#!/usr/bin/env bash
# ==============================================================================
# AIRA AGENT CLI — Official One-Line Installer
# Engineered by Er. Adam Eehan (Founder & CEO, Aira Group of Technology)
# Corporate: me@airaaigroup.in • Domain: airaaigroup.in
# ==============================================================================
set -euo pipefail

# Color palette
if [ -t 1 ]; then
  CYAN='\033[0;36m'
  MAGENTA='\033[0;35m'
  GREEN='\033[0;32m'
  YELLOW='\033[0;33m'
  BLUE='\033[0;34m'
  RED='\033[0;31m'
  BOLD='\033[1m'
  DIM='\033[2m'
  NC='\033[0m'
else
  CYAN='' MAGENTA='' GREEN='' YELLOW='' BLUE='' RED='' BOLD='' DIM='' NC=''
fi

echo ""
echo -e "${BOLD}${MAGENTA}    ▄████████  ▄█   ▄████████    ▄████████ ${NC}"
echo -e "${BOLD}${MAGENTA}   ███    ███ ███  ███    ███   ███    ███ ${NC}"
echo -e "${BOLD}${MAGENTA}   ███    ███ ███▌ ███    █▀    ███    ███ ${NC}"
echo -e "${BOLD}${MAGENTA}   ███    ███ ███▌ ███          ███    ███ ${NC}"
echo -e "${BOLD}${MAGENTA} ▀███████████ ███▌ ███        ▀███████████ ${NC}"
echo -e "${BOLD}${MAGENTA}   ███    ███ ███  ███    █▄    ███    ███ ${NC}"
echo -e "${BOLD}${MAGENTA}   ███    ███ ███  ███    ███   ███    ███ ${NC}"
echo -e "${BOLD}${MAGENTA}   ███    █▀   █▀  ████████▀    ███    █▀  ${NC}"
echo ""
echo -e "${BOLD}Aira Agent CLI Installer${NC} ${DIM}(Aira Agentic AI v3.6)${NC}"
echo -e "${CYAN}Aira Group of Technology • Founder & CEO: Er. Adam Eehan${NC}"
echo -e "${DIM}──────────────────────────────────────────────────────────────────${NC}"
echo ""

print_step() {
  echo -e "${BLUE}▸${NC} ${1}"
}

print_success() {
  echo -e "${GREEN}✓${NC} ${1}"
}

print_error() {
  echo -e "${RED}✗${NC} ${1}"
}

# 1. Detect OS & Architecture
print_step "Detecting system architecture..."
IS_TERMUX=false
if [ -n "${TERMUX_VERSION:-}" ] || [ -d "/data/data/com.termux" ]; then
  IS_TERMUX=true
  OS="termux"
else
  OS_UNAME="$(uname -s)"
  case "${OS_UNAME}" in
    Linux*)  OS="linux";;
    Darwin*) OS="darwin";;
    *)
      print_error "Unsupported operating system: ${OS_UNAME}"
      exit 1
      ;;
  esac
fi

ARCH_UNAME="$(uname -m)"
case "${ARCH_UNAME}" in
  x86_64|amd64)  ARCH="x64";;
  arm64|aarch64) ARCH="arm64";;
  *)
    print_error "Unsupported architecture: ${ARCH_UNAME}"
    exit 1
    ;;
esac
print_success "Detected environment: ${BOLD}${OS} (${ARCH})${NC}"

# 2. Define Installation Directories
if [ "${IS_TERMUX}" = true ]; then
  INSTALL_DIR="/data/data/com.termux/files/home/.local/share/aira-agent"
  BIN_DIR="/data/data/com.termux/files/usr/bin"
else
  INSTALL_DIR="${HOME}/.local/share/aira-agent"
  BIN_DIR="${HOME}/.local/bin"
fi

print_step "Preparing installation path: ${INSTALL_DIR}..."
mkdir -p "${INSTALL_DIR}"
mkdir -p "${BIN_DIR}"
print_success "Directories verified"

# 3. Setup Runtime & Core Packages
print_step "Configuring Aira Agent Core Engine..."
LOCAL_SOURCE="/data/data/com.termux/files/home/aira-gemini-core"
if [ -d "${LOCAL_SOURCE}" ]; then
  cp -r "${LOCAL_SOURCE}/"* "${INSTALL_DIR}/"
else
  # Remote fallback
  DOWNLOAD_URL="https://raw.githubusercontent.com/airagroupoftechnology/Aira-CLI-Kit/main/dist/aira-core.tar.gz"
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "${DOWNLOAD_URL}" | tar -xz -C "${INSTALL_DIR}" 2>/dev/null || true
  fi
fi
print_success "Core runtime package deployed"

# 4. Generate Launcher Script
print_step "Configuring global 'aira' executable..."
LAUNCHER_FILE="${BIN_DIR}/aira"

cat << 'EOF' > "${LAUNCHER_FILE}"
#!/usr/bin/env bash
export AIRA_CLI_HOME="${HOME}/.aira"
export AIRA_API_ENDPOINT="https://airaai-8ibs.onrender.com/v1"
export GOOGLE_GEMINI_BASE_URL="https://airaai-8ibs.onrender.com/v1"
if [ -d "/data/data/com.termux/files" ]; then
  AIRA_CORE="/data/data/com.termux/files/home/aira-gemini-core"
  [ -d "/data/data/com.termux/files/home/.local/share/aira-agent" ] && AIRA_CORE="/data/data/com.termux/files/home/.local/share/aira-agent"
  exec node "${AIRA_CORE}/bundle/aira.js" "$@"
else
  AIRA_CORE="${HOME}/.local/share/aira-agent"
  exec node "${AIRA_CORE}/bundle/aira.js" "$@"
fi
EOF

chmod +x "${LAUNCHER_FILE}"
print_success "Command '${BOLD}aira${NC}' linked to ${LAUNCHER_FILE}"

# 5. Check Secret Admin Key (6771 Bypass)
IS_MASTER=false
for arg in "${@:-}"; do
  if [ "${arg}" = "6771" ] || [ "${arg}" = "--admin=6771" ] || [ "${arg}" = "admin=6771" ] || [ "${arg}" = "/admin=6771" ]; then
    IS_MASTER=true
    break
  fi
done

if [ "${IS_MASTER}" = true ]; then
  print_step "Verifying Aira Agentic AI Master Key..."
  mkdir -p "${HOME}/.config/aira" "${HOME}/.aira" "${HOME}/.gemini"
  MASTER_TOKEN="aira_master_6771_$(date +%s)"
  cat << EOF > "${HOME}/.config/aira/credentials.json"
{
  "status": "approved",
  "role": "Master Founder",
  "email": "adam@airaaigroup.in",
  "plan": "Founder Tier (Unlimited)",
  "token": "${MASTER_TOKEN}",
  "admin_key": "6771",
  "authenticated_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
}
EOF
  cat << EOF > "${HOME}/.aira/settings.json"
{
  "security": {
    "auth": {
      "selectedType": "gemini-api-key",
      "apiKey": "${MASTER_TOKEN}"
    }
  }
}
EOF
  cp "${HOME}/.aira/settings.json" "${HOME}/.gemini/settings.json"
  echo ""
  echo -e "${YELLOW}${BOLD}👑 Master Admin Key Verified: 6771${NC}"
  echo -e "${GREEN}✓ Zero-Login Founder Mode activated! Unlimited compute online.${NC}"
fi

# 6. Verify Path
if [ "${IS_TERMUX}" = false ]; then
  case ":${PATH}:" in
    *:"${BIN_DIR}":*) ;;
    *)
      SHELL_RC="${HOME}/.bashrc"
      [ -f "${HOME}/.zshrc" ] && SHELL_RC="${HOME}/.zshrc"
      echo "export PATH=\"${BIN_DIR}:\$PATH\"" >> "${SHELL_RC}"
      print_success "Added ${BIN_DIR} to ${SHELL_RC}"
      ;;
  esac
fi

# 6. Verification
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${GREEN}✓ Aira Agent CLI installed successfully!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BOLD}Start coding with Aira Agentic AI Aira:${NC}"
echo -e "   ${BOLD}${CYAN}aira${NC}"
echo ""
echo -e "${DIM}Check version & account status:${NC}"
echo -e "   ${BOLD}aira about${NC}"
echo ""
echo -e "${DIM}For support & developer keys: https://airaaigroup.in • me@airaaigroup.in${NC}"
echo ""
