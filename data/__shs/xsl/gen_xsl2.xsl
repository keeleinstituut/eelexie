<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:msxsl="urn:schemas-microsoft-com:xslt"
xmlns:alt="http://www.w3.org/1999/XSL/Transform-alternate"
xmlns:pr_sd="http://www.eo.ee/dev/xml/names">

	<xsl:namespace-alias stylesheet-prefix="alt" result-prefix="xsl"/>
	<xsl:output method="xml" omit-xml-declaration="no" indent="yes" encoding="utf-8" />

	<xsl:variable name="ELEM_NAME">en</xsl:variable>
	<xsl:variable name="ELEM_NAME_MIXED">enmx</xsl:variable>
	<xsl:variable name="ELEM_NAME_XML1">enx1</xsl:variable>
	<xsl:variable name="ELEM_NAME_LEVEL1">enl1</xsl:variable>
	<xsl:variable name="ATTR_NAME">an</xsl:variable>
	<xsl:variable name="ATTR_NAME_MIXED">anmx</xsl:variable>
	<xsl:variable name="ATTR_NAME_XML1">anx1</xsl:variable>
	<xsl:variable name="ELEM_TEXT">et</xsl:variable>
	<xsl:variable name="ELEM_TEXT_LEVEL1">etl1</xsl:variable>
	<xsl:variable name="ATTR_TEXT">at</xsl:variable>
	<xsl:variable name="ATTR_TEXT_MIXED">atmx</xsl:variable>
	<xsl:variable name="ATTR_TEXT_XML1">atx1</xsl:variable>
	<xsl:variable name="COMM_TEXT">ct</xsl:variable>
	<xsl:variable name="ELEM_CREATE">ec</xsl:variable>
	<xsl:variable name="INFO_TEXT">it</xsl:variable>
	<xsl:variable name="WIDE_SPAN">etws</xsl:variable>

	<xsl:variable name="SDURI">http://www.eo.ee/dev/xml/names</xsl:variable>

  <xsl:variable name="ADD_ATTR">
    <xsl:if test="*/@pr_sd:sAppLang = 'et'">Lisa tunnus </xsl:if>
    <xsl:if test="*/@pr_sd:sAppLang = 'en'">Add attribute </xsl:if>
  </xsl:variable>
  <xsl:variable name="NEW_TEXT">
		<xsl:if test="*/@pr_sd:sAppLang = 'et'">UUS </xsl:if>
		<xsl:if test="*/@pr_sd:sAppLang = 'en'">NEW </xsl:if>
	</xsl:variable>
	<xsl:variable name="ADD_MISSING_TEXT">
		<xsl:if test="*/@pr_sd:sAppLang = 'et'">Lisa puuduvad elemendid!</xsl:if>
		<xsl:if test="*/@pr_sd:sAppLang = 'en'">Add missing elements!</xsl:if>
	</xsl:variable>
	<xsl:variable name="DEL_EMPTY_TEXT">
		<xsl:if test="*/@pr_sd:sAppLang = 'et'">Kustuta tühjad elemendid!</xsl:if>
		<xsl:if test="*/@pr_sd:sAppLang = 'en'">Delete empty elements!</xsl:if>
	</xsl:variable>
	<xsl:variable name="CREATE_TEXT">
		<xsl:if test="*/@pr_sd:sAppLang = 'et'">Lisa!</xsl:if>
		<xsl:if test="*/@pr_sd:sAppLang = 'en'">Create!</xsl:if>
	</xsl:variable>

  <xsl:variable name="imgSrc_downArr">graphics/downarrow 16-16.ico</xsl:variable>
  <xsl:variable name="imgSrc_justify">graphics/justify.ico</xsl:variable>
  <xsl:variable name="imgSrc_struProp">graphics/struprop_16-16.ico</xsl:variable>
  <xsl:variable name="imgSrc_delArt">graphics/delart 16-16.ico</xsl:variable>
  <xsl:variable name="imgAlt">&#x25A0;</xsl:variable>

  <xsl:template match="/">
		<alt:stylesheet version="1.0">

			<alt:output method="html" omit-xml-declaration="yes" indent="no" encoding="utf-8" />


			<!--<xsl:value-of select="concat('&#x0d;&#x0a;', '&#xA0;', '&#x0d;&#x0a;', '&#x09;')"/>-->
			<!--<xsl:text xml:space="preserve">&#x0d;&#x0a;</xsl:text>-->


      <alt:include href="include/incTemplates.xsl" />


      <xsl:variable name="names_in_mixed">
				<xsl:for-each select=".//*[not(string(@pr_sd:qname) = string(preceding::*/@pr_sd:qname) or string(@pr_sd:qname) = string(ancestor::*/@pr_sd:qname))][@pr_sd:ct = 3][@pr_sd:show = 'true']//*[@pr_sd:show = 'true']">
					<name_in_mixed>
						<xsl:value-of select="name()"/>
					</name_in_mixed>
				</xsl:for-each>
			</xsl:variable>
			<xsl:for-each select=".//*[not(@pr_sd:qname = preceding::*/@pr_sd:qname or @pr_sd:qname = ancestor::*/@pr_sd:qname)][name() = msxsl:node-set($names_in_mixed)/name_in_mixed[not(. = preceding-sibling::name_in_mixed)]]">
				<alt:template match="{name()}" mode="el_in_mixed">

					<alt:param name="rada"/>
					<alt:param name="vanem_kirjeldav"/>
					<alt:param name="vanem_muudetav"/>
					<alt:param name="vanem_unname"/>

					<alt:variable name="allposnr">
						<alt:number level="single" count="node()"  format="1"></alt:number>
					</alt:variable>
					<alt:if test="$allposnr > 1">
            <alt:element name="br"></alt:element>
          </alt:if>

					<alt:variable name="mposnr">
						<alt:number level="single" format="1"></alt:number>
					</alt:variable>

					<!--pealkiri-->
					<alt:element name="span">
						<alt:attribute name="id">
							<alt:value-of select="concat($rada, '{name()}[', $mposnr, ']')"></alt:value-of>
						</alt:attribute>
						<alt:attribute name="title">
							<alt:value-of select="concat('{@pr_sd:desc}: {name()}[', $mposnr, ']')"></alt:value-of>
						</alt:attribute>
						<alt:attribute name="class">
							<xsl:value-of select="concat($ELEM_NAME_MIXED, ' ', $ELEM_NAME_MIXED, '_', @pr_sd:unName, ' noedit')"></xsl:value-of>
						</alt:attribute>
						<alt:attribute name="tabIndex">0</alt:attribute>
						<alt:value-of select="local-name()"></alt:value-of>
					</alt:element>
					<!--atribuudid-->
					<xsl:for-each select="@*[namespace-uri() != $SDURI and . != '']">
						<xsl:variable name="attDesc">
							<xsl:value-of select="substring-before(., '&#xE003;')"></xsl:value-of>
						</xsl:variable>
						<xsl:variable name="attEdit">
							<xsl:value-of select="substring-before(substring-after(., '&#xE003;'), '&#xE004;')"></xsl:value-of>
						</xsl:variable>
						<xsl:variable name="attUnName">
							<xsl:value-of select="substring-after(., '&#xE004;')"></xsl:value-of>
						</xsl:variable>
						<alt:if test="@{name()}">
							<alt:text>&#xA0;</alt:text>
							<alt:element name="span">
								<alt:attribute name="id">
									<alt:value-of select="concat($rada, '{name(..)}[', $mposnr, ']/@{name()}')"></alt:value-of>
								</alt:attribute>
								<alt:attribute name="title">
									<alt:value-of select="concat('{$attDesc}: {name(..)}[', $mposnr, ']/@{name()}')"></alt:value-of>
								</alt:attribute>
								<alt:attribute name="class">
									<xsl:value-of select="concat($ATTR_TEXT_MIXED, ' ', $ATTR_TEXT_MIXED, '_', $attUnName, ' ', $attEdit)"></xsl:value-of>
								</alt:attribute>
								<alt:if test="@{name()} = ''">
									<alt:attribute name="style">width:16px;</alt:attribute>
								</alt:if>
								<alt:attribute name="lang">
									<alt:call-template name="get_lang"></alt:call-template>
								</alt:attribute>
								<alt:attribute name="tabIndex">0</alt:attribute>
								<alt:value-of select="@{name()}"></alt:value-of>
							</alt:element>
						</alt:if>
					</xsl:for-each>
					<!--sisu ja teised-->
					<alt:apply-templates select="node()" mode="el_in_mixed">
						<alt:with-param name="rada">
							<alt:value-of select="concat($rada, '{name()}[', $mposnr, ']/')"></alt:value-of>
						</alt:with-param>
						<alt:with-param name="vanem_kirjeldav">
							<xsl:value-of select="@pr_sd:desc" />
						</alt:with-param>
						<alt:with-param name="vanem_muudetav">
							<xsl:value-of select="@pr_sd:enableedit" />
						</alt:with-param>
						<alt:with-param name="vanem_unname">
							<xsl:value-of select="@pr_sd:unName" />
						</alt:with-param>
					</alt:apply-templates>

				</alt:template>
			</xsl:for-each>


			<alt:template match="text()" mode="el_in_mixed">

				<alt:param name="rada"/>
				<alt:param name="vanem_kirjeldav"/>
				<alt:param name="vanem_muudetav"/>
				<alt:param name="vanem_unname"/>
				<alt:param name="alates"/>

				<alt:variable name="allposnr">
					<alt:number level="single" count="node()"  format="1"></alt:number>
				</alt:variable>
				<alt:if test="$allposnr > 1">
					<alt:text>&#xA0;</alt:text>
				</alt:if>

				<alt:variable name="mposnr">
					<alt:number level="single" format="1"></alt:number>
				</alt:variable>

				<alt:element name="span">
					<alt:attribute name="id">
						<alt:value-of select="concat($rada, 'text()[', $mposnr, ']')"></alt:value-of>
					</alt:attribute>
					<alt:attribute name="title">
						<alt:value-of select="concat($vanem_kirjeldav, ': text()[', $mposnr, ']')"></alt:value-of>
					</alt:attribute>
					<alt:attribute name="class">
						<alt:value-of select="concat('{$ELEM_TEXT} {$ELEM_TEXT}_', $vanem_unname, ' ', $vanem_muudetav)"></alt:value-of>
					</alt:attribute>
					<alt:choose>
						<alt:when test="$alates = 'true' and count(../node()) = 1">
							<alt:attribute name="style">width:100%;</alt:attribute>
						</alt:when>
						<alt:otherwise>
							<alt:if test=". = ''">
								<alt:attribute name="style">width:16px;</alt:attribute>
							</alt:if>
						</alt:otherwise>
					</alt:choose>
					<alt:attribute name="lang">
						<alt:call-template name="get_lang"></alt:call-template>
					</alt:attribute>
					<alt:attribute name="tabIndex">0</alt:attribute>
					<alt:value-of select="."></alt:value-of>
				</alt:element>

			</alt:template>


			<alt:template match="comment()" mode="el_in_mixed">

				<alt:param name="rada"/>
				<alt:param name="vanem_kirjeldav"/>
				<alt:param name="vanem_muudetav"/>
				<alt:param name="vanem_unname"/>

				<alt:variable name="allposnr">
					<alt:number level="single" count="node()"  format="1"></alt:number>
				</alt:variable>
				<alt:if test="$allposnr > 1">
					<alt:text>&#xA0;</alt:text>
				</alt:if>

				<alt:variable name="mposnr">
					<alt:number level="single" format="1"></alt:number>
				</alt:variable>

				<alt:element name="span">
					<alt:attribute name="id">
						<alt:value-of select="concat($rada, 'comment()[', $mposnr, ']')"></alt:value-of>
					</alt:attribute>
					<alt:attribute name="title">
						<alt:value-of select="concat($vanem_kirjeldav, ': comment()[', $mposnr, ']')"></alt:value-of>
					</alt:attribute>
					<alt:attribute name="class">
						<alt:value-of select="concat('{$COMM_TEXT} {$COMM_TEXT}_', $vanem_unname, ' ', $vanem_muudetav)"></alt:value-of>
					</alt:attribute>
					<alt:if test=". = ''">
						<alt:attribute name="style">width:16px;</alt:attribute>
					</alt:if>
					<alt:attribute name="lang">
						<alt:call-template name="get_lang"></alt:call-template>
					</alt:attribute>
					<alt:attribute name="tabIndex">0</alt:attribute>
					<alt:value-of select="."></alt:value-of>
				</alt:element>

			</alt:template>


			<alt:template match="/">
				<body lang="et">
					<table id="cnt_tbl" border="1" width="100%" cellSpacing="0">
						<alt:apply-templates select="*/*"></alt:apply-templates>
					</table>
				</body>
			</alt:template>


			<xsl:apply-templates select="*/*"></xsl:apply-templates>


			<xsl:for-each select=".//*[not(@pr_sd:qname = preceding::*/@pr_sd:qname or @pr_sd:qname = ancestor::*/@pr_sd:qname)][@pr_sd:ct = -1 or @pr_sd:ct = 1 or @pr_sd:ct = 3][@pr_sd:show = 'true']">
				<alt:template match="{name()}">

					<alt:param name="rada"></alt:param>

					<alt:variable name="psCount">
						<alt:value-of select="count(preceding-sibling::*)"></alt:value-of>
					</alt:variable>
					<alt:apply-templates select="preceding-sibling::comment()[count(preceding-sibling::*) = number($psCount)]">
						<alt:with-param name="rada">
							<alt:value-of select="$rada"></alt:value-of>
						</alt:with-param>
						<alt:with-param name="vanem_kirjeldav">
							<alt:value-of select="../@pr_sd:desc" />
						</alt:with-param>
					</alt:apply-templates>

					<alt:variable name="posnr_{local-name()}">
						<alt:number level="single" format="1"></alt:number>
					</alt:variable>

					<tr>
						<td width="2%">
							<xsl:if test="@pr_sd:addbutton = 'true'">
								<alt:element name="img">
									<alt:attribute name="id">
										<alt:value-of select="concat('addgrupp||', $rada, '{name()}[', $posnr_{local-name()}, ']')"></alt:value-of>
									</alt:attribute>
									<alt:attribute name="src">
                    <xsl:value-of select="$imgSrc_justify"/>
                  </alt:attribute>
                  <alt:attribute name="alt">
                    <xsl:value-of select="$imgAlt"/>
                  </alt:attribute>
                  <alt:attribute name="title">
										<xsl:value-of select="concat($NEW_TEXT, '&quot;', @pr_sd:desc, '&quot;')"></xsl:value-of>
									</alt:attribute>
									<alt:attribute name="tabIndex">0</alt:attribute>
								</alt:element>
							</xsl:if>
						</td>
						<td width="33%">
							<alt:element name="span">
								<!--
							Eesmärgiks on, et kõik klassid oleksid erinevad: saab paremini käsitleda CSS-is.

							Elementide nimed: (1)en (2)en_local-name() (3)noedit
							Atribuutide nimed: (1)an (2)an_local-name() (3)noedit
							(praegu - 18. mai 2006 - pole; on nüüd xsl1 - s, 10. august 2006: mitte 'span' - ina)
							Elementide väärtused: (1)et (2)et_local-name(..) (3)edit/noedit
							Atribuutide väärtused: (1)at (2)at_local-name() (3)edit/noedit
							Kommentaaride väärtused: (1)ct (2)ct_local-name(..) (3)edit
							Veel loomata elementide nimed: (1)ec (2)ec_local-name() (3)noedit
							Tekstiinfo (nt SP taanete info): (1)it (2)it_ (3)noedit
							-->
								<alt:attribute name="id">
									<alt:value-of select="concat($rada, '{name()}[', $posnr_{local-name()}, ']')"></alt:value-of>
								</alt:attribute>
								<alt:attribute name="title">
									<alt:value-of select="concat('{name()}[', $posnr_{local-name()}, ']')"></alt:value-of>
								</alt:attribute>
								<alt:attribute name="class">
									<xsl:value-of select="concat($ELEM_NAME, ' ', $ELEM_NAME, '_', @pr_sd:unName, ' noedit')"></xsl:value-of>
								</alt:attribute>
								<alt:attribute name="tabIndex">0</alt:attribute>
								<xsl:value-of select="@pr_sd:desc"></xsl:value-of>
							</alt:element>
							<xsl:for-each select="@*[namespace-uri() != $SDURI and . != '']">
								<xsl:variable name="attDesc">
									<xsl:value-of select="substring-before(., '&#xE003;')"></xsl:value-of>
								</xsl:variable>
								<xsl:variable name="attEdit">
									<xsl:value-of select="substring-before(substring-after(., '&#xE003;'), '&#xE004;')"></xsl:value-of>
								</xsl:variable>
								<xsl:variable name="attUnName">
									<xsl:value-of select="substring-after(., '&#xE004;')"></xsl:value-of>
								</xsl:variable>
                <alt:text>&#xA0;</alt:text>
                <alt:choose>
                  <alt:when test="@{name()}">
                    <alt:element name="span">
                      <alt:attribute name="id">
                        <alt:value-of select="concat($rada, '{name(..)}[', $posnr_{local-name(..)}, ']/@{name()}')"></alt:value-of>
                      </alt:attribute>
                      <alt:attribute name="title">
                        <alt:value-of select="concat('{$attDesc}: {name(..)}[', $posnr_{local-name(..)}, ']/@{name()}')"></alt:value-of>
                      </alt:attribute>
                      <alt:attribute name="class">
                        <xsl:value-of select="concat($ATTR_TEXT, ' ', $ATTR_TEXT, '_', $attUnName, ' ', $attEdit)"></xsl:value-of>
                      </alt:attribute>
                      <alt:if test="@{name()} = ''">
                        <alt:attribute name="style">width:16px;</alt:attribute>
                      </alt:if>
                      <alt:attribute name="lang">
                        <alt:call-template name="get_lang"></alt:call-template>
                      </alt:attribute>
                      <alt:attribute name="tabIndex">0</alt:attribute>
                      <alt:value-of select="@{name()}"></alt:value-of>
                    </alt:element>
                  </alt:when>
                  <alt:otherwise>
                    <alt:element name="img">
                      <alt:attribute name="border">1</alt:attribute>
                      <alt:attribute name="id">
                        <alt:value-of select="concat('addAttr|{name()}|', $rada, '{name(..)}[', $posnr_{local-name(..)}, ']')"></alt:value-of>
                      </alt:attribute>
                      <alt:attribute name="src">
                        <xsl:value-of select="$imgSrc_struProp"/>
                      </alt:attribute>
                      <alt:attribute name="alt">
                        <xsl:value-of select="$imgAlt"/>
                      </alt:attribute>
                      <alt:attribute name="title">
                        <xsl:value-of select="concat($ADD_ATTR, '&quot;', $attDesc, '&quot;')"></xsl:value-of>
                      </alt:attribute>
                      <alt:attribute name="tabIndex">0</alt:attribute>
                    </alt:element>
                  </alt:otherwise>
                </alt:choose>
							</xsl:for-each>
						</td>
						<td>
							<xsl:choose>
								<xsl:when test="@pr_sd:ct = -1 or @pr_sd:ct = 1">
									<alt:if test="text()">
										<alt:element name="span">
											<alt:attribute name="id">
												<alt:value-of select="concat($rada, '{name()}[', $posnr_{local-name()}, ']/text()[1]')"></alt:value-of>
											</alt:attribute>
											<alt:attribute name="title">
												<alt:value-of select="concat('{name()}[', $posnr_{local-name()}, ']/text()[1]')"></alt:value-of>
											</alt:attribute>
											<alt:attribute name="class">
												<xsl:value-of select="concat($ELEM_TEXT, ' ', $ELEM_TEXT, '_', @pr_sd:unName, ' ', @pr_sd:enableedit, ' ', $WIDE_SPAN)"></xsl:value-of>
											</alt:attribute>
											<alt:attribute name="lang">
												<alt:call-template name="get_lang"></alt:call-template>
											</alt:attribute>
											<alt:attribute name="tabIndex">0</alt:attribute>
											<alt:value-of select="."></alt:value-of>
										</alt:element>
									</alt:if>
								</xsl:when>
								<xsl:otherwise>
									<alt:apply-templates select="node()" mode="el_in_mixed">
										<alt:with-param name="rada">
											<alt:value-of select="concat($rada, '{name()}[', $posnr_{local-name()}, ']/')"></alt:value-of>
										</alt:with-param>
										<alt:with-param name="vanem_kirjeldav">
											<xsl:value-of select="@pr_sd:desc" />
										</alt:with-param>
										<alt:with-param name="vanem_muudetav">
											<xsl:value-of select="@pr_sd:enableedit" />
										</alt:with-param>
										<alt:with-param name="vanem_unname">
											<xsl:value-of select="@pr_sd:unName" />
										</alt:with-param>
										<alt:with-param name="alates">true</alt:with-param>
									</alt:apply-templates>
								</xsl:otherwise>
							</xsl:choose>
						</td>
						<td width="32px">
						</td>
					</tr>

				</alt:template>
			</xsl:for-each>


			<!-- SHOWCOMMENT -->
			<alt:template match="comment()">
				<alt:param name="rada"></alt:param>
				<alt:param name="vanem_kirjeldav"/>
				<alt:param name="vanem_muudetav"/>
				<alt:param name="vanem_unname"/>

				<alt:variable name="posnr_comment">
					<alt:number level="single" format="1"></alt:number>
				</alt:variable>

				<tr>
					<td colspan="4">
						<alt:element name="span">
							<alt:attribute name="id">
								<alt:value-of select="concat($rada, 'comment()[', $posnr_comment, ']')"></alt:value-of>
							</alt:attribute>
							<alt:attribute name="title">
								<alt:value-of select="concat($vanem_kirjeldav, ': ', name(..), '/comment()[', $posnr_comment, ']')"></alt:value-of>
							</alt:attribute>
							<alt:attribute name="class">
								<alt:value-of select="concat('{$COMM_TEXT} {$COMM_TEXT}_', $vanem_unname, ' edit {$WIDE_SPAN}')"></alt:value-of>
							</alt:attribute>
							<alt:attribute name="lang">
								<alt:call-template name="get_lang"></alt:call-template>
							</alt:attribute>
							<alt:attribute name="tabIndex">0</alt:attribute>
							<alt:value-of select="."></alt:value-of>
						</alt:element>
					</td>
				</tr>
			</alt:template>
			<!-- comment() -->

		</alt:stylesheet>
	</xsl:template>
	<!--"/"-->



	<!-- TEGELIK STYLESHEET ALGUS -->

	<xsl:template match="*">

		<!-- SCHEMACONTENTTYPE_ELEMENTONLY -->
		<xsl:if test="@pr_sd:show = 'true' and @pr_sd:ct = 2">

			<alt:template match="{name()}">

				<alt:param name="rada"></alt:param>

				<alt:variable name="posnr_{local-name()}">
					<alt:number level="single" format="1"></alt:number>
				</alt:variable>


				<xsl:if test="@pr_sd:hng = 'true'">

					<tr>
						<xsl:choose>
							<!--P, S, Z, F, VT, KOM, K, KA, T, TA-->
							<xsl:when test="@pr_sd:depth = 1 and @pr_sd:addbutton = 'false'">

								<!-- Kirjeldav pealkirjaks -->
								<td colspan="2" width="35%">
									<alt:element name="span">
										<alt:attribute name="id">
											<alt:value-of select="concat($rada, '{name()}[', $posnr_{local-name()}, ']')"></alt:value-of>
										</alt:attribute>
										<alt:attribute name="title">
											<alt:value-of select="concat('{name()}[', $posnr_{local-name()}, ']')"></alt:value-of>
										</alt:attribute>
										<alt:attribute name="class">
											<xsl:value-of select="concat($ELEM_NAME, ' ', $ELEM_NAME, '_', @pr_sd:unName, ' noedit')"></xsl:value-of>
										</alt:attribute>
										<alt:attribute name="style">float:left;</alt:attribute>
										<alt:attribute name="tabIndex">0</alt:attribute>
										<xsl:value-of select="@pr_sd:desc"></xsl:value-of>
									</alt:element>
								</td>
							</xsl:when>
							<xsl:otherwise>

								<td width="2%">
									<!-- Lisamise nupp -->
									<xsl:if test="@pr_sd:addbutton = 'true'">
										<alt:element name="img">
											<alt:attribute name="id">
												<alt:value-of select="concat('addgrupp||', $rada, '{name()}[', $posnr_{local-name()}, ']')"></alt:value-of>
											</alt:attribute>
											<alt:attribute name="src">
                        <xsl:value-of select="$imgSrc_justify"/>
                      </alt:attribute>
                      <alt:attribute name="alt">
                        <xsl:value-of select="$imgAlt"/>
                      </alt:attribute>
                      <alt:attribute name="title">
												<xsl:value-of select="concat($NEW_TEXT, '&quot;', @pr_sd:desc, '&quot;')"></xsl:value-of>
											</alt:attribute>
											<alt:attribute name="tabIndex">0</alt:attribute>
										</alt:element>
									</xsl:if>
								</td>

								<!-- Kirjeldav pealkirjaks -->
								<td width="33%">
									<alt:element name="span">
										<alt:attribute name="id">
											<alt:value-of select="concat($rada, '{name()}[', $posnr_{local-name()}, ']')"></alt:value-of>
										</alt:attribute>
										<alt:attribute name="title">
											<alt:value-of select="concat('{name()}[', $posnr_{local-name()}, ']')"></alt:value-of>
										</alt:attribute>
										<alt:attribute name="class">
											<xsl:value-of select="concat($ELEM_NAME, ' ', $ELEM_NAME, '_', @pr_sd:unName, ' noedit')"></xsl:value-of>
										</alt:attribute>
										<alt:attribute name="style">float:left;</alt:attribute>
										<alt:attribute name="tabIndex">0</alt:attribute>
										<xsl:value-of select="@pr_sd:desc"></xsl:value-of>
									</alt:element>
								</td>

							</xsl:otherwise>
						</xsl:choose>

						<td>

							<xsl:for-each select="@*[namespace-uri() != $SDURI and . != '']">
								<xsl:variable name="attDesc">
									<xsl:value-of select="substring-before(., '&#xE003;')"></xsl:value-of>
								</xsl:variable>
								<xsl:variable name="attEdit">
									<xsl:value-of select="substring-before(substring-after(., '&#xE003;'), '&#xE004;')"></xsl:value-of>
								</xsl:variable>
								<xsl:variable name="attUnName">
									<xsl:value-of select="substring-after(., '&#xE004;')"></xsl:value-of>
								</xsl:variable>

                <alt:text>&#xA0;</alt:text>
                <alt:choose>
                  <alt:when test="@{name()}">
                    <alt:element name="span">
                      <alt:attribute name="id">
                        <alt:value-of select="concat($rada, '{name(..)}[', $posnr_{local-name(..)}, ']/@{name()}')"></alt:value-of>
                      </alt:attribute>
                      <alt:attribute name="title">
                        <alt:value-of select="concat('{$attDesc}: {name(..)}[', $posnr_{local-name(..)}, ']/@{name()}')"></alt:value-of>
                      </alt:attribute>
                      <alt:attribute name="class">
                        <xsl:value-of select="concat($ATTR_TEXT, ' ', $ATTR_TEXT, '_', $attUnName, ' ', $attEdit)"></xsl:value-of>
                      </alt:attribute>
                      <alt:if test="@{name()} = ''">
                        <alt:attribute name="style">width:16px;</alt:attribute>
                      </alt:if>
                      <alt:attribute name="lang">
                        <alt:call-template name="get_lang"></alt:call-template>
                      </alt:attribute>
                      <alt:attribute name="tabIndex">0</alt:attribute>
                      <alt:value-of select="@{name()}"></alt:value-of>
                    </alt:element>
                  </alt:when>
                  <alt:otherwise>
                    <alt:element name="img">
                      <alt:attribute name="border">1</alt:attribute>
                      <alt:attribute name="id">
                        <alt:value-of select="concat('addAttr|{name()}|', $rada, '{name(..)}[', $posnr_{local-name(..)}, ']')"></alt:value-of>
                      </alt:attribute>
                      <alt:attribute name="src">
                        <xsl:value-of select="$imgSrc_struProp"/>
                      </alt:attribute>
                      <alt:attribute name="alt">
                        <xsl:value-of select="$imgAlt"/>
                      </alt:attribute>
                      <alt:attribute name="title">
                        <xsl:value-of select="concat($ADD_ATTR, '&quot;', $attDesc, '&quot;')"></xsl:value-of>
                      </alt:attribute>
                      <alt:attribute name="tabIndex">0</alt:attribute>
                    </alt:element>
                  </alt:otherwise>
                </alt:choose>
							</xsl:for-each>

						</td>

						<!-- Lisade lisamise ja kustutamise nupud -->
						<xsl:variable name="koiktekstid">
							<xsl:for-each select="*[@pr_sd:ct != 2]">
								<xsl:value-of select="concat(' and ', name())"></xsl:value-of>
							</xsl:for-each>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="$koiktekstid != ''">
								<td width="32px">
									<alt:if test="not({substring($koiktekstid, 6)})">
										<alt:element name="img">
											<alt:attribute name="id">
												<alt:value-of select="concat('addlisad||', $rada, '{name()}[', $posnr_{local-name()}, ']')"></alt:value-of>
											</alt:attribute>
											<alt:attribute name="src">
                        <xsl:value-of select="$imgSrc_downArr"/>
                      </alt:attribute>
                      <alt:attribute name="alt">
                        <xsl:value-of select="$imgAlt"/>
                      </alt:attribute>
                      <alt:attribute name="title">
												<xsl:value-of select="$ADD_MISSING_TEXT"/>
											</alt:attribute>
											<alt:attribute name="tabIndex">0</alt:attribute>
										</alt:element>
									</alt:if>
									<alt:if test="*[. = '']">
										<alt:element name="img">
											<alt:attribute name="id">
												<alt:value-of select="concat('dellisad||', $rada, '{name()}[', $posnr_{local-name()}, ']')"></alt:value-of>
											</alt:attribute>
											<alt:attribute name="src">
                        <xsl:value-of select="$imgSrc_delArt"/>
                      </alt:attribute>
                      <alt:attribute name="alt">
                        <xsl:value-of select="$imgAlt"/>
                      </alt:attribute>
                      <alt:attribute name="title">
												<xsl:value-of select="$DEL_EMPTY_TEXT"/>
											</alt:attribute>
											<alt:attribute name="tabIndex">0</alt:attribute>
										</alt:element>
									</alt:if>
								</td>
							</xsl:when>
							<xsl:otherwise>
								<td width="32px"></td>
							</xsl:otherwise>
						</xsl:choose>
					</tr>
				</xsl:if>
				<!--@pr_sd:hng = 'true'-->


        <xsl:choose>

          <!--suvalise jadaga elemendid-->
          <xsl:when test="@pr_sd:anySequence">
            <xsl:for-each select="*">
              <xsl:if test="@pr_sd:show = 'true'">
                <xsl:if test="@pr_sd:createbutton = 'true'">
                  <!-- Loomise nupp -->
                  <alt:if test="not({name()})">
                    <tr>
                      <td width="16px">
                        <alt:element name="img">
                          <alt:attribute name="id">
                            <alt:value-of select="concat('creategrupp|{name()}|', $rada, '{name(..)}[', $posnr_{local-name(..)}, ']')"></alt:value-of>
                          </alt:attribute>
                          <alt:attribute name="src">
                            <xsl:value-of select="$imgSrc_downArr"/>
                          </alt:attribute>
                          <alt:attribute name="alt">
                            <xsl:value-of select="$imgAlt"/>
                          </alt:attribute>
                          <alt:attribute name="title">
                            <xsl:value-of select="$CREATE_TEXT"/>
                          </alt:attribute>
                          <alt:attribute name="tabIndex">0</alt:attribute>
                        </alt:element>
                      </td>
                      <td width="33%">
                        <alt:element name="span">
                          <alt:attribute name="title">
                            <xsl:value-of select="name()"></xsl:value-of>
                          </alt:attribute>
                          <alt:attribute name="class">
                            <xsl:value-of select="concat($ELEM_CREATE, ' ', $ELEM_CREATE, '_', @pr_sd:unName, ' noedit')"></xsl:value-of>
                          </alt:attribute>
                          <alt:attribute name="tabIndex">0</alt:attribute>
                          <xsl:value-of select="@pr_sd:desc"></xsl:value-of>
                        </alt:element>
                      </td>
                      <td>
                      </td>
                      <td width="32px">
                      </td>
                    </tr>
                  </alt:if>
                </xsl:if>
                <alt:apply-templates select="{name()}">
                  <alt:with-param name="rada">
                    <alt:value-of select="concat($rada, '{name(..)}[', $posnr_{local-name(..)}, ']/')"></alt:value-of>
                  </alt:with-param>
                </alt:apply-templates>
              </xsl:if>
            </xsl:for-each>

          </xsl:when>

          <!--tavalise jrk-ga elemendid-->
          <xsl:otherwise>
            <xsl:for-each select="*">
              <xsl:if test="@pr_sd:show = 'true'">

                <xsl:if test="@pr_sd:createbutton = 'true'">

                  <!-- Loomise nupp -->
                  <alt:if test="not({name()})">
                    <tr>
                      <td width="16px">
                        <alt:element name="img">
                          <alt:attribute name="id">
                            <alt:value-of select="concat('creategrupp|{name()}|', $rada, '{name(..)}[', $posnr_{local-name(..)}, ']')"></alt:value-of>
                          </alt:attribute>
                          <alt:attribute name="src">
                            <xsl:value-of select="$imgSrc_downArr"/>
                          </alt:attribute>
                          <alt:attribute name="alt">
                            <xsl:value-of select="$imgAlt"/>
                          </alt:attribute>
                          <alt:attribute name="title">
                            <xsl:value-of select="$CREATE_TEXT"/>
                          </alt:attribute>
                          <alt:attribute name="tabIndex">0</alt:attribute>
                        </alt:element>
                      </td>
                      <td width="33%">
                        <alt:element name="span">
                          <alt:attribute name="title">
                            <xsl:value-of select="name()"></xsl:value-of>
                          </alt:attribute>
                          <alt:attribute name="class">
                            <xsl:value-of select="concat($ELEM_CREATE, ' ', $ELEM_CREATE, '_', @pr_sd:unName, ' noedit')"></xsl:value-of>
                          </alt:attribute>
                          <alt:attribute name="tabIndex">0</alt:attribute>
                          <xsl:value-of select="@pr_sd:desc"></xsl:value-of>
                        </alt:element>
                      </td>
                      <td>
                      </td>
                      <td width="32px">
                      </td>
                    </tr>
                  </alt:if>

                </xsl:if>
                <!--@pr_sd:createbutton = 'true'-->


                <xsl:choose>
                  <!-- SimpleType (TypeName(oParticle.type) = "ISchemaType") korral puudub 'type' objekt -->
                  <!-- SCHEMACONTENTTYPE_MIXED -->
                  <xsl:when test="@pr_sd:ct = -1 or @pr_sd:ct = 1 or @pr_sd:ct = 3">

                    <!-- SCHEMACONTENTTYPE_TEXTONLY -->
                    <alt:apply-templates select="{name()}">
                      <alt:with-param name="rada">
                        <alt:value-of select="concat($rada, '{name(..)}[', $posnr_{local-name(..)}, ']/')"></alt:value-of>
                      </alt:with-param>
                    </alt:apply-templates>

                  </xsl:when>
                  <xsl:when test="@pr_sd:ct = 2">

                    <!-- SCHEMACONTENTTYPE_ELEMENTONLY -->
                    <alt:apply-templates select="{name()}">
                      <alt:with-param name="rada">
                        <alt:value-of select="concat($rada, '{name(..)}[', $posnr_{local-name(..)}, ']/')"></alt:value-of>
                      </alt:with-param>
                    </alt:apply-templates>

                  </xsl:when>
                  <xsl:otherwise></xsl:otherwise>
                </xsl:choose>

              </xsl:if>
              <!--algelemendi alamelemendi @pr_sd:show = 'true'-->

            </xsl:for-each>
            <!--algelemendi alamelemendid-->
          </xsl:otherwise>

        </xsl:choose>


			</alt:template>
			<!--match="{name()}"-->


			<xsl:for-each select="*">
				<xsl:variable name="qname">
					<xsl:value-of select="name()"></xsl:value-of>
				</xsl:variable>
				<xsl:if test="not(preceding::*[name() = $qname] or ancestor::*[name() = $qname])">
					<xsl:apply-templates select="self::node()" />
				</xsl:if>
			</xsl:for-each>

		</xsl:if>
		<!--@pr_sd:show = 'true' and @pr_sd:ct = 2"-->

	</xsl:template>
	<!-- * -->

</xsl:stylesheet>
