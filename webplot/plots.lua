local webplot = require 'webplot'
local webplot_path = webplot.path
local webplot_host = webplot.host
print(webplot_host)
function webplot.dygraph(fig_path, data, options)
  webplot.dojob(
    function()
      cjson = require 'cjson'
      if not _ws then _ws = {} end
      if not _data then _data = {} end
      if not _options then _options = {} end
      _data[fig_path] = data
      _options[fig_path] = cjson.encode(options)
      app.get(fig_path, function(req, res)
          res.render(webplot_path .. 'dygraph.html', {
              data = cjson.encode(_data[fig_path]),
              options = _options[fig_path]
            })
        end)
      print(fig_path)
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

function webplot.dygraph_append(fig_path, new_data)
  webplot.dojob(
    function()
      local data = _data[fig_path]
      data[#data + 1] = new_data
      if _ws[fig_path] then
        _ws[fig_path]:write(cjson.encode(new_data))
      end
    end)
end

return webplot
