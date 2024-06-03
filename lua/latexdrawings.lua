local module = require("latexdrawings.module")

local config = {
	opt = "Hello!",
}

local M = {}

M.config = config

M.setup = function(args)
	M.config = vim.tbl_deep_extend("force", M.config, args or {})
end

M.begin_drawing = function()
	return module.begin_drawing()
end

return M
