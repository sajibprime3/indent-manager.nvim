local Manager = {}

local default_opts = {
	default_indent = 4,
	keymap = "<leader>fi",
}

local default_indent_config = {
	lua = 2,
	java = 4,
	c = 4,
	cpp = 4,
}

local manager_config_path = vim.fn.stdpath("data") .. "/indent-manager"
local manager_config_file = manager_config_path .. "/config.lua"
local indent_config = {}

-- Save config file
local function save_config()
	if vim.fn.isdirectory(manager_config_path) == 0 then
		vim.fn.mkdir(manager_config_path, "p")
	end
	local lines = { "return {" }
	for ft, size in pairs(indent_config) do
		-- table.insert(lines, string.format("  %q = %d,", ft, size))
		table.insert(lines, string.format(" %s = %d,", ft, size))
	end
	table.insert(lines, "}")
	vim.fn.writefile(lines, manager_config_file)
end

local function load_config()
	if vim.fn.filereadable(manager_config_file) == 1 then
		local ok, cfg = pcall(dofile, manager_config_file)
		if ok and type(cfg) == "table" then
			indent_config = cfg
			return
		end
	end
	-- Config file missing or invalid: use defaults and write
	print("Indent Manager: Creating a new config with defaults.")
	indent_config = vim.deepcopy(default_indent_config)
	save_config()
end

-- Apply indentation settings
local function apply_indent(filetype)
	local size = indent_config[filetype] or Manager.options.default_indent
	vim.opt_local.shiftwidth = size
	vim.opt_local.tabstop = size
	vim.opt_local.softtabstop = size
	vim.opt_local.expandtab = true
end

-- Command: :SetIndentSize [size]
function Manager.set_indent_size(size)
	local ft = vim.bo.filetype
	local sz = tonumber(size)
	if not sz then
		print("Usage: :SetIndentSize <number>")
		return
	end
	indent_config[ft] = sz
	save_config()
	apply_indent(ft)
	print("Set indent size for " .. ft .. " to " .. sz)
end

-- Command: :ShowIndentSize
function Manager.show_indent()
	local ft = vim.bo.filetype
	local size = indent_config[ft] or Manager.options.default_indent
	print("Indent for " .. ft .. ": " .. size)
end

-- Command: :OpenIndentConfig
function Manager.open_config()
	vim.cmd("edit " .. manager_config_file)
end

-- Setup user config
function Manager.setup(opts)
	Manager.options = vim.tbl_deep_extend("force", default_opts, opts or {})
	load_config()

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		callback = function(args)
			-- local ft = vim.bo.filetype
			local ft = vim.api.nvim_get_option_value("filetype", { buf = args.buf })
			apply_indent(ft)
		end,
	})

	vim.api.nvim_create_user_command("SetIndentSize", function(args)
		Manager.set_indent_size(args.args)
	end, { nargs = 1 })

	vim.api.nvim_create_user_command("ShowIndentSize", function()
		Manager.show_indent()
	end, {})

	vim.api.nvim_create_user_command("OpenIndentConfig", function()
		Manager.open_config()
	end, {})
	vim.keymap.set("n", Manager.options.keymap, "", { desc = "Indent Manager" })
	vim.keymap.set("n", Manager.options.keymap .. "z", Manager.show_indent, { desc = "Show indent si(z)e" })
	vim.keymap.set("n", Manager.options.keymap .. "c", Manager.open_config, { desc = "Open indent (c)onfig" })
end

return Manager
