# Template that you should use for your analysis script. This script loads the JSON data into a players object
# and loops over the player

import json, sys
from datetime import datetime

if len(sys.argv) < 2:
    print "enter json file"
    sys.exit(0)
    
f = open(sys.argv[1]);
players = json.loads(f.read())

print "Number of players: %d" % len(players) 
playthroughs = 0.0
minigames = 0
text = ""
num_players = 0
for player in players: 
    
    levels = player['levels']
    days = ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY"]
    previous_seq = 0
    for level in levels:
			
        detail = level['q_detail']
        difficultyIndex = int(detail.index("difficulty"))
        valueIndex = difficultyIndex + 12
        value = detail[valueIndex:valueIndex+1]
        index = detail.find("sequence")
        if index != -1:
            if level['qid'] == 1:
                sequenceIndex = int(detail.index("sequence"))
                value2Index = sequenceIndex + 14
                value2 = detail[value2Index:value2Index+2]			
            else:
                sequenceIndex = int(detail.index("sequence"))
                value2Index = sequenceIndex + 17
                value2 = detail[value2Index:value2Index+2]	

            day_str1 = value2.replace(",", "")
            day_str2 = day_str1.replace("}", "")
            day = int(day_str2)
            if day % 6 == 0 and day <= 30:
                if day == 0:
                    if previous_seq > 0:
                        playthroughs += 1
                        minigames += previous_seq
                        previous_seq = 0
            previous_seq = day
    if previous_seq > 0:
        num_players += 1
        playthroughs += 1
        minigames += previous_seq
        previous_seq = 0

print str(minigames / playthroughs)
#print str(playthroughs/num_players)