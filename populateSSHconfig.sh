#!/bin/bash

# Define the list of PC names
pc_list=("adrastos" "admeta" "aither" "alkmene" "amata" "apate" "ajax" "agylla" "arges" "anaxo" "ares" "atropos" "achilles" "adamas" "alethia" "axylos" "arabia" "acheloos" "aktor" "adanis" "anemoi" "elektra" "eleusius" "eryx" "erebos" "eumolos" "eos" "euros" "eros" "kademos" "kalypso" "kalliste" "kratos" "kreon" "klytios" "kroton" "oikles" "oibalos" "otos" "oidipus" "oxylos" "orestes" "proteus" "priamos" "phoenix" "phobos" "phylla" "pythia" "pandion" "phoebe" "polydora" "polyphem" "penelope" "pegasos" "paris" "pan" "pallas")

# Get the user from command line arguments
user=$1

if [ -z "$user" ]; then
  echo "No user given. Exiting..."
  exit 1
fi

# Check if SSH config file exists, if not create it
filename="$HOME/.ssh/config"
if [ ! -f "$filename" ]; then
  touch "$filename"
fi

# check if header exists in SSH config file
if grep -q "# --- RBI SSH Config ---" "$filename"; then
  echo "RBI SSH Config already exists in $filename"
  exit 0
fi

# Write the PCs to the SSH config file
echo "# --- RBI SSH Config ---" >> "$filename"
echo "" >> "$filename"
echo "Host rbi" >> "$filename"
echo "    HostName adamas.rbi.cs.uni-frankfurt.de" >> "$filename"
echo "    User $user" >> "$filename"
echo "" >> "$filename"
for pc in "${pc_list[@]}"; do
  if grep -q "Host $pc" "$filename"; then
    continue
  else
    echo "Host $pc" >> "$filename"
    echo "    HostName $pc.rbi.cs.uni-frankfurt.de" >> "$filename"
    echo "    User $user" >> "$filename"
    echo "" >> "$filename"
  fi
done
echo "# --- End of RBI SSH Config ---" >> "$filename"

exit 0
