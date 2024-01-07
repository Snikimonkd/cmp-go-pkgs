require("cmp").register_source("go_pkgs", require("cmp_go_pkgs"))

vim.api.nvim_create_user_command("CurNode", function(c)
	require("cmp_go_pkgs.source").kek(c)
end, {})
