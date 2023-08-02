local typedefs = require "kong.db.schema.typedefs"

local PLUGIN_NAME = "treblle"


local schema = {
  name = PLUGIN_NAME,
  fields = {
    -- the 'fields' array is the top-level entry with fields defined by Kong
    { consumer = typedefs.no_consumer }, -- this plugin cannot be configured on a consumer (typical for auth plugins)
    { protocols = typedefs.protocols_http },
    {
      config = {
        -- The 'config' record is the custom part of the plugin schema
        type = "record",
        fields = {
          {
            project_id = {
              required = true,
              type = "string"
            },
          },
          {
            api_key = {
              required = true,
              type = "string"
            },
          },
          {
            additional_fields_to_mask = {
              default = {},
              type = "array",
              elements = typedefs.header_name
            }
          }
        }, -- adding a constraint for the value
      },
    },
  },
}

return schema
