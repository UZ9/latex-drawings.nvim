local M = {}

M.DIRECTORY_NAME = "Diagrams"

function M.stop_drawing()
	print("Stopped drawing")
end

function M.begin_drawing()
	local function start_inkscape(file_path)
		local handle = io.popen("inkscape " .. file_path)

		if handle then
			local result = handle:read("*a")
			handle:close()

			if result ~= "" then
				vim.notify("Result: " .. result, vim.log.levels.ERROR)
			end
		end
	end

	local directory_path = vim.fn.getcwd() .. "/" .. M.DIRECTORY_NAME
	local file_name = "test.svg"

	if vim.fn.isdirectory(directory_path) == 0 then
    print(directory_path .. " not found, so creating it now...")
		vim.fn.mkdir(directory_path)
	end

	start_inkscape(directory_path .. "/" .. file_name)
end

function M.handle_stdout(_, data)
	print("stdout called")
	print(data)
end

function M.setup(opts)
	opts = opts or {}
end

return M
