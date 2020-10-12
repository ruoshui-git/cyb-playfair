#!/usr/bin/env bash

# Format: ( +"command|expected")
cases=()
passed=()

# Format: (+"command|expected|received")
failed=()

function reset() {
    cases=()
    passed=()
    failed=()
}

# Use some COLORS!
# https://stackoverflow.com/questions/4332478/read-the-current-text-color-in-a-xterm/4332530#4332530
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
LIME_YELLOW=$(tput setaf 190)
POWDER_BLUE=$(tput setaf 153)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)
BLINK=$(tput blink)
REVERSE=$(tput smso)
UNDERLINE=$(tput smul)

function puts_color() {
    printf "$2$1${NORMAL}"
}

# print "ok" with color, no endline
function puts_ok() {
    puts_color ok ${GREEN}
    # printf "${GREEN}ok${NORMAL}"
}

# print "fail" with red, no endline
function puts_fail() {
    puts_color FAILED ${RED}
    # printf "${RED}failed${NORMAL}"
}

function t() {
    cases+=("$1|$2")
}

function test_one() {
    # split test test string into command and expected output
    IFS='|' read -r -a parts <<< "$1"
    local arg=${parts[0]}
    local run="$(make_command "$arg")"
    local expected="${parts[1]}"

    # hit the user that we are making progress
    printf "case: \"$arg\"... "

    # run command and capture last line, suppress stdout (cargo prints a lot to stdout)
    local received="$(eval $run 2> /dev/null | tail -1)"

    if [ "$received" = "$expected" ]; then
        passed+=("$1") 
        puts_ok; echo;
    else 
        failed+=("$1|$received")
        puts_fail; echo;
    fi
}

function print_sep() {
    # we need eval b/c sequence expansion happens before variable evaluation
    eval printf "$1%.0s" {1..$2}
    echo
}

function print_fail_case() {
    # split fail string into parts
    IFS='|' read -r -a parts <<< "$1"
    local args=${parts[0]}
    local expected=${parts[1]}
    local received=${parts[2]}

    print_sep = 50

    local run=$(make_command "$args")
    echo "command: $run"
    echo "expected: $expected"
    echo "received: $received"
}


function run_all() {
    local ncases="${#cases[@]}"

    echo "  Testing $ncases cases...";

    print_sep = 100

    for tcase in "${cases[@]}"; do 
        test_one "$tcase"
    done

    local npassed="${#passed[@]}"
    local nfailed="${#failed[@]}"

    print_sep = 100
    
    if [ $nfailed -ne 0 ]; then
        puts_color FAILURES: ${RED}; echo;

        for failed in "${failed[@]}"; do
            print_fail_case "$failed"
        done
    fi 

    echo
    print_sep = 50

    printf "test result: " 
    if [ $nfailed -eq 0 ]; then
        puts_ok
    else
        puts_fail
    fi
    echo "; $npassed passed; $nfailed failed"
}

# --------------------------------------------

# define how to make a command
# $1 is the first parameter, which is the test case passed in (first arg of t())
function make_command() {
    printf "make run ARGS=\"$1\"" # make_command "decode 1" -> echo "make run ARGS=decode 1"
}


# test cases here
# t args_to_make expected_value
reset
t "encode Dragonball ABCDEFGHIKLMNOPQRSTUVWXYZ" BTBFTSGFNVPV
t "decode BTBFTSGFNVPV ABCDEFGHIKLMNOPQRSTUVWXYZ" DRAGONBALXLZ
t "encode WHITEHAT PLAYFIREXMBCDGHKNOQSTUVWZ" ZGRUMDPV
t "decode ZGRUMDPV PLAYFIREXMBCDGHKNOQSTUVWZ" WHITEHAT
t "encode AGOODFOODBOOKISACOOKBOOK PLAYFIREXMBCDGHKNOQSTUVWZ" YDQEQGASQGDKVTMKLDQEVTDKVT
t "decode YDQEQGASQGDKVTMKLDQEVTDKVT PLAYFIREXMBCDGHKNOQSTUVWZ" AGOXODFOODBOOKISACOXOKBOOK
t "encode TODAYISAGOODDAYTODIE OZAKDIREXMBCVGHYNPQSTUFWL" UZMENRPDBKIMMENUIMBV
t "decode UZMENRPDBKIMMENUIMBV OZAKDIREXMBCVGHYNPQSTUFWL" TODAYISAGOODDAYTODIE
run_all
echo
reset
echo J cases:
t "encode IAMJUSTJAMMINJELLY ERTYUIOPASDFGQWHKLZXCVBNM" DQCSEIEPSNCSCATHZT
t "decode DQCSEIEPSNCSCATHZT ERTYUIOPASDFGQWHKLZXCVBNM" IAMIUSTIAMMINIELLY
t "encode JIMJAMESJACK QWERTYUIOPASDFGHKLZXCVBNM" PLPBYDBTDUSVVN
t "decode PLPBYDBTDUSVVN QWERTYUIOPASDFGHKLZXCVBNM" IXIMIAMESIACKZ
run_all