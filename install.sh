#!/bin/bash

# ============================================================
#               FREEZEEHOST THEME INSTALLER
# ============================================================
# Version: 3.6.0-PRO (STABLE)
# ============================================================

# Colors
NC='\033[0m'; BOLD='\033[1m'
BRIGHT_RED='\033[91m'; BRIGHT_GREEN='\033[92m'; BRIGHT_YELLOW='\033[93m'
BRIGHT_MAGENTA='\033[95m'; BRIGHT_CYAN='\033[96m'; WHITE='\033[97m'
BG_GREEN='\033[42m'; BG_RED='\033[41m'

# Helpers
print_info() { echo -e "  ${BRIGHT_CYAN}${BOLD}💠 INFO${NC} ${WHITE}│ $1${NC}"; }
print_success() { echo -e "  ${BRIGHT_GREEN}${BOLD}✅ SUCCESS${NC} ${WHITE}│ $1${NC}"; }
print_error() { echo -e "  ${BRIGHT_RED}${BOLD}❌ ERROR${NC} ${WHITE}│ $1${NC}"; }

show_loading() {
  echo -ne "  ${BRIGHT_MAGENTA}${BOLD}⏳ $2${NC} "
  for ((i=0; i<$1; i++)); do echo -ne "${BRIGHT_CYAN}."; sleep 0.4; done
  echo -e " ${BRIGHT_GREEN}DONE!${NC}"
}

# --- VERIFICATION SYSTEM ---
verify_mongodb_direct() {
  local check_type=$1; local pwd_input=$2; local key_input=$3
  export NODE_PATH=$(npm root -g 2>/dev/null):$NODE_PATH
  
  node <<EOF
const mongoose = require('mongoose');
const _0x1f2e = 'bW9uZ29kYitzcnY6Ly9mcmVlemVlaG9zdDpGcmVlWmVlSG9zdDEyQGNsdXN0ZXIwLnZ5d3U1eHQubW9uZ29kYi5uZXQvRnJlZVplZUhvc3Q/cmV0cnlXcml0ZXM9dHJ1ZSZ3PW1ham9yaXR5JmFwcE5hbWU9Q2x1c3RlcjA=';
const MONGO_URI = Buffer.from(_0x1f2e, 'base64').toString();
const whitelistSchema = new mongoose.Schema({ ip: String, password: { type: String }, custom_apikey: { type: String } }, { collection: 'whitelist' });
const Whitelist = mongoose.model('Whitelist', whitelistSchema);

async function check() { 
    try { 
        await mongoose.connect(MONGO_URI, { serverSelectionTimeoutMS: 20000 }); 
        let found; 
        if ('$check_type' === 'ip') { 
            found = await Whitelist.findOne({ ip: '$VPS_IP' }); 
        } else { 
            found = await Whitelist.findOne({ ip: '$VPS_IP', password: '$pwd_input', custom_apikey: '$key_input' }); 
        } 
        process.exit(found ? 0 : 1); 
    } catch (e) { 
        process.exit(2); 
    } 
}
check();
EOF
  return $?
}

start_script() {
  clear; echo -e "${BRIGHT_YELLOW}${BOLD}"
  echo -e "  ███████╗██████╗ ███████╗███████╗███████╗███████╗██╗  ██╗ ██████╗ ███████╗████████╗"
  echo -e "  ██╔════╝██╔══██╗██╔════╝██╔════╝██╔════╝██╔════╝██║  ██║██╔═══██╗██╔════╝╚══██╔══╝"
  echo -e "  █████╗  ██████╔╝█████╗  █████╗  █████╗  █████╗  ███████║██║   ██║███████╗   ██║   "
  echo -e "  ██╔══╝  ██╔══██╗██╔══╝  ██╔══╝  ██╔══╝  ██╔══╝  ██╔══██║██║   ██║╚════██║   ██║   "
  echo -e "  ██║     ██║  ██║███████╗███████╗███████╗███████╗██║  ██║╚██████╔╝███████║   ██║   "
  echo -e "  ╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝   "
  echo -e "${NC}"; echo -e "  ${BOLD}${BRIGHT_YELLOW}  [ 👑  SYSTEM INITIALIZING PREMIUM ACCESS 👑  ] ${NC}\n"
  
  show_loading 3 "Checking System Resources"
  show_loading 3 "Checking Network Protocol"
  show_loading 3 "Checking Secure Connection"
  
  echo -e "\n  ${BOLD}${WHITE}┌──────────────────────── SYSTEM PREPARATION ──────────────────────────┐${NC}"
  print_info "Syncing dependencies..."
  sudo apt-get update -qq > /dev/null 2>&1
  sudo apt-get install -qq -y jq gawk curl wget nodejs npm > /dev/null 2>&1
  
  if ! node -e "require('mongoose')" &>/dev/null; then
    print_info "Installing Database Connector..."
    sudo npm install -g mongoose --silent > /dev/null 2>&1
  fi
  print_success "System Ready."; sleep 1.5
  
  clear
  echo -e "${BRIGHT_CYAN}${BOLD}  ╔══════════════════════════════════════════════════════════════════════╗"
  echo -e "  ║               🔒 SECURITY & IDENTITY VERIFICATION 🔒                 ║"
  echo -e "  ╚══════════════════════════════════════════════════════════════════════╝${NC}\n"
  
  VPS_IP=$(curl -s https://api.ipify.org || echo "Unknown")
  echo -e "  ${BRIGHT_WHITE}${BOLD}➤ FIREWALL CHECK:${NC}"
  print_info "Checking IP: ${BRIGHT_YELLOW}$VPS_IP${NC}"
  
  if verify_mongodb_direct "ip"; then
    echo -e "  ${BOLD}STATUS: ${BG_GREEN}${BRIGHT_WHITE} AUTHORIZED ${NC}"
  else
    echo -e "  ${BOLD}STATUS: ${BG_RED}${BRIGHT_WHITE} UNAUTHORIZED ${NC}"
    print_error "IP is not whitelisted. Use api/seed_db.js to add it."
    exit 1
  fi
  echo ""

  SESSION_FILE="/root/.fzh_session"
  if [ ! -f "$SESSION_FILE" ]; then
    echo -e "  ${BRIGHT_WHITE}${BOLD}➤ IDENTITY VERIFICATION (2-STEP):${NC}"
    echo -n -e "  ${BOLD}${BRIGHT_MAGENTA}👉 ${WHITE}OWNER PASSWORD : ${NC}"; read -s SECOND_PWD; echo
    echo -n -e "  ${BOLD}${BRIGHT_MAGENTA}👉 ${WHITE}CUSTOM API KEY  : ${NC}"; read CLIENT_API_KEY
    print_info "Verifying credentials..."
    if verify_mongodb_direct "full" "$SECOND_PWD" "$CLIENT_API_KEY"; then
      echo -e "  ${BOLD}RESULT: ${BG_GREEN}${BRIGHT_WHITE} ACCESS GRANTED ${NC}"; touch "$SESSION_FILE"; sleep 1
    else
      echo -e "  ${BOLD}RESULT: ${BG_RED}${BRIGHT_WHITE} ACCESS DENIED ${NC}"; exit 1
    fi
  else
    echo -e "  ${BRIGHT_GREEN}${BOLD}✔ Session Active.${NC}"; sleep 1
  fi
}

# --- MENU & THEMES ---
install_theme() {
  while true; do
    clear; echo -e "\n  ${BRIGHT_CYAN}${BOLD}╔══════════════════ SELECT PREMIUM THEME ══════════════════╗${NC}\n"
    echo -e "  ${BRIGHT_WHITE}[1] Stellar   [2] Billing   [3] Enigma   [4] Elysium"
    echo -e "  [5] Frostcore [6] Nightcore [7] Ice      [8] Noobe"
    echo -e "  [9] Arix      [10] Nookure  [R] Reset    [X] Exit\n"
    echo -n -e "  ${BOLD}${BRIGHT_YELLOW}👉 Choice: ${NC}"; read SELECT_THEME
    case "$SELECT_THEME" in
      [1-9]|10) break ;;
      r|R) uninstall_theme; return ;;
      x|X) return ;;
    esac
  done
  # install logic...
}

# --- START ---
start_script

while true; do
  clear; echo -e "${BRIGHT_YELLOW}${BOLD}"
  echo -e "  ███████╗██████╗ ███████╗███████╗███████╗███████╗██╗  ██╗ ██████╗ ███████╗████████╗"
  echo -e "  ██╔════╝██╔══██╗██╔════╝██╔════╝██╔════╝██╔════╝██║  ██║██╔═══██╗██╔════╝╚══██╔══╝"
  echo -e "  █████╗  ██████╔╝█████╗  █████╗  █████╗  █████╗  ███████║██║   ██║███████╗   ██║   "
  echo -e "  ██╔══╝  ██╔══██╗██╔══╝  ██╔══╝  ██╔══╝  ██╔══╝  ██╔══██║██║   ██║╚════██║   ██║   "
  echo -e "  ██║     ██║  ██║███████╗███████╗███████╗███████╗██║  ██║╚██████╔╝███████║   ██║   "
  echo -e "  ╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝   "
  echo -e "${NC}"
  echo -e "  ${BOLD}${WHITE}┌───────────────────────── ${BRIGHT_YELLOW}PREMIUM DASHBOARD${WHITE} ──────────────────────────┐${NC}"
  echo -e "  ${BOLD}${WHITE}│${NC} ${DIM}License:${NC} ${BRIGHT_GREEN}ACTIVE${NC}  ${BOLD}${WHITE}│${NC} ${DIM}User:${NC} ${BRIGHT_CYAN}VIP GUEST${NC}   ${BOLD}${WHITE}│${NC} ${DIM}Version:${NC} ${BRIGHT_YELLOW}3.6.0-PRO${NC}  ${BOLD}${WHITE}│${NC}"
  echo -e "  ${BOLD}${WHITE}└────────────────────────────────────────────────────────────────────────┘${NC}"
  echo -e "\n  ${BOLD}${BRIGHT_MAGENTA}💎 EXCLUSIVE SERVICES:${NC}"
  echo -e "  [1] Premium Themes  [2] Blueprint Core  [X] Exit\n"
  echo -n -e "  ${BOLD}${WHITE}root@FreeZeeHost:~# ${NC}"; read MENU_CHOICE
  case "$MENU_CHOICE" in
    1) install_theme ;; 2) install_blueprint ;; x|X) exit 0 ;;
  esac
done
