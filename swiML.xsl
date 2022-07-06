<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns:myData="http://www.bartneck.de" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
    <xsl:template match="/">
        <html>
            <head>
                <title>
                    <xsl:for-each select="program">
                        <xsl:value-of select="title"/>
                    </xsl:for-each>
                </title>

            </head>
            <body>
                <h1>
                    <xsl:for-each select="program">
                        <xsl:value-of select="title"/>
                    </xsl:for-each>
                </h1>

                <!--  
                <p><xsl:apply-templates select="program"/></p>
                -->
                <h2>Description:</h2>
                <xsl:for-each select="program">
                    <p>
                        <xsl:value-of select="programDescription"/>
                    </p>
                    <p>Target Pool Length: <xsl:value-of select="poolLength"
                            /><xsl:text> </xsl:text><xsl:value-of select="poolLengthUnit"/></p>
                    <p>Default Length Unit: <xsl:value-of select="defaultInstructionLengthUnit"
                        /></p>
                </xsl:for-each>

                <p>
                    <xsl:apply-templates select="program"/>
                </p>

                <!--  Example on how to call a template
                <xsl:call-template name="dateTransformation" />
                -->
                <h2>Authors:</h2>
                <ul>
                    <xsl:apply-templates select="program/author"/>
                </ul>
                <h2>Program:</h2>
                <ul>
                    <xsl:apply-templates select="program/instruction"/>
                    <xsl:apply-templates select="program/instruction/stroke/standardStroke"/>
                </ul>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="standardStroke">
        <p>Standard Stroke: <xsl:value-of select="standardStroke"/></p>
    </xsl:template>


    <xsl:template match="instruction">
        <li>
            <xsl:value-of select="lengthAsDistance"/>
        </li>

    </xsl:template>


    <xsl:template match="author">
        <xd:desc>
            <xd:p>The template for each author.</xd:p>
        </xd:desc>
        <li><xsl:value-of select="firstName"/><xsl:text> </xsl:text><xsl:value-of select="lastName"
            />, <xsl:value-of select="email"/></li>
    </xsl:template>

    <!-- Just left here as an example of how to call a template -->
    <xsl:template name="dateTransformation"> test <xsl:for-each select="program">
            <xsl:value-of select="creationDate"/>
        </xsl:for-each>
    </xsl:template>


    <xsl:template match="program">Creation Date: <xsl:call-template name="iso8601DateToDisplayDate">
            <xsl:with-param name="iso8601Date" select="creationDate"/>
        </xsl:call-template>
    </xsl:template>


    <xsl:variable name="allMonths" select="document('months.xml')"/>
    <xsl:variable name="thisDocument" select="document('')"/>

    <myData:Months>
        <Month index="1">January</Month>
        <Month index="2">February</Month>
        <Month index="3">March</Month>
        <Month index="4">April</Month>
        <Month index="5">May</Month>
        <Month index="6">June</Month>
        <Month index="7">July</Month>
        <Month index="8">August</Month>
        <Month index="9">September</Month>
        <Month index="10">October</Month>
        <Month index="11">November</Month>
        <Month index="12">December</Month>
    </myData:Months>

    <xsl:template name="iso8601DateToDisplayDate">
        <xsl:param name="iso8601Date"/>
        <xsl:variable name="yearPart" select="substring($iso8601Date, 1, 4)"/>
        <xsl:variable name="monthPart" select="substring($iso8601Date, 6, 2)"/>
        <xsl:variable name="monthName"
            select="$thisDocument/xsl:stylesheet/myData:Months/Month[@index = number($monthPart)]"/>
        <xsl:variable name="datePart" select="substring($iso8601Date, 9, 2)"/>
        <xsl:value-of select="concat($datePart, ' ', $monthName, ' ', $yearPart)"/>
    </xsl:template>
</xsl:stylesheet>
