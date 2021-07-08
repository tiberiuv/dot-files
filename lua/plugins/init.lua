local require_reset = require("utils").require_reset

-- Package manager + plugins
require_reset("plugins/packer")

-- Plugin specific config
require_reset("plugins/identline")
-----------------------------------------

-- No config plugin imports
require("nvim-ale-diagnostic")
