#!/usr/bin/env bash

# Copy your configuration to a separate folder
export EXPFOLDER="examples-docker"
cp -R examples "$EXPFOLDER"

# remove dev db
for svc in relying_party provider federation_authority; do
  rm -f "$EXPFOLDER/$svc/db.sqlite3"
done

# Definisci variabili semplici invece di un array associativo
AT='s,http://127.0.0.1:8000,http://trust-anchor.org:8000,g'
RP='s,http://127.0.0.1:8001,http://relying-party.org:8001,g'
OP='s,http://127.0.0.1:8002,http://cie-provider.org:8002,g'
WTA='s,http://127.0.0.1:8000,http://wallet.trust-anchor.org:8005,g'

# Apply the rewrite rules for federation_authority, relying_party and provider
for svc in federation_authority relying_party provider; do
  # JSON dump
  sed -e "$AT" -e "$RP" -e "$OP" \
      "examples/$svc/dumps/example.json" \
      > "$EXPFOLDER/$svc/dumps/example.json"

  # settingslocal.py
  sed -e "$AT" -e "$RP" -e "$OP" \
      "examples/$svc/$svc/settingslocal.py.example" \
      > "$EXPFOLDER/$svc/$svc/settingslocal.py"
done

# Apply the rewrite rules for wallet_trust_anchor
# JSON dump
sed -e "$WTA" \
    examples/wallet_trust_anchor/dumps/ta-ec.json \
    > "$EXPFOLDER/wallet_trust_anchor/dumps/ta-ec.json"

# settingslocal.py
sed -e "$WTA" \
    examples/wallet_trust_anchor/wallet_trust_anchor/settingslocal.py.example \
    > "$EXPFOLDER/wallet_trust_anchor/wallet_trust_anchor/settingslocal.py"
