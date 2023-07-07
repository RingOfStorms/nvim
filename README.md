
# Neovim config

Backup existing config:
```
DATE=$(date +"%Y%m%d")
mv ~/.config/nvim ~/.config/nvim_$DATE.bak
mv ~/.local/share/nvim ~/.local/share/nvim_$DATE.bak
mv ~/.local/state/nvim ~/.local/state/nvim_$DATE.bak
```
or remove existing config:
```
rm -rf ~/.config/nvim 
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim 
```

## Install
```
git clone https://github.com/RingOfStorms/nvim ~/.config/nvim
nvim --headless "+Lazy! sync" +qa
hyperfine "nvim --headless +qa"
```



## Useful links
- [Lazy Events](https://github.com/folke/lazy.nvim#-user-events)

