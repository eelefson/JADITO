# Template that you should use for your analysis script. This script loads the JSON data into a players object
# and loops over the player

import json, sys
from datetime import datetime

if len(sys.argv) < 2:
    print "enter json file"
    sys.exit(0)
    
f = open(sys.argv[1]);
players = json.loads(f.read())

MDAP_0_success = 0
MDAP_0_failure = 0

MDAP_1_success = 0
MDAP_1_failure = 0

MDAP_2_success = 0
MDAP_2_failure = 0

MDAP_3_success = 0
MDAP_3_failure = 0

for player in players: 
    levels = player['levels']
    for level in levels:
        if level['quest_end'] is not None:
		    # CHANGE THIS TO GET DIFFERENT GAMES
            if level['qid'] == 8:
                detail = level['q_detail']
                difficultyIndex = int(detail.index("difficulty"))
                valueIndex = difficultyIndex + 12
                value = detail[valueIndex:valueIndex+1]
                if value == "0":
                    if level['quest_end']['q_detail'] == "{\"completed\":\"success\"}":
                        MDAP_0_success += 1;
                    else:
                        MDAP_0_failure += 1;
                elif value == "1":
                    if level['quest_end']['q_detail'] == "{\"completed\":\"success\"}":
                        MDAP_1_success += 1;
                    else:
                        MDAP_1_failure += 1;				    
                elif value == "2":
                    if level['quest_end']['q_detail'] == "{\"completed\":\"success\"}":
                        MDAP_2_success += 1;
                    else:
                        MDAP_2_failure += 1;				    
                elif value == "3":
                    if level['quest_end']['q_detail'] == "{\"completed\":\"success\"}":
                        MDAP_3_success += 1;
                    else:
                        MDAP_3_failure += 1;
						
print "Level 0 Success: %d" % MDAP_0_success
print "Level 0 Failure: %d" % MDAP_0_failure
print ""
print "Level 1 Success: %d" % MDAP_1_success
print "Level 1 Failure: %d" % MDAP_1_failure
print ""
print "Level 2 Success: %d" % MDAP_2_success
print "Level 2 Failure: %d" % MDAP_2_failure
print ""
print "Level 3 Success: %d" % MDAP_3_success
print "Level 3 Failure: %d" % MDAP_3_failure
