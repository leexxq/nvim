local keymap = vim.keymap.set

-- Leader key (space bar)
vim.g.mapleader = " "
--- lsp
-- C-x-o for autocomplete suggestion
----------------


---------------
--- vim builtin
-- :w shortcut
keymap("n", "<Leader>w", ":w<CR>", { desc = "Write" })

-- :q shortcut
keymap("n", "<Leader>q", ":q<CR>", { desc = "Quit/Close" })

-- Scroll with mouse
keymap("n", "<ScrollWheelUp>", "<C-Y>", {})
keymap("n", "<ScrollWheelDown>", "<C-E>", {})

-- Split vertically
keymap("n", "<Leader>s", ":vsplit<CR>", { silent = true })

-- Navigate splits
keymap("n", "<C-Left>", ":winc h<CR>", { silent = true })
keymap("n", "<C-Down>", ":winc j<CR>", { silent = true })
keymap("n", "<C-Up>", ":winc k<CR>", { silent = true })
keymap("n", "<C-Right>", ":winc l<CR>", { silent = true })

-- Resize current split
keymap("n", "<Leader>+", ":vertical resize +5<CR>", { silent = true })
keymap("n", "<Leader>-", ":vertical resize -5<CR>", { silent = true })

keymap("n", "<m-h>", ":tabprev<CR>", { silent = true })
keymap("n", "<m-l>", ":tabnext<CR>", { silent = true })

keymap("n", "<m-1>", ":tabn 1<CR>", { silent = true })
keymap("n", "<m-2>", ":tabn 2<CR>", { silent = true })
keymap("n", "<m-3>", ":tabn 3<CR>", { silent = true })
keymap("n", "<m-4>", ":tabn 4<CR>", { silent = true })
keymap("n", "<m-5>", ":tabn 5<CR>", { silent = true })
keymap("n", "<m-6>", ":tabn 6<CR>", { silent = true })
keymap("n", "<m-7>", ":tabn 7<CR>", { silent = true })
keymap("n", "<m-8>", ":tabn 8<CR>", { silent = true })
keymap("n", "<m-9>", ":tabn 9<CR>", { silent = true })
keymap("n", "<m-0>", ":tabn 10<CR>", { silent = true })

---in insert quick cursor move likely terminal
keymap("i", "<C-a>", "<Home>", {})
keymap("i", "<C-f>", "<Right>", {})
keymap("i", "<C-b>", "<Left>", {})
keymap("i", "<C-e>", "<End>", {})

-- keymap("i", "<C-CR>", "<esc>A;<CR>")



keymap("n", "<C-W>t", ":tabnew<CR>", { desc = "Create new tab window", silent = true, })
keymap("n", "[n", ":cn<CR>", { desc = "jump to next error after make", silent = true, })
keymap("n", "]n", ":cp<CR>", { desc = "jump to previous error after make", silent = true, })

keymap("n", "<esc><esc>", "<Cmd>winc q<CR>", { desc = "close cur window,same as winc q", silent = true });
