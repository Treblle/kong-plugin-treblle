local base_urls = {
  "https://rocknrolla.treblle.com",
  "https://punisher.treblle.com",
  "https://sicario.treblle.com",
}

local function get_base_url(config)
  config = config or {}

  if config.debug then
    return "https://debug.treblle.com/"
  else
    local random_url_index = math.random(#base_urls)
    return base_urls[random_url_index]
  end
end

return get_base_url
