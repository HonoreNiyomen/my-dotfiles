# Path to your Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

# Oh My Zsh Plugins
plugins=(git zsh-autosuggestions fast-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# =========================
# Environment Variables
# =========================

# Uncomment if needed:
# export LANG=en_US.UTF-8
# export ARCHFLAGS="-arch $(uname -m)"

# =========================
# Path
# =========================
#set +h

# =========================
# Settings
# =========================

HIST_STAMPS="yyyy-mm-dd"
# HYPHEN_INSENSITIVE="true"
# COMPLETION_WAITING_DOTS="true"
# ENABLE_CORRECTION="true"
export EDITOR='vim'

# mise (version manager)
if command -v mise &> /dev/null; then
  eval "$(mise activate zsh)"
fi

# =========================
# Aliases
# =========================

alias ..="cd .."
alias ...="cd ~/"
alias la="ls -a"
#alias cat="bat"
#alias grep="rg"
alias vim="nvim"
alias apt_install="sudo apt-fast install"
alias apt_remove="sudo apt-fast remove"
alias open_vpn_start="sudo openvpn --config ~/Work/'helsb docs'/eregprod.ovpn"

# =========================
# Custom Functions
# =========================

rebuild_helsb() {
  systemctl restart postgresql && cd ~/Work/helsb && mix restart && mix ecto.reset
}
start_helsb() {
  cd ~/Work/helsb && iex -S mix phx.server
}

run_lob_frontend() {
  cd ~/Personal/lob-exam-scheduler-java/exams-frontend && npm run dev
}

run_lob_backend() {
  cd ~/Personal/lob-exam-scheduler-java/ && ./mvnw spring-boot:run
}

export PATH="/usr/games:$PATH"
export ERL_AFLAGS="-kernel shell_history enabled"
export KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac --without-wx"
export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:/home/horez/.local/share/flatpak/exports/share:${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
export EXAMS_DATABASE_URL="jdbc:postgresql://localhost:5432/lob_exams_java"
export DB_USERNAME="root"
export DB_PASSWORD="Qwerty12"
export JWT_SECRET="3714874f0ebd5536ec5e8ba027fa882b"
export TERMINAL=alacritty
export QT_QPA_PLATFORM=wayland
export XDG_CURRENT_DESKTOP=sway
