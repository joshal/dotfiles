zmodload zsh/zprof

# Clear PATH variable since tmux always sources /etc/profile as it runs as a login shell -
# See, https://superuser.com/a/583502
if [ -n "$TMUX" ] && [ -f /etc/profile ]; then
    PATH=""
    source /etc/profile
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [ -f ~/.zshrc_scripts ]; then
    source ~/.zshrc_scripts
fi

if [ -f ~/.zshrc_zplug ]; then
    source ~/.zshrc_zplug
fi

# User configuration

#######
# paths
#######

pathprepend "$(brew --prefix)/sbin"

########
# vim
########

alias vim='mvim -v'

if type nvim > /dev/null 2>&1; then
    alias vim='nvim'
    export VISUAL=nvim
    export EDITOR="$VISUAL"
fi

########
# direnv
########

eval "$(direnv hook zsh)"

#########
# ripgrep
#########

export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

#########
# fzf
#########

# Command line fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Setting ag as the default source for fzf
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow -g "!.git/*"'

# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Default options for fzf
export FZF_DEFAULT_OPTS="--reverse --inline-info"

#########
# jenv
#########

export JENV_ROOT="$HOME/.jenv"
if which jenv > /dev/null; then
    # initialize jenv
    eval "$(jenv init - --no-rehash)"
    # start background rehashing process, see
    # https://github.com/gcuisinier/jenv/issues/148#issuecomment-230259636
    (jenv rehash &) 2> /dev/null
    # XXX: There seems to be an issue with maven where in the M2_HOME variable is set by default and
    # pointing to a wrong location. We use the maven plugin enabled with jenv so that maven can find
    # the JAVA_HOME variable it needs. The jenv enabled maven fails because of the wrong M2_HOME
    # environment variable. Hence we unset it here.
    # https://github.com/gcuisinier/jenv#plugins
    unset M2_HOME
fi

#########
# pyenv
#########

export PYENV_ROOT="$HOME/.pyenv"
if command -v pyenv > /dev/null; then
    # initialize pyenv
    eval "$(pyenv init --path)"
    # initialize pyenv virtualenv
    eval "$(pyenv virtualenv-init -)"
    # install virtualenvwrapper
    # pyenv virtualenvwrapper

    # As suggested with YCM
    # https://github.com/Valloric/YouCompleteMe#i-get-fatal-python-error-pythreadstate_get-no-current-thread-on-startup
    pyenv() {
        case $* in
            install* ) shift 1; command env CFLAGS="-I$(brew --prefix openssl)/include -I$(xcrun --show-sdk-path)/usr/include" LDFLAGS="-L$(brew --prefix openssl)/lib" PYTHON_CONFIGURE_OPTS="--enable-framework --enable-unicode=ucs2" pyenv install "$@" ;;
            doctor ) shift 1; command env CFLAGS="-I$(brew --prefix openssl)/include" LDFLAGS="-L$(brew --prefix openssl)/lib" PYTHON_CONFIGURE_OPTS="--enable-framework --enable-unicode=ucs2" pyenv doctor ;;
            * ) command pyenv "$@" ;;
        esac
    }
fi

#######
# rbenv
#######

export RBENV_ROOT="$HOME/.rbenv"
if which rbenv > /dev/null; then
    # initialize rbenv
    eval "$(rbenv init -)"
fi

#######
# pip
#######

if command -v pip > /dev/null; then
    pip() {
        case $* in
            install* ) shift 1; command env ARCHFLAGS="-arch x86_64" LDFLAGS="-L/usr/local/opt/openssl/lib" CFLAGS="-I/usr/local/opt/openssl/include" pip install "$@" ;;
            * ) command pip "$@" ;;
        esac
    }
fi


if [ -f ~/.zshrc_work ]; then
    source ~/.zshrc_work
fi

#########
# autojump
#########

[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

#########
# override lib/completion.zsh
#########
WORDCHARS=''

#########
# powerlevel10k
#########

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#########
# git
#########

# When you're on your fork, simply type 'update' to update your master. This will rebase all your current changes on top of upstream/master.
alias update="git checkout master && git fetch --tags -f upstream && git rebase upstream/master && git push origin HEAD:master"

# Created by `pipx` on 2021-05-18 20:36:24
export PATH="$PATH:/Users/jdaftari/.local/bin"

#########
# zoxide
#########
eval "$(zoxide init zsh)"
