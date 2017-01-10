local webplot = require 'webplot.kernel'
local webplot_path = package.searchpath("webplot", package.path)
webplot.path = webplot_path:sub(1, webplot_path:len() - 8)

webplot.start()
webplot.dojob(
  function()
    cjson = require 'cjson'
    _ws = {}
    _data = {}
    _options = {}
  end
)

return webplot
