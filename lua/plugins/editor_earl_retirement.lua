return {
  "chrisgrieser/nvim-early-retirement",
  config = true,
  event = "VeryLazy",
  opts = {
    retirementAgeMins = 1,
    notificationOnAutoClose = true,
    -- deleteBufferWhenFileDeleted = true,
  },
}
