import swiMLTest as swiML


program=swiML.readXML('pythonExamples/cont.xml')
print(program)
swiML.writeXML('pythonExamples/test.xml',program)