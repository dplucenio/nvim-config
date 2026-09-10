local M = {}

local function trim(value)
  return value:match("^%s*(.-)%s*$")
end

local function is_escaped(value, index)
  local backslashes = 0
  index = index - 1

  while index > 0 and value:sub(index, index) == "\\" do
    backslashes = backslashes + 1
    index = index - 1
  end

  return backslashes % 2 == 1
end

local function parse_row(line)
  local indent = line:match("^(%s*)") or ""
  local value = trim(line:sub(#indent + 1))
  local cells = {}
  local current = {}
  local code_ticks = nil
  local saw_delimiter = false
  local ended_with_delimiter = false
  local index = 1

  while index <= #value do
    local character = value:sub(index, index)

    if character == "`" then
      local run_end = index
      while value:sub(run_end + 1, run_end + 1) == "`" do
        run_end = run_end + 1
      end

      local run_length = run_end - index + 1
      if code_ticks == nil then
        code_ticks = run_length
      elseif code_ticks == run_length then
        code_ticks = nil
      end

      table.insert(current, value:sub(index, run_end))
      ended_with_delimiter = false
      index = run_end + 1
    elseif character == "|" and code_ticks == nil and not is_escaped(value, index) then
      table.insert(cells, trim(table.concat(current)))
      current = {}
      saw_delimiter = true
      ended_with_delimiter = true
      index = index + 1
    else
      table.insert(current, character)
      ended_with_delimiter = false
      index = index + 1
    end
  end

  table.insert(cells, trim(table.concat(current)))

  if value:sub(1, 1) == "|" then
    table.remove(cells, 1)
  end
  if ended_with_delimiter then
    table.remove(cells, #cells)
  end

  if not saw_delimiter or #cells == 0 then
    return nil, "is not a Markdown table row"
  end

  return { indent = indent, cells = cells }
end

local function separator_alignment(cell)
  local left, dashes, right = cell:match("^(:?)(%-+)(:?)$")

  if not dashes or #dashes < 3 then
    return nil
  end
  if left == ":" and right == ":" then
    return "center"
  end
  if right == ":" then
    return "right"
  end
  if left == ":" then
    return "left"
  end

  return "default"
end

local function padded_cell(value, width, alignment)
  local padding = width - vim.fn.strdisplaywidth(value)

  if alignment == "right" then
    return string.rep(" ", padding) .. value
  end
  if alignment == "center" then
    local left = math.floor(padding / 2)
    return string.rep(" ", left) .. value .. string.rep(" ", padding - left)
  end

  return value .. string.rep(" ", padding)
end

local function separator_cell(width, alignment)
  if alignment == "center" then
    return ":" .. string.rep("-", width - 2) .. ":"
  end
  if alignment == "right" then
    return string.rep("-", width - 1) .. ":"
  end
  if alignment == "left" then
    return ":" .. string.rep("-", width - 1)
  end

  return string.rep("-", width)
end

function M.format_lines(lines)
  if #lines < 2 then
    return nil, "select a complete table, including its separator row"
  end

  local rows = {}
  local column_count = nil

  for row_index, line in ipairs(lines) do
    local row, error_message = parse_row(line)
    if not row then
      return nil, string.format("row %d %s", row_index, error_message)
    end

    column_count = column_count or #row.cells
    if #row.cells ~= column_count then
      return nil, string.format(
        "row %d has %d columns; expected %d",
        row_index,
        #row.cells,
        column_count
      )
    end

    table.insert(rows, row)
  end

  local alignments = {}
  local widths = {}

  for column = 1, column_count do
    local alignment = separator_alignment(rows[2].cells[column])
    if not alignment then
      return nil, "the second selected row is not a valid Markdown table separator"
    end

    alignments[column] = alignment
    if alignment == "center" then
      widths[column] = 3
    elseif alignment == "left" or alignment == "right" then
      widths[column] = 2
    else
      widths[column] = 1
    end
  end

  for row_index, row in ipairs(rows) do
    if row_index ~= 2 then
      for column, cell in ipairs(row.cells) do
        widths[column] = math.max(widths[column], vim.fn.strdisplaywidth(cell))
      end
    end
  end

  local formatted = {}
  for row_index, row in ipairs(rows) do
    local cells = {}

    for column, cell in ipairs(row.cells) do
      if row_index == 2 then
        cells[column] = separator_cell(widths[column] + 2, alignments[column])
      else
        cells[column] = padded_cell(cell, widths[column], alignments[column])
      end
    end

    if row_index == 2 then
      formatted[row_index] = row.indent .. "|" .. table.concat(cells, "|") .. "|"
    else
      formatted[row_index] = row.indent .. "| " .. table.concat(cells, " | ") .. " |"
    end
  end

  return formatted
end

function M.format_range(buffer, first_line, last_line)
  local lines = vim.api.nvim_buf_get_lines(buffer, first_line - 1, last_line, false)
  local formatted, error_message = M.format_lines(lines)

  if not formatted then
    return false, "MarkdownTable: " .. error_message
  end

  vim.api.nvim_buf_set_lines(buffer, first_line - 1, last_line, false, formatted)
  return true
end

return M
