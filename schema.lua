-- config input validation scripts

local function validate_percentage_latency(given_value, given_config)
  local percentage = tonumber(given_value) or -1
  if percentage  < 0 or percentage > 100 then
    return false, "Only numbers between 0 and 100"
  end

  given_config.percentage_latency=percentage
end

local function validate_percentage_error(given_value, given_config)
  local percentage = tonumber(given_value) or -1
  if percentage < 0 or percentage > 100 then
    return false, "Only numbers between 0 and 100"
  end

  given_config.percentage_error=percentage
end

local function validate_minimum(given_value, given_config)
  local minimum = tonumber(given_value) or -1
  if minimum <0 then
    return false, "Minimum latency must not be smaller than 0"
  end

  --if minimum > given_config.maximum_latency_msec then
  --  return false, "Minimum latency must not be bigger than maximum latency"
  --end

  given_config.minimum_latency_msec = minimum
end

local function validate_maximum(given_value, given_config)
  local maximum = tonumber(given_value) or -1
  if maximum <0 then
    return false, "Maximum latency must not be smaller than 0"
  end

  --if maximum < given_config.minimum_latency_msec then
  --  return false, "Minimum latency must not be bigger than maximum latency"
  --end

  given_config.maximum_latency_msec = maximum
end

local function validate_status_codes(v, t, column)
  if v and type(v) == "table" then
    for _, error_type in ipairs(v) do
      local number = tonumber(error_type) or -1
      if number < 100 or number > 999 then
        return false, "Only numbers between 100 and 999 allowed"
      end
    end
  end
  return true
end

-- plugin configuration


return {
  no_consumer = false, -- this plugin is available on APIs as well as on Consumers,
  fields = {
    -- Describe your plugin's configuration's schema here.
    minimum_latency_msec = {type = "integer", required = true, func = validate_minimum, default = 0},
    maximum_latency_msec = {type = "integer", required = true, func = validate_maximum, default = 1000},
    percentage_latency = {type = "integer", required = true, func = validate_percentage_latency, default = 50},
    status_codes = {type = "array", required = false, func = validate_status_codes },
    percentage_error = {type = "integer", required = false, func = validate_percentage_error, default = 0},
    add_header = {type = "boolean", default = true},
    
  },
  self_check = function(schema, plugin_t, dao, is_updating)
    return true
  end
}
