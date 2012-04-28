# Git branch
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Command prompts
export PS1="\\w\$(parse_git_branch) > "
export PS2='> '
export PS3='#? '
export PS4='+'

# Text editor
export EDITOR='vim'

alias ..="cd .."

alias ls="ls -G"
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

export CLOJURE_HOME="$HOME/Library/Clojure"
export PYTHONPATH="/usr/local/lib/python2.7/site-packages/:/Users/Wylie/Library/Python/2.7/site-packages/:$PYTHONPATH"

export PATH=$HOME/bin:$PATH
export PATH=/usr/local/sbin:$PATH

# Setup Amazon EC2 Command-Line Tools
export EC2_HOME=~/.ec2
export PATH=$PATH:$EC2_HOME/bin
export EC2_PRIVATE_KEY=`ls $EC2_HOME/pk-*.pem`
export EC2_CERT=`ls $EC2_HOME/cert-*.pem`
export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home/

# rvm loader
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
