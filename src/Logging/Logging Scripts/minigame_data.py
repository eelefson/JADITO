# Template that you should use for your analysis script. This script loads the JSON data into a players object
# and loops over the player

import json, sys
from datetime import datetime

if len(sys.argv) < 2:
    print "enter json file"
    sys.exit(0)
    
f = open(sys.argv[1]);
players = json.loads(f.read())

AvoidCoworker_success = 0
Brainstormer_success = 0
CatchPencil_success = 0
CoffeeRun_success = 0
ColdCaller_success = 0
DictatorDictation_success = 0
InOut_success = 0
MDAP_success = 0
PickUpPapers_success = 0
SignPapers_success = 0
SpeedyStapler_success = 0
Spellchecker_success = 0
TimeClock_success = 0
WaterBreak_success = 0

AvoidCoworker_failure = 0
Brainstormer_failure = 0
CatchPencil_failure = 0
CoffeeRun_failure = 0
ColdCaller_failure = 0
DictatorDictation_failure = 0
InOut_failure = 0
MDAP_failure = 0
PickUpPapers_failure = 0
SignPapers_failure = 0
SpeedyStapler_failure = 0
Spellchecker_failure = 0
TimeClock_failure = 0
WaterBreak_failure = 0

for player in players: 
    levels = player['levels']
    for level in levels:
        if level['quest_end'] is not None:
			if level['qid'] == 1:
				if level['quest_end']['q_detail'] == "{\"completed\":\"success\"}":
					AvoidCoworker_success += 1;
				else:
					AvoidCoworker_failure += 1;
			elif level['qid'] == 2:
				if level['quest_end']['q_detail'] == "{\"completed\":\"success\"}":
					Brainstormer_success += 1;
				else:
					Brainstormer_failure += 1;	
			elif level['qid'] == 3:
				if level['quest_end']['q_detail'] == "{\"completed\":\"success\"}":
					CatchPencil_success += 1;
				else:
					CatchPencil_failure += 1;	
			elif level['qid'] == 4:
				if level['quest_end']['q_detail'] == "{\"completed\":\"success\"}":
					CoffeeRun_success += 1;
				else:
					CoffeeRun_failure += 1;		
			elif level['qid'] == 5:
				if level['quest_end']['q_detail'] == "{\"completed\":\"success\"}":
					ColdCaller_success += 1;
				else:
					ColdCaller_failure += 1;		
			elif level['qid'] == 6:
				if level['quest_end']['q_detail'] == "{\"completed\":\"success\"}":
					DictatorDictation_success += 1;
				else:
					DictatorDictation_failure += 1;
			elif level['qid'] == 7:
				if level['quest_end']['q_detail'] == "{\"completed\":\"success\"}":
					InOut_success += 1;
				else:
					InOut_failure += 1;						
			elif level['qid'] == 8:
				if level['quest_end']['q_detail'] == "{\"completed\":\"success\"}":
					MDAP_success += 1;
				else:
					MDAP_failure += 1;	
			elif level['qid'] == 9:
				if level['quest_end']['q_detail'] == "{\"completed\":\"success\"}":
					PickUpPapers_success += 1;
				else:
					PickUpPapers_failure += 1;		
			elif level['qid'] == 10:
				if level['quest_end']['q_detail'] == "{\"completed\":\"success\"}":
					SignPapers_success += 1;
				else:
					SignPapers_failure += 1;		
			elif level['qid'] == 11:
				if level['quest_end']['q_detail'] == "{\"completed\":\"success\"}":
					SpeedyStapler_success += 1;
				else:
					SpeedyStapler_failure += 1;		
			elif level['qid'] == 12:
				if level['quest_end']['q_detail'] == "{\"completed\":\"success\"}":
					Spellchecker_success += 1;
				else:
					Spellchecker_failure += 1;		
			elif level['qid'] == 13:
				if level['quest_end']['q_detail'] == "{\"completed\":\"success\"}":
					TimeClock_success += 1;
				else:
					TimeClock_failure += 1;		
			elif level['qid'] == 14:
				if level['quest_end']['q_detail'] == "{\"completed\":\"success\"}":
					WaterBreak_success += 1;
				else:
					WaterBreak_failure += 1;
				
print "AvoidCoworker_success: %d" % AvoidCoworker_success
print "AvoidCoworker_failure: %d" % AvoidCoworker_failure
print ""
print "Brainstormer_success: %d" % Brainstormer_success
print "Brainstormer_failure: %d" % Brainstormer_failure
print ""
print "CatchPencil_success: %d" % CatchPencil_success
print "CatchPencil_failure: %d" % CatchPencil_failure
print ""
print "CoffeeRun_success: %d" % CoffeeRun_success
print "CoffeeRun_failure: %d" % CoffeeRun_failure
print ""
print "ColdCaller_success: %d" % ColdCaller_success
print "ColdCaller_failure: %d" % ColdCaller_failure
print ""
print "DictatorDictation_success: %d" % DictatorDictation_success
print "DictatorDictation_failure: %d" % DictatorDictation_failure
print ""
print "InOut_success: %d" % InOut_success
print "InOut_failure: %d" % InOut_failure
print ""
print "MDAP_success: %d" % MDAP_success
print "MDAP_failure: %d" % MDAP_failure
print ""
print "PickUpPapers_success: %d" % PickUpPapers_success
print "PickUpPapers_failure: %d" % PickUpPapers_failure
print ""
print "SignPapers_success: %d" % SignPapers_success
print "SignPapers_failure: %d" % SignPapers_failure
print ""
print "SpeedyStapler_success: %d" % SpeedyStapler_success
print "SpeedyStapler_failure: %d" % SpeedyStapler_failure
print ""
print "Spellchecker_success: %d" % Spellchecker_success
print "Spellchecker_failure: %d" % Spellchecker_failure
print ""
print "TimeClock_success: %d" % TimeClock_success
print "TimeClock_failure: %d" % TimeClock_failure
print ""
print "WaterBreak_success: %d" % WaterBreak_success
print "WaterBreak_failure: %d" % WaterBreak_failure

