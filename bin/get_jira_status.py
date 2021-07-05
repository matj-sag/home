#!/usr/bin/env python3

import sys, os, jira

if len(sys.argv) < 3:
        print("Usage: %s <itrac jsessionid> <itrac item>" % sys.argv[0])
        sys.exit(1)

jsessionid=sys.argv[1]
itracid=sys.argv[2]

c=0
while True:
        try:
                itrac = jira.JIRA("https://itrac.eur.ad.sag", options={'headers':{'Cookie':'JSESSIONID='+jsessionid}, 'verify':False}, max_retries=1)
                issue = itrac.issue(itracid)
        except:
                c = c + 1
                if c > 20:
                        print("Unknown")
                        sys.exit(1)
                continue
        break
print(issue.fields.status)
