# Add Homebrew's libpq to PATH for PostgreSQL tools
if [ -d "/opt/homebrew/opt/libpq/bin" ]; then
  export PATH="$PATH:/opt/homebrew/opt/libpq/bin"
else
  warn "Homebrew libpq not found; PostgreSQL tools may not work properly."
fi
