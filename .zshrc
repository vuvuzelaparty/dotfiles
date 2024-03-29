# Allow zsh aliases and functions to be used from vim shell (:!<command>)
cp ~/.zshrc ~/.zshenv

# clear all aliases
unalias -m "*"

# to clear a function, use $(unset -f <function>)

alias ls='ls -CF --color=always' # color and extension coded output of ls

# reset home directory
HOME=/home/$USER

# History stuff
HISTFILE=~/.zhistory
HISTSIZE=5000
SAVEHIST=5000

setopt autocd braceccl cbases cprecedences extendedglob globdots globstarshort histexpiredupsfirst histfindnodups histignorealldups histignoredups histreduceblanks histsavenodups incappendhistory listpacked magicequalsubst markdirs numericglobsort octalzeroes pathdirs promptsubst rcexpandparam sunkeyboardhack
unsetopt caseglob flowcontrol ignorebraces ignoreclosebraces nomatch

bindkey -v # vi mode
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
bindkey '^[[Z' reverse-menu-complete
bindkey '^r' history-incremental-search-backward
export EDITOR=vim
# The following lines were added by compinstall
zstyle :compinstall filename "/home/$USER/.zshrc"

autoload run-help

autoload -Uz compinit
compinit
# End of lines added by compinstall

# prompt stuff
autoload -U colors
colors

autoload -Uz promptinit
promptinit

# git prompt
autoload -Uz vcs_info
zstyle ':vcs_info:*' stagedstr 'Staged%f '
zstyle ':vcs_info:*' unstagedstr 'Modified%f '
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' actionformats '%B%F{5}[ %F{2}%b%F{3}|%F{1}%a%F{5} ]%%b%f'
zstyle ':vcs_info:*' formats '%B%F{2}%c%F{3}%u%F{5}[ %F{2}%b%F{5} ]%%b%f'
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
zstyle ':vcs_info:*' enable git
+vi-git-untracked() {
	[[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && [[ $(git ls-files --other --directory --exclude-standard | sed q | wc -l | tr -d ' ') == 1 ]] && hook_com[unstaged]+='%F{1}New%f '
}

precmd() { # same as $PROMPT_COMMAND in bash
	vcs_info
# 	# print -Pn "\e]0;%n@%m: %~\a"
}
RPROMPT='${vcs_info_msg_0_}'

# display current directory in a nice way
prettyPath() {
	local fullShortPath=$(print -P %~ | perl -pe "s/(\w{3})[^\/]+\//\1\//g")
	local prettyPath=$(print -P %~)
	if [ $(print -P %~ | grep -o '/' | wc -l) -lt 3 ]; then
		if [ $(echo $fullShortPath | grep -o '/' | wc -l) -eq 4 ] && [[ $PWD = $HOME* ]]; then
			prettyPath=$(echo $fullShortPath | cut -c6- | sed "s/${USER:0:3}/~/")
		fi
	elif [ $(echo $fullShortPath | grep -o '/' | wc -l) -lt 4 ] && [[ $PWD != $HOME* ]]; then
		prettyPath=$fullShortPath
	else
		prettyPath=$(echo $fullShortPath | awk -F "/" '{OFS="/"} {print $(NF-2),$(NF-1),$NF}')
	fi
	echo $prettyPath
}

# name the screen/tmux tab the current directory
setTabTitle() { print -n "\033k$@\033\134" }
title() {
	if [[ $PWD = $HOME ]] || [[ $PWD = $HOME/ ]]; then
		setTabTitle "~"
	elif [[ $PWD = "/" ]]; then
		setTabTitle "/"
	else
		setTabTitle "$(echo $PWD | awk -F "/" '{print $NF}')"
	fi
}
alias ti='title'

chpwd() # function that executes any time cd is executed
{
	ls
	ti
}

VIMODE="-I-"
function zle-line-init zle-keymap-select {
	VIMODE="${${KEYMAP/vicmd/-N-}/(main|viins)/-I-}"
	zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

PROMPT='%B%F{magenta}<< %F{red}%n%F{blue}@%m %F{green}~> %F{yellow}$(prettyPath)%F{magenta} >>%f%b ${VIMODE} $ ' # display prompt in a nice way

xrdb -merge ~/.Xresources


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

source ~/.gitrc
source ~/.blu

eval $(dircolors -b ~/.dircolors)

alias l='ls'
alias la='l -A'
alias ll='la -lh'
alias dirs='dirs -v'
alias mkdir='mkdir -p'
alias grep='grep -I --exclude={*.min.js,*.css} --exclude-dir=.cache --color=always "$@" 2>/dev/null'
alias sizeof='du -sh'
alias c='cd'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
alias ......='cd ../../../../../'
alias md='mkdir -p'
alias vi="vim"
alias v='vi'
alias vz='v ~/.zshrc'
alias vv='v ~/.vimrc'
alias vt='v ~/.tmux.conf'
alias v3='v ~/.config/i3/config'
alias vg='cat ~/.gitrc'
alias vvg='v ~/.gitrc'
alias s='source ~/.zshrc'
alias f='fg'
alias e='exit'
alias j='jobs'
alias wget='wget -c'
mc() { mkdir "$@" && cd "$1" }
alias tmux='tmux -2'
alias tw='tmux neww'
t() { [[ $TERM = screen ]] && tw || tmux }
alias tl='tmux ls'
alias ta='tmux attach'
alias tat='ta -t'
mktar() { tar -cvf "$@"; mv "$1" "$1.tar" }
mktargz() { tar -cvzf "$@"; mv "$1" "$1.tar.gz" }
alias utar='tar xvf'
alias logout='pkill -u $USER'
eval $(thefuck --alias)
eval $(thefuck --alias FUCK)
swp() { find . -depth -name .\*.swp -exec rm -i {} \; && find ~/.cache/vim/swap -name \*.swp -exec rm -i {} \; }
alias tmp='rm /tmp/tmp.*'
pi() { setTabTitle pi && ssh pi@raspberrypi && ti }
alias stats='neofetch'
makej() { make -j || make V=s | tee make_fail }
alias AURmake='makepkg -Acsf' # $ AURmake
alias AURinstall='sudo pacman -U' # $ AURinstall foo.pkg.tar.zst
alias AURaddkey='gpg --recv-keys'
AURupdate() { ghead=$(git rev-parse HEAD) && gp && [ $(git rev-parse HEAD) != $ghead ] && git clean -fd && rm -f *.pkg.tar.zst && AURmake && AURinstall *.pkg.tar.zst }
UAAUR() { prev=$PWD && cd ~/AUR && for dir in $(ls --color=never); do echo $dir; cd $dir; AURupdate; cd -; done && cd $prev }
alias smigrep='noglob ~/dev/smigrep/smigrep'
alias sm='smigrep'
alias networkIPlist="nmap -sn $(ip route show | grep -i 'default via'| awk '{print $3}')/24"
spu() { sudo pacman-key --refresh-keys; sudo pacman -Syu && sudo pacman -R $(pacman -Qdtq) }
spuf() { sudo pacman-key --refresh-keys; sudo pacman -Syyu && sudo pacman -R $(pacman -Qdtq) } # sometimes this doesn't work, run $(sudo pacman -S archlinux-keyring) if hit with corrupted keys
rand() { [[ "$1" =~ "^[0-9]+$" ]] && [ $1 -lt 32769 ] && echo $[RANDOM%$1+1] || { echo "Please enter an integer between 1 and 32768" && return; } }
rand2() { [[ "$1" =~ "^[0-9]+$" ]] && [[ "$2" =~ "^[0-9]+$" ]] && [ $2 -lt 32769 ] && [ $2 -gt $1 ] && echo $[RANDOM%$[$2-$1+1]+$1] || { echo "Please enter 2 integers between 1 and 32768, with the second integer being greater than the first" && return; } }
awkk() { awk "NR==$1" }
alias devices="mount | grep 'sd[a-z][0-9]'"
alias wh='noglob find . -depth -iname'
alias pp='curl icanhazip.com'
alias top='top -o %CPU'
alias gzip='gzip -f'
alias pdf='evince 2> /dev/null'
alias img='eog 2> /dev/null'
alias mm='free -ht'
alias clrmem="sudo sh -c 'sync; echo 1 > /proc/sys/vm/drop_caches; sync; echo 2 > /proc/sys/vm/drop_caches; sync; echo 3 > /proc/sys/vm/drop_caches'"
na() { [ $# -eq 0 ] && { pcmanfm 2> /dev/null & } || pcmanfm $@ 2> /dev/null & }
open() {
	for i in $@; do
		[[ "$(file -b $i)" =~ "PDF document.*" ]] && pdf $i &
		{ [[ "$(file -b $i)" =~ "JPEG image data.*" ]] || [[ "$(file -b $i)" =~ "PNG image data.*" ]] } && img $i &
	done
}
ceil() { [ "${1%.*}" = "-0" ] && echo 0 || { [ "${1#*.}" -gt "0" ] && [ "${1:0:1}" != "-" ] && echo $[${1%.*}+1] || echo ${1%.*}; } } # round towards positive infinity
floor() { [ "${1#*.}" != "$1" ] && [ "${1:0:1}" = "-" ] && echo $[${1%.*}-1] || echo ${1%.*}; } # round towards negative infinity
trunc() { [ "${1%.*}" = "-0" ] && echo 0 || echo ${1%.*}; } # round towards 0
truncR() { [ "${1#*.}" != "$1" ] && { [ "${1:0:1}" = "-" ] && echo $[${1%.*}-1] || echo $[${1%.*}+1]; } || echo ${1%.*}; } # round away from 0
roundToInt() { [[ "${1#*.}" =~ "^[5-9][0-9]*$" ]] && truncR $1 || trunc $1; } # round to nearest integer

rsa=~/.ssh/id_rsa
export rsa
alias ssh="ssh -i $rsa"
alias scp="scp -i $rsa"
dotfiles() { cp ~/.gitrc ~/.tmux.conf ~/.vimrc ~/.zshrc ~/.sleep ~/.lock_screen ~/.dircolors ~/.Xresources ~/.blu ~/dotfiles; cp ~/.config/i3/{config,i3status.conf} ~/dotfiles/.config/i3/; cp ~/.vim/colors/vcolorscheme.vim ~/dotfiles/.vim/colors; cd ~/dotfiles }

rmctrlM() {
	for i do
		sed -e "s///" $i > tmp # to get the '^M', do ctrl-v, then hit enter
		mv tmp $i
	done
}

goto() {
	cd $(dirname $(wh $1))
}

# alias dd='dd "$@" status=progress oflag=sync'

# to convert to decimal/binary/hex/octal
# python -c 'print(bin|hex|oct|int(0b|0x|0o|<num>))'
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[globbing]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=yellow'
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
