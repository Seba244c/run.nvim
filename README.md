<p align="center">
  <h1 align="center">run.nvim</h2>
</p>


<p align="center">
    > Blazingly fast action runner
</p>

## ⚡️ Features
W.I.P

## 📋 Installation
Using [packer](https://github.com/wbthomason/packer.nvim) in lua

```lua
use {"Seba244c/run.nvim", requires = {'nvim-telescope/telescope.nvim'}, tag = '*', config = function()
  require("run").setup()
end}
```

Using [lazy.nvim](https://github.com/folke/lazy.nvim) in lua

```lua
{
  -- amongst your other plugins
  {'Seba244c/run.nvim', version = "*", dependencies = {'nvim-telescope/telescope.nvim' }, config = true}
  -- or
  {'Seba244c/run.nvim', version = "*", dependencies = {'nvim-telescope/telescope.nvim' }, opts = {--[[ things you want to change go here]]}}
}
```

Using [vim-plug](https://github.com/junegunn/vim-plug) in vimscript

```vim
Plug 'Seba244c/run.nvim', {'tag' : '*'}
    Plug 'nvim-telescope/telescope.nvim'

lua require("run").setup()
```

## ☄ Getting started
## ⚙ Configuration


