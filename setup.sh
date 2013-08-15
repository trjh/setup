#!/bin/bash
# Simple setup.sh for configuring Ubuntu 12.04 LTS EC2 instance
# for headless setup. 

# Install heroku (lecture 2)
wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh

sudo add-apt-repository ppa:chris-lea/node.js	# (lecture 3)
sudo add-apt-repository ppa:cassou/emacs	# emacs24

sudo apt-get update		# update list of available packages/versions
sudo apt-get upgrade -q -y	# install newest version of packages
sudo apt-get install -q -y curl

# Install python, nodejs (lecture 3)
sudo apt-get install -q -y python-software-properties python g++ make
sudo apt-get install -q -y nodejs

# Install nvm: node-version manager
# https://github.com/creationix/nvm
sudo apt-get install -q -y git
curl https://raw.github.com/creationix/nvm/master/install.sh | sh

# Load nvm and install latest production node
source $HOME/.nvm/nvm.sh
nvm install v0.10.12
nvm use v0.10.12

# Install jshint to allow checking of JS code within emacs
# http://jshint.com/
npm install -g jshint

# Install cheerio "web scraping" tool,
# https://github.com/MatthewMueller/cheerio
# and commander (command line interpretation)
# https://github.com/visionmedia/commander.js
# and restler
# https://github.com/danwrong/restler
# for grader.js
npm install cheerio
npm install commander
npm install restler

# Install rlwrap to provide libreadline features with node
# See: http://nodejs.org/api/repl.html#repl_repl
sudo apt-get install -q -y rlwrap

# Install emacs24
# https://launchpad.net/~cassou/+archive/emacs
# i don't know why i do this -- i don't use it - trjh
sudo apt-get install -q -y emacs24-nox emacs24-el emacs24-common-non-dfsg

# for HW7
sudo apt-get install -q -y postgresql postgresql-contrib

#
# more misc for me
#
sudo apt-get install -q -y colordiff

# git pull and install dotfiles as well
cd $HOME
if [ -d ./dotfiles/ ]; then
    mv dotfiles dotfiles.old
fi
if [ -d .emacs.d/ ]; then
    mv .emacs.d .emacs.d~
fi

#
# add github.com host keys
#
cat >> ~/.ssh/known_hosts << EOF
|1|TvQ8CXTFkHmtECmKwSfYuyOhZaQ=|MckSEtPnNRW3o28RnSLDi+UpzrM= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
|1|NvgQqxvDK7zN8ni3E6Ojc6rGNjM=|FFBmPApv1Px2zB/LPpq0tN8kJpY= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
EOF

#
# add dotfiles, and other git repositories
#
git clone git@github.com:trjh/dotfiles.git
if [[ $? != 0 ]]; then
    echo git ssh connection failed;
else 
    ln -sb dotfiles/.screenrc .
    ln -sb dotfiles/.bash_profile .
    ln -sb dotfiles/.bashrc .
    ln -sb dotfiles/.bashrc_custom .
    ln -sf dotfiles/.emacs.d .
    ln -sf dotfiles/.vimrc .
    ln -sf dotfiles/.gitconfig .
    ln -sf dotfiles/.colordiffrc
    ln -sf setup/gitcheck.sh

    #
    # download my bitstarter
    #
    git clone git@github.com:trjh/bitstarter.git

    # configure it
    cd bitstarter
    git remote add heroku git@heroku.com:hidden-cove-5100.git
    heroku git:remote -a trjh-bitstarter-s-mooc --remote staging-heroku
    heroku git:remote -a trjh-bitstarter-mooc --remote production-heroku
    # if the latter two don't work, the whole heroku thing might need a login
    # first

    #
    # more HW7
    #
    cd $HOME
    git clone https://github.com/startup-class/bitstarter-ssjs-db.git
    cd bitstarter-ssjs-db
    npm install
    ln -s ../bitstarter/.env
    for i in index.html web.js; do
	mv $i ${i}.bak
	ln -s ../bitstarter/ssjs-$i $i
    done
    mv setup-ssjs.sh setup-ssjs.sh.bak
    ln -s ../bitstarter/setup-ssjs.sh
fi
