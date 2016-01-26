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
";
gitattributes="\
*.c   linguist-language=C
*.h   linguist-language=C
*.cpp linguist-language=C++
*.hpp linguist-language=C++
";


#------------------------------------------------------------------------------#
counter()
{
    printf "$#";
}


#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
stepper()
{
    printf "\033[1;35m[\033[1;36m${INDEX}\033[0;35m/\033[0;36m${TOTAL}\033[1;35m] ";
    printf "\033[1;37m$1\033[0m\n";
}


#------------------------------------------------------------------------------#
task_project()
{
    # Create project folder
    stepper "Create project folder: ${FOLDER}";
    mkdir ${FOLDER};
    cd ${FOLDER};
}


#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
task_README()
{
    # Create README file
    stepper "Create file: README.md";
    touch README.md;
}


#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
task_LICENSE()
{
    # Download LICENSE file
    stepper "Download file: LICENSE (GPLv3)";
    wget http://www.gnu.org/licenses/gpl-3.0.txt -O LICENSE;
}


#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
task_mkdirs()
{
    # Create basic folder hierarchy
    stepper "Create folders: src include";
    mkdir src;
    mkdir include;
}


#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
task_main_c()
{
    # Add simple file
    stepper "Create file: src/main.c";
    printf "$main_c" > src/main.c;
}


#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
task_git()
{
    # Make this a git repository
    stepper "Create git repository";
    git init;
    printf "$gitignore" > .gitignore;
    printf "$gitattributes" > .gitattributes
    git add .gitignore .gitattributes;
}


#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
task_tuplet()
{
    # Add tup support
    stepper "Setup git submodule: tuplet";
    git submodule add https://github.com/petervaro/tuplet.git;
    bash tuplet/setup.sh;
}


#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
task_mininstall()
{
    # Add mininstall support
    stepper "Setup git submodule: mininstall";
    git submodule add https://github.com/petervaro/mininstall.git;
    cp mininstall/install.sh .;
    chmod +x install.sh;
}


#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
task_tup()
{
    # Initialize tup
    stepper "Create tup repository";
    tup init;
}


#------------------------------------------------------------------------------#
TASKS="
task_README
task_LICENSE
task_mkdirs
task_main_c
task_git
task_tuplet
task_mininstall
task_tup
";


#------------------------------------------------------------------------------#
# If no project folder name specified
if [ -z "$1" ];
then
    printf "\033[1;31mYou have to specify the project (folder) name!\033[0m\n";
    exit 1;
fi;

# If project folder is not current folder
if [ "$1" != "." ];
then
    TASKS="task_project $TASKS";
fi;

# Execute tasks one-by-one
INDEX=1;
TOTAL=`counter $TASKS`;
FOLDER="$1";
for task in $TASKS;
do
    eval "$task";
    INDEX=$((INDEX+=1))
done;

# Terminate script
exit;
