 #!/usr/bin/python
 # ------------------------------------------------------------------------------
 # Sample Python script
 # ------------------------------------------------------------------------------
import sys
 
for word in sys.argv: #echo the command line arguments
print word 
print "HI FROM PYTHON"
print "Enter user name" 
line = sys.stdin.readline()
 
sys.stdout.write("hello," + line)