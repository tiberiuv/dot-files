local require_reset = require("utils").require_reset

-- Package manager + plugins
require_reset("plugins/packer")

-- Plugin specific config
require_reset("plugins/compe_setup")
require_reset("plugins/treesitter")
require_reset("plugins/fzf")
require_reset("plugins/lualine")
require_reset("plugins/smooth_scroll")
require_reset("plugins/identline")
require_reset("plugins/toggle_term")
require_reset("plugins/ale")
require_reset("plugins/nerdtree")
-----------------------------------------

-- No config plugin imports
require("nvim-ale-diagnostic")
