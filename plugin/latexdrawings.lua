-- Version check
if vim.fn.has("nvim-0.7.0") ~= 1 then
	vim.api.nvim_err_writeln("latexdrawings.nvim requires at least nvim-0.7.0.")
end

vim.api.nvim_create_user_command("BeginDrawing", require("latexdrawings").core.begin_drawing, {})
vim.api.nvim_create_user_command("ChooseDrawing", require("latexdrawings").ui.choose_latex_drawing, {})
