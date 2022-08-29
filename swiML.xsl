<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns:myData="http://www.bartneck.de" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:sw="https://github.com/bartneck/swiML">

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
                    <xsl:value-of select="sw:program/sw:title"/>
                </title>
            </head>
            <body>
                <xsl:choose>
                    <xsl:when test="sw:program/sw:hideIntro = 'true'"/>
                    <xsl:otherwise>
                        <div class="intro">
                            <h1>
                                <xsl:value-of select="sw:program/sw:title"/>
                            </h1>
                            <xsl:apply-templates select="sw:program/sw:author"/>
                            <p class="describtion">
                                <xsl:value-of select="sw:program/sw:programDescription"/>
                            </p>
                            <ul>
                                <li>
                                    <span style="font-weight: 600">Date:</span>
                                    <xsl:value-of
                                        select="format-date(sw:program/sw:creationDate, '[D01] [MNn] [Y0001]')"
                                    />
                                </li>
                                <li>
                                    <span style="font-weight: 600">Pool Size:</span>
                                    <xsl:value-of select="sw:program/sw:poolLength"/>
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="sw:program/sw:poolLengthUnit"/>
                                </li>
                                <li>
                                    <span style="font-weight: 600">Units:</span>
                                    <xsl:value-of
                                        select="sw:program/sw:defaultInstructionLengthUnit"/>
                                </li>
                                <li>
                                    <span style="font-weight: 600">Length:</span>
                                    <xsl:call-template name="showLength"/>
                                </li>
                            </ul>
                        </div>
                    </xsl:otherwise>
                </xsl:choose>

                <!-- The recursive instructions -->
                <div class="program">
                    <xsl:apply-templates select="sw:program/sw:instruction"/>
                </div>
            </body>
        </html>
    </xsl:template>

    <!-- ============================== -->
    <!-- Main Templates -->
    <!-- ============================== -->

    <!-- Calculation for the length of the program -->
    <!-- Does not work if mixed length units, such as laps, meters, time -->
    <!-- Works fine if all lengths are exclusively meters or laps -->
    <xsl:function name="myData:product" as="xs:decimal">
        <xsl:param name="numbers" as="xs:decimal*"/>
        <xsl:sequence select="
                if (empty($numbers))
                then
                    1
                else
                    $numbers[1] * myData:product($numbers[position() gt 1])"/>
    </xsl:function>

    <!-- Show the programLength if it is declared. Otherwise calcualte length. -->
    <xsl:template name="showLength">
        <xsl:choose>
            <xsl:when test="not(sw:programLength)">
                <total>
                    <xsl:value-of select="
                            sum(
                            for $l in //sw:lengthAsDistance
                            return
                                $l * myData:product($l/ancestor::sw:repetition/sw:repetitionCount)
                            )"/>
                </total>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="sw:programLength"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>



    <!-- Author Template -->
    <xsl:template match="sw:author">
        <p class="authorName">
            <xsl:value-of separator=" " select="sw:firstName, sw:lastName"/>
        </p>
        <p class="authorEmail">
            <xsl:value-of select="sw:email"/>
        </p>
    </xsl:template>

    <!-- Instruction Template -->
    <xsl:template match="sw:instruction">
        <xsl:apply-templates select="sw:repetition"/>
        <xsl:apply-templates select="sw:lengthAsDistance"/>
        <xsl:apply-templates select="sw:lengthAsTime"/>
    </xsl:template>

    <!-- Repetition Template -->
    <xsl:template match="sw:repetition">
        <div class="repetition">
            <div class="repetitionCount"><xsl:value-of select="sw:repetitionCount"/>&#215;</div>
            <div class="reptitionSymbol"/>
            <div class="repetitionContent">
                <xsl:apply-templates select="sw:instruction"/>
            </div>
        </div>
    </xsl:template>

    <!-- Dirct Swim Template -->
    <xsl:template match="sw:lengthAsDistance">
        <div class="instruction">
            <span style="font-weight: 900">
                <xsl:value-of separator=" " select="../sw:lengthAsDistance, ../sw:lengthUnit"/>
            </span>
            <xsl:apply-templates select="../sw:stroke/sw:standardStroke"/>
            <xsl:apply-templates select="../sw:stroke/sw:kicking"/>
            <xsl:apply-templates select="../sw:stroke/sw:drill"/>
            <xsl:apply-templates select="../sw:rest/sw:afterStop"/>
            <xsl:apply-templates select="../sw:rest/sw:sinceStart"/>
            <xsl:apply-templates select="../sw:rest/sw:inOut"/>
            <xsl:call-template name="showIntensity"/>
            <xsl:apply-templates select="../sw:breath"/>
            <xsl:apply-templates select="../sw:underwater"/>
            <xsl:apply-templates select="../sw:equipment"/>
            <xsl:apply-templates select="../sw:instructionDescription"/>

        </div>
    </xsl:template>

    <xsl:template match="sw:lengthAsTime">
        <!--        <li>TIME: <xsl:value-of select="minutes-from-duration(../lengthAsTime)"/>:<xsl:value-of
                select="seconds-from-duration(../lengthAsTime)"/></li>-->
    </xsl:template>

    <!-- ============================== -->
    <!-- Secondary Templates -->
    <!-- ============================== -->

    <xsl:template match="sw:instructionDescription">
        <span style="font-style: italic;">
            <xsl:value-of select="concat('&#160;', ../sw:instructionDescription)"/>
        </span>
    </xsl:template>

    <xsl:template match="sw:equipment">
        <xsl:text>&#160;</xsl:text>
        <xsl:call-template name="toDisplay">
            <xsl:with-param name="fullTerm" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="sw:breath">
        <xsl:text>&#160;</xsl:text>
        <xsl:call-template name="toDisplay">
            <xsl:with-param name="fullTerm" select="'breath'"/>
        </xsl:call-template>
        <xsl:value-of select="../sw:breath"/>
    </xsl:template>

    <xsl:template match="sw:underwater">
        <xsl:text>&#160;&#8615;</xsl:text>
    </xsl:template>

    <xsl:template name="showIntensity">
        <!-- static intensity profile -->
        <xsl:if test="../sw:intensity/sw:staticIntensity/sw:precentageEffort">
            <xsl:value-of
                select="concat('&#160;', ../sw:intensity/sw:staticIntensity/sw:precentageEffort, '%')"
            />
        </xsl:if>
        <xsl:if test="../sw:intensity/sw:staticIntensity/sw:precentageHeartRate">
            <xsl:value-of
                select="concat('&#160;&#9829;', ../sw:intensity/sw:staticIntensity/sw:precentageHeartRate, '%')"
            />
        </xsl:if>
        <xsl:if test="../sw:intensity/sw:staticIntensity/sw:zone">
            <xsl:text>&#160;</xsl:text>
            <xsl:call-template name="toDisplay">
                <xsl:with-param name="fullTerm" select="../sw:intensity/sw:staticIntensity/sw:zone"
                />
            </xsl:call-template>
        </xsl:if>
        <!-- dynamic intensity profile -->
        <!-- The dynamic intensity across may only occur within a repetition -->
        <!-- to do: add assertion for across -->
        <xsl:choose>
            <xsl:when test="../sw:intensity/sw:dynamicAcross = 'true'">
                <xsl:if test="../sw:intensity/sw:startIntensity/sw:precentageEffort">
                    <xsl:value-of
                        select="concat('&#160;', ../sw:intensity/sw:startIntensity/sw:precentageEffort, '&#8230;', ../sw:intensity/sw:stopIntensity/sw:precentageEffort, '% Across')"
                    />
                </xsl:if>
                <xsl:if test="../sw:intensity/sw:startIntensity/sw:precentageHeartRate">
                    <xsl:value-of
                        select="concat('&#160;&#9829;', ../sw:intensity/sw:startIntensity/sw:precentageHeartRate, '&#8230;', ../sw:intensity/sw:stopIntensity/sw:precentageHeartRate, '% Across')"
                    />
                </xsl:if>
                <xsl:if test="../sw:intensity/sw:startIntensity/sw:zone">
                    <xsl:text>&#160;</xsl:text>
                    <xsl:call-template name="toDisplay">
                        <xsl:with-param name="fullTerm"
                            select="../sw:intensity/sw:startIntensity/sw:zone"/>
                    </xsl:call-template>
                    <xsl:text>&#8230;</xsl:text>
                    <xsl:call-template name="toDisplay">
                        <xsl:with-param name="fullTerm"
                            select="../sw:intensity/sw:stopIntensity/sw:zone"/>
                    </xsl:call-template>
                    <xsl:text>Across</xsl:text>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="../sw:intensity/sw:startIntensity/sw:precentageEffort">
                    <xsl:value-of
                        select="concat('&#160;', ../sw:intensity/sw:startIntensity/sw:precentageEffort, '&#8230;', ../sw:intensity/sw:stopIntensity/sw:precentageEffort, '% Within')"
                    />
                </xsl:if>
                <xsl:if test="../sw:intensity/sw:startIntensity/sw:precentageHeartRate">
                    <xsl:value-of
                        select="concat('&#160;&#9829;', ../sw:intensity/sw:startIntensity/sw:precentageHeartRate, '&#8230;', ../sw:intensity/sw:stopIntensity/sw:precentageHeartRate, '% Within')"
                    />
                </xsl:if>
                <xsl:if test="../sw:intensity/sw:startIntensity/sw:zone">
                    <xsl:text>&#160;</xsl:text>
                    <xsl:call-template name="toDisplay">
                        <xsl:with-param name="fullTerm"
                            select="../sw:intensity/sw:startIntensity/sw:zone"/>
                    </xsl:call-template>
                    <xsl:text>&#8230;</xsl:text>
                    <xsl:call-template name="toDisplay">
                        <xsl:with-param name="fullTerm"
                            select="../sw:intensity/sw:stopIntensity/sw:zone"/>
                    </xsl:call-template>
                    <xsl:text> Within</xsl:text>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="../sw:intensity/dynamicAcross">
            <xsl:if test="../sw:intensity/sw:startIntensity/sw:precentageEffort">
                <xsl:value-of
                    select="concat('&#160;', ../sw:intensity/sw:startIntensity/sw:precentageEffort, '&#8230;', ../sw:intensity/sw:stopIntensity/sw:precentageEffort, '%')"
                />
            </xsl:if>
            <xsl:if test="../sw:intensity/sw:startIntensity/sw:precentageHeartRate">
                <xsl:value-of
                    select="concat('&#160;&#9829;', ../sw:intensity/sw:startIntensity/sw:precentageHeartRate, '&#8230;', ../sw:intensity/sw:stopIntensity/sw:precentageHeartRate, '%')"
                />
            </xsl:if>
            <xsl:if test="../sw:intensity/sw:startIntensity/sw:zone">
                <xsl:text>&#160;</xsl:text>
                <xsl:call-template name="toDisplay">
                    <xsl:with-param name="fullTerm"
                        select="../sw:intensity/sw:startIntensity/sw:zone"/>
                </xsl:call-template>
                <xsl:call-template name="toDisplay">
                    <xsl:with-param name="fullTerm"
                        select="../sw:intensity/sw:stopIntensity/sw:zone"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template match="sw:afterStop">
        <xsl:value-of
            select="concat('&#160;&#9684;', minutes-from-duration(.), ':', seconds-from-duration(.))"
        />
    </xsl:template>

    <xsl:template match="sw:sinceStart">
        <xsl:value-of
            select="concat('&#160;@_', minutes-from-duration(.), ':', seconds-from-duration(.))"/>
    </xsl:template>

    <xsl:template match="sw:inOut">
        <xsl:value-of select="concat('&#160;', ., ' in 1 out')"/>
    </xsl:template>

    <xsl:template match="sw:standardStroke">
        <xsl:text>&#160;</xsl:text>
        <xsl:call-template name="toDisplay">
            <xsl:with-param name="fullTerm" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="sw:kicking">
        <xsl:text>&#160;</xsl:text>
        <xsl:call-template name="toDisplayKick">
            <xsl:with-param name="orientation" select="sw:orientation"/>
            <xsl:with-param name="legMovement" select="sw:legMovement"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="sw:drill">
        <xsl:text>&#160;D&#160;</xsl:text>
        <xsl:if test="sw:drillStroke">
            <xsl:call-template name="toDisplay">
                <xsl:with-param name="fullTerm" select="sw:drillStroke"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:text>&#160;</xsl:text>
        <xsl:call-template name="toDisplay">
            <xsl:with-param name="fullTerm" select="sw:drillNameType"/>
        </xsl:call-template>
    </xsl:template>



    <!-- ============================== -->
    <!-- Helper -->
    <!-- ============================== -->
    <xsl:variable name="thisDocument" select="document('')"/>

    <xsl:template name="toDisplay">
        <xsl:param name="fullTerm"/>
        <xsl:value-of
            select="$thisDocument/xsl:stylesheet/myData:translation/term[@index = string($fullTerm)]"
        />
    </xsl:template>

    <xsl:template name="toDisplayKick">
        <xsl:param name="orientation"/>
        <xsl:param name="legMovement"/>
        <xsl:if test="$legMovement != ''">
            <xsl:value-of select="
                    concat(
                    'K&#160;',
                    $thisDocument/xsl:stylesheet/myData:translation/term[@index = string($legMovement)],
                    '&#160;',
                    $thisDocument/xsl:stylesheet/myData:translation/term[@index = string($orientation)])"
            />
        </xsl:if>
    </xsl:template>

    <myData:translation>
        <term index="butterfly">FL</term>
        <term index="backstroke">BK</term>
        <term index="breaststroke">BR</term>
        <term index="freestyle">FR</term>
        <term index="individualMedley">IM</term>
        <term index="reverseIndividualMedley">IM Reverse</term>
        <term index="indivdualMedleyOverlap">IM Overlap</term>
        <term index="individualMedleyOrder">IM Order</term>
        <term index="medley">Medley</term>
        <term index="any">Any</term>
        <term index="nr1">Nr 1</term>
        <term index="nr2">Nr 2</term>
        <term index="nr3">Nr 3</term>
        <term index="nr4">Nr 4</term>
        <term index="notButterfly">Not FL</term>
        <term index="notBackstroke">Not BK</term>
        <term index="notBreaststroke">Not BR</term>
        <term index="notFreestyle">Not FR</term>
        <term index="flutter">Flutter</term>
        <term index="dolpine">Dolpine</term>
        <term index="scissor">Scissor</term>
        <term index="front">Front</term>
        <term index="back">Back</term>
        <term index="left">Left</term>
        <term index="right">Right</term>
        <term index="side">Side</term>
        <term index="recovery">Recovery</term>
        <term index="endurance">Endurance</term>
        <term index="tempo">Tempo</term>
        <term index="max">Max</term>
        <term index="6KickDrill">6KD</term>
        <term index="fingerTrails">FT</term>
        <term index="123">123</term>
        <term index="bigDog">Big Dog</term>
        <term index="scull">Scull</term>
        <term index="board">Board</term>
        <term index="pads">Pads</term>
        <term index="pullBuoy">Pullbuoy</term>
        <term index="fins">Fins</term>
        <term index="snorkle">Snorkle</term>
        <term index="chute">Chute</term>
        <term index="stretchCord">Stretch Cord</term>
        <term index="breath">b</term>
    </myData:translation>


</xsl:stylesheet>
