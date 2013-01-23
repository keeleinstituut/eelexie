<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:al_p="http://www.eo.ee/xml/xsl/perlscripts">


  <xsl:output method="xml" omit-xml-declaration="no" indent="no" encoding="utf-8" />


  <xsl:template match="/">
    <xsl:copy>
      <xsl:apply-templates select="outDOM" />
    </xsl:copy>
  </xsl:template>


  <xsl:template match="outDOM">
    <outDOM>
      <xsl:for-each select="sr/l">
        <xsl:sort select="t" data-type="text" order="ascending" />
        <xsl:copy-of select="self::node()" />
      </xsl:for-each>
    </outDOM>
  </xsl:template>


</xsl:stylesheet>
