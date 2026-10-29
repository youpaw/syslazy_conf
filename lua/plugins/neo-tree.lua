-- <Tab> in the tree opens a file as a throwaway preview: the cursor stays in
-- the tree, and the next preview replaces it. A preview is kept once it's
-- modified or opened for real with <CR>/l.
local preview_buf

local function unmark(buf)
  vim.b[buf].tree_preview = nil
  if preview_buf == buf then
    preview_buf = nil
  end
end

local function drop_preview()
  local buf = preview_buf
  preview_buf = nil
  if not (buf and vim.api.nvim_buf_is_valid(buf) and vim.b[buf].tree_preview) then
    return
  end
  if vim.bo[buf].modified then
    unmark(buf)
  else
    Snacks.bufdelete({ buf = buf })
  end
end

vim.api.nvim_create_autocmd("BufModifiedSet", {
  group = vim.api.nvim_create_augroup("tree_preview", { clear = true }),
  callback = function(ev)
    if vim.b[ev.buf].tree_preview and vim.bo[ev.buf].modified then
      unmark(ev.buf)
    end
  end,
})

return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = function(_, opts)
    opts.commands = opts.commands or {}
    opts.commands.preview_open = function(state)
      local node = state.tree:get_node()
      if node.type ~= "file" then
        return state.commands.open(state)
      end

      local existing = vim.fn.bufnr(node:get_id())
      local kept = existing ~= -1 and vim.bo[existing].buflisted and not vim.b[existing].tree_preview

      state.commands.open(state)
      local buf = vim.api.nvim_get_current_buf()
      vim.api.nvim_set_current_win(state.winid)
      if kept or buf == preview_buf then
        return
      end

      drop_preview()
      vim.b[buf].tree_preview = true
      preview_buf = buf
    end

    opts.window = opts.window or {}
    opts.window.mappings = opts.window.mappings or {}
    opts.window.mappings["<Tab>"] = "preview_open"

    -- Opening with <CR>/l fires file_opened; that keeps the buffer. The
    -- preview command marks its buffer only after this has run.
    opts.event_handlers = opts.event_handlers or {}
    table.insert(opts.event_handlers, {
      event = "file_opened",
      handler = function(path)
        local buf = vim.fn.bufnr(path)
        if buf ~= -1 then
          unmark(buf)
        end
      end,
    })
  end,
}
