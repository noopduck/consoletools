#!/bin/bash
set -euo pipefail

# Unified shell customization setup
# Applies powerline, tmux, and zsh configurations.
#
# Usage:
#   ./setup.sh                  # interactive menu
#   ./setup.sh --all            # apply everything
#   ./setup.sh --powerline      # just powerline
#   ./setup.sh --tmux           # just tmux
#   ./setup.sh --zsh            # just zsh
#   ./setup.sh --fzf            # just fzf
#   ./setup.sh --dry-run        # show what would be done without making changes

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ---------------------------------------------------------------------------
# Colors (best-effort, degrade to plain text on non-terminal)
# ---------------------------------------------------------------------------
if [[ -t 1 ]]; then
    RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
    CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'
else
    RED=''; GREEN=''; YELLOW=''; CYAN=''; BOLD=''; RESET=''
fi

info()  { echo -e "${CYAN}[info]${RESET}  $*"; }
ok()    { echo -e "${GREEN}[ ok ]${RESET}  $*"; }
warn()  { echo -e "${YELLOW}[warn]${RESET}  $*"; }
err()   { echo -e "${RED}[err ]${RESET}  $*" >&2; }
step()  { echo -e "\n${BOLD}=== $* ===${RESET}"; }

# ---------------------------------------------------------------------------
# Globals
# ---------------------------------------------------------------------------
DRY_RUN=false
APPLIED=()

# ---------------------------------------------------------------------------
# OS detection helper
# ---------------------------------------------------------------------------
# Returns 0 if the given package manager is available.
has_dpkg()  { [[ -f /etc/debian_version ]]; }
has_pacman(){ [[ "$(uname -r)" =~ MANJARO ]]; }
has_dnf()   { [[ -n "$(command -v dnf)" ]]; }

detect_os() {
    if has_dpkg;  then echo "debian";  return 0
    elif has_pacman; then echo "manjaro"; return 0
    elif has_dnf;  then echo "fedora";  return 0
    else echo "unknown"; return 1
    fi
}

# Install a package using the system package manager.
# Usage: ensure_pkg <package> [package2 ...]
ensure_pkg() {
    local os pkg
    os="$(detect_os)"
    for pkg in "$@"; do
        if pkg_installed "$pkg"; then
            ok "$pkg already installed"
            continue
        fi
        case "$os" in
            debian)
                if "$DRY_RUN"; then
                    info "[dry-run] would apt-get install $pkg"
                else
                    info "Installing $pkg via apt";  sudo apt-get install -y "$pkg"
                fi ;;
            manjaro)
                if "$DRY_RUN"; then
                    info "[dry-run] would pacman -S $pkg"
                else
                    info "Installing $pkg via pacman"; sudo pacman --noconfirm -S "$pkg"
                fi ;;
            fedora)
                if "$DRY_RUN"; then
                    info "[dry-run] would dnf install $pkg"
                else
                    info "Installing $pkg via dnf";    sudo dnf install -y "$pkg"
                fi ;;
            unknown)
                err "Unsupported OS and $pkg is not installed. Install it manually."
                return 1
                ;;
        esac
    done
}

# Check whether a package is already installed (best-effort).
pkg_installed() {
    local pkg="$1" os
    os="$(detect_os)"
    case "$os" in
        debian)  dpkg -l "$pkg" 2>/dev/null | grep -q "^ii" ;;
        manjaro) pacman -Qs "^${pkg}$" &>/dev/null ;;
        fedora)  rpm -q "$pkg" &>/dev/null ;;
        unknown) command -v "$pkg" &>/dev/null ;;
    esac
}

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

# Append text to a file only if not already present.
# Usage: ensure_in_file <file> <marker_line> <text_to_append>
ensure_in_file() {
    local file="$1" marker="$2" body="$3"
    if [[ ! -f "$file" ]]; then
        warn "$file does not exist"
        return 1
    fi
    if grep -qF "$marker" "$file"; then
        ok "$marker already in $file"
        return 0
    fi
    if "$DRY_RUN"; then
        info "[dry-run] would append $marker to $file"
        return 0
    fi
    echo "$body" >> "$file"
    ok "Appended $marker to $file"
}

# Install a pip package for the current user.
install_pip_pkg() {
    local pkg="$1"
    if pip3 show "$pkg" &>/dev/null; then
        ok "pip package $pkg already installed"
        return 0
    fi
    if "$DRY_RUN"; then
        info "[dry-run] would pip3 install --user $pkg"
        return 0
    fi
    pip3 install --user --quiet "$pkg"
    ok "pip3 installed $pkg"
}

# Download a URL to a temp file; print the path. Caller must clean up.
download_to_tmp() {
    local url="$1" desc="${2:-}"
    local tmp
    tmp="$(mktemp)"
    if "$DRY_RUN"; then
        info "[dry-run] would curl -fsSL '$url' -> $tmp"
        rm "$tmp"
        return 0
    fi
    curl -fsSL "$url" -o "$tmp"
    ok "Downloaded $desc to $tmp"
    echo "$tmp"
}

# ---------------------------------------------------------------------------
# Fzf setup
# ---------------------------------------------------------------------------
setup_fzf() {
    step "Fzf"

    ensure_pkg fzf

    local zsh_completion="$HOME/.config/completion.zsh"
    local bash_completion="$HOME/.config/completion.sh"

    # Generate zsh completion script
    if "$DRY_RUN"; then
        info "[dry-run] would run: fzf --zsh > $zsh_completion"
    else
        mkdir -p "$(dirname "$zsh_completion")"
        fzf --zsh > "$zsh_completion"
        ok "Generated $zsh_completion"
    fi

    # Source zsh completion in .zshrc
    local zshrc="$HOME/.zshrc"
    ensure_in_file "$zshrc" "fzf.zsh" \
        "# fzf completions
source \"\$HOME/.config/completion.zsh\""

    # Generate bash completion script
    if "$DRY_RUN"; then
        info "[dry-run] would run: fzf --bash > $bash_completion"
    else
        mkdir -p "$(dirname "$bash_completion")"
        fzf --bash > "$bash_completion"
        ok "Generated $bash_completion"
    fi

    # Source bash completion in .bashrc
    local bashrc="$HOME/.bashrc"
    ensure_in_file "$bashrc" "fzf.bash" \
        "# fzf completions
source \"\$HOME/.config/completion.sh\""

    APPLIED+=(fzf)
}

# ---------------------------------------------------------------------------
# Tmux setup
# ---------------------------------------------------------------------------
setup_tmux() {
    step "Tmux"

    ensure_pkg tmux curl

    # tpm (tmux plugin manager)
    local tpm_dir="$HOME/.tmux/plugins/tpm"
    if [[ ! -d "$tpm_dir" ]]; then
        mkdir -p "$HOME/.tmux/plugins"
        if "$DRY_RUN"; then
            info "[dry-run] would clone tpm into $tpm_dir"
        else
            git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
        fi
        ok "Cloned tpm"
    else
        ok "tpm already installed"
    fi

    # Fetch .tmux.conf from remote
    local tmux_conf_url="https://raw.githubusercontent.com/noopduck/consoletools/master/DOTFILES/.tmux.conf"
    local tmux_conf="$HOME/.tmux.conf"

    if [[ -f "$tmux_conf" ]]; then
        warn "$tmux_conf already exists — appending remote config"
        if ! "$DRY_RUN"; then
            curl -fsSL "$tmux_conf_url" >> "$tmux_conf"
        fi
    else
        info "Creating $tmux_conf from remote"
        if ! "$DRY_RUN"; then
            curl -fsSL "$tmux_conf_url" -o "$tmux_conf"
        fi
    fi
    ok "tmux.conf ready"

    # mtmux helper
    local mtmux_src="https://raw.githubusercontent.com/noopduck/consoletools/master/mtmux"
    local mtmux_dst="$HOME/.local/bin/mtmux"
    if [[ ! -f "$mtmux_dst" ]]; then
        mkdir -p "$(dirname "$mtmux_dst")"
        if "$DRY_RUN"; then
            info "[dry-run] would install mtmux to $mtmux_dst"
        else
            curl -fsSL "$mtmux_src" -o "$mtmux_dst"
            chmod +x "$mtmux_dst"
        fi
        ok "Installed mtmux"
    else
        ok "mtmux already installed"
    fi

    APPLIED+=(tmux)
}

# ---------------------------------------------------------------------------
# Zsh setup
# ---------------------------------------------------------------------------
setup_zsh() {
    step "Zsh"

    ensure_pkg zsh fzf tmux

    # GNOME keyboard repeat settings (only on GNOME)
    if command -v gsettings &>/dev/null \
       && gsettings list-schemas 2>/dev/null | grep -q "org.gnome.desktop.peripherals.keyboard"; then
        if ! "$DRY_RUN"; then
            gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 20
            gsettings set org.gnome.desktop.peripherals.keyboard delay 180
        fi
        ok "Set GNOME keyboard repeat rate"
    else
        warn "GNOME gsettings not available, skipping keyboard settings"
    fi

    # Oh My Zsh installer
    local omz_install_url="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
    info "Installing Oh My Zsh (non-interactive)"
    if "$DRY_RUN"; then
        info "[dry-run] would run: sh -c \"$(curl -fsSL $omz_install_url)\""
    else
        sh -c "$(curl -fsSL "$omz_install_url")" </dev/null
    fi

    # Powerlevel10k
    local p10k_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    if [[ ! -d "$p10k_dir" ]]; then
        info "Cloning powerlevel10k"
        if "$DRY_RUN"; then
            info "[dry-run] would clone powerlevel10k into $p10k_dir"
        else
            mkdir -p "$(dirname "$p10k_dir")"
            git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
        fi
    else
        ok "powerlevel10k already cloned"
    fi

    # Ensure p10k theme is set in .zshrc
    local zshrc="$HOME/.zshrc"
    if [[ -f "$zshrc" ]]; then
        if ! grep -qF 'powerlevel10k/powerlevel10k' "$zshrc"; then
            if "$DRY_RUN"; then
                info "[dry-run] would set ZSH_THEME=powerlevel10k/powerlevel10k in $zshrc"
            else
                echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> "$zshrc"
            fi
            ok "Set ZSH_THEME in $zshrc"
        else
            ok "ZSH_THEME already set in $zshrc"
        fi
    fi

    # User fonts
    local fonts_url="https://raw.githubusercontent.com/noopduck/consoletools/master/shell_customizations/fonts/fonts.tar.gz"
    local fonts_dir="$HOME/.local/share/fonts"
    local fonts_tmp
    fonts_tmp="$(download_to_tmp "$fonts_url" "fonts")"

    if [[ ! -d "$fonts_dir" ]]; then
        if ! "$DRY_RUN"; then
            mkdir -p "$fonts_dir"
        fi
    fi

    if "$DRY_RUN"; then
        info "[dry-run] would extract fonts to $fonts_dir"
    else
        tar xf "$fonts_tmp" -C "$fonts_dir"
        if command -v fc-cache &>/dev/null; then
            fc-cache -f
            ok "Font cache updated"
        else
            warn "fc-cache not found — run it manually to register fonts"
        fi
    fi
    rm -f "$fonts_tmp"

    # Nord gnome-terminal theme
    local nord_url="https://raw.githubusercontent.com/arcticicestudio/nord-gnome-terminal/develop/src/nord.sh"
    info "Installing Nord gnome-terminal theme"
    if "$DRY_RUN"; then
        info "[dry-run] would pipe nord theme installer"
    else
        curl -fsSL "$nord_url" | bash
    fi

    APPLIED+=(zsh)
}

# ---------------------------------------------------------------------------
# Menu / CLI
# ---------------------------------------------------------------------------
show_menu() {
    echo -e "\n${BOLD}Shell Customization Setup${RESET}"
    echo "========================="
    echo ""
    echo "  1) Tmux        — tmux + tpm + remote config"
    echo "  2) Zsh         — zsh + oh-my-zsh + powerlevel10k + fonts"
    echo "  4) Fzf         — fzf with shell completions"
    echo "  3) All         — tmux + zsh + fzf"
    echo "  0) Quit"
    echo ""
    read -rp "Choose [1-4,0]: " choice
    echo "$choice"
}

run_selected() {
    local components=("$@")
    for c in "${components[@]}"; do
        case "$c" in
            tmux)      setup_tmux ;;
            zsh)       setup_zsh ;;
            fzf)       setup_fzf ;;
            *)         err "Unknown component: $c"; return 1 ;;
        esac
    done
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
main() {
    local components=()

    # Parse flags
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --dry-run)  DRY_RUN=true; shift ;;
            --all)      components=(tmux zsh fzf); shift ;;
            --tmux)      components+=(tmux); shift ;;
            --zsh)       components+=(zsh); shift ;;
            --fzf)       components+=(fzf); shift ;;
            -h|--help)
                echo "Usage: $0 [--all|--tmux|--zsh|--fzf|--dry-run]"
                exit 0 ;;
            *) err "Unknown argument: $1"; exit 1 ;;
        esac
    done

    # Interactive menu if no flags given
    if [[ ${#components[@]} -eq 0 ]]; then
        choice="$(show_menu)"
        case "$choice" in
            1) components=(tmux) ;;
            2) components=(zsh) ;;
            4) components=(fzf) ;;
            3) components=(tmux zsh fzf) ;;
            *) exit 0 ;;
        esac
    fi

    if "$DRY_RUN"; then
        warn "Running in dry-run mode — nothing will be changed"
    fi

    run_selected "${components[@]}"

    echo -e "\n${GREEN}${BOLD}Done! Applied: ${APPLIED[*]}${RESET}"
    if [[ "${#components[@]}" -gt 0 ]]; then
        if [[ "${components[*]}" =~ zsh ]]; then
            echo ""
            info "Restart your terminal or run: exec zsh"
        fi
    fi
}

main "$@"
