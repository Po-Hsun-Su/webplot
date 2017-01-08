local webplot = require 'webplot'

webplot.start()

local data = torch.Tensor(3,3):fill(1)

webplot.dojob(
  function()
    local _data = data -- share data in main thread to webplot
    app.get('/', function(req, res)
        res.send(tostring(_data))
      end)
  end
)
-- do some computation ...
webplot.takeover() -- takeover control of main thread to keep webplot running
