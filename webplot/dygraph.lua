local webplot = require 'webplot'

local webplot_path = webplot.path
local webplot_host = webplot.host

local dygraph = {}

function dygraph.add(fig_path, data, options)
  webplot.dojob(
    function()
      _data[fig_path] = data
      _options[fig_path] = cjson.encode(options)
      app.get(fig_path, function(req, res)
          res.render(webplot_path .. 'dygraph.html', {
              data = cjson.encode(_data[fig_path]),
              options = _options[fig_path]
            })
        end)

      app.ws(fig_path .. 'ws', function(ws)
          ws.checkorigin = function(origin) print(origin) return origin == webplot_host end
          ws.onopen = function(req)
            print('/ws/opened')
            _ws[fig_path] = ws
          end
          ws.onclose = function(req) print('/ws/closed') end
        end)
    end)
end

function dygraph.append(fig_path, new_data)
  webplot.dojob(
    function()
      local data = _data[fig_path]
      data[#data + 1] = new_data
      if _ws[fig_path] then
        _ws[fig_path]:write(cjson.encode(new_data))
      end
    end)
end

return dygraph
