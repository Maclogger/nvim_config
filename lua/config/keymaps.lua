---------------------------------------------------
--------------------- KEYMAPS ---------------------
---------------------------------------------------

local keymap = vim.keymap
local opts = {
  noremap = true,
  silent = true,
}

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Save File
keymap.set("n", "<C-s>", ":w<Return>")

-- Close current buffer
keymap.set("n", "<C-w>", ":bd<Return>:bn<Return>", opts)

-- Save File with Notification
keymap.set("n", "<C-s>", function()
  vim.cmd("w")
  vim.notify("Súbor bol úspešne uložený. ✔", vim.log.levels.INFO, { title = "Uloženie" })
end, { desc = "Uložiť súbor a zobraziť notifikáciu" })

-- Umplist
keymap.set("n", "<C-m>", "<C-i>", opts)

-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)

-- Quick rename word under the cursor
keymap.set("n", "<leader>rt", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gc<Left><Left><Left>]])

-- Quick comment
-- gc (by default)

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

keymap.set("n", "<F6>", dap.continue)
keymap.set("n", "<F9>", dap.step_over)
keymap.set("n", "<F9>", dap.step_into)
keymap.set("n", "<F7>", dap.step_out)
keymap.set("n", "<Leader>b", dap.toggle_breakpoint)
keymap.set("n", "<Leader>B", function()
  dap.set_breakpoint(vim.fn.input("Podmienka breakpointu: "))
end)
keymap.set("n", "<Leader>lp", function()
  dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end)
keymap.set("n", "<Leader>dr", dap.repl.open)
keymap.set("n", "<Leader>dl", dap.run_last)

---------------------------------------------------
---------------------- C# DAP ---------------------
---------------------------------------------------

keymap.set("n", "<F5>", function()
  require("csharp").debug_project()
end)

---------------------------------------------------
--------------------- HARPOON ---------------------
---------------------------------------------------

-- Harpoon keybindings
local ui = require("harpoon.ui")

-- Pridanie aktuálneho súboru do Harpoon (klávesová skratka s "a")
keymap.set("n", "<leader>a", function()
  require("harpoon.mark").add_file()
  local bufname = vim.fn.expand("%:t")
  vim.notify(
    "Buffer " .. bufname .. " bol pridaný do Harpoon. ✔",
    vim.log.levels.INFO,
    { title = "Harpoon Pridanie" }
  )
end, { desc = "Harpoon úspešné pridanie bufferu." })

-- Otvorenie Harpoon menu
keymap.set("n", "<leader>g", ui.toggle_quick_menu, { desc = "Zobraziť Harpoon menu" })

-- Rýchle prepínanie medzi 4 hlavnými súbormi pomocou <leader>h, <leader>j, <leader>k, <leader>l
keymap.set("n", "<leader>h", function()
  require("harpoon.ui").nav_file(1)
end, { desc = "Prejsť na súbor 1" })

keymap.set("n", "<leader>j", function()
  require("harpoon.ui").nav_file(2)
end, { desc = "Prejsť na súbor 2" })

keymap.set("n", "<leader>k", function()
  require("harpoon.ui").nav_file(3)
end, { desc = "Prejsť na súbor 3" })

keymap.set("n", "<leader>l", function()
  require("harpoon.ui").nav_file(4)
end, { desc = "Prejsť na súbor 4" })

keymap.set("n", "<leader>ô", function()
  require("harpoon.ui").nav_file(5)
end, { desc = "Prejsť na súbor 5" })

keymap.set("n", "<leader>§", function()
  require("harpoon.ui").nav_file(6)
end, { desc = "Prejsť na súbor 6" })

---------------------------------------------------
----------------------- LSP -----------------------
---------------------------------------------------

-- Mapovanie pre formátovanie kódu
keymap.set("n", "<A-f>", vim.lsp.buf.format, { desc = "Formátovať kód" })

--
-- Mapovanie pre prechod na definíciu
keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Prejsť na definíciu" })

-- Importujte Telescope
local telescope_builtin = require("telescope.builtin")

-- Nastavenie zobrazenie chýb na sd
keymap.set("n", "sd", telescope_builtin.diagnostics, { desc = "Zobraziť diagnostiky" })

keymap.set("n", "úd", vim.diagnostic.goto_prev, { desc = "Predchádzajúca diagnostika" })
keymap.set("n", "äd", vim.diagnostic.goto_next, { desc = "Nasledujúca diagnostika" })

-- Nastavenie key-bindu 'su' v normálnom režime pre funkciu 'Show Usages' pomocou Telescope
keymap.set("n", "su", telescope_builtin.lsp_references, { desc = "Show Usages" })

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
keymap.set("n", "<leader>t", function()
  global_terminal:toggle()
end, { noremap = true, silent = true, desc = "Toggle terminal" })

keymap.set("n", "<leader>r", function()
  RunCurrentFile()
end, { noremap = true, silent = true, desc = "Run current file" })

function AttachDartLS()
  local lspconfig = require("lspconfig")
  local dart_client = nil

  for _, client in ipairs(vim.lsp.get_active_clients()) do
    if client.name == "dartls" then
      dart_client = client
      break
    end
  end

  if dart_client then
    vim.lsp.buf_attach_client(0, dart_client.id)
    print("dartls attached to buffer")
  else
    print("dartls client not found")
  end
end

-- Vytvor mapovanie, napríklad na <leader>ld
vim.api.nvim_set_keymap("n", "<leader>ld", ":lua AttachDartLS()<CR>", { noremap = true, silent = true })
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
--------------------- NEOGEN ----------------------
---------------------------------------------------

-- Funkcia na vygenerovanie dokumentácie
keymap.set("n", "<leader>d", function()
  require("neogen").generate()
end)

---------------------------------------------------
----------------------- END -----------------------
---------------------------------------------------
