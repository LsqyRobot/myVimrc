export ZSH="/Users/lsqyRobot/.oh-my-zsh"
ZSH_THEME="robbyrussell"
source $ZSH/oh-my-zsh.sh
plugins=(git zsh-autosuggestions	wd extract z)
source /Users/lsqyRobot/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/opt/nvm/nvm.sh
alias pdf='open'
alias m='make all'
alias uml='java -jar /Users/lsqyRobot/Applications/plant.jar -charset UTF-8'
bindkey -v  #vim mode
alias paper='wd great && vim greatThesis.tex' 
alias octave='octave --no-gui'
alias py3='conda activate lsqyPy3'
alias py2='conda activate lsqyPy2'
alias octave='octave-cli'
# added by Anaconda3 2019.10 installer
# >>> conda init >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$(CONDA_REPORT_ERRORS=false '/Users/lsqyRobot/opt/anaconda3/bin/conda' shell.bash h    ook 2> /dev/null)"
if [ $? -eq 0 ]; then
    \eval "$__conda_setup"
else
    if [ -f "/Users/lsqyRobot/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/lsqyRobot/opt/anaconda3/etc/profile.d/conda.sh"
        CONDA_CHANGEPS1=false conda activate base
    else
        \export PATH="/Users/lsqyRobot/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda init <<<
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
