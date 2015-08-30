import sys
from IPython.lib import passwd

print(sys.argv)

# Create hash of password
passwdhash = passwd(sys.argv[1])
c  = open("passwdhash.txt", "w")
c.write(passwdhash)
c.close()