<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" omit-xml-declaration="no" indent="no" encoding="utf-8"/>

  <!--84 märki (115 - 31 = 84)-->
  <!--<xsl:variable name="fr_sym">^0123456789_%+/|AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsŠšZzŽžTtUuVvWwÕõÄäÖöÜüXxYy()[]</xsl:variable>-->
  <!--671 - 31 = 640; 640/8 = 80-->
  <!--<xsl:variable name="to_sym">&#xE001;&#xE002;&#xE003;&#xE004;&#xE005;&#xE006;&#xE007;&#xE008;&#xE009;&#xE00A;&#xE00B;&#xE00C;&#xE00D;&#xE00E;&#xE00F;&#xE010;&#xE011;&#xE011;&#xE013;&#xE013;&#xE015;&#xE015;&#xE017;&#xE017;&#xE019;&#xE019;&#xE01B;&#xE01B;&#xE01D;&#xE01D;&#xE01F;&#xE01F;&#xE021;&#xE021;&#xE023;&#xE023;&#xE025;&#xE025;&#xE027;&#xE027;&#xE029;&#xE029;&#xE02B;&#xE02B;&#xE02D;&#xE02D;&#xE02F;&#xE02F;&#xE031;&#xE031;&#xE033;&#xE033;&#xE035;&#xE035;&#xE037;&#xE037;&#xE039;&#xE039;&#xE03B;&#xE03B;&#xE03D;&#xE03D;&#xE03F;&#xE03F;&#xE041;&#xE041;&#xE043;&#xE043;&#xE045;&#xE045;&#xE047;&#xE047;&#xE049;&#xE049;&#xE04B;&#xE04B;&#xE04D;&#xE04D;&#xE04F;&#xE04F;</xsl:variable>-->

  <!--6. juuni 2010-->
  <!--111 - 31 = 80 märki-->
  <!--<xsl:variable name="fr_sym">^0123456789_%+/|AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsŠšZzŽžTtUuVvWwÕõÄäÖöÜüXxYy</xsl:variable>-->
  <!--671 - 31 = 640; 640/8 = 80-->
  <!--<xsl:variable name="to_sym">&#xE001;&#xE002;&#xE003;&#xE004;&#xE005;&#xE006;&#xE007;&#xE008;&#xE009;&#xE00A;&#xE00B;&#xE00C;&#xE00D;&#xE00E;&#xE00F;&#xE010;&#xE011;&#xE011;&#xE013;&#xE013;&#xE015;&#xE015;&#xE017;&#xE017;&#xE019;&#xE019;&#xE01B;&#xE01B;&#xE01D;&#xE01D;&#xE01F;&#xE01F;&#xE021;&#xE021;&#xE023;&#xE023;&#xE025;&#xE025;&#xE027;&#xE027;&#xE029;&#xE029;&#xE02B;&#xE02B;&#xE02D;&#xE02D;&#xE02F;&#xE02F;&#xE031;&#xE031;&#xE033;&#xE033;&#xE035;&#xE035;&#xE037;&#xE037;&#xE039;&#xE039;&#xE03B;&#xE03B;&#xE03D;&#xE03D;&#xE03F;&#xE03F;&#xE041;&#xE041;&#xE043;&#xE043;&#xE045;&#xE045;&#xE047;&#xE047;&#xE049;&#xE049;&#xE04B;&#xE04B;&#xE04D;&#xE04D;&#xE04F;&#xE04F;</xsl:variable>-->

  <!--02. märts 2011-->
  <!--181 - 31 = 150 märki
  1199 - 31 = 1168; 1168/8 = 146
  seega 'fr_sym' viimased 4 (ümarsulud, kantsulud) kustutatakse
  'fr_sym' esimesed 16 (sümbolid) teisenduvad üks-üheseselt, edaspidi on suurtähed võrdsed väiketähtedega
  ülejäänud võimalikud ( tühik nt: !"#$&'*,-.:;<=>?@\_`{|}~ ) jäävad samaks-->
  <xsl:variable name="fr_sym">^0123456789_%+/|AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsŠšZzŽžTtUuVvWwÕõÄäÖöÜüXxYyАаБбВвГгДдЕеЁёЖжЗзИиЙйКкЛлМмНнОоПпРрСсТтУуФфХхЦцЧчШшЩщЪъЫыЬьЭэЮюЯя()[]</xsl:variable>
  <xsl:variable name="to_sym">&#xE001;&#xE002;&#xE003;&#xE004;&#xE005;&#xE006;&#xE007;&#xE008;&#xE009;&#xE00A;&#xE00B;&#xE00C;&#xE00D;&#xE00E;&#xE00F;&#xE010;&#xE011;&#xE011;&#xE013;&#xE013;&#xE015;&#xE015;&#xE017;&#xE017;&#xE019;&#xE019;&#xE01B;&#xE01B;&#xE01D;&#xE01D;&#xE01F;&#xE01F;&#xE021;&#xE021;&#xE023;&#xE023;&#xE025;&#xE025;&#xE027;&#xE027;&#xE029;&#xE029;&#xE02B;&#xE02B;&#xE02D;&#xE02D;&#xE02F;&#xE02F;&#xE031;&#xE031;&#xE033;&#xE033;&#xE035;&#xE035;&#xE037;&#xE037;&#xE039;&#xE039;&#xE03B;&#xE03B;&#xE03D;&#xE03D;&#xE03F;&#xE03F;&#xE041;&#xE041;&#xE043;&#xE043;&#xE045;&#xE045;&#xE047;&#xE047;&#xE049;&#xE049;&#xE04B;&#xE04B;&#xE04D;&#xE04D;&#xE04F;&#xE04F;&#xE051;&#xE051;&#xE053;&#xE053;&#xE055;&#xE055;&#xE057;&#xE057;&#xE059;&#xE059;&#xE05B;&#xE05B;&#xE05D;&#xE05D;&#xE05F;&#xE05F;&#xE061;&#xE061;&#xE063;&#xE063;&#xE065;&#xE065;&#xE067;&#xE067;&#xE069;&#xE069;&#xE06B;&#xE06B;&#xE06D;&#xE06D;&#xE06F;&#xE06F;&#xE071;&#xE071;&#xE073;&#xE073;&#xE075;&#xE075;&#xE077;&#xE077;&#xE079;&#xE079;&#xE07B;&#xE07B;&#xE07D;&#xE07D;&#xE07F;&#xE07F;&#xE081;&#xE081;&#xE083;&#xE083;&#xE085;&#xE085;&#xE087;&#xE087;&#xE089;&#xE089;&#xE08B;&#xE08B;&#xE08D;&#xE08D;&#xE08F;&#xE08F;&#xE091;&#xE091;</xsl:variable>


  <xsl:template match="/">
    <xsl:copy>
      <xsl:apply-templates select="outDOM" />
    </xsl:copy>
  </xsl:template>


  <xsl:template match="outDOM">
    <xsl:copy>
      <xsl:copy-of select="@*" />
      <xsl:apply-templates select="fsi">
        <xsl:sort select="t" data-type="text" order="ascending" />
        <xsl:sort select="translate(n, $fr_sym, $to_sym)" data-type="text" order="ascending" />
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="fsi">
    <xsl:copy-of select="current()" />
  </xsl:template>


</xsl:stylesheet>
