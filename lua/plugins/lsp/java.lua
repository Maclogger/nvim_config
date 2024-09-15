-- lua/lsp/java.lua
local util = require("lspconfig.util")

return {
  jdtls = {
    cmd = { "jdtls" },
    root_dir = function(fname)
      return util.root_pattern("build.gradle", "pom.xml", ".git")(fname) or util.path.dirname(fname)
    end,
    settings = {
      java = {
        eclipse = {
          downloadSources = true,
        },
        configuration = {
          updateBuildConfiguration = "interactive",
        },
        maven = {
          downloadSources = true,
        },
        implementationsCodeLens = {
          enabled = true,
        },
        referencesCodeLens = {
          enabled = true,
        },
        format = {
          enabled = true,
        },
      },
    },
  },
}
