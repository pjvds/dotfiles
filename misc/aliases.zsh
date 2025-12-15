# Description: A collection of useful zsh aliases and functions

# Aliases
alias rm='rm -r'
alias .='cd $DOTFILES'
alias .v='cd $DOTFILES && vim .'
alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias tailf='tailf -f'

alias jd="cd ~/Downloads"
alias jdf="cd $DOTFILES"
alias jc="cd ~/Code"
alias jcd="cd ~/Code/deloitte"

# enhanced ls - use 'll' as function name to avoid conflict with zim's 'll' alias
# Unalias ll from zim utility module first
unalias ll 2>/dev/null
ll() {
  if [[ "$PWD" == "$HOME/Downloads" ]]; then
    # Reverse creation-date sort
    ls -lAh -Utr
  else
    ls -lah
  fi
}
# Keep 'l' as shorthand alias
alias l=ll

#cwd
homerow() {
	echo " A  ,  S ,  D ,   F       J  ,  K ,  L ,  ;"
	echo "Ctrl, Alt, GUI, Shift - Shift, GUI, Alt, Ctrl"
}

synctime() {
	sudo ntpdate -u 0.nl.pool.ntp.org
}

# Get the key id (KID) of the public key part in a certificate
kid() {
# Input CRT file
	CRT_FILE="$1"
	DER_FILE=$(mktemp)

	# Extract the public key in DER format
	openssl x509 -in "$CRT_FILE" -pubkey -noout 2> /dev/null | openssl rsa -pubin -outform DER -out $DER_FILE 2> /dev/null

	# Compute the SHA-256 hash of the public key
	SHA256_HASH=$(openssl dgst -sha256 -binary "$DER_FILE" 2> /dev/null | xxd -p -c 256)

	# Convert hash to Base64-URL format (remove padding and replace characters)
	KID=$(echo -n "$SHA256_HASH" | xxd -r -p | base64 | tr '+/' '-_' | tr -d '=')

	# Output the KID
	echo $KID

	# Clean up the temporary file
	rm $DER_FILE
}
