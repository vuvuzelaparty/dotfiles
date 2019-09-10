# .zshrc
# rob

# Allow zsh aliases and functions to be used from vim shell (:!<command>)
cp ~/.zshrc ~/.zshenv

# History stuff
HISTFILE=~/.zhistory
HISTSIZE=5000
SAVEHIST=5000
setopt appendhistory beep nomatch notify markdirs extendedglob autocd

unsetopt caseglob  # vi input mode
bindkey -v

# The following lines were added by compinstall
zstyle :compinstall filename "/home/rob/.zshrc"

autoload -Uz compinit # allow autocomplete
compinit
# End of lines added by compinstall

# prompt stuff
autoload -U colors
colors

alias ls='ls -CF --color=always' # color and extension coded output of ls
eval $(dircolors -b ~/.dircolors)

xrdb -merge ~/.Xresources

# git prompt
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' stagedstr 'Staged'
zstyle ':vcs_info:*' unstagedstr ' Modified'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' actionformats '%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats '%B%F{2}%c%F{3}%u %F{5}[branch * %F{2}%b%F{5}] '
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
zstyle ':vcs_info:*' enable git
+vi-git-untracked() {
	if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && [[ $(git ls-files --other --directory --exclude-standard | sed q | wc -l | tr -d ' ') == 1 ]] ; then
		hook_com[unstaged]+=' %F{1}New%f'
	fi
}

# set name of screen/tmux tab
setScTitle () { print -n "\033k$@\033\134" }

precmd () { # same as $PROMPT_COMMAND in bash
	vcs_info
	# tail -1 ~/.zhistory # TODO make terminal title previously executed command
	# print -Pn "\e]0;%n@%m: %~\a"
}
RPROMPT='${vcs_info_msg_0_}'

# display current directory in a nice way
prettyPathFunc () {
	fullShortPath=$(echo $PWD | perl -pe "s/(\w{3})[^\/]+\//\1\//g")
	if (( $(print -P %~ | grep -o '/' | wc -l) < 3 )); then
		if (( $(echo $fullShortPath | grep -o '/' | wc -l) == 4 )) && [[ $PWD = $HOME* ]]; then
			prettyPath=$(echo $fullShortPath | cut -c6- | sed "s/${USER:0:3}/~/")
		else
			prettyPath=$(print -P %~)
		fi
	elif (( $(echo $fullShortPath | grep -o '/' | wc -l) < 4 )) && [[ $PWD != $HOME* ]]; then
		prettyPath=$fullShortPath
	else
		prettyPath=$(echo $fullShortPath | awk -F "/" '{OFS="/"} {print $(NF-2),$(NF-1),$NF}')
	fi
}
prettyPathFunc

# name the screen/tmux tab the current directory
scrTermTitle () {
	if [[ $PWD = $HOME ]]; then
		setScTitle "~"
	elif [[ $PWD = "/" ]]; then
		setScTitle "/"
	else
		setScTitle "$(echo $PWD | awk -F "/" '{ print $NF }')"
	fi
}
scrTermTitle
alias title='scrTermTitle'

chpwd () # function that executes any time cd is executed
{
	ls
	prettyPathFunc
	scrTermTitle
}

zle-line-init () { # zsh line editor
	if (( ${+terminfo[smkx]} )); then
		echoti smkx
	fi
}
zle-line-finish () {
	if (( ${+terminfo[rmkx]} )); then
		echoti rmkx
	fi
}

zle -N zle-line-init
zle -N zle-line-finish

# Show VI mode
VIMODE="-I-"
function zle-line-init zle-keymap-select {
	VIMODE="${${KEYMAP/vicmd/-N-}/(main|viins)/-I-}"
	zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

autoload -Uz zmv # allow zmv to be used, might not be necessary anymore

PROMPT='%F{magenta}<< %F{red}%n %B%F{blue}~> %b%F{yellow}$prettyPath%F{magenta} >>%f ${VIMODE} $ ' # display prompt in a nice way

# Automatically choose and autocomplete option
setopt AUTO_MENU
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
bindkey '^[[Z' reverse-menu-complete
bindkey '^r' history-incremental-search-backward

# Press ESC then any of the following keys if unsure about caps lock
# necessary if you use a keyboard that doesn't indicate if caps lock on (I used to have one of these)
bindkey -M vicmd 'Q' vi-caps-lock-panic
bindkey -M vicmd 'G' vi-caps-lock-panic
bindkey -M vicmd 'H' vi-caps-lock-panic
bindkey -M vicmd 'J' vi-caps-lock-panic
bindkey -M vicmd 'K' vi-caps-lock-panic
bindkey -M vicmd 'L' vi-caps-lock-panic
bindkey -M vicmd 'Z' vi-caps-lock-panic
bindkey -M vicmd 'M' vi-caps-lock-panic

# turn off screensaver
xset s off -dpms

# Don't have to worry about num lock anymore
# bindkey -s "[2~" "0"
# bindkey -s "[3~" "."
# bindkey -s "[4~" "1"
# bindkey -s "OB" "2"
# bindkey -s "[6~" "3"
# bindkey -s "OD" "4"
# bindkey -s "OE" "5"
# bindkey -s "OC" "6"
# bindkey -s "[1~" "7"
# bindkey -s "OA" "8"
# bindkey -s "[5~" "9"

# Syntax highlighting (package needs to be installed)
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[globbing]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=yellow'

export EDITOR=vim

# Aliases and Functions
alias sc='screen'
alias scr='sc'
alias scl='sc -list'
alias sr='sc -raAd'
alias tmux='tmux -2'
alias tw='tmux neww'
t() { [[ $TERM = screen ]] && tw || tmux }
alias tl='tmux ls'
alias ta='tmux attach'
alias tat='ta -t'
alias sd='systemctl'
alias grep='grep -I --exclude={\*.min.js,\*.css} --color=always "$@" 2>/dev/null'
alias grep1='grep -m 1'
alias sizeof='du -sh'
alias c='cd'
alias cdd='pushd'
alias co='popd'
alias ccd='cd ..'
alias cccd='cd ../..'
alias ccccd='cd ../../..'
alias c4d='cd ../../../..'
alias c5d='cd ../../../../..'
alias c6d='cd ../../../../../..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias .6='cd ../../../../../..'
alias l='ls'
alias la='ls -A'
alias ll='la -lh'
alias dirs='dirs -v'
alias mkdir='mkdir -p'
alias md='mkdir'
alias rmd='rmdir'
alias mount='mount | column -t'
alias wget='wget -c'
mc() { mkdir "$@" && cd "$1" }
mktar() { tar -cvf "$@"; mv "$1" "$1.tar" }
mktargz() { tar -cvzf "$@"; mv "$1" "$1.tar.gz" }
alias utar='tar xvf'
alias logout='pkill -u $USER'
eval $(thefuck --alias)
eval $(thefuck --alias FUCK)
alias php='/usr/bin/psysh'
alias :q='echo "Nothing happened, because you were not in vim."'
alias :Q=':q'
alias :w='echo "Nothing happened, because you are not in vim."'
alias :W=':w'
alias :wq=':q'
alias :Wq=':q'
alias :WQ=':q'
alias :qw=':q'
alias :Qw=':q'
alias :QW=':q'
alias e='exit'
alias j='jobs'
alias vi="vim"
alias v='vi'
alias vz='v ~/.zshrc'
alias vv='v ~/.vimrc'
alias vs='v ~/.screenrc'
alias vt='v ~/.tmux.conf'
alias v3='v ~/.config/i3/config'
alias vg='cat ~/.gitrc'
alias vvg='v ~/.gitrc'
alias zh='v ~/.zhistory'
alias s='source ~/.zshrc'
alias f='fg'
makej() { make -j || make V=s | tee make_fail }
alias smigrep='noglob ~/dev/smigrep/smigrep'
alias sm='smigrep'
vmconsole() { setScTitle console && sudo virsh console && scrTermTitle }
alias rm='rm -f'
alias rmrf='rm -r'
alias gzip='gzip -f'
alias pdf='evince 2> /dev/null'
alias img='eog 2> /dev/null'
open () {
	[[ "$(file -b $1)" =~ "PDF document.*" ]] && pdf $1
	{ [[ "$(file -b $1)" =~ "JPEG image data.*" ]] || [[ "$(file -b $1)" =~ "PNG image data.*" ]] } && img $1
}
swp() { find . -depth -name .\*.swp -exec rm -i {} \; && find ~/.cache/vim/swap -name \*.swp -exec rm -i {} \; }
alias tmp='rm /tmp/tmp.*'
pi() { setScTitle pi && ssh pi@raspberrypi && scrTermTitle }
alias wake_mac_disk='sg_raw /dev/sr0 EA 00 00 00 00 00 01'
alias stats='neofetch'
alias AURmake='makepkg -Acsf' # $ AURmake
alias AURinstall='sudo pacman -U' # $ AURinstall foo.pkg.tar.xz
alias AURaddkey='gpg --recv-keys'
AURupdate() { ghead=$(git rev-parse HEAD) && gp && [ $(git rev-parse HEAD) != $ghead ] && rm *.pkg.tar.xz && AURmake && AURinstall *.pkg.tar.xz }
alias devices="mount | grep 'sd[a-z][0-9]'"
alias generateConfigForNewMachine='mktargz ~/config ~/dev/smigrep/smigrep ~/.config/i3/config ~/.dircolors ~/.gitconfig ~/.gitrc ~/.tmux.conf ~/.vimrc ~/.vim/autoload ~/.vim/bundle ~/.vim/colors ~/.Xresources ~/.zshrc ~/.screenrc ~/.sleep ~/.lock_screen'
alias networkIPlist="nmap -sn $(ip route show | grep -i 'default via'| awk '{print $3}')/24"
spu() { sudo pacman-key --refresh-keys && sudo pacman -Syu && sudo pacman -R $(pacman -Qdtq) }
spuf() { sudo pacman-key --refresh-keys && sudo pacman -Syyu && sudo pacman -R $(pacman -Qdtq) }
dotfiles() { cp ~/.dircolors ~/.gitrc ~/.tmux.conf ~/.vimrc ~/.zshrc ~/.Xresources ~/.screenrc ~/.sleep ~/.lock_screen ~/.blu ~/dotfiles; cp ~/.config/i3/config ~/dotfiles/.config/i3/; cp ~/.vim/colors/robcolorscheme.vim ~/dotfiles/.vim/colors; cd ~/dotfiles; sed -i "s/blu=\".*/blu=\"<bluetooth_address>\"\n# replace <bluetooth_address> with your device ID\; can be found by doing \`echo 'paired-devices' | bluetoothctl\` assuming your device is already paired/" .blu }
alias outsideip='curl icanhazip.com'
# alias dd='dd "$@" status=progress oflag=sync'
# xrandr --output DP-3 --mode 3840x2160 --output DP-1 --off
rand() { [[ "$1" =~ "^[0-9]+$" ]] && (($1 < 32769)) && echo $(( RANDOM%$1 + 1 )) || { echo "Please enter a number between 1 and 32768" && return; } }
rand2() { [[ "$1" =~ "^[0-9]+$" ]] && [[ "$2" =~ "^[0-9]+$" ]] && (($2 < 32769)) && (($2 > $1)) && echo $(( RANDOM%(($2-$1+1)) + $1 )) || { echo "Please enter 2 numbers between 1 and 32768, with the second number being greater than the first" && return; } }
alias wh='noglob find . -depth -iname'
alias er="amixer get Master | grep --color=never -o -e '\[.*%\] \[o.*\]' | head -1"
alias a='amixer'
alias am='alsamixer'
alias subl='subl3'
alias pp='curl icanhazip.com'
alias PP='pp'
alias vpn='~/vpn'
alias top='top -o %CPU'

source ~/.gitrc
source ~/.blu

tmux_colors() { for i in {0..255}; do printf "\x1b[38;5;${i}mcolor${i}\x1b[0m\n"; done }

# # make syntastic use python2.7
# venv() {
# 	local activate=~/.python/$1/bin/activate
# 	if [ -e "$activate" ] ; then
# 		source "$activate"
# 	else
# 		echo "Error: Not found: $activate"
# 	fi
# }
# venv27() { echo "'deactivate' to exit python environment"; venv 27 ; }

rmctrlM() {
	for i do
		sed -e "s///" $i > tmp # to get the '^M', do ctrl-v, then hit enter
		mv tmp $i
	done
}

# xautolock -time 1 -locker '~/.lock_screen' &

# to convert to decimal/binary/hex
# python -c 'print(bin|hex|int(0b|0x|<num>))'
