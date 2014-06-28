class Event {
  Person[] participants;
  String action;
  int[] affectedstats;
  
  Event(Person[] participants, String action, int[] affectedstats) {
    
  }
}

/*
CAUSE AND EFFECT
Events (Interactions) and Actions
Must cause People to interact with each other.

EVENTS
May be caused by a person (Internal) or the world (External)

Internal:
are caused by increase or decrease in certain stats

eg. INCREASE EXTRAVERSION
result: Joe chats with Sally.
Participants = Joe, Sally
description = "chats with"
action = Joe.extraversion(7) - Sally.agreeableness(4) = 3
if action >= 0, then Joe and Sally ++happiness
else, then Joe and Sally --happiness


*/
