local ok, jdtls = pcall(require, "jdtls")
if not ok then
  return
end

local root_dir = vim.fs.root(0, {
  "pom.xml",
  "build.gradle",
  "build.gradle.kts",
  "settings.gradle",
  "settings.gradle.kts",
  "mvnw",
  "gradlew",
  ".git",
})

if not root_dir then
  return
end

local project_name = vim.fs.basename(root_dir)
local workspace_dir = vim.fs.joinpath(vim.fn.stdpath("cache"), "jdtls", project_name)

jdtls.start_or_attach({
  cmd = {
    "jdtls",
    "-data",
    workspace_dir,
  },
  root_dir = root_dir,
  capabilities = require("blink.cmp").get_lsp_capabilities(),
  init_options = {
    bundles = {},
  },
})
