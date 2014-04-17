# system-wide bashrc
if [ -f /etc/bashrc ]; then
  source /etc/bashrc
fi

# personal bashrc
if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi
