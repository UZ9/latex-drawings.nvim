local config = {
	opt = "Hello!",
}

local M = {}

M.core = require("latexdrawings.core")
M.ui = require("latexdrawings.ui")
M.config = config

M.setup = function(args)
	M.config = vim.tbl_deep_extend("force", M.config, args or {})
end

return M
