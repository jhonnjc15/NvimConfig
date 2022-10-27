local ls = require "luasnip"
-- some shorthands...
local snip = ls.snippet
local node = ls.snippet_node
local text = ls.text_node
local insert = ls.insert_node
local func = ls.function_node
local choice = ls.choice_node
local dynamicn = ls.dynamic_node

local rep = require("luasnip.extras").rep

ls.config.set_config {
    history = true,
    -- treesitter-hl has 100, use something higher (default is 200).
    ext_base_prio = 200,
    -- minimal increase in priority.
    ext_prio_increase = 1,
    enable_autosnippets = false,
    store_selection_keys = "<c-s>",
}

local date = function()
    return { os.date "%Y-%m-%d" }
end

local filename = function()
    return { vim.fn.expand "%:p" }
end

-- Make sure to not pass an invalid command, as io.popen() may write over nvim-text.
local function bash(_, _, command)
    local file = io.popen(command, "r")
    local res = {}
    for line in file:lines() do
        table.insert(res, line)
    end
    return res
end

ls.add_snippets(nil, {
  all = {
    snip({
      trig = "date",
      namr = "Date",
      dscr = "Date in the form of YYYY-MM-DD",
    }, {
      func(date, {}),
    }),
    snip({
      trig = "pwd",
      namr = "PWD",
      dscr = "Path to current working directory",
    }, {
      func(bash, {}, { user_args = { "pwd" } }),
    }),
    snip({
      trig = "filename",
      namr = "Filename",
      dscr = "Absolute path to file",
    }, {
      func(filename, {}),
    }),
    snip({
      trig = "signature",
      namr = "Signature",
      dscr = "Name and Surname",
    }, {
      text "Sergei Bulavintsev",
      insert(0),
    }),
  },
  sh = {
    snip("shebang", {
      text { "#!/bin/sh", "" },
      insert(0),
    }),
  },
  python = {
    snip("shebang", {
      text { "#!/usr/bin/env python3", "" },
      insert(0),
    }),
  },
  lua = {
       snip("shebang", {
           text { "#!/usr/bin/lua", "", "" },
           insert(0),
       }),
       snip("req", {
           text "require('",
           insert(1, "Module-name"),
           text "')",
           insert(0),
       }),
       snip("func", {
           text "function(",
           insert(1, "Arguments"),
           text { ")", "\t" },
           insert(2),
           text { "", "end", "" },
           insert(0),
       }),
       snip("forp", {
           text "for ",
           insert(1, "k"),
           text ", ",
           insert(2, "v"),
           text " in pairs(",
           insert(3, "table"),
           text { ") do", "\t" },
           insert(4),
           text { "", "end", "" },
           insert(0),
       }),
       snip("fori", {
           text "for ",
           insert(1, "k"),
           text ", ",
           insert(2, "v"),
           text " in ipairs(",
           insert(3, "table"),
           text { ") do", "\t" },
           insert(4),
           text { "", "end", "" },
           insert(0),
       }),
       snip("if", {
           text "if ",
           insert(1),
           text { " then", "\t" },
           insert(2),
           text { "", "end", "" },
           insert(0),
       }),
       snip("M", {
           text { "local M = {}", "", "" },
           insert(0),
           text { "", "", "return M" },
       }),
   },
  javascript = {
    snip({
      trig = "rfc",
      namr = "rfc",
      dscr = "React Functional Component",
    }, {
    text {"import React from \"react\";", ""},
    text {"","const "},
    rep(1),
    text {" = () => {", "", "  "},
    text {"return (", ""},
    text {"    <div>", ""},
    text "      ",
    insert(0),
    text {"", "    </div>", ""},
    text "  )",
    text {"","};"},
    text {"", "", "export default { "},
    insert(1, "ComponenteName"),
    text " };",
    })
  }
})
require("luasnip/loaders/from_vscode").load({ paths = { "./snippets" } }) -- Load snippets from my-snippets folder


