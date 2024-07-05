local M = {}

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local conf = require("telescope.config").values

local function find_all_drawings() end

function M.choose_latex_drawing()
	pickers
		.new({}, {
			prompt_title = "Select cloned repo to remove",
			finder = finders.new_table({
				results = { "one", "two" },
			}),
			attach_mappings = function(prompt_bufnr, _)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)

					local selection = action_state.get_selected_entry()

					print("Chose " .. selection)
				end)

				return true
			end,
			sorter = conf.generic_sorter({}),
		})
		:find()
end

return M
