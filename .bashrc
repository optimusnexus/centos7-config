# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

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
BLUE="\[\033[00;34m\]"
BOLD_BLUE="\[\033[01;34m\]"
BOLD_YELLOW="\[\033[01;33m\]"
YELLOW="\[\e[1;33m\]"
BOLD_GREEN="\[\e[1;32m\]"
GREEN="\[\e[0;32m\]"
nl=$'\n'

function parse_git_branch() 
{
        # Get the git context
        PS1_GIT=""
        CONTEXT=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\(\1\)/')
        if [ -n "${CONTEXT}" ]; then
                CONTEXT='['$(basename `git rev-parse --show-toplevel`)'] '${CONTEXT}
                gits
                git_status=''
                if [[ "${ac}" != "0" ]]; then git_status+=' Add='${ac}; fi
                if [[ "${mc}" != "0" ]]; then git_status+=' Mod='${mc}; fi
                if [[ "${dc}" != "0" ]]; then git_status+=' Del='${dc}; fi
                if [[ "${uc}" != "0" ]]; then git_status+=' Unt='${uc}; fi
                if [[ "${cc}" != "0" ]]; then git_status+=' Ign='${cc}; fi
                if [[ "${ic}" != "0" ]]; then git_status+=' Conflicts='${ic}; fi

                PS1_GIT='(git: '${CONTEXT}
                if [[ "${git_status}" != "" ]]; then PS1_GIT+=' -'${git_status}; fi

                PS1_GIT+=')\n'
        fi
}

function kube_ps1()
{
        # Get current context
        CONTEXT='['$(cat ~/.kube/config 2>/dev/null | grep "current-context:" | sed "s/current-context: //")']'
        PS1_KUBE=""
        if [ -n "${CONTEXT}" ]; then
                CONTEXT+=' ('$(cat ~/.kube/config 2>/dev/null | grep "namespace:" | sed "s/\s*namespace: //")')'
                PS1_KUBE="(k8s: ${CONTEXT})\n"
        fi
}

function terraform_workspace() 
{
        # Check if terraform folder exists where we are
        CURRENT=$(pwd)
        PS1_TFM=""
        if [[ -d "${CURRENT}/.terraform" ]]
        then
                CONTEXT=$(cat ${CURRENT}/.terraform/terraform.tfstate 2>/dev/null | jq '.backend.config.workspaces.name' | sed 's/"//g')
                PS1_TFM="(tfm: ${CONTEXT})\n"
        fi
}

function prepare_prompt()
{
        parse_git_branch
        kube_ps1
        terraform_workspace

        PS1_PROMPT=${PS1_GIT}${PS1_TFM}${PS1_KUBE}
        echo -e "${PS1_PROMPT}"
}

function gits() {
        ac=0 mc=0 dc=0 uc=0 ic=0 cc=0
        local line status
        while read -r line; do
                [ "$line" ] || continue
                status=${line:0:2}
                path=${line:3}
                case "$status" in
                        "M ") ((mc++)) ;;
                        "D ") ((dc++)) ;;
                        "??") ((uc++)) ;;
                        "A ") ((ac++)) ;;
                        "!!") ((ic++)) ;;
                        "AA") ((cc++)) ;;
                        "AU") ((cc++)) ;;
                        "DD") ((cc++)) ;;
                        "DU") ((cc++)) ;;
                        "UD") ((cc++)) ;;
                        "UU") ((cc++)) ;;
                        "UA") ((cc++)) ;;
                        "DD") ((cc++)) ;;
                        *) echo unsupported status on line: $line
                esac
        done <<< "$(git status -s)"
}

source <(kubectl completion bash)
alias k=kubectl
complete -F __start_kubectl k

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

complete -C /usr/local/bin/vault vault

export PS1="${BOLD_YELLOW}\n==> \d \t <==\n${BLUE}(host: \h)\n(path: \w)\n${GREEN}\$(prepare_prompt)\n--> ${NORMAL}"
