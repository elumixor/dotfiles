local registers = require("registers")

registers.setup({
    show_empty = false,
    show_register_types = false,
    window = {
        max_width = 100,
        border = "none",
        transparency = 0,
    },
    bind_keys = {
        registers = registers.apply_register(),
    },
})
