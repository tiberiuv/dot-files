#---------- Create various symlinks ----------

# Assumes directories actually exist on new host
# Call this from home dir

dir=$HOME/icloud/dot-files

ln -sfF ${dir}/.zshrc $HOME/.zshrc
ln -sfF ${dir}/.zprofile $HOME/.zprofile
ln -sfF ${dir}/.zshenv $HOME/.zshenv
ln -sfF ${dir}/.alacritty.yml $HOME/.config/alacritty/alacritty.yml
ln -sfF ${dir}/.tmux.conf $HOME/.tmux.conf
ln -sfF ${dir}/init.vim $HOME/.config/nvim/init.vim
ln -sfF ${dir}/lua $HOME/.config/nvim/lua
ln -sfF ${dir}/plugins.vim $HOME/.config/nvim/plugins.vim
ln -sfF ${dir}/init.lua $HOME/.config/nvim/init.lua
ln -sfF ${dir}/kitty $HOME/.config/kitty
