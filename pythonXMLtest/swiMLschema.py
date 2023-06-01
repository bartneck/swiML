from validator import validate

if validate('asserttests.xml','swiML.xsd'):
    print('valid')
else:
    print('invalid')
