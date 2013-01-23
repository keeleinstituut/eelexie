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
    <xsl:element name="A">
      <xsl:attribute name="nr">
        <xsl:value-of select="o:P/o:tmnr"></xsl:value-of>
      </xsl:attribute>
      <S>
        <xsl:for-each select="o:S/o:trmg">
          <xsl:element name="trm">
            <xsl:attribute name="nr">
              <xsl:value-of select="@o:nr"></xsl:value-of>
            </xsl:attribute>
            <xsl:for-each select="o:xg/o:x">
              <xsl:element name="x">
                <xsl:value-of select="."></xsl:value-of>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:for-each>
      </S>
    </xsl:element>
  </xsl:template>
  <!-- A -->


</xsl:stylesheet>
