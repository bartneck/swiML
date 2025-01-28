Documentation for steps in swiMLFlat.xsl 

Transforming xml documents defined by swiML.xsd into xml documents with no nesting of elements and only basic instructions

This document outlines how each section of the resulting XML document is constructed with reference to individual functions and templates in swiMLFlat.xsl


### Page Setup 

a few variables and settings are set so that the incoming xml document is able to be copied whilst some elements can be changed. 
The program element and all header elements are copied exactly to the new document.
The xsl then matches every node of the program and processes them so the result is a list of basic instructions 


# Instructions
Each instruction is passed through this template which then sorts basic instructions from non-basic and applies the relevant template

## Parameters 
The template has two parameters which are cont and pos each give the template information on where the instruction is in the program for the special cases that require the info. 
### Cont 
Cont gives the template information on whether the instruction is the last one to be listed inside one of its parent instructions. Using binary representation in 0|0 where the ....... FINISH 
### Pos 
Pos gives the relative position of an instruction inside its parent elements initially set to None as an instruction would have no parents. Pos uses the format of triplets of numbers in x,y,z separated by | so -> u,v,w|x,y,z where the right most is its parent second rightmost is grandparent and so on. 
In each triplet the first 2 numbers represent the positions out of the third number that the instruction covers, e.g. 5,6,8 means the instruction covers from 5/8 to 6/8 -> the third quarter of its parent.
In the program this could be the 3rd 50 in a 4x50 


## Non-basic Instructions
The template checks to see if the imediate child of the instruction is a non-basic instruction in which case it will pass on the parameters to the relevant template

## Basic Instruction
When a basic instruction is copied all the elements it has will need to be copied but sometimes some need to be modified or created. 

### Length 
The length element always stays the same 

### Stroke
When a non medley order stroke is swum it is copied over, otherwise the quarter the instruction is in needs to be calculated and the stroke can then be determined by IM order

### Rest 
Rest can be copied but when the instruction is inside a continue, all but the last instruction need to have a 0 rest element created so that the program knows its inside a continue. 

### Other Elements 
All other instruction elements can be copied over