FROM alpine
RUN apk add --no-cache --update neovim \
                                git \ 
                                ripgrep \ 
                                fd \
                                curl \
                                unzip \
                                tar \
                                gzip \
                                nodejs \
                                npm \
                                cargo \
                                xclip \
                                wget \
                                bash \
                                php82 \
                                composer \
                                build-base
COPY config/ /root/.config/nvim
RUN nvim --headless "+Lazy! sync" +qa
RUN nvim --headless "+LspInstall intelephense tsserver html cssls jsonls tailwindcss bashls svelte lua_ls emmet_ls dockerls yamlls rust_analyzer ansiblels astro elixirls volar" +qa
RUN nvim --headless "+MasonInstall prettierd blade-formatter php-cs-fixer" +qa
RUN nvim --headless "+MasonInstall phpstan eslint_d" +qa
RUN nvim --headless "+TSInstallSync json javascript typescript yaml html css markdown markdown_inline svelte graphql bash lua vim dockerfile gitignore query astro elixir php phpdoc regex rust scss vue" +qa
CMD [ "nvim", "/home/"]
