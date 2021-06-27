#---------- Create various symlinks ---------- 

# Assumes directories actually exist on new host
# Call this from home dir

p=~/icloud/dot-files

ln -sfF ${p}/.zshrc ~/.zshrc
ln -sfF ${p}/.alacritty.yml ~/.config/alacritty/alacritty.yml
ln -sfF ${p}/.tmux.conf ~/.tmux.conf
ln -sfF ${p}/init.vim ~/.config/nvim/init.vim
ln -sfF ${p}/lua ~/.config/nvim/lua
ln -sfF ${p}/plugins.vim ~/.config/nvim/plugins.vim
ln -sfF ${p}/init.lua ~/.config/nvim/init.lua
ln -sfF ${p}/kitty ~/.config/kitty
