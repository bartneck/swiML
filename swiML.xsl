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

                <xsl:choose>
                    <xsl:when test="sw:program/sw:hideIntro = 'true'"/>
                    <xsl:otherwise>
                        
                <div class="bottom">
                    <div class="footnote">made with: </div>
                    <div class="logo">
                        <a href="https://github.com/bartneck/swiML">
                            <svg id="Layer_1" xmlns="http://www.w3.org/2000/svg"
                                viewBox="0 0 1219.33 460.35">
                                <defs>
                                    <style>
                                        .cls-1 {
                                            fill: #231f20;
                                        }</style>
                                </defs>
                                <path class="cls-1"
                                    d="M209,360.8c0,58.3-51.7,99.55-104.5,99.55C39.6,460.35,0,419.65,0,362.45c0-14.3,12.1-26.4,26.4-26.4h39.6c18.7,0,26.4,11.55,26.4,25.85,0,6.6,5.5,12.1,12.1,12.1s12.1-5.5,12.1-12.1v-9.35c0-17.6-6.05-25.85-24.75-33.55l-22.55-9.9C41.25,297,0,279.95,0,225.5v-20.35c0-58.3,44.55-101.75,104.5-101.75,66.55,0,104.5,45.65,104.5,97.35,0,14.3-12.1,26.4-26.4,26.4h-39.6c-15.95,0-26.4-7.7-26.4-25.3,0-6.6-5.5-12.1-12.1-12.1s-12.1,5.5-12.1,12.1v7.7c0,17.05,7.7,27.5,24.2,34.65l23.1,9.9c29.15,12.65,69.3,29.15,69.3,83.6v23.1Z"/>
                                <path class="cls-1"
                                    d="M556.59,354.2c0,72.05-51.7,106.15-96.25,106.15-19.25,0-35.75-3.3-49.5-12.65l-7.15-4.4c-3.85-2.75-5.5-4.4-9.9-4.4-3.3,0-5.5,1.1-9.9,4.4l-6.6,4.4c-13.75,9.35-30.8,12.65-49.5,12.65-52.25,0-96.8-40.7-96.8-106.15V133.65c0-14.3,12.1-26.4,26.4-26.4h39.6c14.3,0,26.4,13.75,26.4,26.4v233.75c0,6.6,5.5,12.1,12.1,12.1s12.1-5.5,12.1-12.1V133.65c0-14.3,12.1-26.4,26.4-26.4h39.6c14.3,0,26.4,13.75,26.4,26.4v233.75c0,6.6,5.5,12.1,12.1,12.1s12.1-5.5,12.1-12.1V133.65c0-14.3,12.1-26.4,26.4-26.4h40.15c14.3,0,25.85,12.1,25.85,26.4v220.55Z"/>
                                <path class="cls-1"
                                    d="M672.64,58.85c0,14.3-12.1,26.4-26.4,26.4h-39.6c-14.3,0-26.4-12.1-26.4-26.4V29.15c0-14.3,12.1-26.4,26.4-26.4h39.6c14.3,0,26.4,13.75,26.4,26.4v29.7Zm0,371.25c0,14.3-12.1,26.4-26.4,26.4h-39.6c-14.3,0-26.4-12.1-26.4-26.4V133.65c0-14.3,12.1-26.4,26.4-26.4h39.6c14.3,0,26.4,13.75,26.4,26.4V430.1Z"/>
                                <path class="cls-1"
                                    d="M1033.99,116.05V430.1c0,14.3-12.1,26.4-26.4,26.4h-43.45c-14.3,0-26.4-13.75-26.4-26.4V105.05c0-6.6-5.5-12.1-12.1-12.1s-12.1,5.5-12.1,12.1V430.1c0,14.3-12.1,26.4-26.4,26.4h-43.45c-14.3,0-26.4-13.75-26.4-26.4V105.05c0-6.6-5.5-12.1-12.1-12.1s-12.1,5.5-12.1,12.1V430.1c0,14.3-12.1,26.4-26.4,26.4h-43.45c-14.3,0-26.4-12.1-26.4-26.4V31.35c0-17.05,13.2-31.35,32.45-31.35,6.6,0,14.3,2.75,19.25,4.95l2.75,1.1c6.05,2.2,8.8,3.85,15.95,3.85,6.05,0,14.85-2.75,22-4.95,7.15-2.2,19.25-4.95,32.45-4.95s23.1,2.75,31.9,5.5c7.15,2.2,15.4,4.4,20.35,4.4s13.2-2.2,20.35-4.4c8.8-2.75,21.45-5.5,34.65-5.5,73.7,0,105.05,43.45,105.05,116.05Z"/>
                                <path class="cls-1"
                                    d="M1154.43,347.6c0,7.15,4.95,12.65,12.1,12.65h26.4c14.3,0,26.4,12.1,26.4,26.4v43.45c0,14.3-12.1,26.4-26.4,26.4h-108.35c-14.3,0-26.4-12.1-26.4-26.4V29.15c0-14.3,12.1-26.4,26.4-26.4h43.45c14.3,0,26.4,12.1,26.4,26.4V347.6Z"
                                />
                            </svg>
                        </a>
                    </div>
                </div>
                    </xsl:otherwise>
                </xsl:choose>



                <!--                <p class="footnote">made with:<a href="https://github.com/bartneck/swiML"><img class="swiML-logo-bw" src="swiML-logo-bw.svg"/></a></p>-->
            </body>
        </html>
    </xsl:template>

    <!-- ============================== -->
    <!-- Main Templates -->
    <!-- ============================== -->

    <!-- Author Template -->
    <xsl:template match="sw:author">
        <p class="authorName">
            <xsl:value-of separator=" " select="sw:firstName, sw:lastName"/>
        </p>
        <p class="authorEmail">
            <xsl:value-of select="sw:email"/>
        </p>
    </xsl:template>

    <!-- First Segment Template-->
    <xsl:template match="sw:instruction[1]/sw:segmentName"/>
        
    <!-- Instruction Template -->
    <xsl:template match="sw:instruction">
        <xsl:apply-templates select="sw:segmentName"/>
        <xsl:apply-templates select="sw:repetition"/>
        <xsl:apply-templates select="sw:lengthAsDistance"/>
        <xsl:apply-templates select="sw:lengthAsTime"/>
    </xsl:template>
    
    <!-- First segment template -->
    <xsl:template match="sw:instruction[1]/sw:segmentName">
        <div class="firstSegmentName"><xsl:value-of select="."/></div>
    </xsl:template>
    
    <!-- Segment name template -->
    <xsl:template match="sw:segmentName">
        <div class="segmentName">
            <xsl:value-of select="."/>
        </div>
    </xsl:template>
    
    <!-- Repetition Template -->
    <xsl:template match="sw:repetition">
        <div class="repetition">
            <div class="repetitionCount">
                <xsl:value-of
                    select="concat(sw:repetitionCount, '&#215;', sw:repetitionDescription)"/>
            </div>
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
            <xsl:call-template name="directSwim"/>
        </div>
    </xsl:template>

    <xsl:template match="sw:lengthAsTime">
        <!--        <li>TIME: <xsl:value-of select="minutes-from-duration(../lengthAsTime)"/>:<xsl:value-of
                select="seconds-from-duration(../lengthAsTime)"/></li>-->
        <div class="instruction">
            <span style="font-weight: 900">
                <xsl:value-of separator=":"
                    select="minutes-from-duration(.), format-number(seconds-from-duration(.), '00')"
                />
            </span>
            <xsl:call-template name="directSwim"/>
        </div>
    </xsl:template>

    <xsl:template name="directSwim">
        <xsl:apply-templates select="../sw:stroke/sw:standardStroke"/>
        <xsl:apply-templates select="../sw:stroke/sw:kicking/sw:orientation"/>
        <xsl:apply-templates select="../sw:stroke/sw:kicking/sw:standardKick"/>
        <xsl:apply-templates select="../sw:stroke/sw:drill"/>
        <xsl:apply-templates select="../sw:rest/sw:afterStop"/>
        <xsl:apply-templates select="../sw:rest/sw:sinceStart"/>
        <xsl:apply-templates select="../sw:rest/sw:inOut"/>
        <xsl:call-template name="showIntensity"/>
        <xsl:apply-templates select="../sw:breath"/>
        <xsl:apply-templates select="../sw:underwater"/>
        <xsl:apply-templates select="../sw:equipment"/>
        <xsl:apply-templates select="../sw:instructionDescription"/>
    </xsl:template>
    <!-- ============================== -->
    <!-- Secondary Templates -->
    <!-- ============================== -->

    <!-- Show the programLength if it is declared. Otherwise calcualte length. -->
    <xsl:template name="showLength">
        <xsl:choose>
            <xsl:when test="not(sw:programLength)">
                <xsl:value-of select="
                        sum(
                        for $l in //sw:lengthAsDistance
                        return
                            $l * myData:product($l/ancestor::sw:repetition/sw:repetitionCount)
                        )"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="sw:programLength"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

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

    <!-- Intensity -->
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

    <!-- Rest -->
    <xsl:template match="sw:afterStop">
        <xsl:value-of
            select="concat('&#160;&#9684;', minutes-from-duration(.), ':', format-number(seconds-from-duration(.), '00'))"
        />
    </xsl:template>

    <xsl:template match="sw:sinceStart">
        <xsl:value-of
            select="concat('&#160;@_', minutes-from-duration(.), ':', format-number(seconds-from-duration(.), '00'))"
        />
    </xsl:template>

    <xsl:template match="sw:inOut">
        <xsl:value-of select="concat('&#160;', ., ' in 1 out')"/>
    </xsl:template>

    <!-- Stroke -->
    <xsl:template match="sw:standardStroke">
        <xsl:text>&#160;</xsl:text>
        <xsl:call-template name="toDisplay">
            <xsl:with-param name="fullTerm" select="."/>
        </xsl:call-template>
    </xsl:template>

    <!-- Kick -->
    <xsl:template match="sw:orientation">
        <xsl:text>&#160;K&#160;</xsl:text>
        <xsl:call-template name="toDisplay">
            <xsl:with-param name="fullTerm" select="."/>
        </xsl:call-template>
        <xsl:text>&#160;</xsl:text>
        <xsl:call-template name="toDisplay">
            <xsl:with-param name="fullTerm" select="../sw:legMovement"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="sw:standardKick">
        <xsl:text>&#160;K&#160;</xsl:text>
        <xsl:call-template name="toDisplay">
            <xsl:with-param name="fullTerm" select="."/>
        </xsl:call-template>
    </xsl:template>

    <!-- Drill -->
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

    <myData:translation>
        <term index="butterfly">FL</term>
        <term index="backstroke">BK</term>
        <term index="breaststroke">BR</term>
        <term index="freestyle">FR</term>
        <term index="individualMedley">IM</term>
        <term index="reverseIndividualMedley">IM Reverse</term>
        <term index="individualMedleyOverlap">IM Overlap</term>
        <term index="individualMedleyOrder">IM Order</term>
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
        <term index="singleArm">Single Arm</term>
        <term index="board">Board</term>
        <term index="pads">Pads</term>
        <term index="pullBuoy">Pullbuoy</term>
        <term index="fins">Fins</term>
        <term index="snorkle">Snorkle</term>
        <term index="chute">Chute</term>
        <term index="stretchCord">Stretch Cord</term>
        <term index="breath">b</term>
    </myData:translation>

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
</xsl:stylesheet>
