#!/usr/bin/env python3
"""Index Claude Code sessions across every machine the user works on.

Transcripts are per-machine: each host keeps its own ~/.claude/projects and none
of them can see the others. Reads local and remote alike and prints one line per
session, newest first:

    YYYY-MM-DD  <host>  <project>  <KB>  <opening prompt>

Usage: scan-sessions.py [--days N] [--host NAME ...]
A host that cannot be reached is reported on stderr, never skipped silently —
the devpod is often stopped, and a missing machine means a missing slice of the
picture, not an absence of work.
"""
import argparse, json, os, subprocess, sys, time

# Each host keeps a separate store. looter's home is shared across the wider
# machine estate, so it covers all of those in one read.
HOSTS = {
    "local":  None,
    "devpod": "devcont-matj-debian13.devpod",
    "looter": "looter.apama.com",
}

SCAN = r'''
import json,glob,os,sys
cut=float(sys.argv[1])
for f in glob.glob(os.path.expanduser("~/.claude/projects/*/*.jsonl")):
    try: mt=os.path.getmtime(f)
    except OSError: continue
    if mt<cut: continue
    first=""
    try:
        with open(f,errors="replace") as fh:
            for line in fh:
                try: d=json.loads(line)
                except Exception: continue
                if d.get("type")!="user": continue
                c=(d.get("message") or {}).get("content")
                if isinstance(c,str): first=c
                elif isinstance(c,list):
                    for p in c:
                        if p.get("type")=="text": first=p.get("text",""); break
                if first and not first.lstrip().startswith("<"): break
                first=""
    except Exception: continue
    if not first: continue
    print(json.dumps({"mtime":mt,"project":os.path.basename(os.path.dirname(f)),
                      "kb":round(os.path.getsize(f)/1024),
                      "first":" ".join(first.split())[:200]}))
'''

def scan(host, target, cut):
    # The scan program goes over stdin, never on the command line: quoting it
    # into a remote shell mangles the newlines and it dies with a SyntaxError.
    if target:
        # BatchMode so a missing key fails fast instead of prompting; the devpod's
        # ssh wrapper writes kubernetes warnings to stderr, which we discard.
        argv = ["ssh", "-o", "BatchMode=yes", "-o", "ConnectTimeout=20", target,
                f"python3 - {cut}"]
    else:
        argv = ["python3", "-", str(cut)]
    try:
        r = subprocess.run(argv, input=SCAN, capture_output=True, text=True, timeout=120)
    except subprocess.TimeoutExpired:
        print(f"!! {host}: timed out", file=sys.stderr); return []
    if r.returncode != 0:
        why = (r.stderr or "").strip().splitlines()
        why = why[-1] if why else f"exit {r.returncode}"
        print(f"!! {host}: unreachable ({why})", file=sys.stderr); return []
    out = []
    for line in r.stdout.splitlines():
        try: d = json.loads(line)
        except Exception: continue
        d["host"] = host; out.append(d)
    return out

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--days", type=int, default=30)
    ap.add_argument("--host", action="append", choices=list(HOSTS))
    a = ap.parse_args()
    cut = time.time() - a.days * 86400
    rows = []
    for h in (a.host or list(HOSTS)):
        rows += scan(h, HOSTS[h], cut)
    for d in sorted(rows, key=lambda x: -x["mtime"]):
        day = time.strftime("%Y-%m-%d", time.localtime(d["mtime"]))
        proj = d["project"].replace("-home-matj-work-", "").replace("-workspaces-", "") \
                           .replace("-work-mjj29-", "").replace("-home-matj", "~") or "~"
        print(f'{day}  {d["host"]:6}  {proj[:26]:26} {d["kb"]:5}K  {d["first"][:100]}')
    if not rows: print("(no sessions found)")

main()
