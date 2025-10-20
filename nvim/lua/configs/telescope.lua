local action_state = require("telescope.actions.state")
local action_utils = require("telescope.actions.utils")

local function single_or_multi_select(prompt_bufnr)
	local current_picker = action_state.get_current_picker(prompt_bufnr)
	local has_multi_selection = (next(current_picker:get_multi_selection()) ~= nil)

	if has_multi_selection then
		local results = {}
		action_utils.map_selections(prompt_bufnr, function(selection)
			table.insert(results, selection[1])
		end)

		-- load the selections into buffers list without switching to them
		for _, filepath in ipairs(results) do
			vim.cmd.badd({ args = { filepath } })
		end

		require("telescope.pickers").on_close_prompt(prompt_bufnr)

		-- switch to newly loaded buffers if on an empty buffer
		if vim.fn.bufname() == "" and not vim.bo.modified then
			vim.cmd.bwipeout()
			vim.cmd.buffer(results[1])
		end
		return
	end

	-- if does not have multi selection, open single file
	require("telescope.actions").file_edit(prompt_bufnr)
end

return function(_, conf)
	conf.defaults.path_display = {
		filename_first = {
			reverse_directories = false,
		},
	}

	conf.defaults.mappings.i = {
		["<cr>"] = single_or_multi_select,
	}

	return conf
end
