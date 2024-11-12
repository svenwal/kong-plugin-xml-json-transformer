local xmljsontransformer = {
    PRIORITY = 1010, -- set the plugin priority, which determines plugin execution order
    VERSION = "0.9",
  }
local xml2lua = require("xml2lua")
local handler = require("xmlhandler.tree")
local parser = xml2lua.parser(handler)
local cjson = require "cjson"

function xmljsontransformer:header_filter(config)
  kong.response.set_header("content-type", "application/json")
  kong.response.clear_header("content-length")
end

function xmljsontransformer:access(config)
	kong.service.request.enable_buffering()
end

function xmljsontransformer:body_filter(config)
  local response_body = kong.service.response.get_raw_body()

  parser:parse(response_body)

  local xml = handler.root
  json_text = cjson.encode(xml)
  kong.response.set_raw_body(json_text)
end

return xmljsontransformer


