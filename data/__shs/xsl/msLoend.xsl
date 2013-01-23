<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:al_p="http://www.eo.ee/xml/xsl/perlscripts">


  <xsl:output method="xml" omit-xml-declaration="no" indent="yes" encoding="utf-8" />


  <xsl:template match="/">
    <xsl:apply-templates select="al:sr" />
  </xsl:template>


  <!-- sõnastik <sr> -->
  <xsl:template match="al:sr">
    <sr>
      <xsl:apply-templates select="al:A"></xsl:apply-templates>
    </sr>
  </xsl:template>


  <!-- artikkel <A> (XPath - id ÕS järgi) -->
  <xsl:template match="al:A">
    <xsl:variable name="marksonad">
      <xsl:for-each select="siinTulebAsendada">
        <xsl:if test="position() > 1">
          <xsl:text> :: </xsl:text>
        </xsl:if>
        <xsl:for-each select="text()">
          <xsl:value-of select="." />
        </xsl:for-each>
      </xsl:for-each>
    </xsl:variable>
    <md>
      <xsl:value-of select="$marksonad" />
    </md>
  </xsl:template>


</xsl:stylesheet>
