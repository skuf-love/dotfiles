-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode" })
vim.keymap.set("i", "JJ", "<Esc>:w<Enter>", { desc = "Exit insert mode" })
vim.keymap.set("n", "JJ", ":w<Enter>", { desc = "Exit insert mode" })

vim.keymap.set("n", "<leader>!tc", function()
	local current_buffer_path = vim.api.nvim_buf_get_name(0)

	print("Run specs")
	print(current_buffer_path)

	local cwd = vim.fn.getcwd()
	local current_buffer_name = vim.api.nvim_buf_get_name(0)

	local spec_file = string.gsub(current_buffer_name, cwd .. "/", "")
	print("CWD", cwd)
	print("Buffer name:", current_buffer_name)
	print("Spec file", spec_file)
	--vim.cmd 'vsplit'
	--vim.api.nvim_buf_set_lines(0, -1, -1, false, { cwd, current_buffer_name, spec_file })
	-- local spec_debug_buff = vim.api.nvim_create_buf(true, false)
	--vim.api.nvim_set_current_buf(spec_debug_buff)

	--vim.api.nvim_buf_set_lines(0, -1, -1, false, { 'Current buffer path: ' .. current_buffer_path })
	local output = vim.fn.system("docker container ls --format \"{{.Names}}\" | grep disputer-spring  | tr -d '\n'")
	--vim.api.nvim_buf_set_lines(0, -1, -1, false, { 'Spring container lookup: ' .. output })
	-- print(string.len(output))
	-- local start_index = string.find(output, 'disputer-spring-1')
	-- print(start_index)
	-- if start_index == nil then
	if string.len(output) == 0 then
		--vim.api.nvim_buf_set_lines(0, -1, -1, false, { "Spring container isn't running. Spinning up" })
		local container_start_output = vim.fn.system("docker compose up spring -d")
		print(container_start_output)
		--vim.api.nvim_buf_set_lines(0, -1, -1, false, vim.split(container_start_output, "\n", {plain = true}))
	end
	-- local run_result = vim.fn.system 'docker container exec -it disputer-spring-1 spring rspec spec/models/disputer_spec.rb'
	-- local run_result = vim.fn.system 'docker container exec -i disputer-spring-1 spring rspec spec/models/dispute_spec.rb'

	local rspec_command = "spring rspec " .. spec_file
	local docker_exec = "docker container exec -it disputer-spring-1"
	local full_command = docker_exec .. " " .. rspec_command
	print("Rspec command: ", rspec_command)
	print("Full command: ", full_command)
	--vim.api.nvim_buf_set_lines(0, -1, -1, false, { docker_exec, rspec_command, full_command })

	vim.cmd("new")
	local spec_buff = vim.api.nvim_create_buf(true, false)
	vim.api.nvim_set_current_buf(spec_buff)
	vim.fn.termopen(full_command)
end, { desc = "Run specs" })

-- vim.keymap.set("n", "<leader>rc", function()
-- 	local current_buffer_path = vim.api.nvim_buf_get_name(0)
--
-- 	local cwd = vim.fn.getcwd()
-- 	local current_buffer_name = vim.api.nvim_buf_get_name(0)
--
-- 	print("CWD", cwd)
-- 	print("Buffer name:", current_buffer_name)
-- 	--vim.api.nvim_buf_set_lines(0, -1, -1, false, { docker_exec, rspec_command, full_command })
--
-- 	local full_command = "go run" .. " " .. current_buffer_name
-- 	vim.cmd("new")
-- 	local spec_buff = vim.api.nvim_create_buf(true, false)
-- 	vim.api.nvim_set_current_buf(spec_buff)
-- 	vim.fn.termopen(full_command)
-- end, { desc = "Run current" })

-- vim.keymap.set("n", "<leader>tc", function()
-- 	local cwd = vim.fn.getcwd()
-- 	local file_dir = vim.fn.expand("%:h")
-- 	print("File dir: " .. file_dir)
-- 	local full_command = "go test" .. " " .. cwd .. "/" .. file_dir
-- 	vim.cmd("new")
-- 	local spec_buff = vim.api.nvim_create_buf(true, false)
-- 	vim.api.nvim_set_current_buf(spec_buff)
-- 	vim.fn.termopen(full_command)
-- end, { desc = "Run current" })
