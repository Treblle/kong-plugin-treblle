local typedefs = require "kong.db.schema.typedefs"

local PLUGIN_NAME = "treblle"


local schema = {
  name = PLUGIN_NAME,
  fields = {
    -- the 'fields' array is the top-level entry with fields defined by Kong
    { consumer = typedefs.no_consumer }, -- this plugin cannot be configured on a consumer (typical for auth plugins)
    protocols = {
      type = "array",
      required = true,
      default = { "http", "https" },
      elements = {
        type = "string",
        one_of = { "http", "https" }
      }
    },
    {
      config = {
        -- The 'config' record is the custom part of the plugin schema
        type = "record",
        fields = {
          project_id = {
            required = true,
            type = "string"
          },
          api_key = {
            required = true,
            type = "string"
          },
        }, -- adding a constraint for the value
      },
    },
  },
}

return schema
