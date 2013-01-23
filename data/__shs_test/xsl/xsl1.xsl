<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:msxsl="urn:schemas-microsoft-com:xslt"
xmlns:al="http://www.eo.ee/xml/xsl/scripts"
xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xsl:output method="html" omit-xml-declaration="yes" indent="no" encoding="utf-8" />

  <!--Chrome ja Safari ei toeta include ja import-->
  <!--<xsl:include href="include/incTemplates.xsl"/>-->

  <msxsl:script language="JScript" implements-prefix="al">
    <![CDATA[

		// script line offset algab reast "msxsl:script" ja alates 1-st,
		// ehk "msxsl:script" eelneva rea #-le liita line number.

    // nii '.' ( self::node() ), 'current()', 'text()' kui ka $muutuja korral tulevad parameetrid 'nodelist' objektina
    // string ('') korral mitte objektina

    function unName(inpStr) {
        var unStr, i;
        unStr = inpStr.replace(/:/, "-");
        for (i = 0; i < inpStr.length; i++) {
            unStr += '_' + inpStr.charCodeAt(i);
        }
        return unStr;
    } // unName
]]>
  </msxsl:script>


  <xsl:variable name="ul_style">margin-left:6mm;padding-left:0mm;</xsl:variable>
  <!--<xsl:variable name="li_style">list-style-type:none;</xsl:variable>-->
  <xsl:variable name="li_style"></xsl:variable>


  <xsl:template match="/">
    <xsl:variable name="srLang">
      <xsl:choose>
        <xsl:when test="*/@xml:lang">
          <xsl:value-of select="*/@xml:lang"></xsl:value-of>
        </xsl:when>
        <xsl:otherwise>et</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <body lang="{$srLang}" style="margin:0;padding:0;">
      <div>
        <xsl:apply-templates select="*/*" />
      </div>
      <br />
      <br />
      <br />
      <br />
      <br />
    </body>
  </xsl:template>
  <!-- / -->


  <xsl:template match="comment()">
    <xsl:param name="rada"></xsl:param>
    <xsl:variable name="posnr_comment">
      <xsl:number level="single" format="1"></xsl:number>
    </xsl:variable>

    <ul style="{$ul_style}">
      <li style="{$li_style}">
        <xsl:element name="span">
          <xsl:attribute name="id">
            <xsl:value-of select="concat($rada, 'comment()[', $posnr_comment, ']')"></xsl:value-of>
          </xsl:attribute>
          <xsl:attribute name="class">
            <!--<xsl:value-of select="concat('ctx1 ctx1_', local-name(..), ' edit')"></xsl:value-of>-->
            <xsl:value-of select="concat('ct ct_', local-name(..), ' edit')"></xsl:value-of>
          </xsl:attribute>
          <xsl:attribute name="tabIndex">0</xsl:attribute>
          <xsl:value-of select="current()"></xsl:value-of>
        </xsl:element>
      </li>
    </ul>

  </xsl:template>
  <!-- comment() -->


  <xsl:template match="*">

    <xsl:param name="rada"></xsl:param>
    <xsl:variable name="posnr">
      <xsl:number level="single" format="1"></xsl:number>
    </xsl:variable>

    <ul style="{$ul_style}">

      <li style="{$li_style}">

        <b>
          <xsl:text>&lt;</xsl:text>
        </b>

        <xsl:element name="span">
          <xsl:attribute name="id">
            <xsl:value-of select="concat($rada, name(), '[', $posnr, ']')"></xsl:value-of>
          </xsl:attribute>
          <xsl:attribute name="class">
            <xsl:value-of select="concat('enx1 enx1_', local-name(), ' noedit')"></xsl:value-of>
          </xsl:attribute>
          <xsl:attribute name="tabIndex">0</xsl:attribute>
          <xsl:value-of select="name()"></xsl:value-of>
        </xsl:element>

        <xsl:for-each select="@*">
          <xsl:sort select="name()" data-type="text" order="ascending" />
          <b>
            <xsl:value-of select="concat(' ', name(), '=')"></xsl:value-of>
            <xsl:text>"</xsl:text>
          </b>
          <xsl:element name="span">
            <xsl:attribute name="id">
              <xsl:value-of select="concat($rada, name(..), '[', $posnr, ']/@', name())"></xsl:value-of>
            </xsl:attribute>
            <!--edit/noedit info on app globaalses muutujas-->
            <xsl:attribute name="class">
              <!--<xsl:value-of select="concat('atx1 atx1_', local-name(), ' edit')"></xsl:value-of>-->
              <xsl:choose>
                <xsl:when test="function-available('al:unName')">
                  <xsl:value-of select="concat('at at_', al:unName(name()), ' edit')"></xsl:value-of>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="concat('at at_', translate(name(), ':', '-'), ' edit')"></xsl:value-of>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="lang">
              <xsl:call-template name="get_lang"></xsl:call-template>
            </xsl:attribute>
            <xsl:if test="current() = ''">
              <xsl:attribute name="style">width:16px;</xsl:attribute>
            </xsl:if>
            <xsl:attribute name="tabIndex">0</xsl:attribute>
            <xsl:value-of select="."></xsl:value-of>
          </xsl:element>
          <b>
            <xsl:text>"</xsl:text>
          </b>

        </xsl:for-each>

        <b>
          <xsl:text>&gt;</xsl:text>
        </b>

        <xsl:choose>
          <xsl:when test="text() and *">
            <ul style="{$ul_style}">
              <li style="{$li_style}">
                <xsl:apply-templates select="*|text()|comment()">
                  <xsl:with-param name="rada">
                    <xsl:value-of select="concat($rada, name(), '[', $posnr, ']/')"></xsl:value-of>
                  </xsl:with-param>
                </xsl:apply-templates>
              </li>
            </ul>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="*|text()|comment()">
              <xsl:with-param name="rada">
                <xsl:value-of select="concat($rada, name(), '[', $posnr, ']/')"></xsl:value-of>
              </xsl:with-param>
            </xsl:apply-templates>
          </xsl:otherwise>
        </xsl:choose>

      </li>

    </ul>

  </xsl:template>
  <!-- * -->


  <xsl:template match="text()">
    <xsl:param name="rada"></xsl:param>
    <xsl:variable name="posnr_text">
      <xsl:number level="single" format="1"></xsl:number>
    </xsl:variable>

    <!-- TEKST -->
    <!--selle tühiku korral näitab õigesti, kas järgnev span algab tühikuga v mitte-->
    <!--<xsl:text>&#xA0;</xsl:text>-->
    <!--<pre style="display:inline">-->
      <xsl:element name="span">
        <xsl:attribute name="id">
          <xsl:value-of select="concat($rada, 'text()[', $posnr_text, ']')"></xsl:value-of>
        </xsl:attribute>
        <!--edit/noedit info on app globaalses muutujas-->
        <xsl:attribute name="class">
          <!--<xsl:value-of select="concat('etx1 etx1_', local-name(..), ' edit')"></xsl:value-of>-->
          <xsl:choose>
            <xsl:when test="function-available('al:unName')">
              <xsl:value-of select="concat('et et_', al:unName(name(..)), ' edit')"></xsl:value-of>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat('et et_', translate(name(), ':', '-'), ' edit')"></xsl:value-of>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="lang">
          <xsl:call-template name="get_lang"></xsl:call-template>
        </xsl:attribute>
        <xsl:if test="current() = ''">
          <xsl:attribute name="style">width:32px;</xsl:attribute>
        </xsl:if>
        <xsl:attribute name="tabIndex">0</xsl:attribute>
        <xsl:value-of select="current()"></xsl:value-of>
      </xsl:element>
    <!--</pre>-->

  </xsl:template>
  <!-- text() -->


  <xsl:template name="get_lang">
    <xsl:variable name="keel">
      <xsl:for-each select="ancestor-or-self::*[@xml:lang][1]">
        <xsl:value-of select="@xml:lang"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$keel != ''">
        <xsl:value-of select="$keel"/>
      </xsl:when>
      <xsl:otherwise>et</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
