package = "webplot"
version = "scm-1"

source = {
   url = "https://github.com/Po-Hsun-Su/webplot",
   tag = "master"
}

description = {
   summary = "Web plot interface for torch7",
   detailed = [[
        Web plot interface for torch7
   ]],
   homepage = "https://github.com/Po-Hsun-Su/webplot"
}

dependencies = {
   "torch >= 7.0",
   "sys >= 1.0",
   "luasocket >= 2.0",
   "lua-cjson >= 2.1.0",
   "async >= 1.0",
   "threads >= 1.0",
}

build = {
   type = "command",
   install_command = "cp -r webplot $(LUADIR)/"
}
