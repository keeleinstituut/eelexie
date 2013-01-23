<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:al_p="http://www.eo.ee/xml/xsl/perlscripts">


  <xsl:output method="xml" omit-xml-declaration="no" indent="no" encoding="utf-8" />

  <xsl:variable name="dic_desc">xxx</xsl:variable>


  <xsl:template match="/">
    <xsl:copy>
      <xsl:apply-templates select="al:sr" />
    </xsl:copy>
  </xsl:template>


  <xsl:template match="al:sr">
    <xsl:copy>
      <xsl:copy-of select="@*" />
      <xsl:apply-templates select="$art_xpath"></xsl:apply-templates>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="al:A">
    
    <xsl:copy-of select="current()" />

    <xsl:if test="$dic_desc = 'har'">
      <!--<xsl:variable name="ms">
        <xsl:value-of select="al:P/al:ep/al:terg/al:ter[@al:tyyp = 'ee']"></xsl:value-of>
      </xsl:variable>-->
      <xsl:for-each select="al:P">
        <xsl:for-each select="al:ep">

          <xsl:for-each select="al:terg[al:ter/@al:tyyp = 'sy']">
            <xsl:element name="h:A" xmlns:h="http://www.eki.ee/dict/har">
              <xsl:element name="h:P">
                <xsl:element name="h:ep">

                  <xsl:copy-of select="." />

                  <xsl:element name="h:terg">
                    <xsl:for-each select="ancestor::al:ep/al:terg/al:ter[@al:tyyp = 'ee'][1]">
                      <xsl:element name="h:ter">
                        <xsl:attribute name="h:tyyp">viidatav</xsl:attribute>
                        <xsl:attribute name="h:O">
                          <xsl:value-of select="@al:O"/>
                        </xsl:attribute>
                        <xsl:value-of select="."></xsl:value-of>
                      </xsl:element>
                    </xsl:for-each>
                  </xsl:element>

                </xsl:element>
              </xsl:element>
            </xsl:element>
          </xsl:for-each>

        </xsl:for-each>
      </xsl:for-each>

    </xsl:if>
  </xsl:template>


</xsl:stylesheet>
