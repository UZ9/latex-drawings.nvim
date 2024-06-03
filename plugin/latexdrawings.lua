-- Version check
if vim.fn.has("nvim-0.7.0") ~= 1 then
	vim.api.nvim_err_writeln("Example.nvim requires at least nvim-0.7.0.")
end

vim.api.nvim_create_user_command("BeginDrawing", require("latexdrawings").begin_drawing, {})
