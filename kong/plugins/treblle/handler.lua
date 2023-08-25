-- If you're not sure your plugin is executing, uncomment the line below and restart Kong
-- then it will throw an error which indicates the plugin is being loaded at least.

--assert(ngx.get_phase() == "timer", "The world is coming to an end!")

---------------------------------------------------------------------------------------------
-- In the code below, just remove the opening brackets; `[[` to enable a specific handler
--
-- The handlers are based on the OpenResty handlers, see the OpenResty docs for details
-- on when exactly they are invoked and what limitations each handler has.
---------------------------------------------------------------------------------------------
local http = require("resty.http")
local get_base_url = require('kong.plugins.treblle.base_url')
local cjson = require("cjson")

local plugin = {
  PRIORITY = 5,      -- set the plugin priority, which determines plugin execution order
  VERSION = "0.0.1", -- version in X.Y.Z format. Check hybrid-mode compatibility requirements.
}



-- do initialization here, any module level code runs in the 'init_by_lua_block',
-- before worker processes are forked. So anything you add here will run once,
-- but be available in all workers.
function plugin:log(plugin_conf)
  local request_start_time = ngx.req.start_time()
  local response_end_time = ngx.now()

  local load_time = response_end_time - request_start_time

  local httpc = http.new()

  local base_url = get_base_url({ debug = true })

  local headers = {
    ["Content-Type"] = "application/json",
    ["x-api-key"] = plugin_conf.api_key,
  }
  local body = {
    api_key = plugin_conf.api_key,
    project_id = plugin_conf.project_id,
    sdk = "go",
    version = plugin.VERSION,
    request = {
      ip = ngx.var.remote_addr,
      url = kong.request.get_path(),
      user_agent = kong.request.get_header("User-Agent"),
      method = kong.request.get_method(),
      headers = kong.request.get_headers(),
      body = kong.request.get_body(),
    },
    response = {
      headers = kong.response.get_headers(),
      code = kong.response.get_status(),
      size = tonumber(kong.response.get_header("Content-Length")),
      load_time = load_time,
      body = kong.response.get_body(),
    },
  }

  local json_data = cjson.encode(body)
  print(json_data)
  local _, _ = httpc:request_uri(base_url, {
    method = "POST",
    headers = headers,
    body = json_data
  })
end

-- return our plugin object
return plugin
