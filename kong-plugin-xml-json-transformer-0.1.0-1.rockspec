package = "kong-plugin-xml-json-transformer"
version = "0.3.0-1"
supported_platforms = {"linux", "macosx"}
source = {
   url = "git+https://github.com/svenwal/kong-plugin-xml-json-transformer.git"
}
description = {
   summary = "xml-json-transformer is a Kongplugin which adds a random latency and/or random errors to responses in order to simulate bad networks.",
   detailed = [[
## Configuration parameters
|FORM PARAMETER|DEFAULT|DESCRIPTION|
|:----|:------:|------:|
|config.minimum_latency_msec|0|This parameter describes the minimum latency (msec) to be added|
|config.maximum_latency_msec|1000|This parameter describes the maximum latency (msec) to be added|
|config.percentage_latency|50|Percentage of requests which shall get the latency added|
|config.percentage_error|0|Percentage of requests which shall return an error|
|config.status_codes|500|Array of http status codes which will be used if error is returned (random selection from array)|
|config.add_header|true|If set to true a header X-Kong-Latency-Injected will be added with either the value of the added latency or none if random generator has chosen not to add a latency. Also adds the X-Kong-Error-Injected header if http status code has been added.|]],
   homepage = "https://github.com/svenwal/kong-plugin-xml-json-transformer",
   license = "BSD 2-Clause License"
}
dependencies = {}
build = {
   type = "builtin",
   modules = {
      handler = "handler.lua",
      schema = "schema.lua"
   }
}
