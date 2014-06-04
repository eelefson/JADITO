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

for player in players: 
    print ""
    print "Player: %s" % player['uid']
    print "\tNumber of page loads (visits): %d" % len(player['pageloads'])
    print "\tNumber of levels played: %d" % len(player['levels'])
    
    levels = player['levels']
    days = ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY"]
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
                print "\t\tDay Of The Week: %s" % days[day / 6]		
		
        print "\t\tLevel/'Quest' id: %s (%s)" % (level['qid'], datetime.fromtimestamp(level['log_q_ts']))
        print "\t\tLevel Start Event Detail %s" % level['q_detail']
        if level['quest_end'] is not None: 
            print "\t\tLevel End Event Detail %s\n" % level['quest_end']['q_detail']
       
        #actions = level['actions']
        #for action in actions:
        #    print "\t\t\tAID: %s, Timestamp: %s, Action details: %s" % (action['aid'], action['ts'], action['a_detail'])