1. Install ZSH and Oh-My-Zsh

	$ sudo apt install -y zsh curl git vim

	$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

2. Install plugins.

	$ git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions

	$ git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting

3. Enable plugins by adding them to .zshrc.

	plugins=(git zsh-autosuggestions fast-syntax-highlighting)

4. Logout and Login to make the changes take effect
