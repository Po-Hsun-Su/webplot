local webplot = require 'webplot'
local dygraph = require 'webplot.dygraph'

local sys = require 'sys'

local x = torch.linspace(0,math.pi,100):view(100,1)
local y1 = torch.sin(x)
local y2 = torch.cos(x)
local data = torch.cat({x,y1,y2},2):totable()

local options = {
  labels = {"x", "sin", "cos"}
}
local fig_path = 'figure1/'

dygraph.add(fig_path, data, options)

webplot.open(fig_path)

for i = 100, 400 do
  sys.sleep(0.03)
  x = i*math.pi/100
  data[i] = {x, math.sin(x),math.cos(x)}
  dygraph.append(fig_path, data[i])
end

webplot.takeover()
