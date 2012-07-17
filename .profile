# vim:set syntax=sh:

# Hard drives and memory are cheap. Keep 10,000 lines of history and
export HISTSIZE=10000
# don't limit the size of the history file.
unset HISTFILESIZE
# ignore dupes in bash
export HISTCONTROL=ignoreboth


# http://www.gnu.org/software/bash/manual/html_node/Bash-History-Builtins.html#Bash-History-Builtins
# We are going to store each session as a separate file, with the IP addr
bash_hist=$HOME/.history_bash
sship=`echo $SSH_CLIENT | awk '{print $1}'`
test -d $bash_hist || mkdir $bash_hist
export HISTFILE=$bash_hist/hist-$sship-`date +%Y-%m-%d-%H-%M-%S`.hist

# Clean up files based on $MAX_DAYS
MAX_DAYS=180
if [ "$MAX_DAYS" != "" ] ; then
    find $bash_hist -mtime +$MAX_DAYS | xargs rm -rf
fi

# Read in history from the previous history files, up until we hit HISTSIZE
for file in `ls -1tr $bash_hist`; do
    history -r $bash_hist/$file
    if [ `history | wc -l` -gt $HISTSIZE ] ; then
        break
    fi
done

########### Always use vim
export SVN_EDITOR=`which vim`
export EDITOR=`which vim`