local kernel = require 'webplot.kernel'
local webplot_path = package.searchpath("webplot", package.path)
kernel.path = webplot_path:sub(1, webplot_path:len() - 8)
kernel.start()

return kernel
