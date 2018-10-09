import os
import atexit
import readline
import rlcompleter

readline.parse_and_bind('tab: complete')

histfile = os.path.join(os.environ['RLWRAP_HOME'], 'python_history')
try:
    readline.read_history_file(histfile)
except IOError:
    pass

readline.set_history_length(250)
atexit.register(readline.write_history_file, histfile)

del os, histfile, readline, rlcompleter
