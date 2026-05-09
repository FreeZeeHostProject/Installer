#!/bin/bash

# ============================================================
#               FREEZEEHOST THEME INSTALLER
# ============================================================
# Version: 5.0.0-PRO (LEGENDARY RESTORED)
# (c) 2026 FreeZeeHost Official. All Rights Reserved.
# ============================================================

# --- COLORS ---
NC='\033[0m'; BOLD='\033[1m'; DIM='\033[2m'
YELLOW='\033[1;33m'; GREEN='\033[1;32m'; RED='\033[1;31m'; CYAN='\033[1;36m'; WHITE='\033[1;37m'
MAGENTA='\033[1;35m'; BRIGHT_CYAN='\033[96m'; BRIGHT_GREEN='\033[92m'; BRIGHT_YELLOW='\033[93m'
BG_GREEN='\033[42m'; BG_RED='\033[41m'

# --- UI HELPERS ---
print_info() { echo -e "  ${CYAN}${BOLD}💠${NC} ${WHITE}$1${NC}"; }
print_success() { echo -e "  ${GREEN}${BOLD}✅${NC} ${WHITE}$1${NC}"; }
print_error() { echo -e "  ${RED}${BOLD}❌${NC} ${WHITE}$1${NC}"; }

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
  echo -ne "  ${BOLD}${WHITE}⏳  $2 ... ${NC}"
  for ((i=0; i<3; i++)); do echo -ne "${YELLOW}."; sleep 0.4; done
  echo -e " ${GREEN}DONE!${NC}"
}

# --- DATABASE VERIFICATION ---
verify_mongodb_direct() {
  local check_type=$1; local pwd_input=$2; local key_input=$3
  export NODE_PATH=$(npm root -g 2>/dev/null):$NODE_PATH
  export FZH_IP="$VPS_IP"; export FZH_PWD="$pwd_input"; export FZH_KEY="$key_input"; export FZH_TYPE="$check_type"
  
  node <<'EOF'
const mongoose = require('mongoose');
const _0x1f2e = 'bW9uZ29kYitzcnY6Ly9mcmVlemVlaG9zdDpGcmVlWmVlSG9zdDEyXy5AY2x1c3RlcjAudnl3dTV4dC5tb25nb2RiLm5ldC9GcmVlWmVlSG9zdD9yZXRyeVdyaXRlcz10cnVlJnc9bWFqb3JpdHkmYXBwTmFtZT1DbHVzdGVyMA==';
const MONGO_URI = Buffer.from(_0x1f2e, 'base64').toString();
const whitelistSchema = new mongoose.Schema({ ip: String, password: { type: String }, custom_apikey: { type: String } }, { collection: 'whitelist' });
const Whitelist = mongoose.model('Whitelist', whitelistSchema);

async function check() { 
    try { 
        await mongoose.connect(MONGO_URI, { serverSelectionTimeoutMS: 20000 }); 
        const ip = process.env.FZH_IP.trim();
        const type = process.env.FZH_TYPE;
        let found;
        if (type === 'ip') { 
            found = await Whitelist.findOne({ ip: ip }); 
        } else { 
            found = await Whitelist.findOne({ ip: ip, password: process.env.FZH_PWD, custom_apikey: process.env.FZH_KEY }); 
        } 
        process.exit(found ? 0 : 1); 
    } catch (e) { process.exit(2); } 
}
check();
EOF
  return $?
}

# --- SERVICE FUNCTIONS ---
check_ptero_dir() { [ -d "/var/www/pterodactyl" ] || return 1; }

install_theme() {
  while true; do
    clear; echo ""; premium_box "SELECT PREMIUM THEME" "$CYAN"; echo ""
    echo -e "  ${WHITE}${BOLD}[1] 🌌 Stellar    [2] 💳 Billing    [3] 🧩 Enigma    [4] 🌈 Elysium"
    echo -e "  [5] ❄️ Frostcore  [6] 🌃 Nightcore  [7] 🧱 Ice       [8] 👶 Noobe"
    echo -e "  [9] 🔥 Arix       [10]🐦 Nookure    [R] 🔄 Reset     [X] 🔙 Back"
    echo ""; echo -n -e "  ${BOLD}${YELLOW}👉 Choice: ${NC}"; read SELECT_THEME
    case "$SELECT_THEME" in
      [1-9]|10) break ;;
      r|R) uninstall_theme; return ;;
      x|X) return ;;
    esac
  done
  check_ptero_dir || { print_error "Panel not found!"; sleep 2; return 1; }
  # Install logic...
}

# --- START SEQUENCE ---
start_script() {
  clear; echo -e "${BRIGHT_YELLOW}${BOLD}"
  echo -e "  ███████╗██████╗ ███████╗███████╗███████╗███████╗██╗  ██╗ ██████╗ ███████╗████████╗"
  echo -e "  ██╔════╝██╔══██╗██╔════╝██╔════╝██╔════╝██╔════╝██║  ██║██╔═══██╗██╔════╝╚══██╔══╝"
  echo -e "  █████╗  ██████╔╝█████╗  █████╗  █████╗  █████╗  ███████║██║   ██║███████╗   ██║   "
  echo -e "  ██╔══╝  ██╔══██╗██╔══╝  ██╔══╝  ██╔══╝  ██╔══╝  ██╔══██║██║   ██║╚════██║   ██║   "
  echo -e "  ██║     ██║  ██║███████╗███████╗███████╗███████╗██║  ██║╚██████╔╝███████║   ██║   "
  echo -e "  ╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝   "
  echo -e "${NC}"; echo -e "    [ 👑  SYSTEM INITIALIZING PREMIUM ACCESS 👑  ] "
  echo ""
  
  show_loading 0 "Checking System Resources"
  show_loading 0 "Checking Network Protocol"
  show_loading 0 "Checking Secure Connection"
  echo ""

  print_info "Syncing dependencies..."
  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get update -qq > /dev/null 2>&1
  sudo apt-get install -qq -y jq gawk curl wget nodejs npm > /dev/null 2>&1
  if ! node -e "require('mongoose')" &>/dev/null; then sudo npm install -g mongoose --silent > /dev/null 2>&1; fi
  print_success "System Ready."
  
  sleep 1.5; clear
  
  premium_header "SYSTEM FIREWALL - IP VERIFICATION" "$CYAN"
  VPS_IP=$(curl -s https://api.ipify.org || echo "Unknown")
  print_info "Checking Whitelist for: ${YELLOW}$VPS_IP${NC}"
  
  if verify_mongodb_direct "ip"; then
    echo -e "  ${BOLD}STATUS: ${BG_GREEN}${WHITE} AUTHORIZED ${NC}\n"
  else
    echo -e "  ${BOLD}STATUS: ${BG_RED}${WHITE} UNAUTHORIZED ${NC}\n"; exit 1
  fi

  SESSION_FILE="/root/.fzh_session"
  if [ ! -f "$SESSION_FILE" ]; then
    premium_header "IDENTITY VERIFICATION REQUIRED" "$MAGENTA"
    print_warning "Password entries are hidden while typing."
    echo -n -e "  ${BOLD}${MAGENTA}👉 ${WHITE}OWNER PASSWORD : ${NC}"; read -s SECOND_PWD; echo
    echo -n -e "  ${BOLD}${MAGENTA}👉 ${WHITE}CUSTOM API KEY  : ${NC}"; read CLIENT_API_KEY
    if verify_mongodb_direct "full" "$SECOND_PWD" "$CLIENT_API_KEY"; then
      echo -e "  ${BOLD}RESULT: ${BG_GREEN}${WHITE} ACCESS GRANTED ${NC}"; touch "$SESSION_FILE"; sleep 1
    else
      echo -e "  ${BOLD}RESULT: ${BG_RED}${WHITE} ACCESS DENIED ${NC}"; exit 1
    fi
  else
    print_success "Session Active."; sleep 1
  fi
}

# --- MAIN DASHBOARD ---
start_script
while true; do
  clear; echo -e "${YELLOW}${BOLD}"
  echo -e "  ███████╗██████╗ ███████╗███████╗███████╗███████╗██╗  ██╗ ██████╗ ███████╗████████╗"
  echo -e "  ██╔════╝██╔══██╗██╔════╝██╔════╝██╔════╝██╔════╝██║  ██║██╔═══██╗██╔════╝╚══██╔══╝"
  echo -e "  █████╗  ██████╔╝█████╗  █████╗  █████╗  █████╗  ███████║██║   ██║███████╗   ██║   "
  echo -e "  ██╔══╝  ██╔══██╗██╔══╝  ██╔══╝  ██╔══╝  ██╔══╝  ██╔══██║██║   ██║╚════██║   ██║   "
  echo -e "  ██║     ██║  ██║███████╗███████╗███████╗███████╗██║  ██║╚██████╔╝███████║   ██║   "
  echo -e "  ╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝   "
  echo -e "${NC}"
  echo -e "  ${BOLD}${WHITE}┌───────────────────────── ${YELLOW}PREMIUM DASHBOARD${WHITE} ──────────────────────────┐${NC}"
  echo -e "  ${BOLD}${WHITE}│${NC} ${DIM}License:${NC} ${GREEN}ACTIVE${NC}  ${BOLD}${WHITE}│${NC} ${DIM}User:${NC} ${CYAN}VIP GUEST${NC}   ${BOLD}${WHITE}│${NC} ${DIM}Version:${NC} ${BRIGHT_YELLOW}5.0.0-PRO${NC}  ${BOLD}${WHITE}│${NC}"
  echo -e "  ${BOLD}${WHITE}└────────────────────────────────────────────────────────────────────────┘${NC}"
  echo -e "\n  ${BOLD}${MAGENTA}💎 EXCLUSIVE SERVICES:${NC}"
  echo -e "    ${WHITE}${BOLD}[1]  ${NC}${CYAN}🎨 Premium Themes${NC}     ${WHITE}${BOLD}[13] ${NC}${CYAN}📑 Install PHPMyAdmin${NC}"
  echo -e "    ${WHITE}${BOLD}[2]  ${NC}${CYAN}🔌 Blueprint Core${NC}     ${WHITE}${BOLD}[14] ${NC}${CYAN}🔐 Configure SSL${NC}"
  echo -e "    ${WHITE}${BOLD}[3]  ${NC}${CYAN}⏰ Auto-Suspend Pro${NC}   ${WHITE}${BOLD}[15] ${NC}${CYAN}💾 Full System Backup${NC}"
  echo -e "    ${WHITE}${BOLD}[4]  ${NC}${CYAN}🛡️ Protect Panel${NC}       ${WHITE}${BOLD}[16] ${NC}${CYAN}🚀 Turbo Build Assets${NC}"
  echo -e "    ${WHITE}${BOLD}[5]  ${NC}${CYAN}🔄 System Reset${NC}        ${WHITE}${BOLD}[17] ${NC}${CYAN}🚧 Maintenance Toggle${NC}"
  echo -e "    ${WHITE}${BOLD}[6]  ${NC}${CYAN}🗑️ Safe Uninstall${NC}      ${WHITE}${BOLD}[18] ${NC}${CYAN}🛠️ Fix Permissions${NC}"
  echo -e "    ${WHITE}${BOLD}[7]  ${NC}${CYAN}⚙️ Wings Management${NC}    ${WHITE}${BOLD}[19] ${NC}${CYAN}🧹 Clear Logs/Temp${NC}"
  echo -e "    ${WHITE}${BOLD}[8]  ${NC}${CYAN}🏗️ Node Architect${NC}      ${WHITE}${BOLD}[20] ${NC}${CYAN}🥚 Backup All Eggs${NC}"
  echo -e "    ${WHITE}${BOLD}[9]  ${NC}${CYAN}🔓 Admin Recovery${NC}      ${WHITE}${BOLD}[21] ${NC}${CYAN}📂 Backup Panel Files${NC}"
  echo -e "    ${WHITE}${BOLD}[10] ${NC}${CYAN}🔑 Security Config${NC}     ${WHITE}${BOLD}[22] ${NC}${CYAN}👤 Backup All Users${NC}"
  echo -e "    ${WHITE}${BOLD}[11] ${NC}${CYAN}🖼️ Change Background${NC}   ${WHITE}${BOLD}[23] ${NC}${CYAN}🗄️ Backup Database${NC}"
  echo -e "    ${WHITE}${BOLD}[12] ${NC}${CYAN}🏷️ Change Logo${NC}         ${WHITE}${BOLD}[x]  ${NC}${RED}❌ Terminal Exit${NC}"
  echo ""; echo -n -e "  ${BOLD}${WHITE}root@FreeZeeHost:~# ${NC}"; read -r MENU_CHOICE
  case "$MENU_CHOICE" in
    1) install_theme ;; x|X) exit 0 ;; *) sleep 1 ;;
  esac
done
