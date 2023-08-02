-- If you're not sure your plugin is executing, uncomment the line below and restart Kong
-- then it will throw an error which indicates the plugin is being loaded at least.

--assert(ngx.get_phase() == "timer", "The world is coming to an end!")

---------------------------------------------------------------------------------------------
-- In the code below, just remove the opening brackets; `[[` to enable a specific handler
--
-- The handlers are based on the OpenResty handlers, see the OpenResty docs for details
-- on when exactly they are invoked and what limitations each handler has.
---------------------------------------------------------------------------------------------



local plugin = {
  PRIORITY = 5,      -- set the plugin priority, which determines plugin execution order
  VERSION = "0.0.1", -- version in X.Y.Z format. Check hybrid-mode compatibility requirements.
}



-- do initialization here, any module level code runs in the 'init_by_lua_block',
-- before worker processes are forked. So anything you add here will run once,
-- but be available in all workers.



function plugin:log(plugin_conf)
  -- Log the request details
  kong.log.debug("Request: ", {
    method = kong.request.get_method(),
    uri = kong.request.get_path(),
    headers = kong.request.get_headers(),
    body = kong.request.get_body(),
  })

  -- Log the response details
  kong.log.debug("Response: ", {
    status = kong.response.get_status(),
    headers = kong.response.get_headers(),
    body = kong.response.get_body(),
  })
end

-- return our plugin object
return plugin
