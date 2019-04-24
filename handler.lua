-- Grab pluginname from module name
local plugin_name = "xml-json-transformer"
local responses = require "kong.tools.responses"
local cjson = require "cjson"
local table_concat = table.concat
local xml2lua = require("xml2lua")
local handler = require("xmlhandler.tree")
local parser = xml2lua.parser(handler)

-- load the base plugin object and create a subclass
local xml_json_transformer = require("kong.plugins.base_plugin"):extend()

-- constructor
function xml_json_transformer:new()
  xml_json_transformer.super.new(self, plugin_name)
end

function xml_json_transformer:header_filter(conf)
  xml_json_transformer.super.header_filter(self)

  --ngx.header["content-encoding"] = "none"
  ngx.header["content-type"] = "application/json"

end

---[[ runs in the 'access_by_lua_block'
function xml_json_transformer:body_filter(config)
  xml_json_transformer.super.body_filter(self)
  
 
  local ctx = ngx.ctx 
  local response_body =''

  local resp_body = string.sub(ngx.arg[1], 1, 1000)  
    ctx.buffered = string.sub((ctx.buffered or "") .. resp_body, 1, 1000)
    -- arg[2] is true if this is the last chunk
    if ngx.arg[2] then
      response_body = ctx.buffered
    end
  parser:parse(resp_body)

  local xml = handler.root
  json_text = cjson.encode(xml)
  ngx.arg[2] = ""
  ngx.arg[1] = json_text
end 

-- set the plugin priority, which determines plugin execution order
xml_json_transformer.PRIORITY = 990

-- return our plugin object
return xml_json_transformer

