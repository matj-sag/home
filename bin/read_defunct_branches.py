#!/usr/bin/env python

import os, sys

if len(sys.argv) < 2:
	print("Usage: read_defunct_branches.py <file>")
	sys.exit(1)

print("Reading from file %s" % sys.argv[1])

items = {}

def addItem(branch, issue, status, result, committer):
	if not committer: committer="Live"
	c = items.get(committer, [])
	items[committer] = c
	c.append((branch, issue, status, result))

branch = None
result = None
committer = None
with open(sys.argv[1]) as f:
	for l in f:
		if '' == l.strip(): continue
		if 'Retry' in l: continue
		if 'Checking' in l: continue
		if l.startswith('dev'):
			if branch:
				addItem(branch, issue, status, result, committer)
				branch = None
				committer = None
				result = None
			branch = l.split('=')[0].strip()
			issue = l.split('=')[1].split()[0]
			try:
				status = l.split('=')[1].split()[1]
			except:
				status = None
		else:
			try:
				result = l.split('.')[0].strip()
				committer = l.split('=')[1].strip()
			except:
				print(l)
				raise

if branch:
	addItem(branch, issue, status, result, committer)

committers = list(items.keys())
committers.sort()
for committer in committers:
	if committer:
		print('')
		print('Branches for %s' % committer)
		for (branch, issue, status, result) in items[committer]:
			print('%s - %s due to %s %s' % (branch, result, issue, status or ''))
