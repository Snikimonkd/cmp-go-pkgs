local source = {}

local items = {}

local list_pkgs_command = "gopls.list_known_packages"

source.new = function()
	local self = setmetatable({}, { __index = source })

	return self
end

local init_items = function(a)
	local client = vim.lsp.get_client_by_id(a.data.client_id)
	local bufnr = vim.api.nvim_get_current_buf()
	local uri = vim.uri_from_bufnr(bufnr)
	local arguments = { { URI = uri } }

	client.request("workspace/executeCommand", {
		command = list_pkgs_command,
		arguments = arguments,
	}, function(arg1, arg2, _)
		if arg2 == nil and arg1 ~= nil then
			vim.notify(("LSP error: %s"):format(vim.inspect(arg1)), vim.log.levels.DEBUG)
			return
		end

		if arg1 == nil and arg2 == nil then
			vim.notify("both arg1 and arg2 are nil", vim.log.levels.DEBUG)
			return
		end

		local tmp = {}

		for _, v in ipairs(arg2.Packages) do
			table.insert(tmp, {
				label = string.format('"%s"', v),
				kind = 9,
				insertText = string.format('"%s"', v),
			})
		end

		items[bufnr] = tmp
	end, bufnr)
end

vim.api.nvim_create_autocmd({ "LspAttach" }, {
	pattern = { "*.go" },
	callback = init_items,
})

source._check_if_inside_imports = function()
	local cur_node = require("nvim-treesitter.ts_utils").get_node_at_cursor()

	local func = cur_node
	local flag = false

	while func do
		if func:type() == "import_declaration" then
			flag = true
			break
		end

		func = func:parent()
	end

	return flag
end

source.complete = function(self, _, callback)
	local ok = self._check_if_inside_imports()
	if ok == false then
		vim.notify("not inside imports", vim.log.levels.DEBUG)
		callback()
		return
	end

	local bufnr = vim.api.nvim_get_current_buf()

	if next(items) == nil or items[bufnr] == nil then
		callback()
		return
	end

	callback({ items = items[bufnr], isIncomplete = false })
end

source.is_available = function()
	return vim.bo.filetype == "go"
end

return source
