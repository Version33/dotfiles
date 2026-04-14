{
  flake.modules.neovim.keymaps-lsp = {
    config.vim.keymaps = [
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
    ];
  };
}
