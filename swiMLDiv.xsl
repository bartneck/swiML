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
                
                <h2>Description:</h2>
                <xsl:for-each select="program">
                    <p><xsl:value-of select="programDescription"/></p>
                    <p>Target Pool Length: <xsl:value-of select="poolLength" /><xsl:text> </xsl:text><xsl:value-of select="poolLengthUnit"/></p>
                    <p>Default Length Unit: <xsl:value-of select="defaultInstructionLengthUnit"/></p>
                    <p>Creation Date: <xsl:value-of select="format-date(creationDate,'[D01] [MNn] [Y0001]')"/></p>
                </xsl:for-each>

                <h2>Authors:</h2>
                <ul>
                    <xsl:apply-templates select="program/author"/>
                </ul>
                
                <h2>Program:</h2>
                <ol>
                    <xsl:apply-templates select="program/instruction"/>
                </ol>
                
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="author">
        <xd:desc>
            <xd:p>The template for each author.</xd:p>
        </xd:desc>
        <li><xsl:value-of select="firstName"/><xsl:text> </xsl:text><xsl:value-of select="lastName"/>, <xsl:value-of select="email"/></li>
    </xsl:template>
    
    <xsl:template match="instruction">
        <xsl:apply-templates select="repetition"/>
        <xsl:apply-templates select="lengthAsDistance"/>
        <xsl:apply-templates select="lengthAsTime" />
    </xsl:template>
    
    <xsl:template match="repetition">
        <li>Repetition Count: <xsl:value-of select="repetitionCount"/></li>
        <ol>
            <xsl:apply-templates select="instruction"/>
        </ol>
    </xsl:template>
    
    <xsl:template match="lengthAsDistance">
        <li>LENGTH: <xsl:value-of select="../lengthAsDistance"/> <xsl:value-of select="../lengthUnit"/>
        </li>
    </xsl:template>
    
    <xsl:template match="lengthAsTime">
        <li>TIME: <xsl:value-of select="minutes-from-duration(../lengthAsTime)"/>:<xsl:value-of select="seconds-from-duration(../lengthAsTime)"/></li>
    </xsl:template>
    

    
</xsl:stylesheet>
