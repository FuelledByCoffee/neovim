require 'nvim-treesitter.configs'.setup {

  ensure_installed = "all",

  sync_install = false,

  highlight = {
    enable = true,
    disable = {"vim", "tmux"},

    -- Instead of true it can also be a list of languages
    -- additional_vim_regex_highlighting = {"make"},
  },

  vim.keymap.set("n", "<F2>",  "<cmd>TSHighlightCapturesUnderCursor<cr>", { buffer=0, noremap=true }),

  playground = {
    enable = false,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  }
}
