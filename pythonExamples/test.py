import swiMLTest as swiML


program=swiML.readXML('cont.xml')
print(program)
swiML.writeXML('test.xml',program)