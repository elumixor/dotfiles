vim.opt.background = 'dark'
vim.g.colors_name = 'mytheme'

-- First we will need lush, and the colorscheme we wish to modify
local lush = require('lush')
local hsl = lush.hsl

local baseTheme = require('meliora').get_theme()

local Add = hsl(120, 40, 45)
local Change = hsl(45, 80, 50)
local Delete = hsl(0, 50, 50)

local Warning = hsl(30, 100, 50)
local Info = hsl(200, 10, 50)
local Hint = hsl(120, 10, 50)

-- we can apply modifications ontop of the existing colorscheme
local spec = lush.extends({baseTheme}).with(function()
  return {
    Normal { bg = hsl(220, 15, 10), fg = baseTheme.Normal.fg },
    -- Use the existing Comment group in harbour, but adjust the gui attribute
    Comment { fg = baseTheme.Comment.fg.ro(120).da(40).de(30), bg = baseTheme.Comment.bg, gui = "italic" },
    -- While we're here, we might decide that the default Function group is too bright
    -- Function { fg = harbour.Function.fg.da(15) }
        --
    ScrollbarHandle { fg = baseTheme.CursorLine.fg, bg = hsl(203, 10, 15) },

    DiffAdd { fg = Add, bg = Add.de(80).da(70) },
    DiffChange { fg = Change, bg = Change.de(80).da(70) },
    GitSignsAdd { DiffAdd },
    GitSignsChange { DiffChange },
    DiffDelete { fg = Delete, bg = Delete.de(80).da(70) },
    GitSignsDelete { DiffDelete },

    DiagnosticVirtualTextError { fg = baseTheme.Error.fg, bg = baseTheme.Error.bg },
    DiagnosticVirtualTextWarn { fg = Warning, bg = Warning.de(80).da(70) },
    DiagnosticVirtualTextInfo { fg = Info, bg = baseTheme.Normal.bg },
    DiagnosticVirtualTextHint { fg = Hint, bg = baseTheme.Normal.bg },

    ScrollbarError { DiagnosticVirtualTextError, bg = baseTheme.Normal.bg },
    ScrollbarWarn { DiagnosticVirtualTextWarn, bg = baseTheme.Normal.bg },
    ScrollbarInfo { DiagnosticVirtualTextInfo, bg = baseTheme.Normal.bg },
    ScrollbarHint { DiagnosticVirtualTextHint, bg = baseTheme.Normal.bg },

    ScrollbarErrorHandle { ScrollbarError, bg = ScrollbarHandle.bg },
    ScrollbarWarnHandle { ScrollbarWarn, bg = ScrollbarHandle.bg },
    ScrollbarInfoHandle { ScrollbarInfo, bg = ScrollbarHandle.bg },
    ScrollbarHintHandle { ScrollbarHint, bg = ScrollbarHandle.bg },
  }
end)

-- then pass the extended spec to lush for application
lush(spec)
