<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:al="http://www.eo.ee/xml/xsl/scripts"
xmlns:msxsl="urn:schemas-microsoft-com:xslt">

  <xsl:output method="html" omit-xml-declaration="yes" indent="no" encoding="utf-8" />


  <msxsl:script language="JScript" implements-prefix="al">
    <![CDATA[

		// script line offset algab reast "msxsl:script" ja alates 1-st,
		// ehk "msxsl:script" eelneva rea #-le liita line number.

    // nii '.' ( self::node() ), 'current()', 'text()' kui ka $muutuja korral tulevad parameetrid 'nodelist' objektina
    // string ('') korral mitte objektina

		function RS(currtext) {
		var nt;
  
		if (typeof(currtext) == 'object') { // nodelist
			if (currtext.length == 0) {
				return '';
			}
			nt = currtext[0].text;
		}
		else {
			nt = currtext;
		}

		nt = nt.replace(/(&suba;(.+?)&subl;)/g, "$2".sub());
		nt = nt.replace(/(&supa;(.+?)&supl;)/g, "$2".sup());
		nt = nt.replace(/(&ba;(.+?)&bl;)/g, "$2".bold());
		nt = nt.replace(/(&la;(.+?)&ll;)/g, "<u>$2</u>");
		nt = nt.replace(/(&ema;(.+?)&eml;)/g, "$2".italics());

		// muutujad (entities)
    // teeme nüüd nii, et ainult teatud asjad asendame (et jääksid oma loomulikku rada kehtima &apos;, &#x0011; jne)
		nt = nt.replace(/(&(ja|jne|jt|ka|ehk|Hrl|hrl|nt|puudub|v|vm|vms|напр\.|и др\.|и т\. п\.|г\.);)/g, "$2".italics());

		return nt;
		}
]]>
  </msxsl:script>


  <xsl:variable name="veerud"></xsl:variable>

  <xsl:template match="outDOM">

    <html>
      <head>
        <META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=utf-8"/>
        <style type="text/css">
          .\_md {text-decoration:underline;color:blue;cursor:hand;}
          .\_xsmall {font-size:x-small;}
          .\_hl {background-color:yellow;font-weight:bold;}
          .\_bhl {background-color:pink;font-weight:bold;}
          .\_b {font-weight:bold;}
          .mvt, .tvt, .lvt {background-color:cyan;}
          .m, .ter {color:maroon;font-weight:bold;}
          .t, .d {color:green;font-style:italic;}
          .n {color:blue;}
          .k, .k1, .k2 {color:gray;font-style:italic;}
          .sl, .v, .v1, .v2, .s, .s1, .s2 {font-size:x-small;text-transform:uppercase;}
          .ml {color:sienna;}
        </style>
      </head>
      <body id="browseFrameBodyId">
        <table id="opTable" style="width:100%;">
          <tr>
            <td style="vertical-align:middle;font-size:normal;font-weight:bold;">
              <xsl:value-of select="concat(r/i[@n = 'q'], ': ', @qinfo, '; ')"/>
              <xsl:if test="@leide != ''">
                <!-- <xsl:number value="@leide" grouping-separator=" " grouping-size="3"/> -->
                <xsl:value-of select="@leide"/>
                <xsl:value-of select="concat(' ', r/i[@n = 'l'], ', ')"/>
              </xsl:if>
              <!--<xsl:number value="../cnt" grouping-separator=" " grouping-size="3"/>-->
              <xsl:value-of select="../cnt"/>
              <xsl:value-of select="concat(' ', r/i[@n = 'e'], '.')"/>
              <span id="maxPrintArts" style="font-weight:normal;font-size:x-small;">
                (<xsl:value-of select="r/i[@n = 'mpa']"/>)
              </span>
            </td>
            <td>
              <img id="changeTable" title="Muuda tabelit" style="cursor:hand;" src="graphics/TableHS.png" alt="tabeli sisu"></img>
            </td>
            <td>
              <img id="copyTable" title="Kopeeri tabel" src="graphics/CopyHS.png" alt="kopeeri tabel"></img>
            </td>
            <td align="right">
              <img id="eeLex" src="graphics/EELEX_tume.png" title="EELex logo" style="height:13px;"></img>
            </td>
            <td>
              <xsl:element name="img">
                <xsl:attribute name="id">qryMethod</xsl:attribute>
                <xsl:attribute name="src">
                  <xsl:value-of select="concat('graphics/', r/qM)"/>
                </xsl:attribute>
              </xsl:element>
            </td>
          </tr>
        </table>

        <xsl:variable name="dic_desc">
          <xsl:value-of select="r/dd"/>
        </xsl:variable>

        <xsl:variable name="TITLE_FLT_TEXT">
          <xsl:value-of select="r/i[@n = 'flt']"/>
        </xsl:variable>

        <xsl:variable name="TITLE_SORT_TEXT">
          <xsl:value-of select="r/i[@n = 'ts']"/>
        </xsl:variable>

        <div id="browseTableDiv" style="width:100%;height:90%;overflow:auto;border:1px solid black;">
          <table id="browseTable" border="1" style="width:100%;" soors="fromClient">

            <thead style="font-weight:bold;background-color:tomato;color:white;font-size:x-small;">
              <tr>
                <xsl:for-each select="document('')//xsl:variable[@name = 'veerud']/veerg">
                  <xsl:element name="th">
                    <xsl:value-of select="."/>
                  </xsl:element>
                </xsl:for-each>
              </tr>
            </thead>

            <tbody id="browseTableTBody">
              <xsl:for-each select="sr/A">

                <xsl:variable name="md">
                  <xsl:value-of select="md/t"/>
                </xsl:variable>
                <xsl:variable name="vf">
                  <xsl:value-of select="vf"/>
                </xsl:variable>
                <xsl:variable name="G">
                  <xsl:value-of select="G"/>
                </xsl:variable>
                <xsl:variable name="K">
                  <xsl:value-of select="K"/>
                </xsl:variable>
                <xsl:variable name="KL">
                  <xsl:value-of select="KL"/>
                </xsl:variable>
                <xsl:variable name="T">
                  <xsl:value-of select="T"/>
                </xsl:variable>
                <xsl:variable name="TA">
                  <xsl:value-of select="TA"/>
                </xsl:variable>
                <xsl:variable name="TL">
                  <xsl:value-of select="TL"/>
                </xsl:variable>
                <xsl:variable name="PT">
                  <xsl:value-of select="PT"/>
                </xsl:variable>
                <xsl:variable name="PTA">
                  <xsl:value-of select="PTA"/>
                </xsl:variable>

                <xsl:for-each select="l/t/*">
                  <!--<xsl:for-each select="pref:xg/pref:xgg/pref:x|pref:xg/pref:xgg/pref:glg/pref:gl">
                    <xsl:if test="local-name() = 'x'">
                      <xsl:element name="tr"></xsl:element>
                    </xsl:if>
                  </xsl:for-each>-->
                  <!--<xsl:for-each select="pref:xg">
                    <xsl:for-each select="pref:xgg">

                      <xsl:element name="tr">

                        <xsl:variable name="vasted">
                          <xsl:for-each select="pref:x">
                            <xsl:if test="position() &gt; 1">
                              <xsl:text>, </xsl:text>
                            </xsl:if>
                            <xsl:value-of select="."/>
                          </xsl:for-each>
                        </xsl:variable>

                        <xsl:element name="td">
                          <xsl:element name="span">
                            <xsl:attribute name="class">_md</xsl:attribute>
                            <xsl:attribute name="value">
                              <xsl:value-of select="concat($vf, '||', $G)" />
                            </xsl:attribute>
                            <xsl:value-of select="al:RS(string($md))" disable-output-escaping="yes" />
                          </xsl:element>
                        </xsl:element>
                        <xsl:element name="td">
                          <xsl:value-of select="$vasted"/>
                        </xsl:element>

                        <xsl:for-each select="pref:glg/pref:gl">
                          <xsl:element name="td">
                            <xsl:value-of select="."/>
                          </xsl:element>
                        </xsl:for-each>

                      </xsl:element>

                    </xsl:for-each>
                  </xsl:for-each>-->

                </xsl:for-each>
              </xsl:for-each>
            </tbody>

          </table>
        </div>

      </body>
    </html>

  </xsl:template>


  <xsl:template match="*">
    <xsl:apply-templates select="node()"></xsl:apply-templates>
  </xsl:template>


  <xsl:template match="text()">
    <xsl:if test="not(local-name(..) = 'A')">
      <xsl:text> &#x25AA;</xsl:text>
      <xsl:element name="span">
        <xsl:attribute name="class">
          <xsl:value-of select="local-name(..)"/>
        </xsl:attribute>
        <xsl:attribute name="style">
          <xsl:text>color:red;</xsl:text>
        </xsl:attribute>
        <xsl:value-of select="al:RS(string(.))" disable-output-escaping="yes"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template name="att">
    <xsl:value-of select="concat(' &#x25AB;', local-name(), '=')" />
    <xsl:text>"</xsl:text>
    <xsl:value-of select="." />
    <xsl:text>"</xsl:text>
  </xsl:template>

  <xsl:template name="att2">
    <xsl:value-of select="concat('[&#x25AB;', local-name(), '=')" />
    <xsl:text>"</xsl:text>
    <xsl:value-of select="." />
    <xsl:text>"]</xsl:text>
  </xsl:template>


</xsl:stylesheet>
