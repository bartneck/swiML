import swiML

swiML.test_load(
    'greatday',
    'your new mum',
    ['go shawty','wauebgiabguer'],
    'nothing','25','yard'
    )
instruction = [
    {'lengthAsDistance':100},
    {'sinceStart':'PT1M35S'},
    {'staticIntensity':{'percentageHeartRate':80}},
    {'standardStroke':'freestyle'},
    None,
    False,
    [],
    'boopy doop'
]
instruction2 = [
    {'lengthAsDistance':200},
    {'sinceStart':'PT1M55S'},
    {'staticIntensity':{'percentageHeartRate':60}},
    {'standardStroke':'backstroke'},
    None,
    False,
    [],
    'boopy doopy doop'
]
swiML.repetition(instruction,5,'have fun')
swiML.repetition(instruction2,3,'have fun')
