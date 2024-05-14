#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# Set desired Python version
GLOBAL_PY="3.12.3"

# Function to check if a command exists
exists() {
  command -v "$1" > /dev/null 2>&1
}

# Function for consistent output formatting
print_msg() {
  echo -e "\n$1\n"
}

# Function for error handling
check_error() {
  if [ $? -ne 0 ]; then
    print_msg "Error: $1"
    exit 1
  fi
}

# Install/update pyenv if not installed
if [ ! -d ~/.pyenv ]; then
  print_msg "Installing pyenv..."
  brew install pyenv
  # Uncomment the lines below for installing pyenv via pyenv-installer script
  # brew install openssl readline sqlite3 xz zlib
  # curl https://pyenv.run | bash
else
  print_msg "pyenv already installed"
fi

# Add pyenv executable to the PATH if not already present
if ! exists pyenv; then
  print_msg "Adding pyenv executable to the PATH"
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
fi

# Enable pyenv shims directory in the PATH if not already enabled
if ! echo "$PATH" | grep --color=auto "$(pyenv root)/shims" > /dev/null 2>&1; then
  print_msg "Adding pyenv shims directory to the PATH"
  eval "$(pyenv init --path)"
fi

# Show available Python 3.12 versions
print_msg "Available Python 3.12 versions:"
pyenv install --list | grep " 3\.[12]"

# Install Python via pyenv if not installed
if ! pyenv versions | grep -q "$GLOBAL_PY"; then
  print_msg "Installing Python $GLOBAL_PY via pyenv"
  pyenv install "$GLOBAL_PY"
fi

# Set up global Python version via pyenv
if ! pyenv global | grep -q "$GLOBAL_PY"; then
  print_msg "Setting up Python $GLOBAL_PY as the global version via pyenv"
  pyenv global "$GLOBAL_PY"
fi

# Verify if Python version is set up correctly
PY="$(python --version)"
if [ "$PY" = "Python $GLOBAL_PY" ]; then
  print_msg "Python $GLOBAL_PY set up correctly"
else
  print_msg "Warning: Python $GLOBAL_PY is NOT set up correctly, still using system version: $PY"
fi

# Install pipx if not installed
if ! brew ls --versions pipx > /dev/null 2>&1; then
  print_msg "Installing pipx..."
  brew install pipx
else
  print_msg "pipx already installed"
fi

# Install or upgrade pipx packages for Python $GLOBAL_PY
print_msg "Installing pipx packages for Python $GLOBAL_PY..."
PIPX_LIST="$(pipx list)"
GLOBAL_PY_PATH="$(pyenv which python)"

while read -r P; do
  if [[ "$PIPX_LIST" =~ "package $P" ]]; then
    print_msg "$P already installed."
  else
    print_msg "Installing $P for $GLOBAL_PY."
    if [[ "$PIPX_LIST" =~ "package $P .*, Python $GLOBAL_PY" ]]; then
      pipx uninstall "$P"
      check_error "Failed to uninstall $P"
    fi
    pipx install --python "$GLOBAL_PY_PATH" "$P"
    check_error "Failed to install $P"
  fi
done < "$SCRIPT_DIR/pipx-requirements.txt"

# Install or upgrade pip packages for Python $GLOBAL_PY
print_msg "Installing pip packages for Python $GLOBAL_PY..."
PIP_LIST="$(pip list --format freeze)"
GLOBAL_PY_PATH="$(pyenv which python)"

while read -r P; do
  if [[ "$PIP_LIST" =~ "$P==" ]]; then
    print_msg "$P already installed."
  else
    print_msg "Installing $P for $GLOBAL_PY."
    pip --python "$GLOBAL_PY_PATH" install "$P"
    check_error "Failed to install $P"
  fi
done < "$SCRIPT_DIR/pip-requirements.txt"

print_msg "Script '$0' execution completed successfully"
