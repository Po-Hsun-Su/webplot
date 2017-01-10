local webplot = require 'webplot'
local dygraph = require 'webplot.dygraph'

local sys = require 'sys'

local data = {{0, math.sin(0), math.cos(0)}}
local options = {
  labels = {"x", "sin", "cos"}
}
local fig_path = 'figure1/'

dygraph.add(fig_path, data, options)

sys.execute('xdg-open ' .. webplot.host .. '/' .. fig_path)

for i = 2, 3000 do
  sys.sleep(0.03)
  x = (i-1)*2*math.pi/1000
  data[i] = {x, math.sin(x),math.cos(x)}
  dygraph.append(fig_path, data[i])
end

webplot.takeover()
