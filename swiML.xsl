<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns:myData="http://www.bartneck.de" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
    <xsl:template match="/">

        <!-- ============================== -->
        <!-- HTML Document -->
        <!-- ============================== -->


        <html>
            <head>
                <meta charset="UTF-8"/>
                <link href="swiML.css" rel="stylesheet" type="text/css"/>
                <link rel="preconnect" href="https://fonts.googleapis.com"/>
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous"/>
                <link
                    href="https://fonts.googleapis.com/css2?family=JetBrains+Mono:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800"
                    rel="stylesheet"/>
                <title>
                    <xsl:for-each select="program">
                        <xsl:value-of select="title"/>
                    </xsl:for-each>
                </title>
            </head>
            <body>
                <div class="intro">
                    <h1>
                        <xsl:for-each select="program">
                            <xsl:value-of select="title"/>
                        </xsl:for-each>
                    </h1>
                    <xsl:apply-templates select="program/author"/>
                    <p class="describtion">
                        <xsl:for-each select="program">
                        <xsl:value-of select="programDescription"/>
                        </xsl:for-each>
                    </p>
                    <xsl:for-each select="program">
                        <ul>
                            <li>
                                <span style="font-weight: 600">Date:</span>
                                <xsl:value-of
                                    select="format-date(creationDate, '[D01] [MNn] [Y0001]')"/>
                            </li>
                            <li>
                                <span style="font-weight: 600">Pool Size:</span>
                                <xsl:value-of select="poolLength"/>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="poolLengthUnit"/>
                            </li>
                            <li>
                                <span style="font-weight: 600">Units:</span>
                                <xsl:value-of select="defaultInstructionLengthUnit"/>
                            </li>
                            <li><span style="font-weight: 600">Length:</span>
                                <xsl:value-of select="sum(instruction/lengthAsDistance)"/>
                            </li>
                        </ul>
                    </xsl:for-each>
                </div>
                <div class="program">
                    <xsl:apply-templates select="program/instruction"/>
                </div>


            </body>
        </html>
    </xsl:template>

    <!-- ============================== -->
    <!-- Main Templates -->
    <!-- ============================== -->


    <!-- Author Template -->
    <xsl:template match="author">
        <p class="authorName">
            <xsl:value-of separator=" " select="firstName, lastName"/>
        </p>
        <p class="authorEmail">
            <xsl:value-of select="email"/>
        </p>
    </xsl:template>

    <!-- Instruction Template -->
    <xsl:template match="instruction">
        <xsl:apply-templates select="repetition"/>
        <xsl:apply-templates select="lengthAsDistance"/>
        <xsl:apply-templates select="lengthAsTime"/>
    </xsl:template>

    <!-- Repetition Template -->
    <xsl:template match="repetition">
        <div class="repetition">
            <div class="repetitionCount"><xsl:value-of select="repetitionCount"/>&#215;</div>
            <div class="reptitionSymbol"></div>
            <div class="repetitionContent">
            <xsl:apply-templates select="instruction"/>
            </div>
        </div>
    </xsl:template>

    <!-- Dirct Swim Template -->
    <xsl:template match="lengthAsDistance">
        <div class="instruction">LENGTH: <xsl:value-of select="../lengthAsDistance"/>
<!--            <xsl:call-template name="toDisplay">
                <xsl:with-param name="fullTerm" select="../stoke/standardStroke"/>
            </xsl:call-template>-->
<!--            <xsl:apply-templates select="../stroke/standardStroke"/>-->
            <xsl:call-template name="showStroke"/>
            <xsl:call-template name="toDisplayKick">
                <xsl:with-param name="orientation" select="../stroke/kicking/orientation"/>
                <xsl:with-param name="legMovement" select="../stroke/kicking/legMovement"/>
            </xsl:call-template>
            <xsl:value-of select="../lengthUnit"/>
        </div>
    </xsl:template>

    <xsl:template match="lengthAsTime">
<!--        <li>TIME: <xsl:value-of select="minutes-from-duration(../lengthAsTime)"/>:<xsl:value-of
                select="seconds-from-duration(../lengthAsTime)"/></li>-->
    </xsl:template>

    <!-- ============================== -->
    <!-- Secondary Templates -->
    <!-- ============================== -->

    <xsl:template name="showStroke">
        <xsl:text>&#160;</xsl:text>
        <xsl:call-template name="toDisplay">
            <xsl:with-param name="fullTerm" select="../stroke/standardStroke"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:variable name="thisDocument" select="document('')"/>

    <xsl:template name="toDisplay">
        <xsl:param name="fullTerm"/>
        <xsl:value-of
            select="$thisDocument/xsl:stylesheet/myData:translation/term[@index = string($fullTerm)]"/>
        <xsl:text> </xsl:text>
    </xsl:template>

    <xsl:template name="toDisplayKick">
        <xsl:param name="orientation"/>
        <xsl:param name="legMovement"/>
        <xsl:if test="$legMovement != ''">
            <xsl:value-of select="
                    concat(
                    ' K ',
                    $thisDocument/xsl:stylesheet/myData:translation/term[@index = string($legMovement)],
                    ' ',
                    $thisDocument/xsl:stylesheet/myData:translation/term[@index = string($orientation)])"
            />
        </xsl:if>
    </xsl:template>

    <myData:translation>
        <term index="butterfly">FL</term>
        <term index="backstroke">BK</term>
        <term index="breaststroke">BR</term>
        <term index="freestyle">FR</term>
        <term index="flutter">Flutter</term>
        <term index="dolpine">Dolpine</term>
        <term index="scissor">Scissor</term>
        <term index="front">Front</term>
        <term index="back">Back</term>
        <term index="left">Left</term>
        <term index="right">Right</term>
        <term index="side">Side</term>

    </myData:translation>


<!--    <!-\- Instruction Template -\->
    <xsl:template match="instruction">
        <xsl:apply-templates select="repetition"/>
        <xsl:apply-templates select="lengthAsDistance"/>
        <xsl:apply-templates select="lengthAsTime"/>
    </xsl:template>
    
    <!-\- Repetition Template -\->
    <xsl:template match="repetition">
        <li>Repetition Count: <xsl:value-of select="repetitionCount"/></li>
        <ol>
            <xsl:apply-templates select="instruction"/>
        </ol>
    </xsl:template>
    
    <!-\- Dirct Swim Template -\->
    <xsl:template match="lengthAsDistance">
        <li>LENGTH: <xsl:value-of select="../lengthAsDistance"/>
            <xsl:apply-templates select="../stroke/standardStroke"/>
            <xsl:call-template name="toDisplayKick">
                <xsl:with-param name="orientation" select="../stroke/kicking/orientation"/>
                <xsl:with-param name="legMovement" select="../stroke/kicking/legMovement"/>
            </xsl:call-template>
            <xsl:value-of select="../lengthUnit"/>
        </li>
    </xsl:template>-->
    
</xsl:stylesheet>
