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

require("fg"):setup({
  default_action = "nvim",
})

require("git"):setup()

require("session"):setup({
  sync_yanked = true,
})

require("projects"):setup({
  event = {
    save = {
      enable = true,
      name = "project-saved",
    },
    load = {
      enable = true,
      name = "project-loaded",
    },
    delete = {
      enable = true,
      name = "project-deleted",
    },
    delete_all = {
      enable = true,
      name = "project-deleted-all",
    },
    merge = {
      enable = true,
      name = "project-merged",
    },
  },
  save = {
    method = "yazi",
    yazi_load_event = "@projects-load",
    lua_save_path = "",
  },
  last = {
    update_after_save = true,
    update_after_load = true,
    update_before_quit = false,
    load_after_start = false,
  },
  merge = {
    event = "projects-merge",
    quit_after_merge = false,
  },
  notify = {
    enable = true,
    title = "Projects",
    timeout = 3,
    level = "info",
  },
})
