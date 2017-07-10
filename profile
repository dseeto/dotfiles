[ -f ~/.alias.local ] && source ~/.alias.local
[ -f ~/.bashrc.local ] && source ~/.bashrc.local
[ -f ~/.profile.local ] && source ~/.profile.local
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

eval "$(pyenv init -)"
