source ~/.bashrc

# npm
export PATH=/usr/local/share/npm/bin:$PATH
export NODE_PATH=/usr/local/share/npm/lib/node_modules

# php
export PATH=/usr/local/opt/php53/bin:$PATH

# pyenv
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

# rvm
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
