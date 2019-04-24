-- config input validation scripts


-- plugin configuration


return {
  no_consumer = false, -- this plugin is available on APIs as well as on Consumers,
  fields = {
    ignore_content_type = {type = "boolean", default = false},
    
  },
  self_check = function(schema, plugin_t, dao, is_updating)
    return true
  end
}
