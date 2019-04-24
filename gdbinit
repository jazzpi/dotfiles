# -*- mode: gdb-script; -*-

## PRINT SETTINGS
# Print addresses of args in traces
set print address on
# Always print the symbol in <symbol+1234>
set print max-symbolic-offset 0
# TODO
set print symbol-filename on
# Format like '/a' all the time
set print symbol on
# Pretty print arrays
set print array on
# Show array indices when showing arrays
set print array-indexes on
# Display a maximum of 64 array entries
set print elements 64
# Only print scalar args in traces
set print frame-arguments scalars off
# Pretty-print args in traces
set print raw frame-arguments
# Print arg values & values at entry
set print entry-values default
# "<repeats N times>" where N >= 8
set print repeats 8
# Keep printing arrays after NULLs
set print null-stop off
# Pretty-print structs
set print pretty on
# UTF-8
set print sevenbit-strings off
# Print unions in structs/unions
set print union on
# Demangle C++ names
set print demangle on
# Demangle C++ names in disassemblies too
set print asm-demangle on
# Determine mangling style automatically
set demangle-style auto
# Identify derived object type if possible
set print object on
# Print static members for C++ objects
set print static-members on
# Print static members for Pascal objects
set print pascal_static-members on
# Pretty-print vtables
set print vtbl on
# Don't ask me to continue
set pagination off

source ~/.gdbinit.py
