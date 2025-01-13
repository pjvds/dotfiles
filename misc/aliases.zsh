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
