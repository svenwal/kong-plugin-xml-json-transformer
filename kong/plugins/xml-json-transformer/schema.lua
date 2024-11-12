return {
  name = "xml-json-transformer",
  fields = {
    { config = {
        type = "record",
        fields = {
		{ ignore_content_type = {type = "boolean", default = false}, },
        },
      },
    },
  },
  entity_checks = {
    -- Add any checks here if needed
  },
}

