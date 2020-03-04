# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Source kube-ps1.sh for displaying the context of k8s
source ~/kube-ps1.sh

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

alias ll='ls -all'
alias dc='docker-compose'

# TMUX
if which tmux >/dev/null 2>&1; then
    #if not inside a tmux session, and if no session is started, start a new session
    test -z "$TMUX" && (tmux attach || tmux new-session)
fi

alias tf='terraform'
alias git='hub'
alias g='git status -sb'
alias gh='git hist'
alias gp='git pull'
alias gpr='git pull --rebase'
alias gpp='git pull --rebase && git push'
alias gf='git fetch'
alias gb='git branch'
alias ga='git add'
alias gc='git commit'
alias gca='git commit --amend'
alias gcv='git commit --no-verify'
alias gd='git diff --color-words'
alias gdc='git diff --cached -w'
alias gdw='git diff --no-ext-diff --word-diff'
alias gdv='git diff'
alias gl='git log --oneline --decorate'
alias gt='git tag'
alias grc='git rebase --continue'
alias grs='git rebase --skip'
alias gsl='git stash list'
alias gss='git stash save'


# Prompt
NORMAL="\[\033[00m\]"
BLUE="\[\033[01;34m\]"
YELLOW="\[\e[1;33m\]"
GREEN="\[\e[1;32m\]"

function parse_git_branch {
        CONTEXT=$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1 /')

        if [ -n "$CONTEXT" ]; then
                echo "(git: ${CONTEXT})"
        fi
}

function kube_ps1()
{
        # Get current context
        CONTEXT=$(cat ~/.kube/config | grep "current-context:" | sed "s/current-context: //")

        if [ -n "$CONTEXT" ]; then
                echo "(k8s: ${CONTEXT}) \n"
        fi
}

PS1="${GREEN}\$(parse_git_branch)$(kube_ps1)${BLUE}\h:\W \$ ${NORMAL}"
export PS1
source <(kubectl completion bash)
alias k=kubectl
complete -F __start_kubectl k

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

complete -C /usr/local/bin/vault vault
