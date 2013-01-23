<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" omit-xml-declaration="no" indent="no" encoding="utf-8"/>

  <xsl:param name="pr"/>
  <xsl:param name="uri"/>
  <xsl:param name="dic_desc"/>


  <xsl:template match="/">
    <xsl:copy>
      <xsl:apply-templates select="al:sr"/>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="al:sr">
    <xsl:element name="{$pr}:sr" namespace="{$uri}">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="thisQuery"/>
    </xsl:element>
  </xsl:template>


  <xsl:template match="al:A">
    <xsl:element name="{$pr}:A" namespace="{$uri}">
      <xsl:element name="{$pr}:P" namespace="{$uri}">
        <xsl:for-each select="al:P/al:mg">
          <xsl:element name="{$pr}:mg" namespace="{$uri}">
            <xsl:for-each select="al:m">
              <xsl:element name="{$pr}:m" namespace="{$uri}">
                <xsl:apply-templates select="@*"/>
                <xsl:value-of select="."/>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
      <xsl:element name="{$pr}:I" namespace="{$uri}">
        <xsl:attribute name="{$pr}:src" namespace="{$uri}">
          <xsl:value-of select="$dic_desc"/>
        </xsl:attribute>
        <xsl:for-each select=".">
          <xsl:element name="{$pr}:A" namespace="{$uri}">
            <xsl:apply-templates select="@* | node()"/>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
      <xsl:element name="{$pr}:G" namespace="{$uri}">
        <xsl:value-of select="al:G"/>
      </xsl:element>
      <xsl:element name="{$pr}:K" namespace="{$uri}">
        <xsl:value-of select="al:K"/>
      </xsl:element>
      <xsl:element name="{$pr}:KA" namespace="{$uri}">
        <xsl:value-of select="al:KA"/>
      </xsl:element>
      <xsl:if test="al:KL">
        <xsl:element name="{$pr}:KL" namespace="{$uri}">
          <xsl:value-of select="al:TL"/>
        </xsl:element>
      </xsl:if>
      <xsl:if test="al:T">
        <xsl:element name="{$pr}:T" namespace="{$uri}">
          <xsl:value-of select="al:T"/>
        </xsl:element>
      </xsl:if>
      <xsl:if test="al:TA">
        <xsl:element name="{$pr}:TA" namespace="{$uri}">
          <xsl:value-of select="al:TA"/>
        </xsl:element>
      </xsl:if>
      <xsl:if test="al:TL">
        <xsl:element name="{$pr}:TL" namespace="{$uri}">
          <xsl:value-of select="al:TL"/>
        </xsl:element>
      </xsl:if>
      <xsl:if test="al:PT">
        <xsl:element name="{$pr}:PT" namespace="{$uri}">
          <xsl:value-of select="al:PT"/>
        </xsl:element>
      </xsl:if>
      <xsl:if test="al:PTA">
        <xsl:element name="{$pr}:PTA" namespace="{$uri}">
          <xsl:value-of select="al:PTA"/>
        </xsl:element>
      </xsl:if>
      <xsl:if test="al:X">
        <xsl:element name="{$pr}:X" namespace="{$uri}">
          <xsl:value-of select="al:X"/>
        </xsl:element>
      </xsl:if>
      <xsl:if test="al:XA">
        <xsl:element name="{$pr}:XA" namespace="{$uri}">
          <xsl:value-of select="al:XA"/>
        </xsl:element>
      </xsl:if>
    </xsl:element>
  </xsl:template>


  <xsl:template match="node()">
    <xsl:choose>
      <xsl:when test="self::*">
        <xsl:choose>
          <!--mida pole vaja-->
          <xsl:when test="contains(';I;G;K;KA;KL;T;TA;TL;PT;PTA;X;XA;', concat(';', local-name(), ';'))">
          </xsl:when>

          <!--elemendid, millega midagi ette ei võeta, lihtsalt kopeeritakse-->
          <!--sr, hld, vk, er-->
          <xsl:otherwise>
            <xsl:element name="{$pr}:{local-name()}" namespace="{$uri}">
              <xsl:apply-templates select="@* | node()"/>
            </xsl:element>
          </xsl:otherwise>

        </xsl:choose>
      </xsl:when>

      <!--text(), comment(), processing-instruction() jvbvm-->
      <xsl:otherwise>
        <xsl:copy-of select="self::node()"/>
      </xsl:otherwise>

    </xsl:choose>
  </xsl:template>


  <xsl:template match="@*">
    <xsl:choose>

      <!--võõrkeelsed plokid, elemendid-->
      <xsl:when test="name() = 'xml:lang'">
        <xsl:copy-of select="self::node()"/>
      </xsl:when>

      <xsl:otherwise>
        <xsl:attribute name="{$pr}:{local-name()}" namespace="{$uri}">
          <xsl:value-of select="."/>
        </xsl:attribute>
      </xsl:otherwise>

    </xsl:choose>
  </xsl:template>


</xsl:stylesheet>
