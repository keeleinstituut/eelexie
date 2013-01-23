<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


	<xsl:output method="html" omit-xml-declaration="yes" indent="no" encoding="utf-8" />


  <xsl:variable name="dic_desc"></xsl:variable>
  

  <xsl:template match="*">
    <div id="_copyDiv" style="text-align:left;">
      <table bordder="0" width="100%">
        <tr>
          <td align="left">
            <img src="graphics/copy.bmp" id="do_copy" style="visibility:hidden;"></img>
          </td>
          <td align="right">
            <img src="graphics/exit_16_16.ico" id="exit_copy" style="cursor:hand;"></img>
          </td>
        </tr>
      </table>
      <hr/>
      <xsl:apply-templates select=".//text()"></xsl:apply-templates>
    </div>
  </xsl:template>


  <xsl:template match="text()">
    <xsl:if test="position() > 1">, </xsl:if>
    <xsl:element name="span">
      <xsl:attribute name="style">background-color:yellow;</xsl:attribute>
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>
  
  
</xsl:stylesheet>
