---------------------------------------------------
--------------------- KEYMAPS ---------------------
---------------------------------------------------

local keymaps = vim.keymap
local opts = {
  noremap = true,
  silent = true,
}

-- Select all
keymaps.set("n", "<C-a>", "gg<S-v>G")

-- Save File
keymaps.set("n", "<C-s>", ":w<Return>")

-- Close current buffer
keymaps.set("n", "<C-w>", ":bd<Return>:bn<Return>", opts)

-- Save File with Notification
keymaps.set("n", "<C-s>", function()
  vim.cmd("w")
  vim.notify("Súbor bol úspešne uložený. ✔", vim.log.levels.INFO, { title = "Uloženie" })
end, { desc = "Uložiť súbor a zobraziť notifikáciu" })

-- umplist
keymaps.set("n", "<C-m>", "<C-i>", opts)

-- Split window
keymaps.set("n", "ss", ":split<Return>", opts)
keymaps.set("n", "sv", ":vsplit<Return>", opts)

---------------------------------------------------
-------------------- NEOSCROLL --------------------
---------------------------------------------------

local neoscroll = require("neoscroll")

neoscroll.setup({
  easing_function = "linear", -- Typ easing funkcie
})

---------------------------------------------------
---------------------- DEBUG ----------------------
---------------------------------------------------

local dap = require("dap")

keymaps.set("n", "<F6>", dap.continue)
keymaps.set("n", "<F9>", dap.step_over)
keymaps.set("n", "<F8>", dap.step_into)
keymaps.set("n", "<F7>", dap.step_out)
keymaps.set("n", "<Leader>b", dap.toggle_breakpoint)
keymaps.set("n", "<Leader>B", function()
  dap.set_breakpoint(vim.fn.input("Podmienka breakpointu: "))
end)
keymaps.set("n", "<Leader>lp", function()
  dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end)
keymaps.set("n", "<Leader>dr", dap.repl.open)
keymaps.set("n", "<Leader>dl", dap.run_last)

---------------------------------------------------
--------------------- HARPOON ---------------------
---------------------------------------------------

-- Harpoon keybindings
local ui = require("harpoon.ui")

-- Pridanie aktuálneho súboru do Harpoon (klávesová skratka s "a")
keymaps.set("n", "<leader>a", function()
  require("harpoon.mark").add_file()
  local bufname = vim.fn.expand("%:t")
  vim.notify(
    "Buffer " .. bufname .. " bol pridaný do Harpoon. ✔",
    vim.log.levels.INFO,
    { title = "Harpoon Pridanie" }
  )
end, { desc = "Harpoon úspešné pridanie bufferu." })

-- Otvorenie Harpoon menu
keymaps.set("n", "<leader>g", ui.toggle_quick_menu, { desc = "Zobraziť Harpoon menu" })

-- Rýchle prepínanie medzi 4 hlavnými súbormi pomocou <leader>h, <leader>j, <leader>k, <leader>l
keymaps.set("n", "<leader>h", function()
  require("harpoon.ui").nav_file(1)
end, { desc = "Prejsť na súbor 1" })

keymaps.set("n", "<leader>j", function()
  require("harpoon.ui").nav_file(2)
end, { desc = "Prejsť na súbor 2" })

keymaps.set("n", "<leader>k", function()
  require("harpoon.ui").nav_file(3)
end, { desc = "Prejsť na súbor 3" })

keymaps.set("n", "<leader>l", function()
  require("harpoon.ui").nav_file(4)
end, { desc = "Prejsť na súbor 4" })

---------------------------------------------------
----------------------- LSP -----------------------
---------------------------------------------------

-- Mapovanie pre formátovanie kódu
keymaps.set("n", "<A-f>", vim.lsp.buf.format, { desc = "Formátovať kód" })

-- Mapovanie pre prechod na definíciu
keymaps.set("n", "gd", vim.lsp.buf.definition, { desc = "Prejsť na definíciu" })

-- Importujte Telescope
local telescope_builtin = require("telescope.builtin")
-- Nastavenie key-bindu 'su' v normálnom režime pre funkciu 'Show Usages' pomocou Telescope
keymaps.set("n", "su", telescope_builtin.lsp_references, { desc = "Show Usages" })

-- Create a global terminal for all languages
local Terminal = require("toggleterm.terminal").Terminal
local global_terminal = Terminal:new({ hidden = true, direction = "vertical", size = vim.o.columns * 0.1 })

-- Funkcia na nastavenie klávesových skratiek pre rôzne jazyky
function RunCurrentFile()
  local filetype = vim.bo.filetype
  local current_file_path = vim.fn.expand("%:p") -- Získa plnú cestu k aktuálnemu súboru
  vim.cmd("w") -- Uloží aktuálny súbor
  if not global_terminal:is_open() then
    global_terminal:open()
  end
  local command = ""
  if filetype == "python" then
    command = PythonSetup(current_file_path)
  elseif filetype == "java" then
    command = JavaSetup(current_file_path)
  end
  global_terminal:send(command, true)
end

-- Keybinding to toggle the terminal with <leader>t
keymaps.set("n", "<leader>t", function()
  global_terminal:toggle()
end, { noremap = true, silent = true, desc = "Toggle terminal" })

keymaps.set("n", "<leader>r", function()
  RunCurrentFile()
end, { noremap = true, silent = true, desc = "Run current file" })

---------------------------------------------------
---------------------- Python ---------------------
---------------------------------------------------

-- Funkcia na spustenie Python kódu
function PythonSetup(file_path)
  return "python3 " .. file_path
end

---------------------------------------------------
----------------------- Java ----------------------
---------------------------------------------------

-- Funkcia na spustenie Java kódu bez balíkov
function JavaSetup(file_path)
  local class_name = vim.fn.fnamemodify(file_path, ":t:r") -- Získa názov súboru bez prípony (názov triedy)
  local dir = vim.fn.fnamemodify(file_path, ":p:h") -- Získa cestu k priečinku súboru
  local tmp_dir = vim.fn.stdpath("data") .. "/java_classes" -- Dočasný priečinok pre .class súbory

  return "mkdir -p "
    .. tmp_dir
    .. " && cd "
    .. dir
    .. " && javac -d "
    .. tmp_dir
    .. " "
    .. file_path
    .. " && java -cp "
    .. tmp_dir
    .. " "
    .. class_name
    .. " && rm -r "
    .. tmp_dir
end

---------------------------------------------------
----------------------- END -----------------------
---------------------------------------------------
