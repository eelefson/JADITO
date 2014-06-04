# Template that you should use for your analysis script. This script loads the JSON data into a players object
# and loops over the player

import json, sys
from datetime import datetime

if len(sys.argv) < 2:
    print "enter json file"
    sys.exit(0)
    
f = open(sys.argv[1]);
players = json.loads(f.read())

max = 1306
text = ""
for counter in range(max, 0, -1):
    num_in_bucket = 0;
    inactivity_limit = 30000
    for player in players:
        levels = player['levels']
        totalActiveTime = 0
        for level in levels:
             if level["dqid"] is not None:
                  actions = level["actions"]
                  activeTime = 0
                  lastTimeStamp = 0
                  currentTimeStamp = -1

                  for action in actions:
                       currentTimeStamp = action["ts"]
                       difference = currentTimeStamp - lastTimeStamp
                       if difference > inactivity_limit:
                            difference = inactivity_limit
                       activeTime = activeTime + difference				
                       lastTimeStamp = currentTimeStamp
	
                  totalActiveTime = totalActiveTime + activeTime

        time = totalActiveTime/1000
        if time >= counter:
            num_in_bucket += 1
    text += str(num_in_bucket) + "\t"
print text