-- Grab pluginname from module name
local plugin_name = "xml-json-transformer"
local responses = require "kong.tools.responses"
local cjson = require "cjson"

-- load the base plugin object and create a subclass
local xml_json_transformer = require("kong.plugins.base_plugin"):extend()

-- constructor
function xml_json_transformer:new()
  xml_json_transformer.super.new(self, plugin_name)
end

---[[ runs in the 'access_by_lua_block'
function xml_json_transformer:body_filter(config)
  xml_json_transformer.super.body_filter(self)
  
  local xml2lua = require("xml2lua")
  --Uses a handler that converts the XML to a Lua table
  local handler = require("xmlhandler.tree")


  --Instantiates the XML parser
  local parser = xml2lua.parser(handler)
  local xmlSource = [[
    <people>
      <person type="natural">
        <name>Manoel</name>
        <city>Palmas-TO</city>
      </person>
      <person type="legal">
        <name>University of Brasília</name>
        <city>Brasília-DF</city>
      </person>  
    </people>    
    ]]
    parser:parse(xmlSource)

  local xml = handler.root.people

  --ngx.log(ngx.ERR, "*** Parsing done")

  --json_text = cjson.encode(xml)
  --json_text= "{}"
  --ngx.log(ngx.ERR, json_text)
  ngx.header["Content-Type"] = "application/json"
  return responses.send(200, xml)
end 

-- set the plugin priority, which determines plugin execution order
xml_json_transformer.PRIORITY = 995

-- return our plugin object
return xml_json_transformer

