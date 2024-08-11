
local custom_lsp_attach = function(client)
  -- See `:help nvim_buf_set_keymap()` for more information
  vim.keymap.set("n", "K",  vim.lsp.buf.hover,                { buffer=0 })
  vim.keymap.set("n", "gd", vim.lsp.buf.definition,           { buffer=0 })
  vim.keymap.set("n", "gt", vim.lsp.buf.type_definition,      { buffer=0 })
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation,       { buffer=0 })
  vim.keymap.set("n", "-r", vim.lsp.buf.rename,               { buffer=0 })
  vim.keymap.set("n", "-a", vim.lsp.buf.references,           { buffer=0 })
  vim.keymap.set("n", "-.", vim.lsp.buf.code_action,          { buffer=0 })
  vim.keymap.set("n", "-n", vim.diagnostic.goto_next,         { buffer=0 })
  vim.keymap.set("n", "-p", vim.diagnostic.goto_prev,         { buffer=0 })
  vim.keymap.set("n", "-l", "<cmd>Telescope diagnostics<cr>", { buffer=0 })


  -- Use LSP as the handler for omnifunc.
  --    See `:help omnifunc` and `:help ins-completion` for more information.
  vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Use LSP as the handler for formatexpr.
  --    See `:help formatexpr` for more information.
  vim.api.nvim_buf_set_option(0, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')

  -- For plugins with an `on_attach` callback, call them here. For example:
  -- require('completion').on_attach()
	
	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
		vim.lsp.diagnostic.on_publish_diagnostics, {
			virtual_text = false,
			underline = false
		}
	)
end

-- Add additional capabilities supported by nvim-cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Add this later maybe: , 'lua_ls'
local lspconfig = require('lspconfig')

local servers = { 'pyright', 'rust_analyzer', 'clangd', 'gopls' }
for _, lsp in pairs(servers) do
  lspconfig[lsp].setup {
    on_attach = custom_lsp_attach,
    capabilities = capabilities,
    flags = {
      -- This will be the default in neovim 0.7+
      -- debounce_text_changes = 150,
    }
  }
end

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- nvim-cmp setup
local cmp = require('cmp')
local luasnip = require('luasnip')
local lspkind = require('lspkind')
cmp.setup {
	snippet = {
		expand = function(args)
			-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			luasnip.lsp_expand(args.body) -- For `luasnip` users.
			-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
			-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
		end,
	},
	window = {
		-- completion = {
			-- winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
			-- col_offset = -3,
			-- side_padding = 0,
		-- },
		-- documentation = cmp.config.window.bordered(),
	},
	formatting = {
		format = function(entry, vim_item)
			if vim.tbl_contains({ 'path' }, entry.source.name) then
				local icon, hl_group = require('nvim-web-devicons').get_icon(entry:get_completion_item().label)
				if icon then
					vim_item.kind = icon
					vim_item.kind_hl_group = hl_group
					return vim_item
				end
			end
			return lspkind.cmp_format({ with_text = true })(entry, vim_item)
		end
	},
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
	mapping = {
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
    end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	},
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'omni' },
    { name = 'emoji', insert = true },
  },
}

-- An example of configuring for `sumneko_lua`,
--  a language server for Lua.

-- set the path to the sumneko installation
-- local system_name = "Linux" -- (Linux, macOS, or Windows)
-- local sumneko_root_path = '/path/to/lua-language-server'
-- local sumneko_binary = sumneko_root_path.."/bin/"..system_name.."/lua-language-server"

-- require('lspconfig').sumneko_lua.setup({
--   cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
--   -- An example of settings for an LSP server.
--   --    For more options, see nvim-lspconfig
--   settings = {
--     Lua = {
--       runtime = {
--         -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
--         version = 'LuaJIT',
--         -- Setup your lua path
--         path = vim.split(package.path, ';'),
--       },
--       diagnostics = {
--         -- Get the language server to recognize the `vim` global
--         globals = {'vim'},
--       },
--       workspace = {
--         -- Make the server aware of Neovim runtime files
--         library = {
--           [vim.fn.expand('$VIMRUNTIME/lua')] = true,
--           [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
--         },
--       },
--     }
--   },

--   on_attach = custom_lsp_attach
-- })
