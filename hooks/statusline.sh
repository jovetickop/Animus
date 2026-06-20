#!/bin/bash
input=$(cat)

session=$(echo "$input" | grep -o '"session_name":"[^"]*"' | head -1 | sed 's/"session_name":"//;s/"//' | cut -c1-20)
[ -z "$session" ] && session=$(echo "$input" | grep -o '"session_id":"[^"]*"' | head -1 | sed 's/"session_id":"//;s/"//' | cut -c1-20)
model=$(echo "$input" | grep -o '"display_name":"[^"]*"' | head -1 | sed 's/"display_name":"//;s/"//')
dir=$(echo "$input" | grep -o '"current_dir":"[^"]*"' | head -1 | sed 's/"current_dir":"//;s/"//')
remaining=$(echo "$input" | grep -o '"remaining_percentage":[0-9]*' | head -1 | sed 's/"remaining_percentage"://')
vim_mode=$(echo "$input" | grep -o '"mode":"[^"]*"' | head -1 | sed 's/"mode":"//;s/"//')

CYAN='\033[36m'; YELLOW='\033[33m'; GREEN='\033[32m'; MAGENTA='\033[35m'; NC='\033[0m'

printf "${CYAN}[%s]${NC} " "$session"
printf "${YELLOW}%s${NC} | " "$model"
printf "%s" "$dir"
[ -n "$remaining" ] && printf " | ${GREEN}Context: %s%%${NC}" "$remaining"
[ -n "$vim_mode" ] && printf " | ${MAGENTA}Vim: %s${NC}" "$vim_mode"
echo ""
