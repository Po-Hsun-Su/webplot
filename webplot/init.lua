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

local sys = require 'sys'
function webplot.open(fig_path)
  if sys.uname() == 'linux' then
    sys.execute('xdg-open ' .. webplot.host .. '/' .. fig_path)
  elseif sys.uname() == "macos" then
    sys.execute('open ' .. webplot.host .. '/' .. fig_path)
  else
    error("Only linux and osx are supported")
  end
end

return webplot
