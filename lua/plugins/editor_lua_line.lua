local function lsp_clients()
	local clients = {}
	for _, client in pairs(vim.lsp.buf_get_clients(0)) do
		clients[#clients + 1] = client.name
	end
	table.sort(clients)
	return table.concat(clients, " • "), " "
end

local function langs()
	local l = {}
	for _, client in pairs(vim.lsp.buf_get_clients(0)) do
		local out = nil
		if client.name == "pyright" then
			out = vim.fn.system({ "python", "-V" })
		elseif client.name == "tsserver" then
			out = "node " .. vim.fn.system({ "node", "--version" })
		end
		if out ~= nil and out ~= "" then
			l[#l + 1] = vim.trim(out)
		end
	end

	table.sort(l)
	return table.concat(l, " • "), " "
end

local last_blame = nil
local last_blame_time = vim.loop.now()
local function gitblame()
	local d = vim.b.gitsigns_blame_line_dict

	if d then
		last_blame = d
		last_blame_time = vim.loop.now()
	elseif vim.loop.now() - last_blame_time <= 2000 then
		d = last_blame
	end

	if d then
		local ok, res = pcall(os.date, "%d %b %y", d.committer_time)
		return d.committer:sub(1, 12) .. " - " .. (ok and res or d.committer_time)
	end
	return ""
end

local function smart_tab_name()
	local filepath = vim.fn.expand("%:p")
	local parent_dir = vim.fn.fnamemodify(filepath, ":h:t")
	local filename = vim.fn.fnamemodify(filepath, ":t")

	-- Define a whitelist of patterns
	local whitelist = {
		"index%..*",
		"mod%..*",
		"Dockerfile",
		".env",
		".env%..*",
    "router%..*",
    "controller%..*",
    "service%..*",
    "utils%..*",
    "util%..*",
		"README%..*",
		"LICENSE",
		"Makefile",
		"build%..*",
		"config%..*",
		"setup%..*",
		"init%..*",
		"main%..*",
		"app%..*",
		"test%..*",
		"spec%..*",
		"package%..*",
		"requirements%..*",
		"manifest%..*",
		"composer%..*",
		"gulpfile%..*",
		"Gruntfile%..*",
		"webpack%..*",
		"tsconfig%..*",
		"babel%..*",
		"eslint%..*",
		"prettier%..*",
		"tslint%..*",
		"karma%..*",
		"jest%..*",
		"mocha%..*",
		"rollup%..*",
		"vite%..*",
		"nuxt%..*",
		"next%..*",
		"angular%..*",
		"vue%..*",
		"tailwind%..*",
		"postcss%..*",
		"stylelint%..*",
		"editorconfig",
		"gitignore",
		"gitattributes",
		"gitmodules",
		"docker-compose%..*",
		"dockerfile%..*",
		"dockerignore",
		"travis%..*",
		"circleci%..*",
		"appveyor%..*",
		"azure-pipelines%..*",
		"codecov%..*",
		"coveralls%..*",
		"dependabot%..*",
		"renovate%..*",
		"vercel%..*",
		"netlify%..*",
		"heroku%..*",
		"now%..*",
		"firebase%..*",
		"amplify%..*",
		"serverless%..*",
		"cloudformation%..*",
		"terraform%..*",
		"ansible%..*",
		"chef%..*",
		"puppet%..*",
		"salt%..*",
		"helm%..*",
		"kustomize%..*",
		"kubernetes%..*",
		"skaffold%..*",
		"tilt%..*",
		"argocd%..*",
		"flux%..*",
		"istio%..*",
		"linkerd%..*",
		"prometheus%..*",
		"grafana%..*",
		"loki%..*",
		"jaeger%..*",
		"opentelemetry%..*",
		"zipkin%..*",
		"thanos%..*",
		"victoria-metrics%..*",
		"cortex%..*",
		"alertmanager%..*",
		"blackbox%..*",
		"node_exporter%..*",
		"cadvisor%..*",
		"fluentd%..*",
		"fluentbit%..*",
		"logstash%..*",
		"filebeat%..*",
		"metricbeat%..*",
		"heartbeat%..*",
		"packetbeat%..*",
		"winlogbeat%..*",
		"auditbeat%..*",
		"functionbeat%..*",
		"elastic-agent%..*",
		"elasticsearch%..*",
		"kibana%..*",
		"logstash%..*",
		"beats%..*",
		"opensearch%..*",
		"opensearch-dashboards%..*",
		"graylog%..*",
		"sumologic%..*",
		"datadog%..*",
		"newrelic%..*",
		"dynatrace%..*",
		"appdynamics%..*",
		"instana%..*",
		"lightstep%..*",
		"signalfx%..*",
		"wavefront%..*",
		"scout%..*",
		"rollbar%..*",
		"sentry%..*",
		"bugsnag%..*",
		"airbrake%..*",
		"raygun%..*",
		"overops%..*",
		"pagerduty%..*",
		"opsgenie%..*",
		"victorops%..*",
		"xmatters%..*",
		"statuspage%..*",
		"status.io%..*",
		"pingdom%..*",
		"uptimerobot%..*",
		"site24x7%..*",
		"betteruptime%..*",
		"freshping%..*",
		"healthchecks%..*",
		"deadmanssnitch%..*",
		"cronitor%..*",
		"cronhub%..*",
		"cronitor%..*",
		"healthchecks.io%..*",
	}

	-- Check if the filename matches any pattern in the whitelist
	for _, pattern in ipairs(whitelist) do
		if filename:match(pattern) then
			return parent_dir .. "/" .. filename
		end
	end

	-- If no match, return just the filename
	return filename
end


return {
	"nvim-lualine/lualine.nvim",
	-- dependencies = { { "folke/noice.nvim", optional = true } },
	lazy = false,
	opts = function()
		return {
			options = {
				theme = "codedark",
				section_separators = { left = "", right = "" },
				component_separators = "|",
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = {
					"branch",
					"filename",
				},
				lualine_c = {
					"diff",
					"diagnostics",
					{ "reg_recording", icon = { "󰻃" }, color = { fg = "#D37676" } },
					{ gitblame, color = { fg = "#696969" } },
				},
				lualine_x = {
					lsp_clients,
					langs,
					"encoding",
					"filetype",
					"filesize",
				},
				lualine_y = { "searchcount", "selectioncount" },
				lualine_z = { "location" },
			},
			winbar = {
				lualine_a = {
					{
						smart_tab_name,
						symbols = {
							modified = "", -- Text to show when the file is modified.
							readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
							unnamed = "[No Name]", -- Text to show for unnamed buffers.
							newfile = "[New]", -- Text to show for newly created file before first write
						},
					},
				},
				lualine_b = {
					"mode",
				},
			},
			inactive_winbar = {
				lualine_a = {
					{
						smart_tab_name,
						symbols = {
							modified = "", -- Text to show when the file is modified.
							readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
							unnamed = "[No Name]", -- Text to show for unnamed buffers.
							newfile = "[New]", -- Text to show for newly created file before first write
						},
					},
				},
			},
		}
	end,
	config = function(_, opts)
		require("lualine").setup(opts)

		local ref = function()
			require("lualine").refresh({
				place = { "statusline" },
			})
		end

		local group = vim.api.nvim_create_augroup("myconfig-lua-line-group", { clear = true })
		vim.api.nvim_create_autocmd("RecordingEnter", {
			group = group,
			callback = ref,
		})
		vim.api.nvim_create_autocmd("RecordingLeave", {
			group = group,
			callback = function()
				local timer = vim.loop.new_timer()
				timer:start(50, 0, vim.schedule_wrap(ref))
			end,
		})
	end,
}
