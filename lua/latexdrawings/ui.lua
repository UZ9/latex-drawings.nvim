local M = {}

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")
local core = require("latexdrawings.core")

local INCFIG_NAME_PATTERN = "\\\\incfig\\{[^}]+\\}"

function M.choose_latex_drawing()
	pickers
		.new({}, {
			prompt_title = "Select repo to add",
			finder = finders.new_oneshot_job(
				{ "rg", "--line-number", "--no-heading", INCFIG_NAME_PATTERN, "--glob", "*.tex" },
				{

					entry_maker = function(entry)
						local lnum, match = entry:match(":(.*): *\\incfig{(.*)}")

						return {
							value = entry,
							display = match,
							ordinal = match,
							lnum = tonumber(lnum),
						}
					end,
				}
			),

			attach_mappings = function(prompt_bufnr, _)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)

					local entry = action_state.get_selected_entry()

					local inkfig_name = entry.display
					local line_number = entry.lnum

					print("Chose " .. inkfig_name .. " located at  " .. line_number)

					local directory_path = vim.fn.getcwd() .. "/" .. core.DIAGRAM_DIRECTORY_NAME
					core.start_inkscape(directory_path, inkfig_name)
				end)

				return true
			end,
			sorter = conf.generic_sorter({}),
		})
		:find()
end

return M
