package = "kong-plugin-xml-json-transformer"
version = "0.2.0-1"
supported_platforms = {"linux", "macosx"}
source = {
   url = "https://github.com/svenwal/kong-plugin-xml-json-transformer"
}
description = {
   summary = "xml-json-transformer is a Kong plugin to trasnfer XML responses to JSON",
   detailed = [[
## Configuration parameters
|FORM PARAMETER|DEFAULT|DESCRIPTION|
|:----|:------:|------:|
|config.ignore_content_type|false|This parameter can be used if any traffic (not only application/xml) shall be tried to convert|
]],
   homepage = "https://github.com/svenwal/kong-plugin-xml-json-transformer",
   license = "BSD 2-Clause License"
}
dependencies = {
   "xml2lua >= 1.4",
}

build = {
  type = "builtin",
  modules = {
    -- TODO: add any additional files that the plugin consists of
    ["kong.plugins."..pluginName..".handler"] = "kong/plugins/"..pluginName.."/handler.lua",
    ["kong.plugins."..pluginName..".schema"] = "kong/plugins/"..pluginName.."/schema.lua",
  }
}
