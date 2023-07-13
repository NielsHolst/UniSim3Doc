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
    from = str_locate_all(s, "\\{")[[1]][2,2]
    to   = nchar(s)
    result = substr(s, from, to)
    result
    # str_replace_all(result, "\\\\", "\\\\\\\\")
  }

  command_lines = which(str_detect(lines, ".*\\\\newcommand"))
  if (length(command_lines) == 0) return(NULL)
  commands = lines[command_lines]

  data.frame(
    Line        = commands,
    LineNumber  = command_lines,
    RegExp        = paste0("\\", aaply(commands, 1, extract_name), "(?=($|[^a-zA-Z]))"), # Next character is either empty (end of line) or not a letter
    Cardinality = aaply(commands, 1, extract_cardinality),
    Definition  = aaply(commands, 1, extract_definition)
  )
}

fix_double_backslashes = function() {
  lines <<- str_replace_all(lines, "\\\\$", "\\\\\\\\")
}

extract_arguments = function(s, n) {

  char = function(s, pos) {
    substr(s, pos, pos)
  }

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

process_line = function(s) {
  E = data.frame(str_locate_all(s, "\\\\[a-zA-Z]+"))
  n = nrow(E)
  if (n == 0)  return(s)
  M = data.frame()

  # Add initial text
  if (E$start[1] > 1) {
    from = 1
    to   = E$start[1] - 1
    M = rbind(M, data.frame(From=from, To=to, Type="text", Index=NA, Value=substr(s, from, to)))
  }

  for (i in 1:n) {
    # Add escaped text
    from  = E$start[i]
    to    = E$end[i]
    value = substr(s, from, to)
    macro_ix = which(aaply(macros$RegExp, 1, function(re) str_detect(value, re)))
    m = length(macro_ix)
    type = "error"
    if (m == 0) {
      type = "text"
      macro_ix = NA
    } else if (m == 1) {
      type = "macro"
      macro = macro_ix
    }  
    M = rbind(M, data.frame(From=from, To=to, Type=type, Index=macro_ix, Value=value))

    # Add text after escaped text
    from  = E$end[i] + 1
    to    = if (i<n) E$start[i+1]-1 else nchar(s)
    if (from > to) break
    value = substr(s, from, to)
    
    # Extract macro arguments
    if (!is.na(macro_ix) && macros$Cardinality[macro_ix] > 0) {
      A = extract_arguments(value, macros$Cardinality[macro_ix])
      a = nrow(A)
      # Add initial text
      if (A$From[1] > 1) {
        from = 1
        to   = A$To[1] - 1
        M = rbind(M, data.frame(From=from, To=to, Type="text", Index=NA, Value=substr(value, from, to)))
      }
      for (j in 1:a) {
        # Add argument
        from  = A$From[j]
        to    = A$To[j]
        type  = "arg"
        M = rbind(M, data.frame(From=from, To=to, Type="arg", Index=j, Value=substr(value, from, to)))
      }
      # Add trailing text
      from  = A$To[a] + 1
      to    = nchar(value)
      if (from <= to) {
        M = rbind(M, data.frame(From=from, To=to, Type="text", Index=NA, Value=substr(value, from, to)))
      }
    } else {
    # Or extract text
      from = E$end[i] + 1
      to   = if (i < n) E$start[i+1] - 1 else nchar(s)
      if (from <= to) {
        M = rbind(M, data.frame(From=from, To=to, Type="text", Index=NA, Value=substr(s, from, to)))
      }
    }
    rownames(M) = {}
    M
  }
  M

  # Collate text and macro tokens
  result = {}
  i = 1
  while (i <= nrow(M)) {
    m = M[i,]
    if (m$Type == "text") {
      result = c(result, m$Value)
    } else if (m$Type == "macro") {
      expansion = macros$Definition[m$Index]
      cardinality = macros$Cardinality[m$Index]
      if (cardinality > 0) {
        for (j in 1:cardinality) {
          k = i+j
          # value = substr(M$Value[k], 2, nchar(M$Value[k]) - 1)
          pattern = paste0("#", j)
          expansion = str_replace(expansion, pattern, M$Value[k])
        }
        i = i + cardinality
      }
      result = c(result, expansion)
    } else {
      stop(paste("Unexpected token type:", m$Type))
    }
    i = i + 1
  }
  paste0(result, collapse="")
}


#
# Main
#

# Set source and destination names
source_names = list.files(full.names=TRUE, recursive=TRUE,pattern="\\.md$")
dest_names = paste0(".", source_names)
source_names
dest_names

# i = 3
# lines = read_file(source_names[i])
# macros = extract_macros(lines)
# discard_lines = 1:(max(macros$LineNumber)+1)
# lines = lines[-discard_lines]
# process_line(lines[959])


# Create any missing destination folders
create_dest_dirs()

for (i in 1:length(source_names)) {
  lines = read_file(source_names[i])
  macros = extract_macros(lines)
  if (!is.null(macros)) {
    discard_lines = 1:(max(macros$LineNumber)+1)
    lines = lines[-discard_lines]    
    lines = aaply(lines, 1, process_line)
    lines = aaply(lines, 1, double_single_dollars)

    fix_double_backslashes()
  }
  write_file(dest_names[i], lines)
}
