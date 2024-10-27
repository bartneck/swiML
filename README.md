# swiML

![logo swiML](https://bartneck.github.io/swiML/swiMLLogoGradient.png)

A project to formalise swimming training programs using XML. Our repository is available [here](https://github.com/bartneck/swiML).

# Introduction
The goal of this project is to develop a communication standard for swim training programs that can be used to exchange training programs between web services, apps, and fitness trackers. While there are some standards available for loggin your exercises, none focus on what you want to swim.

Each trainer has his/her own taxonomy and nomenclatures for the various exercises. The Swimming Markup Lanuguage (swiML) will provide a standard for naming. The goal is to also allow for customisations to accomodate local preferences. In addition, it features a transformation of turing valid XML files into beautifuly formatted instructions that can be printed or displayed on devices.

Here is a short video that introduces swiML:

[![swiML Introduction Video](https://img.youtube.com/vi/uzR_eI7XN0o/0.jpg)](https://www.youtube.com/watch?v=uzR_eI7XN0o)

# Book
I am currently working on a book that will be published by [CRC Press](https://www.routledge.com/corporate/about-us/crc-press) in 2025. It will not only include an introduction and documentation of swiML, but also rich examples.

# Architecture
swiML consists of an XML based swim training program that can be validated against the swiML Schema (XSD File). A swiML XML file can be generated directly in XML or using the Python library. If the file is valid, then it can be transformed using XSLT to HTML (XSL File).

![System Architecture](https://bartneck.github.io/swiML/documentation/swiML-Architecture.png)

# Usage
Here is an example of a very simple training program:

```
<?xml version="1.0" encoding="UTF-8"?>
<program xmlns="https://github.com/bartneck/swiML"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="https://github.com/bartneck/swiML https://raw.githubusercontent.com/bartneck/swiML/main/version/latest/swiML.xsd">
    <poolLength>25</poolLength>
    <lengthUnit>meters</lengthUnit>
    <instruction>
        <length>
            <lengthAsDistance>100</lengthAsDistance>
        </length>
        <stroke>
            <standardStroke>freestyle</standardStroke>
        </stroke>
    </instruction>
</program>
```

Or if you want to model a repetition you can write:

```
<?xml version="1.0" encoding="UTF-8"?>
<program xmlns="https://github.com/bartneck/swiML"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="https://github.com/bartneck/swiML https://raw.githubusercontent.com/bartneck/swiML/main/swiML.xsd">
    <title>Jasi Masters</title>
    <author>
        <firstName>Christoph</firstName>
        <lastName>Bartneck</lastName>
    </author>
    <programDescription>Our Tuesday evening program in the sun. The target duration was 60 minutes.</programDescription>
    <creationDate>2023-02-07</creationDate>
    <poolLength>25</poolLength>
    <lengthUnit>meters</lengthUnit>
    <instruction>
        <repetition>
            <repetitionCount>4</repetitionCount>
            <instruction>
                <length><lengthAsDistance>100</lengthAsDistance></length>
                <stroke><standardStroke>freestyle</standardStroke></stroke>
            </instruction>
        </repetition>
    </instruction>
</program>
```

## Documentation
A [HTML based documenation](https://bartneck.github.io/swiML/documentation/swiML.html) is available as well as a [PDF version](documentation/swiML.pdf). My [swiML YouTube Playlist](https://www.youtube.com/playlist?list=PLNoiyEjV43RzxH_o4E_7v0Q9yWhG7taKX) contains videos that showcase the use.

## Tools
We recommend an XML authoring tool, such as [Oxygen Author](https://www.oxygenxml.com/xml_author.html) to write, validate and transform swiML documents. Alternatively, there are XML plugins for [Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-xml) and [Eclipse](https://marketplace.eclipse.org/content/eclipse-xml-editors-and-tools). JetBrain's [Rider](https://www.jetbrains.com/rider/) has the complete XML/XSLT workflow build in and is free for non-commercial use.

## Files
You can use the swiML Schema (swiML.xsd) to validate your swiML file. You can then use the XSLT (swiML.xsl) to tranformation the swiML XML to HTML.

To reference the swiML Schema you can point directly to:
```
https://raw.githubusercontent.com/bartneck/swiML/main/version/latest/swiML.xsd
```

## Versions
The version folder contains stable versions of the files while the root folder contains our work in progress. The latest stable version is available in:

```versions/latest```

## Python
We also developed a Python library that you can use to code your swimming program. It is available as a package over at [PyPi](https://pypi.org/project/swiml_python_xml/). You can find some example of how to use Python in our [Python Examples](https://github.com/bartneck/swiML/tree/main/pythonExamples) folder.

# Examples
A first test implementation showing the [training sessions](https://bartneck.github.io/swiML/jasiMasters/) for the [Jasi Masters](https://jasimasters.org.nz) swimming club in Christchurch, New Zealand is available. These programs demonstrate the usage of swiML, including examples of Python programs.
