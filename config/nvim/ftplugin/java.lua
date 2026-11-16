local jdtls = require("jdtls")
local root_util = require("config.root")

local root = root_util.find(0, {
	"gradlew", "mvnw", "pom.xml", "build.gradle", "build.gradle.kts", ".git",
})

local workspace = vim.fn.stdpath("data") .. "/jdtls-workspace/"
	.. vim.fn.fnamemodify(root, ":t") .. "-" .. vim.fn.sha256(root):sub(1, 8)

-- Source folders from .nvimroot, if any are listed
local source_paths = root_util.read_marker(root)

local java_settings = {}
if #source_paths > 0 then
	java_settings.project = { sourcePaths = source_paths }
end

jdtls.start_or_attach({
	cmd = { "jdtls", "-data", workspace },
	root_dir = root,
	settings = { java = java_settings },
})
