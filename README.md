# webplot: an embedded plot server for torch

**webplot** is light-weight embedded plot server based on [waffle](https://github.com/benglard/waffle) and [threads](https://github.com/torch/threads). Just `require 'webplot'` and you are good to go. No server launches required. See [examples](#examples).

The embedded webplot server is fully controllable as it equipped a task queue for you to give it job asynchronously. See [Technical overview](#overview) to add any web page to the server any where in your script.

Features of webplot:
* Launch itself in your script seamlessly. No manual server launches.
* Is fully controllable with Lua script
* Read tensor in your script without memory copy
* Support Websocket for live update

## Installation
Install [waffle](https://github.com/benglard/waffle)
    luarocks install https://raw.githubusercontent.com/benglard/htmlua/master/htmlua-scm-1.rockspec
    luarocks install https://raw.githubusercontent.com/benglard/waffle/master/waffle-scm-1.rockspec
Install **webplot**
    luarocks install https://raw.githubusercontent.com/Po-Hsun-Su/webplot/master/webplot-scm-1.rockspec

## <a name='examples'></a> Examples
Plot sin and cosine using [dygraph](http://dygraphs.com/)
```lua
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

dygraph.add(fig_path, data, options) -- add to server
webplot.open(fig_path) -- open the plot in browser

```
Live update
```lua
for i = 100, 400 do
  sys.sleep(0.03)
  x = i*math.pi/100
  data[i] = {x, math.sin(x),math.cos(x)}
  dygraph.append(fig_path, data[i]) -- append data and redraw
end

webplot.takeover() -- block main thread to keep webplot server alive
```

## <a name='overview'></a> Technical overview
The webplot embedded server is a [waffle](https://github.com/benglard/waffle) server running on a thread created by [threads](https://github.com/torch/threads). The server starts with a task [queue](https://github.com/torch/threads#queue) that you can use to give jobs to the server asynchronously. For example, you tell the server to setup a web page that prints a tensor.
```lua
local webplot = require 'webplot'

local data = torch.Tensor(3,3):fill(1)

webplot.dojob(
  function()
    app.get('/', function(req, res) -- app is an instance of waffle server
        res.send(tostring(data)) -- send the upvalue "data" when client "get \"
      end)
  end
)
-- do other stuff ...

webplot.takeover() -- block main thread
```
With `dojob()`, you can add any web page to the waffle server at any time without blocking your script!

Let's see how dygraph plot is implemented using `dojob()` and [html rendering](https://github.com/benglard/waffle#html-rendering) of [waffle](https://github.com/benglard/waffle).
```lua
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
    end)
end
```
#### Live update via Websocket
Live update is implemented using [Websocket](https://github.com/benglard/waffle#websockets). See [dygraph.lua](https://github.com/Po-Hsun-Su/webplot/blob/master/webplot/dygraph.lua) and [dygraph.html](https://github.com/Po-Hsun-Su/webplot/blob/master/webplot/dygraph.html) for example of establishing Websockt connection.
