#---------- Create various symlinks ----------

# Assumes directories actually exist on new host
# Call this from home dir

dir=~/icloud/dot-files

ln -sfF ${dir}/.zshrc ~/.zshrc
ln -sfF ${dir}/.alacritty.yml ~/.config/alacritty/alacritty.yml
ln -sfF ${dir}/.tmux.conf ~/.tmux.conf
ln -sfF ${dir}/init.vim ~/.config/nvim/init.vim
ln -sfF ${dir}/lua ~/.config/nvim/lua
ln -sfF ${dir}/plugins.vim ~/.config/nvim/plugins.vim
ln -sfF ${dir}/init.lua ~/.config/nvim/init.lua
ln -sfF ${dir}/kitty ~/.config/kitty
