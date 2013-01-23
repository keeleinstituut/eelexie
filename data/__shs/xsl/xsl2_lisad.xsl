<?xml version="1.0"?>
<xsl:stylesheet version="1.0" p:mode="auto" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:pr_sd="http://www.eo.ee/dev/xml/schemas/xmlschemadescriptors" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:p="http://www.eki.ee/dict/sp">
	<xsl:output method="html" omit-xml-declaration="yes" indent="no" encoding="utf-8"/>

  <xsl:template match="p:t">
    <!-- järgnev lisada -->
    <xsl:param name="t_nr"></xsl:param>
    <xsl:param name="rada"></xsl:param>
    <xsl:variable name="posnr_t">
      <xsl:number level="single" format="1"></xsl:number>
    </xsl:variable>
    <!-- ... -->
    <tr>
			<td width="2%">
			</td>
			<td width="33%">
				<xsl:element name="span">
          <!-- ... -->
        </xsl:element>
        <!-- järgnev lisada -->
        <span class="text_info text_info_ text_info__ noedit" 
              title="ploki info" 
              style="text-transform:uppercase;" 
              tabIndex="0">
          <xsl:value-of select="concat(' [', local-name(ancestor::p:tulp|ancestor::p:sm1p|ancestor::p:ls1p|ancestor::p:ls2p|ancestor::p:ls3p|ancestor::p:sm2p|ancestor::p:yh1p|ancestor::p:yh2p|ancestor::p:muup), ' ', $t_nr, $posnr_t, ']')"></xsl:value-of>
        </span>
      </td>
			<td/>
      <td width="32px">
      </td>
      <td width="32px">
      </td>
		</tr>
    <!-- ... -->
    <xsl:if test="not(p:t)">
      <tr>
        <td width="16px">
          <xsl:element name="img">
            <!-- ... -->
          </xsl:element>
        </td>
        <td width="33%">
          <xsl:element name="span">
            <!-- ... järgnev muuta -->
            <xsl:attribute name="tabIndex">0</xsl:attribute>alltaane</xsl:element>
        </td>
        <td></td>
        <td width="32px"></td>
      </tr>
    </xsl:if>
    <xsl:apply-templates select="p:t|p:t/preceding-sibling::comment()[following-sibling::*[1][name()='p:t']]">
      <xsl:with-param name="rada">
        <xsl:value-of select="concat($rada, 'p:t[', $posnr_t, ']/')"></xsl:value-of>
      </xsl:with-param>
      <!-- järgnev lisada -->
      <xsl:with-param name="t_nr">
        <xsl:value-of select="concat($t_nr, $posnr_t, '.')"></xsl:value-of>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>


  <xsl:template match="p:t0">
    <xsl:param name="rada"></xsl:param>
    <xsl:variable name="posnr_t0">
      <xsl:number level="single" format="1"></xsl:number>
    </xsl:variable>
    <!-- ... -->
    <!-- järgnev lisada -->
    <xsl:variable name="t0_nr">
      <xsl:number level="single" format="A"></xsl:number>
    </xsl:variable>
    <tr>
      <td width="2%">
      </td>
      <td width="33%">
        <xsl:element name="span">
          <!-- ... -->
        </xsl:element>
        <!-- järgnev lisada -->
        <span class="text_info text_info_ text_info__ noedit" 
              title="ploki info" 
              style="text-transform:uppercase;" 
              tabIndex="0">
          <xsl:value-of select="concat(' [', local-name(ancestor::p:tulp|ancestor::p:sm1p|ancestor::p:ls1p|ancestor::p:ls2p|ancestor::p:ls3p|ancestor::p:sm2p|ancestor::p:yh1p|ancestor::p:yh2p|ancestor::p:muup), ' ', $t0_nr, ']')"></xsl:value-of>
        </span>
      </td>
      <td/>
      <td width="32px">
      </td>
      <td width="32px">
      </td>
    </tr>
    <!-- ... -->
    <xsl:apply-templates select="p:t|p:t/preceding-sibling::comment()[following-sibling::*[1][name()='p:t']]">
      <xsl:with-param name="rada">
        <xsl:value-of select="concat($rada, 'p:t0[', $posnr_t0, ']/')"></xsl:value-of>
      </xsl:with-param>
      <!-- järgnev lisada -->
      <xsl:with-param name="t_nr">
        <xsl:value-of select="concat($t0_nr, '.')"></xsl:value-of>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  
</xsl:stylesheet>
