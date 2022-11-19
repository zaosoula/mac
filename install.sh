SUDO=''
if (( $EUID != 0 )); then
    SUDO='sudo'
fi

echo "Installing/updating Homebrew (https://github.com/Homebrew/brew) ..."
which -s brew
if [[ $? != 0 ]] ; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  brew update
fi

echo "Installing Rectangle (https://github.com/rxhanson/Rectangle) ..."
brew install --cask rectangle

echo "Copying Rectangle config..."
cp ./RectangleConfig.json ~/Library/Application Support/Rectangle/RectangleConfig.json

echo "Installing asimov (https://github.com/stevegrunwell/asimov) ..."
brew install asimov

echo "Activating asimov service..."
$SUDO brew services start asimov

echo "Installing raycast (https://www.raycast.com) ..."
brew install --cask raycast

echo "Installing topgrade (https://github.com/topgrade-rs/topgrade) ..."
brew install topgrade

echo "Copying topgrade config..."
cp ./topgrade.toml ${XDG_CONFIG_HOME:-~/.config}/topgrade.toml

echo "Running topgrade..."
$SUDO topgrade
