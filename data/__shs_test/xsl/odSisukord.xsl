<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:o="http://www.eki.ee/dict/od">


  <xsl:output method="html" omit-xml-declaration="yes" indent="no" encoding="utf-8" />


  <xsl:template match="/">
    <xsl:apply-templates select="*"></xsl:apply-templates>
  </xsl:template>
  <!-- / -->


  <xsl:template match="o:sr">
    <sr>
      <xsl:apply-templates select="o:A"/>
    </sr>
  </xsl:template>
  <!-- sr -->


  <xsl:template match="o:A">
    <A>
      <tmnr>
        <xsl:value-of select="o:P/o:tmnr"></xsl:value-of>
      </tmnr>
      <yten>
        <xsl:value-of select="o:P/o:yten"></xsl:value-of>
      </yten>
      <ytet>
        <xsl:value-of select="o:P/o:ytet"></xsl:value-of>
      </ytet>
      <tmen>
        <xsl:value-of select="o:P/o:tmen"></xsl:value-of>
      </tmen>
      <tmet>
        <xsl:value-of select="o:P/o:tmet"></xsl:value-of>
      </tmet>
    </A>
  </xsl:template>
  <!-- A -->

  
</xsl:stylesheet>
