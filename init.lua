-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  --theme
  {"navarasu/onedark.nvim"},
  -- Core plugins
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "stevearc/oil.nvim" },
  { "neovim/nvim-lspconfig" },

  -- Autocompletion
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },
})

require('onedark').setup {
  style = 'warmer',
  transparent = false,          -- Show/hide background
  term_colors = true,           -- Change terminal color as per the selected theme style
  ending_tildes = false,        -- Show the end-of-buffer tildes. By default they are hidden
  cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

  -- toggle theme style ---
  toggle_style_key = nil,                                                              -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
  toggle_style_list = { 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light' }, -- List of styles to toggle between

  -- Change code style ---
  -- Options are italic, bold, underline, none
  -- You can configure multiple style with comma seperated, For e.g., keywords = 'italic,bold'
  code_style = {
    comments = 'italic',
    keywords = 'none',
    functions = 'none',
    strings = 'none',
    variables = 'none'
  },

  -- Lualine options --
  lualine = {
    transparent = false, -- lualine center bar transparency
  },

  -- Custom Highlights --
  colors = {},     -- Override default colors
  highlights = {}, -- Override highlight groups

  -- Plugins Config --
  diagnostics = {
    darker = true,     -- darker colors for diagnostic
    undercurl = true,  -- use undercurl instead of underline for diagnostics
    background = true, -- use background color for virtual text
  },
}

require('onedark').load()

-- Base Configuration
vim.wo.number = true;
vim.opt.title = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hlsearch = true
vim.opt.backup = false
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 2
vim.opt.expandtab = true
vim.opt.scrolloff = 10
vim.opt.shell = 'fish'
vim.opt.backupskip = { '/tmp/*', '/private/tmp/*' }
vim.opt.inccommand = 'split'
vim.opt.ignorecase = true
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.wrap = false
vim.opt.backspace = { 'start', 'eol', 'indent' }
vim.opt.path:append { '**' }
vim.opt.wildignore:append { '*/node_modules/*' }

require("nvim-treesitter.configs").setup {
  highlight = { enable = true },
}

require("telescope").setup {}

--OIL
require("oil").setup({
  default_file_explorer = true,
  float = {
    max_width = 40,
    max_height = 20,
  }
})

local lspconfig = require("lspconfig")
lspconfig.pyright.setup {}

-- LSP Diagnostics Configuration
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = true,
  severity_sort = true,
})

vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })

-- Autocompletion Setup
local cmp = require("cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
    { name = "path" },
  })
})


-- Keybindings
vim.g.mapleader = " "
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Oil (File Explorer)
vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
-- open in floating window
vim.keymap.set("n", "sf", require("oil").open_float, { desc = "Open parent directory in floating window" })
vim.keymap.set("n", "q", require("oil").close, { desc = "Close oil" })

-- Telescope Keybindings
map("n", "<leader>sf", ":Telescope find_files<CR>", opts)
map("n", "<leader>sg", ":Telescope live_grep<CR>", opts)
map("n", "<leader><leader>", ":Telescope buffers<CR>", opts)
map("n", "<leader>sh", ":Telescope help_tags<CR>", opts)
map("n", "<leader>sk", ":Telescope keymaps<CR>", opts)
map("n", "<leader>sc", ":Telescope commands<CR>", opts)
map("n", "<leader>sr", ":Telescope oldfiles<CR>", opts)
map("n", "<leader>ss", ":Telescope lsp_document_symbols<CR>", opts)

-- LSP Keybindings
map("n", "gd", ":lua vim.lsp.buf.definition()<CR>", opts)
map("n", "gD", ":lua vim.lsp.buf.declaration()<CR>", opts)
map("n", "gr", ":lua vim.lsp.buf.references()<CR>", opts)
map("n", "gi", ":lua vim.lsp.buf.implementation()<CR>", opts)
map("n", "K", ":lua vim.lsp.buf.hover()<CR>", opts)
map("n", "<leader>rn", ":lua vim.lsp.buf.rename()<CR>", opts)
map("n", "<leader>ca", ":lua vim.lsp.buf.code_action()<CR>", opts)
map("n", "<leader>e", ":lua vim.diagnostic.open_float()<CR>", opts)
map("n", "[d", ":lua vim.diagnostic.goto_prev()<CR>", opts)
map("n", "]d", ":lua vim.diagnostic.goto_next()<CR>", opts)

-- Show available commands
map("n", "<leader>?", ":Telescope commands<CR>", opts)

-- Save and Quit Shortcut
map("n", "<leader>wq", ":wq<CR>", opts)
map("n", "<leader>q", ":q<CR>", opts)
map("n", "<leader>w", ":w<CR>", opts)

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

