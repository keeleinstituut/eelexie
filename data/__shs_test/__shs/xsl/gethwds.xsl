<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


	<xsl:output method="xml" omit-xml-declaration="no" indent="no" encoding="utf-8" />


  <xsl:param name="dic_desc"></xsl:param>


	<xsl:template match="/">
    <xsl:copy>
      <xsl:apply-templates select="al:sr" />
    </xsl:copy>
	</xsl:template>


	<!-- sõnastik <sr> -->
	<xsl:template match="al:sr">
		<sr>
      <xsl:apply-templates select="al:A"/>
    </sr>
	</xsl:template>


	<!-- artikkel <A> -->
	<xsl:template match="al:A">
		<A>
      <xsl:variable name="marksonad">
        <xsl:choose>
          <xsl:when test="$dic_desc = 'sp_'">
            <xsl:for-each select="al:P/al:mg/al:mag/al:m">
              <xsl:value-of select="concat(' :: ', .)" />
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="$dic_desc = 'od_'">
            <xsl:for-each select="al:P">
              <xsl:text> :: </xsl:text>
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
              <xsl:value-of select="concat(' :: ', .)" />
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="$dic_desc = 'geo'">
            <xsl:for-each select="al:P/al:ep/al:terg/al:ter">
              <xsl:value-of select="concat(' :: ', .)" />
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="$dic_desc = 'ief'">
            <xsl:for-each select="al:P/al:terg/al:ter">
              <xsl:value-of select="concat(' :: ', .)" />
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:for-each select="al:P/al:mg/al:m">
              <xsl:text> :: </xsl:text>
              <xsl:for-each select="text()">
                <xsl:value-of select="." />
              </xsl:for-each>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
			<md>
        <xsl:value-of select="substring($marksonad, 5)" />
      </md>
			<G>
        <xsl:value-of select="al:G"/>
      </G>
		</A>
	</xsl:template>


</xsl:stylesheet>
