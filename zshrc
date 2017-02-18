export TERM="xterm-256color"

if [ -f ~/.zshrc_scripts ]; then
    source ~/.zshrc_scripts
fi

if [ -f ~/.zshrc_omz ]; then
    source ~/.zshrc_omz
fi

if [ -f ~/.zshrc_local ]; then
    source ~/.zshrc_local
fi

if [ -f ~/.zshrc_work ]; then
    source ~/.zshrc_work
fi
