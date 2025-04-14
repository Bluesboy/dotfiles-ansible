require("bookmarks"):setup({
  last_directory = { enable = false, persist = true, mode = "dir" },
  persist = "all",
  desc_format = "full",
  file_pick_mode = "parent",
  custom_desc_input = false,
  notify = {
    enable = false,
    timeout = 1,
    message = {
      new = "New bookmark '<key>' -> '<folder>'",
      delete = "Deleted bookmark in '<key>'",
      delete_all = "Deleted all bookmarks",
    },
  },
})

require("starship"):setup({
  hide_flags = false,
  flags_after_prompt = true,
})

require("git"):setup()
