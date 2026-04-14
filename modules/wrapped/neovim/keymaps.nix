{
  flake.modules.neovim.keymaps = {
    config.vim.keymaps = [
      # ── Better up/down (respect wrapped lines) ────────────────────────
      {
        key = "j";
        mode = [
          "n"
          "x"
        ];
        action = "v:count == 0 ? 'gj' : 'j'";
        expr = true;
        silent = true;
        desc = "Down";
      }
      {
        key = "k";
        mode = [
          "n"
          "x"
        ];
        action = "v:count == 0 ? 'gk' : 'k'";
        expr = true;
        silent = true;
        desc = "Up";
      }
      {
        key = "<Down>";
        mode = [
          "n"
          "x"
        ];
        action = "v:count == 0 ? 'gj' : 'j'";
        expr = true;
        silent = true;
        desc = "Down";
      }
      {
        key = "<Up>";
        mode = [
          "n"
          "x"
        ];
        action = "v:count == 0 ? 'gk' : 'k'";
        expr = true;
        silent = true;
        desc = "Up";
      }

      # ── Window navigation ─────────────────────────────────────────────
      {
        key = "<C-h>";
        mode = "n";
        action = "<C-w>h";
        silent = true;
        desc = "Go to Left Window";
      }
      {
        key = "<C-j>";
        mode = "n";
        action = "<C-w>j";
        silent = true;
        desc = "Go to Lower Window";
      }
      {
        key = "<C-k>";
        mode = "n";
        action = "<C-w>k";
        silent = true;
        desc = "Go to Upper Window";
      }
      {
        key = "<C-l>";
        mode = "n";
        action = "<C-w>l";
        silent = true;
        desc = "Go to Right Window";
      }

      # ── Window resize ─────────────────────────────────────────────────
      {
        key = "<C-Up>";
        mode = "n";
        action = "<cmd>resize +2<cr>";
        silent = true;
        desc = "Increase Window Height";
      }
      {
        key = "<C-Down>";
        mode = "n";
        action = "<cmd>resize -2<cr>";
        silent = true;
        desc = "Decrease Window Height";
      }
      {
        key = "<C-Left>";
        mode = "n";
        action = "<cmd>vertical resize -2<cr>";
        silent = true;
        desc = "Decrease Window Width";
      }
      {
        key = "<C-Right>";
        mode = "n";
        action = "<cmd>vertical resize +2<cr>";
        silent = true;
        desc = "Increase Window Width";
      }

      # ── Move lines ────────────────────────────────────────────────────
      {
        key = "<A-j>";
        mode = "n";
        action = "<cmd>execute 'move .+' . v:count1<cr>==";
        silent = true;
        desc = "Move Down";
      }
      {
        key = "<A-k>";
        mode = "n";
        action = "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==";
        silent = true;
        desc = "Move Up";
      }
      {
        key = "<A-j>";
        mode = "i";
        action = "<esc><cmd>m .+1<cr>==gi";
        silent = true;
        desc = "Move Down";
      }
      {
        key = "<A-k>";
        mode = "i";
        action = "<esc><cmd>m .-2<cr>==gi";
        silent = true;
        desc = "Move Up";
      }
      {
        key = "<A-j>";
        mode = "v";
        action = ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv";
        silent = true;
        desc = "Move Down";
      }
      {
        key = "<A-k>";
        mode = "v";
        action = ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv";
        silent = true;
        desc = "Move Up";
      }

      # ── Buffers ───────────────────────────────────────────────────────
      # Note: <S-h>/<S-l> are owned by bufferline (cycleNext/cyclePrevious in ui.nix)
      {
        key = "[b";
        mode = "n";
        action = "<cmd>bprevious<cr>";
        silent = true;
        desc = "Prev Buffer";
      }
      {
        key = "]b";
        mode = "n";
        action = "<cmd>bnext<cr>";
        silent = true;
        desc = "Next Buffer";
      }
      {
        key = "<leader>bb";
        mode = "n";
        action = "<cmd>e #<cr>";
        silent = true;
        desc = "Switch to Other Buffer";
      }
      {
        key = "<leader>`";
        mode = "n";
        action = "<cmd>e #<cr>";
        silent = true;
        desc = "Switch to Other Buffer";
      }
      {
        key = "<leader>bd";
        mode = "n";
        lua = true;
        action = "function() Snacks.bufdelete() end";
        silent = true;
        desc = "Delete Buffer";
      }
      {
        key = "<leader>bo";
        mode = "n";
        lua = true;
        action = "function() Snacks.bufdelete.other() end";
        silent = true;
        desc = "Delete Other Buffers";
      }
      {
        key = "<leader>bD";
        mode = "n";
        action = "<cmd>bd<cr>";
        silent = true;
        desc = "Delete Buffer and Window";
      }

      # ── Escape / clear search ─────────────────────────────────────────
      {
        key = "<esc>";
        mode = [
          "i"
          "n"
          "s"
        ];
        action = "<cmd>nohlsearch<cr><esc>";
        silent = true;
        desc = "Escape and Clear hlsearch";
      }
      {
        key = "<leader>ur";
        mode = "n";
        action = "<cmd>nohlsearch<bar>diffupdate<bar>normal! <C-L><cr>";
        silent = true;
        desc = "Redraw / Clear hlsearch / Diff Update";
      }

      # ── Saner n/N — always forward/backward, open folds ──────────────
      {
        key = "n";
        mode = "n";
        action = "'Nn'[v:searchforward].'zv'";
        expr = true;
        silent = true;
        desc = "Next Search Result";
      }
      {
        key = "n";
        mode = [
          "x"
          "o"
        ];
        action = "'Nn'[v:searchforward]";
        expr = true;
        silent = true;
        desc = "Next Search Result";
      }
      {
        key = "N";
        mode = "n";
        action = "'nN'[v:searchforward].'zv'";
        expr = true;
        silent = true;
        desc = "Prev Search Result";
      }
      {
        key = "N";
        mode = [
          "x"
          "o"
        ];
        action = "'nN'[v:searchforward]";
        expr = true;
        silent = true;
        desc = "Prev Search Result";
      }

      # ── Undo break-points in insert mode ──────────────────────────────
      {
        key = ",";
        mode = "i";
        action = ",<c-g>u";
      }
      {
        key = ".";
        mode = "i";
        action = ".<c-g>u";
      }
      {
        key = ";";
        mode = "i";
        action = ";<c-g>u";
      }

      # ── Save / quit ───────────────────────────────────────────────────
      {
        key = "<C-s>";
        mode = [
          "i"
          "x"
          "n"
          "s"
        ];
        action = "<cmd>w<cr><esc>";
        silent = true;
        desc = "Save File";
      }
      {
        key = "<leader>qq";
        mode = "n";
        action = "<cmd>qa<cr>";
        silent = true;
        desc = "Quit All";
      }
      {
        key = "<leader>K";
        mode = "n";
        action = "<cmd>norm! K<cr>";
        silent = true;
        desc = "Keywordprg";
      }

      # ── Files ─────────────────────────────────────────────────────────
      {
        key = "<leader>fn";
        mode = "n";
        action = "<cmd>enew<cr>";
        silent = true;
        desc = "New File";
      }

      # ── Better indenting (stay in visual) ─────────────────────────────
      {
        key = "<";
        mode = "x";
        action = "<gv";
        desc = "Indent Left";
      }
      {
        key = ">";
        mode = "x";
        action = ">gv";
        desc = "Indent Right";
      }

      # ── Comment above / below ─────────────────────────────────────────
      {
        key = "gco";
        mode = "n";
        action = "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>";
        desc = "Add Comment Below";
      }
      {
        key = "gcO";
        mode = "n";
        action = "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>";
        desc = "Add Comment Above";
      }

      # ── Window splits ─────────────────────────────────────────────────
      {
        key = "<leader>-";
        mode = "n";
        action = "<C-w>s";
        silent = true;
        desc = "Split Window Below";
      }
      {
        key = "<leader>|";
        mode = "n";
        action = "<C-w>v";
        silent = true;
        desc = "Split Window Right";
      }
      {
        key = "<leader>wd";
        mode = "n";
        action = "<C-w>c";
        silent = true;
        desc = "Delete Window";
      }

      # ── Tabs ──────────────────────────────────────────────────────────
      {
        key = "<leader><tab><tab>";
        mode = "n";
        action = "<cmd>tabnew<cr>";
        silent = true;
        desc = "New Tab";
      }
      {
        key = "<leader><tab>d";
        mode = "n";
        action = "<cmd>tabclose<cr>";
        silent = true;
        desc = "Close Tab";
      }
      {
        key = "<leader><tab>]";
        mode = "n";
        action = "<cmd>tabnext<cr>";
        silent = true;
        desc = "Next Tab";
      }
      {
        key = "<leader><tab>[";
        mode = "n";
        action = "<cmd>tabprevious<cr>";
        silent = true;
        desc = "Previous Tab";
      }
      {
        key = "<leader><tab>f";
        mode = "n";
        action = "<cmd>tabfirst<cr>";
        silent = true;
        desc = "First Tab";
      }
      {
        key = "<leader><tab>l";
        mode = "n";
        action = "<cmd>tablast<cr>";
        silent = true;
        desc = "Last Tab";
      }
      {
        key = "<leader><tab>o";
        mode = "n";
        action = "<cmd>tabonly<cr>";
        silent = true;
        desc = "Close Other Tabs";
      }

      # ── Diagnostics ───────────────────────────────────────────────────
      {
        key = "<leader>cd";
        mode = "n";
        lua = true;
        action = "function() vim.diagnostic.open_float() end";
        silent = true;
        desc = "Line Diagnostics";
      }
      {
        key = "]d";
        mode = "n";
        lua = true;
        action = "function() vim.diagnostic.jump({ count=vim.v.count1, float=true }) end";
        silent = true;
        desc = "Next Diagnostic";
      }
      {
        key = "[d";
        mode = "n";
        lua = true;
        action = "function() vim.diagnostic.jump({ count=-vim.v.count1, float=true }) end";
        silent = true;
        desc = "Prev Diagnostic";
      }
      {
        key = "]e";
        mode = "n";
        lua = true;
        action = "function() vim.diagnostic.jump({ count=vim.v.count1,  severity=vim.diagnostic.severity.ERROR, float=true }) end";
        silent = true;
        desc = "Next Error";
      }
      {
        key = "[e";
        mode = "n";
        lua = true;
        action = "function() vim.diagnostic.jump({ count=-vim.v.count1, severity=vim.diagnostic.severity.ERROR, float=true }) end";
        silent = true;
        desc = "Prev Error";
      }
      {
        key = "]w";
        mode = "n";
        lua = true;
        action = "function() vim.diagnostic.jump({ count=vim.v.count1,  severity=vim.diagnostic.severity.WARN, float=true }) end";
        silent = true;
        desc = "Next Warning";
      }
      {
        key = "[w";
        mode = "n";
        lua = true;
        action = "function() vim.diagnostic.jump({ count=-vim.v.count1, severity=vim.diagnostic.severity.WARN, float=true }) end";
        silent = true;
        desc = "Prev Warning";
      }

      # ── LSP ───────────────────────────────────────────────────────────
      {
        key = "<leader>cf";
        mode = [
          "n"
          "x"
        ];
        lua = true;
        action = "function() require('conform').format({ force=true }) end";
        silent = true;
        desc = "Format";
      }
      {
        key = "<leader>cF";
        mode = [
          "n"
          "x"
        ];
        lua = true;
        action = "function() require('conform').format({ formatters={'injected'}, timeout_ms=3000 }) end";
        silent = true;
        desc = "Format Injected Langs";
      }
      {
        key = "<leader>ca";
        mode = [
          "n"
          "x"
        ];
        lua = true;
        action = "function() vim.lsp.buf.code_action() end";
        silent = true;
        desc = "Code Action";
      }
      {
        key = "<leader>cr";
        mode = "n";
        lua = true;
        action = "function() vim.lsp.buf.rename() end";
        silent = true;
        desc = "Rename";
      }
      {
        key = "<leader>cl";
        mode = "n";
        action = "<cmd>LspInfo<cr>";
        silent = true;
        desc = "Lsp Info";
      }
      {
        key = "<leader>co";
        mode = "n";
        lua = true;
        action = "function() vim.lsp.buf.code_action({ apply=true, context={only={'source.organizeImports'}} }) end";
        silent = true;
        desc = "Organize Imports";
      }
      {
        key = "<leader>cc";
        mode = [
          "n"
          "x"
        ];
        lua = true;
        action = "function() vim.lsp.codelens.run() end";
        silent = true;
        desc = "Run Codelens";
      }
      {
        key = "<leader>cC";
        mode = "n";
        lua = true;
        action = "function() vim.lsp.codelens.refresh() end";
        silent = true;
        desc = "Refresh Codelens";
      }
      {
        key = "gd";
        mode = "n";
        lua = true;
        action = "function() vim.lsp.buf.definition() end";
        silent = true;
        desc = "Goto Definition";
      }
      {
        key = "gD";
        mode = "n";
        lua = true;
        action = "function() vim.lsp.buf.declaration() end";
        silent = true;
        desc = "Goto Declaration";
      }
      {
        key = "gr";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').lsp_references() end";
        silent = true;
        desc = "References";
      }
      {
        key = "gI";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').lsp_implementations() end";
        silent = true;
        desc = "Goto Implementation";
      }
      {
        key = "gy";
        mode = "n";
        lua = true;
        action = "function() vim.lsp.buf.type_definition() end";
        silent = true;
        desc = "Goto Type Definition";
      }
      {
        key = "K";
        mode = "n";
        lua = true;
        action = "function() vim.lsp.buf.hover() end";
        silent = true;
        desc = "Hover";
      }
      {
        key = "gK";
        mode = "n";
        lua = true;
        action = "function() vim.lsp.buf.signature_help() end";
        silent = true;
        desc = "Signature Help";
      }
      {
        key = "<c-k>";
        mode = "i";
        lua = true;
        action = "function() vim.lsp.buf.signature_help() end";
        silent = true;
        desc = "Signature Help";
      }

      # ── Quickfix / Location list ──────────────────────────────────────
      {
        key = "<leader>xl";
        mode = "n";
        lua = true;
        action = "function() local l=vim.fn.getloclist(0,{winid=0}); if l.winid~=0 then vim.cmd.lclose() else vim.cmd.lopen() end end";
        silent = true;
        desc = "Location List";
      }
      {
        key = "<leader>xq";
        mode = "n";
        lua = true;
        action = "function() local q=vim.fn.getqflist({winid=0}); if q.winid~=0 then vim.cmd.cclose() else vim.cmd.copen() end end";
        silent = true;
        desc = "Quickfix List";
      }
      {
        key = "[q";
        mode = "n";
        action = "<cmd>cprev<cr>";
        silent = true;
        desc = "Previous Quickfix";
      }
      {
        key = "]q";
        mode = "n";
        action = "<cmd>cnext<cr>";
        silent = true;
        desc = "Next Quickfix";
      }

      # ── Which-key meta ────────────────────────────────────────────────
      {
        key = "<leader>?";
        mode = "n";
        lua = true;
        action = "function() require('which-key').show({ global=false }) end";
        silent = true;
        desc = "Buffer Keymaps (which-key)";
      }
      {
        key = "<c-w><space>";
        mode = "n";
        lua = true;
        action = "function() require('which-key').show({ keys='<c-w>', loop=true }) end";
        silent = true;
        desc = "Window Hydra Mode (which-key)";
      }

      # ── Bufferline extras ─────────────────────────────────────────────
      {
        key = "<leader>bp";
        mode = "n";
        action = "<cmd>BufferLineTogglePin<cr>";
        silent = true;
        desc = "Toggle Pin";
      }
      {
        key = "<leader>bP";
        mode = "n";
        action = "<cmd>BufferLineGroupClose ungrouped<cr>";
        silent = true;
        desc = "Delete Non-Pinned Buffers";
      }
      {
        key = "<leader>br";
        mode = "n";
        action = "<cmd>BufferLineCloseRight<cr>";
        silent = true;
        desc = "Delete Buffers to the Right";
      }
      {
        key = "<leader>bl";
        mode = "n";
        action = "<cmd>BufferLineCloseLeft<cr>";
        silent = true;
        desc = "Delete Buffers to the Left";
      }
      {
        key = "<leader>bj";
        mode = "n";
        action = "<cmd>BufferLinePick<cr>";
        silent = true;
        desc = "Pick Buffer";
      }
      {
        key = "[B";
        mode = "n";
        action = "<cmd>BufferLineMovePrev<cr>";
        silent = true;
        desc = "Move Buffer Prev";
      }
      {
        key = "]B";
        mode = "n";
        action = "<cmd>BufferLineMoveNext<cr>";
        silent = true;
        desc = "Move Buffer Next";
      }

      # ── Noice ─────────────────────────────────────────────────────────
      {
        key = "<leader>snl";
        mode = "n";
        lua = true;
        action = "function() require('noice').cmd('last') end";
        silent = true;
        desc = "Noice Last Message";
      }
      {
        key = "<leader>snh";
        mode = "n";
        lua = true;
        action = "function() require('noice').cmd('history') end";
        silent = true;
        desc = "Noice History";
      }
      {
        key = "<leader>sna";
        mode = "n";
        lua = true;
        action = "function() require('noice').cmd('all') end";
        silent = true;
        desc = "Noice All";
      }
      {
        key = "<leader>snd";
        mode = "n";
        lua = true;
        action = "function() require('noice').cmd('dismiss') end";
        silent = true;
        desc = "Dismiss All Notifications";
      }
      {
        key = "<S-Enter>";
        mode = "c";
        lua = true;
        action = "function() require('noice').redirect(vim.fn.getcmdline()) end";
        silent = true;
        desc = "Redirect Cmdline";
      }
      {
        key = "<c-f>";
        mode = [
          "i"
          "n"
          "s"
        ];
        lua = true;
        expr = true;
        action = "function() if not require('noice.lsp').scroll(4)  then return '<c-f>' end end";
        silent = true;
        desc = "Scroll Forward";
      }
      {
        key = "<c-b>";
        mode = [
          "i"
          "n"
          "s"
        ];
        lua = true;
        expr = true;
        action = "function() if not require('noice.lsp').scroll(-4) then return '<c-b>' end end";
        silent = true;
        desc = "Scroll Backward";
      }

      # ── Notifications ─────────────────────────────────────────────────
      {
        key = "<leader>n";
        mode = "n";
        lua = true;
        action = "function() Snacks.notifier.show_history() end";
        silent = true;
        desc = "Notification History";
      }
      {
        key = "<leader>un";
        mode = "n";
        lua = true;
        action = "function() Snacks.notifier.hide() end";
        silent = true;
        desc = "Dismiss All Notifications";
      }

      # ── UI inspect ────────────────────────────────────────────────────
      {
        key = "<leader>ui";
        mode = "n";
        lua = true;
        action = "function() vim.show_pos() end";
        silent = true;
        desc = "Inspect Pos";
      }
      {
        key = "<leader>uI";
        mode = "n";
        lua = true;
        action = "function() vim.treesitter.inspect_tree(); vim.api.nvim_input('I') end";
        silent = true;
        desc = "Inspect Tree";
      }

      # ── fzf-lua ───────────────────────────────────────────────────────
      {
        key = "<leader><space>";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').files() end";
        silent = true;
        desc = "Find Files";
      }
      {
        key = "<leader>ff";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').files() end";
        silent = true;
        desc = "Find Files";
      }
      {
        key = "<leader>fg";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').git_files() end";
        silent = true;
        desc = "Find Git Files";
      }
      {
        key = "<leader>fr";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').oldfiles() end";
        silent = true;
        desc = "Recent Files";
      }
      {
        key = "<leader>fb";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').buffers() end";
        silent = true;
        desc = "Buffers";
      }
      {
        key = "<leader>sg";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').live_grep() end";
        silent = true;
        desc = "Grep";
      }
      {
        key = "<leader>sw";
        mode = [
          "n"
          "x"
        ];
        lua = true;
        action = "function() require('fzf-lua').grep_cword() end";
        silent = true;
        desc = "Grep Word";
      }
      {
        key = "<leader>ss";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').lsp_document_symbols() end";
        silent = true;
        desc = "LSP Symbols";
      }
      {
        key = "<leader>sS";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').lsp_workspace_symbols() end";
        silent = true;
        desc = "LSP Workspace Symbols";
      }
      {
        key = "<leader>sd";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').diagnostics_document() end";
        silent = true;
        desc = "Document Diagnostics";
      }
      {
        key = "<leader>sD";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').diagnostics_workspace() end";
        silent = true;
        desc = "Workspace Diagnostics";
      }
      {
        key = "<leader>sh";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').help_tags() end";
        silent = true;
        desc = "Help Pages";
      }
      {
        key = "<leader>sk";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').keymaps() end";
        silent = true;
        desc = "Keymaps";
      }
      {
        key = "<leader>sc";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').command_history() end";
        silent = true;
        desc = "Command History";
      }
      {
        key = "<leader>/";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').lgrep_curbuf() end";
        silent = true;
        desc = "Buffer Lines";
      }
      {
        key = "<leader>gc";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').git_commits() end";
        silent = true;
        desc = "Git Commits";
      }
      {
        key = "<leader>gs";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').git_status() end";
        silent = true;
        desc = "Git Status";
      }

      # ── Flash ─────────────────────────────────────────────────────────
      {
        key = "s";
        mode = [
          "n"
          "o"
          "x"
        ];
        lua = true;
        action = "function() require('flash').jump() end";
        silent = true;
        desc = "Flash";
      }
      {
        key = "S";
        mode = [
          "n"
          "o"
          "x"
        ];
        lua = true;
        action = "function() require('flash').treesitter() end";
        silent = true;
        desc = "Flash Treesitter";
      }
      {
        key = "r";
        mode = "o";
        lua = true;
        action = "function() require('flash').remote() end";
        silent = true;
        desc = "Remote Flash";
      }
      {
        key = "R";
        mode = [
          "o"
          "x"
        ];
        lua = true;
        action = "function() require('flash').treesitter_search() end";
        silent = true;
        desc = "Treesitter Search";
      }
      {
        key = "<c-s>";
        mode = "c";
        lua = true;
        action = "function() require('flash').toggle() end";
        silent = true;
        desc = "Toggle Flash Search";
      }

      # ── Grug-far ──────────────────────────────────────────────────────
      {
        key = "<leader>sr";
        mode = [
          "n"
          "x"
        ];
        lua = true;
        action = "function() require('grug-far').open({ prefills={ search=vim.fn.expand('<cword>') } }) end";
        silent = true;
        desc = "Search and Replace";
      }

      # ── Trouble ───────────────────────────────────────────────────────
      {
        key = "<leader>xx";
        mode = "n";
        action = "<cmd>Trouble diagnostics toggle<cr>";
        silent = true;
        desc = "Diagnostics (Trouble)";
      }
      {
        key = "<leader>xX";
        mode = "n";
        action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
        silent = true;
        desc = "Buffer Diagnostics (Trouble)";
      }
      {
        key = "<leader>cs";
        mode = "n";
        action = "<cmd>Trouble symbols toggle<cr>";
        silent = true;
        desc = "Symbols (Trouble)";
      }
      {
        key = "<leader>cS";
        mode = "n";
        action = "<cmd>Trouble lsp toggle<cr>";
        silent = true;
        desc = "LSP (Trouble)";
      }
      {
        key = "<leader>xL";
        mode = "n";
        action = "<cmd>Trouble loclist toggle<cr>";
        silent = true;
        desc = "Location List (Trouble)";
      }
      {
        key = "<leader>xQ";
        mode = "n";
        action = "<cmd>Trouble qflist toggle<cr>";
        silent = true;
        desc = "Quickfix List (Trouble)";
      }

      # ── Todo-comments ─────────────────────────────────────────────────
      {
        key = "]t";
        mode = "n";
        lua = true;
        action = "function() require('todo-comments').jump_next() end";
        silent = true;
        desc = "Next Todo Comment";
      }
      {
        key = "[t";
        mode = "n";
        lua = true;
        action = "function() require('todo-comments').jump_prev() end";
        silent = true;
        desc = "Previous Todo Comment";
      }
      {
        key = "<leader>xt";
        mode = "n";
        action = "<cmd>Trouble todo toggle<cr>";
        silent = true;
        desc = "Todo (Trouble)";
      }
      {
        key = "<leader>xT";
        mode = "n";
        action = "<cmd>Trouble todo toggle filter={tag={TODO,FIX,FIXME}}<cr>";
        silent = true;
        desc = "Todo/Fix/Fixme (Trouble)";
      }
      {
        key = "<leader>st";
        mode = "n";
        lua = true;
        action = "function() require('fzf-lua').grep({ search='TODO|FIXME|HACK|NOTE', no_esc=true }) end";
        silent = true;
        desc = "Todo";
      }

      # ── Snacks Explorer ───────────────────────────────────────────────
      {
        key = "<leader>fe";
        mode = "n";
        lua = true;
        action = "function() Snacks.explorer({ cwd = Snacks.git.get_root() or vim.fn.getcwd() }) end";
        silent = true;
        desc = "Explorer Snacks (root dir)";
      }
      {
        key = "<leader>fE";
        mode = "n";
        lua = true;
        action = "function() Snacks.explorer() end";
        silent = true;
        desc = "Explorer Snacks (cwd)";
      }
      {
        key = "<leader>e";
        mode = "n";
        lua = true;
        action = "function() Snacks.explorer({ cwd = Snacks.git.get_root() or vim.fn.getcwd() }) end";
        silent = true;
        desc = "Explorer Snacks (root dir)";
      }
      {
        key = "<leader>E";
        mode = "n";
        lua = true;
        action = "function() Snacks.explorer() end";
        silent = true;
        desc = "Explorer Snacks (cwd)";
      }

      # ── Session (persistence.nvim) ────────────────────────────────────
      {
        key = "<leader>qs";
        mode = "n";
        lua = true;
        action = "function() require('persistence').load() end";
        silent = true;
        desc = "Restore Session";
      }
      {
        key = "<leader>qS";
        mode = "n";
        lua = true;
        action = "function() require('persistence').select() end";
        silent = true;
        desc = "Select Session";
      }
      {
        key = "<leader>ql";
        mode = "n";
        lua = true;
        action = "function() require('persistence').load({ last=true }) end";
        silent = true;
        desc = "Restore Last Session";
      }
      {
        key = "<leader>qd";
        mode = "n";
        lua = true;
        action = "function() require('persistence').stop() end";
        silent = true;
        desc = "Don't Save Current Session";
      }
    ];
  };
}
