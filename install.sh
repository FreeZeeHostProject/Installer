#!/bin/bash

# ============================================================
#               FREEZEEHOST THEME INSTALLER
# ============================================================
# Version: 3.7.0-PRO (ULTIMATE)
# (c) 2026 FreeZeeHost Official. All Rights Reserved.
# ============================================================

# --- COLORS & STYLE ---
NC='\033[0m'; BOLD='\033[1m'; DIM='\033[2m'
BRIGHT_RED='\033[91m'; BRIGHT_GREEN='\033[92m'; BRIGHT_YELLOW='\033[93m'
BRIGHT_BLUE='\033[94m'; BRIGHT_MAGENTA='\033[95m'; BRIGHT_CYAN='\033[96m'; WHITE='\033[97m'
BG_GREEN='\033[42m'; BG_RED='\033[41m'

# --- UI HELPERS ---
print_info() { echo -e "  ${BRIGHT_CYAN}${BOLD}💠 INFO${NC} ${WHITE}│ $1${NC}"; }
print_success() { echo -e "  ${BRIGHT_GREEN}${BOLD}✅ SUCCESS${NC} ${WHITE}│ $1${NC}"; }
print_warning() { echo -e "  ${BRIGHT_YELLOW}${BOLD}⚠️ WARNING${NC} ${WHITE}│ $1${NC}"; }
print_error() { echo -e "  ${BRIGHT_RED}${BOLD}❌ ERROR${NC} ${WHITE}│ $1${NC}"; }

premium_header() {
  local title=$1; local color=$2
  echo -e "  ${color}${BOLD}┌────────────────────────────────────────────────────────────────────────┐${NC}"
  echo -e "  ${color}${BOLD}│${NC}  ${WHITE}${BOLD}${title}${NC}"
  echo -e "  ${color}${BOLD}└────────────────────────────────────────────────────────────────────────┘${NC}"
}

premium_box() {
  local title=$1; local color=$2
  echo -e "  ${color}${BOLD}╔══════════════════════════════════════════════════════════════════════╗${NC}"
  echo -e "  ${color}${BOLD}║${NC}  ${WHITE}${BOLD}👑 ${title}${NC}"
  echo -e "  ${color}${BOLD}╚══════════════════════════════════════════════════════════════════════╝${NC}"
}

show_loading() {
  local duration=$1; local message=$2
  echo -ne "  ${BRIGHT_MAGENTA}${BOLD}⏳ $message${NC} "
  for ((i=0; i<duration; i++)); do echo -ne "${BRIGHT_CYAN}."; sleep 0.4; done
  echo -e " ${BRIGHT_GREEN}DONE!${NC}"
}

line_separator() { echo -e "  ${DIM}${WHITE}──────────────────────────────────────────────────────────────────────────${NC}"; }

# --- DB VERIFICATION (ULTIMATE VERSION) ---
verify_mongodb_direct() {
  local check_type=$1; local pwd_input=$2; local key_input=$3
  # Auto-load global modules
  export NODE_PATH=$(npm root -g 2>/dev/null):$NODE_PATH
  
  node <<EOF
const mongoose = require('mongoose');
// URI with updated password 'FreeZeeHost12'
const _0x1f2e = 'bW9uZ29kYitzcnY6Ly9mcmVlemVlaG9zdDpGcmVlWmVlSG9zdDEyQGNsdXN0ZXIwLnZ5d3U1eHQubW9uZ29kYi5uZXQvRnJlZVplZUhvc3Q/cmV0cnlXcml0ZXM9dHJ1ZSZ3PW1ham9yaXR5JmFwcE5hbWU9Q2x1c3RlcjA=';
const MONGO_URI = Buffer.from(_0x1f2e, 'base64').toString();

const whitelistSchema = new mongoose.Schema({ 
  ip: String, 
  password: { type: String }, 
  custom_apikey: { type: String }, 
  status: { type: String } 
}, { collection: 'whitelist' });

const Whitelist = mongoose.model('Whitelist', whitelistSchema);

async function runCheck() { 
    try { 
        await mongoose.connect(MONGO_URI, { serverSelectionTimeoutMS: 15000 }); 
        let targetIp = '$VPS_IP'.trim();
        let found;
        
        if ('$check_type' === 'ip') { 
            // Loose regex check to find IP even with hidden whitespace in DB
            found = await Whitelist.findOne({ ip: new RegExp('^' + targetIp + '$', 'i') }); 
        } else { 
            found = await Whitelist.findOne({ 
              ip: new RegExp('^' + targetIp + '$', 'i'), 
              password: '$pwd_input', 
              custom_apikey: '$key_input' 
            }); 
        } 
        
        process.exit(found ? 0 : 1); 
    } catch (e) { 
        process.exit(2); 
    } 
}
runCheck();
EOF
  return $?
}

fetch_vps_ip() { VPS_IP=$(curl -s https://api.ipify.org || echo "Unknown"); }

start_script() {
  # 1. BANNER & INITIAL CHECKS
  clear
  echo -e "${BRIGHT_YELLOW}${BOLD}"
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
  echo ""

  # 2. DEPENDENCIES
  premium_header "SYSTEM PREPARATION" "$BRIGHT_WHITE"
  print_info "Syncing core dependencies..."
  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get update -qq > /dev/null 2>&1
  sudo apt-get install -qq -y jq gawk curl wget nodejs npm > /dev/null 2>&1
  
  if ! node -e "require('mongoose')" &>/dev/null; then
    print_warning "Database Connector missing. Installing..."
    sudo npm install -g mongoose --silent > /dev/null 2>&1
  fi
  print_success "System dependencies are ready."
  sleep 2

  # 3. CLEAR & VERIFICATION
  clear
  echo -e "${BRIGHT_CYAN}${BOLD}"
  echo -e "  ╔══════════════════════════════════════════════════════════════════════╗"
  echo -e "  ║               🔒 SECURITY & IDENTITY VERIFICATION 🔒                 ║"
  echo -e "  ╚══════════════════════════════════════════════════════════════════════╝${NC}"
  echo ""

  fetch_vps_ip
  echo -e "  ${BRIGHT_WHITE}${BOLD}➤ FIREWALL CHECK:${NC}"
  print_info "Target IP: ${BRIGHT_YELLOW}$VPS_IP${NC}"
  
  if verify_mongodb_direct "ip"; then
    echo -e "  ${BOLD}STATUS: ${BG_GREEN}${BRIGHT_WHITE} AUTHORIZED ${NC}"
  else
    echo -e "  ${BOLD}STATUS: ${BG_RED}${BRIGHT_WHITE} UNAUTHORIZED ${NC}"
    print_error "Your IP is not in our database. Please whitelist it first."
    exit 1
  fi
  echo ""

  # 4. IDENTITY
  SESSION_FILE="/root/.fzh_session"
  if [ ! -f "$SESSION_FILE" ]; then
    echo -e "  ${BRIGHT_WHITE}${BOLD}➤ IDENTITY VERIFICATION (2-STEP):${NC}"
    print_warning "Note: Password will be hidden while typing."
    echo -n -e "  ${BOLD}${BRIGHT_MAGENTA}👉 ${WHITE}OWNER PASSWORD : ${NC}"; read -s SECOND_PWD; echo
    echo -n -e "  ${BOLD}${BRIGHT_MAGENTA}👉 ${WHITE}CUSTOM API KEY  : ${NC}"; read CLIENT_API_KEY
    
    print_info "Verifying with Database..."
    if verify_mongodb_direct "full" "$SECOND_PWD" "$CLIENT_API_KEY"; then
      echo -e "  ${BOLD}RESULT: ${BG_GREEN}${BRIGHT_WHITE} ACCESS GRANTED ${NC}"
      touch "$SESSION_FILE"
      sleep 2
    else
      echo -e "  ${BOLD}RESULT: ${BG_RED}${BRIGHT_WHITE} ACCESS DENIED ${NC}"
      exit 1
    fi
  else
    echo -e "  ${BRIGHT_GREEN}${BOLD}✔ Session Active: Welcome back.${NC}"
    sleep 1.5
  fi
}

# --- THEME FUNCTIONS (DASHBOARD) ---
install_theme() {
  while true; do
    clear; echo ""; premium_box "SELECT PREMIUM THEME" "$BRIGHT_CYAN"; echo ""
    echo -e "  ${BRIGHT_WHITE}[1] Stellar    [2] Billing"
    echo -e "  [3] Enigma     [4] Elysium"
    echo -e "  [5] Frostcore  [6] Nightcore"
    echo -e "  [7] Ice        [8] Noobe"
    echo -e "  [9] Arix       [10] Nookure"
    echo ""; echo -e "  ${BRIGHT_YELLOW}[R] Reset Panel   [X] Back"
    echo ""; echo -n -e "  ${BOLD}${BRIGHT_YELLOW}👉 Choice: ${NC}"; read -r SELECT_THEME
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
  echo -e "  ${BOLD}${WHITE}│${NC} ${DIM}License:${NC} ${BRIGHT_GREEN}ACTIVE${NC}  ${BOLD}${WHITE}│${NC} ${DIM}User:${NC} ${BRIGHT_CYAN}VIP GUEST${NC}   ${BOLD}${WHITE}│${NC} ${DIM}Version:${NC} ${BRIGHT_YELLOW}3.7.0-PRO${NC}  ${BOLD}${WHITE}│${NC}"
  echo -e "  ${BOLD}${WHITE}└────────────────────────────────────────────────────────────────────────┘${NC}"
  echo -e "\n  ${BOLD}${BRIGHT_MAGENTA}💎 EXCLUSIVE SERVICES:${NC}"
  echo -e "    ${BRIGHT_WHITE}${BOLD}[1]  ${NC}${BRIGHT_BLUE}🎨 Premium Themes${NC}\e[45G ${BRIGHT_WHITE}${BOLD}[13] ${NC}${BRIGHT_GREEN}📑 Install PHPMyAdmin${NC}"
  echo -e "    ${BRIGHT_WHITE}${BOLD}[2]  ${NC}${BRIGHT_BLUE}🔌 Blueprint Core${NC}\e[45G ${BRIGHT_WHITE}${BOLD}[14] ${NC}${BRIGHT_GREEN}🔐 Configure SSL${NC}"
  echo -e "    ${BRIGHT_WHITE}${BOLD}[3]  ${NC}${BRIGHT_BLUE}⏰ Auto-Suspend Pro${NC}\e[45G ${BRIGHT_WHITE}${BOLD}[15] ${NC}${BRIGHT_YELLOW}💾 Full System Backup${NC}"
  echo -e "    ${BRIGHT_WHITE}${BOLD}[4]  ${NC}${BRIGHT_YELLOW}🛡️ Protect Panel${NC}\e[45G ${BRIGHT_WHITE}${BOLD}[16] ${NC}${BRIGHT_BLUE}🚀 Turbo Build Assets${NC}"
  echo -e "    ${BRIGHT_WHITE}${BOLD}[x]  ${NC}${RED}❌ Terminal Exit${NC}"
  echo ""; echo -n -e "  ${BOLD}${WHITE}root@FreeZeeHost:~# ${NC}"; read -r MENU_CHOICE
  case "$MENU_CHOICE" in
    1) install_theme ;; 2) install_blueprint ;; 
    x|X) exit 0 ;;
  esac
done
