#!/bin/bash
## INFO ##
## INFO ##

main_c="\
/* INFO **
** INFO */

/*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* Include standard headers */
#include <stdlib.h>
/*  const : EXIT_SUCCESS
            EXIT_FAILURE */

/*----------------------------------------------------------------------------*/
int
main(void)
{
    return EXIT_SUCCESS;
}
";
gitignore="\
## INFO ##
## INFO ##

# Extensions
*.DS_Store
*.pyc
*.pyo
*.sublime-workspace
*.sublime-project
*.so
*.o

# Folders
build-*

# Hidden folders
.tup

# Files
README.html
";
step=1;

stepper()
{
    printf "\033[1;35m[\033[1;36m$((step++))\033[0;35m/\033[0;36m7\033[1;35m]";
    printf "$count \033[1;37m$1\n\033[0m";
}

if [ -z "$1" ];
then
    printf "\033[1;31mYou have to specify the project (folder) name!\033[0m\n";
    exit 1;
fi;

# Create project folder
stepper "Create project folder: $1";
mkdir $1;
cd $1;

# Add README and LICENSE files
stepper "Create file: README.md";
touch README.md;
stepper "Download file: LICENSE (GPLv3)";
wget http://www.gnu.org/licenses/gpl-3.0.txt -O LICENSE;

# Create basic folder hierarchy
stepper "Create folders: src include";
mkdir src;
mkdir include;

# Add simple file
stepper "Create file: src/main.c";
printf "$main_c" > src/main.c;

# Make this a git repository
stepper "Create git repository";
git init;
printf "$gitignore" > .gitignore;
git add .gitignore;

# Add tup support
stepper "Setup git submodule: tuplet";
git submodule add https://github.com/petervaro/tuplet.git;
bash tuplet/setup.sh;

# Initialize tup
stepper "Create tup repository";
tup init;

exit;