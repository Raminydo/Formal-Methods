mtype = { MECHANICAL, BUTTON, VOICE, LEFT, RIGHT, ON, OFF, SAME, ISOLATED }
chan controller = [0] of { mtype, mtype };
chan signal = [0] of { mtype, mtype, mtype };
active proctype Car() {
    mtype method;
    mtype direction;
    mtype state;
    
    do
    :: controller ? method, direction ->
        if
        :: method == MECHANICAL ->
            printf("Using mechanical handle for %e indicator\n", direction)
        :: method == BUTTON ->
            printf("Using button for %e indicator\n", direction)
        :: method == VOICE ->
            printf("Using voice command for %e indicator\n", direction)
        fi;
        
        state = ON;
        signal ! method, direction, state
    od
}
active proctype IndicatorController() {
    mtype method;
    mtype direction;
    mtype state;
    mtype color_scheme = SAME;
    mtype sound_scheme = SAME;
    do
    :: signal ? method, direction, state ->
        if
        :: direction == LEFT ->
            printf("LEFT indicator is %e\n", state)
        :: direction == RIGHT ->
            printf("RIGHT indicator is %e\n", state)
        fi;
        if
        :: color_scheme == SAME ->
            printf("All indicators use the same color\n")
        :: color_scheme == ISOLATED ->
            if
            :: direction == LEFT ->
                printf("LEFT indicator uses isolated color\n")
            :: direction == RIGHT ->
                printf("RIGHT indicator uses isolated color\n")
            fi
        fi;
        if
        :: sound_scheme == SAME ->
            printf("All indicators use the same sound\n")
        :: sound_scheme == ISOLATED ->
            if
            :: direction == LEFT ->
                printf("LEFT indicator uses isolated sound\n")
            :: direction == RIGHT ->
                printf("RIGHT indicator uses isolated sound\n")
            fi
        fi
    od
}
init {
    run Car();
    run IndicatorController();
    controller ! MECHANICAL, LEFT;
    controller ! BUTTON, RIGHT;
    controller ! VOICE, LEFT;
}
