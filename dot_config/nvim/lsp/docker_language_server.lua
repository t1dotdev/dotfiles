-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/docker_language_server.lua
-- Compose files are plain `yaml` in nvim 0.12, so yamlls covers them.
return {
	cmd = { "docker-language-server", "start", "--stdio" },
	filetypes = { "dockerfile" },
	root_markers = { "Dockerfile", "docker-compose.yaml", "docker-compose.yml", "compose.yaml", "compose.yml", ".git" },
}
