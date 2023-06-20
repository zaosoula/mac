SUDO=''
if (( $EUID != 0 )); then
    SUDO='sudo'
fi


function install_brew_formula() {
  formulaName=$1
  formulaInfo="$(brew info --json=v2 "$formulaName")"
  formulaInstalled="$(printf "%s" "$formulaInfo" | jq '.formulae[0].installed | length > 0')"
  formulaHomepage="$(printf "%s"  "$formulaInfo" | jq -r '.formulae[0].homepage')"

  if [ $formulaInstalled != "true" ]; then
    echo "Installing $formulaName ($formulaHomepage) ..."
    brew install $1
  else
    echo "$formulaName is already installed"
    return 1
  fi
}

function install_brew_cask() {
  caskName=$1
  caskInfo="$(brew info --json=v2 "homebrew/cask/$caskName")"
  appName="$(printf "%s" "$caskInfo" | jq -r '.casks[0].artifacts[] | select(has("app")) | .app[0]')"
  caskHomepage="$(printf "%s" "$caskInfo" | jq -r '.casks[0].homepage')"

  if [[ ! -d "/Applications/$appName" ]]; then
    echo "Installing $appName ($caskHomepage) ..."
    brew install --cask $1
  else
    echo "$appName is already installed"
    return 1
  fi
}

function start_brew_service() {
  serviceName=$1
  serviceInfo=$(brew services info $serviceName --json)
  serviceStatus=$(node -pe 'JSON.parse(process.argv[1])[0].loaded' "$serviceInfo")

  if [ $serviceStatus != "true"  ]; then
    echo "Activating $serviceName service..."
    $SUDO brew services start $serviceName
  else
    echo "$serviceName is already running"
  fi
}

echo "Installing/updating Homebrew (https://github.com/Homebrew/brew) ..."
which -s brew
if [[ $? != 0 ]] ; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  brew update
fi

brew install jq -q

install_brew_formula asimov
install_brew_formula topgrade

echo "Copying topgrade config..."
cp ./topgrade.toml ${XDG_CONFIG_HOME:-~/.config}/topgrade.toml

install_brew_formula git
install_brew_formula nvm
install_brew_formula pnpm
install_brew_formula wget
install_brew_formula temurin


install_brew_cask rectangle
if [[ $? -eq 0 ]]
then 
  echo "Copying Rectangle config..."
  cp ./RectangleConfig.json "~/Library/Application Support/Rectangle/RectangleConfig.json"
fi

install_brew_cask notion
install_brew_cask raycast
install_brew_cask github
install_brew_cask brave-browser
install_brew_cask 1password
install_brew_cask spotify
install_brew_cask visual-studio-code
install_brew_cask discord
install_brew_cask readdle-spark
install_brew_cask figma
install_brew_cask postman
install_brew_cask docker
install_brew_cask cyberduck
install_brew_cask cakebrew

defaults write com.apple.Finder AppleShowAllFiles true

echo "Activating asimov service..."
$SUDO bash -c "$(declare -f start_brew_service); start_brew_service asimov"

./update.sh
