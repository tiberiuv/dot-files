return {
  "cenk1cenk2/schema-companion.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
  },
  config = function()
    -- PLEASE FOLLOW THE CONFIGURATION INSTRUCTIONS BELOW SINCE THERE IS AN ADDITIONAL STEP NEEDED FOR EACH LANGUAGE SERVER
    require("schema-companion").setup({})
  end,
}
