<?xml version="1.0"?>
<xsl:stylesheet version="1.0" x:mode="auto" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:pr_sd="http://www.eo.ee/dev/xml/names" xmlns:x="http://www.eki.ee/dict/dmo">
	<xsl:output method="html" omit-xml-declaration="yes" indent="no" encoding="utf-8"/>
	<xsl:include href="include/incTemplates.xsl"/>
	<xsl:template match="x:r" mode="el_in_mixed">
		<xsl:param name="rada"/>
		<xsl:param name="vanem_kirjeldav"/>
		<xsl:param name="vanem_muudetav"/>
		<xsl:param name="vanem_unname"/>
		<xsl:variable name="allposnr">
			<xsl:number level="single" count="node()" format="1"></xsl:number>
		</xsl:variable>
		<xsl:if test="$allposnr &gt; 1">
			<xsl:element name="br"></xsl:element>
		</xsl:if>
		<xsl:variable name="mposnr">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<xsl:element name="span">
			<xsl:attribute name="id">
				<xsl:value-of select="concat($rada, 'x:r[', $mposnr, ']')"></xsl:value-of>
			</xsl:attribute>
			<xsl:attribute name="title">
				<xsl:value-of select="concat('rektsioon: x:r[', $mposnr, ']')"></xsl:value-of>
			</xsl:attribute>
			<xsl:attribute name="class">enmx enmx_x-r_120_58_114 noedit</xsl:attribute>
			<xsl:attribute name="tabIndex">0</xsl:attribute>
			<xsl:value-of select="local-name()"></xsl:value-of>
		</xsl:element>
		<xsl:apply-templates select="node()" mode="el_in_mixed">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:r[', $mposnr, ']/')"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">rektsioon</xsl:with-param>
			<xsl:with-param name="vanem_muudetav">edit</xsl:with-param>
			<xsl:with-param name="vanem_unname">x-r_120_58_114</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="x:ld" mode="el_in_mixed">
		<xsl:param name="rada"/>
		<xsl:param name="vanem_kirjeldav"/>
		<xsl:param name="vanem_muudetav"/>
		<xsl:param name="vanem_unname"/>
		<xsl:variable name="allposnr">
			<xsl:number level="single" count="node()" format="1"></xsl:number>
		</xsl:variable>
		<xsl:if test="$allposnr &gt; 1">
			<xsl:element name="br"></xsl:element>
		</xsl:if>
		<xsl:variable name="mposnr">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<xsl:element name="span">
			<xsl:attribute name="id">
				<xsl:value-of select="concat($rada, 'x:ld[', $mposnr, ']')"></xsl:value-of>
			</xsl:attribute>
			<xsl:attribute name="title">
				<xsl:value-of select="concat('ladina termin: x:ld[', $mposnr, ']')"></xsl:value-of>
			</xsl:attribute>
			<xsl:attribute name="class">enmx enmx_x-ld_120_58_108_100 noedit</xsl:attribute>
			<xsl:attribute name="tabIndex">0</xsl:attribute>
			<xsl:value-of select="local-name()"></xsl:value-of>
		</xsl:element>
		<xsl:if test="@xml:lang">
			<xsl:text> </xsl:text>
			<xsl:element name="span">
				<xsl:attribute name="id">
					<xsl:value-of select="concat($rada, 'x:ld[', $mposnr, ']/@xml:lang')"></xsl:value-of>
				</xsl:attribute>
				<xsl:attribute name="title">
					<xsl:value-of select="concat('xml:lang: x:ld[', $mposnr, ']/@xml:lang')"></xsl:value-of>
				</xsl:attribute>
				<xsl:attribute name="class">atmx atmx_xml-lang_120_109_108_58_108_97_110_103 noedit</xsl:attribute>
				<xsl:if test="@xml:lang = ''">
					<xsl:attribute name="style">width:16px;</xsl:attribute>
				</xsl:if>
				<xsl:attribute name="lang">
					<xsl:call-template name="get_lang"></xsl:call-template>
				</xsl:attribute>
				<xsl:attribute name="tabIndex">0</xsl:attribute>
				<xsl:value-of select="@xml:lang"></xsl:value-of>
			</xsl:element>
		</xsl:if>
		<xsl:apply-templates select="node()" mode="el_in_mixed">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:ld[', $mposnr, ']/')"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">ladina termin</xsl:with-param>
			<xsl:with-param name="vanem_muudetav">edit</xsl:with-param>
			<xsl:with-param name="vanem_unname">x-ld_120_58_108_100</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="x:xr" mode="el_in_mixed">
		<xsl:param name="rada"/>
		<xsl:param name="vanem_kirjeldav"/>
		<xsl:param name="vanem_muudetav"/>
		<xsl:param name="vanem_unname"/>
		<xsl:variable name="allposnr">
			<xsl:number level="single" count="node()" format="1"></xsl:number>
		</xsl:variable>
		<xsl:if test="$allposnr &gt; 1">
			<xsl:element name="br"></xsl:element>
		</xsl:if>
		<xsl:variable name="mposnr">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<xsl:element name="span">
			<xsl:attribute name="id">
				<xsl:value-of select="concat($rada, 'x:xr[', $mposnr, ']')"></xsl:value-of>
			</xsl:attribute>
			<xsl:attribute name="title">
				<xsl:value-of select="concat('rektsioon: x:xr[', $mposnr, ']')"></xsl:value-of>
			</xsl:attribute>
			<xsl:attribute name="class">enmx enmx_x-xr_120_58_120_114 noedit</xsl:attribute>
			<xsl:attribute name="tabIndex">0</xsl:attribute>
			<xsl:value-of select="local-name()"></xsl:value-of>
		</xsl:element>
		<xsl:apply-templates select="node()" mode="el_in_mixed">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:xr[', $mposnr, ']/')"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">rektsioon</xsl:with-param>
			<xsl:with-param name="vanem_muudetav">edit</xsl:with-param>
			<xsl:with-param name="vanem_unname">x-xr_120_58_120_114</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="text()" mode="el_in_mixed">
		<xsl:param name="rada"/>
		<xsl:param name="vanem_kirjeldav"/>
		<xsl:param name="vanem_muudetav"/>
		<xsl:param name="vanem_unname"/>
		<xsl:param name="alates"/>
		<xsl:variable name="allposnr">
			<xsl:number level="single" count="node()" format="1"></xsl:number>
		</xsl:variable>
		<xsl:if test="$allposnr &gt; 1">
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:variable name="mposnr">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<xsl:element name="span">
			<xsl:attribute name="id">
				<xsl:value-of select="concat($rada, 'text()[', $mposnr, ']')"></xsl:value-of>
			</xsl:attribute>
			<xsl:attribute name="title">
				<xsl:value-of select="concat($vanem_kirjeldav, ': text()[', $mposnr, ']')"></xsl:value-of>
			</xsl:attribute>
			<xsl:attribute name="class">
				<xsl:value-of select="concat('et et_', $vanem_unname, ' ', $vanem_muudetav)"></xsl:value-of>
			</xsl:attribute>
			<xsl:choose>
				<xsl:when test="$alates = 'true' and count(../node()) = 1">
					<xsl:attribute name="style">width:100%;</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test=". = ''">
						<xsl:attribute name="style">width:16px;</xsl:attribute>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:attribute name="lang">
				<xsl:call-template name="get_lang"></xsl:call-template>
			</xsl:attribute>
			<xsl:attribute name="tabIndex">0</xsl:attribute>
			<xsl:value-of select="."></xsl:value-of>
		</xsl:element>
	</xsl:template>
	<xsl:template match="comment()" mode="el_in_mixed">
		<xsl:param name="rada"/>
		<xsl:param name="vanem_kirjeldav"/>
		<xsl:param name="vanem_muudetav"/>
		<xsl:param name="vanem_unname"/>
		<xsl:variable name="allposnr">
			<xsl:number level="single" count="node()" format="1"></xsl:number>
		</xsl:variable>
		<xsl:if test="$allposnr &gt; 1">
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:variable name="mposnr">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<xsl:element name="span">
			<xsl:attribute name="id">
				<xsl:value-of select="concat($rada, 'comment()[', $mposnr, ']')"></xsl:value-of>
			</xsl:attribute>
			<xsl:attribute name="title">
				<xsl:value-of select="concat($vanem_kirjeldav, ': comment()[', $mposnr, ']')"></xsl:value-of>
			</xsl:attribute>
			<xsl:attribute name="class">
				<xsl:value-of select="concat('ct ct_', $vanem_unname, ' ', $vanem_muudetav)"></xsl:value-of>
			</xsl:attribute>
			<xsl:if test=". = ''">
				<xsl:attribute name="style">width:16px;</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="lang">
				<xsl:call-template name="get_lang"></xsl:call-template>
			</xsl:attribute>
			<xsl:attribute name="tabIndex">0</xsl:attribute>
			<xsl:value-of select="."></xsl:value-of>
		</xsl:element>
	</xsl:template>
	<xsl:template match="/">
		<body lang="et">
			<table id="cnt_tbl" border="1" width="100%" cellSpacing="0">
				<xsl:apply-templates select="*/*"></xsl:apply-templates>
			</table>
		</body>
	</xsl:template>
	<xsl:template match="x:A">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="posnr_A">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<xsl:if test="not(x:P)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:P|', $rada, 'x:A[', $posnr_A, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:P</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-P_120_58_80 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>päis</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:P">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:A[', $posnr_A, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:S)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:S|', $rada, 'x:A[', $posnr_A, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:S</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-S_120_58_83 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>sisu</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:S">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:A[', $posnr_A, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:data)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:data|', $rada, 'x:A[', $posnr_A, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:data</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-data_120_58_100_97_116_97 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>algtekst</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:data">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:A[', $posnr_A, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:KOM)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:KOM|', $rada, 'x:A[', $posnr_A, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:KOM</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-KOM_120_58_75_79_77 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>kommentaarid</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:KOM">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:A[', $posnr_A, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:PT">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:A[', $posnr_A, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:PTA">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:A[', $posnr_A, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="x:P">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="posnr_P">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td colspan="2" width="35%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:P[', $posnr_P, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:P[', $posnr_P, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-P_120_58_80 noedit</xsl:attribute>
					<xsl:attribute name="style">float:left;</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>päis</xsl:element>
			</td>
			<td/>
			<td width="32px">
				<xsl:if test="not(x:a and x:mvt)">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('addlisad||', $rada, 'x:P[', $posnr_P, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<xsl:if test="*[. = '']">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('dellisad||', $rada, 'x:P[', $posnr_P, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/delart 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Kustuta tühjad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
			</td>
		</tr>
		<xsl:if test="not(x:mg)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:mg|', $rada, 'x:P[', $posnr_P, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:mg</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-mg_120_58_109_103 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>märksõna grupp</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:mg">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:P[', $posnr_P, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:a)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:a|', $rada, 'x:P[', $posnr_P, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:a</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-a_120_58_97 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>alternatiiv</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:a">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:P[', $posnr_P, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:mvt)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:mvt|', $rada, 'x:P[', $posnr_P, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:mvt</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-mvt_120_58_109_118_116 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>märksõnaviide</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:mvt">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:P[', $posnr_P, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="x:mg">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="posnr_mg">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:mg[', $posnr_mg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "märksõna grupp"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:mg[', $posnr_mg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:mg[', $posnr_mg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-mg_120_58_109_103 noedit</xsl:attribute>
					<xsl:attribute name="style">float:left;</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>märksõna grupp</xsl:element>
			</td>
			<td/>
			<td width="32px">
				<xsl:if test="not(x:m and x:mf and x:hld and x:vk and x:v and x:s)">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('addlisad||', $rada, 'x:mg[', $posnr_mg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<xsl:if test="*[. = '']">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('dellisad||', $rada, 'x:mg[', $posnr_mg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/delart 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Kustuta tühjad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
			</td>
		</tr>
		<xsl:apply-templates select="x:m">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:mg[', $posnr_mg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:mf)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:mf|', $rada, 'x:mg[', $posnr_mg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:mf</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-mf_120_58_109_102 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>morfonoloogiline vorm</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:mf">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:mg[', $posnr_mg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:hld)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:hld|', $rada, 'x:mg[', $posnr_mg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:hld</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-hld_120_58_104_108_100 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>hääldus</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:hld">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:mg[', $posnr_mg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:vk)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:vk|', $rada, 'x:mg[', $posnr_mg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:vk</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-vk_120_58_118_107 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>vormikood</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:vk">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:mg[', $posnr_mg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:grp)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:grp|', $rada, 'x:mg[', $posnr_mg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:grp</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-grp_120_58_103_114_112 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>grammatika plokk</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:grp">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:mg[', $posnr_mg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:v)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:v|', $rada, 'x:mg[', $posnr_mg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:v</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-v_120_58_118 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>vald</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:v">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:mg[', $posnr_mg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:s)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:s|', $rada, 'x:mg[', $posnr_mg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:s</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-s_120_58_115 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>stiil</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:s">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:mg[', $posnr_mg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="x:grp">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="posnr_grp">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:grp[', $posnr_grp, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "grammatika plokk"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:grp[', $posnr_grp, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:grp[', $posnr_grp, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-grp_120_58_103_114_112 noedit</xsl:attribute>
					<xsl:attribute name="style">float:left;</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>grammatika plokk</xsl:element>
			</td>
			<td/>
			<td width="32px"></td>
		</tr>
		<xsl:if test="not(x:mfp)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:mfp|', $rada, 'x:grp[', $posnr_grp, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:mfp</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-mfp_120_58_109_102_112 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>morfoloogia plokk</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:mfp">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:grp[', $posnr_grp, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:gri)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:gri|', $rada, 'x:grp[', $posnr_grp, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:gri</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-gri_120_58_103_114_105 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>grammatiline info</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:gri">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:grp[', $posnr_grp, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="x:mfp">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="posnr_mfp">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:mfp[', $posnr_mfp, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "morfoloogia plokk"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:mfp[', $posnr_mfp, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:mfp[', $posnr_mfp, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-mfp_120_58_109_102_112 noedit</xsl:attribute>
					<xsl:attribute name="style">float:left;</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>morfoloogia plokk</xsl:element>
			</td>
			<td/>
			<td width="32px">
				<xsl:if test="not(x:mt)">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('addlisad||', $rada, 'x:mfp[', $posnr_mfp, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<xsl:if test="*[. = '']">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('dellisad||', $rada, 'x:mfp[', $posnr_mfp, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/delart 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Kustuta tühjad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
			</td>
		</tr>
		<xsl:if test="not(x:mkg)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:mkg|', $rada, 'x:mfp[', $posnr_mfp, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:mkg</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-mkg_120_58_109_107_103 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>morf.kirje grupp</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:mkg">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:mfp[', $posnr_mfp, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:mvg)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:mvg|', $rada, 'x:mfp[', $posnr_mfp, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:mvg</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-mvg_120_58_109_118_103 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>muutevormi grupp</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:mvg">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:mfp[', $posnr_mfp, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:mt)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:mt|', $rada, 'x:mfp[', $posnr_mfp, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:mt</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-mt_120_58_109_116 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>muuttüüp</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:mt">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:mfp[', $posnr_mfp, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="x:mkg">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="posnr_mkg">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:mkg[', $posnr_mkg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "morf.kirje grupp"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:mkg[', $posnr_mkg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:mkg[', $posnr_mkg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-mkg_120_58_109_107_103 noedit</xsl:attribute>
					<xsl:attribute name="style">float:left;</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>morf.kirje grupp</xsl:element>
			</td>
			<td/>
			<td width="32px">
				<xsl:if test="not(x:mkl and x:mk)">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('addlisad||', $rada, 'x:mkg[', $posnr_mkg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<xsl:if test="*[. = '']">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('dellisad||', $rada, 'x:mkg[', $posnr_mkg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/delart 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Kustuta tühjad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
			</td>
		</tr>
		<xsl:apply-templates select="x:mkl">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:mkg[', $posnr_mkg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:mk">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:mkg[', $posnr_mkg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="x:mvg">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="posnr_mvg">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:mvg[', $posnr_mvg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "muutevormi grupp"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:mvg[', $posnr_mvg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:mvg[', $posnr_mvg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-mvg_120_58_109_118_103 noedit</xsl:attribute>
					<xsl:attribute name="style">float:left;</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>muutevormi grupp</xsl:element>
			</td>
			<td/>
			<td width="32px">
				<xsl:if test="not(x:vk and x:mv)">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('addlisad||', $rada, 'x:mvg[', $posnr_mvg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<xsl:if test="*[. = '']">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('dellisad||', $rada, 'x:mvg[', $posnr_mvg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/delart 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Kustuta tühjad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
			</td>
		</tr>
		<xsl:if test="not(x:vk)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:vk|', $rada, 'x:mvg[', $posnr_mvg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:vk</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-vk_120_58_118_107 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>vormikood</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:vk">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:mvg[', $posnr_mvg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:mv)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:mv|', $rada, 'x:mvg[', $posnr_mvg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:mv</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-mv_120_58_109_118 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>muutevormid</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:mv">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:mvg[', $posnr_mvg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="x:gri">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="posnr_gri">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:gri[', $posnr_gri, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "grammatiline info"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:gri[', $posnr_gri, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:gri[', $posnr_gri, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-gri_120_58_103_114_105 noedit</xsl:attribute>
					<xsl:attribute name="style">float:left;</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>grammatiline info</xsl:element>
			</td>
			<td/>
			<td width="32px">
				<xsl:if test="not(x:sl and x:gki and x:r)">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('addlisad||', $rada, 'x:gri[', $posnr_gri, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<xsl:if test="*[. = '']">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('dellisad||', $rada, 'x:gri[', $posnr_gri, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/delart 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Kustuta tühjad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
			</td>
		</tr>
		<xsl:if test="not(x:sl)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:sl|', $rada, 'x:gri[', $posnr_gri, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:sl</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-sl_120_58_115_108 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>sõnaliik</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:sl">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:gri[', $posnr_gri, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:gki)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:gki|', $rada, 'x:gri[', $posnr_gri, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:gki</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-gki_120_58_103_107_105 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>gr.kasutusinfo</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:gki">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:gri[', $posnr_gri, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:r)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:r|', $rada, 'x:gri[', $posnr_gri, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:r</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-r_120_58_114 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>rektsioon</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:r">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:gri[', $posnr_gri, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="x:S">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="posnr_S">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td colspan="2" width="35%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:S[', $posnr_S, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:S[', $posnr_S, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-S_120_58_83 noedit</xsl:attribute>
					<xsl:attribute name="style">float:left;</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>sisu</xsl:element>
			</td>
			<td/>
			<td width="32px"></td>
		</tr>
		<xsl:if test="not(x:tp)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:tp|', $rada, 'x:S[', $posnr_S, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:tp</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-tp_120_58_116_112 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>tähendusnumbri  plokk</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:tp">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:S[', $posnr_S, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:LS)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:LS|', $rada, 'x:S[', $posnr_S, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:LS</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-LS_120_58_76_83 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>liitsõnade plokk</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:LS">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:S[', $posnr_S, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="x:tp">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="posnr_tp">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:tp[', $posnr_tp, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "tähendusnumbri  plokk"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:tp[', $posnr_tp, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:tp[', $posnr_tp, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-tp_120_58_116_112 noedit</xsl:attribute>
					<xsl:attribute name="style">float:left;</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>tähendusnumbri  plokk</xsl:element>
			</td>
			<td>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@x:tnr">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:tp[', $posnr_tp, ']/@x:tnr')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('tähendusnumber: x:tp[', $posnr_tp, ']/@x:tnr')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="class">at at_x-tnr_120_58_116_110_114 edit</xsl:attribute>
							<xsl:if test="@x:tnr = ''">
								<xsl:attribute name="style">width:16px;</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="lang">
								<xsl:call-template name="get_lang"></xsl:call-template>
							</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
							<xsl:value-of select="@x:tnr"></xsl:value-of>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="img">
							<xsl:attribute name="border">1</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat('addAttr|x:tnr|', $rada, 'x:tp[', $posnr_tp, ']')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="src">graphics/struprop_16-16.ico</xsl:attribute>
							<xsl:attribute name="alt">■</xsl:attribute>
							<xsl:attribute name="title">Lisa tunnus "tähendusnumber"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@x:as">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:tp[', $posnr_tp, ']/@x:as')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('elemendi staatus: x:tp[', $posnr_tp, ']/@x:as')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="class">at at_x-as_120_58_97_115 edit</xsl:attribute>
							<xsl:if test="@x:as = ''">
								<xsl:attribute name="style">width:16px;</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="lang">
								<xsl:call-template name="get_lang"></xsl:call-template>
							</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
							<xsl:value-of select="@x:as"></xsl:value-of>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="img">
							<xsl:attribute name="border">1</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat('addAttr|x:as|', $rada, 'x:tp[', $posnr_tp, ']')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="src">graphics/struprop_16-16.ico</xsl:attribute>
							<xsl:attribute name="alt">■</xsl:attribute>
							<xsl:attribute name="title">Lisa tunnus "elemendi staatus"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td width="32px">
				<xsl:if test="not(x:tvt)">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('addlisad||', $rada, 'x:tp[', $posnr_tp, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<xsl:if test="*[. = '']">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('dellisad||', $rada, 'x:tp[', $posnr_tp, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/delart 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Kustuta tühjad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
			</td>
		</tr>
		<xsl:if test="not(x:mmg)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:mmg|', $rada, 'x:tp[', $posnr_tp, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:mmg</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-mmg_120_58_109_109_103 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>allmärksõna grupp</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:mmg">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:tp[', $posnr_tp, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:gri)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:gri|', $rada, 'x:tp[', $posnr_tp, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:gri</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-gri_120_58_103_114_105 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>grammatiline info</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:gri">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:tp[', $posnr_tp, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:tg">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:tp[', $posnr_tp, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:np)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:np|', $rada, 'x:tp[', $posnr_tp, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:np</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-np_120_58_110_112 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>näidete plokk</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:np">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:tp[', $posnr_tp, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:tvt)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:tvt|', $rada, 'x:tp[', $posnr_tp, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:tvt</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-tvt_120_58_116_118_116 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>tähendusviide</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:tvt">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:tp[', $posnr_tp, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="x:mmg">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="posnr_mmg">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:mmg[', $posnr_mmg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:mmg[', $posnr_mmg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-mmg_120_58_109_109_103 noedit</xsl:attribute>
					<xsl:attribute name="style">float:left;</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>allmärksõna grupp</xsl:element>
			</td>
			<td/>
			<td width="32px">
				<xsl:if test="not(x:mm and x:vk)">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('addlisad||', $rada, 'x:mmg[', $posnr_mmg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<xsl:if test="*[. = '']">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('dellisad||', $rada, 'x:mmg[', $posnr_mmg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/delart 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Kustuta tühjad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
			</td>
		</tr>
		<xsl:apply-templates select="x:mm">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:mmg[', $posnr_mmg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:vk">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:mmg[', $posnr_mmg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="x:tg">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="posnr_tg">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:tg[', $posnr_tg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "tähendusgrupp"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:tg[', $posnr_tg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:tg[', $posnr_tg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-tg_120_58_116_103 noedit</xsl:attribute>
					<xsl:attribute name="style">float:left;</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>tähendusgrupp</xsl:element>
			</td>
			<td>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@x:as">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:tg[', $posnr_tg, ']/@x:as')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('elemendi staatus: x:tg[', $posnr_tg, ']/@x:as')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="class">at at_x-as_120_58_97_115 edit</xsl:attribute>
							<xsl:if test="@x:as = ''">
								<xsl:attribute name="style">width:16px;</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="lang">
								<xsl:call-template name="get_lang"></xsl:call-template>
							</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
							<xsl:value-of select="@x:as"></xsl:value-of>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="img">
							<xsl:attribute name="border">1</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat('addAttr|x:as|', $rada, 'x:tg[', $posnr_tg, ']')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="src">graphics/struprop_16-16.ico</xsl:attribute>
							<xsl:attribute name="alt">■</xsl:attribute>
							<xsl:attribute name="title">Lisa tunnus "elemendi staatus"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td width="32px"></td>
		</tr>
		<xsl:if test="not(x:dg)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:dg|', $rada, 'x:tg[', $posnr_tg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:dg</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-dg_120_58_100_103 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>definitsioonigrupp</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:dg">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:tg[', $posnr_tg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:xp">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:tg[', $posnr_tg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="x:dg">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="posnr_dg">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:dg[', $posnr_dg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "definitsioonigrupp"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:dg[', $posnr_dg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:dg[', $posnr_dg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-dg_120_58_100_103 noedit</xsl:attribute>
					<xsl:attribute name="style">float:left;</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>definitsioonigrupp</xsl:element>
			</td>
			<td/>
			<td width="32px">
				<xsl:if test="not(x:v and x:s and x:dt and x:d)">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('addlisad||', $rada, 'x:dg[', $posnr_dg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<xsl:if test="*[. = '']">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('dellisad||', $rada, 'x:dg[', $posnr_dg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/delart 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Kustuta tühjad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
			</td>
		</tr>
		<xsl:apply-templates select="x:v">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:dg[', $posnr_dg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:s">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:dg[', $posnr_dg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:dt">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:dg[', $posnr_dg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:d">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:dg[', $posnr_dg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="x:xp">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="posnr_xp">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:xp[', $posnr_xp, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:xp[', $posnr_xp, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-xp_120_58_120_112 noedit</xsl:attribute>
					<xsl:attribute name="style">float:left;</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>vastete plokk</xsl:element>
			</td>
			<td/>
			<td width="32px"></td>
		</tr>
		<xsl:apply-templates select="x:xg">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:xp[', $posnr_xp, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="x:xg">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="posnr_xg">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:xg[', $posnr_xg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "vastegrupp"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:xg[', $posnr_xg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:xg[', $posnr_xg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-xg_120_58_120_103 noedit</xsl:attribute>
					<xsl:attribute name="style">float:left;</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>vastegrupp</xsl:element>
			</td>
			<td>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@xml:lang">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:xg[', $posnr_xg, ']/@xml:lang')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('xml:lang: x:xg[', $posnr_xg, ']/@xml:lang')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="class">at at_xml-lang_120_109_108_58_108_97_110_103 noedit</xsl:attribute>
							<xsl:if test="@xml:lang = ''">
								<xsl:attribute name="style">width:16px;</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="lang">
								<xsl:call-template name="get_lang"></xsl:call-template>
							</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
							<xsl:value-of select="@xml:lang"></xsl:value-of>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="img">
							<xsl:attribute name="border">1</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat('addAttr|xml:lang|', $rada, 'x:xg[', $posnr_xg, ']')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="src">graphics/struprop_16-16.ico</xsl:attribute>
							<xsl:attribute name="alt">■</xsl:attribute>
							<xsl:attribute name="title">Lisa tunnus "xml:lang"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@x:as">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:xg[', $posnr_xg, ']/@x:as')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('elemendi staatus: x:xg[', $posnr_xg, ']/@x:as')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="class">at at_x-as_120_58_97_115 edit</xsl:attribute>
							<xsl:if test="@x:as = ''">
								<xsl:attribute name="style">width:16px;</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="lang">
								<xsl:call-template name="get_lang"></xsl:call-template>
							</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
							<xsl:value-of select="@x:as"></xsl:value-of>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="img">
							<xsl:attribute name="border">1</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat('addAttr|x:as|', $rada, 'x:xg[', $posnr_xg, ']')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="src">graphics/struprop_16-16.ico</xsl:attribute>
							<xsl:attribute name="alt">■</xsl:attribute>
							<xsl:attribute name="title">Lisa tunnus "elemendi staatus"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td width="32px">
				<xsl:if test="not(x:xtx and x:x and x:hld and x:xvk)">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('addlisad||', $rada, 'x:xg[', $posnr_xg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<xsl:if test="*[. = '']">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('dellisad||', $rada, 'x:xg[', $posnr_xg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/delart 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Kustuta tühjad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
			</td>
		</tr>
		<xsl:apply-templates select="x:xtx">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:xg[', $posnr_xg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:x">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:xg[', $posnr_xg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:hld)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:hld|', $rada, 'x:xg[', $posnr_xg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:hld</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-hld_120_58_104_108_100 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>hääldus</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:hld">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:xg[', $posnr_xg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:xvk)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:xvk|', $rada, 'x:xg[', $posnr_xg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:xvk</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-xvk_120_58_120_118_107 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>vormikood</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:xvk">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:xg[', $posnr_xg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:xgrp)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:xgrp|', $rada, 'x:xg[', $posnr_xg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:xgrp</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-xgrp_120_58_120_103_114_112 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>vaste grammatika plokk</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:xgrp">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:xg[', $posnr_xg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:xdg)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:xdg|', $rada, 'x:xg[', $posnr_xg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:xdg</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-xdg_120_58_120_100_103 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>vaste definitsioonigrupp</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:xdg">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:xg[', $posnr_xg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="x:xgrp">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="posnr_xgrp">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:xgrp[', $posnr_xgrp, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "vaste grammatika plokk"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:xgrp[', $posnr_xgrp, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:xgrp[', $posnr_xgrp, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-xgrp_120_58_120_103_114_112 noedit</xsl:attribute>
					<xsl:attribute name="style">float:left;</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>vaste grammatika plokk</xsl:element>
			</td>
			<td/>
			<td width="32px"></td>
		</tr>
		<xsl:if test="not(x:xmfp)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:xmfp|', $rada, 'x:xgrp[', $posnr_xgrp, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:xmfp</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-xmfp_120_58_120_109_102_112 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>vaste morfoloogia plokk</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:xmfp">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:xgrp[', $posnr_xgrp, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:xgri)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:xgri|', $rada, 'x:xgrp[', $posnr_xgrp, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:xgri</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-xgri_120_58_120_103_114_105 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>vaste grammatiline info</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:xgri">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:xgrp[', $posnr_xgrp, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="x:xmfp">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="posnr_xmfp">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:xmfp[', $posnr_xmfp, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "vaste morfoloogia plokk"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:xmfp[', $posnr_xmfp, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:xmfp[', $posnr_xmfp, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-xmfp_120_58_120_109_102_112 noedit</xsl:attribute>
					<xsl:attribute name="style">float:left;</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>vaste morfoloogia plokk</xsl:element>
			</td>
			<td/>
			<td width="32px">
				<xsl:if test="not(x:xmt)">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('addlisad||', $rada, 'x:xmfp[', $posnr_xmfp, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<xsl:if test="*[. = '']">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('dellisad||', $rada, 'x:xmfp[', $posnr_xmfp, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/delart 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Kustuta tühjad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
			</td>
		</tr>
		<xsl:if test="not(x:xmvg)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:xmvg|', $rada, 'x:xmfp[', $posnr_xmfp, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:xmvg</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-xmvg_120_58_120_109_118_103 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>vaste muutevormigrupp</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:xmvg">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:xmfp[', $posnr_xmfp, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:xag)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:xag|', $rada, 'x:xmfp[', $posnr_xmfp, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:xag</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-xag_120_58_120_97_103 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>gr.variandi grupp</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:xag">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:xmfp[', $posnr_xmfp, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:xmt)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:xmt|', $rada, 'x:xmfp[', $posnr_xmfp, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:xmt</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-xmt_120_58_120_109_116 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>vaste muuttüüp</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:xmt">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:xmfp[', $posnr_xmfp, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="x:xmvg">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="posnr_xmvg">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:xmvg[', $posnr_xmvg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "vaste muutevormigrupp"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:xmvg[', $posnr_xmvg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:xmvg[', $posnr_xmvg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-xmvg_120_58_120_109_118_103 noedit</xsl:attribute>
					<xsl:attribute name="style">float:left;</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>vaste muutevormigrupp</xsl:element>
			</td>
			<td/>
			<td width="32px">
				<xsl:if test="not(x:xvk and x:xmv)">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('addlisad||', $rada, 'x:xmvg[', $posnr_xmvg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<xsl:if test="*[. = '']">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('dellisad||', $rada, 'x:xmvg[', $posnr_xmvg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/delart 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Kustuta tühjad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
			</td>
		</tr>
		<xsl:if test="not(x:xvk)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:xvk|', $rada, 'x:xmvg[', $posnr_xmvg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:xvk</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-xvk_120_58_120_118_107 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>vormikood</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:xvk">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:xmvg[', $posnr_xmvg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:xmv)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:xmv|', $rada, 'x:xmvg[', $posnr_xmvg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:xmv</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-xmv_120_58_120_109_118 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>muutevormid</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:xmv">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:xmvg[', $posnr_xmvg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="x:xag">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="posnr_xag">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:xag[', $posnr_xag, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:xag[', $posnr_xag, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-xag_120_58_120_97_103 noedit</xsl:attribute>
					<xsl:attribute name="style">float:left;</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>gr.variandi grupp</xsl:element>
			</td>
			<td/>
			<td width="32px">
				<xsl:if test="not(x:xa and x:xmv)">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('addlisad||', $rada, 'x:xag[', $posnr_xag, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<xsl:if test="*[. = '']">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('dellisad||', $rada, 'x:xag[', $posnr_xag, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/delart 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Kustuta tühjad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
			</td>
		</tr>
		<xsl:if test="not(x:xa)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:xa|', $rada, 'x:xag[', $posnr_xag, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:xa</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-xa_120_58_120_97 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>gr.variant</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:xa">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:xag[', $posnr_xag, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:xmv)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:xmv|', $rada, 'x:xag[', $posnr_xag, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:xmv</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-xmv_120_58_120_109_118 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>muutevormid</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:xmv">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:xag[', $posnr_xag, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="x:xgri">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="posnr_xgri">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:xgri[', $posnr_xgri, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "vaste grammatiline info"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:xgri[', $posnr_xgri, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:xgri[', $posnr_xgri, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-xgri_120_58_120_103_114_105 noedit</xsl:attribute>
					<xsl:attribute name="style">float:left;</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>vaste grammatiline info</xsl:element>
			</td>
			<td/>
			<td width="32px">
				<xsl:if test="not(x:xsl and x:xz and x:xgki and x:xr)">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('addlisad||', $rada, 'x:xgri[', $posnr_xgri, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<xsl:if test="*[. = '']">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('dellisad||', $rada, 'x:xgri[', $posnr_xgri, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/delart 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Kustuta tühjad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
			</td>
		</tr>
		<xsl:if test="not(x:xsl)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:xsl|', $rada, 'x:xgri[', $posnr_xgri, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:xsl</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-xsl_120_58_120_115_108 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>sõnaliik</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:xsl">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:xgri[', $posnr_xgri, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:xz)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:xz|', $rada, 'x:xgri[', $posnr_xgri, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:xz</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-xz_120_58_120_122 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>gr.sugu</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:xz">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:xgri[', $posnr_xgri, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:xgki)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:xgki|', $rada, 'x:xgri[', $posnr_xgri, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:xgki</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-xgki_120_58_120_103_107_105 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>gr.kasutusinfo</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:xgki">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:xgri[', $posnr_xgri, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:xr)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:xr|', $rada, 'x:xgri[', $posnr_xgri, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:xr</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-xr_120_58_120_114 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>rektsioon</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:xr">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:xgri[', $posnr_xgri, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="x:xdg">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="posnr_xdg">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:xdg[', $posnr_xdg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "vaste definitsioonigrupp"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:xdg[', $posnr_xdg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:xdg[', $posnr_xdg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-xdg_120_58_120_100_103 noedit</xsl:attribute>
					<xsl:attribute name="style">float:left;</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>vaste definitsioonigrupp</xsl:element>
			</td>
			<td/>
			<td width="32px">
				<xsl:if test="not(x:xv and x:xs and x:xd and x:xn)">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('addlisad||', $rada, 'x:xdg[', $posnr_xdg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<xsl:if test="*[. = '']">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('dellisad||', $rada, 'x:xdg[', $posnr_xdg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/delart 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Kustuta tühjad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
			</td>
		</tr>
		<xsl:apply-templates select="x:xv">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:xdg[', $posnr_xdg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:xs">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:xdg[', $posnr_xdg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:xd">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:xdg[', $posnr_xdg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:xn">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:xdg[', $posnr_xdg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="x:np">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="posnr_np">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:np[', $posnr_np, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:np[', $posnr_np, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-np_120_58_110_112 noedit</xsl:attribute>
					<xsl:attribute name="style">float:left;</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>näidete plokk</xsl:element>
			</td>
			<td/>
			<td width="32px"></td>
		</tr>
		<xsl:if test="not(x:ng)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:ng|', $rada, 'x:np[', $posnr_np, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:ng</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-ng_120_58_110_103 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>näitegrupp</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:ng">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:np[', $posnr_np, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="x:ng">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="posnr_ng">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:ng[', $posnr_ng, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "näitegrupp"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:ng[', $posnr_ng, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:ng[', $posnr_ng, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-ng_120_58_110_103 noedit</xsl:attribute>
					<xsl:attribute name="style">float:left;</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>näitegrupp</xsl:element>
			</td>
			<td>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@x:as">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:ng[', $posnr_ng, ']/@x:as')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('elemendi staatus: x:ng[', $posnr_ng, ']/@x:as')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="class">at at_x-as_120_58_97_115 edit</xsl:attribute>
							<xsl:if test="@x:as = ''">
								<xsl:attribute name="style">width:16px;</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="lang">
								<xsl:call-template name="get_lang"></xsl:call-template>
							</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
							<xsl:value-of select="@x:as"></xsl:value-of>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="img">
							<xsl:attribute name="border">1</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat('addAttr|x:as|', $rada, 'x:ng[', $posnr_ng, ']')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="src">graphics/struprop_16-16.ico</xsl:attribute>
							<xsl:attribute name="alt">■</xsl:attribute>
							<xsl:attribute name="title">Lisa tunnus "elemendi staatus"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td width="32px">
				<xsl:if test="not(x:n)">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('addlisad||', $rada, 'x:ng[', $posnr_ng, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<xsl:if test="*[. = '']">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('dellisad||', $rada, 'x:ng[', $posnr_ng, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/delart 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Kustuta tühjad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
			</td>
		</tr>
		<xsl:apply-templates select="x:n">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:ng[', $posnr_ng, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:qnp)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:qnp|', $rada, 'x:ng[', $posnr_ng, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:qnp</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-qnp_120_58_113_110_112 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>näitetõlgete plokk</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:qnp">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:ng[', $posnr_ng, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="x:qnp">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="posnr_qnp">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:qnp[', $posnr_qnp, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "näitetõlgete plokk"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:qnp[', $posnr_qnp, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:qnp[', $posnr_qnp, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-qnp_120_58_113_110_112 noedit</xsl:attribute>
					<xsl:attribute name="style">float:left;</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>näitetõlgete plokk</xsl:element>
			</td>
			<td>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@x:ntnr">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:qnp[', $posnr_qnp, ']/@x:ntnr')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('näite tähendusnumber: x:qnp[', $posnr_qnp, ']/@x:ntnr')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="class">at at_x-ntnr_120_58_110_116_110_114 edit</xsl:attribute>
							<xsl:if test="@x:ntnr = ''">
								<xsl:attribute name="style">width:16px;</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="lang">
								<xsl:call-template name="get_lang"></xsl:call-template>
							</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
							<xsl:value-of select="@x:ntnr"></xsl:value-of>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="img">
							<xsl:attribute name="border">1</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat('addAttr|x:ntnr|', $rada, 'x:qnp[', $posnr_qnp, ']')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="src">graphics/struprop_16-16.ico</xsl:attribute>
							<xsl:attribute name="alt">■</xsl:attribute>
							<xsl:attribute name="title">Lisa tunnus "näite tähendusnumber"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td width="32px"></td>
		</tr>
		<xsl:if test="not(x:ndg)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:ndg|', $rada, 'x:qnp[', $posnr_qnp, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:ndg</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-ndg_120_58_110_100_103 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>näite definitsioonigrupp</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:ndg">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:qnp[', $posnr_qnp, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:qng)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:qng|', $rada, 'x:qnp[', $posnr_qnp, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:qng</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-qng_120_58_113_110_103 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>näitetõlke grupp</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:qng">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:qnp[', $posnr_qnp, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="x:ndg">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="posnr_ndg">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:ndg[', $posnr_ndg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "näite definitsioonigrupp"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:ndg[', $posnr_ndg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:ndg[', $posnr_ndg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-ndg_120_58_110_100_103 noedit</xsl:attribute>
					<xsl:attribute name="style">float:left;</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>näite definitsioonigrupp</xsl:element>
			</td>
			<td/>
			<td width="32px">
				<xsl:if test="not(x:v and x:s and x:nd)">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('addlisad||', $rada, 'x:ndg[', $posnr_ndg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<xsl:if test="*[. = '']">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('dellisad||', $rada, 'x:ndg[', $posnr_ndg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/delart 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Kustuta tühjad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
			</td>
		</tr>
		<xsl:apply-templates select="x:v">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:ndg[', $posnr_ndg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:s">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:ndg[', $posnr_ndg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:nd">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:ndg[', $posnr_ndg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="x:qng">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="posnr_qng">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:qng[', $posnr_qng, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "näitetõlke grupp"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:qng[', $posnr_qng, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:qng[', $posnr_qng, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-qng_120_58_113_110_103 noedit</xsl:attribute>
					<xsl:attribute name="style">float:left;</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>näitetõlke grupp</xsl:element>
			</td>
			<td>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@xml:lang">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:qng[', $posnr_qng, ']/@xml:lang')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('xml:lang: x:qng[', $posnr_qng, ']/@xml:lang')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="class">at at_xml-lang_120_109_108_58_108_97_110_103 noedit</xsl:attribute>
							<xsl:if test="@xml:lang = ''">
								<xsl:attribute name="style">width:16px;</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="lang">
								<xsl:call-template name="get_lang"></xsl:call-template>
							</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
							<xsl:value-of select="@xml:lang"></xsl:value-of>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="img">
							<xsl:attribute name="border">1</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat('addAttr|xml:lang|', $rada, 'x:qng[', $posnr_qng, ']')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="src">graphics/struprop_16-16.ico</xsl:attribute>
							<xsl:attribute name="alt">■</xsl:attribute>
							<xsl:attribute name="title">Lisa tunnus "xml:lang"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td width="32px">
				<xsl:if test="not(x:xtx and x:qn and x:xv and x:xs)">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('addlisad||', $rada, 'x:qng[', $posnr_qng, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<xsl:if test="*[. = '']">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('dellisad||', $rada, 'x:qng[', $posnr_qng, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/delart 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Kustuta tühjad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
			</td>
		</tr>
		<xsl:apply-templates select="x:xtx">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:qng[', $posnr_qng, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:qn">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:qng[', $posnr_qng, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:xv)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:xv|', $rada, 'x:qng[', $posnr_qng, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:xv</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-xv_120_58_120_118 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>vald</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:xv">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:qng[', $posnr_qng, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:xs)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:xs|', $rada, 'x:qng[', $posnr_qng, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:xs</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-xs_120_58_120_115 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>stiil</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:xs">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:qng[', $posnr_qng, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="x:LS">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="posnr_LS">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:LS[', $posnr_LS, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "liitsõnade plokk"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:LS[', $posnr_LS, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:LS[', $posnr_LS, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-LS_120_58_76_83 noedit</xsl:attribute>
					<xsl:attribute name="style">float:left;</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>liitsõnade plokk</xsl:element>
			</td>
			<td>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@x:lso">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:LS[', $posnr_LS, ']/@x:lso')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('liitsõnaosa: x:LS[', $posnr_LS, ']/@x:lso')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="class">at at_x-lso_120_58_108_115_111 edit</xsl:attribute>
							<xsl:if test="@x:lso = ''">
								<xsl:attribute name="style">width:16px;</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="lang">
								<xsl:call-template name="get_lang"></xsl:call-template>
							</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
							<xsl:value-of select="@x:lso"></xsl:value-of>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="img">
							<xsl:attribute name="border">1</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat('addAttr|x:lso|', $rada, 'x:LS[', $posnr_LS, ']')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="src">graphics/struprop_16-16.ico</xsl:attribute>
							<xsl:attribute name="alt">■</xsl:attribute>
							<xsl:attribute name="title">Lisa tunnus "liitsõnaosa"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@x:as">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:LS[', $posnr_LS, ']/@x:as')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('elemendi staatus: x:LS[', $posnr_LS, ']/@x:as')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="class">at at_x-as_120_58_97_115 edit</xsl:attribute>
							<xsl:if test="@x:as = ''">
								<xsl:attribute name="style">width:16px;</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="lang">
								<xsl:call-template name="get_lang"></xsl:call-template>
							</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
							<xsl:value-of select="@x:as"></xsl:value-of>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="img">
							<xsl:attribute name="border">1</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat('addAttr|x:as|', $rada, 'x:LS[', $posnr_LS, ']')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="src">graphics/struprop_16-16.ico</xsl:attribute>
							<xsl:attribute name="alt">■</xsl:attribute>
							<xsl:attribute name="title">Lisa tunnus "elemendi staatus"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td width="32px">
				<xsl:if test="not(x:tvt)">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('addlisad||', $rada, 'x:LS[', $posnr_LS, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<xsl:if test="*[. = '']">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('dellisad||', $rada, 'x:LS[', $posnr_LS, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/delart 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Kustuta tühjad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
			</td>
		</tr>
		<xsl:if test="not(x:lsdg)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:lsdg|', $rada, 'x:LS[', $posnr_LS, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:lsdg</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-lsdg_120_58_108_115_100_103 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>ls. definitsioonigrupp</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:lsdg">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:LS[', $posnr_LS, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:np)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:np|', $rada, 'x:LS[', $posnr_LS, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:np</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-np_120_58_110_112 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>näidete plokk</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:np">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:LS[', $posnr_LS, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:tvt)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:tvt|', $rada, 'x:LS[', $posnr_LS, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:tvt</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-tvt_120_58_116_118_116 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>tähendusviide</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:tvt">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:LS[', $posnr_LS, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="x:lsdg">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="posnr_lsdg">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:lsdg[', $posnr_lsdg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:lsdg[', $posnr_lsdg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-lsdg_120_58_108_115_100_103 noedit</xsl:attribute>
					<xsl:attribute name="style">float:left;</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>ls. definitsioonigrupp</xsl:element>
			</td>
			<td/>
			<td width="32px">
				<xsl:if test="not(x:v and x:s and x:lsd)">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('addlisad||', $rada, 'x:lsdg[', $posnr_lsdg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<xsl:if test="*[. = '']">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('dellisad||', $rada, 'x:lsdg[', $posnr_lsdg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/delart 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Kustuta tühjad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
			</td>
		</tr>
		<xsl:apply-templates select="x:v">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:lsdg[', $posnr_lsdg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:s">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:lsdg[', $posnr_lsdg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:lsd">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:lsdg[', $posnr_lsdg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="x:KOM">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="posnr_KOM">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td colspan="2" width="35%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:KOM[', $posnr_KOM, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:KOM[', $posnr_KOM, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-KOM_120_58_75_79_77 noedit</xsl:attribute>
					<xsl:attribute name="style">float:left;</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>kommentaarid</xsl:element>
			</td>
			<td/>
			<td width="32px"></td>
		</tr>
		<xsl:if test="not(x:komg)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:komg|', $rada, 'x:KOM[', $posnr_KOM, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:komg</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-komg_120_58_107_111_109_103 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>kommentaari grupp</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:komg">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:KOM[', $posnr_KOM, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="x:komg">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="posnr_komg">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:komg[', $posnr_komg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "kommentaari grupp"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:komg[', $posnr_komg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:komg[', $posnr_komg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-komg_120_58_107_111_109_103 noedit</xsl:attribute>
					<xsl:attribute name="style">float:left;</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>kommentaari grupp</xsl:element>
			</td>
			<td/>
			<td width="32px">
				<xsl:if test="not(x:kom and x:kaut and x:kaeg)">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('addlisad||', $rada, 'x:komg[', $posnr_komg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<xsl:if test="*[. = '']">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('dellisad||', $rada, 'x:komg[', $posnr_komg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/delart 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Kustuta tühjad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
			</td>
		</tr>
		<xsl:apply-templates select="x:kom">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:komg[', $posnr_komg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:kaut">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:komg[', $posnr_komg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:kaeg">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:komg[', $posnr_komg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="x:m">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_m">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:m[', $posnr_m, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:m[', $posnr_m, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-m_120_58_109 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>märksõna</xsl:element>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@x:i">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:m[', $posnr_m, ']/@x:i')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('hom-number: x:m[', $posnr_m, ']/@x:i')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="class">at at_x-i_120_58_105 edit</xsl:attribute>
							<xsl:if test="@x:i = ''">
								<xsl:attribute name="style">width:16px;</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="lang">
								<xsl:call-template name="get_lang"></xsl:call-template>
							</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
							<xsl:value-of select="@x:i"></xsl:value-of>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="img">
							<xsl:attribute name="border">1</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat('addAttr|x:i|', $rada, 'x:m[', $posnr_m, ']')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="src">graphics/struprop_16-16.ico</xsl:attribute>
							<xsl:attribute name="alt">■</xsl:attribute>
							<xsl:attribute name="title">Lisa tunnus "hom-number"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@x:liik">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:m[', $posnr_m, ']/@x:liik')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('märksõna liik: x:m[', $posnr_m, ']/@x:liik')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="class">at at_x-liik_120_58_108_105_105_107 edit</xsl:attribute>
							<xsl:if test="@x:liik = ''">
								<xsl:attribute name="style">width:16px;</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="lang">
								<xsl:call-template name="get_lang"></xsl:call-template>
							</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
							<xsl:value-of select="@x:liik"></xsl:value-of>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="img">
							<xsl:attribute name="border">1</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat('addAttr|x:liik|', $rada, 'x:m[', $posnr_m, ']')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="src">graphics/struprop_16-16.ico</xsl:attribute>
							<xsl:attribute name="alt">■</xsl:attribute>
							<xsl:attribute name="title">Lisa tunnus "märksõna liik"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@x:ps">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:m[', $posnr_m, ']/@x:ps')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('põhisõna: x:m[', $posnr_m, ']/@x:ps')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="class">at at_x-ps_120_58_112_115 edit</xsl:attribute>
							<xsl:if test="@x:ps = ''">
								<xsl:attribute name="style">width:16px;</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="lang">
								<xsl:call-template name="get_lang"></xsl:call-template>
							</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
							<xsl:value-of select="@x:ps"></xsl:value-of>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="img">
							<xsl:attribute name="border">1</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat('addAttr|x:ps|', $rada, 'x:m[', $posnr_m, ']')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="src">graphics/struprop_16-16.ico</xsl:attribute>
							<xsl:attribute name="alt">■</xsl:attribute>
							<xsl:attribute name="title">Lisa tunnus "põhisõna"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@x:u">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:m[', $posnr_m, ']/@x:u')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('uus märksõna: x:m[', $posnr_m, ']/@x:u')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="class">at at_x-u_120_58_117 edit</xsl:attribute>
							<xsl:if test="@x:u = ''">
								<xsl:attribute name="style">width:16px;</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="lang">
								<xsl:call-template name="get_lang"></xsl:call-template>
							</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
							<xsl:value-of select="@x:u"></xsl:value-of>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="img">
							<xsl:attribute name="border">1</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat('addAttr|x:u|', $rada, 'x:m[', $posnr_m, ']')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="src">graphics/struprop_16-16.ico</xsl:attribute>
							<xsl:attribute name="alt">■</xsl:attribute>
							<xsl:attribute name="title">Lisa tunnus "uus märksõna"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:apply-templates select="node()" mode="el_in_mixed">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($rada, 'x:m[', $posnr_m, ']/')"></xsl:value-of>
					</xsl:with-param>
					<xsl:with-param name="vanem_kirjeldav">märksõna</xsl:with-param>
					<xsl:with-param name="vanem_muudetav">edit</xsl:with-param>
					<xsl:with-param name="vanem_unname">x-m_120_58_109</xsl:with-param>
					<xsl:with-param name="alates">true</xsl:with-param>
				</xsl:apply-templates>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:r">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_r">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:r[', $posnr_r, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "rektsioon"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:r[', $posnr_r, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:r[', $posnr_r, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-r_120_58_114 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>rektsioon</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:r[', $posnr_r, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:r[', $posnr_r, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-r_120_58_114 edit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:mf">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_mf">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:mf[', $posnr_mf, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:mf[', $posnr_mf, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-mf_120_58_109_102 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>morfonoloogiline vorm</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:mf[', $posnr_mf, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:mf[', $posnr_mf, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-mf_120_58_109_102 edit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:hld">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_hld">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:hld[', $posnr_hld, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "hääldus"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:hld[', $posnr_hld, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:hld[', $posnr_hld, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-hld_120_58_104_108_100 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>hääldus</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:hld[', $posnr_hld, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:hld[', $posnr_hld, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-hld_120_58_104_108_100 edit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:vk">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_vk">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:vk[', $posnr_vk, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:vk[', $posnr_vk, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-vk_120_58_118_107 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>vormikood</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:vk[', $posnr_vk, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:vk[', $posnr_vk, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-vk_120_58_118_107 edit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:mkl">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_mkl">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:mkl[', $posnr_mkl, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:mkl[', $posnr_mkl, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-mkl_120_58_109_107_108 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>morf.kirje lühikujul</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:mkl[', $posnr_mkl, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:mkl[', $posnr_mkl, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-mkl_120_58_109_107_108 edit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:mk">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_mk">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:mk[', $posnr_mk, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:mk[', $posnr_mk, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-mk_120_58_109_107 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>morf.kirje</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:mk[', $posnr_mk, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:mk[', $posnr_mk, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-mk_120_58_109_107 edit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:mv">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_mv">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:mv[', $posnr_mv, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "muutevormid"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:mv[', $posnr_mv, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:mv[', $posnr_mv, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-mv_120_58_109_118 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>muutevormid</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:mv[', $posnr_mv, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:mv[', $posnr_mv, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-mv_120_58_109_118 edit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:mt">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_mt">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:mt[', $posnr_mt, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "muuttüüp"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:mt[', $posnr_mt, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:mt[', $posnr_mt, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-mt_120_58_109_116 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>muuttüüp</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:mt[', $posnr_mt, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:mt[', $posnr_mt, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-mt_120_58_109_116 edit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:sl">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_sl">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:sl[', $posnr_sl, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "sõnaliik"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:sl[', $posnr_sl, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:sl[', $posnr_sl, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-sl_120_58_115_108 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>sõnaliik</xsl:element>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@x:rk">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:sl[', $posnr_sl, ']/@x:rk')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('rektsioonikood: x:sl[', $posnr_sl, ']/@x:rk')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="class">at at_x-rk_120_58_114_107 edit</xsl:attribute>
							<xsl:if test="@x:rk = ''">
								<xsl:attribute name="style">width:16px;</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="lang">
								<xsl:call-template name="get_lang"></xsl:call-template>
							</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
							<xsl:value-of select="@x:rk"></xsl:value-of>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="img">
							<xsl:attribute name="border">1</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat('addAttr|x:rk|', $rada, 'x:sl[', $posnr_sl, ']')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="src">graphics/struprop_16-16.ico</xsl:attribute>
							<xsl:attribute name="alt">■</xsl:attribute>
							<xsl:attribute name="title">Lisa tunnus "rektsioonikood"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:sl[', $posnr_sl, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:sl[', $posnr_sl, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-sl_120_58_115_108 edit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:gki">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_gki">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:gki[', $posnr_gki, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "gr.kasutusinfo"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:gki[', $posnr_gki, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:gki[', $posnr_gki, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-gki_120_58_103_107_105 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>gr.kasutusinfo</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:gki[', $posnr_gki, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:gki[', $posnr_gki, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-gki_120_58_103_107_105 edit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:v">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_v">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:v[', $posnr_v, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "vald"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:v[', $posnr_v, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:v[', $posnr_v, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-v_120_58_118 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>vald</xsl:element>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@x:l">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:v[', $posnr_v, ']/@x:l')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('kasutuslisand: x:v[', $posnr_v, ']/@x:l')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="class">at at_x-l_120_58_108 edit</xsl:attribute>
							<xsl:if test="@x:l = ''">
								<xsl:attribute name="style">width:16px;</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="lang">
								<xsl:call-template name="get_lang"></xsl:call-template>
							</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
							<xsl:value-of select="@x:l"></xsl:value-of>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="img">
							<xsl:attribute name="border">1</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat('addAttr|x:l|', $rada, 'x:v[', $posnr_v, ']')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="src">graphics/struprop_16-16.ico</xsl:attribute>
							<xsl:attribute name="alt">■</xsl:attribute>
							<xsl:attribute name="title">Lisa tunnus "kasutuslisand"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:v[', $posnr_v, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:v[', $posnr_v, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-v_120_58_118 edit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:s">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_s">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:s[', $posnr_s, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "stiil"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:s[', $posnr_s, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:s[', $posnr_s, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-s_120_58_115 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>stiil</xsl:element>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@x:l">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:s[', $posnr_s, ']/@x:l')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('kasutuslisand: x:s[', $posnr_s, ']/@x:l')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="class">at at_x-l_120_58_108 edit</xsl:attribute>
							<xsl:if test="@x:l = ''">
								<xsl:attribute name="style">width:16px;</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="lang">
								<xsl:call-template name="get_lang"></xsl:call-template>
							</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
							<xsl:value-of select="@x:l"></xsl:value-of>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="img">
							<xsl:attribute name="border">1</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat('addAttr|x:l|', $rada, 'x:s[', $posnr_s, ']')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="src">graphics/struprop_16-16.ico</xsl:attribute>
							<xsl:attribute name="alt">■</xsl:attribute>
							<xsl:attribute name="title">Lisa tunnus "kasutuslisand"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:s[', $posnr_s, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:s[', $posnr_s, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-s_120_58_115 edit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:a">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_a">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:a[', $posnr_a, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "alternatiiv"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:a[', $posnr_a, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:a[', $posnr_a, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-a_120_58_97 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>alternatiiv</xsl:element>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@x:i">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:a[', $posnr_a, ']/@x:i')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('hom-number: x:a[', $posnr_a, ']/@x:i')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="class">at at_x-i_120_58_105 edit</xsl:attribute>
							<xsl:if test="@x:i = ''">
								<xsl:attribute name="style">width:16px;</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="lang">
								<xsl:call-template name="get_lang"></xsl:call-template>
							</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
							<xsl:value-of select="@x:i"></xsl:value-of>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="img">
							<xsl:attribute name="border">1</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat('addAttr|x:i|', $rada, 'x:a[', $posnr_a, ']')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="src">graphics/struprop_16-16.ico</xsl:attribute>
							<xsl:attribute name="alt">■</xsl:attribute>
							<xsl:attribute name="title">Lisa tunnus "hom-number"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:a[', $posnr_a, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:a[', $posnr_a, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-a_120_58_97 edit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:mvt">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_mvt">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:mvt[', $posnr_mvt, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "märksõnaviide"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:mvt[', $posnr_mvt, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:mvt[', $posnr_mvt, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-mvt_120_58_109_118_116 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>märksõnaviide</xsl:element>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@x:i">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:mvt[', $posnr_mvt, ']/@x:i')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('hom-number: x:mvt[', $posnr_mvt, ']/@x:i')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="class">at at_x-i_120_58_105 edit</xsl:attribute>
							<xsl:if test="@x:i = ''">
								<xsl:attribute name="style">width:16px;</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="lang">
								<xsl:call-template name="get_lang"></xsl:call-template>
							</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
							<xsl:value-of select="@x:i"></xsl:value-of>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="img">
							<xsl:attribute name="border">1</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat('addAttr|x:i|', $rada, 'x:mvt[', $posnr_mvt, ']')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="src">graphics/struprop_16-16.ico</xsl:attribute>
							<xsl:attribute name="alt">■</xsl:attribute>
							<xsl:attribute name="title">Lisa tunnus "hom-number"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@x:t">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:mvt[', $posnr_mvt, ']/@x:t')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('täh-number: x:mvt[', $posnr_mvt, ']/@x:t')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="class">at at_x-t_120_58_116 edit</xsl:attribute>
							<xsl:if test="@x:t = ''">
								<xsl:attribute name="style">width:16px;</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="lang">
								<xsl:call-template name="get_lang"></xsl:call-template>
							</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
							<xsl:value-of select="@x:t"></xsl:value-of>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="img">
							<xsl:attribute name="border">1</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat('addAttr|x:t|', $rada, 'x:mvt[', $posnr_mvt, ']')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="src">graphics/struprop_16-16.ico</xsl:attribute>
							<xsl:attribute name="alt">■</xsl:attribute>
							<xsl:attribute name="title">Lisa tunnus "täh-number"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@x:mvtl">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:mvt[', $posnr_mvt, ']/@x:mvtl')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('m.viite liik: x:mvt[', $posnr_mvt, ']/@x:mvtl')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="class">at at_x-mvtl_120_58_109_118_116_108 edit</xsl:attribute>
							<xsl:if test="@x:mvtl = ''">
								<xsl:attribute name="style">width:16px;</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="lang">
								<xsl:call-template name="get_lang"></xsl:call-template>
							</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
							<xsl:value-of select="@x:mvtl"></xsl:value-of>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="img">
							<xsl:attribute name="border">1</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat('addAttr|x:mvtl|', $rada, 'x:mvt[', $posnr_mvt, ']')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="src">graphics/struprop_16-16.ico</xsl:attribute>
							<xsl:attribute name="alt">■</xsl:attribute>
							<xsl:attribute name="title">Lisa tunnus "m.viite liik"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:mvt[', $posnr_mvt, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:mvt[', $posnr_mvt, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-mvt_120_58_109_118_116 edit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:mm">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_mm">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:mm[', $posnr_mm, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:mm[', $posnr_mm, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-mm_120_58_109_109 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>allmärksõna</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:mm[', $posnr_mm, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:mm[', $posnr_mm, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-mm_120_58_109_109 edit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:dt">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_dt">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:dt[', $posnr_dt, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:dt[', $posnr_dt, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-dt_120_58_100_116 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>tulenemisseletus</xsl:element>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@x:i">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:dt[', $posnr_dt, ']/@x:i')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('hom-number: x:dt[', $posnr_dt, ']/@x:i')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="class">at at_x-i_120_58_105 edit</xsl:attribute>
							<xsl:if test="@x:i = ''">
								<xsl:attribute name="style">width:16px;</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="lang">
								<xsl:call-template name="get_lang"></xsl:call-template>
							</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
							<xsl:value-of select="@x:i"></xsl:value-of>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="img">
							<xsl:attribute name="border">1</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat('addAttr|x:i|', $rada, 'x:dt[', $posnr_dt, ']')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="src">graphics/struprop_16-16.ico</xsl:attribute>
							<xsl:attribute name="alt">■</xsl:attribute>
							<xsl:attribute name="title">Lisa tunnus "hom-number"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@x:t">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:dt[', $posnr_dt, ']/@x:t')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('täh-number: x:dt[', $posnr_dt, ']/@x:t')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="class">at at_x-t_120_58_116 edit</xsl:attribute>
							<xsl:if test="@x:t = ''">
								<xsl:attribute name="style">width:16px;</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="lang">
								<xsl:call-template name="get_lang"></xsl:call-template>
							</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
							<xsl:value-of select="@x:t"></xsl:value-of>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="img">
							<xsl:attribute name="border">1</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat('addAttr|x:t|', $rada, 'x:dt[', $posnr_dt, ']')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="src">graphics/struprop_16-16.ico</xsl:attribute>
							<xsl:attribute name="alt">■</xsl:attribute>
							<xsl:attribute name="title">Lisa tunnus "täh-number"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:dt[', $posnr_dt, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:dt[', $posnr_dt, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-dt_120_58_100_116 edit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:d">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_d">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:d[', $posnr_d, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "seletus"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:d[', $posnr_d, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:d[', $posnr_d, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-d_120_58_100 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>seletus</xsl:element>
			</td>
			<td>
				<xsl:apply-templates select="node()" mode="el_in_mixed">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($rada, 'x:d[', $posnr_d, ']/')"></xsl:value-of>
					</xsl:with-param>
					<xsl:with-param name="vanem_kirjeldav">seletus</xsl:with-param>
					<xsl:with-param name="vanem_muudetav">edit</xsl:with-param>
					<xsl:with-param name="vanem_unname">x-d_120_58_100</xsl:with-param>
					<xsl:with-param name="alates">true</xsl:with-param>
				</xsl:apply-templates>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:ld">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_ld">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:ld[', $posnr_ld, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "ladina termin"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:ld[', $posnr_ld, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:ld[', $posnr_ld, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-ld_120_58_108_100 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>ladina termin</xsl:element>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@xml:lang">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:ld[', $posnr_ld, ']/@xml:lang')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('xml:lang: x:ld[', $posnr_ld, ']/@xml:lang')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="class">at at_xml-lang_120_109_108_58_108_97_110_103 noedit</xsl:attribute>
							<xsl:if test="@xml:lang = ''">
								<xsl:attribute name="style">width:16px;</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="lang">
								<xsl:call-template name="get_lang"></xsl:call-template>
							</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
							<xsl:value-of select="@xml:lang"></xsl:value-of>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="img">
							<xsl:attribute name="border">1</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat('addAttr|xml:lang|', $rada, 'x:ld[', $posnr_ld, ']')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="src">graphics/struprop_16-16.ico</xsl:attribute>
							<xsl:attribute name="alt">■</xsl:attribute>
							<xsl:attribute name="title">Lisa tunnus "xml:lang"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:ld[', $posnr_ld, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:ld[', $posnr_ld, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-ld_120_58_108_100 edit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:xtx">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_xtx">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:xtx[', $posnr_xtx, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:xtx[', $posnr_xtx, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-xtx_120_58_120_116_120 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>täpsustus</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:xtx[', $posnr_xtx, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:xtx[', $posnr_xtx, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-xtx_120_58_120_116_120 edit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:x">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_x">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:x[', $posnr_x, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:x[', $posnr_x, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-x_120_58_120 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>vaste</xsl:element>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@x:xliik">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:x[', $posnr_x, ']/@x:xliik')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('vaste liik: x:x[', $posnr_x, ']/@x:xliik')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="class">at at_x-xliik_120_58_120_108_105_105_107 edit</xsl:attribute>
							<xsl:if test="@x:xliik = ''">
								<xsl:attribute name="style">width:16px;</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="lang">
								<xsl:call-template name="get_lang"></xsl:call-template>
							</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
							<xsl:value-of select="@x:xliik"></xsl:value-of>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="img">
							<xsl:attribute name="border">1</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat('addAttr|x:xliik|', $rada, 'x:x[', $posnr_x, ']')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="src">graphics/struprop_16-16.ico</xsl:attribute>
							<xsl:attribute name="alt">■</xsl:attribute>
							<xsl:attribute name="title">Lisa tunnus "vaste liik"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@x:xall">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:x[', $posnr_x, ']/@x:xall')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('vaste päritolu: x:x[', $posnr_x, ']/@x:xall')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="class">at at_x-xall_120_58_120_97_108_108 edit</xsl:attribute>
							<xsl:if test="@x:xall = ''">
								<xsl:attribute name="style">width:16px;</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="lang">
								<xsl:call-template name="get_lang"></xsl:call-template>
							</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
							<xsl:value-of select="@x:xall"></xsl:value-of>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="img">
							<xsl:attribute name="border">1</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat('addAttr|x:xall|', $rada, 'x:x[', $posnr_x, ']')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="src">graphics/struprop_16-16.ico</xsl:attribute>
							<xsl:attribute name="alt">■</xsl:attribute>
							<xsl:attribute name="title">Lisa tunnus "vaste päritolu"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:apply-templates select="node()" mode="el_in_mixed">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($rada, 'x:x[', $posnr_x, ']/')"></xsl:value-of>
					</xsl:with-param>
					<xsl:with-param name="vanem_kirjeldav">vaste</xsl:with-param>
					<xsl:with-param name="vanem_muudetav">edit</xsl:with-param>
					<xsl:with-param name="vanem_unname">x-x_120_58_120</xsl:with-param>
					<xsl:with-param name="alates">true</xsl:with-param>
				</xsl:apply-templates>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:xr">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_xr">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:xr[', $posnr_xr, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "rektsioon"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:xr[', $posnr_xr, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:xr[', $posnr_xr, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-xr_120_58_120_114 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>rektsioon</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:xr[', $posnr_xr, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:xr[', $posnr_xr, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-xr_120_58_120_114 edit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:xvk">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_xvk">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:xvk[', $posnr_xvk, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:xvk[', $posnr_xvk, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-xvk_120_58_120_118_107 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>vormikood</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:xvk[', $posnr_xvk, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:xvk[', $posnr_xvk, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-xvk_120_58_120_118_107 edit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:xmv">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_xmv">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:xmv[', $posnr_xmv, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "muutevormid"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:xmv[', $posnr_xmv, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:xmv[', $posnr_xmv, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-xmv_120_58_120_109_118 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>muutevormid</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:xmv[', $posnr_xmv, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:xmv[', $posnr_xmv, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-xmv_120_58_120_109_118 edit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:xa">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_xa">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:xa[', $posnr_xa, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:xa[', $posnr_xa, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-xa_120_58_120_97 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>gr.variant</xsl:element>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@x:xgk">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:xa[', $posnr_xa, ']/@x:xgk')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('gr.kood: x:xa[', $posnr_xa, ']/@x:xgk')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="class">at at_x-xgk_120_58_120_103_107 edit</xsl:attribute>
							<xsl:if test="@x:xgk = ''">
								<xsl:attribute name="style">width:16px;</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="lang">
								<xsl:call-template name="get_lang"></xsl:call-template>
							</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
							<xsl:value-of select="@x:xgk"></xsl:value-of>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="img">
							<xsl:attribute name="border">1</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat('addAttr|x:xgk|', $rada, 'x:xa[', $posnr_xa, ']')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="src">graphics/struprop_16-16.ico</xsl:attribute>
							<xsl:attribute name="alt">■</xsl:attribute>
							<xsl:attribute name="title">Lisa tunnus "gr.kood"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:xa[', $posnr_xa, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:xa[', $posnr_xa, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-xa_120_58_120_97 edit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:xmt">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_xmt">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:xmt[', $posnr_xmt, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "vaste muuttüüp"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:xmt[', $posnr_xmt, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:xmt[', $posnr_xmt, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-xmt_120_58_120_109_116 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>vaste muuttüüp</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:xmt[', $posnr_xmt, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:xmt[', $posnr_xmt, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-xmt_120_58_120_109_116 edit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:xsl">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_xsl">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:xsl[', $posnr_xsl, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "sõnaliik"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:xsl[', $posnr_xsl, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:xsl[', $posnr_xsl, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-xsl_120_58_120_115_108 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>sõnaliik</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:xsl[', $posnr_xsl, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:xsl[', $posnr_xsl, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-xsl_120_58_120_115_108 edit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:xz">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_xz">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:xz[', $posnr_xz, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "gr.sugu"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:xz[', $posnr_xz, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:xz[', $posnr_xz, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-xz_120_58_120_122 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>gr.sugu</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:xz[', $posnr_xz, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:xz[', $posnr_xz, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-xz_120_58_120_122 edit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:xgki">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_xgki">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:xgki[', $posnr_xgki, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "gr.kasutusinfo"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:xgki[', $posnr_xgki, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:xgki[', $posnr_xgki, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-xgki_120_58_120_103_107_105 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>gr.kasutusinfo</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:xgki[', $posnr_xgki, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:xgki[', $posnr_xgki, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-xgki_120_58_120_103_107_105 edit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:xv">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_xv">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:xv[', $posnr_xv, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "vald"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:xv[', $posnr_xv, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:xv[', $posnr_xv, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-xv_120_58_120_118 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>vald</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:xv[', $posnr_xv, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:xv[', $posnr_xv, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-xv_120_58_120_118 edit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:xs">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_xs">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:xs[', $posnr_xs, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "stiil"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:xs[', $posnr_xs, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:xs[', $posnr_xs, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-xs_120_58_120_115 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>stiil</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:xs[', $posnr_xs, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:xs[', $posnr_xs, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-xs_120_58_120_115 edit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:xd">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_xd">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:xd[', $posnr_xd, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:xd[', $posnr_xd, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-xd_120_58_120_100 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>vaste seletus</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:xd[', $posnr_xd, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:xd[', $posnr_xd, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-xd_120_58_120_100 edit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:xn">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_xn">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:xn[', $posnr_xn, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:xn[', $posnr_xn, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-xn_120_58_120_110 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>vaste kasutusnäide</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:xn[', $posnr_xn, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:xn[', $posnr_xn, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-xn_120_58_120_110 edit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:n">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_n">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:n[', $posnr_n, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "näide"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:n[', $posnr_n, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:n[', $posnr_n, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-n_120_58_110 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>näide</xsl:element>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@x:nrl">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:n[', $posnr_n, ']/@x:nrl')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('väljendi roll: x:n[', $posnr_n, ']/@x:nrl')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="class">at at_x-nrl_120_58_110_114_108 edit</xsl:attribute>
							<xsl:if test="@x:nrl = ''">
								<xsl:attribute name="style">width:16px;</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="lang">
								<xsl:call-template name="get_lang"></xsl:call-template>
							</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
							<xsl:value-of select="@x:nrl"></xsl:value-of>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="img">
							<xsl:attribute name="border">1</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat('addAttr|x:nrl|', $rada, 'x:n[', $posnr_n, ']')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="src">graphics/struprop_16-16.ico</xsl:attribute>
							<xsl:attribute name="alt">■</xsl:attribute>
							<xsl:attribute name="title">Lisa tunnus "väljendi roll"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:apply-templates select="node()" mode="el_in_mixed">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($rada, 'x:n[', $posnr_n, ']/')"></xsl:value-of>
					</xsl:with-param>
					<xsl:with-param name="vanem_kirjeldav">näide</xsl:with-param>
					<xsl:with-param name="vanem_muudetav">edit</xsl:with-param>
					<xsl:with-param name="vanem_unname">x-n_120_58_110</xsl:with-param>
					<xsl:with-param name="alates">true</xsl:with-param>
				</xsl:apply-templates>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:nd">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_nd">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:nd[', $posnr_nd, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "näite seletus"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:nd[', $posnr_nd, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:nd[', $posnr_nd, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-nd_120_58_110_100 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>näite seletus</xsl:element>
			</td>
			<td>
				<xsl:apply-templates select="node()" mode="el_in_mixed">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($rada, 'x:nd[', $posnr_nd, ']/')"></xsl:value-of>
					</xsl:with-param>
					<xsl:with-param name="vanem_kirjeldav">näite seletus</xsl:with-param>
					<xsl:with-param name="vanem_muudetav">edit</xsl:with-param>
					<xsl:with-param name="vanem_unname">x-nd_120_58_110_100</xsl:with-param>
					<xsl:with-param name="alates">true</xsl:with-param>
				</xsl:apply-templates>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:qn">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_qn">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:qn[', $posnr_qn, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:qn[', $posnr_qn, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-qn_120_58_113_110 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>näitetõlge</xsl:element>
			</td>
			<td>
				<xsl:apply-templates select="node()" mode="el_in_mixed">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($rada, 'x:qn[', $posnr_qn, ']/')"></xsl:value-of>
					</xsl:with-param>
					<xsl:with-param name="vanem_kirjeldav">näitetõlge</xsl:with-param>
					<xsl:with-param name="vanem_muudetav">edit</xsl:with-param>
					<xsl:with-param name="vanem_unname">x-qn_120_58_113_110</xsl:with-param>
					<xsl:with-param name="alates">true</xsl:with-param>
				</xsl:apply-templates>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:tvt">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_tvt">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:tvt[', $posnr_tvt, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "tähendusviide"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:tvt[', $posnr_tvt, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:tvt[', $posnr_tvt, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-tvt_120_58_116_118_116 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>tähendusviide</xsl:element>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@x:i">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:tvt[', $posnr_tvt, ']/@x:i')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('hom-number: x:tvt[', $posnr_tvt, ']/@x:i')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="class">at at_x-i_120_58_105 edit</xsl:attribute>
							<xsl:if test="@x:i = ''">
								<xsl:attribute name="style">width:16px;</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="lang">
								<xsl:call-template name="get_lang"></xsl:call-template>
							</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
							<xsl:value-of select="@x:i"></xsl:value-of>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="img">
							<xsl:attribute name="border">1</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat('addAttr|x:i|', $rada, 'x:tvt[', $posnr_tvt, ']')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="src">graphics/struprop_16-16.ico</xsl:attribute>
							<xsl:attribute name="alt">■</xsl:attribute>
							<xsl:attribute name="title">Lisa tunnus "hom-number"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@x:t">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:tvt[', $posnr_tvt, ']/@x:t')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('täh-number: x:tvt[', $posnr_tvt, ']/@x:t')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="class">at at_x-t_120_58_116 edit</xsl:attribute>
							<xsl:if test="@x:t = ''">
								<xsl:attribute name="style">width:16px;</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="lang">
								<xsl:call-template name="get_lang"></xsl:call-template>
							</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
							<xsl:value-of select="@x:t"></xsl:value-of>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="img">
							<xsl:attribute name="border">1</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat('addAttr|x:t|', $rada, 'x:tvt[', $posnr_tvt, ']')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="src">graphics/struprop_16-16.ico</xsl:attribute>
							<xsl:attribute name="alt">■</xsl:attribute>
							<xsl:attribute name="title">Lisa tunnus "täh-number"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@x:tvtl">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:tvt[', $posnr_tvt, ']/@x:tvtl')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('t.viite liik: x:tvt[', $posnr_tvt, ']/@x:tvtl')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="class">at at_x-tvtl_120_58_116_118_116_108 edit</xsl:attribute>
							<xsl:if test="@x:tvtl = ''">
								<xsl:attribute name="style">width:16px;</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="lang">
								<xsl:call-template name="get_lang"></xsl:call-template>
							</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
							<xsl:value-of select="@x:tvtl"></xsl:value-of>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="img">
							<xsl:attribute name="border">1</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat('addAttr|x:tvtl|', $rada, 'x:tvt[', $posnr_tvt, ']')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="src">graphics/struprop_16-16.ico</xsl:attribute>
							<xsl:attribute name="alt">■</xsl:attribute>
							<xsl:attribute name="title">Lisa tunnus "t.viite liik"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:tvt[', $posnr_tvt, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:tvt[', $posnr_tvt, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-tvt_120_58_116_118_116 edit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:lsd">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_lsd">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:lsd[', $posnr_lsd, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:lsd[', $posnr_lsd, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-lsd_120_58_108_115_100 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>liitsõnaosa seletus</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:lsd[', $posnr_lsd, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:lsd[', $posnr_lsd, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-lsd_120_58_108_115_100 edit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:data">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_data">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:data[', $posnr_data, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">UUS "algtekst"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:data[', $posnr_data, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:data[', $posnr_data, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-data_120_58_100_97_116_97 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>algtekst</xsl:element>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@x:src">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:data[', $posnr_data, ']/@x:src')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('allikas: x:data[', $posnr_data, ']/@x:src')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="class">at at_x-src_120_58_115_114_99 edit</xsl:attribute>
							<xsl:if test="@x:src = ''">
								<xsl:attribute name="style">width:16px;</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="lang">
								<xsl:call-template name="get_lang"></xsl:call-template>
							</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
							<xsl:value-of select="@x:src"></xsl:value-of>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="img">
							<xsl:attribute name="border">1</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:value-of select="concat('addAttr|x:src|', $rada, 'x:data[', $posnr_data, ']')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="src">graphics/struprop_16-16.ico</xsl:attribute>
							<xsl:attribute name="alt">■</xsl:attribute>
							<xsl:attribute name="title">Lisa tunnus "allikas"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:data[', $posnr_data, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:data[', $posnr_data, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-data_120_58_100_97_116_97 edit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:kom">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_kom">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:kom[', $posnr_kom, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:kom[', $posnr_kom, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-kom_120_58_107_111_109 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>kommentaar</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:kom[', $posnr_kom, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:kom[', $posnr_kom, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-kom_120_58_107_111_109 edit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:kaut">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_kaut">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:kaut[', $posnr_kaut, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:kaut[', $posnr_kaut, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-kaut_120_58_107_97_117_116 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>kommentaari autor</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:kaut[', $posnr_kaut, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:kaut[', $posnr_kaut, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-kaut_120_58_107_97_117_116 noedit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:kaeg">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_kaeg">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:kaeg[', $posnr_kaeg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:kaeg[', $posnr_kaeg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-kaeg_120_58_107_97_101_103 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>kommenteerimisaeg</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:kaeg[', $posnr_kaeg, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:kaeg[', $posnr_kaeg, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-kaeg_120_58_107_97_101_103 noedit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:any">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_any">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:any[', $posnr_any, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:any[', $posnr_any, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-any_120_58_97_110_121 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>artikkel</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:any[', $posnr_any, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:any[', $posnr_any, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-any_120_58_97_110_121 edit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:PT">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_PT">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:PT[', $posnr_PT, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:PT[', $posnr_PT, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-PT_120_58_80_84 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>artikli peatoimetaja</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:PT[', $posnr_PT, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:PT[', $posnr_PT, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-PT_120_58_80_84 edit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:PTA">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="psCount">
			<xsl:value-of select="count(preceding-sibling::*)"></xsl:value-of>
		</xsl:variable>
		<xsl:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">
				<xsl:value-of select="../@pr_sd:desc"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="posnr_PTA">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:PTA[', $posnr_PTA, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:PTA[', $posnr_PTA, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-PTA_120_58_80_84_65 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>peatoimetamise aeg</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:PTA[', $posnr_PTA, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:PTA[', $posnr_PTA, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-PTA_120_58_80_84_65 edit etws</xsl:attribute>
						<xsl:attribute name="lang">
							<xsl:call-template name="get_lang"></xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				</xsl:if>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="comment()">
		<xsl:param name="rada"></xsl:param>
		<xsl:param name="vanem_kirjeldav"/>
		<xsl:param name="vanem_muudetav"/>
		<xsl:param name="vanem_unname"/>
		<xsl:variable name="posnr_comment">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td colspan="4">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'comment()[', $posnr_comment, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat($vanem_kirjeldav, ': ', name(..), '/comment()[', $posnr_comment, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">
						<xsl:value-of select="concat('ct ct_', $vanem_unname, ' edit etws')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="lang">
						<xsl:call-template name="get_lang"></xsl:call-template>
					</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
					<xsl:value-of select="."></xsl:value-of>
				</xsl:element>
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>
