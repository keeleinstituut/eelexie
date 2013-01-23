<?xml version="1.0" encoding="utf-8"?>
<!-- ************************************************************************************************************************ -->
<!--  Eesti-X sõnastikupõhi                                                                                                   -->
<!--  Prog : Ain Teesalu                                                                                                      -->
<!--  Viimati muudetud : 08.03.2011 11:44                                                                                     -->
<!-- ************************************************************************************************************************ -->
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:msxsl="urn:schemas-microsoft-com:xslt"
xmlns:al="http://www.eo.ee/xml/xsl/scripts"
xmlns:x="http://www.eki.ee/dict/dmo">


	<xsl:output method="html" omit-xml-declaration="yes" indent="no" encoding="utf-8" />


	<msxsl:script language="JScript" implements-prefix="al">
		<![CDATA[
		function RS(currtext, itStyle){
		// script line offset algab reast "msxsl:script" ja alates 1-st,
		// ehk "msxsl:script" eelneva rea #-le liita line number.

		var bn, nt;
  
    // nii '.' ( self::node() ), 'current()', 'text()' kui ka $muutuja korral tuleb 'nodelist' objektina
    // string ('') korral mitte objektina
  
		if (typeof(currtext) == 'object'){ // nodelist
			if (currtext.length == 0){
				return '';
			}
			if (currtext(0).nodeName == "#text"){
				bn = currtext(0).parentNode.baseName;
			}
			else{
				bn = currtext(0).baseName;
			}
			nt = currtext(0).text;
		}
		else{
			nt = currtext;
		}

		var ss;
		if (typeof(itStyle) == 'object'){ // nodelist
			ss = itStyle(0).text;
		}
		else{
			ss = itStyle;
		}
		
		// $1-$9, $1 on esimene
		nt = nt.replace(/(&suba;(.+?)&subl;)/g, "$2".sub());
		nt = nt.replace(/(&supa;(.+?)&supl;)/g, "$2".sup());
		nt = nt.replace(/(&ba;(.+?)&bl;)/g, "$2".bold());
		if (ss == '1'){
			nt = nt.replace(/(&ema;(.+?)&eml;)/g, "<i style='font-style:normal;'>$2</i>");
		}
		else{
			nt = nt.replace(/(&ema;(.+?)&eml;)/g, "$2".italics());
		}

		// muutujad (entities)
		nt = nt.replace(/(&(.+?);)/g, "$2".italics());

		return nt;
		}
]]>
	</msxsl:script>


	<xsl:variable name="dispNone">;x:mvl;x:all;x:G;x:K;x:KA;x:KL;x:T;x:TA;x:TL;x:PT;x:PTA;x:X;x:XA;</xsl:variable>

	<!--itad täidetakse app-i bodyOnLoad-is sellega, mis CSS-is on
	(etvw_local-name(..))-->
	<xsl:variable name="itad"></xsl:variable>
	<xsl:variable name="varjud">;etvw_data;etvw_maht;</xsl:variable>

	<!--edMode täidetakse oXsl3 jaoks ka app bodyOnLoad-is 1-ga-->
	<xsl:variable name="edMode">0</xsl:variable>

	<!--printing pannakse trükkimise alguses procs_sct - s 1-ks,
	samuti showShaded=0, kui varjutatud teksti väljatrükis ei taheta-->
	<xsl:variable name="printing">0</xsl:variable>
	<xsl:variable name="showShaded">1</xsl:variable>

  <xsl:variable name="suurTahed">;x:A;x:P;x:S;x:LS;x:KOM;x:G;x:K;x:KA;x:KL;x:T;x:TA;x:TL;x:X;x:XA;</xsl:variable>

  <xsl:variable name="data_srcex2_color">
		<xsl:choose>
			<xsl:when test="$printing = '0'">gold</xsl:when>
			<xsl:otherwise>silver</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="data_src_qqs_color">
		<xsl:choose>
			<xsl:when test="$printing = '0'">salmon</xsl:when>
			<xsl:otherwise>silver</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
  <xsl:variable name="data_src_en__color">
    <xsl:choose>
      <xsl:when test="$printing = '0'">darkorange</xsl:when>
      <xsl:otherwise>silver</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- artikli näitamisele saadetakse DOM -->
	<xsl:template match="/">
		<xsl:apply-templates select="*"></xsl:apply-templates>
	</xsl:template>
	<!-- / -->


	<!-- Word printi saadetakse sr -->
	<xsl:template match="x:sr">

		<body lang="et">
			<xsl:if test="$showShaded = '1' and $printing = '1'">
				<br/>
				<div>
					<h3 style="background-color:silver;">
						<xsl:value-of select="@qinfo"/>
					</h3>
				</div>
				<br/>
			</xsl:if>
			<xsl:apply-templates select="*">
				<xsl:with-param name="rada"/>
			</xsl:apply-templates>
		</body>

	</xsl:template>
	<!-- sr -->


	<xsl:template match="x:A">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<p>
			<xsl:apply-templates select="*[not(contains($dispNone, concat(';', name(), ';')))]">
				<xsl:with-param name="rada">
					<xsl:value-of select="concat($rada, name(), '[', $posnr, ']/')"></xsl:value-of>
				</xsl:with-param>
			</xsl:apply-templates>
		</p>
	</xsl:template>
	<!-- x:A -->


	<xsl:template match="*">
		<xsl:param name="rada"></xsl:param>
		<xsl:if test="not(contains($varjud, concat(';etvw_', local-name(), ';')) and $showShaded = '0')">
			<xsl:variable name="posnr">
				<xsl:number level="single" format="1"></xsl:number>
			</xsl:variable>

			<!-- ENNE elemendi teksti -->
			<!-- s, v -->
			<xsl:if test="@x:l[not(. = '')]">
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="@x:l">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($rada, name(), '[', $posnr, ']/')"></xsl:value-of>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(@x:l = 'ka')">
					<xsl:text>.</xsl:text>
				</xsl:if>
				<!--mõni vald või stiil võib ka grupis 1. olla-->
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="@x:mvtl[not(. = '')]">
        <xsl:if test="preceding::*[1][not(name() = 'x:m')]">,</xsl:if>
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="@x:mvtl">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($rada, name(), '[', $posnr, ']/')"></xsl:value-of>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="@x:tvtl[not(. = '')]">
				<xsl:text>. </xsl:text>
				<xsl:apply-templates select="@x:tvtl">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($rada, name(), '[', $posnr, ']/')"></xsl:value-of>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:text> </xsl:text>
			</xsl:if>
      <xsl:if test="name() = 'x:a'">
        <xsl:text>, </xsl:text>
        <xsl:if test="not(preceding-sibling::x:a)">
          <i>ka</i>
        </xsl:if>
      </xsl:if>
      <xsl:if test="name() = 'x:gki'">
        <xsl:if test="ancestor::x:grg">;</xsl:if>
      </xsl:if>
      <xsl:if test="name() = 'x:tp'">
				<xsl:if test="count(../x:tp) > 1">
					<br/>
					<xsl:apply-templates select="@x:tnr">
						<xsl:with-param name="rada">
							<xsl:value-of select="concat($rada, name(), '[', $posnr, ']/')"></xsl:value-of>
						</xsl:with-param>
					</xsl:apply-templates>
					<xsl:text>.</xsl:text>
				</xsl:if>
			</xsl:if>
      <xsl:if test="name() = 'x:qnp'">
        <xsl:if test="count(../x:qnp) > 1">
          <xsl:if test="number(@x:ntnr) > 1">,</xsl:if>
          <xsl:text> (</xsl:text>
          <xsl:apply-templates select="@x:ntnr">
            <xsl:with-param name="rada">
              <xsl:value-of select="concat($rada, name(), '[', $posnr, ']/')"></xsl:value-of>
            </xsl:with-param>
          </xsl:apply-templates>
          <xsl:text>)</xsl:text>
        </xsl:if>
      </xsl:if>
      <xsl:if test="name() = 'x:kom'">
        <br/>
      </xsl:if>

      <xsl:choose>
        <xsl:when test="text()">
          <xsl:choose>
            <xsl:when test="name() = 'x:data'">
              <br/>
              <xsl:apply-templates select="@*">
								<xsl:with-param name="rada">
									<xsl:value-of select="concat($rada, name(), '[', $posnr, ']/')"></xsl:value-of>
								</xsl:with-param>
							</xsl:apply-templates>
							<xsl:text> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="nodePosnr">
								<xsl:number level="single" count="node()[not(contains($dispNone, concat(';', name(), ';')))]" format="1"></xsl:number>
							</xsl:variable>
							<xsl:if test="$nodePosnr > 1">
								<xsl:text> </xsl:text>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text> </xsl:text>
					<xsl:choose>
						<xsl:when test="name() = 'x:grg'">
							<xsl:if test="not(preceding-sibling::x:grg)">
								<xsl:text>&lt;</xsl:text>
							</xsl:if>
						</xsl:when>
						<xsl:when test="name() = 'x:np'">
							<!-- Black Diamond Suit -->
							<xsl:text>&#x2666;</xsl:text>
						</xsl:when>
						<xsl:when test="name() = 'x:LS'">
							<br/>
              <!--Black Square-->
              <xsl:text>&#x25A0;</xsl:text>
              <b>Ls:</b>
							<xsl:text> </xsl:text>
							<xsl:apply-templates select="@*">
								<xsl:with-param name="rada">
									<xsl:value-of select="concat($rada, name(), '[', $posnr, ']/')"></xsl:value-of>
								</xsl:with-param>
							</xsl:apply-templates>
							<xsl:text> </xsl:text>
						</xsl:when>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>

      <xsl:if test="name() = 'x:gki'">
        <xsl:if test="ancestor::x:tp">
          <xsl:if test="not(preceding-sibling::x:gki)">
            <xsl:text>&lt;</xsl:text>
          </xsl:if>
        </xsl:if>
      </xsl:if>
      <xsl:if test="name() = 'x:mf'">
				<xsl:text>\</xsl:text>
			</xsl:if>
      <xsl:if test="name() = 'x:r'">
        <xsl:if test="not(preceding-sibling::node()[1][name() = 'x:r'])">
          <xsl:text>{</xsl:text>
        </xsl:if>
      </xsl:if>
      <xsl:if test="name() = 'x:hld'">
				<xsl:text>[</xsl:text>
			</xsl:if>
      <xsl:if test="name() = 'x:dt'">
        <xsl:text>(&lt; </xsl:text>
      </xsl:if>
      <xsl:if test="name() = 'x:d'">
				<xsl:if test="not(preceding-sibling::x:d)">
					<xsl:text>(</xsl:text>
				</xsl:if>
			</xsl:if>
      <xsl:if test="name() = 'x:nd'">
        <xsl:if test="not(preceding-sibling::x:nd)">
          <xsl:text>(</xsl:text>
        </xsl:if>
      </xsl:if>
      <xsl:if test="name() = 'x:lsd'">
        <xsl:text>(</xsl:text>
      </xsl:if>
      <xsl:if test="name() = 'x:kaut'">
        <xsl:text>[</xsl:text>
      </xsl:if>
      <xsl:if test="name() = 'x:kaeg'">
        <xsl:text>[</xsl:text>
      </xsl:if>


      <xsl:if test="name() = 'x:grp'">
        <xsl:if test="not(preceding-sibling::x:grp)">
          <xsl:text>&lt; </xsl:text>
        </xsl:if>
      </xsl:if>

      <!-- Võimalik elemendi TEKST -->
			<xsl:apply-templates select="node()[not(contains($dispNone, concat(';', name(), ';')))][not(. = '')]">
				<xsl:with-param name="rada">
					<xsl:value-of select="concat($rada, name(), '[', $posnr, ']/')"></xsl:value-of>
				</xsl:with-param>
			</xsl:apply-templates>


			<!--PEALE teksti-->
			<!-- m -->
			<xsl:if test="@x:i[not(. = '')]">
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="@x:i">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($rada, name(), '[', $posnr, ']/')"></xsl:value-of>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:if>
      <xsl:if test="name() = 'x:gki'">
        <xsl:if test="ancestor::x:tp">
          <xsl:choose>
            <xsl:when test="following-sibling::x:gki">
              <xsl:text>;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>&gt;</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:if>
      <xsl:if test="name() = 'x:mf'">
				<xsl:text>\</xsl:text>
			</xsl:if>
      <xsl:if test="name() = 'x:r'">
        <xsl:choose>
          <xsl:when test="following-sibling::node()[1][name() = 'x:r']">,</xsl:when>
          <xsl:otherwise>}</xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <xsl:if test="name() = 'x:rk'">
        <xsl:choose>
          <xsl:when test="following-sibling::x:rk"> /</xsl:when>
        </xsl:choose>
      </xsl:if>
      <xsl:if test="name() = 'x:hld'">
				<xsl:text>]</xsl:text>
	  </xsl:if>
      <xsl:if test="name() = 'x:mg'">
        <xsl:choose>
          <xsl:when test="following-sibling::x:mg">;</xsl:when>
        </xsl:choose>
      </xsl:if>
      <xsl:if test="name() = 'x:sly'">
        <xsl:choose>
          <xsl:when test="following-sibling::x:sly">,</xsl:when>
        </xsl:choose>
      </xsl:if>
      <xsl:if test="name() = 'x:v'">
        <xsl:choose>
          <xsl:when test="following-sibling::*[1][local-name() = 'v' or local-name() = 's']">,</xsl:when>
        </xsl:choose>
      </xsl:if>
      <xsl:if test="name() = 'x:s'">
        <xsl:choose>
          <xsl:when test="following-sibling::*[1][local-name() = 's']">,</xsl:when>
        </xsl:choose>
      </xsl:if>
      <xsl:if test="name() = 'x:dt'">
        <xsl:text>)</xsl:text>
      </xsl:if>
      <xsl:if test="name() = 'x:d'">
				<xsl:choose>
					<xsl:when test="following-sibling::x:d">;</xsl:when>
					<xsl:otherwise>)</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
      <xsl:if test="name() = 'x:nd'">
        <xsl:choose>
          <xsl:when test="following-sibling::x:nd">,</xsl:when>
          <xsl:otherwise>)</xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <xsl:if test="name() = 'x:lsd'">
        <xsl:text>)</xsl:text>
      </xsl:if>
      <xsl:if test="name() = 'x:grg'">
				<xsl:choose>
					<xsl:when test="following-sibling::x:grg">;</xsl:when>
					<xsl:otherwise>&gt;</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
      <xsl:if test="name() = 'x:tg'">
        <xsl:if test="following-sibling::x:tg">;</xsl:if>
      </xsl:if>
      <xsl:if test="name() = 'x:slg'">
        <xsl:if test="following-sibling::x:slg">,</xsl:if>
      </xsl:if>
      <xsl:if test="name() = 'x:dg'">
        <xsl:if test="following-sibling::x:dg">,</xsl:if>
      </xsl:if>
      <xsl:if test="name() = 'x:ng'">
				<xsl:if test="following-sibling::x:ng">;</xsl:if>
			</xsl:if>
			<xsl:if test="name() = 'x:n'">
				<xsl:if test="following-sibling::x:n">,</xsl:if>
			</xsl:if>
      <xsl:if test="name() = 'x:kaut'">
        <xsl:text>]</xsl:text>
      </xsl:if>
      <xsl:if test="name() = 'x:kaeg'">
        <xsl:text>]</xsl:text>
      </xsl:if>

      <xsl:if test="name() = 'x:grp'">
        <xsl:choose>
          <xsl:when test="following-sibling::x:grp">;</xsl:when>
          <xsl:otherwise> &gt;</xsl:otherwise>
        </xsl:choose>
      </xsl:if>


      <!-- rk -->      
	  <xsl:if test="@x:rk[not(. = '')]">
		<xsl:text> [</xsl:text>
			<xsl:apply-templates select="@x:rk">
				<xsl:with-param name="rada">
					<xsl:value-of select="concat($rada, name(), '[', $posnr, ']/')"></xsl:value-of>
				</xsl:with-param>
			</xsl:apply-templates>
		<xsl:text>]</xsl:text>
	  </xsl:if>







    </xsl:if>
	</xsl:template>
	<!-- * -->


	<xsl:template match="text()">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>


		<!--ENNE teksti-->
		<!--tühik tuleb siin ikkagi lisada, mixed väljad: r-->
		<xsl:variable name="nodePosnr">
			<xsl:number level="single" count="node()[not(contains($dispNone, concat(';', name(), ';')))]" format="1"></xsl:number>
		</xsl:variable>
		<xsl:if test="$nodePosnr > 1">
			<xsl:text> </xsl:text>
		</xsl:if>


		<!-- TEKST -->
		<!--Kui siin tuleks mõni element panna "a"(anchor href) sisse, siis tuleb võrrelda, kas "$printing = '1'"-->
		<xsl:element name="span">
			<!--tabIndex - it ja id - d on igal juhul vaja, va ainult trüki korral-->
			<xsl:if test="$printing = '0'">
				<xsl:attribute name="tabIndex">0</xsl:attribute>
				<xsl:attribute name="id">
          <xsl:value-of select="concat($rada, 'text()[', $posnr, ']')" />
        </xsl:attribute>
			</xsl:if>
			<!--vaate viisi korral ei ole tõenäoline, et CSS nimed kokku langevad, seega on
		elemendi klassi juures kasutatud ainult local-name(..) - t, mitte unikaalset
		nimetust. etvw: "element text in view". Tekstide editeerimine (edit/noedit) on app-i 
		globaalses muutujas, kuna edit/noedit peab kehtima kõikide parandamise XSL-ide 
		jaoks ühtemoodi.-->
			<xsl:attribute name="class">
        <xsl:variable name="lnOsa">
          <xsl:if test="contains($suurTahed, concat(';', name(), ';'))">
            <xsl:text>__</xsl:text>
          </xsl:if>
          <xsl:value-of select="local-name(..)"/>
        </xsl:variable>
				<xsl:choose>
					<xsl:when test="$edMode = '1'">
						<xsl:value-of select="concat('etvw etvw_', $lnOsa, ' noedit')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat('etvw_', $lnOsa)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="lang">
				<xsl:call-template name="get_lang"></xsl:call-template>
			</xsl:attribute>
			<xsl:if test="name(..) = 'x:m' and ../@x:liik[. = 'z']">
				<xsl:attribute name="style">font-style:italic;</xsl:attribute>
			</xsl:if>
			<xsl:if test="name(..) = 'x:maht'">
				<xsl:attribute name="style">background-color:sandybrown;</xsl:attribute>
			</xsl:if>

			<xsl:if test="name(..) = 'x:data'">
				<xsl:choose>
					<xsl:when test="../@x:src = 'dmo'">
						<xsl:attribute name="style">
							<xsl:value-of select="concat('background-color:', $data_srcex2_color, ';')"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:when test="../@x:src = 'qqs'">
						<xsl:attribute name="style">
							<xsl:value-of select="concat('background-color:', $data_src_qqs_color, ';')"/>
						</xsl:attribute>
					</xsl:when>
          <xsl:when test="../@x:src = 'en_'">
            <xsl:attribute name="style">
              <xsl:value-of select="concat('background-color:', $data_src_en__color, ';')"/>
            </xsl:attribute>
          </xsl:when>
        </xsl:choose>
			</xsl:if>
      <xsl:if test="$printing = '0'">
        <xsl:if test="name(..) = 'x:x' and . = '|vaste|'">
          <xsl:attribute name="style">color:red;</xsl:attribute>
        </xsl:if>
        <xsl:if test="name(..) = 'x:qn' and . = '|tõlge|'">
          <xsl:attribute name="style">color:red;</xsl:attribute>
        </xsl:if>
      </xsl:if>
      <xsl:choose>
				<xsl:when test="name(..) = 'x:mvt' or name(..) = 'x:tvt' or name(..) = 'x:a' or name(..) = 'x:dt'">
					<xsl:choose>
						<xsl:when test="$printing = '0'">
							<a href="../xxx.cgi" style="background-color:cyan;">
								<xsl:value-of select="current()" />
							</a>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="current()" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="contains($itad, concat(';etvw_', local-name(..), ';'))">
					<xsl:value-of select="al:RS(current(), '1')" disable-output-escaping="yes" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="al:RS(current(), '0')" disable-output-escaping="yes" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>


		<!--PEALE teksti-->

	</xsl:template>
	<!-- text() -->


	<xsl:template match="@*">
		<xsl:param name="rada"></xsl:param>
		<xsl:element name="span">
			<xsl:if test="$printing = '0'">
				<xsl:attribute name="tabIndex">0</xsl:attribute>
				<xsl:attribute name="id">
					<xsl:value-of select="concat($rada, '@', name())" />
				</xsl:attribute>
			</xsl:if>
			<!--atvw>: "attribute text in view"-->
			<xsl:attribute name="class">
				<xsl:choose>
					<xsl:when test="$edMode = '1'">
						<xsl:value-of select="concat('atvw atvw_', local-name(), ' noedit')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat('atvw_', local-name())"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="lang">
				<xsl:call-template name="get_lang"></xsl:call-template>
			</xsl:attribute>
			<!--algtekst 'data' src atribuut-->
			<xsl:if test="name() = 'x:src' and name(..) = 'x:data'">
				<xsl:choose>
					<xsl:when test=". = 'dmo'">
						<xsl:attribute name="style">
							<xsl:value-of select="concat('border:', $data_srcex2_color, ' 2px solid;')"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:when test=". = 'qqs'">
						<xsl:attribute name="style">
							<xsl:value-of select="concat('border:', $data_src_qqs_color, ' 2px solid;')"/>
						</xsl:attribute>
					</xsl:when>
          <xsl:when test=". = 'en_'">
            <xsl:attribute name="style">
              <xsl:value-of select="concat('border:', $data_src_en__color, ' 2px solid;')"/>
            </xsl:attribute>
          </xsl:when>
        </xsl:choose>
			</xsl:if>
			<!--liitsõnaploki 'LS' src atribuut-->
			<xsl:if test="name() = 'x:lso' and name(..) = 'x:LS'">
				<xsl:attribute name="style">
					<xsl:text>text-decoration:underline;</xsl:text>
				</xsl:attribute>
			</xsl:if>
      <xsl:choose>
        <xsl:when test="name() = 'x:mvtl'">
          <xsl:choose>
            <xsl:when test=". = 'var'">
              <i>vt</i>
            </xsl:when>
            <xsl:when test=". = 'gr'">
              <!--nool paremale-->
              <xsl:text>&#x2192;</xsl:text>
            </xsl:when>
            <xsl:when test=". = 'fr'">
              <i>vtfr</i>
            </xsl:when>
            <xsl:when test=". = 'srj'">
              <i>vt ka</i>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="."/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
		</xsl:element>
	</xsl:template>
	<!-- @* -->


  <xsl:include href="include/incTemplates.xsl" />


</xsl:stylesheet>
<!-- Stylus Studio meta-information - (c) 2004-2009. Progress Software Corporation. All rights reserved.

<metaInformation>
	<scenarios/>
	<MapperMetaTag>
		<MapperInfo srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
		<MapperBlockPosition></MapperBlockPosition>
		<TemplateContext></TemplateContext>
		<MapperFilter side="source"></MapperFilter>
	</MapperMetaTag>
</metaInformation>
-->