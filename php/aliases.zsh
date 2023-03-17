alias qq='exit'
alias :q='exit'

#function lando {
#  # Ensure you have a global plugins directory
#  mkdir -p ~/.lando/plugins
#
#  # Install plugin
#  # NOTE: Modify the "yarn add @lando/php" line to install a particular version eg
#  # yarn add @lando/php@0.5.2
#  docker run --rm -it -v ${HOME}/.lando/plugins:/plugins -w /tmp node:16-alpine sh -c \
#    "yarn init -y \
#    && yarn add @lando/php --production --flat --no-default-rc --no-lockfile --link-duplicates \
#    && yarn install --production --cwd /tmp/node_modules/@lando/php \
#    && mkdir -p /plugins/@lando \
#    && mv --force /tmp/node_modules/@lando/php /plugins/@lando/php" \
#    "$@"
#}
