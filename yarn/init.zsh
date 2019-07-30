YARN_HOME="$HOME/.yarn"

if [ ! -d "$YARN_HOME" ]; then
  return
fi

export PATH="$YARN_HOME/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
