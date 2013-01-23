
//Copyright© 2006 - 2012. Andres Loopmann, EKI, andres.loopmann@eki.ee. All rights reserved.

var dhxLayout, dhxLayoutContent, dhxBar, dhxBarWidths, dhxBarContent, brGrid, dhxBarPaging;
var elemInput;

var sqlDics, dicDescsArr;

var sCmdId;
var sUsrName; // EELex kasutajanimi
var sAppLang = "et"; // kasutajaliidese keel

var dtOpStart, opInfo;
var pagingRowsPerPage = 500, pagingPageNr, pagingPageCount, pagingSql;

var valaDoc, valaDiv, valaCss;
var bgColor = '#deeaf8'; // gold, #D0E3EF, AntiqueWhite, khaki, WhiteSmoke, #ffe09f, #ffe1a8, #ffdd94, #e5f2f8, #ededed

var dhxWins, tyybidWindow;

//-----------------------------------------------------------------------------------
function bodyOnLoad() {

    var ix;

    //    window.dhx_globalImgPath = "html/dhtmlx/dhtmlxCombo/codebase/imgs/";

    var layoutParent = document.getElementById("parentId");
    //    var layoutParent = document.body;
    dhxLayout = new dhtmlXLayoutObject(layoutParent, "3J", "dhx_blue");
    //    dhxLayout = new dhtmlXLayoutObject("parentId", "3J", "dhx_blue");
    dhxLayout.cells("a").setText("Sõnastike koondindeks");
    //    dhxLayout.cells("a").hideHeader();
    dhxLayout.cells("b").hideHeader();
    dhxLayout.cells("c").hideHeader();

    dhxLayout.cells("b").setWidth(layoutParent.clientWidth * 0.25);
    dhxLayout.cells("a").setHeight(68);
    dhxLayout.cells("a").fixSize(false, true);
    //    dhxLayout.setAutoSize("a;c", "b;c");

    //    dhxLayout.cont.obj._offsetTop = 10;
    //    dhxLayout.cont.obj._offsetHeight = -60;

    //        dhxWins = new dhtmlXWindows();
    dhxWins = dhxLayout.dhxWins;
    dhxWins.setImagePath("html/dhtmlx/dhtmlxWindows/codebase/imgs/");



    dhxBar = dhxLayout.cells("a").attachToolbar();
    dhxBar.setSkin("dhx_web");
    //        dhxBar.setIconsPath("graphics/");

    var barNr = 0;
    dhxBar.addText("dhxBarLogo", ++barNr, "<img id='eeLexLogo' src='graphics/EELex_153x38_taust-ececec-lai.png' style='height:24px;'>");
    dhxBar.addText("dhxBarPealKiri", ++barNr, "<div id='pealKiri'></div>");
    dhxBar.addText("dhxBarDummyText", ++barNr, "<div id='dummy'></div>");

    dhxBar.addText("dhxBarMenu", ++barNr, "<div id='pkMenu'></div>");
    var pkMenuObj = document.getElementById("pkMenu");
    var pkMenu = new dhtmlXMenuObject(pkMenuObj);
    //        srMenu.setIconsPath("graphics/");
    var menuXml =
            "<menu>" +
              "<item id='dics' text='Sõnastikud'></item>" +
              "<item id='about' text='Rakendusest'></item>" +
            "</menu>";
    pkMenu.loadXMLString(menuXml);
    pkMenu.setSkin("dhx_skyblue");
    pkMenu.attachEvent("onClick", function (id, zoneId, casState) {
        srMenuOnClick(id);
    });

    dhxBarWidths = document.getElementById("eeLexLogo").clientWidth +
                        document.getElementById("pealKiri").clientWidth +
                        document.getElementById("pkMenu").clientWidth;
    setDummyTextWidth();


    dhxLayout.cells("b").attachURL("html/Koond_artikkel.htm");

    //    dhxLayout.attachEvent("onResizeFinish", function () {
    //        setDummyTextWidth();
    //    });
    //    dhxLayout.attachEvent("onPanelResizeFinish", function () {
    //        setDummyTextWidth();
    //    });




    dhxLayoutContent = new dhtmlXLayoutObject(dhxLayout.cells("c"), "2E", "dhx_blue");
    dhxLayoutContent.cells("a").setText("Sõnastikud");
    //    dhxLayoutContent.cells("a").hideHeader();
    dhxLayoutContent.cells("b").hideHeader();
    dhxLayoutContent.cells("b").setHeight(100);
    dhxLayoutContent.cells("b").fixSize(false, true);
    //    dhxLayoutContent.setAutoSize("a;b", "a");

    barNr = 0;
    dhxBarContent = dhxLayoutContent.cells("a").attachToolbar();
    dhxBarContent.setSkin("dhx_web");
    //    toolbar.addInput(id, pos, value, width);
    dhxBarContent.addInput("txtElemOtsitav", ++barNr, "", 400);
    dhxBarContent.addSeparator("seprPealeTeksti", ++barNr);

    dhxBarContent.addText("dhxBarContentMenu", ++barNr, "<div id='contentMenu'></div>");
    var contentMenuObj = document.getElementById("contentMenu");
    var contentMenu = new dhtmlXMenuObject(contentMenuObj);
    contentMenu.setIconsPath("graphics/");
    menuXml =
            "<menu>" +
              "<item id='contRandom' text='' img='my_computer2.png'></item>" +
              "<item id='contSepr' type='separator' />" +
              "<item id='contOtsi' text='Otsi'></item>" +
              "<item id='contCommon' text='Ühised ms'></item>" +
              "<item id='contSaveAs' text='Salvesta'></item>" +
            "</menu>";
    contentMenu.loadXMLString(menuXml);
    contentMenu.setTooltip("contRandom", "Lase arvutil valida märksõna!");
    contentMenu.setSkin("dhx_skyblue");
    // id - id of the clicked/hovered menu item;
    // zoneId (only for onClick event in case of a Contextual Menu) - id of the contextual menu zone;
    // casState(only for onClick event) - whether the key “Ctrl”, “Alt”, or “Shift” was pressed with click or not.
    // if (casState["ctrl"] == true) {, if (casState["alt"] == true) {, if (casState["shift"] == true) {
    contentMenu.attachEvent("onClick", function (id, zoneId, casState) {
        contentMenuOnClick(id, zoneId, casState);
    });
    dhxBarContent.attachEvent("onEnter", function (id, value) {
        otsing("suvaline");
    });
    var inputs = dhxBarContent.cont.getElementsByTagName("INPUT"); // 'DOMelem_input' on combo korral nt
    for (ix = 0; ix < inputs.length; ix++) {
        var thisInput = inputs[ix];
        if (thisInput.getAttribute("type") == "text") {
            elemInput = thisInput;
            break;
        }
    }


    brGrid = dhxLayoutContent.cells("a").attachGrid();
    brGrid.setImagePath("html/dhtmlx/dhtmlxGrid/codebase/imgs/");
    brGrid.setHeader("Nr,Märksõna,Hom nr.,Liik,Sõnastik,");
    brGrid.setInitWidths("50,200,100,50,300,*");
    brGrid.setColAlign("center,left,center,center,left,left");
    brGrid.enableEditEvents(false, false, false); // click, dblclick, F2
    brGrid.setColSorting("int,str,int,str,str,str");
    brGrid.setColTypes("ro,ro,ro,ro,ro,ro");
    brGrid.enableTooltips("false,false,false,false,false,false");
    brGrid.setSkin("gray");
    brGrid.enableAutoHeight(true, dhxLayoutContent.cells("a").getHeight() - 70, true);
    //    brGrid.attachHeader(" ,#cspan,#text_search,#text_filter,#combo_filter,#text_filter,#combo_filter,#text_filter,#text_filter,#combo_filter");
    //    // setStyle(ss_header, ss_grid, ss_selCell, ss_selRow)
    //    brGrid.setStyle("background-color:navy;color:white; font-weight:bold;", "", "color:red;", "");
    //    brGrid.setStyle("", "", "", "background-color:silver;");
    brGrid.init();
    brGrid.enableSmartRendering(true);

    brGrid.attachEvent("onRowSelect", function (id, ind) {
        gridOnRowSelect(id, ind);
    });
    brGrid.attachEvent("onRightClick", function (id, ind, obj) {
        gridOnRightClick(id, ind, obj);
    });



    barNr = 0;
    dhxBarPaging = dhxLayoutContent.cells("b").attachToolbar();
    dhxBarPaging.setSkin("dhx_web");
    dhxBarPaging.setIconsPath("graphics/");

    dhxBarPaging.addButton("btnReadFirst", ++barNr, null, "DataContainer_MoveFirstHS.png", null);
    dhxBarPaging.setItemToolTip("btnReadFirst", "Esimene lk.");
    dhxBarPaging.addButton("btnReadPrev", ++barNr, null, "DataContainer_MovePreviousHS.png", null);
    dhxBarPaging.setItemToolTip("btnReadPrev", "Eelmine lk.");

    dhxBarPaging.addSeparator("seprPealePrev", ++barNr);
    dhxBarPaging.addText("dhxBarPagingPealKiri", ++barNr, "<div id='pagingPealKiri' style='width:10cm;text-align:center;'><span id='spnPagingInfo'>-</span><span id='spnPagingElapsed'></span></div>");
    dhxBarPaging.addSeparator("seprEnneNext", ++barNr);

    dhxBarPaging.addButton("btnReadNext", ++barNr, null, "DataContainer_MoveNextHS.png", null);
    dhxBarPaging.setItemToolTip("btnReadNext", "Järgmine lk.");
    dhxBarPaging.addButton("btnReadLast", ++barNr, null, "DataContainer_MoveLastHS.png", null);
    dhxBarPaging.setItemToolTip("btnReadLast", "Viimane lk.");

    dhxBarPaging.addSeparator("seprEnneSelect", ++barNr);

    // id - id of the option;
    // type - obj|sep, whether this option is an object or a separator;
    // text - label of the option (only for objects);
    // img - path to the option image (only for objects).
    //    toolbar.addButtonSelect(id, pos, text, opts, imgEnabled, imgDisabled, renderSelect, openAll, maxOpen);
    dhxBarPaging.addButtonSelect("pageSelect", ++barNr, "Vali lk.", [['1', 'obj', '1. lk.', null]], null, null, true, true, 10);
    dhxBarPaging.setWidth("pageSelect", 150);

    dhxBarPaging.addSeparator("seprEnnePagingDummy", ++barNr);
    dhxBarPaging.addText("dhxBarPagingDummy", ++barNr, "");


    dhxBarPaging.attachEvent("onClick", function (id) {
        dhxBarPagingOnClick(id);
    });

    dhxLayout.cells("c").view("about").attachURL("html/Koond_about.htm", false);


    var oConfigDOM, cfgElem, lexlist;

//    oConfigDOM = IDD("File", "http://eelextest.eki.ee/__shs/shsConfig.xml", false, false, null);
    oConfigDOM = IDD("File", "../../../__shs/shsConfig.xml", false, false, null);
    if (!oConfigDOM) {
        alert("Puudub EELex konf. fail 'shsConfig.xml'!");
        return;
    }
    cfgElem = oConfigDOM.documentElement.getElementsByTagName("qmMySql")[0];
    if (cfgElem) {
        sqlDics = getXmlNodeValue(cfgElem);
    }
    if (!sqlDics) {
        alert("Pole ühtegi sõnastikku MySql-is?");
        return;
    }

//    lexlist = IDD("File", "http://eelextest.eki.ee/lexlist.xml", false, false, null);
    lexlist = IDD("File", "../../../lexlist.xml", false, false, null);

    var selectedDics = "", pageCmd = "";
    if (window.location.search) {
        var srch = window.location.search.substr(1);
        var params = srch.split("&");
        for (ix = 0; ix < params.length; ix++) {
            var cmdParams = params[ix].split("=");
            var cmd = jsTrim(cmdParams[0]);
            var val = jsTrim(cmdParams[1]);
            if (cmd == "dics") {
                selectedDics = val;
            }
            if (cmd == "ms") {
                val = decodeURIComponent(val);
                dhxBarContent.setValue("txtElemOtsitav", val);
            }
            if (cmd == "cmd") {
                pageCmd = val;
            }
        }
    }
    if (!selectedDics) {
        selectedDics = ";";
        if (sqlDics.indexOf('ety') > -1) {
            selectedDics += "ety;";
        }
        if (sqlDics.indexOf('ex_') > -1) {
            selectedDics += "ex_;";
        }
        if (sqlDics.indexOf('evs') > -1) {
            selectedDics += "evs;";
        }
        if (sqlDics.indexOf('ies') > -1) {
            selectedDics += "ies;";
        }
        if (sqlDics.indexOf('kn_') > -1) {
            selectedDics += "kn_;";
        }
        if (sqlDics.indexOf('qs_') > -1) {
            selectedDics += "qs_;";
        }
        if (sqlDics.indexOf('sp_') > -1) {
            selectedDics += "sp_;";
        }
        if (sqlDics.indexOf('ss_') > -1) {
            selectedDics += "ss_;";
        }
        if (sqlDics.indexOf('ss1') > -1) {
            selectedDics += "ss1;";
        }
        if (sqlDics.indexOf('psv') > -1) {
            selectedDics += "psv;";
        }
        if (sqlDics.indexOf('vsl') > -1) {
            selectedDics += "vsl;";
        }
    }

    var sqldicsArr = sqlDics.substr(1, sqlDics.length - 2).split(";");
    sqldicsArr.sort();

    dicDescsArr = {};


    var htmlString = "<div style='background-color:#ececec;height:100%;'><table id='tblDicChecks'>";
    htmlString += "<tr>";
    for (ix = 0; ix < sqldicsArr.length; ix++) {
        var dd = sqldicsArr[ix];
        var valitud = "";
        if (selectedDics.indexOf(";" + dd + ";") > -1) {
            valitud = " checked";
        }
        var spikker = getXmlSingleNodeValue(lexlist.documentElement, "lex[@id = '" + dd + "']/name[@l = '" + sAppLang + "']");
        htmlString += "<td title='" + spikker + "'><input id='chk_" + dd + "' dd='" + dd + "' type='checkbox'" + valitud + "><label for='chk_" + dd + "'>" + dd + "</label></td>";
        dicDescsArr[dd] = spikker;
    }
    htmlString += "</tr>";
    htmlString += "</table>";
    htmlString += "<table style='width:100%;'>";
    htmlString += "<tr>";
    htmlString += "<td title='Vali kõik / Tühjenda kõik'><input id='chk_All' type='checkbox' onclick='checkUncheckAll()'><label for='chk_All'>Kõik</label></td>";
    htmlString += "<td style='text-align:right;font-size:xx-small;color:silver;'>Powered by DHTMLX<br />Design à la de La Condamine mode</td>";
    htmlString += "</tr>";
    htmlString += "</table></div>";
    dhxLayoutContent.cells("b").attachHTMLString(htmlString);

    //    sbMain = dhxLayoutContent.cells("b").attachStatusBar();
    //    sbMain.setText("_"); // enne polegi statusBar-i näha

    elemInput.focus();

    if (pageCmd == "otsi") {
        otsing("suvaline");
    }
    if (pageCmd == "yhised") {
        yhised("suvaline");
    }

    //    sbMain = dhxLayoutContent.cells("a").attachStatusBar();

} //bodyOnLoad


//-----------------------------------------------------------------------------------
function checkUncheckAll() {
    var allChecked = document.getElementById("chk_All").checked;
    var checksTable = document.getElementById("tblDicChecks");
    var checks = checksTable.getElementsByTagName("INPUT");
    for (var ix = 0; ix < checks.length; ix++) {
        var check = checks[ix];
        if (check.type == "checkbox") {
            if (allChecked) {
                check.checked = true;
            } else {
                check.checked = false;
            }
        }
    }
} // checkUncheckAll


//-----------------------------------------------------------------------------------
function contentMenuOnClick(itmId, zone, casState) {
    if (itmId == "contOtsi") {
        otsing(casState);
    } else if (itmId == "contCommon") {
        yhised(casState);
    } else if (itmId == "contRandom") {
        getRandomWord(casState);
    } else if (itmId == "contSaveAs") {
        srvSaveAs(casState);
    }
} // contentMenuOnClick


//-----------------------------------------------------------------------------------
function setDummyTextWidth() {
    dhxBar.setWidth("dhxBarDummyText", dhxLayout.cells("a").getWidth() - dhxBarWidths - 55);
} // setDummyTextWidth


//-----------------------------------------------------------------------------------
function dhxBarPagingOnClick(clickedId) {
    var itmType = dhxBarPaging.getType(clickedId), lims;
    if (itmType == "buttonSelectButton") {
        if (clickedId <= pagingPageCount && clickedId != pagingPageNr) {
            pagingPageNr = clickedId;
            lims = " LIMIT " + ((pagingPageNr - 1) * pagingRowsPerPage) + "," + pagingRowsPerPage;
            pagingPages(lims);
            setButtonSelectId(dhxBarPaging, "pageSelect", pagingPageNr, " / " + pagingPageCount + " lk.");
        }
    } else if (itmType == "button") {
        if (clickedId == "btnReadNext") {
            if (pagingPageNr < pagingPageCount) {
                pagingPageNr++;
                lims = " LIMIT " + ((pagingPageNr - 1) * pagingRowsPerPage) + "," + pagingRowsPerPage;
                pagingPages(lims);
                setButtonSelectId(dhxBarPaging, "pageSelect", pagingPageNr, " / " + pagingPageCount + " lk.");
            }
        } else if (clickedId == "btnReadPrev") {
            if (pagingPageNr > 1) {
                pagingPageNr--;
                lims = " LIMIT " + ((pagingPageNr - 1) * pagingRowsPerPage) + "," + pagingRowsPerPage;
                pagingPages(lims);
                setButtonSelectId(dhxBarPaging, "pageSelect", pagingPageNr, " / " + pagingPageCount + " lk.");
            }
        } else if (clickedId == "btnReadFirst") {
            if (pagingPageNr > 1) {
                pagingPageNr = 1;
                lims = " LIMIT " + ((pagingPageNr - 1) * pagingRowsPerPage) + "," + pagingRowsPerPage;
                pagingPages(lims);
                setButtonSelectId(dhxBarPaging, "pageSelect", pagingPageNr, " / " + pagingPageCount + " lk.");
            }
        } else if (clickedId == "btnReadLast") {
            if (pagingPageNr < pagingPageCount) {
                pagingPageNr = pagingPageCount;
                lims = " LIMIT " + ((pagingPageNr - 1) * pagingRowsPerPage) + "," + pagingRowsPerPage;
                pagingPages(lims);
                setButtonSelectId(dhxBarPaging, "pageSelect", pagingPageNr, " / " + pagingPageCount + " lk.");
            }
        }
    }
} // dhxBarPagingOnClick


//-----------------------------------------------------------------------------------
function pagingPages(pagingClause) {
    var sqlCmd = pagingSql + pagingClause;
    sCmdId = "ClientRead";
    var cmdXml = "<prm>" +
                    "<cmd>" + sCmdId + "</cmd>" +
                    "<sql>" + sqlCmd + "</sql>" +
                    "<scfr></scfr>" +
                "</prm>";

    var cmdXmlDom = IDD("String", cmdXml, false, false, null);
    if (!(cmdXmlDom && getXmlString(cmdXmlDom))) { // kui on viga, siis IE-s on xml=''
        alert("Viga 'cmdXmlDom'-s");
        return;
    }
    StartOperation(cmdXmlDom);
} // pagingPages


//-----------------------------------------------------------------------------------
function srMenuOnClick(mnuItmId) {
    if (mnuItmId == "dics") {
        dhxLayout.cells("c").view("def").setActive();
    } else if (mnuItmId == "about") {
        dhxLayout.cells("c").view("about").setActive();
    }
} // srMenuOnClick


//-----------------------------------------------------------------------------------
function srvSaveAs(casState) {
    if (!pagingSql) {
        return;
    }
    sCmdId = "srvSaveAs";
    var cmdXml = "<prm>" +
                    "<cmd>" + sCmdId + "</cmd>" +
                    "<sql>" + pagingSql + "</sql>" +
                "</prm>";

    var cmdXmlDom = IDD("String", cmdXml, false, false, null);
    if (!(cmdXmlDom && getXmlString(cmdXmlDom))) { // kui on viga, siis IE-s on xml=''
        alert("Viga 'cmdXmlDom'-s");
        return;
    }
    StartOperation(cmdXmlDom);
} // srvSaveAs


//-----------------------------------------------------------------------------------
function getRandomWord(casState) {
    var seldDics = "", dicsTing = "", allChecked = true;
    var checksTable = document.getElementById("tblDicChecks");
    var checks = checksTable.getElementsByTagName("INPUT");
    for (var ix = 0; ix < checks.length; ix++) {
        var check = checks[ix];
        if (check.type == "checkbox") {
            if (check.checked) {
                if (seldDics) {
                    seldDics += ",";
                }
                seldDics += "'" + check.getAttribute("dd") + "'";
            } else {
                allChecked = false;
            }
        }
    }
    if (seldDics) {
        if (!allChecked) {
            dicsTing = "msid.dic_code IN (" + seldDics + ")";
        }
    }

    sCmdId = "getRandomWord";
    var cmdXml = "<prm>" +
                    "<cmd>" + sCmdId + "</cmd>" +
                    "<sql>" + dicsTing + "</sql>" +
                "</prm>";

    var cmdXmlDom = IDD("String", cmdXml, false, false, null);
    if (!(cmdXmlDom && getXmlString(cmdXmlDom))) { // kui on viga, siis IE-s on xml=''
        alert("Viga 'cmdXmlDom'-s");
        return;
    }
    StartOperation(cmdXmlDom);
} // getRandomWord


//-----------------------------------------------------------------------------------
function yhised(casState) {

    opInfo = "<b>Ühised</b> - ";

    var otsitav = jsTrim(dhxBarContent.getValue("txtElemOtsitav"));
    var msTing = "";
    if (otsitav != "*") {
        var mySqlLikePtrn = getMySqlLikePtrn(otsitav); // koos eraldajatega
        msTing = "ms_nos LIKE " + mySqlLikePtrn + " AND ";
    }

    var dicsTing = "";
    var seldDics = "";
    var allChecked = true;
    var mitu = 0;
    var checksTable = document.getElementById("tblDicChecks");
    var checks = checksTable.getElementsByTagName("INPUT");
    for (var ix = 0; ix < checks.length; ix++) {
        var check = checks[ix];
        if (check.type == "checkbox") {
            if (check.checked) {
                if (seldDics) {
                    seldDics += ",";
                }
                seldDics += "'" + check.getAttribute("dd") + "'";
                mitu++;
            } else {
                allChecked = false;
            }
        }
    }
    if (mitu < 2) {
        return;
    }
    dicsTing = "dic_code IN (" + seldDics + ")";


    pagingPageNr = 1;

    //        Dim lisand As String = "CREATE TEMPORARY TABLE tt (SELECT msid.ms_nos, msid.dic_code FROM msid WHERE (msid.dic_code IN (" & rmtd & ") AND msid.vol_nr > 0" & msNosTing & ") GROUP BY msid.ms_nos HAVING (COUNT(msid.ms_nos) > 1 AND COUNT(DISTINCT msid.dic_code) = " & jnr & ") ORDER BY NULL)"
    //        Dim sql As String = "SELECT msid.ms AS ms, msid.vol_nr AS vol_nr, msid.dic_code AS dic_code, msid.ms_att_i AS ms_att_i, msid.ms_att_liik AS ms_att_liik, msid.G AS G FROM msid, tt WHERE ( msid.dic_code IN(" & rmtd & ") AND msid.vol_nr > 0" & msNosTing & " AND msid.ms_nos = tt.ms_nos ) ORDER BY msid.ms_nos, msid.dic_code, msid.ms_att_i LIMIT 2000"

    var sqlCmd = "SELECT m1.ms AS ms, m1.ms_nos AS ms_nos, m1.vol_nr AS vol_nr, m1.dic_code AS dic_code, \
                m1.ms_att_i AS ms_att_i, m1.ms_att_liik AS ms_att_liik, m1.G AS G \
                FROM msid AS m1 FORCE INDEX FOR ORDER BY (ix_nos_code_i) \
                JOIN (SELECT ms_nos AS ms_nos, dic_code AS dic_code FROM msid WHERE (" + msTing + "vol_nr > 0 AND " + dicsTing + ") GROUP BY ms_nos HAVING (COUNT(DISTINCT dic_code) = " + mitu + ") ORDER BY NULL) AS m2 \
                ON (m2.ms_nos = m1.ms_nos AND m1." + dicsTing + " AND m1.vol_nr > 0) \
                ORDER BY m1.ms_nos, m1.dic_code, m1.ms_att_i";

    sqlCmd = sqlCmd.replace(/\s+/g, " ");
    pagingSql = sqlCmd;
    sqlCmd += " LIMIT " + ((pagingPageNr - 1) * pagingRowsPerPage) + "," + pagingRowsPerPage;

    if (casState["ctrl"] && casState["shift"]) {
        alert(sqlCmd);
        return;
    }

    sCmdId = "ClientRead";
    var cmdXml = "<prm>" +
                    "<cmd>" + sCmdId + "</cmd>" +
                    "<sql>" + sqlCmd + "</sql>" +
                    "<scfr>SQL_CALC_FOUND_ROWS</scfr>" +
                "</prm>";

    var cmdXmlDom = IDD("String", cmdXml, false, false, null);
    if (!(cmdXmlDom && getXmlString(cmdXmlDom))) { // kui on viga, siis IE-s on xml=''
        alert("Viga 'cmdXmlDom'-s");
        return;
    }

    var pagingPealKiri = document.getElementById("spnPagingInfo");
    pagingPealKiri.innerHTML = "";

    StartOperation(cmdXmlDom);
} // yhised


//-----------------------------------------------------------------------------------
function otsing(casState) {

    opInfo = "<b>Otsing</b> - ";

    var otsitav = jsTrim(dhxBarContent.getValue("txtElemOtsitav"));
    var msTing = "";
    if (otsitav != "*") {
        var mySqlLikePtrn = getMySqlLikePtrn(otsitav); // koos eraldajatega
        msTing = "msid.ms_nos LIKE " + mySqlLikePtrn + " AND ";
    }

    var dicsTing = "";
    var seldDics = "";
    var allChecked = true;
    var checksTable = document.getElementById("tblDicChecks");
    var checks = checksTable.getElementsByTagName("INPUT");
    for (var ix = 0; ix < checks.length; ix++) {
        var check = checks[ix];
        if (check.type == "checkbox") {
            if (check.checked) {
                if (seldDics) {
                    seldDics += ",";
                }
                seldDics += "'" + check.getAttribute("dd") + "'";
            } else {
                allChecked = false;
            }
        }
    }
    if (!seldDics) {
        return;
    }
    if (!allChecked) {
        dicsTing = " AND msid.dic_code IN (" + seldDics + ")";
    }


    pagingPageNr = 1;

    var sqlCmd = "SELECT msid.ms AS ms, msid.vol_nr AS vol_nr, msid.dic_code AS dic_code, msid.ms_att_i AS ms_att_i, \
                    msid.ms_att_liik AS ms_att_liik, msid.G AS G \
                    FROM msid FORCE INDEX FOR ORDER BY (ix_nos_code_i) \
                    WHERE (" + msTing + "msid.vol_nr > 0" + dicsTing + ") \
                    ORDER BY msid.ms_nos, msid.dic_code, msid.ms_att_i";

    //    var sqlCmd = "SELECT msid.ms AS ms, msid.vol_nr AS vol_nr, msid.dic_code AS dic_code, msid.ms_att_i AS ms_att_i, \
    //                    msid.ms_att_liik AS ms_att_liik, msid.G AS G \
    //                    FROM msid \
    //                    WHERE (" + msTing + "msid.vol_nr > 0" + dicsTing + ")";

    sqlCmd = sqlCmd.replace(/\s+/g, " ");
    pagingSql = sqlCmd;
    sqlCmd += " LIMIT " + ((pagingPageNr - 1) * pagingRowsPerPage) + "," + pagingRowsPerPage;

    if (casState["ctrl"] && casState["shift"]) {
        alert(sqlCmd);
        return;
    }

    sCmdId = "ClientRead";
    var cmdXml = "<prm>" +
                    "<cmd>" + sCmdId + "</cmd>" +
                    "<sql>" + sqlCmd + "</sql>" +
                    "<scfr>SQL_CALC_FOUND_ROWS</scfr>" +
                "</prm>";

    var cmdXmlDom = IDD("String", cmdXml, false, false, null);
    if (!(cmdXmlDom && getXmlString(cmdXmlDom))) { // kui on viga, siis IE-s on xml=''
        alert("Viga 'cmdXmlDom'-s");
        return;
    }

    var pagingPealKiri = document.getElementById("spnPagingInfo");
    pagingPealKiri.innerHTML = "";

    StartOperation(cmdXmlDom);
} // otsing


//-----------------------------------------------------------------------------------
function StartOperation(oPrmDom) {
    //    dhxBar.disableItem("btnSrch");

    dtOpStart = new Date();
    if (!(sCmdId == "readArtXml")) {
        var pagingElapsed = document.getElementById("spnPagingElapsed");
        pagingElapsed.innerHTML = "";
    }
    dhxLayout.progressOn();
    QueryResponseAsync(oPrmDom);
} //StartOperation


//-----------------------------------------------------------------------------------
function asyncCompleted(objXMLDom) {
    if (!objXMLDom) {
        StopOperation();
        return;
    }

    ParseSrvInfo(objXMLDom);
    StopOperation();

} //asyncCompleted


//-----------------------------------------------------------------------------------
function StopOperation() {
    //    dhxBar.enableItem("btnSrch");

    dhxLayout.progressOff();
    var interval = (new Date().getTime() - dtOpStart.getTime());
    var seconds = Math.floor(interval / 1000);
    if (!(sCmdId == "readArtXml")) {
        var pagingElapsed = document.getElementById("spnPagingElapsed");
        pagingElapsed.innerHTML = "; (" + Math.floor(seconds / 60) + "m, " + (seconds % 60) + "s)";
    }
} //StopOperation


//-----------------------------------------------------------------------------------
function ParseSrvInfo(oRespDom) {
    var sta, cnt, fullCnt, vastus, ix;

    sta = getXmlNodeValue(oRespDom.documentElement.getElementsByTagName("sta")[0]);
    cnt = getXmlNodeValue(oRespDom.documentElement.getElementsByTagName("cnt")[0]);
    cnt = parseInt(cnt);
    if (sta == "Success") {
        if (sCmdId == "ClientRead") {
            fullCnt = getXmlNodeValue(oRespDom.documentElement.getElementsByTagName("fullCnt")[0]);
            if (fullCnt) { // kui oli esimene päring
                fullCnt = parseInt(fullCnt);
                pagingPageCount = Math.ceil(fullCnt / pagingRowsPerPage);
                var otsitav = jsTrim(dhxBarContent.getValue("txtElemOtsitav"));
                var pagingPealKiri = document.getElementById("spnPagingInfo");
                var nrStr = fullCnt.toLocaleString();
                if (nrStr.indexOf(".") > -1) {
                    nrStr = nrStr.substr(0, nrStr.indexOf("."));
                } else if (nrStr.indexOf(",") > -1) {
                    nrStr = nrStr.substr(0, nrStr.indexOf(","));
                }
                pagingPealKiri.innerHTML = opInfo + "'" + otsitav + "': " + nrStr + " märksõna";

                dhxBarPaging.forEachListOption("pageSelect", function (optionId) {
                    dhxBarPaging.removeListOption("pageSelect", optionId);
                });
                if (fullCnt > 0) {
                    for (ix = 0; ix < pagingPageCount; ix++) {
                        //                    addListOption(parentId, optionId, pos, type, text, img)
                        dhxBarPaging.addListOption("pageSelect", ix + 1, ix + 1, 'button', (ix + 1) + " lk.", null);
                    }
                } else {
                    dhxBarPaging.addListOption("pageSelect", 1, 1, 'button', "1. lk.", null);
                }
                setButtonSelectId(dhxBarPaging, "pageSelect", pagingPageNr, " / " + pagingPageCount + " lk.");
            }
            if (cnt == 0) {
                //                sbMain.setText("<img src='graphics/info.png' style='width:16px;'> " + sQryInfo + " - artikleid ei leitud [" + qM + "].");
                //            } else if (cnt == 1) {

                //                vastus = oRespDom.documentElement.getElementsByTagNameNS(DICURI, "A")[0];
                //                FillArtFrames(vastus, true);
                //                sbMain.setText("<img src='graphics/info.png' style='width:16px;'> " + sQryInfo + " - " + cnt + " artikkel [" + qM + "].");

            } else if (cnt > 0) {
                vastus = oRespDom.documentElement.getElementsByTagName("sr")[0];
                FillBrowseFrame(vastus);
                //                sbMain.setText("<img src='graphics/info.png' style='width:16px;'> " + sQryInfo + " - " + cnt + " artiklit [" + qM + "].");
            }
        } else if (sCmdId == "getRandomWord") {
            var w = getXmlSingleNodeValue(oRespDom.documentElement, "w");
            dhxBarContent.setValue("txtElemOtsitav", w);
        } else if (sCmdId == "srvSaveAs") {
            var zF = getXmlSingleNodeValue(oRespDom.documentElement, "zF");
            showZipDownLoad(zF);
        } else if (sCmdId == "readArtXml") {
            vastus = oRespDom.documentElement.getElementsByTagName("sr")[0];
            dhxLayout.cells("b").attachHTMLString(getXmlString(vastus));
        } else if (sCmdId == "readArtHtml") {
            vastus = getXmlSingleNode(oRespDom.documentElement, "sr").firstChild; // CDATA -> TextNode
            var artAsjad = vastus.nodeValue.split(JR); // CSS rules, html, hasHtml
            valaDiv.innerHTML = "";
            if (artAsjad[2]) {
                valaCss.cssText = artAsjad[0];
                valaDiv.innerHTML = artAsjad[1];
                if (artAsjad[2] == "0") { // et on salvestatud muus kui IE-s
                    valaDiv.style.backgroundColor = "HotPink"; // HotPink, LightCoral
                } else {
                    valaDiv.style.backgroundColor = bgColor;
                }
            }
        }
    }
    else {
        alert(getXmlString(oRespDom));
        return;
    }

} //ParseSrvInfo


//-----------------------------------------------------------------------------------
function showZipDownLoad(fileName) {
    var w = dhxLayout.cells("a").getWidth() + dhxLayout.cells("b").getWidth();
    var h = dhxLayout.cells("b").getHeight();
    var dhxWinParams = {
        id: "zipDownLoad",
        left: 0,
        top: 0,
        width: w / 2,
        height: h / 2,
        caption: "Lae loend alla",
        resize: false,
        move: false,
        park: false
    };
    var zdlWindow = dhxWins.createWindow(dhxWinParams);
    //            dhxWins.window("zipDownLoad").setToFullScreen(true);
    //            dhxWins.window("zipDownLoad").centerOnScreen();
    dhxWins.window("zipDownLoad").center();
    dhxWins.window("zipDownLoad").button("park").hide();
    dhxWins.window("zipDownLoad").button("minmax1").hide();
    dhxWins.window("zipDownLoad").setModal(true);
    //            dhxWins.window("zipDownLoad").maximize();
    //        dhxWins.window("zipDownLoad").keepInViewport(true);

    var myTable = document.createElement("table");
    myTable.style.width = "100%";
    myTable.style.height = "100%";
    var myRow = myTable.appendChild(document.createElement("tr"));
    var myCell = myRow.appendChild(document.createElement("td"));
    myCell.style.textAlign = "center";
    myCell.style.verticalAlign = "middle";

    var myHref = myCell.appendChild(document.createElement("a"));
    myHref.setAttribute("href", fileName);
    myHref.innerHTML = fileName.substr(fileName.indexOf('/') + 1);
    myHref.setAttribute("onclick", "parent.dhxWins.window(\"zipDownLoad\").close()");
    dhxWins.window("zipDownLoad").attachObject(myTable, true);
} // showZipDownLoad


//-----------------------------------------------------------------------------------
function setVala() {
    var ifr = dhxLayout.cells("b").getFrame();
    var ifrDoc;
    if (_isIE) {
        ifrDoc = ifr.contentWindow.document;
    } else {
        ifrDoc = ifr.contentDocument;
    }
    valaDiv = ifrDoc.getElementById("valaDiv");
    valaCss = ifrDoc.getElementById("valaCss");
    valaDoc = ifrDoc;
} // setVala


//-----------------------------------------------------------------------------------
function handleView(thisEvent) {

    var thisTarget = thisEvent.target ? thisEvent.target : thisEvent.srcElement;
    var oSrc = thisTarget;

    if (oSrc.tagName == "A") {

        if (!dhxWins.window("winTyybid")) {
            var w = dhxLayout.cells("a").getWidth() + dhxLayout.cells("b").getWidth();
            var h = dhxLayout.cells("b").getHeight();
            var dhxWinParams = {
                id: "winTyybid",
                left: 0,
                top: 0,
                width: w / 2,
                height: h / 2,
                caption: "Tüüpsõnad",
                resize: true,
                move: true,
                park: true
            };
            tyybidWindow = dhxWins.createWindow(dhxWinParams);
            //            dhxWins.window("winMorfSetup").setToFullScreen(true);
            //            dhxWins.window("winMorfSetup").centerOnScreen();
            dhxWins.window("winTyybid").center();
            //        dhxWins.window("winMorfSetup").button("minmax1").hide();
            //        dhxWins.window("winMorfSetup").setModal(true);
            //            dhxWins.window("winMorfSetup").maximize();
            dhxWins.window("winTyybid").keepInViewport(true);
        }

        if (dhxWins.window("winTyybid").isParked()) {
            dhxWins.window("winTyybid").park();
        }
        //        var href = oSrc.href;
        dhxWins.window("winTyybid").attachURL(oSrc.href, false); // false: mitte AJAX
        cancelThisEvent(thisEvent);
    } else if (oSrc.tagName == "IMG") {
        var tyyp = oSrc.getAttribute("tyyp");
        if (tyyp == "bingMaps") {
            var search = encodeURIComponent(oSrc.getAttribute("alt"));
            window.open("http://www.bing.com/maps/default.aspx?where1=" + search, "_bingMaps", "", false);
        }
    }

} //handleView


//-----------------------------------------------------------------------------------
function bodyOnResize() {
    dhxLayout.setSizes();
    dhxAccord.setSizes();
    artLayout.setSizes();
} // bodyOnResize


//-----------------------------------------------------------------------------------
function FillBrowseFrame(srNode) {

    brGrid.clearAll(); // deletes all rows in the grid (kui argumendiks on veel 'true', siis koos päisega)

    var artiklid = getXmlNodesSnapshot(srNode, "A"), artikleid = 0, ix, artikkel;
    if ('snapshotLength' in artiklid) {
        artikleid = artiklid.snapshotLength;
    } else if ('length' in artiklid) {
        artikleid = artiklid.length;
    }
    //    var rowsArr = new Array();
    var rowsXml = "<rows>";
    for (ix = 0; ix < artikleid; ix++) {
        if ('snapshotLength' in artiklid) {
            artikkel = artiklid.snapshotItem(ix);
        } else if ('length' in artiklid) {
            artikkel = artiklid[ix];
        }
        var ms = getXmlNodeValue(artikkel.getElementsByTagName("ms")[0]);
        var volNr = getXmlNodeValue(artikkel.getElementsByTagName("vol_nr")[0]);
        var dicCode = getXmlNodeValue(artikkel.getElementsByTagName("dic_code")[0]);
        var homNr = getXmlNodeValue(artikkel.getElementsByTagName("i")[0]);
        var liik = getXmlNodeValue(artikkel.getElementsByTagName("liik")[0]);
        var G = getXmlNodeValue(artikkel.getElementsByTagName("g")[0]);

        var volFile = dicCode + volNr;

        var kirjeNr = ((pagingPageNr - 1) * pagingRowsPerPage) + ix + 1;

        rowsXml += "<row id='" + kirjeNr + "'>";
        rowsXml += "<userdata name='artKeys'>" + volFile + ";" + G + "</userdata>";
        rowsXml += "<cell>" + kirjeNr + "</cell>";
        rowsXml += "<cell><![CDATA[<div style='color:maroon;'>" + entitiesToHtml(ms) + "</div>]]></cell>";
        rowsXml += "<cell>" + homNr + "</cell>";
        rowsXml += "<cell>" + liik + "</cell>";
        //        rowsXml += "<cell>[" + dicCode + "] " + dicDescsArr[dicCode] + "</cell>";
        rowsXml += "<cell><![CDATA[<span><span style='color:silver;width:100px;'>\[" + dicCode + "\]</span> <span>" + dicDescsArr[dicCode] + "</span></span>]]></cell>";
        rowsXml += "</row>";

        //        // grid.addRow(new_id, text, ind);
        //        brGrid.addRow((ix + 1), [(ix + 1), ms, homNr, liik, dicCode]);
        ////        brGrid.setCellTextStyle(loendur, 2, "text-decoration:underline;color:blue;cursor:pointer;");
        //        brGrid.setUserData((ix + 1), "artKeys", volFile + ";" + G);
        //        rowsArr.push([(ix + 1), ms, homNr, liik, dicCode]);
    }
    rowsXml += "</rows>";

    //    var ar = [[11, 12, 13], [21, 22, 23], [31, 32, 33]]
    //    brGrid.parse(rowsArr, "jsarray");

    brGrid.parse(rowsXml);

    //    sbMain.setText(artikleid);
} //FillBrowseFrame


//-----------------------------------------------------------------------------------
function gridOnRowSelect(rowId, colInd) {
    doBrowseRead(rowId, colInd);
} // gridOnRowSelect


//-----------------------------------------------------------------------------------
function gridOnRightClick(rowId, colInd, evntObj) {
} // gridOnRightClick


//-----------------------------------------------------------------------------------
function doBrowseRead(rowId, colInd) {
    var userdata = brGrid.getUserData(rowId, "artKeys");
    var udData = userdata.split(";");
    sCmdId = "readArtHtml";
    var cmdXml = "<prm>" +
            "<cmd>" + sCmdId + "</cmd>" +
            "<vol>" + udData[0] + "</vol>" +
            "<G>" + udData[1] + "</G>" +
        "</prm>";

    var cmdXmlDom = IDD("String", cmdXml, false, false, null);
    if (!(cmdXmlDom && getXmlString(cmdXmlDom))) { // kui on viga, siis IE-s on xml=''
        alert("Viga 'cmdXmlDom'-s");
        return;
    }
    StartOperation(cmdXmlDom);
} // doBrowseRead


//-----------------------------------------------------------------------------------
function setButtonSelectId(toolBar, buttonSelectId, listOptId, lisaInfo) {
    toolBar.setListOptionSelected(buttonSelectId, listOptId);
    var seldTekst = toolBar.getListOptionText(buttonSelectId, listOptId);
    toolBar.setItemText(buttonSelectId, seldTekst + lisaInfo);
} // setButtonSelectId

