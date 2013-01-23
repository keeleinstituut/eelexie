<?xml version="1.0"?>
<xsl:stylesheet version="1.0" x:mode="auto" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:pr_sd="http://www.eo.ee/dev/xml/names" xmlns:x="http://www.eki.ee/dict/dmo">
	<xsl:output method="html" omit-xml-declaration="yes" indent="no" encoding="utf-8"/>
	<xsl:include href="include/incTemplates.xsl"/>
	<xsl:template match="x:vhom" mode="el_in_mixed">
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
				<xsl:value-of select="concat($rada, 'x:vhom[', $mposnr, ']')"></xsl:value-of>
			</xsl:attribute>
			<xsl:attribute name="title">
				<xsl:value-of select="concat('indicator (homonym number): x:vhom[', $mposnr, ']')"></xsl:value-of>
			</xsl:attribute>
			<xsl:attribute name="class">enmx enmx_x-vhom_120_58_118_104_111_109 noedit</xsl:attribute>
			<xsl:attribute name="tabIndex">0</xsl:attribute>
			<xsl:value-of select="local-name()"></xsl:value-of>
		</xsl:element>
		<xsl:apply-templates select="node()" mode="el_in_mixed">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:vhom[', $mposnr, ']/')"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">indicator (homonym number)</xsl:with-param>
			<xsl:with-param name="vanem_muudetav">edit</xsl:with-param>
			<xsl:with-param name="vanem_unname">x-vhom_120_58_118_104_111_109</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="x:vtxh" mode="el_in_mixed">
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
				<xsl:value-of select="concat($rada, 'x:vtxh[', $mposnr, ']')"></xsl:value-of>
			</xsl:attribute>
			<xsl:attribute name="title">
				<xsl:value-of select="concat('enenen: x:vtxh[', $mposnr, ']')"></xsl:value-of>
			</xsl:attribute>
			<xsl:attribute name="class">enmx enmx_x-vtxh_120_58_118_116_120_104 noedit</xsl:attribute>
			<xsl:attribute name="tabIndex">0</xsl:attribute>
			<xsl:value-of select="local-name()"></xsl:value-of>
		</xsl:element>
		<xsl:apply-templates select="node()" mode="el_in_mixed">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:vtxh[', $mposnr, ']/')"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">enenen</xsl:with-param>
			<xsl:with-param name="vanem_muudetav">edit</xsl:with-param>
			<xsl:with-param name="vanem_unname">x-vtxh_120_58_118_116_120_104</xsl:with-param>
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
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:variable name="mposnr">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<xsl:element name="span">
			<xsl:attribute name="id">
				<xsl:value-of select="concat($rada, 'x:ld[', $mposnr, ']')"></xsl:value-of>
			</xsl:attribute>
			<xsl:attribute name="title">
				<xsl:value-of select="concat('latin definition: x:ld[', $mposnr, ']')"></xsl:value-of>
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
			<xsl:with-param name="vanem_kirjeldav">latin definition</xsl:with-param>
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
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:variable name="mposnr">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<xsl:element name="span">
			<xsl:attribute name="id">
				<xsl:value-of select="concat($rada, 'x:xr[', $mposnr, ']')"></xsl:value-of>
			</xsl:attribute>
			<xsl:attribute name="title">
				<xsl:value-of select="concat('government (question): x:xr[', $mposnr, ']')"></xsl:value-of>
			</xsl:attribute>
			<xsl:attribute name="class">enmx enmx_x-xr_120_58_120_114 noedit</xsl:attribute>
			<xsl:attribute name="tabIndex">0</xsl:attribute>
			<xsl:value-of select="local-name()"></xsl:value-of>
		</xsl:element>
		<xsl:apply-templates select="node()" mode="el_in_mixed">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:xr[', $mposnr, ']/')"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">government (question)</xsl:with-param>
			<xsl:with-param name="vanem_muudetav">edit</xsl:with-param>
			<xsl:with-param name="vanem_unname">x-xr_120_58_120_114</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="x:r" mode="el_in_mixed">
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
				<xsl:value-of select="concat($rada, 'x:r[', $mposnr, ']')"></xsl:value-of>
			</xsl:attribute>
			<xsl:attribute name="title">
				<xsl:value-of select="concat('government (question): x:r[', $mposnr, ']')"></xsl:value-of>
			</xsl:attribute>
			<xsl:attribute name="class">enmx enmx_x-r_120_58_114 noedit</xsl:attribute>
			<xsl:attribute name="tabIndex">0</xsl:attribute>
			<xsl:value-of select="local-name()"></xsl:value-of>
		</xsl:element>
		<xsl:apply-templates select="node()" mode="el_in_mixed">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:r[', $mposnr, ']/')"></xsl:value-of>
			</xsl:with-param>
			<xsl:with-param name="vanem_kirjeldav">government (question)</xsl:with-param>
			<xsl:with-param name="vanem_muudetav">edit</xsl:with-param>
			<xsl:with-param name="vanem_unname">x-r_120_58_114</xsl:with-param>
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
						<xsl:attribute name="title">Create!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:P</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-P_120_58_80 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>head</xsl:element>
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
						<xsl:attribute name="title">Create!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:S</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-S_120_58_83 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>body</xsl:element>
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
						<xsl:attribute name="title">Create!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:KOM</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-KOM_120_58_75_79_77 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>comments</xsl:element>
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
					<xsl:attribute name="tabIndex">0</xsl:attribute>head</xsl:element>
			</td>
			<td/>
			<td width="32px">
				<xsl:if test="not(x:v and x:s and x:a and x:mvt and x:maht and x:all)">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('addlisad||', $rada, 'x:P[', $posnr_P, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Add missing elements!</xsl:attribute>
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
						<xsl:attribute name="title">Delete empty elements!</xsl:attribute>
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
						<xsl:attribute name="title">Create!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:mg</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-mg_120_58_109_103 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>headword_grp</xsl:element>
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
		<xsl:if test="not(x:grg)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:grg|', $rada, 'x:P[', $posnr_P, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Create!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:grg</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-grg_120_58_103_114_103 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>grammatical information_grp</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:grg">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:P[', $posnr_P, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:v">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:P[', $posnr_P, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:s">
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
						<xsl:attribute name="title">Create!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:a</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-a_120_58_97 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>alternative</xsl:element>
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
						<xsl:attribute name="title">Create!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:mvt</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-mvt_120_58_109_118_116 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>headword reference</xsl:element>
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
		<xsl:apply-templates select="x:maht">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:P[', $posnr_P, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:all">
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
			<td width="2%"/>
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
					<xsl:attribute name="tabIndex">0</xsl:attribute>headword_grp</xsl:element>
			</td>
			<td/>
			<td width="32px">
				<xsl:if test="not(x:m and x:mf and x:hld and x:vk)">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('addlisad||', $rada, 'x:mg[', $posnr_mg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Add missing elements!</xsl:attribute>
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
						<xsl:attribute name="title">Delete empty elements!</xsl:attribute>
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
		<xsl:apply-templates select="x:mf">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:mg[', $posnr_mg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
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
						<xsl:attribute name="title">Create!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:vk</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-vk_120_58_118_107 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>morphological code</xsl:element>
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
	</xsl:template>
	<xsl:template match="x:grg">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="posnr_grg">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:grg[', $posnr_grg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">NEW "grammatical information_grp"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:grg[', $posnr_grg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:grg[', $posnr_grg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-grg_120_58_103_114_103 noedit</xsl:attribute>
					<xsl:attribute name="style">float:left;</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>grammatical information_grp</xsl:element>
			</td>
			<td/>
			<td width="32px">
				<xsl:if test="not(x:vk and x:mvl and x:mv and x:sly and x:mt and x:er and x:rk and x:gki)">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('addlisad||', $rada, 'x:grg[', $posnr_grg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Add missing elements!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<xsl:if test="*[. = '']">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('dellisad||', $rada, 'x:grg[', $posnr_grg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/delart 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Delete empty elements!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
			</td>
		</tr>
		<xsl:apply-templates select="x:vk">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:grg[', $posnr_grg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:mvl">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:grg[', $posnr_grg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:mv">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:grg[', $posnr_grg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:evg)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:evg|', $rada, 'x:grg[', $posnr_grg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Create!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:evg</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-evg_120_58_101_118_103 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>irregular form_grp</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:evg">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:grg[', $posnr_grg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:sly">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:grg[', $posnr_grg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:mt">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:grg[', $posnr_grg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:er">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:grg[', $posnr_grg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:rk">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:grg[', $posnr_grg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:gki">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:grg[', $posnr_grg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="x:evg">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="posnr_evg">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:evg[', $posnr_evg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:evg[', $posnr_evg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-evg_120_58_101_118_103 noedit</xsl:attribute>
					<xsl:attribute name="style">float:left;</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>irregular form_grp</xsl:element>
			</td>
			<td/>
			<td width="32px">
				<xsl:if test="not(x:vk and x:ev)">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('addlisad||', $rada, 'x:evg[', $posnr_evg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Add missing elements!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<xsl:if test="*[. = '']">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('dellisad||', $rada, 'x:evg[', $posnr_evg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/delart 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Delete empty elements!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
			</td>
		</tr>
		<xsl:apply-templates select="x:vk">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:evg[', $posnr_evg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:ev">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:evg[', $posnr_evg, ']/')"></xsl:value-of>
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
					<xsl:attribute name="tabIndex">0</xsl:attribute>body</xsl:element>
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
						<xsl:attribute name="title">Create!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:tp</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-tp_120_58_116_112 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>sense number_block</xsl:element>
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
						<xsl:attribute name="title">Create!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:LS</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-LS_120_58_76_83 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>compound words_block</xsl:element>
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
					<xsl:attribute name="title">NEW "sense number_block"</xsl:attribute>
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
					<xsl:attribute name="tabIndex">0</xsl:attribute>sense number_block</xsl:element>
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
								<xsl:value-of select="concat('sense number: x:tp[', $posnr_tp, ']/@x:tnr')"></xsl:value-of>
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
							<xsl:attribute name="title">Add attribute "sense number"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td width="32px">
				<xsl:if test="not(x:gki and x:tvt)">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('addlisad||', $rada, 'x:tp[', $posnr_tp, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Add missing elements!</xsl:attribute>
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
						<xsl:attribute name="title">Delete empty elements!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
			</td>
		</tr>
		<xsl:if test="not(x:slg)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:slg|', $rada, 'x:tp[', $posnr_tp, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Create!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:slg</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-slg_120_58_115_108_103 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>part of speech_grp</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:slg">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:tp[', $posnr_tp, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:gki">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:tp[', $posnr_tp, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:tg)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:tg|', $rada, 'x:tp[', $posnr_tp, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Create!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:tg</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-tg_120_58_116_103 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>sense_grp</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
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
						<xsl:attribute name="title">Create!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:np</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-np_120_58_110_112 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>examples_block</xsl:element>
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
						<xsl:attribute name="title">Create!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:tvt</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-tvt_120_58_116_118_116 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>sense reference</xsl:element>
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
	<xsl:template match="x:slg">
		<xsl:param name="rada"></xsl:param>
		<xsl:variable name="posnr_slg">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%">
				<xsl:element name="img">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('addgrupp||', $rada, 'x:slg[', $posnr_slg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="src">graphics/justify.ico</xsl:attribute>
					<xsl:attribute name="alt">■</xsl:attribute>
					<xsl:attribute name="title">NEW "part of speech_grp"</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
				</xsl:element>
			</td>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:slg[', $posnr_slg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:slg[', $posnr_slg, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-slg_120_58_115_108_103 noedit</xsl:attribute>
					<xsl:attribute name="style">float:left;</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>part of speech_grp</xsl:element>
			</td>
			<td/>
			<td width="32px">
				<xsl:if test="not(x:sl and x:rk)">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('addlisad||', $rada, 'x:slg[', $posnr_slg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Add missing elements!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<xsl:if test="*[. = '']">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('dellisad||', $rada, 'x:slg[', $posnr_slg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/delart 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Delete empty elements!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
			</td>
		</tr>
		<xsl:apply-templates select="x:sl">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:slg[', $posnr_slg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:rk">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:slg[', $posnr_slg, ']/')"></xsl:value-of>
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
					<xsl:attribute name="title">NEW "sense_grp"</xsl:attribute>
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
					<xsl:attribute name="tabIndex">0</xsl:attribute>sense_grp</xsl:element>
			</td>
			<td/>
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
						<xsl:attribute name="title">Create!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:dg</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-dg_120_58_100_103 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>definition_grp</xsl:element>
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
		<xsl:if test="not(x:xp)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:xp|', $rada, 'x:tg[', $posnr_tg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Create!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:xp</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-xp_120_58_120_112 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>equivalent block</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
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
					<xsl:attribute name="title">NEW "definition_grp"</xsl:attribute>
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
					<xsl:attribute name="tabIndex">0</xsl:attribute>definition_grp</xsl:element>
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
						<xsl:attribute name="title">Add missing elements!</xsl:attribute>
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
						<xsl:attribute name="title">Delete empty elements!</xsl:attribute>
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
		<xsl:if test="not(x:dt)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:dt|', $rada, 'x:dg[', $posnr_dg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Create!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:dt</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-dt_120_58_100_116 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>derived from</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
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
					<xsl:attribute name="tabIndex">0</xsl:attribute>equivalent block</xsl:element>
			</td>
			<td/>
			<td width="32px"></td>
		</tr>
		<xsl:if test="not(x:xg)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:xg|', $rada, 'x:xp[', $posnr_xp, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Create!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:xg</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-xg_120_58_120_103 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>equivalent group</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
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
					<xsl:attribute name="title">NEW "equivalent group"</xsl:attribute>
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
					<xsl:attribute name="tabIndex">0</xsl:attribute>equivalent group</xsl:element>
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
							<xsl:attribute name="title">Add attribute "xml:lang"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td width="32px">
				<xsl:if test="not(x:xkl and x:x and x:xvk and x:xsl and x:xv and x:xs)">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('addlisad||', $rada, 'x:xg[', $posnr_xg, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Add missing elements!</xsl:attribute>
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
						<xsl:attribute name="title">Delete empty elements!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
			</td>
		</tr>
		<xsl:apply-templates select="x:xkl">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:xg[', $posnr_xg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:x">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:xg[', $posnr_xg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:xvk">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:xg[', $posnr_xg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:xsl">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:xg[', $posnr_xg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:xv">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:xg[', $posnr_xg, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:xs">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:xg[', $posnr_xg, ']/')"></xsl:value-of>
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
					<xsl:attribute name="tabIndex">0</xsl:attribute>examples_block</xsl:element>
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
						<xsl:attribute name="title">Create!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:ng</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-ng_120_58_110_103 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>examples_grp</xsl:element>
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
					<xsl:attribute name="title">NEW "examples_grp"</xsl:attribute>
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
					<xsl:attribute name="tabIndex">0</xsl:attribute>examples_grp</xsl:element>
			</td>
			<td/>
			<td width="32px">
				<xsl:if test="not(x:n)">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('addlisad||', $rada, 'x:ng[', $posnr_ng, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Add missing elements!</xsl:attribute>
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
						<xsl:attribute name="title">Delete empty elements!</xsl:attribute>
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
						<xsl:attribute name="title">Create!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:qnp</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-qnp_120_58_113_110_112 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>translations (of the examples)_block</xsl:element>
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
					<xsl:attribute name="title">NEW "translations (of the examples)_block"</xsl:attribute>
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
					<xsl:attribute name="tabIndex">0</xsl:attribute>translations (of the examples)_block</xsl:element>
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
								<xsl:value-of select="concat('sense number (of the example): x:qnp[', $posnr_qnp, ']/@x:ntnr')"></xsl:value-of>
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
							<xsl:attribute name="title">Add attribute "sense number (of the example)"</xsl:attribute>
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
						<xsl:attribute name="title">Create!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:ndg</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-ndg_120_58_110_100_103 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>definition (of the examples)_group</xsl:element>
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
						<xsl:attribute name="title">Create!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:qng</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-qng_120_58_113_110_103 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>translation group</xsl:element>
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
					<xsl:attribute name="title">NEW "definition (of the examples)_group"</xsl:attribute>
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
					<xsl:attribute name="tabIndex">0</xsl:attribute>definition (of the examples)_group</xsl:element>
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
						<xsl:attribute name="title">Add missing elements!</xsl:attribute>
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
						<xsl:attribute name="title">Delete empty elements!</xsl:attribute>
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
					<xsl:attribute name="title">NEW "translation group"</xsl:attribute>
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
					<xsl:attribute name="tabIndex">0</xsl:attribute>translation group</xsl:element>
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
							<xsl:attribute name="title">Add attribute "xml:lang"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td width="32px">
				<xsl:if test="not(x:xkl and x:qn and x:xv and x:xs)">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('addlisad||', $rada, 'x:qng[', $posnr_qng, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Add missing elements!</xsl:attribute>
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
						<xsl:attribute name="title">Delete empty elements!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
			</td>
		</tr>
		<xsl:apply-templates select="x:xkl">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:qng[', $posnr_qng, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:qn">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:qng[', $posnr_qng, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:xv">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:qng[', $posnr_qng, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
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
					<xsl:attribute name="title">NEW "compound words_block"</xsl:attribute>
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
					<xsl:attribute name="tabIndex">0</xsl:attribute>compound words_block</xsl:element>
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
								<xsl:value-of select="concat('compound part: x:LS[', $posnr_LS, ']/@x:lso')"></xsl:value-of>
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
							<xsl:attribute name="title">Add attribute "compound part"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td width="32px">
				<xsl:if test="not(x:v and x:s and x:lsd)">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('addlisad||', $rada, 'x:LS[', $posnr_LS, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Add missing elements!</xsl:attribute>
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
						<xsl:attribute name="title">Delete empty elements!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
			</td>
		</tr>
		<xsl:apply-templates select="x:v">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:LS[', $posnr_LS, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="x:s">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($rada, 'x:LS[', $posnr_LS, ']/')"></xsl:value-of>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="not(x:lsd)">
			<tr>
				<td width="16px">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('creategrupp|x:lsd|', $rada, 'x:LS[', $posnr_LS, ']')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/downarrow 16-16.ico</xsl:attribute>
						<xsl:attribute name="alt">■</xsl:attribute>
						<xsl:attribute name="title">Create!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:lsd</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-lsd_120_58_108_115_100 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>definition of compound words_block</xsl:element>
				</td>
				<td></td>
				<td width="32px"></td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="x:lsd">
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
						<xsl:attribute name="title">Create!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:np</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-np_120_58_110_112 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>examples_block</xsl:element>
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
					<xsl:attribute name="tabIndex">0</xsl:attribute>comments</xsl:element>
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
						<xsl:attribute name="title">Create!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</td>
				<td width="33%">
					<xsl:element name="span">
						<xsl:attribute name="title">x:komg</xsl:attribute>
						<xsl:attribute name="class">ec ec_x-komg_120_58_107_111_109_103 noedit</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>comment_grp</xsl:element>
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
					<xsl:attribute name="title">NEW "comment_grp"</xsl:attribute>
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
					<xsl:attribute name="tabIndex">0</xsl:attribute>comment_grp</xsl:element>
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
						<xsl:attribute name="title">Add missing elements!</xsl:attribute>
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
						<xsl:attribute name="title">Delete empty elements!</xsl:attribute>
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
					<xsl:attribute name="tabIndex">0</xsl:attribute>headword</xsl:element>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@x:i">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:m[', $posnr_m, ']/@x:i')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('homonym number: x:m[', $posnr_m, ']/@x:i')"></xsl:value-of>
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
							<xsl:attribute name="title">Add attribute "homonym number"</xsl:attribute>
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
								<xsl:value-of select="concat('type of the headword: x:m[', $posnr_m, ']/@x:liik')"></xsl:value-of>
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
							<xsl:attribute name="title">Add attribute "type of the headword"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:m[', $posnr_m, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:m[', $posnr_m, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-m_120_58_109 edit etws</xsl:attribute>
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
					<xsl:attribute name="tabIndex">0</xsl:attribute>morphonological form</xsl:element>
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
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:hld[', $posnr_hld, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:hld[', $posnr_hld, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-hld_120_58_104_108_100 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>pronunciation</xsl:element>
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
					<xsl:attribute name="tabIndex">0</xsl:attribute>morphological code</xsl:element>
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
	<xsl:template match="x:mvl">
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
		<xsl:variable name="posnr_mvl">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:mvl[', $posnr_mvl, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:mvl[', $posnr_mvl, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-mvl_120_58_109_118_108 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>abbreviated inflectional forms</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:mvl[', $posnr_mvl, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:mvl[', $posnr_mvl, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-mvl_120_58_109_118_108 edit etws</xsl:attribute>
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
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:mv[', $posnr_mv, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:mv[', $posnr_mv, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-mv_120_58_109_118 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>inflectional forms</xsl:element>
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
	<xsl:template match="x:ev">
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
		<xsl:variable name="posnr_ev">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:ev[', $posnr_ev, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:ev[', $posnr_ev, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-ev_120_58_101_118 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>irregular form</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:ev[', $posnr_ev, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:ev[', $posnr_ev, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-ev_120_58_101_118 edit etws</xsl:attribute>
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
	<xsl:template match="x:sly">
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
		<xsl:variable name="posnr_sly">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:sly[', $posnr_sly, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:sly[', $posnr_sly, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-sly_120_58_115_108_121 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>part of speech</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:sly[', $posnr_sly, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:sly[', $posnr_sly, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-sly_120_58_115_108_121 edit etws</xsl:attribute>
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
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:mt[', $posnr_mt, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:mt[', $posnr_mt, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-mt_120_58_109_116 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>inflectional type number</xsl:element>
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
	<xsl:template match="x:er">
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
		<xsl:variable name="posnr_er">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:er[', $posnr_er, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:er[', $posnr_er, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-er_120_58_101_114 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>index of irregularity</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:er[', $posnr_er, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:er[', $posnr_er, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-er_120_58_101_114 edit etws</xsl:attribute>
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
	<xsl:template match="x:rk">
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
		<xsl:variable name="posnr_rk">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:rk[', $posnr_rk, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:rk[', $posnr_rk, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-rk_120_58_114_107 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>government (morphological code)</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:rk[', $posnr_rk, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:rk[', $posnr_rk, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-rk_120_58_114_107 edit etws</xsl:attribute>
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
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:gki[', $posnr_gki, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:gki[', $posnr_gki, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-gki_120_58_103_107_105 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>usage hints (grammatical information)</xsl:element>
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
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:v[', $posnr_v, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:v[', $posnr_v, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-v_120_58_118 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>domain</xsl:element>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@x:l">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:v[', $posnr_v, ']/@x:l')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('usage hint: x:v[', $posnr_v, ']/@x:l')"></xsl:value-of>
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
							<xsl:attribute name="title">Add attribute "usage hint"</xsl:attribute>
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
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:s[', $posnr_s, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:s[', $posnr_s, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-s_120_58_115 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>register</xsl:element>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@x:l">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:s[', $posnr_s, ']/@x:l')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('usage hint: x:s[', $posnr_s, ']/@x:l')"></xsl:value-of>
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
							<xsl:attribute name="title">Add attribute "usage hint"</xsl:attribute>
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
					<xsl:attribute name="title">NEW "alternative"</xsl:attribute>
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
					<xsl:attribute name="tabIndex">0</xsl:attribute>alternative</xsl:element>
			</td>
			<td>
				<xsl:apply-templates select="node()" mode="el_in_mixed">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($rada, 'x:a[', $posnr_a, ']/')"></xsl:value-of>
					</xsl:with-param>
					<xsl:with-param name="vanem_kirjeldav">alternative</xsl:with-param>
					<xsl:with-param name="vanem_muudetav">edit</xsl:with-param>
					<xsl:with-param name="vanem_unname">x-a_120_58_97</xsl:with-param>
					<xsl:with-param name="alates">true</xsl:with-param>
				</xsl:apply-templates>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:vhom">
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
		<xsl:variable name="posnr_vhom">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:vhom[', $posnr_vhom, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:vhom[', $posnr_vhom, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-vhom_120_58_118_104_111_109 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>indicator (homonym number)</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:vhom[', $posnr_vhom, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:vhom[', $posnr_vhom, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-vhom_120_58_118_104_111_109 edit etws</xsl:attribute>
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
					<xsl:attribute name="title">NEW "headword reference"</xsl:attribute>
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
					<xsl:attribute name="tabIndex">0</xsl:attribute>headword reference</xsl:element>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@x:mvtl">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:mvt[', $posnr_mvt, ']/@x:mvtl')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('type of the headword reference: x:mvt[', $posnr_mvt, ']/@x:mvtl')"></xsl:value-of>
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
							<xsl:attribute name="title">Add attribute "type of the headword reference"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:apply-templates select="node()" mode="el_in_mixed">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($rada, 'x:mvt[', $posnr_mvt, ']/')"></xsl:value-of>
					</xsl:with-param>
					<xsl:with-param name="vanem_kirjeldav">headword reference</xsl:with-param>
					<xsl:with-param name="vanem_muudetav">edit</xsl:with-param>
					<xsl:with-param name="vanem_unname">x-mvt_120_58_109_118_116</xsl:with-param>
					<xsl:with-param name="alates">true</xsl:with-param>
				</xsl:apply-templates>
			</td>
			<td width="32px"></td>
		</tr>
	</xsl:template>
	<xsl:template match="x:vtxh">
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
		<xsl:variable name="posnr_vtxh">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:vtxh[', $posnr_vtxh, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:vtxh[', $posnr_vtxh, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-vtxh_120_58_118_116_120_104 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>enenen</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:vtxh[', $posnr_vtxh, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:vtxh[', $posnr_vtxh, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-vtxh_120_58_118_116_120_104 edit etws</xsl:attribute>
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
	<xsl:template match="x:maht">
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
		<xsl:variable name="posnr_maht">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:maht[', $posnr_maht, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:maht[', $posnr_maht, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-maht_120_58_109_97_104_116 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>size class</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:maht[', $posnr_maht, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:maht[', $posnr_maht, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-maht_120_58_109_97_104_116 edit etws</xsl:attribute>
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
	<xsl:template match="x:all">
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
		<xsl:variable name="posnr_all">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:all[', $posnr_all, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:all[', $posnr_all, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-all_120_58_97_108_108 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>source</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:all[', $posnr_all, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:all[', $posnr_all, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-all_120_58_97_108_108 edit etws</xsl:attribute>
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
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:sl[', $posnr_sl, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:sl[', $posnr_sl, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-sl_120_58_115_108 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>part of speech</xsl:element>
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
					<xsl:attribute name="tabIndex">0</xsl:attribute>derived from</xsl:element>
			</td>
			<td>
				<xsl:apply-templates select="node()" mode="el_in_mixed">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($rada, 'x:dt[', $posnr_dt, ']/')"></xsl:value-of>
					</xsl:with-param>
					<xsl:with-param name="vanem_kirjeldav">derived from</xsl:with-param>
					<xsl:with-param name="vanem_muudetav">edit</xsl:with-param>
					<xsl:with-param name="vanem_unname">x-dt_120_58_100_116</xsl:with-param>
					<xsl:with-param name="alates">true</xsl:with-param>
				</xsl:apply-templates>
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
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:d[', $posnr_d, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:d[', $posnr_d, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-d_120_58_100 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>definition</xsl:element>
			</td>
			<td>
				<xsl:apply-templates select="node()" mode="el_in_mixed">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($rada, 'x:d[', $posnr_d, ']/')"></xsl:value-of>
					</xsl:with-param>
					<xsl:with-param name="vanem_kirjeldav">definition</xsl:with-param>
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
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:ld[', $posnr_ld, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:ld[', $posnr_ld, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-ld_120_58_108_100 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>latin definition</xsl:element>
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
							<xsl:attribute name="title">Add attribute "xml:lang"</xsl:attribute>
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
	<xsl:template match="x:xkl">
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
		<xsl:variable name="posnr_xkl">
			<xsl:number level="single" format="1"></xsl:number>
		</xsl:variable>
		<tr>
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:xkl[', $posnr_xkl, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:xkl[', $posnr_xkl, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-xkl_120_58_120_107_108 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>hint (usage coverage)</xsl:element>
			</td>
			<td>
				<xsl:if test="text()">
					<xsl:element name="span">
						<xsl:attribute name="id">
							<xsl:value-of select="concat($rada, 'x:xkl[', $posnr_xkl, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('x:xkl[', $posnr_xkl, ']/text()[1]')"></xsl:value-of>
						</xsl:attribute>
						<xsl:attribute name="class">et et_x-xkl_120_58_120_107_108 edit etws</xsl:attribute>
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
					<xsl:attribute name="tabIndex">0</xsl:attribute>equivalent</xsl:element>
			</td>
			<td>
				<xsl:apply-templates select="node()" mode="el_in_mixed">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($rada, 'x:x[', $posnr_x, ']/')"></xsl:value-of>
					</xsl:with-param>
					<xsl:with-param name="vanem_kirjeldav">equivalent</xsl:with-param>
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
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:xr[', $posnr_xr, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:xr[', $posnr_xr, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-xr_120_58_120_114 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>government (question)</xsl:element>
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
					<xsl:attribute name="tabIndex">0</xsl:attribute>morphological code</xsl:element>
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
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:xsl[', $posnr_xsl, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:xsl[', $posnr_xsl, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-xsl_120_58_120_115_108 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>part of speech</xsl:element>
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
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:xv[', $posnr_xv, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:xv[', $posnr_xv, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-xv_120_58_120_118 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>domain</xsl:element>
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
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:xs[', $posnr_xs, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:xs[', $posnr_xs, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-xs_120_58_120_115 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>register</xsl:element>
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
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:n[', $posnr_n, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:n[', $posnr_n, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-n_120_58_110 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>example</xsl:element>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@x:nrl">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:n[', $posnr_n, ']/@x:nrl')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('role of an expression: x:n[', $posnr_n, ']/@x:nrl')"></xsl:value-of>
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
							<xsl:attribute name="title">Add attribute "role of an expression"</xsl:attribute>
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
					<xsl:with-param name="vanem_kirjeldav">example</xsl:with-param>
					<xsl:with-param name="vanem_muudetav">edit</xsl:with-param>
					<xsl:with-param name="vanem_unname">x-n_120_58_110</xsl:with-param>
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
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:r[', $posnr_r, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:r[', $posnr_r, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-r_120_58_114 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>government (question)</xsl:element>
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
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:nd[', $posnr_nd, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:nd[', $posnr_nd, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-nd_120_58_110_100 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>definition of the example</xsl:element>
			</td>
			<td>
				<xsl:apply-templates select="node()" mode="el_in_mixed">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($rada, 'x:nd[', $posnr_nd, ']/')"></xsl:value-of>
					</xsl:with-param>
					<xsl:with-param name="vanem_kirjeldav">definition of the example</xsl:with-param>
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
					<xsl:attribute name="tabIndex">0</xsl:attribute>translation</xsl:element>
			</td>
			<td>
				<xsl:apply-templates select="node()" mode="el_in_mixed">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($rada, 'x:qn[', $posnr_qn, ']/')"></xsl:value-of>
					</xsl:with-param>
					<xsl:with-param name="vanem_kirjeldav">translation</xsl:with-param>
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
					<xsl:attribute name="title">NEW "sense reference"</xsl:attribute>
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
					<xsl:attribute name="tabIndex">0</xsl:attribute>sense reference</xsl:element>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@x:tvtl">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:tvt[', $posnr_tvt, ']/@x:tvtl')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('type of the sense reference: x:tvt[', $posnr_tvt, ']/@x:tvtl')"></xsl:value-of>
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
							<xsl:attribute name="title">Add attribute "type of the sense reference"</xsl:attribute>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:apply-templates select="node()" mode="el_in_mixed">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($rada, 'x:tvt[', $posnr_tvt, ']/')"></xsl:value-of>
					</xsl:with-param>
					<xsl:with-param name="vanem_kirjeldav">sense reference</xsl:with-param>
					<xsl:with-param name="vanem_muudetav">edit</xsl:with-param>
					<xsl:with-param name="vanem_unname">x-tvt_120_58_116_118_116</xsl:with-param>
					<xsl:with-param name="alates">true</xsl:with-param>
				</xsl:apply-templates>
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
					<xsl:attribute name="tabIndex">0</xsl:attribute>definition of compound words_block</xsl:element>
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
			<td width="2%"/>
			<td width="33%">
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($rada, 'x:data[', $posnr_data, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('x:data[', $posnr_data, ']')"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="class">en en_x-data_120_58_100_97_116_97 noedit</xsl:attribute>
					<xsl:attribute name="tabIndex">0</xsl:attribute>source text</xsl:element>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@x:src">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($rada, 'x:data[', $posnr_data, ']/@x:src')"></xsl:value-of>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('source: x:data[', $posnr_data, ']/@x:src')"></xsl:value-of>
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
							<xsl:attribute name="title">Add attribute "source"</xsl:attribute>
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
					<xsl:attribute name="tabIndex">0</xsl:attribute>comment</xsl:element>
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
					<xsl:attribute name="tabIndex">0</xsl:attribute>author of the comment</xsl:element>
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
					<xsl:attribute name="tabIndex">0</xsl:attribute>date of the comment</xsl:element>
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
					<xsl:attribute name="tabIndex">0</xsl:attribute>signed by</xsl:element>
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
					<xsl:attribute name="tabIndex">0</xsl:attribute>date of signing</xsl:element>
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
