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
  ngx.header["content-length"] = nil

end

---[[ runs in the 'access_by_lua_block'
function xml_json_transformer:body_filter(config)
  xml_json_transformer.super.body_filter(self)
  
  -- Nginx output filters may be called multiple times for a single request because response body may be delivered in chunks. 
  -- Thus, the Lua code specified by in this directive may also run multiple times in the lifetime of a single HTTP request.
  
  local chunk, eof = ngx.arg[1], ngx.arg[2]

  if ngx.ctx.buffered == nil then
      ngx.ctx.buffered = {}
  end

  if chunk ~= "" and not ngx.is_subrequest then
      table.insert(ngx.ctx.buffered, chunk)
      ngx.arg[1] = nil
  end

  if eof then
      local resp_body = table.concat(ngx.ctx.buffered)
      ngx.ctx.buffered = nil
      pretty.dump(resp_body)

      local result ,errors = pcall(
      function(resp_body)
      	parser:parse(resp_body)
      end, resp_body)

      if not result then
        ngx.log(ngx.ERR, "parse error")
        ngx.arg[1] = resp_body
        ngx.arg[2] = true
      else
        xml = handler.root
        pretty.dump(xml)
        json_text = cjson.encode(xml)
        ngx.arg[1] = json_text
        ngx.arg[2] = true
      end
  end  
end 

end 

-- set the plugin priority, which determines plugin execution order
xml_json_transformer.PRIORITY = 990

-- return our plugin object
return xml_json_transformer

