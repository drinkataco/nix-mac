return function()
  require("marks").setup({
    -- Use the plugin's built-in motions and toggle keys; they are already terse
    -- and map cleanly onto Vim's mark model.
    default_mappings = true,
    -- Persist uppercase marks promptly so cross-session bookmarks do not depend
    -- on a later manual shada write.
    force_write_shada = true,
  })
end
