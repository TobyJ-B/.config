local ls = require('luasnip')
local s, i, f, d, sn = ls.snippet, ls.insert_node, ls.function_node, ls.dynamic_node, ls.snippet_node
local fmt = require('luasnip.extras.fmt').fmt

-- course folder name, skipping lectures/ and problems/ subfolders
local function course_name()
	local dir = vim.fn.expand('%:p:h')
	local name = vim.fn.fnamemodify(dir, ':t'):lower()
	if name == 'lectures' or name == 'problems' then
		dir = vim.fn.fnamemodify(dir, ':h')
	end
	return vim.fn.fnamemodify(dir, ':t')
end

-- simple "#name[...]" block snippets
local function block(trig, name)
	return s(trig, fmt('#' .. name .. '[\n  {}\n]', { i(0) }))
end

return {
	-- new lecture file: course defaults to the folder name, date to today
	s('lec', fmt([[
#import "@local/notes:0.1.0": *
#show: lecture.with(
  course: "{}",
  title: "{}",
  date: "{}",
)

{}]], {
		d(1, function() return sn(nil, i(1, course_name())) end),
		i(2, 'Title'),
		f(function() return os.date('%d %B %Y') end),
		i(0),
	})),

	-- new problem sheet
	s('sheet', fmt([[
#import "@local/notes:0.1.0": *
#show: sheet.with(
  course: "{}",
  title: "{}",
  subtitle: "{}",
)

{}]], {
		d(1, function() return sn(nil, i(1, course_name())) end),
		i(2, 'Problem Sheet'),
		i(3, 'Topics'),
		i(0),
	})),

	s('ans', fmt('#ans[{}]', { i(0) })),

	block('def', 'definition'),
	block('thm', 'theorem'),
	block('lem', 'lemma'),
	block('ex', 'example'),
	block('nt', 'note'),
	block('todo', 'todo'),
	block('pf', 'proof'),

	s('algo', fmt([=[
#algo(title: "{}")[
  + {}
]]=], { i(1, 'Name'), i(0) })),
}
