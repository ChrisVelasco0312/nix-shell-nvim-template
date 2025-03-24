{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  packages = with pkgs; [
    neovim
    python3
    python3Packages.requests
    ripgrep
    git
    nodejs
    pyright
  ];

  shellHook = ''
    export NVIM_APPNAME=nvim-python-env
    CONFIG_DIR="$HOME/.config/$NVIM_APPNAME"
    DATA_DIR="$HOME/.local/share/$NVIM_APPNAME"

    mkdir -p "$CONFIG_DIR/lua" "$DATA_DIR/lazy"

    # Bootstrap lazy.nvim
    if [ ! -d "$DATA_DIR/lazy/lazy.nvim" ]; then
      git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable "$DATA_DIR/lazy/lazy.nvim"
    fi

    # Copy Lua configuration
    cp "$(dirname "$0")/init.lua" "$CONFIG_DIR/init.lua"

    echo "Activated isolated Python environment with Neovim!"
  '';
}

