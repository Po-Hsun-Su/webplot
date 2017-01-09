local kernel = {}

function kernel.start()
  kernel.ip = "127.0.0.1"
  kernel.http_port = 8080
  kernel.tcp_port = 8081
  kernel.host = "http://" .. kernel.ip .. ':' .. kernel.http_port
  -- start server
  local Queue = require 'threads.queue'
  local clib = require 'libthreads'
  local serialize = "threads.sharedserialize"
  kernel.mainqueue = Queue(1, serialize)
  kernel.threadqueue = Queue(1, serialize)
  kernel.mainqueue:retain()
  kernel.threadqueue:retain()
  kernel.server = clib.Thread(
    string.format(
      [[
      local Queue = require 'threads.queue'
      __threadid = 1
      mainqueue = Queue(%d)
      threadqueue = Queue(%d)
      local threadid = __threadid
      __queue_running = true
      __queue_specific = true
      app = require 'waffle'
      async = require 'async'
      async.tcp.listen({host='%s', port=%d}, function(client)
          --print('new connection')
          client.ondata(function(data)
              -- Data:
              --print('received: ' .. data )
              --print('Do a job')
              if threadqueue.isempty == 0 then
                threadqueue:dojob()
              end
            end)

          -- Done:
          client.onend(function()
              print('client gone...')
            end)
        end)
      app.listen({host='%s', port=%d})
      ]],
      kernel.mainqueue:id(),
      kernel.threadqueue:id(),
      kernel.ip,
      kernel.tcp_port,
      kernel.ip,
      kernel.http_port
    )
  )
  assert(kernel.server, 'Server creation failed')

  -- start client
  local socket = require 'socket'
  kernel.client = socket.tcp()
  local sys = require 'sys'
  local connected = false
  while not connected do -- Improvement: use callback
    sys.sleep(0.01)
    connected = kernel.client:connect(kernel.ip, kernel.tcp_port)
  end
end

function kernel.dojob(cb, maincb)
  kernel.threadqueue:addjob(cb)
  kernel.client:send(' ')
end

function kernel.takeover()
  local running = true
  while running do
    kernel.mainqueue:dojob()
  end
end

return kernel
