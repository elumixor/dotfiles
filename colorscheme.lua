vim.opt.background = 'dark'
vim.g.colors_name = 'mytheme'

-- First we will need lush, and the colorscheme we wish to modify
local lush = require('lush')
local baseTheme = require('meliora').get_theme()

-- we can apply modifications ontop of the existing colorscheme
local spec = lush.extends({baseTheme}).with(function()
  return {
    -- Normal { bg = harbour.Normal.bg.ro(200).sa(10), fg = harbour.Normal.fg },
    -- Use the existing Comment group in harbour, but adjust the gui attribute
    Comment { fg = baseTheme.Comment.fg.ro(120).da(40).de(30), bg = baseTheme.Comment.bg, gui = "italic" },
    -- While we're here, we might decide that the default Function group is too bright
    -- Function { fg = harbour.Function.fg.da(15) }
  }
end)

-- then pass the extended spec to lush for application
lush(spec)
