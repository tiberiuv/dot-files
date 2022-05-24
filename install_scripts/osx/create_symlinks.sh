#---------- Create various symlinks ----------

# Assumes directories actually exist on new host
# Call this from home dir

dir=$HOME/dot-files

ln -sfF ${dir}/.zshrc $HOME/.zshrc
ln -sfF ${dir}/.zprofile $HOME/.zprofile
ln -sfF ${dir}/.zshenv $HOME/.zshenv
ln -sfF ${dir}/.alacritty.yml $HOME/.config/alacritty/alacritty.yml
ln -sfF ${dir}/.tmux.conf $HOME/.tmux.conf
ln -sfF ${dir}/lua $HOME/.config/nvim/
ln -sfF ${dir}/init.lua $HOME/.config/nvim/init.lua
