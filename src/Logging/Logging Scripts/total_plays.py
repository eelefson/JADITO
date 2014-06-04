# Template that you should use for your analysis script. This script loads the JSON data into a players object
# and loops over the player

import json, sys
from datetime import datetime

if len(sys.argv) < 2:
    print "enter json file"
    sys.exit(0)
    
f = open(sys.argv[1]);
players = json.loads(f.read())

max = 261
text = ""
for counter in range(max, 0, -1):
    num_in_bucket = 0;
    for player in players:
        if len(player['levels']) >= counter:
            num_in_bucket += 1
    #print "%d people played at least %d levels" % (num_in_bucket, counter)
    text += str(num_in_bucket) + "\t"
print text
#TO GET MAX NUMBER OF LEVELS PLAYED BY ANY ONE PLAYER
#max = 0
#for player in players:
#    if max < len(player['levels']):
#        max = len(player['levels'])
#print "\tMax number of levels played: %d" % max