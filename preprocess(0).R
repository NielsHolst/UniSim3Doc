rm(list=ls(all=TRUE))
library(plyr)
library(stringr)

setwd("~/sites/UniSim3Doc/src")

create_dest_dirs = function() {

  str_locate_last = function(s) {
    hits = str_locate_all(s,"/")[[1]]
    tail(hits,1)[1]
  }

  dest_dirs = function() {
    cuts = aaply(dest_names, 1, str_locate_last)
    substr(dest_names, 1, cuts-1)
  }

  for (dir in dest_dirs()) {
    if (dir != ".." & !(dir.exists(dir))) {
      print(paste("Create", dir))
      dir.create(dir, recursive=TRUE)
    }
  }
}

read_file = function(file_name) {
  print(paste("Reading", file_name))
  con = file(file_name,open="r")
  lines = readLines(con, warn=FALSE) 
  close(con)
  lines
}

write_file = function(file_name, lines) {
  print(paste("Writing", file_name))
  f = file(file_name, "wt", encoding="UTF-8")
  writeLines(lines, f, sep="\n")
  close(f)
}


double_single_dollars = function(s) {
  hits = str_locate_all(s,"(?<!\\$)\\$(?!\\$)")[[1]][,1]
  if (length(hits) > 0) {
    res = ""
    hits = c(0, hits)
    for (i in 2:length(hits)) {
      from = hits[i-1]+1
      to   = hits[i]
      res  = paste0(res, paste0(substr(s, from, to), "$"))
      # print(c(from,to))
      # print(res)
    }
    from = hits[i]+1
    res = paste0(res, substring(s, from))
    # print(from)
    # print(res)
    res
  } else {
    s
  }
}

# double_single_dollars("")
# double_single_dollars("$")
# double_single_dollars("$$")
# double_single_dollars("$a")
# double_single_dollars("$$a")
# double_single_dollars("b$")
# double_single_dollars("b$$")
# double_single_dollars("a$bc$$d$e")

extract_macros = function(lines) {

  extract_name = function(s) {
    cmd = str_extract(s, "\\{[^\\}]*\\}")
    substr(cmd,2, nchar(cmd)-1)
  }

  extract_cardinality = function(s) {
    n = str_extract(s, "\\[[^\\]]*\\]")
    n = str_extract(s, "\\[[0-9^\\]]*]")
    if (is.na(n)) 0 else as.numeric(substr(n, 2, nchar(n)-1))
  }

  extract_definition = function(s) {
    from = str_locate(s, ".*\\\\newcommand\\{[^\\}]*\\}(\\[[^\\]]*\\])?")[1,2] + 1
    to = nchar(s)
    result = trimws(substr(s, from, to))
    result = substr(result, 2, nchar(result)-1)
    str_replace_all(result, "\\\\", "\\\\\\\\")
  }

  command_lines = which(str_detect(lines, ".*\\\\newcommand"))
  if (length(command_lines) == 0) return(NULL)
  commands = lines[command_lines]

  M = data.frame(
    Line        = commands,
    LineNumber  = command_lines,
    RegExp        = paste0("\\", aaply(commands, 1, extract_name), "(?=($|[^a-zA-Z]))"), # Next character is either empty (end of line) or not a letter
    Cardinality = aaply(commands, 1, extract_cardinality),
    Definition  = aaply(commands, 1, extract_definition)
  )
  for (i in 1:nrow(M)) {
    m = M[i,]
    if (m$Cardinality > 0)  M$Name[i] = paste0(m$Name, paste0(rep("\\{.*\\}", m$Cardinality), collapse=""))
  }
  M
}

replace_macro = function(macro) {
  ix = which(str_detect(lines, macro$RegExp))
  lines[ix] <<- str_replace_all(lines[ix], macro$RegExp, paste0("{", macro$Definition, "}"))
}

char = function(s, pos) {
  substr(s, pos, pos)
}

extract_arguments = function(s, n) {
  M = data.frame (
    From  = rep(NA, n),
    To    = rep(NA, n),
    Value = rep(NA, n)
  )
  pos = 1
  for (i in 1:n) {
    # Find first {
    while (char(s, pos) != "{") pos = pos + 1
    M$From[i] = pos
    pos = pos + 1
    # Find matching }
    nesting = 0
    found = FALSE
    while (!found) {
      ch = char(s, pos) 
      if (ch == "{") {
        nesting = nesting + 1
      } else if (ch == "}") {
        if (nesting > 0) {
          nesting = nesting - 1
        } else {
          found = TRUE
        }
      } else {
        pos = pos + 1
        if (pos > nchar(s)) {
          stop(paste("No matching '}' in line:", s))
        }
      }
    }
    M$To[i] = pos
    M$Value[i] = substr(s, M$From[i] + 1, M$To[i] - 1)
    pos = pos + 1
  }
  M
}

extract_arguments("{}{} = x", 2)
extract_arguments("{abc}{def} = x", 2)

s = lines[959]
macro = macros[1,]
pos = str_locate(s, macro$RegExp)[1,2] + 1
substring(s, pos)

extract_arguments(substring(s, pos), 2)
substr(s, 1, pos-1)



fix_double_backslashes = function() {
  lines <<- str_replace_all(lines, "\\\\$", "\\\\\\\\")
}

#
# Main
#

# Set source and destination names
source_names = list.files(full.names=TRUE, recursive=TRUE,pattern="\\.md$")
dest_names = paste0(".", source_names)
source_names
dest_names

# Create any missing destination folders
create_dest_dirs()

for (i in 1:length(source_names)) {
  i = 3
  lines = read_file(source_names[i])
  macros = extract_macros(lines)
  if (!is.null(macros)) {
    discard_lines = 1:(max(macros$LineNumber)+1)
    lines = lines[-discard_lines]
    

    a_ply(macros, 1, replace_macro)
    lines = aaply(lines, 1, double_single_dollars)

    fix_double_backslashes()
  }
  write_file(dest_names[i], lines)
}
