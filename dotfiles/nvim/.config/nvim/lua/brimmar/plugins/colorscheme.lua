-- return {
--     "glepnir/zephyr-nvim",
--     name = "zephyr",
--     lazy = false,
--     priority = 1000,
--     config = function ()
--         -- load colorscheme here
--         vim.cmd([[colorscheme zephyr]])
--     end
-- }
return {
    "navarasu/onedark.nvim",
    name = "onedark",
    lazy = false,
    priority = 1000,
    config = function ()
        require('onedark').setup({
            style = 'warmer'
        })
        -- load colorscheme here
        vim.cmd([[colorscheme onedark]])
    end
}
