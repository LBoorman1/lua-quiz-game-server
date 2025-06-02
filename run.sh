#!/bin/bash

# Get the luarocks path so local installation is used
eval "$(luarocks path --bin)"

# Run the project
lua main.lua