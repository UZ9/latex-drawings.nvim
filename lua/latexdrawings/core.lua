local M = {}

M.DIAGRAM_DIRECTORY_NAME = "Diagrams"

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

	print("attempting to create..." .. file_path .. "/" .. file_name .. ".svg")
	-- Skip creation if file already exists
	if vim.fn.filereadable(file_path .. "/" .. file_name .. ".svg") == 1 then
		return
	end

	print("got past")

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

local function begin_drawing(drawing_name)
	-- TODO: Move diagram directory to utility class
	local directory_path = vim.fn.getcwd() .. "/" .. M.DIAGRAM_DIRECTORY_NAME

	if vim.fn.isdirectory(directory_path) == 0 then
		vim.fn.mkdir(directory_path)
	end

	-- Blocking task: start inkscape, wait for it to be closed
	M.start_inkscape(directory_path, drawing_name)

	-- Insert latex snippet linking to created diagram
	add_latex_snippet(drawing_name)
end

function M.create_new_drawing()
	local name

	repeat
		name = vim.fn.input("Drawing Name: ")
		print("")
	until (name ~= "") and (string.len(name) <= 20)

	begin_drawing(name)
end

function M.setup(opts)
	opts = opts or {}
end

function M.start_inkscape(file_path, drawing_name)
	-- Attempt to create new inkscape file
	create_inkscape_file(file_path, drawing_name)

	run_command("inkscapecom " .. file_path .. "/" .. drawing_name .. ".svg")

	-- At this point, user has closed inkscape and main thread is no longer locked, we now export into latex
	run_command("inkscapecom --export-type=PDF --export-latex " .. file_path .. "/" .. drawing_name .. ".svg")
end

return M
