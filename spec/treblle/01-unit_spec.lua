local PLUGIN_NAME = "treblle"


-- helper function to validate data against a schema
local validate
do
  local validate_entity = require("spec.helpers").validate_plugin_config_schema
  local plugin_schema = require("kong.plugins." .. PLUGIN_NAME .. ".schema")

  function validate(data)
    return validate_entity(data, plugin_schema)
  end
end


describe(PLUGIN_NAME .. ": (schema)", function()
  it("accepts distinct api_key and project_id", function()
    local ok, err = validate({
      api_key = "Treblle-API-Key",
      project_id = "Treblle-Project-ID",
    })
    assert.is_nil(err)
    assert.is_truthy(ok)
  end)
end)

describe(PLUGIN_NAME .. ": (get_base_url)", function()
  it("returns a string", function()
    local get_base_url = require("kong.plugins.treblle.base_url")
    local base_url = get_base_url()
    assert.is_string(base_url)
  end)

  it("returns debug url", function()
    local get_base_url = require("kong.plugins.treblle.base_url")
    local base_url = get_base_url({ debug = true })
    assert(base_url == 'https://debug.treblle.com/', "Did not return debug base URL")
  end)
end)
