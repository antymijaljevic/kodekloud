# Vi/Vim - Top 50 Commands Reference

## Basic Operations

### Mode Switching
- `i` - Insert mode at cursor
- `I` - Insert mode at beginning of line
- `a` - Append after cursor
- `A` - Append at end of line
- `o` - Open new line below
- `O` - Open new line above
- `Esc` - Return to normal mode
- `v` - Visual mode (character selection)
- `V` - Visual line mode
- `Ctrl+v` - Visual block mode

### File Operations
- `:w` - Save file
- `:q` - Quit
- `:wq` or `:x` - Save and quit
- `:q!` - Quit without saving
- `:w filename` - Save as filename
- `:e filename` - Open file
- `:r filename` - Read file and insert below cursor

## Navigation

### Basic Movement
- `h` - Move left
- `j` - Move down
- `k` - Move up
- `l` - Move right
- `w` - Move forward one word
- `b` - Move backward one word
- `e` - Move to end of word
- `0` - Move to beginning of line
- `$` - Move to end of line
- `^` - Move to first non-blank character

### Advanced Navigation
- `gg` - Go to first line
- `G` - Go to last line
- `:n` or `nG` - Go to line n
- `%` - Jump to matching bracket/parenthesis
- `Ctrl+f` - Page down
- `Ctrl+b` - Page up
- `Ctrl+d` - Half page down
- `Ctrl+u` - Half page up

## Editing

### Deleting
- `x` - Delete character under cursor
- `X` - Delete character before cursor
- `dd` - Delete current line
- `dw` - Delete word
- `d$` or `D` - Delete to end of line
- `d0` - Delete to beginning of line

### Copying (Yanking) and Pasting
- `yy` - Yank (copy) current line
- `yw` - Yank word
- `y$` - Yank to end of line
- `p` - Paste after cursor
- `P` - Paste before cursor

### Changing
- `cw` - Change word
- `cc` - Change entire line
- `C` - Change to end of line
- `r` - Replace single character
- `R` - Enter replace mode

### Undo and Redo
- `u` - Undo
- `Ctrl+r` - Redo
- `.` - Repeat last command

## Search and Replace

- `/pattern` - Search forward for pattern
- `?pattern` - Search backward for pattern
- `n` - Repeat search in same direction
- `N` - Repeat search in opposite direction
- `:%s/old/new/g` - Replace all occurrences in file
- `:s/old/new/g` - Replace all occurrences in line

## Additional Useful Commands

- `:set number` - Show line numbers
- `:set nonumber` - Hide line numbers
- `>>` - Indent line
- `<<` - Unindent line
- `==` - Auto-indent line
- `J` - Join current line with next line