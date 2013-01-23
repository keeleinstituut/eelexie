<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:al_p="http://www.eo.ee/xml/xsl/perlscripts">

  <!--xmlns:al="see_asendatakse_cgi_poolt"-->


  <xsl:output method="xml" omit-xml-declaration="no" indent="no" encoding="utf-8" />


  <xsl:param name="dic_desc"></xsl:param>
  <xsl:param name="volFile"></xsl:param>


  <xsl:template match="/">
    <xsl:copy>
      <xsl:apply-templates select="al:sr" />
    </xsl:copy>
  </xsl:template>


  <!-- sõnastik <sr> -->
  <xsl:template match="al:sr">
    <sr>
      <xsl:apply-templates select="art_xpath"/>
    </sr>
  </xsl:template>


  <!-- artikkel <A> -->
  <xsl:template match="al:A">
    <A>
      <vf>
        <xsl:value-of select="$volFile"/>
      </vf>
      <xsl:variable name="marksonad">
        <xsl:choose>
          <xsl:when test="$dic_desc = 'sp_'">
            <xsl:for-each select="al:P/al:mg/al:mag/al:m">
              <xsl:value-of select="concat('; ', .)" />
              <xsl:if test="@al:i">
                <xsl:value-of select="concat(' ', @al:i)"/>
              </xsl:if>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="$dic_desc = 'od_'">
            <xsl:for-each select="al:P">
              <xsl:text>; </xsl:text>
              <xsl:value-of select="al:tmnr" />
              <xsl:text>: &amp;ema;</xsl:text>
              <xsl:value-of select="al:tmen"/>
              <!--mõttekriips "en dash"-->
              <xsl:text>&amp;eml; &#x2013; </xsl:text>
              <xsl:value-of select="al:tmet"/>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="$dic_desc = 'har'">
            <xsl:for-each select="al:P/al:ep/al:terg/al:ter">
              <xsl:value-of select="concat('; ', .)" />
              <xsl:if test="@al:i">
                <xsl:value-of select="concat(' ', @al:i)"/>
              </xsl:if>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="$dic_desc = 'geo'">
            <xsl:for-each select="al:P/al:ep/al:terg/al:ter">
              <xsl:value-of select="concat('; ', .)" />
              <xsl:if test="@al:i">
                <xsl:value-of select="concat(' ', @al:i)"/>
              </xsl:if>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="$dic_desc = 'ief'">
            <xsl:for-each select="al:P/al:terg/al:ter">
              <xsl:value-of select="concat('; ', .)" />
              <xsl:if test="@al:i">
                <xsl:value-of select="concat(' ', @al:i)"/>
              </xsl:if>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="$dic_desc = 'ess'">
            <xsl:for-each select="al:m">
              <xsl:value-of select="concat('; ', .)" />
              <xsl:if test="@al:i">
                <xsl:value-of select="concat(' ', @al:i)"/>
              </xsl:if>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:for-each select="al:P/al:mg/al:m">
              <xsl:text>; </xsl:text>
              <xsl:value-of select="text()" />
              <xsl:if test="@al:i">
                <xsl:value-of select="concat(' ', @al:i)"/>
              </xsl:if>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <md>
        <xsl:value-of select="substring($marksonad, 3)" />
      </md>
      <G>
        <xsl:value-of select="al:G"/>
      </G>
      <xsl:for-each select="elm_xpath">
        <l>
          <e>
            <xsl:value-of select="name()" />
          </e>
          <t>
            <xsl:for-each select=".//text()">
              <xsl:value-of select="." />
              <!--<xsl:if test="position() &lt; last()">
                <xsl:text> </xsl:text>
              </xsl:if>-->
            </xsl:for-each>
          </t>
          <r>
            <xsl:apply-templates select="." mode="get-xpath"></xsl:apply-templates>
          </r>
          <gf>
            <xsl:choose>
              <!--P, S, K jne, valitakse P, S, K jne-->
              <xsl:when test="local-name(../..) = 'sr'">
                <xsl:copy-of select="." />
              </xsl:when>
              <!--mg jne, valitakse, P jne-->
              <xsl:when test="local-name(../..) = 'A'">
                <xsl:copy-of select=".." />
              </xsl:when>
              <xsl:when test="local-name() = 'A'">
                <xsl:copy-of select="." />
              </xsl:when>
              <xsl:otherwise>
                <xsl:copy-of select="../.." />
              </xsl:otherwise>
            </xsl:choose>
          </gf>
        </l>
      </xsl:for-each>
    </A>
  </xsl:template>


  <xsl:template match="*" mode="get-xpath">
    <xsl:if test="not(local-name(..) = 'A')">
      <xsl:apply-templates select="parent::*" mode="get-xpath"/>
      <xsl:text>/</xsl:text>
    </xsl:if>

    <xsl:value-of select="name()"/>
    <xsl:text>[</xsl:text>
    <xsl:number level="single" format="1"></xsl:number>
    <xsl:text>]</xsl:text>
  </xsl:template>

  
  <xsl:template match="@*" mode="get-xpath">
    <xsl:apply-templates select="parent::*" mode="get-xpath"/>

    <xsl:text>/@</xsl:text>

    <xsl:choose>
      <xsl:when test="namespace-uri() = ''">
        <xsl:value-of select="name()"/>
        <!--<xsl:text> = <xsl:value-of select="."/></xsl:text>-->
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>*[local-name()='</xsl:text>
        <xsl:value-of select="local-name()"/>
        <xsl:text>' and namespace-uri()='</xsl:text>
        <xsl:value-of select="namespace-uri()"/>
        <xsl:text>']</xsl:text>
        <!--<xsl:text> = <xsl:value-of select="."/></xsl:text>-->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
