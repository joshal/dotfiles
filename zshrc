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
    eval "$(jenv init -)"
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
if which pyenv > /dev/null; then
    # initialize pyenv
    eval "$(pyenv init -)"
    # initialize pyenv virtualenv
    eval "$(pyenv virtualenv-init -)"
    # install virtualenvwrapper
    # pyenv virtualenvwrapper
fi

# As suggested with YCM
# https://github.com/Valloric/YouCompleteMe#i-get-fatal-python-error-pythreadstate_get-no-current-thread-on-startup
pyenv() {
    case $* in
        install* ) shift 1; command env CFLAGS="-I$(brew --prefix openssl)/include" LDFLAGS="-L$(brew --prefix openssl)/lib" PYTHON_CONFIGURE_OPTS="--enable-framework --enable-unicode=ucs2" pyenv install "$@" ;;
        * ) command pyenv "$@" ;;
    esac
}

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

pip() {
    case $* in
        install* ) shift 1; command env ARCHFLAGS="-arch x86_64" LDFLAGS="-L/usr/local/opt/openssl/lib" CFLAGS="-I/usr/local/opt/openssl/include" pip install "$@" ;;
        * ) command pip "$@" ;;
    esac
}


#########
# Go
#########

export GOPATH=$HOME/Code/Go
export GOROOT=/usr/local/opt/go/libexec
pathappend $GOPATH/bin $GOROOT/bin

if [ -f ~/.zshrc_work ]; then
    source ~/.zshrc_work
fi
