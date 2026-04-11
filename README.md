## bootstrap dot files
./bootstrap.sh

## install fzf
```
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

## install zsh-syntax-highlighting
```
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```
## change prompt format
```
cp $ZSH/themes/${ZSH_THEME}.zsh-theme $ZSH_CUSTOM/themes/
nano $ZSH_CUSTOM/themes/${ZSH_THEME}.zsh-theme

# replace c to d in 
# PROMPT="%(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} ) %{$fg[cyan]%}%d%{$reset_color%}"
```