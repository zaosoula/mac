SUDO=''
if (( $EUID != 0 )); then
    SUDO='sudo'
fi

## Install or update Homebrew – https://github.com/Homebrew/brew
which -s brew
if [[ $? != 0 ]] ; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  brew update
fi

## Install Rectangle – https://github.com/rxhanson/Rectangle
brew install --cask rectangle

## Copy Rectangle config
cp ./RectangleConfig.json ~/Library/Application Support/Rectangle/RectangleConfig.json

## Install asimov – https://github.com/stevegrunwell/asimov
brew install asimov

## Activate asimov service
$SUDO brew services start asimov

## Install raycast – https://www.raycast.com
brew install --cask raycast
