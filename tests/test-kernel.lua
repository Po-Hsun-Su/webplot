local webplot = require 'webplot'

local data = torch.Tensor(3,3):fill(1)

webplot.dojob(
  function()
    app.get('/', function(req, res)
        res.send(tostring(data))
      end)
  end
)
-- do some computation ...
webplot.takeover() -- takeover control of main thread to keep webplot running
