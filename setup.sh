#!/bin/bash

# Install lua
if lua -v 2>/dev/null | grep -q "^Lua"; then
  echo "Lua is installed"
else
  sudo apt install lua5.4
fi

# Install luarocks (package manager)
if luarocks --version 2>/dev/null | grep -q "^\/usr\/bin\/luarocks"; then
  echo "Luarocks is installed"
else
  sudo apt install luarocks
fi

# Install requirements
if [ ! -f requirements.txt ]; then
  echo "requirements.txt not found"
  exit 1
fi

while IFS= read -r package || [ -n "$package" ]; do
  package=$(echo "$package" | xargs)
  if [ -n "$package" ]; then
    if luarocks --local list --porcelain | grep -qE "^$package[[:space:]]"; then
      echo "$package is already installed, skipping."
    else
      echo "Installing $package..."
      luarocks install --local "$package"
    fi
  fi
done < requirements.txt
