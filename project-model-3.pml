mtype = {mechanical, digital, voice};
chan turnSignal = [0] of {mtype, bool};
active proctype MechanicalHandle() {
    bool state = false; // false is off, true is on
    do
    :: atomic {
        turnSignal ! mechanical, state;
        state = !state; // toggle state
        printf("Mechanical handle state: %d\n", state);
    }
    od
}
active proctype DigitalButton() {
    bool state = false;
    do
    :: atomic {
        turnSignal ! digital, state;
        state = !state; // simulate accidental press and toggle
        printf("Digital button state: %d\n", state);
    }
    od
}
active proctype VoiceAssistant() {
    bool state = false;
    bool misunderstanding = false;
    do
    :: atomic {
        if
        :: misunderstanding -> misunderstanding = false; // reset misunderstanding
        :: else -> turnSignal ! voice, state; state = !state;
        fi
        printf("Voice assistant state: %d, misunderstanding: %d\n", state, misunderstanding);
    }
    od
}
init {
    run MechanicalHandle();
    run DigitalButton();
    run VoiceAssistant();
}
