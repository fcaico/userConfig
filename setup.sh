#!/usr/bin/env zsh

mydir=${(%):-%N}
mydir=`dirname $mydir`
mydir=${0:a:h}
echo $mydir

function setup_powerline_fonts {
  destination="${1}"
  echo "Installing powerline fonts"
  cd "${destination}"
  git clone https://github.com/powerline/fonts.git --depth=1
  cd fonts
  ./install.sh
  cd .. && rm -rf fonts
}

function setup_ohmyzsh {
  destination="${1}"
  if [[ ! -d "${destination}/.oh-my-zsh" ]]; then
	echo "Cloning oh-my-zsh from robbyrussel"
  	(cd "${destination}" && git clone https://github.com/robbyrussell/oh-my-zsh.git .oh-my-zsh)
  else
	echo "oh-my-zsh already exists.  Updating."
  	(cd "${destination}/.oh-my-zsh" && git pull origin master)
  fi
}

function setup_dotfiles ()
{
  dotfile_location="${1}"
  dotfiles=(`ls $dotfile_location`)
  destination="${2}"

  for dotfile in "${dotfiles[@]}"
  do
    fullpath_dest="${destination}"/."${dotfile}"
    fullpath_src="${dotfile_location}/${dotfile}"

    [[ -L "${fullpath_dest}" ]] && rm "${fullpath_dest}";
    if [[ -f "${fullpath_src}" ]]; then
      [[ -f "${fullpath_dest}" ]] && rm "${fullpath_dest}"
    fi

    ln -s "${fullpath_src}" "${fullpath_dest}"
	echo ".${dotfile} linked."

  done
}

echo "\nSetting up fonts\n"
setup_powerline_fonts ${mydir}

echo "\nSetting up oh-my-zsh\n"
setup_ohmyzsh ${mydir}

echo "\nSetting up dotfiles\n"
setup_dotfiles ${mydir}/dotfiles ${mydir}/..
