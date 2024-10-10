local M = {}

---@param s string
---@param width integer
---@param align? 'center'|'left'|'right'
---@return string
function M.align(s, width, align)
  if not align then
    align = "left"
  end
  local len = vim.fn.strchars(s)
  local left = align == "left"
  while len < width do
    if left then
      s = s .. " "
    else
      s = " " .. s
    end
    if align == "center" then
      left = not left
    end
    len = len + 1
  end
  return s
end

---limit string
---@param s string
---@param width integer
---@param truncate? 'left'|'right'
function M.limit(s, width, truncate)
  truncate = truncate or "right"
  local res = s
  if #res > width then
    if truncate == "left" then
      res = res:sub(#res - width + 1, -1)
    else
      res = res:sub(1, width)
    end
  end
  return res
end

return M
