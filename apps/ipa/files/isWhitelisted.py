#!/usr/bin/env python3
import sys, re

USAGE = """
./{} <emailFile> <whitelistFile>
Prints True if email author is in whitelist
Prints False otherwise
"""

def endWithError(e:str=""):
 print(USAGE)
 print(e)
 quit()

def nameFromEmail(email:str)->str:
 #assume format: CN=NOSCO.TIMOTHY.MICHAEL.DODID
 exp = r"CN=(\w+)\.(\w+)(?:\.(\w))?"
 names = re.findall(exp,email)
 if len(names) < 1:#occurs twice, take first
  return ""
 #format result assuming whitelist is of format:
 #Nosco, Timothy M
 #Matthew, Boston               <--notice there is no middle, no "NMN" (fix with .replace if exists)
 #goes through .strip and .upper in __main__
 names = list(map(lambda s: s.upper(), names[0]))
 return "{}, {} {}".format(names[0],names[1],names[2]).strip()

def nameInWhiteList(name:str, whiteList:set)->bool:
 #print(whiteList)
 return name in whiteList

if __name__=="__main__":
 if len(sys.argv)<3:
  endWithError()

 emailFile = sys.argv[1]
 whiteListFile = sys.argv[2]

 try:
  with open(emailFile) as f:
   email = f.read()
  with open(whiteListFile) as f:
   whiteList = set(i.strip().upper() for i in f.readlines())
 except Exception as e:
  endWithError(str(e))

 status=nameInWhiteList(nameFromEmail(email),whiteList)
 if not (status):
  exit (255)
 exit(0)
