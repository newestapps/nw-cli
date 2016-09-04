#!/bin/bash

NWREPO_FOLDER_TREE="https://github.com/newestapps/nw-folder-structure.git"
NWREPO_LARAVEL_STRUCTURE="https://github.com/newestapps/nw-laravel.git"

if [ "$1" = "self-update" ]
then

	echo -e "\033[37;44;1mSelf Update - NW CLI\033[0m";

	sudo curl -X GET "https://newestapps.com.br/cli/install.sh" > install.sh
	sudo chmod 777 install.sh
	sudo ./install.sh;

else

	VERSION="1.0"

	# Execute everything that is necessary as sudo, if is executing as sudo :D
	SUDO=""

	if [ `whoami` = "root" ]
	then
		SUDO="sudo"
	fi

	# Starts index for options
	OPTION_INDEX=1

	# Store the current directory
	CURRENT_DIR=`pwd`"/"

	# Save the selected option for future parce
	SELECTED_OPTION_INDEX="-1"

	function wanip(){
		dig +short myip.opendns.com @resolver1.opendns.com
	}

	function fillLineWith(){
		cols=`tput cols`;
		for (( c=1; c<=$cols; c++ ))
		do
			echo -ne "$1";
		done;
	}

	function separator(){
#		fillLineWith "\033[37;1m~"
#		br
		echo -e "\033[37;1m~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~"
	}

	function chooseOption(){
		tput sc;
		cols=`tput cols`;
		lines=`tput lines`;
		lines=$(($lines))
		
		tput cup $lines 0;
	
		tput setab 2
		tput setaf 0
		fillLineWith " "
		
		tput cup $lines 2
		
		echo -n "Choose your option: "
		read SELECTED_OPTION_INDEX
		
		tput sgr0
		tput rc
	}
	
	function calculateCenter(){
		cols=`tput cols`;
		center=$(( ( cols / 2 ) - ( $1 / 2 ) ))
		echo $center;
	}

	function pageTitle(){
		tput sc;
		cols=`tput cols`;
		lines=`tput lines`;
		
		tput cup 0 0;
	
		tput setab 1
		tput setaf 7
		fillLineWith " "
		
		# Posiciona no centro da linha para escrever o titulo.
		
		titleCharCount=`echo $1 | wc -c`
		startCol=`calculateCenter $titleCharCount`
		
		tput cup 0 $startCol
		
		echo -n $@
		
		
		if [ "$SUDO" = "sudo" ]
		then
			tput setab 4
			tput setaf 7
			tput cup 1 0
			fillLineWith " "

			sudoMessage="Running as SUDO"
			titleCharCount=`echo $sudoMessage | wc -c`
			startCol=`calculateCenter $titleCharCount`

			tput cup 1 $startCol
			echo -e "$sudoMessage"
		fi
		
		tput sgr0
		tput rc
}

	function header(){
		clear

		echo -ne "\033[0;1m"

		if [ "$SUDO" = "sudo" ]
		then
			echo -e "\033[30;43;1m                    Running as SUDO                    \033[0m"
		fi

		echo -ne "\033[0;1m"
		echo "                                                       "
		echo -e " _   _                      \033[31;1m  _ \033[0;1m                       "
		echo -e "| \\ | | ___\033[31;1m__      _____  ___| |_ \033[0;1m__ _ _ __  _ __  ___ "
		echo -e "|  \\| |/ _ \033[31;1m\\ \\ /\\ / / _ \\/ __| __\033[0;1m/ _\` | '_ \\| '_ \\/ __|"
		echo -e "| |\\  |  __/\033[31;1m\\ V  V /  __/\\__ \\ |\033[0;1m| (_| | |_) | |_) \\__ \\"
		echo -e "|_| \\_|\\___| \033[31;1m\\_/\\_/ \\___||___/\\__\033[0;1m\\__,_| .__/| .__/|___/"
		echo "                                      |_|   |_|        "
		echo -e "\033[0;1m"
		echo -e "      Welcome to \033[31;1mNew West Apps\033[0;1m Assistant v${VERSION}           "
		echo -e "\033[0;1m"

		separator
		echo -e "\033[0m"
	}

	echo -ne "\033[0;1m"

	function ask(){
		echo -ne "\033[31;1m>> \033[0;1m${1}\033[0m";
	}

	function start_options(){
		OPTION_INDEX=1
		echo "";
	}

	function option(){
		echo -e " \033[32m${1}  \033[0m${2}"
#		OPTION_INDEX=$(($OPTION_INDEX + 1))
	}

	function choose_option(){
		echo -ne "\033[32mChoose your option:\033[0;1m "
		read SELECTED_OPTION_INDEX
		echo -ne "\033[0m"
	}

	function br(){
		echo ""
	}

	function log(){
		echo -e ">> $@"
	}

	function logGreen(){
		echo -ne "\033[32m"
		log "$@"
		echo -ne "\033[0m"
	}

	function writeCiano(){
		echo -e "\033[36;1m$@\033[0m"
#		pageTitle $@
	}

	function pressEnterContinue(){
		br
		echo -en "\033[30;47mPress (enter) to continue\033[0m"
		read -p "" c
	}


	function intro(){
		header
		
		ask "Server Configuration"
		br
		start_options

		option 1 "Set env variables for this Server" # 1
		option 2 "View server information" # 4

		br
		ask "Project creation/configuration"
		br
		br
		
		option 3 "Create enviroment for automatic deploy using GIT" # 2
		option 4 "Create empty project" # 3

		br
		ask "Help notes"
		br
		br

		option 5 "How to authorize new SSH Key for Git Deployer" # 5

		br
		separator
		br

		option 0 "Exit"
		
		br

		choose_option
	}

	function ucfirst(){
		vari="$1"
		uc="$(tr '[:lower:]' '[:upper:]' <<< ${vari:0:1})${vari:1}"
		echo $uc
	}
	
	function checkboxInfo() {
		echo -ne "\033[1m ["
	
		if [ "$1" == "true" ] || [ "$1" == "1" ] || [ "$1" == "y" ] || [ "$1" == "Y" ]
		then
			echo -ne "\033[32;1m OK \033[0;1m";
		else
			echo -ne "\033[31;1mFAIL\033[0;1m";
		fi
		
		echo -ne "] \033[0m${2}"
		
		br
	}

	####################################################################
	# Cria os diretórios para a commandline  ~/.newestapps

	NW_BASE="$HOME/.newestapps"
	NW_BASE__CONFIG="$NW_BASE/config"

	SERVER_USER=""
	SERVER_DOMAIN=""

	while [ "$SELECTED_OPTION_INDEX" != "0" ]
	do

		if [ ! -d "$NW_BASE" ]
		then
			$SUDO mkdir "$NW_BASE"
			SELECTED_OPTION_INDEX="1"
		else

			if [ ! -f "$NW_BASE__CONFIG" ]
			then
				SELECTED_OPTION_INDEX="1"
			else
				source $NW_BASE__CONFIG
				intro
			fi

		fi

		###############################################################################

		#  ____             _     _____                
		# / ___|  ___ _ __ | |_  | ____|_ ____   _____ 
		# \___ \ / _ \ '_ \| __| |  _| | '_ \ \ / / __|
		#  ___) |  __/ | | | |_  | |___| | | \ V /\__ \
		# |____/ \___|_| |_|\__| |_____|_| |_|\_/ |___/

		# Inicia processo de setar variaveis ambiente para este servidor
		if [ "$SELECTED_OPTION_INDEX" = "1" ]
		then

			header
			
			writeCiano "Set env variables for this Server";
			
			br

			HINT=""
			if [ "$SERVER_USER" != "" ]
			then
				HINT=" ($SERVER_USER)"
			fi

			ask "Server username$HINT: "
			read -p "" SERVER_USER_NEW

			if [ ! "$SERVER_USER_NEW" = "" ]
			then
				SERVER_USER="$SERVER_USER_NEW"
			fi

			###########--------------------------------

			HINT=""

			if [ "$SERVER_DOMAIN" != "" ]
			then
				HINT=" ($SERVER_DOMAIN)"
			fi

			ask "Server domain/ip$HINT: "
			read -p "" SERVER_DOMAIN_NEW

			if [ ! "$SERVER_DOMAIN_NEW" = "" ]
			then
				SERVER_DOMAIN="$SERVER_DOMAIN_NEW"
			fi

			###########--------------------------------

			HINT=""

			if [ "$SERVER_DISTRO" != "" ]
			then
				HINT=" (Current: $SERVER_DISTRO)"
			fi

			ask "Server distro"
			echo ""
			read -p "   Type one of this [osx/ubuntu/centos]$HINT: " SERVER_DISTRO_NEW

			if [ ! "$SERVER_DISTRO_NEW" = "" ]
			then
				SERVER_DISTRO="$SERVER_DISTRO_NEW"
			fi

			if [ "$SERVER_DISTRO" = "osx" ]
			then
				PKGMANAGER=""
			fi

			if [ "$SERVER_DISTRO" = "ubuntu" ]
			then
				PKGMANAGER="apt-get"
			fi

			if [ "$SERVER_DISTRO" = "centos" ]
			then
				PKGMANAGER="yum"
			fi

			####

			wanIP=`wanip`

			echo "SERVER_USER=$SERVER_USER" > "$NW_BASE__CONFIG"
			echo "SERVER_DOMAIN=$SERVER_DOMAIN" >> "$NW_BASE__CONFIG"
			echo "SERVER_DISTRO=$SERVER_DISTRO" >> "$NW_BASE__CONFIG"
			echo "PKGMANAGER=$PACKAGE_MANAGER_FOR_DISTRO" >> "$NW_BASE__CONFIG"
			echo "WATCH_LIST_COMMANDS=$NW_BASE/watchCommandsList" >> "$NW_BASE__CONFIG"
			echo "WAN_IP=$wanIP" >> "$NW_BASE__CONFIG"

			br

			logGreen "Configs Saved!"
			
			br
			
			log "Checking dependencies..."
			
			# Verifica dependencias
			
			if [ `command -v git` = "" ]
			then
				ask "GIT is not installed, would you like to install?"
				echo ""
				read -p "   run  *sudo $PKGMANAGER install git*  ? (Y/n): " INSTALL_GIT
				
				if [ "$INSTALL_GIT" = "" ] || [ `ucfirst "$INSTALL_GIT"` = "Y" ]
				then
					sudo $PKGMANAGER install git
				fi
			else
				logGreen "git is installed"
			fi
			
			
			if [ `command -v php` = "" ]
			then
				log "PHP is not installed, would you like to install?"
			else
				logGreen "php is installed"
			fi
			
			
			br
			logGreen "CONFIGURATION DONE!"

			pressEnterContinue

		fi

		###############################################################################

		#   ____               ____ ___ _____   ____             _             
		#  / ___| ___ _ __    / ___|_ _|_   _| |  _ \  ___ _ __ | | ___  _   _ 
		# | |  _ / _ \ '_ \  | |  _ | |  | |   | | | |/ _ \ '_ \| |/ _ \| | | |
		# | |_| |  __/ | | | | |_| || |  | |   | |_| |  __/ |_) | | (_) | |_| |
		#  \____|\___|_| |_|  \____|___| |_|   |____/ \___| .__/|_|\___/ \__, |
		#                                                 |_|            |___/ 

		# Inicia processo de criar um projeto de deploy.. Necessita git instalado.
		if [ "$SELECTED_OPTION_INDEX" = "3" ]
		then

			header
			writeCiano "Create enviroment for automatic deploy using GIT"
			br

			log "Checking git"

			GIT_VERSION=`git --version`
			log "Using ${GIT_VERSION}"

			###
			PROJECT_ALIAS="newProject"
			CREATE_BETA_COPY="y"
			###

			ask "Where is the project alias? Use variable sintax! (ex. new-android-app): "
			read -p "" PROJECT_ALIAS

			if [ "$PROJECT_ALIAS" = "" ]
			then
				PROJECT_ALIAS="newProject" # TODO - Concat newProject unnamed ID.
			fi

			logGreen "Using *${PROJECT_ALIAS}* as project alias"

			###
			SOURCE_PROJECT_PATH="/var/www/${PROJECT_ALIAS}"
			GIT_BARE_PATH="/var/repo/${PROJECT_ALIAS}"
			###

			ask "Where is the path for Source Code of project? (Current: $SOURCE_PROJECT_PATH/production): "
			read -p "" SOURCE_PROJECT_PATH

			if [ "$SOURCE_PROJECT_PATH" = "" ]
			then
				SOURCE_PROJECT_PATH="/var/www/${PROJECT_ALIAS}"
			fi

			logGreen "Using path *${SOURCE_PROJECT_PATH}* for project source files"

			###

			ask "Where is the path for Git Bare files of project? (Recomended: $GIT_BARE_PATH/production.git): "
			read -p "" GIT_BARE_PATH

			if [ "$GIT_BARE_PATH" = "" ]
			then
				GIT_BARE_PATH="/var/repo/${PROJECT_ALIAS}"
			fi

			logGreen "Using path *${GIT_BARE_PATH}* for git bare structure files"

			###

			ask "Do you want to create a BETA version too? (Y/n): "
			read -p "" CREATE_BETA_COPY

			if [ "$CREATE_BETA_COPY" = "" ]
			then
				CREATE_BETA_COPY="y"
			fi

			logGreen "Two envs will be created, for PRODUCTION and BETA releases."

			###

			HAS_ALREADY_STARTED_GIT="0"

			function createEnv(){
				## https://www.digitalocean.com/community/tutorials/how-to-set-up-automatic-deployment-with-git-with-a-vps

				local envName="$1"
				local fullSourcePath="$SOURCE_PROJECT_PATH/$envName"
				local fullGitPath="$GIT_BARE_PATH/$envName.git"

				#### Create folders
				$SUDO mkdir -p "$fullSourcePath"
				$SUDO mkdir -p "$fullGitPath"

				cd "$fullGitPath"
				gitInitOutput=`$SUDO git init --bare`
				logGreen $gitInitOutput

				$SUDO chmod -R 777 "$SOURCE_PROJECT_PATH"
				$SUDO chmod -R 777 "$GIT_BARE_PATH"

				cd hooks
				$SUDO echo "#!/bin/sh" >> post-receive
				$SUDO echo 'git --work-tree="'$fullSourcePath'" --git-dir="'$fullGitPath'" checkout -f' >> post-receive

				$SUDO chmod +x post-receive

				## Open Source folder
				cd "$fullSourcePath"
				gitInitOutput=`$SUDO git init`
				logGreen $gitInitOutput

				br
				echo -e "\033[37;44m  Execute the commands below in the root path of your project (in your local development machine) \033[0m"

				if [ "$HAS_ALREADY_STARTED_GIT" = "0" ]
				then
					echo -e "\033[0;36m      git init "
					HAS_ALREADY_STARTED_GIT="1"
				fi	

				echo -e "\033[0;36m      git remote add $envName ${SERVER_USER}@${SERVER_DOMAIN}:${fullGitPath} "

				br

				## Back to starting directory
				cd $CURRENT_DIR

			}

			## PRODUCTION Env
			createEnv "production"

			#### Create BETA folders if user wants.
			if [ "$CREATE_BETA_COPY" = "y" ]
			then
				## BETA Env
				createEnv "beta"
			fi

			## Reset controls
			HAS_ALREADY_STARTED_GIT="0"

			pressEnterContinue

		fi

		###############################################################################

		#  _____                 _           ____            _           _   
		# | ____|_ __ ___  _ __ | |_ _   _  |  _ \ _ __ ___ (_) ___  ___| |_ 
		# |  _| | '_ ` _ \| '_ \| __| | | | | |_) | '__/ _ \| |/ _ \/ __| __|
		# | |___| | | | | | |_) | |_| |_| | |  __/| | | (_) | |  __/ (__| |_ 
		# |_____|_| |_| |_| .__/ \__|\__, | |_|   |_|  \___// |\___|\___|\__|
		#                 |_|        |___/                |__/               		

		# Inicia processo de criar a estrutura de pastas de um projeto NW
		if [ "$SELECTED_OPTION_INDEX" = "4" ]
		then

			header

			writeCiano "Create empty project"
			br

			ask "What is the project name?: "
			read -p "" PROJECT_NAME

			ask "What is the project alias?: "
			read -p "" PROJECT_ALIAS

			ask "Project root path: (will be created an directory for with alias): "
			read -p "" PROJECT_ROOT_PATH

			ask "Want to create a new Laravel Application for this project? "
			echo ""
			read -p "(Leave empty for NO, type a folder name for YES):" CREATE_LARAVEL_APP


			if [ ! -d "$PROJECT_ROOT_PATH" ]
			then
				log "Creating directories for root path *$PROJECT_ROOT_PATH*"
				$SUDO mkdir -p "$PROJECT_ROOT_PATH"
			else
				log "Entering project root path..."
			fi

			cd "$PROJECT_ROOT_PATH"

			repository="$NWREPO_FOLDER_TREE"

			clone=`git clone $repository "$PROJECT_ALIAS" > temp`
			clone=`cat temp`

			if [ ! "$clone" ]
			then

				cd "$PROJECT_ALIAS"

				echo "PROJECT_NAME=$PROJECT_NAME" > ".newestapps"
				echo "PROJECT_ALIAS=$PROJECT_ALIAS" >> ".newestapps"
				echo "BASE_REPO=$repository" >> ".newestapps"

				comm=`git add . >> temp`
				comm=`git commit -m "Created project $PROJECT_NAME with Newestapps CLI"`

				logGreen "Created project $PROJECT_NAME with Newestapps CLI"

			else

				log "$clone"

			fi

			if [ -f "temp" ]
			then
				rm temp
			fi


			if [ ! "$CREATE_LARAVEL_APP" = "" ]
			then

				cd "4-Implementations"

				clone=`git clone $NWREPO_LARAVEL_STRUCTURE "$CREATE_LARAVEL_APP" > temp`
				clone=`cat temp`

				cd "$CREATE_LARAVEL_APP"

				composer install
				composer update

				appName=`ucfirst $CREATE_LARAVEL_APP`

				php artisan app:name $appName
				php artisan key:generate
				php artisan vendor:publish
				

			fi

			pressEnterContinue

		fi



		###############################################################################

		#  ____                             ___        __       
		# / ___|  ___ _ ____   _____ _ __  |_ _|_ __  / _| ___  
		# \___ \ / _ \ '__\ \ / / _ \ '__|  | || '_ \| |_ / _ \ 
		#  ___) |  __/ |   \ V /  __/ |     | || | | |  _| (_) |
		# |____/ \___|_|    \_/ \___|_|    |___|_| |_|_|  \___/     


	
		
		# Verifica dependências instaladas
		if [ "$SELECTED_OPTION_INDEX" = "2" ]
		then

			header

			writeCiano "Server Information"
			br
			
			echo -ne " \033[0;1mOS Version:\033[0m "
			uname -mrs
			
			echo -ne " \033[0;1mCurrent user:\033[0m "
			whoami
			
#			lanIP=`wanip`
			echo -e " \033[0;1mLAN IP Address:\033[0m $lanIP"
			echo -e " \033[0;1mWAN IP Address:\033[0m $WAN_IP"

			br
			
			writeCiano "Installed componentes"
			
			br
			
			fileListOfCommands="$WATCH_LIST_COMMANDS"
			
			if [ ! -e "$fileListOfCommands" ]
			then
				> $fileListOfCommands;
				echo "git" >> $fileListOfCommands;
				echo "php" >> $fileListOfCommands;
				echo "figlet" >> $fileListOfCommands;
				echo "zip" >> $fileListOfCommands;
				echo "unzip" >> $fileListOfCommands;
				echo "tar" >> $fileListOfCommands;
				echo "curl" >> $fileListOfCommands;
				echo "wget" >> $fileListOfCommands;
				echo "glances" >> $fileListOfCommands;
				echo "python" >> $fileListOfCommands;
				echo "java" >> $fileListOfCommands;
				echo "javac" >> $fileListOfCommands;
				echo "gcc" >> $fileListOfCommands;
				echo "g++" >> $fileListOfCommands;
			fi
			
			commandsToCheck=`cat "$fileListOfCommands"`
		
			for cmd in $commandsToCheck
			do
			
				bin=`command -v "$cmd"`
				
				if [ "$bin" == "" ]
				then
					checkboxInfo false "$cmd"
				else
				
#					binVersion=`$cmd --version`
					
#					if [ "$binVersion" == "" ]
#					then
#						binVersion=`$cmd -v`
#					fi
					
#					checkboxInfo true "$cmd \033[0;37m --> \033[0m $bin  \033[0;37mVersion:\033[0m $binVersion"
					checkboxInfo true "$cmd \033[0;37m --> \033[0m $bin"
				fi
				
			done

			pressEnterContinue

		fi



		###############################################################################

		#  _   _      _       
		# | | | | ___| |_ __  
		# | |_| |/ _ \ | '_ \ 
		# |  _  |  __/ | |_) |
		# |_| |_|\___|_| .__/ 
		#              |_|    

		# Verifica dependências instaladas
		if [ "$SELECTED_OPTION_INDEX" = "5" ]
		then

			header

			writeCiano "How to authorize new SSH Key for Git Deployer"
			br

			log "First, add a new user for security purposes."
			log "For default, we use the username *git*"
			log "Run the folowing commands to create the user"
			log "   sudo adduser git"
			log "Type one password for user, and follow the steps."
			log "Now log in as the new user"
			log "   su git"
			log "Create the ssh needed directories and files"
			log "   cd"
			log "   mkdir .ssh"
			log "   chmod 700 .ssh"
			log "   > .ssh/authorized_keys"
			log "   chmod 600 .ssh/authoried_keys"
			br
			log "Now, in your local development machine, create a new SSH Key."
			log "   ssh-keygen"
			log "Get the public key hash (assume we created in /Users/newestapps/.ssh/myKey)"
			log "   cat /Users/newestapps/.ssh/myKey.pub"
			log "Copy the output and back to remote server"
			log "Append the copied public key to the authorized_keys file, we just created"
			log " using nano, or other append technic."
			log "And now, you are good to go! Enjoy"

			pressEnterContinue

		fi
		
		
		### EXIT
		
		if [ "$SELECTED_OPTION_INDEX" = "0" ]
		then
			tput sgr0
			echo -e "\033[0m" 
			exit
		fi

	done

	tput sgr0
	echo -e "\033[0m"
		
fi

tput sgr0
echo -e "\033[0m"