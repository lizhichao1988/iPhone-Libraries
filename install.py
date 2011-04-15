#!/usr/bin/python

import os
user_frameworks_path = '~/Library/Frameworks'
root_frameworks_path = '/Library/Frameworks'

#print user_frameworks_path

e = os.path.expanduser(user_frameworks_path)
print e

if e:
        print "exist user_frameworks_path"
else:
        os.mkdir(user_frameworks_path)
        
