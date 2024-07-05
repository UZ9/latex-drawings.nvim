local M = {}

M.DIAGRAM_DIRECTORY_NAME = "Diagrams"

function M.begin_drawing()
	local function run_command(command)
		local handle = io.popen(command)

		if handle then
			local result = handle:read("*a")
			handle:close()

			if result ~= "" then
				vim.notify("Result: " .. result, vim.log.levels.ERROR)
			end
		end
	end

	local function create_inkscape_file(file_path, file_name)
		-- TODO: inkscapecom is a windows specific, find some way of making this universal
		run_command(
			[[inkscapecom --actions="file-new; export-area-page; export-filename:]]
				.. file_path
				.. "/"
				.. file_name
				.. [[.svg; export-do;]]
		)
	end

	local function add_latex_snippet(figure_name)
		local snippet_text = {
			[[\begin{figure}]] .. "[ht]",
			[[    \centering]],
			[[    \incfig{]] .. figure_name .. [[}]],
			[[    \caption{Image Caption}]],
			[[    \label{fig:]] .. figure_name .. [[}]],
			[[\end{figure}]],
		}

		local row, col = unpack(vim.api.nvim_win_get_cursor(0))

		vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, snippet_text)

		vim.api.nvim_win_set_cursor(0, { row, col })
	end

	local function start_inkscape(file_path, file_name)
		-- Attempt to create new inkscape file
		create_inkscape_file(file_path, file_name)

		run_command("inkscapecom " .. file_path .. "/" .. file_name .. ".svg")

		-- At this point, user has closed inkscape and main thread is no longer locked, we now export into latex
		run_command("inkscapecom --export-type=PDF --export-latex " .. file_path .. "/" .. file_name .. ".svg")

		-- Insert latex snippet linking to created diagram
		add_latex_snippet(file_name)
	end

	local directory_path = vim.fn.getcwd() .. "/" .. M.DIAGRAM_DIRECTORY_NAME
	local file_name = "test"

	if vim.fn.isdirectory(directory_path) == 0 then
		vim.fn.mkdir(directory_path)
	end

	start_inkscape(directory_path, file_name)
end

function M.setup(opts)
	opts = opts or {}
end

return M
