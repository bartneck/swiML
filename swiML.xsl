<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns:myData="http://www.bartneck.de" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:sw="https://github.com/bartneck/swiML">

    <!-- global variables for space calculation -->
    <xsl:variable name="instLengths" as="element()*">
        <xsl:choose>
            <xsl:when test="//sw:length/sw:lengthAsDistance or
                //sw:length/sw:lengthAsLaps or
                //sw:length/sw:lengthAsLaps">
                <xsl:for-each select="//sw:length/sw:lengthAsDistance">
                    <Item>
                        <Length><xsl:value-of select="string-length(.)"/></Length>
                        <Section><xsl:value-of select="myData:section(.)"/></Section>
                        <Parents><xsl:value-of select="myData:parents(.)"/></Parents>
                        <Location><xsl:value-of select="myData:location(.)"/></Location>
                    </Item>
                </xsl:for-each>
                <xsl:if test="//sw:length/sw:lengthAsLaps">
                    <xsl:for-each select="//sw:length/sw:lengthAsLaps">
                        <Item>
                            <Length><xsl:value-of select="string-length(.)"/></Length>
                            <Section><xsl:value-of select="myData:section(.)"/></Section>
                            <Parents><xsl:value-of select="myData:parents(.)"/></Parents>
                            <Location><xsl:value-of select="myData:location(.)"/></Location>
                        </Item>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="//sw:length/sw:lengthAsTime">
                    <xsl:for-each select="//sw:length/sw:lengthAsTime">
                        <Item>
                            <Length><xsl:value-of select="string-length(concat(minutes-from-duration(.), ':', format-number(seconds-from-duration(.), '00')))" /></Length>
                            <Section><xsl:value-of select="myData:section(.)"/></Section>
                            <Parents><xsl:value-of select="myData:parents(.)"/></Parents>
                            <Location><xsl:value-of select="myData:location(.)"/></Location>
                        </Item>
                    </xsl:for-each>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:template name="instNodes">
        <xsl:param name="nodes"/>
        <xsl:param name="element"></xsl:param>
        <xsl:if test="$element">
            <xsl:for-each select="$element[./*[1] > max($element/*[1])-9 ]">
                <Item>
                    <Location><xsl:value-of select="./*[4]"/></Location>
                    <Length><xsl:value-of select="max($element/*[1])"/></Length>
                </Item>
            </xsl:for-each>
            
            <xsl:call-template name="instNodes">
                <xsl:with-param name="nodes" select="$nodes"/>
                <xsl:with-param name="element" select="$element[max($element/*[1]) > ./*[1]+9 ]"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:variable name="maxInstLengths" as="element()*">
        <xsl:for-each-group select="$instLengths" group-by="./*[2]">
            <xsl:sort select='./*[2]' order="ascending" data-type="number" />
            <xsl:for-each-group select="$instLengths" group-by="./*[3][../Section = current-grouping-key()]">
                <xsl:call-template name="instNodes">
                    <xsl:with-param name="nodes" select="."/>
                    <xsl:with-param name="element" select="current-group()"/>
                </xsl:call-template>
            </xsl:for-each-group>          
        </xsl:for-each-group>
    </xsl:variable>
    
    <xsl:variable name="contLengths" as="element()*">
        <xsl:choose>
            <xsl:when test="//sw:continue">
                <xsl:for-each select="//sw:continue[not(./sw:simplify[text()='true'])]">
                    <xsl:variable name="contInstLength">
                        <xsl:call-template name="sumItems">
                            <xsl:with-param name="nodeSet" select="./*[not(name(.) = 'instruction')]"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <Item>
                        <xsl:choose>
                            <xsl:when test="../../../sw:repetition and count(../../sw:instruction) = 1 and count(./sw:instruction) = 1">
                                <Length><xsl:value-of select="string-length(string(myData:showLength(.)))+6+string-length(../../sw:repetitionCount)+$contInstLength+count(./*[not(name(.) = 'instruction' or name(.) = 'length' )])"/> </Length>
                            </xsl:when>
                            <xsl:otherwise>
                                <Length><xsl:value-of select="string-length(string(myData:showLength(.)))+3+$contInstLength+count(./*[not(name(.) = 'instruction' or name(.) = 'length' )])"/> </Length>
                            </xsl:otherwise>
                        </xsl:choose>
                        <Section><xsl:value-of select="myData:section(.)"/></Section>
                        <Parents><xsl:value-of select="myData:parents(.)"/></Parents>
                        <Location><xsl:value-of select="myData:location(.)"/></Location>
                    </Item>
                </xsl:for-each>
            </xsl:when>           
            <xsl:otherwise><Item>0</Item></xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:template name="contNodes">
        <xsl:param name="nodes"/>
        <xsl:param name="element"></xsl:param>
        <xsl:if test="$element">
            <xsl:for-each select="$element[./*[1] >= max($element/*[1])-9]">
                <Item>
                    <Location><xsl:value-of select="./*[4]"/></Location>
                    <Length><xsl:value-of select="max($element/*[1])"/></Length>
                </Item>
            </xsl:for-each>
            <xsl:call-template name="contNodes">
                <xsl:with-param name="nodes" select="$nodes"/>
                <xsl:with-param name="element" select="$element[max($element/*[1]) > ./*[1]+9 ]"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:variable name="maxContLengths" as="element()*">
        <xsl:for-each-group select="$contLengths" group-by="./*[2]">
            <xsl:sort select='./*[2]' order="ascending" data-type="number" />
            <xsl:for-each-group select="$contLengths" group-by="./*[3][../Section = current-grouping-key()]">
                <xsl:call-template name="contNodes">
                    <xsl:with-param name="nodes" select="."/>
                    <xsl:with-param name="element" select="current-group()"/>
                </xsl:call-template>                
            </xsl:for-each-group>           
        </xsl:for-each-group>
    </xsl:variable>
    
    <xsl:variable name="simpLengths" as="element()*">
        <xsl:choose>
            <xsl:when test=" //sw:repetition[./sw:simplify[text()='true']]">
                <xsl:for-each select="//sw:repetition[./sw:simplify[text()='true']]">
                    <xsl:variable name="simpInstLength">
                        <xsl:call-template name="sumItems">
                            <xsl:with-param name="nodeSet" select="./*[not(name(.) = 'instruction' or name(.) = 'simplify')]"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <Item>
                        <Length><xsl:value-of select="string-length(string(myData:simpLength(.)))+6+$simpInstLength+count(./*[not(name(.) = 'instruction' or name(.) = 'simplify' or name(.) = 'length' )])"/></Length>
                        <Section><xsl:value-of select="myData:section(.)"/></Section>
                        <Parents><xsl:value-of select="myData:parents(.)"/></Parents>
                        <Location><xsl:value-of select="myData:location(.)"/></Location>
                    </Item>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <Item>0</Item>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:template name="simpNodes">
        <xsl:param name="nodes"/>
        <xsl:param name="element"></xsl:param>
        <xsl:if test="$element">
            <xsl:for-each select="$element[./*[1] >= max($element/*[1])-9]">
                <Item>
                    <Location><xsl:value-of select="./*[4]"/></Location>
                    <Length><xsl:value-of select="max($element/*[1])"/></Length>
                </Item>
            </xsl:for-each>
            <xsl:call-template name="simpNodes">
                <xsl:with-param name="nodes" select="$nodes"/>
                <xsl:with-param name="element" select="$element[max($element/*[1]) > ./*[1]+9 ]"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:variable name="maxSimpLengths" as="element()*">
        <xsl:for-each-group select="$simpLengths" group-by="./*[2]">
            <xsl:sort select='./*[2]' order="ascending" data-type="number" />
            <xsl:for-each-group select="$simpLengths" group-by="./*[3][../Section = current-grouping-key()]">
                <xsl:call-template name="simpNodes">
                    <xsl:with-param name="nodes" select="."/>
                    <xsl:with-param name="element" select="current-group()"/>
                </xsl:call-template>  
            </xsl:for-each-group>          
        </xsl:for-each-group>
    </xsl:variable>
    
    <xsl:variable name="repLengths" as="element()*">
        <xsl:choose>
            <xsl:when test="//sw:repetition[not(./sw:simplify[text()='true'])]">
                <xsl:for-each select="//sw:repetition[not(./sw:simplify[text()='true'])]">
                    <xsl:variable name="repInstLength">
                        <xsl:call-template name="sumItems">
                            <xsl:with-param name="nodeSet" select="./*[not(name(.) = 'instruction' or name(.) = 'simplify') or name(.) = 'repetitionCount']"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <Item>
                        <xsl:choose>
                            <xsl:when test="../../../sw:repetition and count(../../sw:instruction) = 1 and count(./sw:instruction) = 1">
                                <Length><xsl:value-of select="string-length(string(number(./sw:repetitionCount)))+6+string-length(../../sw:repetitionCount)+$repInstLength+count(./*[not(name(.) = 'instruction' or name(.) = 'simplify' or name(.) = 'repetitionCount' or name(.) = 'length' )])"/></Length>
                            </xsl:when>
                            <xsl:otherwise>
                                <Length><xsl:value-of select="string-length(string(number(./sw:repetitionCount)))+2+$repInstLength+count(./*[not(name(.) = 'instruction' or name(.) = 'simplify' or name(.) = 'repetitionCount' or name(.) = 'length' )])"/></Length>
                            </xsl:otherwise>
                        </xsl:choose>
                        <Section><xsl:value-of select="myData:section(.)"/></Section>
                        <Parents><xsl:value-of select="myData:parents(.)"/></Parents>
                        <Location><xsl:value-of select="myData:location(.)"/></Location>
                    </Item>
                </xsl:for-each>                
            </xsl:when>
            <xsl:otherwise><Item>0</Item></xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:template name="repNodes">
        <xsl:param name="nodes"/>
        <xsl:param name="element"></xsl:param>
        <xsl:if test="$element">
            <xsl:for-each select="$element[./*[1] >= max($element/*[1])-9]">
                <Item>
                    <Location><xsl:value-of select="./*[4]"/></Location>
                    <Length><xsl:value-of select="max($element/*[1])"/></Length>
                </Item>
            </xsl:for-each>
            <xsl:call-template name="repNodes">
                <xsl:with-param name="nodes" select="$nodes"/>
                <xsl:with-param name="element" select="$element[max($element/*[1]) > ./*[1]+9 ]"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:variable name="maxRepLengths" as="element()*">
        <xsl:for-each-group select="$repLengths" group-by="./*[2]">
            <xsl:sort select='./*[2]' order="ascending" data-type="number" />
            <xsl:for-each-group select="$repLengths" group-by="./*[3][../Section = current-grouping-key()]">
                <xsl:call-template name="repNodes">
                    <xsl:with-param name="nodes" select="."/>
                    <xsl:with-param name="element" select="current-group()"/>
                </xsl:call-template>  
            </xsl:for-each-group>
        </xsl:for-each-group>
    </xsl:variable>
    
    <xsl:template name="sumExtras">
        <xsl:param name="nodes"/>
        <xsl:param name="tempSum" select="0" />
        <xsl:choose>
            <xsl:when test="not($nodes)">
                <xsl:value-of select="$tempSum" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="product">
                    <xsl:value-of select="string-length($thisDocument/xsl:stylesheet/myData:translation/term[@index = string($nodes[1])])"/>
                </xsl:variable>
                <xsl:call-template name="sumExtras">
                    <xsl:with-param name="nodes" select="$nodes[position() > 1]" />
                    <xsl:with-param name="tempSum" select="$tempSum + $product" />
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        
        
    </xsl:template>
    
    <xsl:template name="sumItems">
        <xsl:param name="nodeSet" />
        <xsl:param name="tempSum" select="0" />
        
        <xsl:choose>
            <xsl:when test="not($nodeSet)">
                <xsl:value-of select="$tempSum" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="product">
                    <xsl:choose>
                        <xsl:when test="name($nodeSet[1]) = 'rest'">
                            <xsl:choose>
                                <xsl:when test="$nodeSet[1]/sw:sinceStart">
                                    <xsl:value-of select="2+string-length(concat(minutes-from-duration(./sw:sinceStart), ':', format-number(seconds-from-duration(./sw:sinceStart), '00')))"/>
                                </xsl:when>
                                <xsl:when test="$nodeSet[1]/sw:afterStop">
                                    <xsl:value-of select="1+string-length(concat(minutes-from-duration(./sw:afterStop), ':', format-number(seconds-from-duration(./sw:afterStop), '00')))"/>
                                </xsl:when>
                                <xsl:when test="$nodeSet[1]/sw:sinceLastRest">
                                    <xsl:value-of select="3+string-length(concat(minutes-from-duration(./sw:sinceLastRest), ':', format-number(seconds-from-duration(./sw:sinceLastRest), '00')))"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="8+string-length(./sw:inOut)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="name($nodeSet[1]) = 'intensity'">
                            <!-- todo -->
                            <xsl:value-of select="1"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="name($nodeSet[1]) != 'length'">
                                    <xsl:call-template name="sumExtras">
                                        <xsl:with-param name="nodes" select="$nodeSet[1]//text()" />
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise><xsl:value-of select="string-length(translate(normalize-space(string($nodeSet[1])), ' ', ''))"/></xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                    
                </xsl:variable>
                <xsl:call-template name="sumItems">
                    <xsl:with-param name="nodeSet" select="$nodeSet[position() > 1]" />
                    <xsl:with-param name="tempSum" select="$tempSum + $product" />
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="/">

        <!-- ============================== -->
        <!-- HTML Document -->
        <!-- ============================== -->
        

        <html>
            <head>
                <script src="https://kit.fontawesome.com/7414123f18.js" crossorigin="anonymous"></script>
                <meta charset="UTF-8"/>
                <meta property="og:image" content="https://bartneck.github.io/swiML/swiMLLogoGradientFacebook.png"/>
                <meta property="og:image:type" content="image/png"/>
                <meta property="og:image:width" content="1200"/>
                <meta property="og:image:height" content="630"/>
                <link href="https://bartneck.github.io/swiML/swiML.css" rel="stylesheet" type="text/css"/>
                <link rel="preconnect" href="https://fonts.googleapis.com"/>
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous"/>
                <link
                    href="https://fonts.googleapis.com/css2?family=JetBrains+Mono:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800"
                    rel="stylesheet"/>
                <link rel="shortcut icon" href="/swiML/favicon/favicon.ico"/>
                <link rel="icon" sizes="16x16 32x32 64x64" href="/swiML/favicon/favicon.ico"/>
                <link rel="icon" type="image/png" sizes="196x196" href="/swiML/favicon/favicon-192.png"/>
                <link rel="icon" type="image/png" sizes="160x160" href="/swiML/favicon/favicon-160.png"/>
                <link rel="icon" type="image/png" sizes="96x96" href="/swiML/favicon/favicon-96.png"/>
                <link rel="icon" type="image/png" sizes="64x64" href="/swiML/favicon/favicon-64.png"/>
                <link rel="icon" type="image/png" sizes="32x32" href="/swiML/favicon/favicon-32.png"/>
                <link rel="icon" type="image/png" sizes="16x16" href="/swiML/favicon/favicon-16.png"/>
                <link rel="apple-touch-icon" href="/swiML/favicon/favicon-57.png"/>
                <link rel="apple-touch-icon" sizes="114x114" href="/swiML/favicon/favicon-114.png"/>
                <link rel="apple-touch-icon" sizes="72x72" href="/swiML/favicon/favicon-72.png"/>
                <link rel="apple-touch-icon" sizes="144x144" href="/swiML/favicon/favicon-144.png"/>
                <link rel="apple-touch-icon" sizes="60x60" href="/swiML/favicon/favicon-60.png"/>
                <link rel="apple-touch-icon" sizes="120x120" href="/swiML/favicon/favicon-120.png"/>
                <link rel="apple-touch-icon" sizes="76x76" href="/swiML/favicon/favicon-76.png"/>
                <link rel="apple-touch-icon" sizes="152x152" href="/swiML/favicon/favicon-152.png"/>
                <link rel="apple-touch-icon" sizes="180x180" href="/swiML/favicon/favicon-180.png"/>
                <meta name="msapplication-TileColor" content="#FFFFFF"/>
                <meta name="msapplication-TileImage" content="/swiML/favicon/favicon-144.png"/>
                <meta name="msapplication-config" content="/swiML/favicon/browserconfig.xml"/>
                
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
                                </li>
                                <li>
                                    <span style="font-weight: 600">Units:</span>
                                    <xsl:value-of select="sw:program/sw:lengthUnit"/>
                                </li>
                                <li>
                                    <span style="font-weight: 600">Length:</span>
                                    <xsl:value-of select="myData:showLength(sw:program)"/>
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
                                    <svg class='logoSvg' id="Layer_1" xmlns="http://www.w3.org/2000/svg"
                                        viewBox="0 0 1219.33 460.35" >
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

    <!-- Instruction Template -->
    <xsl:template match="sw:instruction">
        <xsl:choose>
            <xsl:when test="sw:segmentName or sw:repetition or sw:continue">
                <xsl:apply-templates select="sw:segmentName"/>
                <xsl:apply-templates select="sw:repetition"/>
                <xsl:apply-templates select="sw:continue"/>
            </xsl:when>
            <xsl:otherwise>
                <div class="instruction">
                    <xsl:call-template name="displayInst"/>
                </div> 
                
            </xsl:otherwise>
        </xsl:choose>
        
        
    </xsl:template>

    <!-- First segment template -->
    <xsl:template match="sw:instruction[1]/sw:segmentName">
        <div class="firstSegmentName">
            <xsl:value-of select="."/>
        </div>
    </xsl:template>

    <!-- Segment name template -->
    <xsl:template match="sw:segmentName">
        <div class="segmentName">
            <xsl:value-of select="."/>
        </div>
    </xsl:template>

    <!-- Repetition Template -->
    <xsl:template match="sw:repetition">
        <xsl:variable name="location">
            <xsl:value-of select="myData:location(.)"/>
        </xsl:variable>
        <div class="repetition">
            <xsl:choose>
                <xsl:when test="./sw:simplify[text() = 'true']">
                    <div class="repetitionCount">
                        <xsl:choose>
                            <xsl:when test="./sw:excludeAlignRepetition[text() = 'true']">
                                <xsl:attribute name="style">
                                    <xsl:text>text-align:center;</xsl:text>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="style">
                                    <xsl:text>min-width:</xsl:text>
                                    <xsl:value-of select="$maxSimpLengths[./*[../Location = $location]]/Length"/>
                                    <xsl:text>ch; text-align:center</xsl:text>
                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                        <div>
                            <xsl:attribute name="style">
                                <xsl:text>margin-left: auto; </xsl:text>
                            </xsl:attribute>
                            <xsl:call-template name="simplifyLength"/>
                            <xsl:text>&#160;&#215;&#160;</xsl:text>
                        </div>
                        <xsl:if test="not(./sw:length)">
                            <span>                
                                <xsl:attribute name="style">
                                    <xsl:text>text-align:center;font-weight:900</xsl:text>
                                </xsl:attribute>
                                <xsl:value-of select="(./descendant::sw:length[1]/*[1])"/>
                                <xsl:if test="(./descendant-or-self::sw:lengthAsLaps)"> Laps</xsl:if>
                            </span>
                        </xsl:if>
                        <xsl:call-template name="displayInst"/>
                        <xsl:text>&#160;as</xsl:text>
                    </div>
                    <xsl:choose>
                        <xsl:when test="count(./sw:instruction) > 1">
                            <div class="repetitionSymbol"><xsl:text>&#160;</xsl:text></div>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:if test="(count(.//sw:instruction) > 1) or not(../../sw:simplify[text()='true']) ">
                                <xsl:text>&#160;</xsl:text>
                            </xsl:if>
                            
                        </xsl:otherwise>
                    </xsl:choose>
                    <div class="repetitionContent">
                        <xsl:apply-templates select="sw:instruction"/>
                    </div>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="not(count(../../../sw:continue) = 1 and count(.//sw:instruction) = 1 and not(../../sw:simplify[text()='true']))">
                        <div class="repetitionCount">
                            <xsl:if test="(count(.//sw:instruction) > 1) or not(../../sw:simplify[text()='true'])">
                                <xsl:choose>
                                    <xsl:when test="./sw:excludeAlignRepetition[text() = 'true']">
                                        <xsl:attribute name="style">
                                            <xsl:text>text-align:center;</xsl:text>
                                        </xsl:attribute>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:attribute name="style">
                                            <xsl:text>min-width:</xsl:text>
                                            <xsl:value-of select="$maxRepLengths[./*[../Location = $location]]/Length"/>
                                            <xsl:text>ch;</xsl:text>
                                        </xsl:attribute>
                                    </xsl:otherwise>
                                </xsl:choose>
                                
                            </xsl:if>
                            
                            <div>
                                <xsl:attribute name="style">margin-left:auto</xsl:attribute>
                                <xsl:choose>
                                    <xsl:when test="(count(.//sw:instruction) > 1) or not(../../sw:simplify[text()='true'])  ">
                                        <xsl:value-of select="concat(sw:repetitionCount,'&#160;','&#215;',sw:repetitionDescription)"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:choose>
                                            <xsl:when test=".//repetitionDescription">
                                                <xsl:value-of select="concat(sw:repetitionCount,'&#160;',sw:repetitionDescription)"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="concat(sw:repetitionCount,sw:repetitionDescription)"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </div>
                            
                            <xsl:call-template name="displayInst"/>
                        </div>
                        <xsl:choose>
                            <xsl:when test="count(./sw:instruction) > 1">
                                <div class="repetitionSymbol"><xsl:text>&#160;</xsl:text></div>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if test="(count(.//sw:instruction) > 1) or not(../../sw:simplify[text()='true']) ">
                                    <xsl:text>&#160;</xsl:text>
                                </xsl:if>
                                
                            </xsl:otherwise>
                        </xsl:choose>
                        
                    </xsl:if>
                    <div class="repetitionContent">
                        <xsl:apply-templates select="sw:instruction"/>
                    </div>
                </xsl:otherwise>
            </xsl:choose>
            
        </div>
    </xsl:template>
    
    <!--Continuation Template -->
    <xsl:template match="sw:continue">
        <xsl:variable name="location">
            <xsl:value-of select="myData:location(.)"/>
        </xsl:variable>
        <div class="continue">
            <div class="continueLength">
                <xsl:choose>
                    <xsl:when test="./sw:excludeAlignContinue[text() = 'true']">
                        <xsl:attribute name="style">
                            <xsl:text>text-align:center;</xsl:text>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="style">
                            <xsl:text>min-width:</xsl:text>
                            <xsl:value-of select="$maxContLengths[./*[../Location = $location]]/Length"/>
                            <xsl:text>ch; text-align:center</xsl:text>
                        </xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>   
                <span>                
                    <xsl:attribute name="style">
                        <xsl:text>margin-left: auto; font-weight:900</xsl:text>
                    </xsl:attribute>
                    <xsl:call-template name="showLength"/>
                </span>
                <xsl:call-template name="displayInst"/>
                <xsl:text>&#160;as</xsl:text>
                    
            
            </div>
            <div class="continueSymbol"></div>
            <div class="continueContent">
                <xsl:apply-templates select="sw:instruction"/>
            </div>
        </div>
        
    </xsl:template>
    
    <xsl:template name="displayInst">
        <xsl:if test="not(./ancestor::sw:repetition/sw:simplify[text()='true'])">
            <xsl:choose>
                <xsl:when test="count(../../../../sw:continue) > 0 and (../../sw:repetition and count(..//sw:instruction) = 1)">
                    <span>                
                        <xsl:attribute name="style">
                            <xsl:text>text-align:right;font-weight:900</xsl:text>
                        </xsl:attribute>
                        <xsl:apply-templates select="(preceding-sibling::sw:length | ancestor-or-self::*/sw:length)[last()] * ../../sw:repetition/sw:repetitionCount"/>
                    </span>
                    
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="(preceding-sibling::sw:length | ancestor-or-self::*/sw:length)[last()]"/>
                    
                </xsl:otherwise>
            </xsl:choose>
            
        </xsl:if>
        <xsl:if test=" count(..//sw:instruction) > 1 and ../../sw:repetition/sw:simplify[text()='true']">
            <span>                
                <xsl:attribute name="style">
                    <xsl:text>text-align:right;font-weight:900</xsl:text>
                </xsl:attribute>
                1
            </span>
        </xsl:if>
        <xsl:apply-templates select="sw:stroke/sw:standardStroke"/>
        <xsl:apply-templates select="sw:stroke/sw:kicking/sw:orientation"/>
        <xsl:apply-templates select="sw:stroke/sw:kicking/sw:standardKick"/>
        <xsl:apply-templates select="sw:stroke/sw:drill"/>
        <xsl:apply-templates select="sw:rest/sw:afterStop"/>
        <xsl:apply-templates select="sw:rest/sw:sinceLastRest"/>
        <xsl:apply-templates select="sw:rest/sw:sinceStart"/>
        <xsl:apply-templates select="sw:rest/sw:inOut"/>
        <xsl:call-template name="showIntensity"/>
        <xsl:apply-templates select="sw:breath"/>
        <xsl:apply-templates select="sw:underwater"/>
        <xsl:apply-templates select="sw:equipment"/>
        <xsl:apply-templates select="sw:instructionDescription"/>
    </xsl:template>
    
    <xsl:template match="sw:length">
        <xsl:apply-templates select="sw:lengthAsDistance"/>
        <xsl:apply-templates select="sw:lengthAsLaps"/>
        <xsl:apply-templates select="sw:lengthAsTime"/>
    </xsl:template>
    
    
    <!-- Length Templates -->
    <xsl:template match="sw:lengthAsDistance">
        <xsl:variable name="location">
            <xsl:value-of select="myData:location(.)"/>
        </xsl:variable>
        <span>
            <xsl:choose>
                <xsl:when test="not(../../../sw:repetition) and not(../../sw:excludeAlign[text() = 'true'])">
                    
                    <xsl:attribute name="style">
                        <xsl:text>min-width:</xsl:text>
                        <xsl:value-of select="($maxInstLengths[./*[../Location = $location]]/Length)[last()]"/>
                        <xsl:text>ch;text-align:right;font-weight:900</xsl:text>
                    </xsl:attribute>
                </xsl:when> 
                <xsl:otherwise>
                    <xsl:attribute name="style">
                        <xsl:text>text-align:right;font-weight:900</xsl:text>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            
            
            <xsl:value-of select="../ancestor-or-self::*[sw:lengthAsDistance]"/>
        </span>
        <xsl:if test="//sw:lengthUnit = 'laps'">
            <xsl:text>&#160;&#60;-&#62;</xsl:text>
        </xsl:if>            
        
    </xsl:template>
    
    <xsl:template match="sw:lengthAsLaps">
        <xsl:variable name="location">
            <xsl:value-of select="myData:location(.)"/>
        </xsl:variable>
        <span>
            <xsl:choose>
                <xsl:when test="not(../../../../sw:repetition) and not(../../sw:excludeAlign[text() = 'true'])">
                    <xsl:attribute name="style">
                        <xsl:text>min-width:</xsl:text>
                        <xsl:value-of select="$maxInstLengths[./*[../Location = $location]]/Length"/>
                        <xsl:text>ch;text-align:right;font-weight:900</xsl:text>
                    </xsl:attribute>
                </xsl:when> 
                <xsl:otherwise>
                    <xsl:attribute name="style">
                        <xsl:text>text-align:right;font-weight:900</xsl:text>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="../ancestor-or-self::*[sw:lengthAsLaps]"/>
        </span>
        <xsl:if test="not(//sw:lengthUnit = 'laps')">
            <xsl:text>&#160;</xsl:text>
            <xsl:call-template name="toDisplay">
                <xsl:with-param name="fullTerm" select="'laps'"/>
            </xsl:call-template>
        </xsl:if>
        
    </xsl:template>
    
    <xsl:template match="sw:lengthAsTime">
        <!-- not setup for inheritance -->
        <xsl:variable name="location">
            <xsl:value-of select="myData:location(.)"/>
        </xsl:variable>
        <span>
            <xsl:choose>
                <xsl:when test="not(../../../../sw:repetition) and not(../../sw:excludeAlign[text() = 'true'])">
                    <xsl:attribute name="style">
                        <xsl:text>min-width:</xsl:text>
                        <xsl:value-of select="$maxInstLengths[./*[../Location = $location]]/Length"/>
                        <xsl:text>ch;text-align:right;font-weight:900</xsl:text>
                    </xsl:attribute>
                </xsl:when> 
                <xsl:otherwise>
                    <xsl:attribute name="style">
                        <xsl:text>text-align:right;font-weight:900</xsl:text>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:value-of separator=":" select="minutes-from-duration(.), format-number(seconds-from-duration(.), '00')"/>
        </span>
        
    </xsl:template>
    
    <!-- ============================== -->
    <!-- Secondary Templates -->
    <!-- ============================== -->

    <!-- Show the programLength if it is declared. Otherwise calcualte length. -->
    <xsl:template name="showLength">
        <xsl:value-of select="myData:showLength(.)"/>
    </xsl:template>
    
    <xsl:template name="simplifyLength">
        <xsl:value-of select="myData:simpLength(.)"
        />
        
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
        <xsl:choose>
            <xsl:when test="not(./sw:intensity/sw:stopIntensity)">
                <xsl:call-template name="staticIntensity"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="./sw:intensity">
                    <xsl:choose>
                        <!-- this is gonna change not sure what too yet -->
                        <xsl:when test="../sw:repetition/sw:intensity or ../sw:continue/sw:intensity">
                            <xsl:call-template name="dynamicIntensity"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="dynamicIntensity"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="staticIntensity">
        <!-- static intensity profile -->
        <xsl:if test="./sw:intensity/sw:startIntensity/sw:percentageEffort">
            
            <xsl:value-of
                select="concat('&#160;', ./sw:intensity/sw:startIntensity/sw:percentageEffort, '%')"
            />
        </xsl:if>
        <xsl:if test="./sw:intensity/sw:startIntensity/sw:percentageHeartRate">
            <xsl:value-of
                select="concat('&#160;&#9829;', ./sw:intensity/sw:startIntensity/sw:percentageHeartRate, '%')"
            />
        </xsl:if>
        <xsl:if test="./sw:intensity/sw:startIntensity/sw:zone">
            <xsl:text>&#160;</xsl:text>
            <xsl:call-template name="toDisplay">
                <xsl:with-param name="fullTerm" select="./sw:intensity/sw:startIntensity/sw:zone"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="dynamicIntensity">
        <xsl:if test="./sw:intensity/sw:startIntensity/sw:percentageEffort">
            <xsl:value-of
                select="concat('&#160;', ./sw:intensity/sw:startIntensity/sw:percentageEffort, '&#8230;', ./sw:intensity/sw:stopIntensity/sw:percentageEffort, '%')"
            />
        </xsl:if>
        <xsl:if test="./sw:intensity/sw:startIntensity/sw:percentageHeartRate">
            <xsl:value-of
                select="concat('&#160;&#9829;', ./sw:intensity/sw:startIntensity/sw:percentageHeartRate, '&#8230;', ./sw:intensity/sw:stopIntensity/sw:percentageHeartRate, '%')"
            />
        </xsl:if>
        <xsl:if test="./sw:intensity/sw:startIntensity/sw:zone">
            <xsl:text>&#160;</xsl:text>
            <xsl:call-template name="toDisplay">
                <xsl:with-param name="fullTerm"
                    select="./sw:intensity/sw:startIntensity/sw:zone"/>
            </xsl:call-template>
            <xsl:text>&#8230;</xsl:text>
            <xsl:call-template name="toDisplay">
                <xsl:with-param name="fullTerm"
                    select="./sw:intensity/sw:stopIntensity/sw:zone"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Rest -->
    <xsl:template match="sw:afterStop">
        <xsl:value-of
            select="concat('&#160;&#9684;', minutes-from-duration(.), ':', format-number(seconds-from-duration(.), '00'))"
        />
<!--        <xsl:text>&#160;</xsl:text>
        <i class="fa-regular fa-clock fa-1x"></i>
        <xsl:value-of
            select="concat(minutes-from-duration(.), ':', format-number(seconds-from-duration(.), '00'))"
        />-->
    </xsl:template>

    <xsl:template match="sw:sinceStart">
        <xsl:value-of
            select="concat('&#160;@_', minutes-from-duration(.), ':', format-number(seconds-from-duration(.), '00'))"
        />
    </xsl:template>
    
    <xsl:template match="sw:sinceLastRest">
        <xsl:value-of
            select="concat('&#160;&#8592;@_', minutes-from-duration(.), ':', format-number(seconds-from-duration(.), '00'))"
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
            <xsl:with-param name="fullTerm" select="sw:drillName"/>
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
        <term index="reverseIndividualMedleyOrder">IM Reverse Order</term>
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
        <term index="vertical">Vertical</term>
        <term index="easy">Easy</term>
        <term index="threshold">Threshold</term>
        <term index="endurance">Endurance</term>
        <term index="strong">Strong</term>
        <term index="racePace">Race Pace</term>
        <term index="max">Max</term>
        <term index="6KickDrill">6KD</term>
        <term index="8KickDrill">8KD</term>
        <term index="10KickDrill">10KD</term>
        <term index="12KickDrill">12KD</term>
        <term index="fingerTrails">FT</term>
        <term index="fingerDrag">FD</term>
        <term index="123">123</term>
        <term index="bigDog">Big Dog</term>
        <term index="scull">Scull</term>
        <term index="singleArm">Single Arm</term>
        <term index="technic">Technic</term>
        <term index="dogPaddle">Dog Paddle</term>
        <term index="tarzan">Tarzan</term>
        <term index="6666">6666</term>
        <term index="board">Board</term>
        <term index="pads">Pads</term>
        <term index="pullBuoy">Pullbuoy</term>
        <term index="fins">Fins</term>
        <term index="snorkle">Snorkle</term>
        <term index="chute">Chute</term>
        <term index="stretchCord">Stretch Cord</term>
        <term index="other">?</term>
        <term index="breath">b</term>
        <term index="laps">laps</term>
        <term index="meters">m</term>
        <term index="yards">yd</term>
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
    
    <xsl:function name="myData:breadth">
        <xsl:param name="node" as="node()"/>
        <xsl:choose>
            <xsl:when test="name($node/../..) = 'instruction'">
                <xsl:value-of select="(count($node/ancestor::*)-1) div 2"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="count($node/ancestor::*) div 2"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>
    
    <xsl:function name="myData:parents">
        <xsl:param name="node" as="node()"/>
        <xsl:value-of select="
            string-join(
            for $parent in $node/ancestor-or-self::sw:instruction return
            if ($parent/sw:continue)
            then 
            (1)
            else
            if ($parent/sw:repetition)
            then
            (2)
            else
            if($parent/sw:pyramid)
            then
            (3)
            else
            if ($parent/sw:segmentName)
            then
            (4)
            else(0),'')
            "/>
    </xsl:function>
    
    <xsl:function name="myData:location">
        <xsl:param name="node" as="node()"/>
        <xsl:value-of select="
            string-join(
            for $parent in $node/ancestor-or-self::sw:instruction return
            myData:depth($parent),'')
            "/>
    </xsl:function>
    
    <xsl:function name="myData:section">
        <xsl:param name="node" as="node()"/>
        <xsl:value-of select="count($node/ancestor-or-self::sw:instruction[last()]/preceding-sibling::sw:instruction/sw:segmentName)"/>
    </xsl:function>
    
    <xsl:function name="myData:depth">
        <xsl:param name="node" as="node()" />
        <xsl:value-of select="count($node/ancestor-or-self::sw:instruction[1]/preceding-sibling::sw:instruction)"/>
    </xsl:function>
    
    
    <xsl:function name="myData:simpLength">
        <xsl:param name="root" as="node()"/>
        
        <xsl:sequence select="(
            if
            ($root/descendant-or-self::sw:lengthAsDistance) 
            then(
            sum(
            for $l in $root//sw:instruction[not(child::sw:continue)][not(child::sw:repetition)]
            return
            $l/(preceding-sibling::sw:length | ancestor-or-self::*/sw:length)[last()]/sw:lengthAsDistance 
            * myData:product($l/ancestor::sw:repetition[ancestor::sw:repetition/sw:simplify[text() = 'true']]/sw:repetitionCount)
            )div($root/descendant-or-self::sw:lengthAsDistance[1])) else (0))
            +
            (if
            ($root/descendant-or-self::sw:lengthAsLaps) then (
            (
            sum(
            for $l in $root//sw:instruction[not(child::sw:continue)][not(child::sw:repetition)]
            return
            $l/(preceding-sibling::sw:length | ancestor-or-self::*/sw:length)[last()]/sw:lengthAsLaps 
            * myData:product($l/ancestor::sw:repetition[ancestor::sw:repetition/sw:simplify[text() = 'true']]/sw:repetitionCount)
            )div($root/descendant-or-self::sw:lengthAsLaps[1]))) 
            else (0))"/>
    </xsl:function>
    
    <xsl:function name="myData:showLength">
        <xsl:param name="root" as="node()"/>

        <xsl:sequence select="sum(
            for $breadth in count($root/ancestor-or-self::*)
            return 
            for $l in $root//sw:instruction[not(child::sw:continue)][not(child::sw:repetition)]
            return
            if($l/(preceding-sibling::sw:length | ancestor-or-self::*/sw:length)[last()]/sw:lengthAsDistance)
            then(
            $l/(preceding-sibling::sw:length | ancestor-or-self::*/sw:length)[last()]/sw:lengthAsDistance 
            * myData:product(
            if
            (count($l/ancestor::sw:repetition[count(./ancestor-or-self::*) >= $breadth][not(./sw:simplify = 'true')]) = 0)
            then
            (1)
            else
            (if 
            (name($root) = 'continue') 
            then 
            (($l/ancestor::sw:repetition[count(./ancestor-or-self::*) >= $breadth][not(./sw:simplify = 'true')]/sw:repetitionCount))
            else
            ($l/ancestor::sw:repetition[not(./sw:simplify = 'true')]/sw:repetitionCount))))
            else(0)
            )
            +
            sum(
            for $breadth in count($root/ancestor-or-self::*)
            return 
            for $l in $root//sw:instruction[not(child::sw:continue)][not(child::sw:repetition)]
            return
            if($l/(preceding-sibling::sw:length | ancestor-or-self::*/sw:length)[last()]/sw:lengthAsLaps)
            then(
            $l/(preceding-sibling::sw:length | ancestor-or-self::*/sw:length)[last()]/sw:lengthAsLaps 
            * myData:product(
            if
            (count($l/ancestor::sw:repetition[count(./ancestor-or-self::*) >= $breadth][not(./sw:simplify = 'true')]) = 0)
            then
            (1)
            else
            if 
            (name($root) = 'continue')  
            then 
            ($l/ancestor::sw:repetition[count($root/ancestor-or-self::*) >= $breadth][not(./sw:simplify = 'true')]/sw:repetitionCount)
            else
            ($l/ancestor::sw:repetition[not(./sw:simplify = 'true')]/sw:repetitionCount)))
            else (0)
            ) * $root/ancestor-or-self::sw:program//sw:poolLength  
            "/>
    </xsl:function>
    
</xsl:stylesheet>
