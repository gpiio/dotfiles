export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# Set fpath FIRST
fpath=(~/.zsh/plugins/zsh-completions/src $fpath)

# Initialize completions AFTER setting fpath
autoload -U compinit && compinit 

# Then load other plugins
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

update-zsh-plugins() {
    cd ~/.zsh/plugins
    for dir in */; do
	echo "Updating $dir"
	cd "$dir" && git pull && cd ..
    done
}

reinstall-podman() {
    brew uninstall podman 2>/dev/null || true
    sudo rm -f /usr/local/bin/podman
    brew install podman
    mkdir -p ~/.zsh/completions
    podman completion zsh > ~/.zsh/completions/_podman
    rm -f ~/.zcompdump*
    autoload -U compinit && compinit -i
}

# Function to reinstall kubectl with completions
reinstall-kubectl() {
    echo "🔄 Reinstalling kubectl..."
    
    # Uninstall existing kubectl
    echo "Removing existing kubectl installation..."
    brew uninstall kubectl 2>/dev/null || true
    sudo rm -f /usr/local/bin/kubectl
    sudo rm -f /usr/bin/kubectl
    
    # Clean up completion files
    rm -f ~/.zsh/completions/_kubectl
    
    # Get latest kubectl version
    echo "Fetching latest kubectl version..."
    KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
    echo "Latest version: $KUBECTL_VERSION"
    
    # Download and install kubectl
    echo "Downloading kubectl $KUBECTL_VERSION..."
    cd /tmp
    curl -LO "https://dl.k8s.io/release/$KUBECTL_VERSION/bin/darwin/amd64/kubectl"
    sudo mv kubectl /usr/local/bin/kubectl
    sudo chmod +x /usr/local/bin/kubectl
    
    # Generate completion
    echo "Setting up kubectl completions..."
    mkdir -p ~/.zsh/completions
    kubectl completion zsh > ~/.zsh/completions/_kubectl
    
    # Refresh completions
    rm -f ~/.zcompdump*
    autoload -U compinit && compinit -i
    
    echo "✅ kubectl installation complete!"
    kubectl version --client
    cd ~
}

# Function to reinstall Terraform with completions
reinstall-terraform() {
    echo "🔄 Reinstalling Terraform..."
    
    # Uninstall existing Terraform
    echo "Removing existing Terraform installation..."
    brew uninstall terraform 2>/dev/null || true
    sudo rm -f /usr/local/bin/terraform
    sudo rm -f /usr/bin/terraform
    
    # Remove terraform completion config
    rm -f ~/.bashrc.bak ~/.zshrc.bak  # terraform -install-autocomplete creates these
    
    # Get latest Terraform version
    echo "Fetching latest Terraform version..."
    TERRAFORM_VERSION=$(curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')
    echo "Latest version: $TERRAFORM_VERSION"
    
    # Download and install Terraform
    echo "Downloading Terraform v$TERRAFORM_VERSION..."
    cd /tmp
    curl -fsSL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_darwin_amd64.zip" -o terraform.zip
    unzip -q terraform.zip
    sudo mv terraform /usr/local/bin/terraform
    sudo chmod +x /usr/local/bin/terraform
    rm terraform.zip
    
    # Setup autocomplete
    echo "Setting up Terraform completions..."
    terraform -install-autocomplete 2>/dev/null || {
        # Manual completion setup if -install-autocomplete fails
        mkdir -p ~/.zsh/completions
        curl -fsSL https://raw.githubusercontent.com/hashicorp/terraform/main/contrib/completion/zsh/_terraform > ~/.zsh/completions/_terraform
    }
    
    # Refresh completions
    rm -f ~/.zcompdump*
    autoload -U compinit && compinit -i
    
    echo "✅ Terraform installation complete!"
    terraform version
    cd ~
}

# Function to check system architecture
check-architecture() {
    ARCH=$(uname -m)
    if [[ "$ARCH" == "arm64" ]]; then
        echo "arm64"
    else
        echo "amd64"
    fi
}

# Convenience function to reinstall all three
reinstall-all-tools() {
    echo "🚀 Reinstalling all tools..."
    echo "System architecture: $(check-architecture)"
    echo ""
    
    reinstall-podman
    echo ""
    reinstall-kubectl
    echo ""
    reinstall-terraform
    echo ""
    echo "🎉 All tools reinstalled! Please restart your terminal or run 'source ~/.zshrc'"
}

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

# Bind keys for history substring search
bindkey '^[[A' history-substring-search-up      # Up arrow
bindkey '^[[B' history-substring-search-down    # Down arrow

# Optional: Also bind to vim-style keys
bindkey '^P' history-substring-search-up        # Ctrl+P
bindkey '^N' history-substring-search-down      # Ctrl+N
