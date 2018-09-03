## Install with a installation script

```bash
bash ~/path/to/cloned/repo/install.sh
```

## Install manually

### Bash
Enable touchpad or disable it
**~/.bashrc**
```bash
theme='main'
toggleTouchpad=1 # enable or 0 for disable
source ~/path/to/cloned/repo/bash/.bashrc
```

### vim
**~/.vimrc**
```bash
source ~/path/to/cloned/repo/vim/.vimrc
```

### screen
**~/.screenrc**
```bash
source ~/path/to/cloned/repo/screen/.screenrc
```

### git
**~/.gitconfig**
```bash
[include]
    path = ~/path/to/cloned/repo/git/.gitconfig
```
