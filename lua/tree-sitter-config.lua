require 'nvim-treesitter.configs'.setup {

  ensure_installed = "all",

  sync_install = false,

  ignore_install = {},

  highlight = {
    enable = true,
    disable = {"vim"},

    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = {"make"},
  },
}
