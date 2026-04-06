-- direnv.vim - Auto-load project environment variables
-- This enables project devShells to provide LSPs and tools automatically
return {
	"direnv/direnv.vim",
	lazy = false, -- Must load early before LSP
	priority = 90,
}
