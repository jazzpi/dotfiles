## PRINT SETTINGS
set print address on               # Print addresses of args in traces
set print max-symbolic-offset 0    # Always print the symbol in <symbol+1234>
set print symbol-filename on       # TODO
set print symbol on                # Format like '/a' all the time
set print array on                 # Pretty print arrays
set print array-indexes on         # Show array indices when showing arrays
set print elements 64              # Display a maximum of 64 array entries
set print frame-arguments scalars  # Only print scalar args in traces
set print raw frame-arguments off  # Pretty-print args in traces
set print entry-values default     # Print arg values & values at entry
set print repeats 8                # "<repeats N times>" where N >= 8
set print null-stop off            # Keep printing arrays after NULLs
set print pretty on                # Pretty-print structs
set print sevenbit-strings off     # UTF-8
set print union on                 # Print unions in structs/unions
set print demangle on              # Demangle C++ names
set print asm-demangle on          # Demangle C++ names in disassemblies too
set demangle-style auto            # Determine mangling style automatically
set print object on                # Identify derived object type if possible
set print static-members on        # Print static members for C++ objects
set print pascal_static-members on # Print static members for Pascal objects
set print vtbl on                  # Pretty-print vtables
