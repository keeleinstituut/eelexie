<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:al_p="http://www.eo.ee/xml/xsl/perlscripts">


  <xsl:output method="xml" omit-xml-declaration="no" indent="no" encoding="utf-8" />


  <xsl:param name="volFile"></xsl:param>
  <xsl:param name="teisendada"></xsl:param>


  <xsl:template match="/">
    <xsl:copy>
      <xsl:apply-templates select="al:sr" />
    </xsl:copy>
  </xsl:template>


  <!-- sõnastik <sr> -->
  <xsl:template match="al:sr">
    <sr>
      <xsl:for-each select="elm_xpath">
        <l vf="{$volFile}">
          <t>
            <xsl:choose>
              <xsl:when test="$teisendada = '1'">
                <xsl:value-of select="translate(., ':|+=£#,¤-', '')" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="." />
              </xsl:otherwise>
            </xsl:choose>
          </t>
          <gf>
            <xsl:for-each select="../..">
              <xsl:copy>
                <xsl:for-each select="*">
                  <xsl:choose>
                    <xsl:when test="local-name() = 't'">
                      <xsl:apply-templates select="current()"></xsl:apply-templates>
                    </xsl:when>
                    <xsl:when test="local-name() = 'qsg'"></xsl:when>
                    <xsl:otherwise>
                      <xsl:copy-of select="current()"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each>
              </xsl:copy>
            </xsl:for-each>
          </gf>
          <gfo>
            <xsl:copy-of select="../.."/>
          </gfo>
          <to>
            <xsl:value-of select="." />
          </to>
          <xsl:for-each select="ancestor::al:A[1]">
            <xsl:variable name="marksonad">
              <xsl:for-each select=".//al:m">
                <xsl:value-of select="concat('; ', .)" />
                <xsl:if test="@al:i">
                  <xsl:value-of select="concat(' ', @al:i)"/>
                </xsl:if>
              </xsl:for-each>
            </xsl:variable>
            <md>
              <xsl:value-of select="substring($marksonad, 3)" />
            </md>
            <G>
              <xsl:value-of select="al:G[1]"/>
            </G>
          </xsl:for-each>
        </l>
      </xsl:for-each>
    </sr>
  </xsl:template>


  <xsl:template match="al:t">
    <xsl:copy>
      <xsl:for-each select="*">
        <xsl:choose>
          <xsl:when test="local-name() = 't'">
            <xsl:apply-templates select="current()"></xsl:apply-templates>
          </xsl:when>
          <xsl:when test="local-name() = 'qsg'"></xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="current()"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>


</xsl:stylesheet>
