echo "sourcing .profile"

[ -f ~/.aliases.local ] && source ~/.aliases.local
[ -f ~/.bashrc.local ] && source ~/.bashrc.local
[ -f ~/.profile.local ] && source ~/.profile.local
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

eval "$(pyenv init -)"
