mtype = { right_indicator, left_indicator, none };
// Indicator states
bool rightOn = false;
bool leftOn = false;
// Simulation of driver's internal indicators
active proctype InternalIndicators() {
    do
    :: atomic {
        rightOn = true;
        leftOn = false;
        printf("Magenta right indicator light inside, double beep sound.\n");
        break;
    }
    :: atomic {
        leftOn = true;
        rightOn = false;
        printf("Green left indicator light inside, single beep sound.\n");
        break;
    }
    od
}
// Simulation of external indicators for other drivers
active proctype ExternalIndicators() {
    do
    :: atomic {
        if
        :: rightOn -> printf("External right indicator blinking orange.\n");
        :: leftOn -> printf("External left indicator blinking orange.\n");
        fi;
        break;
    }
    od
}
// Liveness property: Ensure indicators are not on simultaneously
ltl no_conflict { [] !(rightOn && leftOn) }
