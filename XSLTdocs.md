Documentation for steps in swiML.xsl 

Transforming xml documents defined by swiML.xsd into html/pdf documents
Numbering refers to sections in the HTML or groups of functions set out in XSLT 

This document outlines how each section of the resulting HTML document is constructed 
with reference to individual functions and templates in swiML.xsl

# Process 

### Sections
Sections [1](#1-length-variables-and-functions) & [7](#7-mydata-functions) refer to functions and variables that are used within the XSLT and can be found at the rop and bottom of swiML.xsl respectively.

Sections [2](#2-header) & [3](#3-body) refer to the header and the body sections of the HTML docuemnt. 

Sections [4](#4-intro), [5](#5-program) & [6](#6-footer) refer to the elements contained within the body of the HTML document

### Pre-calculations
When creating the HTML all the instructions are just set out on the page and it looks very messy, in order to fix this problem and create a more readable program we choose to align different instructions on the same point, e.g. all basic instructions will be aligned vertically on the right of the last digit of its length, whereas continues and repetitions are aligned on their symbols. 

To acheive this mutliple functions and variables are used or created before any other processes start. For each main type of instruction ([instruction](#51-instructions), [repetition](#52-repetitions), [simplify](#53-simplifying-repetitions), [continue](#54-continues)) there is a set of 2 variables and a function which collect and group each instruction, these can then be accessed later by the template defining the html for the instruction so that it knows how wide each div needs to be for it to align properly. 

For an example using the variables and fuctions to define the width of [instructions](#11-instruction-length). 
Firstly [instLengths](#111-instlengths) collects all the basic instructions defined in the program and creates a list giving each instructions location and the string length of its distance elements. This list is stored and can be accessed globally if needed. 

Next [maxInstLengths](#113-maxinstlengths) is defined which groups the instructions according to firstly what section they are in (defined by [sectionNames](#56-segment-names)), this means that only instructions in the same section will align with each other. 
Each section is then subdivided again but this time into groups of instructions that have the same parents, so that any instructions at the top level will only align with other instructions in the same section that are also at the top level, or any instructions with only a repetition as its parent will only align with those that have the same. 
This is done to avoid misalignments as each different type of instruction has different symbols which dont have the same width, so any subsequent children elements won't align properly. 

After grouping all the instructions [maxInstLengths](#113-maxinstlengths) calls the function [instNodes](#112-instnodes) which then groups the instructions even further into groups of 10 characters. This means that if the first instructions distance had a string length of 1, any instructions in the same grouping upto an including ones with a string length of 10 would be grouped together and set to the largest in the group, i.e. if the largest has a string length of 8 then all instructions in this group will be told to have a width of 8 characters so they all align on the same character. 
This works by calling [instNodes](#112-instnodes) for each group of instructions that [maxInstLengths](#113-maxinstlengths) produces. instNodes then takes any instructions that are within 10 characters of the first and returning each location with the max length of this group. instNodes then recursively calls itself with any remaining instructions until the entire group has been processed, as instNodes outputs Items in a list for each instruction that will be stored in the maxInstLenghs variable to be accessed later. 

This process is the same for all other types of instructions, with repetitions using [repLengths](#141-replengths),[maxRepLengths](#143-maxreplengths) and [repNodes](#142-repnodes) and so on. The process of separating instruction groups by every 10 characters isnt used much in normally instructions and you dont use over a 10 digit length, its more used to separate the other instructions. As repetitions and continues align on the symbol, everything to the left of the symbol is used to calculate string length, not just the distance number. 
When including multiple instruction elements at the top level this can create some longer strings (e.g distance, stroke, rest, multiple equipment) so in order to limit any very short strings from being algined 10+ characters off this limit was introduced. This can be disabled for any instruction by using excludeAlign in an instruction or by using programAlign in the intro to disable these features.  

More information on each of the individual functions and variables can be found in [Section 1](#1-length-variables-and-functions). 

### Alignment Examples 
The following are some examples of how the alignment process works

Basic Instructions:
```
<instruction>
    <length>
        <lengthAsDistance>100</lengthAsDistance>
    </length>
    <stroke>
        <standardStroke>freestyle</standardStroke>
    </stroke>
</instruction>
<instruction>
    <length>
        <lengthAsDistance>50</lengthAsDistance>
    </length>
    <stroke>
        <standardStroke>backstroke</standardStroke>
    </stroke>
</instruction>
<instruction>
    <length>
        <lengthAsLaps>2</lengthAsLaps>
    </length>
    <stroke>
        <standardStroke>butterfly</standardStroke>
    </stroke>
</instruction>
```
These instructions are all collected in instLengths which results in an output of 3000 , 2001 , 1002 . 
The first digit represents the string length of the distance, 3,2,1 which can be seen in the length element of each instruction.
The next 3 digits are the location of the instructions, all three are in section 0 so 2nd digit is 0 and all 3 are at the top level so the parent section is a 0 (this can be multiple digits with multiple parents). The last digit is the location in its group, so the first instruction is at position 0 in section 0 with parents=0, the second is at position 1 and the third at position 2 

Then maxInstLengths takes these and groups them by section and parents, but as they are the same they all end up in the same group. Then fed to instNodes which returns an Item for each instruction as: 03,13,23. The output of instNodes simplifys the location to a single variable giving the distance to the first instruction at a given level. So for 03 the instruction at distance 0 to the first instruction should have the distance div's width set to 3 characters, similar for 13 and 23 the instructions at 1 and 2 distance from the first instruction also need to have width 3 characters. 

This results in the diplayed html reading as:
```
100 FR
 50 BK
  2 laps FL
```
So all instructions are aligned on the right of the last digit in its distance 

Another Example using repetitions: 
```
<instruction>
        <repetition>
            <repetitionCount>3</repetitionCount>
            <instruction>
                <length>
                    <lengthAsDistance>100</lengthAsDistance>
                </length>
                <stroke>
                    <standardStroke>freestyle</standardStroke>
                </stroke>
            </instruction>
        </repetition>
    </instruction>
    
    <instruction>
        <repetition>
            <repetitionCount>3</repetitionCount>
            <rest>
                <sinceStart>PT1M0S</sinceStart>
            </rest>
            <instruction>
                <length>
                    <lengthAsDistance>100</lengthAsDistance>
                </length>
                <stroke>
                    <standardStroke>freestyle</standardStroke>
                </stroke>
            </instruction>
        </repetition>
    </instruction>
```

In this case we use the output of repLengths to determine how wide the div before the repetition symbol needs to be which are 3020 and 10021. In this case the string length of the repetitions are 3 and 10 with both in section 0 and both only having themselves as parents, indicated by the 2. The first repetition at position 0 and the second and position 1. 

maxRepLengths uses this and returns 010 and 110 so both repetitions should have a width of 10 characters as 10 is within 10 characters of 3. This is the resulting HTML with | idicating the repetition symbol:
```
       3 × | 100 FR
3 × @_1:00 | 100 FR
```
However if we also included this tag below the rest element in the second repetition
```
<intensity>
    <startIntensity>
        <zone>racePace</zone>
    </startIntensity>
</intensity>
```
this would change the output of repLengths to 3020 and 20021 and since the string lengths are now more than 10 characters apart they no longer align automatically giving the resultant HTML as:
```
3 × | 100 FR
3 × @_1:00 Race Pace | 100 FR
```

### XML to HTML
Sections 2-6 cover the transformation of XML to HTML with the header ([Section 2](#2-header)) of the document being standard, only the title changing between different documents. 

The body ([Section 3](#3-body)) contains the intro ([Section 4](#4-intro)) which matches all non-instruction elements at the beginning of the program, the footer ([Section 6](#6-footer)) is standard over all documents.

Then all instruction elements and all subsequent instruction elements are transformed using templates to match each XML element ([Section 5](#5-program)).

### Functions
Throughout both these processes multiple functions are used to aid in calculation of the length or location of different elements and these are all handled by the set of functions found at the bottom of swiML.xsl, more info can be found in [Section 7](#7-mydata-functions). 


# 1. Length Variables and Functions
A set of variables and functions that pre-determine the number of characters in each element

## 1.1 Instruction Length
Set of variables and functions for determining the character length of every basic instruction contained within the program

### 1.1.1 instLengths
Variable containing information about every basic instruction present in the program

Checks instructions exist by looking for [lengthAsDistance/Laps/Time](#511-length) tags where [excludeAlign](#5-program) is not true as instructions must reference one
If none exist returns a list with a single 0 entry

Then goes and individually checks for each type of length tag, on finding one it adds an entry to output array 
This entry contains:
String length of the length passed through [myData:number](#71-number) , e.g. 2 for 50 in decimal or 4 for 1:20
Section string of the instruction defined by [myData:section()](#76-section)
Parent string of the instruction defined by [myData:parents()](#74-parents)
Location string of the instruction defined by [myData:location()](#75-location)

Given the later 3 parts of the entry it can be determined exactly where in the program a given instruction is 
As well as what each layer of its parents are, which helps when specific cases need child elements to behave differntly

### 1.1.2 instNodes
Function used by maxInstLengths to sort through the entries in instLengths and group them
Input is the current set of nodes, usually the array instLengths

For each node which has an instruction length within 10 characters for the given node the function returns and array item containing:
The location specified in its entry in instLengths and the max length of its group 

This function then recursively calls itself until all instructions have been grouped into groups with 10 character spacings 


### 1.1.3 maxInstLengths
Variable containing the location of every instruction present in the program and what its corresponding length should be set to

Sorts each instruction by what section of the program its in and then by what parents they have
So that only instructions within the same section and that have the same parents will be aligned

Then calls instNodes with the instruction list to populate the array with entries for each instruction

## 1.2 Continue Length
Set of variables and functions for determining the character length of every continue 

### 1.2.1 contLengths
Variable containing information about every continue present in the program

Checks if there are continues that are aligning in the program, then for each continue outputs an item in the array
If no continues present it will return a list with a single 0 entry

Firstly contInstLength is a local variable given by the sumItems function for instruction elements that are direct children of the continue
Each item contains 4 elements:
String length of the continue
-> defined as string length of the displayed number + 3 for as and then the length of other instruction elements given by contInstLength + 1 for each of the extra elements
Section string of the continue defined by [myData:section()](#76-section)
Parent string of the continue defined by [myData:parents()](#74-parents)
Location string of the continue defined by [myData:location()](#75-location)

### 1.2.2 contNodes
Function used by maxContLengths to sort through the entries in contLengths and group them
Input is the current set of nodes, usually the array contLengths

For each node which has a continue string length within 10 characters for the given node the function returns and array item containing:
The location specified in its entry in contLengths and the max length of its group 

This function then recursively calls itself until all continues have been grouped into groups with 10 character spacings 

### 1.2.3 maxContLengths
Variable containing the location of every continue present in the program and what its corresponding length should be set to

Sorts each continue by what section of the program its in and then by what parents they have
So that only continues within the same section and that have the same parents will be aligned

Then calls contNodes with the continue list to populate the array with entries for each continue

## 1.3 Simplifying Repetition Length
Set of variables and functions for determining the character length of every simplifying repetition

### 1.3.1 simpLengths
Variable containing information about every simplifying repetition present in the program

Checks if there are repetitions that are simplify and are aligning in the program, then for each simplify outputs an item in the array
If no simplifying repetitions present it will return a list with a single 0 entry

Firstly simpInstLength is a local variable given by the sumItems function for instruction elements that are direct children of the simplifying repetition
Another variable isLaps is set to check whether the repetition is simplifying laps, for extra space to fit the word laps
Each item contains 4 elements:
String length of the simplify
-> defined as string length of the repetition count and the instruction being repeated + 6 for as and the repetition symbol 
-> + 5 if isLaps is true and then the length of other instruction elements given by simpInstLength + 1 for each of the extra elements
Section string of the simplify defined by [myData:section()](#76-section)
Parent string of the simplify defined by [myData:parents()](#74-parents)
Location string of the simplify defined by [myData:location()](#75-location)

### 1.3.2 simpNodes
Function used by maxSimpLengths to sort through the entries in simpLengths and group them
Input is the current set of nodes, usually the array simpLengths

For each node which has a string length within 10 characters for the given node the function returns and array item containing:
The location specified in its entry in simpLengths and the max length of its group 

This function then recursively calls itself until all simplifies have been grouped into groups with 10 character spacings 

### 1.3.3 maxSimpLengths
Variable containing the location of every simplify repetition present in the program and what its corresponding length should be set to

Sorts each simplify by what section of the program its in and then by what parents they have
So that only simplifies within the same section and that have the same parents will be aligned

Then calls simpNodes with the simplify list to populate the array with entries for each simplify

## 1.4 Repetition Length
Set of variables and functions for determining the character length of every Repetition

### 1.4.1 repLengths
Variable containing information about every repetition present in the program

Checks if there are repetitions that are aligning in the program, then for each repetition outputs an item in the array
If no repetitions present it will return a list with a single 0 entry

Firstly repInstLength is a local variable given by the sumItems function for instruction elements that are direct children of the repetition
Each item contains 4 elements:
String length of the repetition
-> defined as string length of the repetition count + 2 for repetition symbol and then the length of other instruction elements given by repInstLength + 1 for each of the extra elements
Section string of the repetition defined by [myData:section()](#76-section)
Parent string of the repetition defined by [myData:parents()](#74-parents)
Location string of the repetition defined by [myData:location()](#75-location)

### 1.4.2 repNodes
Function used by maxRepLengths to sort through the entries in repLengths and group them
Input is the current set of nodes, usually the array repLengths

For each node which has a repetition string length within 10 characters for the given node the function returns and array item containing:
The location specified in its entry in repLengths and the max length of its group 

This function then recursively calls itself until all repetitions have been grouped into groups with 10 character spacings 

### 1.4.3 maxRepLengths
Variable containing the location of every repetition present in the program and what its corresponding length should be set to

Sorts each repetition by what section of the program its in and then by what parents they have
So that only repetitions within the same section and that have the same parents will be aligned

Then calls repNodes with the repetition list to populate the array with entries for each repetition

## 1.5 Sum of Instruction Elements 
Set of functions that given a non-basic instruction will returnt the total string length of all instruction elements that are direct children of the instruction

### 1.5.1 sumExtras
Summing function that recursively adds together the string lengths of any nodes that its given 

Works by setting product to the string length of the translation of the given element
Then recursively calling sumExtras with one less element and adding it to the running sum 
When no elements left it returns the running total, this should be the total string length they add to the instruction

### 1.5.2 sumItems
Function that contains predefined lengths for the majority of the instruction elements

Works by setting the product to the determined string length that is defined by what type of element it is 
Then recursively calling sumItems with one less element and adding it to the running sum 
When no elements left it returns the running total, this should be the total string length they add to the instruction

If function finds an element that has no predefined string length it calls sumExtras to get the best estimate of how many characters the element will take


# 2. Header
Data in the header of the HTML page

## 2.1 Meta
Meta data and other relavent links
e.g images, colors, fonts
Link to swiML.css

## 2.2 Title
defined by title element in xml
    

# 3. Body
Displayed html


# 4. Intro
Can be hidden through use of hideIntro tag

Contains:

Title of program (title)
-> string length with max set at 60 chars

Author(s) of program (author)
-> defined by author:firstname,lastname,email
-> email defined as [^@]+@[^\.]+\..+

Any extra description provided (programDescription)
-> max length set to 400 chars

The date of the program (creationDate)

The Length of the pool the program should be swum in (poolLength)
-> Passes length through [myData:number](#71-number)

The unit of measurement the pool is measured in (lengthUnit)
-> defined by lengthUnits: meters,yards,kilometers,miles

The total length of all Elements in the program 
-> determined by passing program element to [myData:showLength](#710-showlength) and then through [myData:number](#71-number)

Other xml elements present before instructions but are not displayed in xsl are:
programAlign
numeralSystem
hideIntro
layoutWidth


# 5. Program
All elements use instruction tag 

## 5.1 Instructions
Displaying basic instructions 
All instructions are aligned on the right of the length section 

### 5.1.1 Length
The Length of the instruction

Normally the length defined by the instruction is displayed, on some specific cases it is different:
If an instructions parent is a simplifying Repetition
-> if that repetition has more than one child display the number 1 passed through [myData:number](#71-number)
-> if not display no distance
If the instructions grandparent is a simplifying repetition and its parent is a repetition with only one child display no length
If the instructions grandparent is a continue and its parent is a repetition with only one child display the length multiplied by the parents repetition length
-> repetitions can't be swum in continues so simplify to a single distance 

Displays each length type differently (distance,laps,time)
Stores location in variable 
If instruction is set to align, call maxInstLengths with location to get min width of the instruction string 
Instruction length is always bold 

Distance and Laps pass length through [myData:number](#71-number) whereas Time passes indivual min and sec numbers through and then combines 
Length can either be defined in the instruction or inherited by ancestor, assertion ensures there is always one defined for each instruction

Laps displays word laps after length 

### 5.1.2 Stroke
The stroke to be swum 

For each standard stroke it is passed to toDisplay, to translate to shortened form for displaying 
Kick can either be a standard kick or can be specified by orientation and legMovement, displayed as standard but with a K after 
Drill is defined by a stroke and a specific drill which must be in the term list, displayed with a D after

### 5.1.3 Rest
The amount of rest for the instruction
Rest has 4 predefined displays: minutes as MM and seconds as SS

AfterStop, rest given after finishing the swimming of the instruction
-> ◔MM:SS
SinceStart, rest given from starting an instruction
-> @_MM:SS
SinceLastRest, rest given from the end of the previous rest
-> ←@_MM:SS
InOut, rest determined by when a certain numbered swimming finishes the first swimmer starts 
-> # in 1 out 

### 5.1.4 Intensity
The intensity of a given swimming block 
Defined with a start intensity and a stop intensity
When only a start intensity it is a static intensity, when both start and stop intensity are defined it is a dynamic intensity 
Static intensity only displays one intensity level to be swum constantly 
Dynamic intensity displays two intensities separated by a ... to denote start the block at the first and finishing at the second intensity level 

Intensities have 3 predefined displays: intensity denoted by Int
PercentageEffort, the percentage of effort given by the swimmer, Int is a number from 1 to 100
-> Int%
PercentageHeartRate, the percentage of a swimmers maximum heart rate, Int is a number from 1 to 100
-> ♥Int%
Zone, a specific term given in the term list e.g. easy, hard, max 
-> Int


### 5.1.5 Other
Other displayed elements of an instruction:

Breath
The number of strokes to be taken between breathes 
Displayed as b# where # is the given number 

Underwater
Whether an instruction is to be swum entirely underwater 
Displayed as the symbol ↧

Equipment 
Any extra equipment to be used while swimming
Displayed as the name of the piece of equipment 
There can be multiple equipment tags in which case multiple are displayed 

Description 
Any extra description given by instructionDescription 
Displayed as what is defined 


## 5.2 Repetitions
A repetition tag can be either a normal repetition or a simplifying repetition
Determined by simplify tag which is a child of a repetition tag 
This entry describes a normal repetition when the simplify tag is absent or is false

XSL will not display count and symbol on the specific event:
A repetitions parent is a continue and it only has one child instruction 
Location of the repetition is used to get string length variable 

### 5.2.1 Repetition Count
Div displaying repetition count, x symbol, repeititon description and any child instruction elements 
Attributes:
    If repetition is set to not align or program is non-aligning, set text to align center
    Otherwise call maxRepLengths with the repetitions location and set min-width of repetition count to that width

If repetition has multiple child instructions display count as normal in form of '# x (description)'
Where # is number and the repetitionDescription is included if defined 
If only one child instruction repetition won't display x symbol only the number and a description if defined 
Repetition count is passes through [myData:number](#71-number) for display

A call to displayInst template displays any instruction elements that are direct children of the repetition
In which case all child instructions are inheriting that element so it is displayed earlier 

### 5.2.2 Repetition Symbol
Curved symbol encasing child instructions denoting what is part of the repetition 

Symbol is only displayed when there are more than one child instruction
When not displayed an extra space is added to replace it unless it has a child which has more than one instruction or its parent is a simplfy

### 5.2.3 Repetition Content
Displayed furthest to the right on the program 
Holds all child instructions of the repetition 
Instructions are displayed as normal 


## 5.3 Simplifying Repetitions
This entry describes a simplifying repetition when the simplify tag is true
Location of the repetition is used to get string length variable 

### 5.3.1 Repetition Count
Div displaying repetition count, x symbol, length to be repeated, repeititon description and any child instruction elements 
Attributes:
    If repetition is set to not align or program is non-aligning, set text to align center
    Otherwise call maxSimpLengths with the repetitions location and set min-width of repetition count to that width

Displays repetition count with call to simplifyLength template which returns number of repetitions made
In the same span the x symbol is displayed
The length to repeat is displayed through call to [myData:firstInst()](#79-firstinst) which returns the first whole instruction in the repetition
In a simplifies case it will always be the right distance as an assertion in the XSD makes sure all lengths in a simplify are the same 
If the instruction is in laps, Laps will be dispayed after the distance 

A call to displayInst template displays any instruction elements that are direct children of the repetition
In which case all child instructions are inheriting that element so it is displayed earlier
A space and an as are the last parts of this section 

### 5.3.2 Repetition Symbol
Curved symbol encasing child instructions denoting what is part of the repetition 

Symbol is only displayed when there are more than one child instruction
When not displayed an extra space is added to replace it unless it has a child which has more than one instruction or its parent is a simplfy

### 5.3.3 Repetition Content
Displayed furthest to the right on the program 
Holds all child instructions of the repetition 
Instructions are displayed as normal 


## 5.4 Continues
A continue denotes a block of swimming to be swum continuously without stopping 
But it allows the block to be made up of different instructions

### 5.4.1 continueLength
Div displaying continue length and the word as 
Attributes:
    If continue is set to not align or program is non-aligning, set text to align center
    Otherwise call maxContLengths with the repetitions location and set min-width of continue count to that width

Displays continue length by calling [myData:contLength](#7101-contlength) and passsing it through [myData:number](#71-number)
On the specific occasion that the continues parent is a simplifying repetition it only displays the length as 1 

### 5.4.2 continueSymbol
Straight symbol encasing child instructions denoting what is part of the continue

### 5.4.3 continueContent
Displayed furthest to the right on the program 
Holds all child instructions of the continue
Instructions are displayed as normal 

## 5.5 Pyramids
There is currently no functionality for the conversion of pyramid elements from XML to HTML

## 5.6 Segment Names
Displays given text inside of segmentName div 
If a segment name is the first instruction given it uses firstSegmentName div 
This currently has no difference to segmentName

# 6. Footer  
Contains Svg of swiML logo

# 7. myData Functions
functions used in the xml to xslt process 

## 7.1 Number 
Function for determining which numeral system is in use 

Takes in a numerical value 
Returns the number passed through a numeral systems function 
Checks global root for defined numeralSystem 
Defaults to the original value which should be decimal 

e.g. if numeralSystem == 'roman' passes value through myData:roman() to return roman numeral of inputted value

## 7.2 Product
Function returns the product of an array of decimals 
This functionality was missing in xpath but it was needed 
Recursively calls itself with one less number and returns the product of the first with the result

## 7.3 Breadth
Function returns twice the number of parents an element has 
As each repetition/continue has and instruction and a repetition element it counts twice 
Works by counting number of ancestors a node has

## 7.4 Parents
Function returns string of numbers denoting each of the parents a node has 
String gives: 
continue = 1
repetition = 2
pyramid = 3
segmentName = 4
other = 0
so for an instruction inside a repetition inside a continue its parent string is 12 

## 7.5 Location 
Function returns a string of numbers which determine its location within the program 
Starts with highest parent and adds how many instructions above it. 
Repeats this process with each parent until it gives how many instructions are above itself within its Parent
Each instruction will have a unique location string in a program 

## 7.6 Section
Function returns which segment of a program an element is in 
Determined by the number of segment names above the element 

## 7.7 Depth
Function returns the depth of an element
This is essentially the location of an elements highest ancestor 
e.g. the instruction at the top level 

## 7.8 SimpRep
Function returns the total number of repetitions needed within a simplifying repetition when passed one 
Works by getting total length of repetition from myData:repLength() and dividing by the length of a single instruction inside the simplify given by myData:firstInst()
If repetition defined with lengthAsLaps it divides again by the pool length to give the number of times the laps need to be repeated 

## 7.9 FirstInst
Function returns the length of the first continuously swum instruction within an instruction 
Works by checking the name of the child node and passing it the relavent result 
If a continue, return the length of the continue as this is swum continuously
If a repetition, call firstInst() again but with the child repetition
If an instruction return the given length of the instruction 

## 7.10 ShowLength
Function that returns the total length of the inputted instruction
Works by recursively calling either itself or one of the two helper functions: contLength() and repLength()

Checks what the given node is and either passes it to the according function or returns the length of the given instruction 
If a repetition passes to repLength, if a continue passes to contLength, if a pyramid PASS 
If a basic instruction return the length of that instruction 
By repeating this process for each child of the given instruction it will return its total length 

### 7.10.1 contLength
Function takes a continue element as input and returns its total length
Checks if continueLength is defined, if so return it as the total length of the instruction 
If not defined call showLength() with the continue so it can break up the individual instructions

### 7.10.2 repLength
Function takes a repetition element as input and returns its total length
Checks if the repetition is simplifying or not 
If the repetition is simplifying the function will return:
A call showLength again with the repetition multiplied by a repetition count if it is defined 
If the repetition is not simplifying the function will return:
A call showLength again with the repetition multiplied by a repetition count
