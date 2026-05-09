/* Colors defined once — all blocks use these */
#define FG "#cdd6f4"
#define BG "#1e1e2e"

static const Block blocks[] = {
    /*Icon*/  /*Command*/                                                                                                                                                                                         /*Interval*/  /*Signal*/

    /* Memory */
    { "", "echo \"^c" FG "^^b" BG "^  $(free -h | awk '/^Mem/{print $3\"/\"$2}' | sed 's/i//g') ^d^\"",                                                                                                         1,            0 },

    /* Disk */
    { "", "echo \"^c" FG "^^b" BG "^  $(df -h / | awk 'NR==2{print $3\"/\"$2}') ^d^\"",                                                                                                                         60,           0 },

    /* Battery — fully inlined, shows Charging / Discharging / Full */
    { "", "[ -d /sys/class/power_supply/BAT0 ] && echo \"^c" FG "^^b" BG "^  BAT $(cat /sys/class/power_supply/BAT0/capacity)% [$(cat /sys/class/power_supply/BAT0/status)] ^d^\"",                             10,           0 },

    /* Date */
    { "", "echo \"^c" FG "^^b" BG "^  $(date '+%b %d (%a) %I:%M:%S%p') ^d^\"",                                                                                                                                  1,            0 },
};

/* No delimiter — each block handles its own spacing */
static char delim[] = "";
static unsigned int delimLen = 0;
