return {
  "chrisgrieser/nvim-early-retirement",
  config = true,
  event = "VeryLazy",
  opts = {
    retirementAgeMins = 3,
    -- notificationOnAutoClose = true,
    deleteBufferWhenFileDeleted = true,
  },
}
