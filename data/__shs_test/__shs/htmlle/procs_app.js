/**
* procs_app.js
* 
*
* @class procs_app
*/
//Copyright© 2006 - 2012. Andres Loopmann, EKI, andres.loopmann@eki.ee. All rights reserved.

/**
* 
* 
* @property PaljuProperteid
*/
var oXsdDOM;
var oXsdSc;
var oXsdNsm;
var sXsdNsList;
var oEditDOM;
var oEditDOMRoot;
var oXmlSc;
var oSchRootElems, oSchRootAttrs;
var oXmlNsm;
var sXmlNsList;
var oXsl1, oXsl2, oXsl3, oXslEdit, oXslView, oXslBrowse, oCopyView;
var gendXslStandard, gendXslNimi = '', xslViewName;
var oEditAll, oViewAll, oDbgTable;

var viewCSS, editCSS;

var sOrgMarkSona, sOrgHomnr;
var sMarkSona, sMSortVal, msAsendus, sFromVolume, sDeldVolId, sAllVolId;
var sTextToCopy;
var bArtModified;

var oElMenuTable;
var sCurrElemId, sSeldItemId, sSeldElemValue, sSeldAttrValue;

var dtOpStart, sQryInfo, sCmdId;
var browseDoc, nBrRowIndex;
var oBrowseNode, browseSortBy, browseSortOrder, filterBy;

//Word väljatrükk
var nStartPageNumber, bRemoveShaded, sWordFileName;

//edit stuff (vana)
var oClicked, oClickedBorder, trueIfrDocClick, contextClicked;
var clType, clEditable, scv, nodepath, elemlang;
var ivde, ivdebgc;
var clickedNode;
var selectedNode, snDecl, snQName, snKirjeldavQName, cmHeading;
var fatherNode, pnDecl;

var neElems, neAttribs;
var ptd;  //rakenduse peatoimetajad;
var zeus;  //see, kes KÕIKE peaks saama teha ...;
var eeLexAdmin, qryMethodOrg;

//edit värk
var oOrgArtNode, artOrgString, cpfragment, urfragment, urindex, urlast, urmax;

//art_le.cgi - st
var sUsrName, srTegija, dic_desc, sAppLang, sDicName;

var bArtSaveAllowed, bArtDelAllowed, bArtAddAllowed, bPrintToWordAllowed, bArtSignAllowed, bArtToolsEnabled, bSrToolsEnabled;
var artMuudatused;

//konfigureeritavad
var appDesc;
var DICPR;
var DICURI;
var dic_vols_count;
var default_query;
var first_default;
var qn_sort_attr;
var fakult, msLsp;
var mySqlDataVer;
var qn_ms, qn_homnr, qn_guid, qn_toimetaja, qn_tkp, qn_autor, qn_akp, qn_art;

//eelexSWCtl tarkvara
//"ma" - morfoloogiline analüüs, "ms" - morfoloogiline süntees
var setKeyboard, orgKBLayoutLang;
var doSpellCheck;
var useMorfo, ma_tul, ma_ls, ma_sqn, ma_vkkuju, ms_valtega, ms_vkkuju;


//üldstruktuur
var yldStruDom, strLangXsl, mnuElemLang;
var impSchemaLocations;

//keelekoodid, tõlkekeeled (need, mis on ISO 639-1 hulgast "palutud")
var rootLang;
var dest_language;  // <julius> sõnastiku teine keel;
var keelteValik;
var appKeeled = { "et": 0, "en": 1, "ru": 2 };


// märksõna keel (@xml:lang), tähestik
var msLang = '', msAlpha = '', msTranslSrc = '', msTranslDst = '';

// plokid, milledel on aT, aTA atribuudid (automaatse salvestusinfo jaoks)
var aTTAPlokid = '';

var textEditFont;
var asuKoht;
var brVer = "Unknown";


/**
* 
*
* @method bodyOnLoad
*/
function bodyOnLoad() {

    var fullAddress = window.location.href;

    asuKoht = fullAddress.substr(0, fullAddress.lastIndexOf("/") + 1); // koos '/'
    brVer = getBrowserData();

    selectedNode = null;

    //algus ---------------------------------------------------------------
    //algväärtused --------------------------------------------------------

    var i, tarr;
    tarr = spn_SrvParms.innerText.split("|");
    sUsrName = tarr[0];
    srTegija = jsStringToBoolean(tarr[1]);
    dic_desc = tarr[2];
    sAppLang = tarr[3];
    sDicName = tarr[4];

    bArtModified = false;

    //konfig
    var oConfigDOM = IDD("File", "shsconfig_" + dic_desc + ".xml", false, false, null);
    if ((oConfigDOM.parseError.errorCode != 0)) {
        ShowXMLParseError(oConfigDOM);
        return;
    }
    var cfgElem = oConfigDOM.documentElement.selectSingleNode("appDesc"); //'EXSA, EELex;
    if (!(cfgElem == null)) {
        appDesc = cfgElem.text;
    } else {
        appDesc = "";
    }

    DICPR = oConfigDOM.documentElement.selectSingleNode("dicpr").text;
    DICURI = oConfigDOM.documentElement.selectSingleNode("dicuri").text;
    dic_vols_count = oConfigDOM.documentElement.selectNodes("vols/vol").length;

    default_query = oConfigDOM.documentElement.selectSingleNode("default_query").text;
    first_default = oConfigDOM.documentElement.selectSingleNode("first_default").text;

    qn_sort_attr = oConfigDOM.documentElement.selectSingleNode("qn_sort_attr").text;

    //muidu märksõna <m>, hariduses nt <ter>
    qn_ms = jsMid(default_query, default_query.lastIndexOf("/") + 1);

    qn_homnr = DICPR + ":i";
    qn_guid = DICPR + ":G";
    qn_toimetaja = DICPR + ":T";
    qn_tkp = DICPR + ":TA";
    qn_autor = DICPR + ":K";
    qn_akp = DICPR + ":KA";
    qn_art = DICPR + ":A";

    neElems = oConfigDOM.documentElement.selectSingleNode("neelems").text;
    neAttribs = oConfigDOM.documentElement.selectSingleNode("neattribs").text;

    //rootLang: ainult xsl2 genereerimisel, ka editDom moodustamisel, kui ag_sr pole
    rootLang = "et";
    cfgElem = oConfigDOM.documentElement.selectSingleNode("rootLang");
    if (cfgElem) {
        rootLang = cfgElem.text;
    }

    // <julius> kui sõnastiku teine keel on määratud, võtame selle
    cfgElem = oConfigDOM.documentElement.selectSingleNode("destLang");
    dest_language = "";
    if (cfgElem) {
        dest_language = cfgElem.text;
    }
    //destLang: ainult loendite menüüdes sihtkeeles
    if (dest_language == "et") { //'nt Pärtel Lippus: Inglise-eesti foneetika terminite sõnastik
        if ((sAppLang == "et")) {
            dest_language = "";
        }
    }
    // ======================================================================================================
    // ats+++  (28.11.2012/12.12.2012)
    // ======================================================================================================
    atsGendViewConfYes();
    //ats


    msAlpha = "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsŠšZzŽžTtUuVvWwÕõÄäÖöÜüXxYy";
    cfgElem = oConfigDOM.documentElement.selectSingleNode("msLang");
    if (cfgElem) {
        msLang = cfgElem.text;
    }
    if (msLang) {
        cfgElem = oConfigDOM.documentElement.selectSingleNode("msAlpha");
        if (cfgElem) {
            msAlpha = cfgElem.text;
        }
        else {
            alert("Märksõna keel olemas ('" + msLang + "'), kuid puudub tähestik!");
            return;
        }
        cfgElem = oConfigDOM.documentElement.selectSingleNode("msTranslSrc");
        if (cfgElem)
            msTranslSrc = cfgElem.text;
        cfgElem = oConfigDOM.documentElement.selectSingleNode("msTranslDst");
        if (cfgElem)
            msTranslDst = cfgElem.text;
    }

    //Morfoloogia
    cfgElem = oConfigDOM.documentElement.selectSingleNode("cfgUseMorfo");
    if (cfgElem) {
        useMorfo = jsStringToBoolean(cfgElem.text);
    } else {
        useMorfo = false;
    }
    //morfoloogia sätted: analüüs
    ma_tul = 0;
    ma_ls = 0;
    ma_sqn = 0;
    ma_vkkuju = 0;
    //morfoloogia sätted: süntees
    ms_valtega = 0;
    ms_vkkuju = 0;
    if (useMorfo) {
        //analüüs;
        cfgElem = oConfigDOM.documentElement.selectSingleNode("morf_ana/tul"); //'tuletusega;
        if (!(cfgElem == null)) {
            ma_tul = parseInt(cfgElem.text);
        }
        cfgElem = oConfigDOM.documentElement.selectSingleNode("morf_ana/ls"); //'liitsõna oletusega;
        if (!(cfgElem == null)) {
            ma_ls = parseInt(cfgElem.text);
        }
        cfgElem = oConfigDOM.documentElement.selectSingleNode("morf_ana/sqn"); //'sõnastikuga;
        if (!(cfgElem == null)) {
            ma_sqn = parseInt(cfgElem.text);
        }
        cfgElem = oConfigDOM.documentElement.selectSingleNode("morf_ana/vkkuju"); //'vormikoodi kuju;
        if (!(cfgElem == null)) {
            ma_vkkuju = parseInt(cfgElem.text);
        }
        //süntees;
        cfgElem = oConfigDOM.documentElement.selectSingleNode("morf_syn/valde"); //'süntees välte märkimisega;
        if (!(cfgElem == null)) {
            ms_valtega = parseInt(cfgElem.text);
        }
        cfgElem = oConfigDOM.documentElement.selectSingleNode("morf_syn/svkkuju"); //'vormikoodi kuju sünteesil;
        if (!(cfgElem == null)) {
            //sünteesi korral on parameeter teise jrk-ga, shsconfig-is on mõlemad analüüsi moodi;
            ms_vkkuju = (parseInt(cfgElem.text) + 2) % 3;
        }
    }


    var xh, oRespDom, sta;
    //ptd - peatoimetajad
    if (appDesc == "EXSA") {
        xh = exCGISync("tools.cgi", "exsaGetField" + JR + dic_desc + JR + sUsrName + JR + "" + JR + "items/item[@code = '" + dic_desc + "']/ptd");
        if (xh.statusText == "OK") {
            oRespDom = xh.responseXML;  //responseXML: TypeName = DomDocument;
            sta = oRespDom.selectSingleNode("rsp/sta").text;
            if (sta == "Success") {
                ptd = oRespDom.selectSingleNode("rsp/answer").text;
            } else {
                alert("Väärtuste leidmine ei õnnestunud!", jsvbCritical, document.title);
                return;
            }
        } else {
            alert(xh.status + ": " + xh.statusText + '\r\n\r\n' + xh.responseText, jsvbCritical);
            return;
        }
    } else {
        cfgElem = oConfigDOM.documentElement.selectSingleNode("ptd");
        if (!(cfgElem == null)) {
            ptd = cfgElem.text;
        } else {
            ptd = "";
        }
        cfgElem = oConfigDOM.documentElement.selectSingleNode("zeus"); //'super parandajad;
        if (!(cfgElem == null)) {
            zeus = cfgElem.text;
        } else {
            zeus = "";
        }
    }

    var shsConf = IDD("File", "shsConfig.xml", false, false, null);
    eeLexAdmin = shsConf.documentElement.selectSingleNode("eeLexAdmin").text;

    qryMethodOrg = "XML";
    var shsConfQmMySql = shsConf.documentElement.selectSingleNode("qmMySql").text;
    if (shsConfQmMySql.indexOf(';' + dic_desc + ';') > -1) {
        qryMethodOrg = "MySql";
    }

    bArtSaveAllowed = false;
    bArtSignAllowed = false;
    bArtDelAllowed = false;
    bArtAddAllowed = false;
    bPrintToWordAllowed = false;
    bArtToolsEnabled = false;
    bSrToolsEnabled = false;

    if (srTegija) {
        if (!(dic_desc == "od_")) {
            bArtAddAllowed = true;
        }
        if (ptd.indexOf(";" + sUsrName + ";") > -1 || eeLexAdmin.indexOf(";" + sUsrName + ";") > -1) {
            bArtSignAllowed = true;
        }
        bPrintToWordAllowed = true;
    }

    fakult = oConfigDOM.documentElement.selectSingleNode("fakult").text;
    msLsp = "";
    cfgElem = oConfigDOM.documentElement.selectSingleNode("msLsp");
    if (!(cfgElem == null)) {
        msLsp = cfgElem.text;
    }
    mySqlDataVer = "";
    cfgElem = oConfigDOM.documentElement.selectSingleNode("mySqlDataVer");
    if (!(cfgElem == null)) {
        mySqlDataVer = cfgElem.text;
    }

    cfgElem = oConfigDOM.documentElement.selectSingleNode("do_spellcheck");
    if (!(cfgElem == null)) {
        doSpellCheck = jsStringToBoolean(cfgElem.text);
    } else {
        doSpellCheck = false;
    }
    cfgElem = oConfigDOM.documentElement.selectSingleNode("cfgSetKeyboard");
    if (!(cfgElem == null)) {
        setKeyboard = jsStringToBoolean(cfgElem.text);
    } else {
        setKeyboard = false;
    }

    cfgElem = oConfigDOM.documentElement.selectSingleNode("teade");
    if (!(cfgElem == null)) {
        if ((cfgElem.text.length > 0)) {
            alert(cfgElem.text, vbInformation, "Teade");
        }
    }

    cfgElem = oConfigDOM.documentElement.selectSingleNode("colorsFonts/editArea/editFont");
    if (cfgElem) {
        textEditFont = cfgElem.text;
    }

    oConfigDOM = null;


    orgKBLayoutLang = "";
    if (setKeyboard) {
        try {
            //orgKBLayoutLang = eelexSWCtl.getKBLayoutLang();
        }
        catch (e) {
            alert(e.name + " 0x" + hex(e.number, true) + ": '" + e.description + "'.");
        }
    }

    sDeldVolId = dic_desc + "0";
    sAllVolId = dic_desc + "All";


    //skeem, üldstruktuur, strLang ---------------------------------------------------------------
    //---------------------------------------------------------------------

    var sXSDFile, sPr;
    sXSDFile = "xsd/schema_" + dic_desc + ".xsd";

    oXsdDOM = IDD("File", sXSDFile, false, false, null);
    if ((oXsdDOM.parseError.errorCode != 0)) {
        ShowXMLParseError(oXsdDOM);
        return;
    }

    oXsdNsm = new ActiveXObject("Msxml2.MXNamespaceManager.6.0");
    oXsdNsm.allowOverride = true;
    var oNsNodeList = oXsdDOM.documentElement.selectNodes("namespace::*");
    for (i = 0; i < oNsNodeList.length; i++) {
        if ((oNsNodeList[i].prefix != "")) {
            if ((oNsNodeList[i].baseName != "xml")) {
                oXsdNsm.declarePrefix(oNsNodeList[i].baseName, oNsNodeList[i].value);
            }
        }
    }

    sXsdNsList = "";
    for (i = 0; i < oXsdNsm.getDeclaredPrefixes.length; i++) {
        sPr = oXsdNsm.getDeclaredPrefixes[i];
        if ((sPr != "xml")) {
            sXsdNsList = sXsdNsList + " xmlns:" + sPr + "='" + oXsdNsm.getURI(sPr) + "'";
        }
    }
    oXsdDOM.setProperty("SelectionLanguage", "XPath");
    oXsdDOM.setProperty("SelectionNamespaces", jsTrim(sXsdNsList));

    oXsdSc = new ActiveXObject("Msxml2.XMLSchemaCache.6.0");
    oXsdSc.validateOnLoad = true;
    oXsdSc.add(DICURI, sXSDFile);


    //imporditud skeemide asukohad, tõlkekeeled
    keelteValik = new Array();
    impSchemaLocations = new ActiveXObject("Scripting.Dictionary");
    var xsdImports = oXsdDOM.documentElement.selectNodes(NS_XS_PR + ":import");
    for (i = 0; i < xsdImports.length; i++) {
        var locn = xsdImports[i].getAttribute("schemaLocation");
        impSchemaLocations.Add(xsdImports[i].getAttribute("namespace"), locn);
        if ((jsLeft(locn, 4) == dic_desc + "/")) { //'asub tüüpide DOM-is;
            updKeelteValik(locn);
        }
    }
    xsdImports = null;


    //üldstruktuur
    yldStruDom = IDD("File", "xml/" + dic_desc + "/stru_" + dic_desc + ".xml", false, false, oXsdSc);
    if (yldStruDom.parseError.errorCode != 0) {
        yldStruDom = null;
    } else {
        yldStruDom.setProperty("SelectionLanguage", "XPath");
        yldStruDom.setProperty("SelectionNamespaces", jsTrim(sXsdNsList) + " xmlns:" + SDPR + "='" + SDURI + "'");
    }
    //strLang
    //resolveExternals = true, include/import pärast ...
    strLangXsl = IDD("File", "xsl/tools/strLang.xsl", true, false, null);
    if ((strLangXsl.parseError.errorCode != 0)) {
        ShowXMLParseError(strLangXsl);
        return;
    }


    // <?xml version="1.0" encoding="UTF-8"?>
    oEditDOM = IDD("String", "<" + DICPR + ":sr xmlns:" + DICPR + "=\"" + DICURI + "\" xml:lang=\"" + rootLang + "\"/>", false, false, oXsdSc);
    if (oEditDOM.parseError.errorCode != 0) {
        ShowXMLParseError(oEditDOM);
        return;
    }
    oEditDOMRoot = oEditDOM.documentElement;

    oXmlNsm = new ActiveXObject("Msxml2.MXNamespaceManager.6.0");
    oXmlNsm.allowOverride = true;
    oNsNodeList = oEditDOMRoot.selectNodes("namespace::*");
    for (i = 0; i < oNsNodeList.length; i++) {
        if ((oNsNodeList[i].prefix != "")) {
            if ((oNsNodeList[i].baseName != "xml")) {
                oXmlNsm.declarePrefix(oNsNodeList[i].baseName, oNsNodeList[i].value);
            }
        }
    }

    oXmlSc = oEditDOM.namespaces;

    sXmlNsList = "";
    for (i = 0; i < oXmlNsm.getDeclaredPrefixes.length; i++) {
        sPr = oXmlNsm.getDeclaredPrefixes[i];
        if (sPr != "xml") {
            sXmlNsList = sXmlNsList + " xmlns:" + sPr + "='" + oXmlNsm.getURI(sPr) + "'";
        }
    }
    sXmlNsList = jsTrim(sXmlNsList) + " xmlns:" + NS_XS_PR + "='" + NS_XS + "' xmlns:" + NS_XSL_PR + "='" + NS_XSL + "' xmlns:pref='" + DICURI + "'";

    oEditDOM.setProperty("SelectionLanguage", "XPath");
    oEditDOM.setProperty("SelectionNamespaces", sXmlNsList);

    oSchRootElems = oXmlSc.getSchema(DICURI).elements;
    oSchRootAttrs = oXmlSc.getSchema(DICURI).attributes;


    if (!(document.all("img_SrTools") == null)) {
        bSrToolsEnabled = true;
        sqnastikuTooriistad();  //fillSrToolsMenu();
    }


    //XSLT teisendused paika
    //toimetamisala XSLT-d
    //resolveExternals = true, include/import pärast ...
    oXsl1 = IDD("File", "xsl/xsl1.xsl", true, false, null);
    if ((oXsl1.parseError.errorCode != 0)) {
        ShowXMLParseError(oXsl1);
        return;
    }
    oXsl1.setProperty("AllowXsltScript", true);


    initEditTransform();


    gendXslStandard = "gendView_" + dic_desc;
    if (gendXslNimi == "") { // mingi cookie, mis salvestaks "gendXslNimi", pärast
        gendXslNimi = gendXslStandard;
    }
    xslViewName = gendXslNimi;

    viewCSS = document.styleSheets[2];

    initViewTransform(1);

    if (!oXslView) { // kui ei saanud, siis vana, käsitsi tehtud
        xslViewName = "view_" + dic_desc;
        oXslView = IDD("File", "xsl/" + xslViewName + ".xsl", true, false, null);
        if (oXslView.parseError.errorCode != 0) {
            ShowXMLParseError(oXslView);
            return;
        }
        oXslView.setProperty("AllowXsltScript", true);
        oXslView.setProperty("SelectionLanguage", "XPath");
        oXslView.setProperty("SelectionNamespaces", sXmlNsList);

        var ruled = viewCSS.rules;
        //vaate genereerimise ajal tehakse küll juba ära, aga kõikide jaoks ei ole genereeritud ...;
        var itad = "";
        for (i = 0; i < ruled.length; i++) {
            if ((ruled[i].style.fontStyle).toLowerCase() == "italic") {
                // .etvw_hld, .etvw_k, .etvw_k1, .etvw_k2, .etvw_sl, ...
                if (ruled[i].selectorText.substr(0, 1) == ".") {
                    itad += ";" + ruled[i].selectorText.substr(1);
                } else {
                    itad += ";" + ruled[i].selectorText;
                }
            }
        }
        if (itad) {
            itad = itad + ";";
            oXslView.documentElement.selectSingleNode(NS_XSL_PR + ":variable[@name = 'itad']").text = itad;
        }

        oXsl3 = oXslView.cloneNode(true);
        oXsl3.documentElement.selectSingleNode(NS_XSL_PR + ":variable[@name = 'edMode']").text = "1"
    }


    //otsingu tulemuste lehitsemise XSLT
    //resolveExternals = true, include/import pärast ...
    oXslBrowse = IDD("File", "xsl/browse2.xsl", true, false, null);
    if ((oXslBrowse.parseError.errorCode != 0)) {
        ShowXMLParseError(oXslBrowse);
        return;
    }
    oXslBrowse.setProperty("AllowDocumentFunction", true);
    oXslBrowse.setProperty("AllowXsltScript", true);
    oXslBrowse.setProperty("SelectionLanguage", "XPath");
    oXslBrowse.setProperty("SelectionNamespaces", sXmlNsList);

    browseDoc = document.frames("frame_Browse").document;

    //avaldised
    PaneEkspressioonid();

    oEditAll = divFrameEdit.all;
    oViewAll = divFrameView.all;

    oDbgTable = frame_dbgPrint.document.all("varsTable");

    showDbgVar("ptd", ptd, "bodyOnLoad", " ", " ", new Date());

    cpfragment = oEditDOM.createDocumentFragment();

    ivde = null;
    trueIfrDocClick = true;
    urmax = 15;

    FillInsertSymbolsMenu();
    FillElementsMenu();

    //märksõna JA @soov korral on nt nii:
    //SetSelectedInfo("q:A/q:P/q:mg/q:m/@q:soov", "q:soov|soov|" + DICURI + "|1")
    //veel:
    //SetSelectedInfo("q:A/q:P/q:mg/q:grg/q:s1", "")
    //SetSelectedInfo("q:A/q:P/q:mg/q:grg/q:s1/@q:levik", "q:levik|levik|" + DICURI + "|1")

    SetSelectedInfo(default_query, "");

    xh = exCGISync("tools.cgi", "appOpen" + PD + dic_desc + PD + sUsrName + PD + brVer);
    if (xh.statusText == "OK") {
        oRespDom = IDD("", "", false, false, null);
        sta = oRespDom.load(xh.responseXML); //'responseXML: TypeName = DomDocument
        if (sta) {
            var opStatus = oRespDom.selectSingleNode("rsp/sta").text;
            if (opStatus == "Success") {
            } else {
            }
        }
    }

} //bodyOnLoad

/**
* 
*
* @method initEditTransform
*/
function initEditTransform() {

    // toimetamisala XSLT
    //resolveExternals = true, include/import pärast ...
    var editGend = true;
    oXsl2 = IDD("File", "xsl/gendXsl2_" + dic_desc + ".xsl", true, false, null);
    if (oXsl2.parseError.errorCode != 0) {
        oXsl2 = IDD("File", "xsl/xsl2_" + dic_desc + "_" + sAppLang + ".xsl", true, false, null);
        if ((oXsl2.parseError.errorCode != 0)) {
            ShowXMLParseError(oXsl2);
            return;
        }
        editGend = false;
    }

    oXsl2.setProperty("AllowXsltScript", true);
    oXsl2.setProperty("AllowDocumentFunction", true);
    oXsl2.setProperty("SelectionLanguage", "XPath");
    oXsl2.setProperty("SelectionNamespaces", sXmlNsList);

    // gend
    var cfgElem = oXsl2.documentElement.selectSingleNode(NS_XSL_PR + ":variable[@name = 'appLang']");
    if (cfgElem)
        cfgElem.text = sAppLang;

    oXslEdit = oXsl2;

    if (editGend)
        document.styleSheets[1].href = "css/gendEdit_" + dic_desc + ".css";

    editCSS = document.styleSheets[1];

} //initEditTransform


/**
* 
*
* @method initViewTransform
* @param {Boolean} vaateValik
*/
function initViewTransform(vaateValik) {

    //resolveExternals = true, include/import pärast ...
    oXslView = IDD("File", "xsl/" + gendXslNimi + ".xsl", true, false, null);
    if (oXslView.parseError.errorCode != 0) {
        gendXslNimi = gendXslStandard;
        xslViewName = gendXslNimi;
        oXslView = IDD("File", "xsl/" + gendXslNimi + ".xsl", true, false, null);
        if (oXslView.parseError.errorCode != 0) {
            //            ShowXMLParseError(oXslView);
            oXslView = null;
            return;
        }
    }

    oXslView.setProperty("AllowXsltScript", true);
    oXslView.setProperty("SelectionLanguage", "XPath");
    oXslView.setProperty("SelectionNamespaces", sXmlNsList);

    //    var viewCssNr = Math.floor(Math.random() * 4000000000);
    //    viewCSS.href = "css/" + gendXslNimi + ".css?p=" + viewCssNr; // val1257(gendXslNimi)

    var d = new Date();
    // The getTime method returns an integer value representing the number of milliseconds between midnight, 
    // January 1, 1970 and the time value in the Date object
    var t = Math.floor(d.getTime() / 1000);
    viewCSS.href = "css/" + gendXslNimi + ".css?p=" + t;

    var xh, rspDOM, loadStatus, sta, ix;

    //    // pole olemas mingit CSS refresh võimalust, seega loe alati
    //    xh = exCGISync("tools.cgi", "getTextFileContent" + JR + dic_desc + JR + sUsrName + JR +
    //                        "css/" + gendXslNimi + ".css");
    //    if (xh.statusText == "OK") {
    //        rspDOM = IDD("", "", false, false, null);
    //        loadStatus = rspDOM.load(xh.responseXML); //'responseXML: TypeName = DomDocument

    //        if (loadStatus) {
    //            sta = rspDOM.selectSingleNode("rsp/sta").text;
    //            if (sta == "Success") {
    //                var myCSS = rspDOM.selectSingleNode("rsp/answer").text;
    //                viewCSS.cssText = myCSS;
    //            }
    //            else
    //                alert(sta);
    //        }
    //    }
    //    else {
    //        alert(xh.status + ": " + xh.statusText + xh.responseText);
    //    }


    if (vaateValik) {
        xh = exCGISync("tools.cgi", "getFiles" + JR + dic_desc + JR + sUsrName + JR +
                        "xsl/" + JR +
                        gendXslStandard + "*.xsl");

        if (xh.statusText == "OK") {
            rspDOM = IDD("", "", false, false, null);
            loadStatus = rspDOM.load(xh.responseXML); //'responseXML: TypeName = DomDocument

            if (loadStatus) {
                while (sel_Vaated.options.length > 0) {
                    sel_Vaated.options.remove(0);
                }

                var fNodes = rspDOM.selectNodes("rsp/outDOM/f");
                for (ix = 0; ix < fNodes.length; ix++) {
                    var opt = document.createElement("OPTION");
                    sel_Vaated.options.add(opt);
                    var tekst = fNodes[ix].text;
                    opt.id = tekst;
                    var n = tekst.substr(0, tekst.lastIndexOf("."));
                    if (n == gendXslNimi) {
                        opt.selected = true;
                    }
                    if (n == gendXslStandard) {
                        opt.innerHTML = "Standard";
                    } else {
                        opt.innerHTML = n.substr(gendXslStandard.length + 1); // allkriips alguses
                    }
                }
                if (sel_Vaated.options.length > 1) {
                    sel_Vaated.style.visibility = "visible";
                }
                else {
                    sel_Vaated.style.visibility = "hidden";
                }
            }
            else {
                alert(xh.status + ": " + xh.statusText + xh.responseText);
            }
        }
        else {
            alert(xh.status + ": " + xh.statusText + xh.responseText);
        }
    }

    //piltide kontekst, pildiJuurikas
    var xslNode = oXslView.documentElement.selectSingleNode(NS_XSL_PR + ":variable[@name = 'pildiJuurikas']");
    if (xslNode) {
        xslNode.text = asuKoht + "__sr/";
    }

    oXsl3 = oXslView.cloneNode(true);
    oXsl3.documentElement.selectSingleNode(NS_XSL_PR + ":variable[@name = 'edMode']").text = "1"

} //initViewTransform


/**
* 
*
* @method xslViewSelected
*/
function xslViewSelected() {
    var xslNimi = sel_Vaated.options(sel_Vaated.selectedIndex).id;
    var n = xslNimi.substr(0, xslNimi.lastIndexOf("."));
    gendXslNimi = n;
    initViewTransform(null);
    if (oEditDOMRoot.hasChildNodes())
        vaatedRefresh(1);
} // xslViewSelected


/**
* 
*
* @method PaneEkspressioonid
*/
function PaneEkspressioonid() {

    //kõik asjad toimetamisalas peale td_UndoRedoNumbers, img_Undo ning img_Redo
    //on alguses disabled ning style="visibility:hidden",
    //td_UndoRedoNumbers, img_Undo, img_Redo on ainult style="visibility:hidden",
    //samuti on xsl1Edit, xsl2Edit, xsl3Edit ainult style="visibility:hidden"

    img_ArtAdd.setExpression("disabled", "(bArtAddAllowed) ? false : true", "JScript");
    img_ArtAdd.style.setExpression("visibility", "(bArtAddAllowed) ? 'visible' : 'hidden'", "JScript")

    img_ArtExport.setExpression("disabled", "(bPrintToWordAllowed) ? false : true", "JScript");
    img_ArtExport.style.setExpression("visibility", "(bPrintToWordAllowed) ? 'visible' : 'hidden'", "JScript")

    if (!(document.all("img_SrTools") == null)) {
        img_SrTools.setExpression("disabled", "(bSrToolsEnabled) ? false : true", "JScript");
        img_SrTools.style.setExpression("visibility", "(bSrToolsEnabled) ? 'visible' : 'hidden'", "JScript");
    }
    if (!(document.all("img_ArtTools") == null)) {
        img_ArtTools.setExpression("disabled", "(bArtToolsEnabled && oEditDOMRoot.hasChildNodes()) ? false : true", "JScript");
        img_ArtTools.style.setExpression("visibility", "(bArtToolsEnabled && oEditDOMRoot.hasChildNodes()) ? 'visible' : 'hidden'", "JScript");
    }

    img_ArtValidate.setExpression("disabled", "(srTegija && oEditDOMRoot.hasChildNodes()) ? false : true", "JScript");
    img_ArtValidate.style.setExpression("visibility", "(srTegija && oEditDOMRoot.hasChildNodes()) ? 'visible' : 'hidden'", "JScript")

    //salvestamise ja kustutamise võimalused on artiklipõhjased
    //ning pannakse paika xmlChanged-is oEditDOMRoot.hasChildNodes() alusel
    img_ArtSave.setExpression("disabled", "(bArtSaveAllowed) ? false : true", "JScript");
    img_ArtSave.style.setExpression("visibility", "(bArtSaveAllowed) ? 'visible' : 'hidden'", "JScript")

    img_ArtDelete.setExpression("disabled", "(bArtDelAllowed) ? false : true", "JScript");
    img_ArtDelete.style.setExpression("visibility", "(bArtDelAllowed) ? 'visible' : 'hidden'", "JScript");
    img_ArtDelete.setExpression("src", "(sFromVolume == sDeldVolId) ? 'graphics/backtolist 16-16.ico' : 'graphics/delart 16-16.ico'", "JScript")

    td_UndoRedoNumbers.style.setExpression("visibility", "(oEditDOMRoot.hasChildNodes()) ? 'visible' : 'hidden'", "JScript")

    //disabled ja src sõltuvad neil olukorrast
    img_Undo.style.setExpression("visibility", "(oEditDOMRoot.hasChildNodes()) ? 'visible' : 'hidden'", "JScript");
    img_Redo.style.setExpression("visibility", "(oEditDOMRoot.hasChildNodes()) ? 'visible' : 'hidden'", "JScript")

    xsl1Edit.style.setExpression("visibility", "(oEditDOMRoot.hasChildNodes()) ? 'visible' : 'hidden'", "JScript");
    xsl2Edit.style.setExpression("visibility", "(oEditDOMRoot.hasChildNodes()) ? 'visible' : 'hidden'", "JScript");
    xsl3Edit.style.setExpression("visibility", "(oEditDOMRoot.hasChildNodes()) ? 'visible' : 'hidden'", "JScript")

    xsl1Edit.style.setExpression("backgroundColor", "(oXslEdit === oXsl1) ? 'silver' : 'seashell'", "JScript");
    xsl2Edit.style.setExpression("backgroundColor", "(oXslEdit === oXsl2) ? 'silver' : 'seashell'", "JScript");
    xsl3Edit.style.setExpression("backgroundColor", "(oXslEdit === oXsl3) ? 'silver' : 'seashell'", "JScript")

    //esimene ja viimane artikkel jäävad SP-st välja
    img_readFirst.style.setExpression("display", "(dic_desc == 'sp_') ? 'none' : ''", "JScript");
    img_readLast.style.setExpression("display", "(dic_desc == 'sp_') ? 'none' : ''", "JScript");
    if ((dic_desc == "sp_")) {
        img_readFirst.parentElement.style.width = 1;
        img_readLast.parentElement.style.width = 1;
    }
    //kinni/lahti nupp on esialgu ainult 'sp_'
    img_ExpandCollapse.style.setExpression("display", "(dic_desc == 'sp_' && oEditDOMRoot.hasChildNodes()) ? '' : 'none'", "JScript");
    if ((dic_desc == "sp_")) {
        img_ExpandCollapse.setExpression("src", "(oEditDOMRoot.selectSingleNode('.//*[@p:edO = \"0\"]')) ? 'graphics/112_Plus_Orange_16x16_72.png' : 'graphics/112_Minus_Orange_16x16_72.png'", "JScript");
    }

    //Vaates
    img_AlignLeft.style.setExpression("visibility", "(oEditDOMRoot.hasChildNodes()) ? 'visible' : 'hidden'", "JScript");
    img_AlignCenter.style.setExpression("visibility", "(oEditDOMRoot.hasChildNodes()) ? 'visible' : 'hidden'", "JScript");
    img_AlignRight.style.setExpression("visibility", "(oEditDOMRoot.hasChildNodes()) ? 'visible' : 'hidden'", "JScript");
    img_AlignJustify.style.setExpression("visibility", "(oEditDOMRoot.hasChildNodes()) ? 'visible' : 'hidden'", "JScript");
    img_ArtPrint.style.setExpression("visibility", "(oEditDOMRoot.hasChildNodes()) ? 'visible' : 'hidden'", "JScript")

} //PaneEkspressioonid


/**
* 
*
* @method GetQueryParams
* @param {String} qryMethod
* @returns {Object} oPrmDom
*/
function GetQueryParams(qryMethod) {

    var withCase, withSymbols;
    var ft, fa;

    withSymbols = 0;
    if (inp_UseSymbols.checked) {
        withSymbols = 1;
    } else {
        if (inp_UseFakult.checked) {
            withSymbols = -1;
        }
    }

    withCase = 1;
    if (inp_UseCase.checked) {
        withCase = 0;
    }

    if (withSymbols < 1) {
        ft = jsTrim(inp_ElemText.value);
        fa = jsTrim(inp_AttrText.value);
    } else {
        ft = inp_ElemText.value;
        fa = inp_AttrText.value;
    }

    //Otsitav element (atribuut) ja sSeldItemId, sSeldElemValue, sSeldAttrValue saadakse järgmiselt:
    //
    //ChooseElement -> ShowElemsMenu -> SwitchElemsMenu -> ClickElemsMenu ->
    //SetSelectedInfo -> HideDivMenu
    //
    //div_ElemsMenu ja div_AttrsMenu <tr>:
    //class = 'mi'; id = sFullPath; value = 'qname|name|URI|IsElement|kirjeldav'

    var aElemInfo, aAttrInfo, sNodeTest, qt, qtMySql, seldQn, artRada, elemRada, evPath;
    var otsitavInfo;
    var tarr, i, rb;
    aElemInfo = sSeldElemValue.split("|");
    seldQn = aElemInfo[0]

    //qt: .//text(), self::node(), text()
    qt = sel_queryType.options(sel_queryType.selectedIndex).id;
    if (qt == ".//text()") {
        qtMySql = "//text()";
    } else if (qt == "self::node()") {
        qtMySql = "//text()";
    } else if (qt == "text()") {
        qtMySql = "/text()";
    }

    //sNodeTest algab artiklist: "q:A/..." jne
    if (sSeldAttrValue != "") {
        sNodeTest = jsMid(sSeldItemId, 0, sSeldItemId.lastIndexOf("/"));
    } else {
        sNodeTest = sSeldItemId;
    }

    //sNodeTest algab artiklist: "q:A/..." jne
    artRada = qn_art;
    evPath = sNodeTest;
    if (sNodeTest == artRada) { //A
        elemRada = "";
    } else {
        if (inp_UseGlobal.checked) {
            elemRada = ".//" + seldQn;
            if (dic_desc == 'ss1' && seldQn == qn_ms) {
                // name() ja local-name() ei kehti MySql XPath-is
                elemRada = ".//*[self::s:m or self::s:tul or self::s:mm or self::s:rv]";
            }
            evPath = elemRada;
        } else {
            elemRada = jsMid(sNodeTest, sNodeTest.indexOf("/") + 1); //'q:A/...;
        }
    }

    if (aElemInfo[3] == "1") { //'"päris" elemendid, mitte koondpäringud
        if (sNodeTest == artRada) {
            otsitavInfo = artRada;
        } else {
            otsitavInfo = elemRada;
        }
    } else {
        //        otsitavInfo = jsMid(sNodeTest, 4); //q:A/...;
        otsitavInfo = "'salvestatud päring'";
    }

    if (sSeldAttrValue != "") {
        sQryInfo = "[" + aElemInfo[4] + " (" + otsitavInfo + ") [ '" + ft + "' (↔: " + ft.length + ")][" + jsMid(sSeldItemId, sSeldItemId.lastIndexOf("/") + 1) + ": '" + fa + "']]";
    } else {
        sQryInfo = "[" + aElemInfo[4] + " (" + otsitavInfo + ") [ '" + ft + "' (↔: " + ft.length + ")]]";
    }
    if (!inp_UseSymbols.checked) {
        if (inp_UseCase.checked) {
            sQryInfo = sQryInfo + ", " + CASE_INSENSITIVE + ", " + SYMS_EXCLUDED;
        } else {
            sQryInfo = sQryInfo + ", " + CASE_SENSITIVE + ", " + SYMS_EXCLUDED;
        }
    } else {
        if (inp_UseCase.checked) {
            sQryInfo = sQryInfo + ", " + CASE_INSENSITIVE + ", " + SYMS_INCLUDED;
        } else {
            sQryInfo = sQryInfo + ", " + CASE_SENSITIVE + ", " + SYMS_INCLUDED;
        }
    }
    if (inp_UseGlobal.checked) {
        sQryInfo = sQryInfo + ", " + GLOBAL_WORD;
    } else {
        sQryInfo = sQryInfo + ", " + LOCAL_WORD;
    }


    showDbgVar("sSeldElemValue", sSeldElemValue, "GetQueryParams", "gqpAlgus", " ", new Date());
    showDbgVar("sSeldAttrValue", sSeldAttrValue, "GetQueryParams", "gqpAlgus", " ", new Date());
    showDbgVar("qt", qt, "GetQueryParams", "gqpAlgus", " ", new Date());
    showDbgVar("qtMySql", qtMySql, "GetQueryParams", "gqpAlgus", " ", new Date());
    showDbgVar("sNodeTest", sNodeTest, "GetQueryParams", "gqpAlgus", " ", new Date());
    showDbgVar("seldQn", seldQn, "GetQueryParams", "gqpAlgus", " ", new Date());
    showDbgVar("sQryInfo", sQryInfo, "GetQueryParams", "gqpAlgus", " ", new Date());
    showDbgVar("artRada", artRada, "GetQueryParams", "gqpAlgus", " ", new Date());
    showDbgVar("elemRada", elemRada, "GetQueryParams", "gqpAlgus", " ", new Date())


    //"päris" elemendid, valitud artikkel ning otsitakse kas tühja v olematut artiklit
    if (aElemInfo[3] == "1" && sNodeTest == artRada && (ft == "" || ft == "=NULL")) {
        return null;
    }

    var attXmlPred, attSqlPred, attPtrn, attSubst, mySqlAttCond, qM;
    attXmlPred = "";
    attSqlPred = "";
    attPtrn = "";
    attSubst = "";
    mySqlAttCond = "";

    qM = qryMethod;

    var seldQnDecl, hasSeldText;
    hasSeldText = false;
    //value = 'qname|name|URI|IsElement|kirjeldav'
    if (aElemInfo[3] == "1") {
        seldQnDecl = oSchRootElems.itemByQName(aElemInfo[1], aElemInfo[2]);
        if (seldQnDecl.type.itemType == SOMITEM_COMPLEXTYPE) {
            if (seldQnDecl.type.contentType == SCHEMACONTENTTYPE_TEXTONLY || seldQnDecl.type.contentType == SCHEMACONTENTTYPE_MIXED) {
                hasSeldText = true;
            }
        } else {
            hasSeldText = true;
        }
    }

    if (sSeldAttrValue != "") {
        //qname|name|URI|IsElement|kirjeldav;
        aAttrInfo = sSeldAttrValue.split("|");

        var mySqlMsAttNimi;
        if (seldQn == qn_ms) {
            if (aAttrInfo[0] == "xml:lang") {
                mySqlMsAttNimi = "ms_lang";
            } else {
                mySqlMsAttNimi = "ms_att_" + aAttrInfo[1];
            }
        }

        var rexBinary, attLikePtrn, atribuutValNimi;
        rexBinary = "";
        if (withCase == 1) {
            rexBinary = "BINARY ";
        }
        attLikePtrn = getMySqlLikePtrn(fa);
        atribuutValNimi = "val";
        // atribuutide väärtused on kas numbrid (@i) või mallid või @mvtl; ehk siis kõik need kaovad '_nos' teisendustel
        // seega on atribuutide puhul järgnev välja kommenteeritud
        //        if ((withSymbols < 1)) {
        //            atribuutValNimi = "val_nos";
        //        }

        if (fa == "*") {
            attXmlPred = "[@" + aAttrInfo[0] + "]";
            attSqlPred = attXmlPred;
            if (seldQn == qn_ms && !(inp_UseGlobal.checked && dic_desc == 'ss1')) {
                mySqlAttCond = " AND msid." + mySqlMsAttNimi + " IS NOT NULL";
            } else {
                mySqlAttCond = " AND atribuudid_" + dic_desc + ".nimi = BINARY '" + aAttrInfo[0] + "'" + " AND atribuudid_" + dic_desc + ".elG = elemendid_" + dic_desc + ".elG";
            }
        } else if (fa == "") {
            attXmlPred = "[@" + aAttrInfo[0] + " = '']";
            attSqlPred = attXmlPred;
            if (seldQn == qn_ms && !(inp_UseGlobal.checked && dic_desc == 'ss1')) {
                mySqlAttCond = " AND msid." + mySqlMsAttNimi + " = ''";
            } else {
                mySqlAttCond = " AND atribuudid_" + dic_desc + ".nimi = BINARY '" + aAttrInfo[0] + "'" + " AND atribuudid_" + dic_desc + "." + atribuutValNimi + " = ''" + " AND atribuudid_" + dic_desc + ".elG = elemendid_" + dic_desc + ".elG";
            }
        } else if (fa == "=NULL") {
            attXmlPred = "[not(@" + aAttrInfo[0] + ")]";
            attSqlPred = attXmlPred;
            if (seldQn == qn_ms && !(inp_UseGlobal.checked && dic_desc == 'ss1')) {
                mySqlAttCond = " AND msid." + mySqlMsAttNimi + " IS NULL";
            } else {
                hasSeldText = false; //las otsib ExtractValue kaudu;
            }
        } else {
            //            if ((withSymbols < 1)) {
            //                if ((CheckForSymbols(fa, "*?0123456789 "))) { //'2. parm VÕIB OLLA;
            //                    rb = alert(CONT_QUERY_Q, vbQuestion, QUERY_WORD + ": @" + fa);
            //                    return null;
            //                }
            //            }

            attPtrn = jsReplace(fa, "&amp;", "&");
            attPtrn = getSrPn2(attPtrn, "XML");
            if (withCase == 0) {
                attPtrn = "(?i)" + attPtrn;
            }
            //"attPtrn" läheb XML funktsiooni parameetrina, seega peab ' asendama;
            attPtrn = jsReplace(attPtrn, "'", "\x27");
            //            if ((withSymbols < 1)) {
            //                attSubst = "&\\w+;|[^\\p{L}\\d\\s]";
            //            }
            attXmlPred = "[al_p:srch2(@" + aAttrInfo[0] + ", '" + attPtrn + "', '" + attSubst + "') > 0]";
            attSqlPred = "[@" + aAttrInfo[0] + getXPathPred(fa) + "]"

            if (seldQn == qn_ms && !(inp_UseGlobal.checked && dic_desc == 'ss1')) {
                mySqlAttCond = " AND msid." + mySqlMsAttNimi + " LIKE " + rexBinary + attLikePtrn;
            } else {
                if (hasSeldText && mySqlDataVer == "2") { //'muul juhul läheb "attSqlPred" kaudu MySql-i;
                    mySqlAttCond = " AND atribuudid_" + dic_desc + ".nimi = BINARY '" + aAttrInfo[0] + "'" + " AND atribuudid_" + dic_desc + "." + atribuutValNimi + " LIKE " + rexBinary + attLikePtrn + " AND atribuudid_" + dic_desc + ".elG = elemendid_" + dic_desc + ".elG";
                }
            }
        }
    }


    var elpred, srchPtrn, hlPtrn, fakPtrn, mySqlPtrn, pQrySql;
    var art_xpath, elm_xpath, arttingimus


    elpred = "";
    srchPtrn = "";
    hlPtrn = "";

    fakPtrn = "";
    if (seldQn == qn_ms && fakult.length > 0 && withSymbols == -1) {
        fakPtrn = fakult;
    }

    mySqlPtrn = "";

    pQrySql = "";

    if (jsTrim(ft) == "=.") {
        alert("Not invented!", vbExclamation);
        return null;
    } else if (jsTrim(ft) == "!=.") {
        //elpred = "[not(.=preceding::" + xmltag + ")]";
        alert("Not invented!", vbExclamation);
        //if (hasSeldText) {
        //    // kui on 'hasSeldText', siis 'evPath' peaks olema kama
        //    qM = "MySql";
        //    pQrySql = getSqlQuery(seldQn, ft, hasSeldText, withSymbols, withCase, evPath, elemRada, mySqlAttCond);
        //}
        return null;
    } else if (jsLeft(jsTrim(ft), 2) == "§§") {
        withSymbols = 1;
        withCase = 1;
        qM = "XML";
        srchPtrn = jsTrim(ft).substr(2);
        srchPtrn = jsReplace(srchPtrn, "\\u", "\\p{Lu}"); //'suurtähed;
        srchPtrn = jsReplace(srchPtrn, "\\l", "\\p{Ll}"); //'väiketähed;
        srchPtrn = jsReplace(srchPtrn, "\\k", "[bcdfghjklmnpqrsšzžtvwx]"); //'eesti konsonandid;
        srchPtrn = jsReplace(srchPtrn, "\\v", "[aeiouõäöüy]"); //'eesti vokaalid;
        elpred = "[al_p:srch(.) > 0]";
        if (sNodeTest == artRada) { //A;
            elm_xpath = "self::node()";
            art_xpath = artRada + attXmlPred + "[" + qt + elpred + "]";
            evPath = artRada + attSqlPred + qtMySql;
        } else {
            arttingimus = elemRada + attXmlPred + "[" + qt + elpred + "]";
            elm_xpath = arttingimus;
            art_xpath = artRada + "[" + arttingimus + "]";
            evPath = elemRada + attSqlPred + qtMySql;
        }
        //        if ((jsLeft(srchPtrn, 4) == "(?õ)")) { //'?õ - kirjastiile mitte arvestada;
        //            mySqlPtrn = jsMid(srchPtrn, 4);
        //        } else {
        //            mySqlPtrn = srchPtrn;
        //        }
        //        hlPtrn = mySqlPtrn;
        //        hlPtrn = jsReplace(hlPtrn, "[^", JR);
        //        hlPtrn = jsReplace(hlPtrn, "^", "\\b");
        //        hlPtrn = jsReplace(hlPtrn, JR, "[^");
        //        hlPtrn = jsReplace(hlPtrn, "$", "\\b");
        //        //    mySqlPtrn = jsReplace(mySqlPtrn, "\", "\\")
        //        mySqlPtrn = jsReplace(mySqlPtrn, "\\-", "[.-.]");
        //        mySqlPtrn = jsReplace(mySqlPtrn, "\\(", "[.(.]");
        //        mySqlPtrn = jsReplace(mySqlPtrn, "\\)", "[.).]");
        //        mySqlPtrn = jsReplace(mySqlPtrn, "\\[", "[.[.]");
        //        mySqlPtrn = jsReplace(mySqlPtrn, "\\]", "[.].]");
        //    substPtrn = "+[a-z]+;"
        //    mySqlPtrn = jsMid(srchPtrn, InStr(1, srchPtrn, ")") + 1)
        //    mySqlPtrn = jsReplace(mySqlPtrn, "\", "\\")
        //    hlPtrn = srchPtrn
        //    if(! (seldQn = qn_ms)){ 'qn_ms = default_query tagumine ots
        //        mySqlPtrn = jsReplace(mySqlPtrn, "^", "[[:<:]]")
        //        mySqlPtrn = jsReplace(mySqlPtrn, "$", "[[:>:]]")
        //        hlPtrn = jsReplace(hlPtrn, "^", "\b")
        //        hlPtrn = jsReplace(hlPtrn, "$", "\b")
        //    }
    } else if (jsLeft(jsTrim(ft), 1) == "§") {
        elpred = "[" + jsTrim(ft).substr(1) + "]";
        if ((sNodeTest == artRada)) { //A;
            elm_xpath = "self::node()";
            art_xpath = artRada + attXmlPred + elpred;
        } else {
            arttingimus = elemRada + attXmlPred + elpred;
            elm_xpath = arttingimus;
            art_xpath = artRada + "[" + arttingimus + "]";
        }
        //MySQL "extractValue" tegutseb juurika tasemel (ehk siis "A");
        evPath = evPath + attSqlPred + elpred + qtMySql;
        //•The :: operator == ! supported in combination with node types such as the following;
        if ((elpred.indexOf("::comment()") > -1 || elpred.indexOf("::text()") > -1 || elpred.indexOf("::processing-instruction()") > -1 || elpred.indexOf("::node()") > -1)) {
            qM = "XML";
        }
        //axes ! supported in MySQL ExtractValue;
        if ((elpred.indexOf("following-sibling::") > -1 || elpred.indexOf("following::") > -1 || elpred.indexOf("preceding-sibling::") > -1 || elpred.indexOf("preceding::") > -1)) {
            qM = "XML";
        }
        //functions ! supported in MySQL ExtractValue;
        if ((elpred.indexOf("id(") > -1 || elpred.indexOf("lang(") > -1 || elpred.indexOf("local-name(") > -1 || elpred.indexOf("name(") > -1 || elpred.indexOf("namespace-uri(") > -1 || elpred.indexOf("normalize-space(") > -1 || elpred.indexOf("starts-with(") > -1 || elpred.indexOf("string(") > -1 || elpred.indexOf("substring-after(") > -1 || elpred.indexOf("substring-before(") > -1 || elpred.indexOf("translate(") > -1)) {
            qM = "XML";
        }
        //ka Perl funktsioonid tuleb siit välja arvata (srch, srch2);
        if ((elpred.indexOf("al_p:srch") > -1)) {
            qM = "XML";
        }
        //kui XPath tingimuse SEES on on veel mingi tingimus ja sisemist tingimust rahuldab rohkem kui 1 juhus,;
        //select * from vsl where extractvalue(art,"z:A[z:P/z:mg[z:m[not(@z:zs)] && z:etg/z:etgg/z:keel = 'ld']]//text()") != '' && vol_nr>0;;
        //select * from vsl where extractvalue(art,"z:A/z:P/z:mg[z:m[not(@z:zs)] && z:etg/z:etgg/z:keel = 'ld']//text()") != '' && vol_nr>0;;
        //MySQL ei suuda seda leida. Senikaua - kui selgusetu - olgu alati "XML";
        qM = "XML";
        withCase = 1;
        withSymbols = 1;
        // et kas elemendil on teksti ette näthud v mitte (hasSeldText)
        // kui 'false', siis läheb alati ExtractValue kaudu
        hasSeldText = false;
        pQrySql = getSqlQuery(seldQn, ft, hasSeldText, withSymbols, withCase, evPath, elemRada, mySqlAttCond);
    } else {
        //serveris otsib 'srch' tectContent' abil, selles aga '&amp;' -> '&';
        srchPtrn = jsReplace(ft, "&amp;", "&");
        srchPtrn = getSrPn2(srchPtrn, "XML");
        hlPtrn = srchPtrn //hlPtrn: ainult MySql meetodi jaoks värvimisel;
        hlPtrn = jsReplace(hlPtrn, "^", "\\b");
        hlPtrn = jsReplace(hlPtrn, "$", "\\b");

        var qtTing;
        if (ft == "*") {
            withSymbols = 1; // XML: vahet pole; mysql: art_alt ja val_nos on tühjad. Vale tulemus
            elpred = "";
            qtTing = "";
            evPath = evPath + attSqlPred + qtMySql;
        } else if (ft == "") {
            withSymbols = 1; // XML: vahet pole; mysql: art_alt ja val_nos on tühjad. Vale tulemus
            elpred = "[. = '']";
            qtTing = elpred;
            evPath = evPath + attSqlPred + elpred + qtMySql;
        } else if (ft == "=NULL") { //'A korral ei täideta, vt ülal;
            seldQn = artRada;
            hasSeldText = false;  //otsitav element muutus <A>, sellel pole mysql tabelites teksti ega atribuute;
            withSymbols = 1;
            withCase = 1;
            //        elpred = "[not(" + elemRada + ")]" ' see vist ei käivitunud MySql XML-i "not()" iseärasuste tõttu
            elpred = "[count(" + elemRada + ") = 0]";
            qtTing = elpred;
            evPath = artRada + elpred + "//text()";  //'sõltumata "qtMySql" - ist
            attXmlPred = ""; //'ei ole kasutatav atr tingimus, kui otsime elementi, mida pole;
            mySqlAttCond = "";
        } else {
            if (withSymbols < 1) {
                if (CheckForSymbols(ft, "*? ")) { //'2. parm VÕIB OLLA;
                    rb = alert(CONT_QUERY_Q + '\n' + QUERY_WORD + ": <" + ft + ">");
                    return null;
                }
            }

            elpred = "[al_p:srch(.) > 0]";
            qtTing = "[" + qt + elpred + "]";
            evPath = evPath + attSqlPred + qtMySql;
        }

        if (seldQn == artRada) { //A;
            elm_xpath = "self::node()";
            art_xpath = artRada + attXmlPred + qtTing;
        } else {
            arttingimus = elemRada + attXmlPred + qtTing;
            elm_xpath = arttingimus;
            art_xpath = artRada + "[" + arttingimus + "]";
        }

        //value = 'qname|name|URI|IsElement|kirjeldav';
        if (aElemInfo[3] == "1") {
            if (inp_UseGlobal.checked && dic_desc == 'ss1' && seldQn == qn_ms) {
                // pQrySql = getSqlQuery("x:yyyyy", ft, false, withSymbols, withCase, evPath, elemRada, mySqlAttCond);
                // *[self::s:m or self::s:tul or self::s:mm or self::s:rv]
                pQrySql = getSqlQuery("s:m;s:tul;s:mm;s:rv", ft, hasSeldText, withSymbols, withCase, evPath, elemRada, mySqlAttCond);
            } else {
                pQrySql = getSqlQuery(seldQn, ft, hasSeldText, withSymbols, withCase, evPath, elemRada, mySqlAttCond);
            }
        }

        //////        // kui küsida gruppe, siis päringutulemuste tabelis oleks vaja näha ka grupi atribuute:
        //////        // teksti omavate väljade korral käib päring vaikimisi MySQL kaudu, gruppide korral XML kaudu
        //////        if (!hasSeldText) {
        //////            qM = "XML";
        //////        }

    }

    if (aElemInfo[3] != "1") { // koond- v valmispäringud
        qM = aElemInfo[5];
        if (qM == "XML") {
            sNodeTest = sNodeTest.replace(/\[%s\]/g, elpred);
            sNodeTest = sNodeTest.replace(/\[%t\]/g, ft);
            arttingimus = sNodeTest.substr(4);
            art_xpath = artRada + "[" + arttingimus + "]";
            elm_xpath = "self::node()";
//        } else {
//            mySqlPtrn = getMySqlLikePtrn(ft); // koos ülakomadega
//            var sqlMsCond = mySqlPtrn, sqlMsField = "msid.ms", sqlVolCond = "> 0";
//            if (withCase == 1) {
//                sqlMsCond = "BINARY " + sqlMsCond;
//            }
//            if (withSymbols < 1) {
//                sqlMsField = "msid.ms_nos";
//            }
//            var volId = sel_Vol.options(sel_Vol.selectedIndex).id;
//            if (volId != sAllVolId) {
//                sqlVolCond = "= " + volId.substr(3, 1);
//            }
//            pQrySql = sNodeTest;
//            pQrySql = pQrySql.replace(/\[%t\]/g, sqlMsCond);
//            pQrySql = pQrySql.replace(/\[%msVäli%\]/g, sqlMsField);
//            pQrySql = pQrySql.replace(/\[%köiteTing%\]/g, sqlVolCond);
        }
    }

    showDbgVar("attXmlPred", attXmlPred, "GetQueryParams", "gqpLõpp", " ", new Date())

    showDbgVar("elpred", elpred, "GetQueryParams", "gqpLõpp", " ", new Date());
    showDbgVar("arttingimus", arttingimus, "GetQueryParams", "gqpLõpp", " ", new Date());
    showDbgVar("art_xpath", art_xpath, "GetQueryParams", "gqpLõpp", " ", new Date());
    showDbgVar("elm_xpath", elm_xpath, "GetQueryParams", "gqpLõpp", " ", new Date());
    showDbgVar("srchPtrn", srchPtrn, "GetQueryParams", "gqpLõpp", " ", new Date());
    showDbgVar("fakPtrn", fakPtrn, "GetQueryParams", "gqpLõpp", " ", new Date());
    showDbgVar("hlPtrn", hlPtrn, "GetQueryParams", "gqpLõpp", " ", new Date());
    showDbgVar("mySqlPtrn", mySqlPtrn, "GetQueryParams", "gqpLõpp", " ", new Date());
    showDbgVar("evPath", evPath, "GetQueryParams", "gqpLõpp", " ", new Date());
    showDbgVar("qM", qM, "GetQueryParams", "gqpLõpp", " ", new Date());
    showDbgVar("pQrySql", pQrySql, "GetQueryParams", "gqpLõpp", " ", new Date())


    var sPrmDomXml, oPrmDom;
    sPrmDomXml = "<prm>" +
                "<cmd></cmd>" +
                "<vol></vol>" +
                "<nfo></nfo>" +
                "<axp></axp>" +
                "<exp></exp>" +
                "<wC></wC>" +
                "<wS></wS>" +
                "<evP></evP>" +
                "<qn></qn>" +
                "<fSrP></fSrP>" +
                "<pFakPtrn></pFakPtrn>" +
                "<fMsqlP></fMsqlP>" +
                "<hlP></hlP>" +
                "<qM></qM>" +
                "<pQrySql></pQrySql>" +
               "</prm>";

    oPrmDom = IDD("String", sPrmDomXml, false, false, null);
    if ((oPrmDom.parseError.errorCode == 0)) {
        //cmd ja vol täidetakse 'btnRunQuery'-is;
        oPrmDom.documentElement.selectSingleNode("nfo").text = sQryInfo;
        oPrmDom.documentElement.selectSingleNode("axp").text = art_xpath;
        oPrmDom.documentElement.selectSingleNode("exp").text = elm_xpath;
        oPrmDom.documentElement.selectSingleNode("wC").text = withCase;
        oPrmDom.documentElement.selectSingleNode("wS").text = withSymbols;
        oPrmDom.documentElement.selectSingleNode("evP").text = evPath;
        oPrmDom.documentElement.selectSingleNode("qn").text = seldQn;
        oPrmDom.documentElement.selectSingleNode("fSrP").text = srchPtrn;
        oPrmDom.documentElement.selectSingleNode("pFakPtrn").text = fakPtrn;
        oPrmDom.documentElement.selectSingleNode("fMsqlP").text = mySqlPtrn;
        oPrmDom.documentElement.selectSingleNode("hlP").text = escape(hlPtrn);
        oPrmDom.documentElement.selectSingleNode("qM").text = qM;
        oPrmDom.documentElement.selectSingleNode("pQrySql").text = pQrySql;
    }

    return oPrmDom;
} //GetQueryParams


/**
* 
*
* @method getSqlQuery
* @param {Object} qn (a la jsMid(default_query, default_query.lastIndexOf("/") + 1); )
* @param {String} txt
* @param {Boolean} onTeksti
* @param {Int} wsym
* @param {Int} wcase
* @param {String} extvalpath
* @param {String} elRada 
* @param {String} msAttCond
* @returns {String} 
*/
function getSqlQuery(qn, txt, onTeksti, wsym, wcase, extvalpath, elRada, msAttCond) {
    var rexBinary, volId, volCond, ret;
    rexBinary = "";
    if (wcase == 1) {
        rexBinary = "BINARY ";
    }
    volId = sel_Vol.options(sel_Vol.selectedIndex).id;
    volCond = dic_desc + ".vol_nr = " + jsMid(volId, 3, 1);
    if (volId == sAllVolId) {
        volCond = dic_desc + ".vol_nr > 0";
    }

    //MySQL LIKE on tegelikult string võrdlemise funktsioon: expr LIKE pat
    //"lihtne" regexp
    var mySqlLikePtrn = getMySqlLikePtrn(txt)

    var mySqlPtrn = getSrPn2(txt, "MySql");
    //need kuradi ^ või [:<:] EI OLE MySQL-is üks ja sama stringi alguse korral!
    mySqlPtrn = jsReplace(mySqlPtrn, "^", "(^|[[:<:]])");
    mySqlPtrn = jsReplace(mySqlPtrn, "$", "($|[[:>:]])");

    ret = "";
    if (qn == (qn_ms)) {
        var msTekstTing;
        if ((txt == "*")) {
            msTekstTing = "";
        } else {
            msTekstTing = "msid.ms LIKE " + rexBinary + mySqlLikePtrn;
            //withSymbols: 0-sümboliteta; -1-sümboliteta ja fak tekstiga; 1-sümbolitega;
            if ((wsym < 1)) {
                msTekstTing = "msid.ms_nos LIKE " + rexBinary + mySqlLikePtrn;
                if ((fakult.length > 0 && wsym == -1)) {
                    msTekstTing = msTekstTing + " OR msid.ms_nos_alt LIKE " + rexBinary + mySqlLikePtrn;
                }
            }
            msTekstTing = " AND (" + msTekstTing + ")";
        }
        ret = "SELECT " + dic_desc + ".md AS md, " + "msid.ms AS l, " +
            "msid.ms_att_i AS ms_att_i, msid.ms_att_liik AS ms_att_liik, " +
            "msid.ms_att_ps AS ms_att_ps, msid.ms_att_tyyp AS ms_att_tyyp, msid.ms_att_mliik AS ms_att_mliik, " +
            "msid.ms_att_k AS ms_att_k, msid.ms_att_mm AS ms_att_mm, msid.ms_att_st AS ms_att_st, " +
            "msid.ms_att_vm AS ms_att_vm, msid.ms_att_all AS ms_att_all, msid.ms_att_uus AS ms_att_uus, " +
            "msid.ms_att_zs AS ms_att_zs, msid.ms_att_u AS ms_att_u, msid.ms_att_em AS ms_att_em, " +
            dic_desc + ".G AS G, " + dic_desc + ".art AS art, " +
            dic_desc + ".K AS K, " + dic_desc + ".KL AS KL, " +
            dic_desc + ".T AS T, " + dic_desc + ".TA AS TA, " + dic_desc + ".TL AS TL, " +
            dic_desc + ".PT AS PT, " + dic_desc + ".PTA AS PTA, " +
            dic_desc + ".vol_nr AS vol_nr " + "FROM msid, " + dic_desc +
            " WHERE (" + dic_desc + ".G = msid.G" +
            " AND msid.dic_code = '" + dic_desc + "'" + msTekstTing + msAttCond + " AND " + volCond + ")" +
            " ORDER BY " + dic_desc + ".ms_att_OO";
    } else {
        var elementValNimi, artValNimi, elementTing, fromTing;
        elementValNimi = "val";
        artValNimi = "art";
        if (wsym < 1) {
            elementValNimi = "val_nos";
            artValNimi = "art_alt";
        }
        if (onTeksti && mySqlDataVer == "2") {
            var ix, qryElemendid = qn.split(";");
            elementTing = "";
            for (ix = 0; ix < qryElemendid.length; ix++) {
                if (elementTing.length > 0) {
                    elementTing += " OR ";
                }
                elementTing += "elemendid_" + dic_desc + ".nimi = BINARY '" + qryElemendid[ix] + "'";
            }
            if (qryElemendid.length > 1) {
                elementTing = "(" + elementTing + ")";
            }
            if (txt == "*") {
            } else {
                //siin peaks midagi optimiseerima, nt päring sl='*';
                elementTing = elementTing + " AND elemendid_" + dic_desc + "." + elementValNimi + " LIKE " + rexBinary + mySqlLikePtrn;
            }
            if (!(elRada.substr(0, 3) == ".//" || elRada == "")) { //'on lokaalne; ".//" korral on globaalne, "" korral on 'art';
                elementTing = elementTing + " AND elemendid_" + dic_desc + ".rada = BINARY '" + elRada + "'";
            }
            elementTing = " AND (" + elementTing + msAttCond + ")";
            fromTing = "";
            if (msAttCond.indexOf("atribuudid_" + dic_desc) > -1) {
                //1 = 1;
                if (msAttCond.indexOf("select " + dic_desc, 1) < 0) {
                    fromTing = ", atribuudid_" + dic_desc;
                }
            }
            ret = "SELECT " + dic_desc + ".md AS md, " + "elemendid_" + dic_desc + ".val AS l, elemendid_" + dic_desc + ".elG AS elG, " +
                dic_desc + ".G AS G, " + dic_desc + ".art AS art, " +
                dic_desc + ".K AS K, " + dic_desc + ".KL AS KL, " +
                dic_desc + ".T AS T, " + dic_desc + ".TA AS TA, " + dic_desc + ".TL AS TL, " +
                dic_desc + ".PT AS PT, " + dic_desc + ".PTA AS PTA, " +
                dic_desc + ".vol_nr AS vol_nr " +
                "FROM " + dic_desc + ", elemendid_" + dic_desc + fromTing +
                " WHERE (" + dic_desc + ".G = elemendid_" + dic_desc + ".G" + elementTing +
                " AND " + volCond + ")" +
                " ORDER BY " + dic_desc + ".ms_att_OO";
        } else {
            if (txt == "*") {
                elementTing = " != ''";
            } else if (txt == "=NULL") {
                elementTing = " != ''";
            } else if (txt.substr(0, 1) == "§") {
                elementTing = " != ''";
            } else {
                elementTing = " regexp " + rexBinary + "'" + mySqlPtrn + "'";
            }
            //'extvalpath: nt ".//s:etp//text()"
            ret = "SELECT " + dic_desc + ".md AS md, " +
                "ExtractValue(" + dic_desc + ".art, \"" + extvalpath + "\") AS l, " +
                dic_desc + ".G AS G, " + dic_desc + ".art AS art, " +
                dic_desc + ".K AS K, " + dic_desc + ".KL AS KL, " +
                dic_desc + ".T AS T, " + dic_desc + ".TA AS TA, " + dic_desc + ".TL AS TL, " +
                dic_desc + ".PT AS PT, " + dic_desc + ".PTA AS PTA, " +
                dic_desc + ".vol_nr AS vol_nr " + "FROM " + dic_desc +
                " WHERE (ExtractValue(" + dic_desc + "." + artValNimi + ", \"" + extvalpath + "\")" + elementTing +
                " AND " + volCond + ")" +
                " ORDER BY " + dic_desc + ".ms_att_OO";
        }
    }

    return ret;
} //getSqlQuery



/**
* 
*
* @method getMySqlLikePtrn
* @param {String} inp
* @returns {String} 
*/
function getMySqlLikePtrn(inp) {
    var ret, escCh, escCl;
    ret = inp;

    //MySql LIKE bug:
    //select * from msid where dic_code='ss_' && vol_nr>0;
    // select * from msid where dic_code='ss_' && vol_nr>0 && ms like '%\\\\%';
    // select * from msid where dic_code='ss_' && vol_nr>0 && locate('\\', ms)>0;
    // select * from msid where dic_code='ss_' && vol_nr>0 && ms like '%\\tõde';
    // select * from msid where dic_code='ss_' && vol_nr>0 && ms like '%\\kirjandus';
    // select * from msid where dic_code='ss_' && vol_nr>0 && ms like '%€\%' escape '€';

    if ((ret.indexOf("\\") > -1)) {
        escCh = "¡";
        escCl = " ESCAPE '¡'";
    } else {
        escCh = "\\";
        escCl = "";
    }
    // märksõnad <m>
    // ss_ (sama puuk mis allpool?: (msid.ms LIKE '%¡\kon%' ESCAPE '¡') annab nii kaldkriipsu kui ka 'kon')
    ret = jsReplace(ret, "\\\\", "\uE003");
    // ss1
    ret = jsReplace(ret, "\\*", "\uE001");
    // ss_, fin
    ret = jsReplace(ret, "\\?", "\uE002");
    // qs_, evs
    ret = jsReplace(ret, "_", "\\_");
    // qs_
    ret = jsReplace(ret, "'", escCh + "'");
    // evs (puuk?: (msid.ms LIKE '%\%m%') annab justnagu '%' ning 'm')
    ret = jsReplace(ret, "%", escCh + "%");
    ret = jsReplace(ret, "?", "_");
    ret = jsReplace(ret, "*", "%");
    ret = jsReplace(ret, "\uE001", "*");
    ret = jsReplace(ret, "\uE002", "?");
    ret = jsReplace(ret, "\uE003", escCh + "\\");
    if ((ret.indexOf("'") > -1)) {
        ret = "\"" + ret + "\"";
    } else {
        ret = "'" + ret + "'";
    }
    ret = ret + escCl

    return ret;
} //getMySqlLikePtrn


/**
* 
*
* @method GCV
* @param {String} sInpStr
* @param {String} lisa
* @param {Int} kuhu
* @returns {String} 
*/
function GCV(sInpStr, lisa, kuhu) {
    var sGCV, i, tarr;
    sGCV = ""

    if ((sInpStr == "'")) {
        if ((kuhu == 0)) {
            sGCV = "\"" + lisa + "'\"";
        } else {
            sGCV = "\"'" + lisa + "\"";
        }
    } else if ((sInpStr.indexOf("'") > -1)) {
        tarr = sInpStr.split("'");
        for (i = 0; i < tarr.length; i++) {
            if (!(tarr[i] == "")) {
                sGCV = sGCV + ",'" + tarr[i] + "'";
            }

            if ((i < tarr.length - 1)) {
                sGCV = sGCV + ",\"'\"";
            }
        }
        if (!(lisa == "")) {
            if ((kuhu == 0)) {
                sGCV = "concat('" + lisa + "', " + jsMid(sGCV, 1) + ")";
            } else {
                sGCV = "concat(" + jsMid(sGCV, 1) + ", '" + lisa + "')";
            }
        } else {
            sGCV = "concat(" + jsMid(sGCV, 1) + ")";
        }
    } else {
        if ((kuhu == 0)) {
            sGCV = "'" + lisa + sInpStr + "'";
        } else {
            sGCV = "'" + sInpStr + lisa + "'";
        }
    }
    return sGCV;
} //GCV

/**
* 
*
* @method getXPathPred
* @param {String} inp
* @returns {String} 
*/
function getXPathPred(inp) {
    var getXPathPred;
    var s, v, regEx, jnr
    regEx = /[\*\?]/;

    s = asendaMetad(inp);

    v = "";
    jnr = 0;
    if (regEx.test(s)) {
        var result = regEx.exec(s);
        while (result != null) {
            jnr = jnr + 1;
            if ((v.length > 0)) {
                v = v + " AND ";
            }
            if ((result.index > 0)) {
                if ((jnr == 1)) {
                    v = v + "contains(concat('~~~',.)," + gcv2("~~~" + jsMid(s, 0, result.index)) + ")";
                } else {
                    v = v + "contains(.," + gcv2(jsMid(s, 0, result.index)) + ")";
                }
            }
            s = s.substr(result.lastIndex);
            result = regEx.exec(s);
        }
        if (s.length > 0) {
            if (v.length > 0) {
                v = v + " AND ";
            }
            v = v + "contains(concat(.,'~~~')," + gcv2(s + "~~~") + ")";
        }
        getXPathPred = v;
    } else {
        getXPathPred = "[.=" + gcv2(s) + "]";
    }
    return getXPathPred;
} //getXPathPred


/**
* 
*
* @method asendaMetad
* @param {String} jupp
* @returns {String} 
*/
function asendaMetad(jupp) {
    var s;
    s = jupp;
    s = jsReplace(s, "\\\\", "\uE003");
    s = jsReplace(s, "\\*", "\uE001");
    s = jsReplace(s, "\\?", "\uE002");
    return s;
} //asendaMetad


/**
* 
*
* @method taastaMetad
* @param {String} jupp
* @returns {String} 
*/
function taastaMetad(jupp) {
    var s;
    s = jupp;
    s = jsReplace(s, "\uE001", "*");
    s = jsReplace(s, "\uE002", "?");
    s = jsReplace(s, "\uE003", "\\\\");
    return s;
} //taastaMetad


/**
* 
*
* @method gcv2
* @param {String} jupp
* @returns {String} 
*/
function gcv2(jupp) {
    var gcv2;
    if ((jupp == "'")) {
        gcv2 = "\"'\"";
    } else if ((jupp == "\"")) {
        gcv2 = "'\"'";
    } else {
        var regEx, tykk;
        regEx = /["']/g;
        var s, v, m;
        s = jupp;
        if (regEx.test(jupp)) {
            v = "concat(";
            var result = regEx.exec(s);
            while (result != null) {
                if (!(v == "concat(")) {
                    v = v + ",";
                }
                tykk = taastaMetad(s.substr(0, result.index)); //kui ' on kohe alguses siis tuleb '';
                if (tykk.length > 0) {
                    v = v + "'" + tykk + "',";
                }
                if ((result[0] == "'")) {
                    v = v + "\"'\"";
                } else {
                    v = v + "'\"'";
                }
                s = s.substr(result.index);
                result = regEx.exec(s);
            }
            if (s.length > 0) {
                v = v + ",'" + taastaMetad(s) + "'";
            }
            v = v + ")";
            gcv2 = v;
        } else {
            gcv2 = "'" + taastaMetad(s) + "'";
        }
    }
    return gcv2;
} //gcv2

/**
* 
*
* @method btnRunQuery
*/
function btnRunQuery() {
    //päringu juurde minemisel oleks katkestamist vaja
    if (salvestaJaKatkesta()) {
        return;
    }

    var oPrmDom, qryMethod;

    qryMethod = "MySql";
    if (window.event.srcElement.id == "inp_RunQueryXML") {
        qryMethod = "XML";
    }

    oPrmDom = GetQueryParams(qryMethod);
    if (!oPrmDom) {
        return;
    }

    sCmdId = "ClientRead";
    oPrmDom.documentElement.selectSingleNode("cmd").text = sCmdId;

    //"${DIC_DESC}2", "${DIC_DESC}All"
    if ((oPrmDom.documentElement.selectSingleNode("vol").text == "")) {
        //id='${DIC_DESC}${volNr}';
        oPrmDom.documentElement.selectSingleNode("vol").text = sel_Vol.options(sel_Vol.selectedIndex).id;
    }

    StartOperation(oPrmDom)

} //btnRunQuery


/**
* 
*
* @method koostamiseLopp
*/
function koostamiseLopp() {
    var itmElem, gspq, refnode, muutused

    muutused = "KL märge"
    itmElem = oEditDOMRoot.firstChild.selectSingleNode(DICPR + ":K");
    if (!(itmElem.text == sUsrName)) {
        muutused = muutused + " (<K> '" + itmElem.text + "' -> '" + sUsrName + "')";
        itmElem.text = sUsrName;
    }
    updMuudatused("S", muutused);

    itmElem = oEditDOMRoot.firstChild.selectSingleNode(DICPR + ":KL");
    if ((itmElem == null)) {
        //GetSchemaPosQuery: teeb oStruDom - ist päringu following-sibling nimede kohta;
        gspq = GetSchemaPosQuery(oEditDOMRoot.firstChild, DICPR + ":KL");
        refnode = oEditDOMRoot.firstChild.selectSingleNode(gspq);
        itmElem = oEditDOMRoot.firstChild.insertBefore(oEditDOM.createNode(NODE_ELEMENT, DICPR + ":KL", DICURI), refnode);
    }
    itmElem.text = GetXSDDateTime(new Date());

    imgArtSaveClick()

} //koostamiseLopp


/**
* 
*
* @method remKoostamiseLopp
*/
function remKoostamiseLopp() {
    var klElem = oEditDOMRoot.firstChild.selectSingleNode(DICPR + ":KL");
    if (!(klElem == null)) {
        klElem.parentNode.removeChild(klElem);
        updMuudatused("S", "KL märke eemaldamine");
        imgArtSaveClick();
    }
} //remKoostamiseLopp



/**
* 
*
* @method signEntry
*/
function signEntry() {
    var gspq, refnode, itmElem;

    itmElem = oEditDOMRoot.firstChild.selectSingleNode(DICPR + ":PT");
    if ((itmElem == null)) {
        //GetSchemaPosQuery: teeb oStruDom - ist päringu following-sibling nimede kohta;
        gspq = GetSchemaPosQuery(oEditDOMRoot.firstChild, DICPR + ":PT");
        refnode = oEditDOMRoot.firstChild.selectSingleNode(gspq);
        itmElem = oEditDOMRoot.firstChild.insertBefore(oEditDOM.createNode(NODE_ELEMENT, DICPR + ":PT", DICURI), refnode);
    }
    itmElem.text = sUsrName;

    itmElem = oEditDOMRoot.firstChild.selectSingleNode(DICPR + ":PTA");
    if ((itmElem == null)) {
        //GetSchemaPosQuery: teeb oStruDom - ist päringu following-sibling nimede kohta;
        gspq = GetSchemaPosQuery(oEditDOMRoot.firstChild, DICPR + ":PTA");
        refnode = oEditDOMRoot.firstChild.selectSingleNode(gspq);
        itmElem = oEditDOMRoot.firstChild.insertBefore(oEditDOM.createNode(NODE_ELEMENT, DICPR + ":PTA", DICURI), refnode);
    }
    itmElem.text = GetXSDDateTime(new Date());
    updMuudatused("S", "PT märge");

    imgArtSaveClick();

} //signEntry


/**
* 
*
* @method remSignEntry
*/
function remSignEntry() {
    var signElems
    signElems = oEditDOMRoot.firstChild.selectNodes(DICPR + ":PT | " + DICPR + ":PTA")

    if ((signElems.length > 0)) {
        signElems.removeAll();
        updMuudatused("S", "PT märke eemaldamine");
        imgArtSaveClick();
    }

} //remSignEntry


/**
* 
*
* @method completeEntryLatvian
*/
function completeEntryLatvian() {
    var itmElem = oEditDOMRoot.firstChild.selectSingleNode(DICPR + ":lTL[@" + DICPR + ":nimi = '" + sUsrName + "']"), newAttr;
    if (!itmElem) {
        //GetSchemaPosQuery: teeb oStruDom - ist päringu following-sibling nimede kohta;
        var gspq = GetSchemaPosQuery(oEditDOMRoot.firstChild, DICPR + ":lTL");
        var refNode = oEditDOMRoot.firstChild.selectSingleNode(gspq);
        itmElem = oEditDOMRoot.firstChild.insertBefore(oEditDOM.createNode(NODE_ELEMENT, DICPR + ":lTL", DICURI), refNode);
        newAttr = itmElem.attributes.setNamedItem(oEditDOM.createNode(NODE_ATTRIBUTE, DICPR + ":nimi", DICURI));
        newAttr.value = sUsrName;
    }
    newAttr = itmElem.attributes.setNamedItem(oEditDOM.createNode(NODE_ATTRIBUTE, DICPR + ":aeg", DICURI));
    newAttr.value = GetXSDDateTime(new Date());
    updMuudatused("S", "lTL lisamine");
    imgArtSaveClick();
} // completeEntryLatvian


/**
* 
*
* @method remCompleteEntryLatvian
*/
function remCompleteEntryLatvian() {
    var itmElem = oEditDOMRoot.firstChild.selectSingleNode(DICPR + ":lTL[@" + DICPR + ":nimi = '" + sUsrName + "']");
    if (itmElem) {
        itmElem.parentNode.removeChild(itmElem);
        updMuudatused("S", "lTL eemaldamine");
        imgArtSaveClick();
    }
} //remCompleteEntryLatvian


/**
* 
*
* @method completeEntryEstonian
*/
function completeEntryEstonian() {
    var itmElem = oEditDOMRoot.firstChild.selectSingleNode(DICPR + ":eTL[@" + DICPR + ":nimi = '" + sUsrName + "']"), newAttr;
    if (!itmElem) {
        //GetSchemaPosQuery: teeb oStruDom - ist päringu following-sibling nimede kohta;
        var gspq = GetSchemaPosQuery(oEditDOMRoot.firstChild, DICPR + ":eTL");
        var refNode = oEditDOMRoot.firstChild.selectSingleNode(gspq);
        itmElem = oEditDOMRoot.firstChild.insertBefore(oEditDOM.createNode(NODE_ELEMENT, DICPR + ":eTL", DICURI), refNode);
        newAttr = itmElem.attributes.setNamedItem(oEditDOM.createNode(NODE_ATTRIBUTE, DICPR + ":nimi", DICURI));
        newAttr.value = sUsrName;
    }
    newAttr = itmElem.attributes.setNamedItem(oEditDOM.createNode(NODE_ATTRIBUTE, DICPR + ":aeg", DICURI));
    newAttr.value = GetXSDDateTime(new Date());
    updMuudatused("S", "eTL lisamine");
    imgArtSaveClick();
} // completeEntryEstonian


/**
* 
*
* @method remCompleteEntryEstonian
*/
function remCompleteEntryEstonian() {
    var itmElem = oEditDOMRoot.firstChild.selectSingleNode(DICPR + ":eTL[@" + DICPR + ":nimi = '" + sUsrName + "']");
    if (itmElem) {
        itmElem.parentNode.removeChild(itmElem);
        updMuudatused("S", "eTL eemaldamine");
        imgArtSaveClick();
    }
} //remCompleteEntryEstonian


/**
* 
*
* @method completeEntry
*/
function completeEntry() {

    var itmElem = oEditDOMRoot.firstChild.selectSingleNode(DICPR + ":TL");

    if (!itmElem) {
        //GetSchemaPosQuery: teeb oStruDom - ist päringu following-sibling nimede kohta;
        var gspq = GetSchemaPosQuery(oEditDOMRoot.firstChild, DICPR + ":TL");
        var refnode = oEditDOMRoot.firstChild.selectSingleNode(gspq);
        itmElem = oEditDOMRoot.firstChild.insertBefore(oEditDOM.createNode(NODE_ELEMENT, DICPR + ":TL", DICURI), refnode);
    }

    if (dic_desc == 'psv') {
        var TLTekst = itmElem.text;
        if (TLTekst.length > 0) {
            var f = false;
            var TLd = TLTekst.split('; ');
            for (var ixTL in TLd) {
                var TL = TLd[ixTL].split(', ');
                if (TL[0] == sUsrName) {
                    f = true;
                    TL[1] = GetXSDDateTime(new Date());
                    TLd[ixTL] = TL.join(', ');
                }
            }
            if (!f) {
                TLd.unshift(sUsrName + ", " + GetXSDDateTime(new Date()));
            }
            itmElem.text = TLd.join('; ');
        }
        else {
            itmElem.text = sUsrName + ", " + GetXSDDateTime(new Date());
        }
    }
    else
        itmElem.text = GetXSDDateTime(new Date());

    updMuudatused("S", "TL märge");
    imgArtSaveClick();

} //completeEntry


/**
* 
*
* @method remCompleteEntry
*/
function remCompleteEntry() {

    var tlElem = oEditDOMRoot.firstChild.selectSingleNode(DICPR + ":TL");

    if (tlElem) {
        if (dic_desc == 'psv') {
            var TLTekst = tlElem.text;
            var TLd = TLTekst.split('; ');
            var newTLd = new Array();
            for (var ixTL in TLd) {
                var TL = TLd[ixTL].split(', ');
                if (TL[0] != sUsrName) {
                    newTLd.unshift(TL[0] + ', ' + TL[1]);
                }
            }
            if (newTLd.length > 0)
                tlElem.text = newTLd.join('; ');
            else
                tlElem.parentNode.removeChild(tlElem);
        }
        else {
            tlElem.parentNode.removeChild(tlElem);
        }
        updMuudatused("S", "TL märke eemaldamine");
        imgArtSaveClick();
    }
} //remCompleteEntry


/**
* 
*
* @method kustutaArtikkel
*/
function kustutaArtikkel() {
    var destVol, orgVolFile, sqlVol;
    if (sFromVolume == sDeldVolId) {
        sCmdId = "ClientRestore";
        if (dic_vols_count > 1) {
            orgVolFile = oEditDOMRoot.selectSingleNode(DICPR + ":A").getAttribute(DICPR + ":KF");
            if (!orgVolFile) {
                orgVolFile = prompt("Sisesta köite number!");
                if (orgVolFile == "" || parseInt(orgVolFile) < 1 || parseInt(orgVolFile) > dic_vols_count) {
                    return;
                } else {
                    orgVolFile = dic_desc + orgVolFile;
                }
            }
            destVol = orgVolFile;
        } else {
            destVol = dic_desc + "1";
        }
        sqlVol = destVol;
    } else {
        sCmdId = "ClientDelete";
        destVol = sDeldVolId;
        sqlVol = sFromVolume;
    }
    sQryInfo = sMSortVal

    var artGuid, qM, seldQn, srchPtrn, homonyymsed, art_xpath, elm_xpath, sql;
    artGuid = oEditDOMRoot.selectSingleNode(DICPR + ":A/" + qn_guid).text;
    qM = "MySql";
    seldQn = qn_ms;  //pärast otsitakse nn homonüümseid märksõnu, st millised veel sama märksõnaga on;
    srchPtrn = "^" + sMSortVal + "$";
    homonyymsed = "";
    if (!(oXslEdit == oXsl1)) {
        homonyymsed = jsMid(first_default, first_default.indexOf("/") + 1) + "[. = " + GCV(sMarkSona, "", 2);
        sql = "SELECT " + dic_desc + ".md AS md, " + "msid.ms AS l, " + "msid.ms_att_i AS ms_att_i, " + "msid.ms_att_liik AS ms_att_liik, " + "msid.ms_att_ps AS ms_att_ps, " + "msid.ms_att_tyyp AS ms_att_tyyp, " + "msid.ms_att_mliik AS ms_att_mliik, " + "msid.ms_att_k AS ms_att_k, " + "msid.ms_att_mm AS ms_att_mm, " + "msid.ms_att_st AS ms_att_st, " + "msid.ms_att_vm AS ms_att_vm, " + "msid.ms_att_all AS ms_att_all, " + "msid.ms_att_uus AS ms_att_uus, " + "msid.ms_att_zs AS ms_att_zs, " + dic_desc + ".G AS G, " + dic_desc + ".art AS art, " + dic_desc + ".K AS K, " + dic_desc + ".T AS T, " + dic_desc + ".TA AS TA, " + dic_desc + ".PT AS PT, " + dic_desc + ".vol_nr AS vol_nr " + "FROM msid, " + dic_desc + " " + "WHERE (" + dic_desc + ".G = msid.G " + "AND msid.dic_code = '" + dic_desc + "' " + "AND (msid.ms = \"" + sMarkSona + "\"";
        homonyymsed = homonyymsed + "]";
        sql = sql + ") " + "AND msid.vol_nr = " + jsMid(sqlVol, 3, 1);
        sql = sql + ") "; //'WHERE tingimuse lõpp;
        sql = sql + "ORDER BY " + dic_desc + ".ms_att_OO";
        elm_xpath = homonyymsed;
        homonyymsed = DICPR + ":A[" + homonyymsed + "]";
        art_xpath = homonyymsed;
    }

    showDbgVar("sCmdId", sCmdId, "kustutaArtikkel", "lõpp", " ", new Date());
    showDbgVar("sQryInfo", sQryInfo, "kustutaArtikkel", "lõpp", " ", new Date());
    showDbgVar("art_xpath", art_xpath, "kustutaArtikkel", "lõpp", " ", new Date());
    showDbgVar("elm_xpath", elm_xpath, "kustutaArtikkel", "lõpp", " ", new Date());
    showDbgVar("srchPtrn", srchPtrn, "kustutaArtikkel", "lõpp", " ", new Date());
    showDbgVar("sql", sql, "kustutaArtikkel", "lõpp", " ", new Date());
    showDbgVar("destVol", destVol, "kustutaArtikkel", "lõpp", " ", new Date());
    showDbgVar("qM", qM, "kustutaArtikkel", "lõpp", " ", new Date())

    var sPrmDomXml, oPrmDom;
    sPrmDomXml = "<prm>" +
                    "<cmd>" + sCmdId + "</cmd>" +
                    "<vol>" + sFromVolume + "</vol>" +
                    "<nfo>" + sQryInfo + "</nfo>" +
                    "<axp>" + art_xpath + "</axp>" +
                    "<exp>" + elm_xpath + "</exp>" +
                    "<wC>0</wC>" +
                    "<wS>1</wS>" +
                    "<fSrP>" + srchPtrn + "</fSrP>" +
                    "<G>" + artGuid + "</G>" +
                    "<sql>" + sql + "</sql>" +
                    "<dV>" + destVol + "</dV>" +
                    "<qn>" + seldQn + "</qn>" +
                    "<qM>" + qM + "</qM>" +
                 "</prm>";

    oPrmDom = IDD("String", sPrmDomXml, false, false, null);
    if ((oPrmDom.parseError.errorCode != 0)) {
        ShowXMLParseError(oPrmDom);
        return;
    }

    StartOperation(oPrmDom);
} //kustutaArtikkel


/**
* 
*
* @method imgArtDeleteClick
*/
function imgArtDeleteClick() {
    if (!(oEditDOMRoot.hasChildNodes())) {
        return;
    }

    //DEL_WORD
    var nRetBtn = window.confirm(jsReplace(DEL_ART_Q, "[%s]", sMSortVal));
    if ((nRetBtn != true)) {
        return;
    }

    kustutaArtikkel()

} //imgArtDeleteClick


/**
* 
*
* @method StartOperation
* @param {Object} oPrmDom
*/
function StartOperation(oPrmDom) {
    var cmdId;
    cmdId = oPrmDom.documentElement.selectSingleNode("cmd").text

    var axpNode, art_xpath
    axpNode = oPrmDom.documentElement.selectSingleNode("axp");
    if (!(axpNode == null)) {
        art_xpath = axpNode.text;
        if (!(art_xpath == "")) {
            if (!(CheckXPath(art_xpath))) {
                return;
            }
        }
    }

    //esimeseks tuleb siis "app_lang", siis "dic_desc"
    var nNode
    nNode = oPrmDom.documentElement.insertBefore(oPrmDom.createNode(NODE_ELEMENT, "dic_desc", ""), oPrmDom.documentElement.firstChild);
    nNode.text = dic_desc
    nNode = oPrmDom.documentElement.insertBefore(oPrmDom.createNode(NODE_ELEMENT, "app_lang", ""), oPrmDom.documentElement.firstChild);
    nNode.text = sAppLang
    nNode = oPrmDom.documentElement.appendChild(oPrmDom.createNode(NODE_ELEMENT, "un", ""));
    nNode.text = sUsrName

    spnMsgDelete();
    window.status = "";
    inp_RunQuery.disabled = true;
    if (!(document.body.all("inp_RunQueryXML") == null)) {
        inp_RunQueryXML.disabled = true;
    }

    //07. juuni 2011
    img_ArtAdd.style.visibility = "hidden";
    img_ArtExport.style.visibility = "hidden"; //'Word väljatrükk;
    if (!(document.body.all("img_SrTools") == null)) {
        img_SrTools.style.visibility = "hidden";
    }
    if (!(document.body.all("img_readFirst") == null)) {
        img_readFirst.style.visibility = "hidden";
    }
    if (!(document.body.all("img_readPrev") == null)) {
        img_readPrev.style.visibility = "hidden";
    }
    if (!(document.body.all("img_readNext") == null)) {
        img_readNext.style.visibility = "hidden";
    }
    if (!(document.body.all("img_readLast") == null)) {
        img_readLast.style.visibility = "hidden";
    }
    if (!(document.body.all("img_artHistory") == null)) {
        img_artHistory.style.visibility = "hidden";
    }
    img_ArtSave.style.visibility = "hidden";
    img_ArtDelete.style.visibility = "hidden";
    //07. juuni 2011 - lõpp

    dtOpStart = new Date();
    statusAnim.style.visibility = "visible";
    QueryResponseAsync(oPrmDom);
} //StartOperation


/**
* 
*
* @method CheckXPath
* @param {String} sXPath
* @returns {Boolean}
*/
function CheckXPath(sXPath) {
    //rex = new RegExp("(al_p:[\\w\\d]+\\(.+?\\)(\\s*(<|<=|>|>=|=|!=)\\s*\\d+))", "g");
    var rex = /(al_p:[\w\d]+\(.+?\)(\s*(<|<=|>|>=|=|!=)\s*\d+))/g;
    var xpthNew = sXPath.replace(rex, ". = 0");

    try {
        var testNodes = oEditDOMRoot.selectNodes(xpthNew);
    }
    catch (e) {
        alert(e.name + " 0x" + hex(e.number, true) + ": '" + e.description + "'\n" + sXPath + "\n" + xpthNew);
        return false;
    }
    return true;
} //CheckXPath

/**
* 
*
* @method ShowXPathError
* @param {Object} objErr
*/
function ShowXPathError(objErr) {
    var errText;
    errText = ERROR_WORD + ": " + objErr.Source + '\r\n' + "Number: 0x" + Hex(objErr.number) + " (" + objErr.number + ")" + '\r\n\r\n' + objErr.Description;
    alert(errText, jsvbCritical, XPATH_ERR);
} //ShowXPathError


/**
* 
*
* @method asyncCompleted
* @param {Object} objXMLDom
*/
function asyncCompleted(objXMLDom) {
    ParseSrvInfo(objXMLDom);
    StopOperation();
} //asyncCompleted


/**
* 
*
* @method ParseSrvInfo
* @param {Object} oRespDom
*/
function ParseSrvInfo(oRespDom) {
    //sta, cnt, vol[, q:A], ["AppSuccess"|"AppFailure"|], statusText, status, responseText
    var sta, cnt, vol, qM, appSta, statusText, status, responseText;
    statusText = oRespDom.documentElement.selectSingleNode("statusText").text;
    status = parseInt(oRespDom.documentElement.selectSingleNode("status").text);
    responseText = oRespDom.documentElement.selectSingleNode("responseText").text;

    var qInfoStr, printSr;

    if (statusText == "OK") {
        appSta = oRespDom.documentElement.selectSingleNode("appSta").text;
        if (appSta == "AppSuccess") {
            sta = oRespDom.documentElement.selectSingleNode("sta").text;
            cnt = oRespDom.documentElement.selectSingleNode("cnt").text;
            //cnt = cnt.replace(" ", "");
            cnt = parseInt(cnt);
            vol = oRespDom.documentElement.selectSingleNode("vol").text;
            qM = oRespDom.documentElement.selectSingleNode("qM").text;
            if (sta == "Success") {
                if (sCmdId == "ClientRead" || sCmdId == "BrowseRead" || sCmdId == "prevNextRead" || sCmdId == "msSarnased" || sCmdId == "tyhjadViited") {
                    if (cnt == 0) {
                        ShowStatusInfo(ART_NOT_FOUND + " [" + qM + "]");
                    } else if (cnt == 1) {
                        sel_Vol.options(vol).selected = true;
                        sFromVolume = vol;
                        FillArtFrames(oRespDom.documentElement.selectSingleNode(DICPR + ":A"), true);
                        divFrameEdit.scrollTop = 0;
                        divFrameView.scrollTop = 0;
                        document.frames("frame_Images").window.scrollTo(0, 0);
                        if (document.all("frame_Browse").style.zIndex == -1)
                            bringZIndexToFront("div_appSisu");
                        ShowStatusInfo(ART_ONE_FOUND + " [" + qM + "]");
                    } else if (cnt > 1 || cnt == -1) {
                        oBrowseNode = oRespDom.documentElement.selectSingleNode("outDOM");
                        filterBy = "";
                        FillBrowseFrame(oBrowseNode);
                        bringZIndexToFront("frame_Browse");
                        ShowStatusInfo(jsReplace(ART_MANY_FOUND, "[%s]", jsFormatNumber(cnt, 0, -2, -2, -2)) + " [" + qM + "]");
                    }
                } else if (sCmdId == "srvXmlValidate") {
                    oBrowseNode = oRespDom.documentElement.selectSingleNode("outDOM");
                    filterBy = "";
                    FillBrowseFrame(oBrowseNode);
                    bringZIndexToFront("frame_Browse");
                    ShowStatusInfo("Vigaseid artikleid: " + cnt + " tk [" + qM + "]");
                } else if (sCmdId == "SaveList") {
                    ExportToExcel(oRespDom.documentElement.selectSingleNode("outDOM"));
                    ShowStatusInfo(jsReplace(EXPORT_OK, "[%s]", jsFormatNumber(cnt, 0, -2, -2, -2)));
                } else if (sCmdId == "ImportRead") {
                    if (cnt == 0) {
                        ShowStatusInfo(ART_NOT_FOUND);
                    } else if (cnt == 1) {
                        //     sel_Vol.options(vol).selected = true
                        var gspq, refnode, importedArt;
                        //GetSchemaPosQuery: teeb oStruDom - ist päringu following-sibling nimede kohta;
                        gspq = GetSchemaPosQuery(oEditDOMRoot.firstChild, DICPR + ":I");
                        refnode = oEditDOMRoot.firstChild.selectSingleNode(gspq);
                        importedArt = oRespDom.documentElement.selectSingleNode(DICPR + ":A/" + DICPR + ":I");
                        oEditDOMRoot.firstChild.insertBefore(importedArt, refnode);
                        oEditAll("ifrdiv").setAttribute("xmlChanged", 2);
                        if (dic_desc == "evs") {
                            var domCopy;
                            domCopy = oEditDOM.cloneNode(true);
                            TeisendaDOM(domCopy);
                            oViewAll("ifrviewdiv").innerHTML = domCopy.transformNode(oXslView);
                        } else {
                            oViewAll("ifrviewdiv").innerHTML = oEditDOM.transformNode(oXslView);
                        }
                        ShowStatusInfo(ART_ONE_FOUND);
                    }
                } else if (sCmdId == "ClientWrite") {
                    if (cnt == 1) {
                        //tühjad elemendid on  kustutatud;
                        FillArtFrames(oRespDom.documentElement.selectSingleNode(DICPR + ":A[1]"), false);
                        ShowStatusInfo(SAVE_OK + " [" + qM + "]");
                        //homonüümsete kontrolli korral võib tulemusena tulla mitu artiklit,;
                        //ka 'sQryInfo' tuleb uuesti võtta;
                    } else if (cnt > 1) {
                        bArtModified = false;
                        oBrowseNode = oRespDom.documentElement.selectSingleNode("outDOM");
                        sQryInfo = oBrowseNode.getAttribute("qinfo");
                        filterBy = "";
                        FillBrowseFrame(oBrowseNode);
                        bringZIndexToFront("frame_Browse");
                        ShowStatusInfo(jsReplace(ART_MANY_FOUND, "[%s]", jsFormatNumber(cnt, 0, -2, -2, -2)) + " [" + qM + "]");
                    } else if (cnt == 0) {
                        // homonüümsete kontrollil läks midagi metsa
                        FillArtFrames(oRespDom.documentElement.selectSingleNode(DICPR + ":A[1]"), false);
                        ShowStatusInfo("Homonüümsete kontroll = 0!" + " [" + qM + "]");
                    }
                } else if (sCmdId == "ClientAdd") {
                    if ((cnt == 1)) {
                        FillArtFrames(oRespDom.documentElement.selectSingleNode(DICPR + ":A[1]"), true);
                        bringZIndexToFront("div_appSisu");
                        ShowStatusInfo(ADD_OK + " [" + qM + "]");
                        sFromVolume = vol;
                        //homonüümsete kontrolli korral võib tulemusena tulla mitu artiklit,;
                        //ka 'sQryInfo' tuleb uuesti võtta;
                    } else if ((cnt > 1)) {
                        oBrowseNode = oRespDom.documentElement.selectSingleNode("outDOM");
                        sQryInfo = oBrowseNode.getAttribute("qinfo");
                        filterBy = "";
                        FillBrowseFrame(oBrowseNode);
                        bringZIndexToFront("frame_Browse");
                        ShowStatusInfo(jsReplace(ART_MANY_FOUND, "[%s]", jsFormatNumber(cnt, 0, -2, -2, -2)) + " [" + qM + "]");
                    }
                } else if (sCmdId == "ClientDelete") {
                    oEditDOMRoot.removeChild(oEditDOMRoot.firstChild);
                    //kui art puudub, on view.xsl tulemusena HTML-is ikkagi 10 BR-i ...;
                    oEditAll("ifrdiv").innerHTML = oEditDOM.transformNode(oXslEdit);
                    oViewAll("ifrviewdiv").innerHTML = oEditDOM.transformNode(oXslView);
                    //0 peaks näitama, et ühtegi homonüümset ei jäänud;
                    if ((cnt == 0)) {
                        ShowStatusInfo(DEL_OK + " [" + qM + "]");
                        sFromVolume = "";
                    } else {
                        oBrowseNode = oRespDom.documentElement.selectSingleNode("outDOM");
                        sQryInfo = oBrowseNode.getAttribute("qinfo");
                        filterBy = "";
                        FillBrowseFrame(oBrowseNode);
                        bringZIndexToFront("frame_Browse");
                        ShowStatusInfo(jsReplace(ART_MANY_FOUND, "[%s]", jsFormatNumber(cnt, 0, -2, -2, -2)) + " [" + qM + "]");
                    }
                } else if (sCmdId == "ClientRestore") {
                    oEditDOMRoot.removeChild(oEditDOMRoot.firstChild);
                    //kui art puudub, on view.xsl tulemusena HTML-is ikkagi 10 BR-i ...;
                    oEditAll("ifrdiv").innerHTML = oEditDOM.transformNode(oXslEdit);
                    oViewAll("ifrviewdiv").innerHTML = oEditDOM.transformNode(oXslView);
                    //1 peaks näitama, et sihtköites on 1 homonüümne;
                    if ((cnt == 1)) {
                        ShowStatusInfo(DEL_OK + " [" + qM + "]");
                        sFromVolume = "";
                    } else if ((cnt > 1)) {
                        oBrowseNode = oRespDom.documentElement.selectSingleNode("outDOM");
                        sQryInfo = oBrowseNode.getAttribute("qinfo");
                        filterBy = "";
                        FillBrowseFrame(oBrowseNode);
                        bringZIndexToFront("frame_Browse");
                        ShowStatusInfo(jsReplace(ART_MANY_FOUND, "[%s]", jsFormatNumber(cnt, 0, -2, -2, -2)) + " [" + qM + "]");
                    }
                } else if (sCmdId == "ClientPrint") {
                    if (cnt > 0) {
                        oBrowseNode = oRespDom.documentElement.selectSingleNode("outDOM/" + DICPR + ":sr");
                        var etw = ExportToWord(nStartPageNumber, bRemoveShaded, sWordFileName, doSpellCheck, oXslView, viewCSS.cssText, spn_msg, oBrowseNode);
                        if (etw > -1) {
                            ShowStatusInfo(jsReplace(EXPORT_OK, "[%s]", jsFormatNumber(cnt, 0, -2, -2, -2)) + " [" + qM + "]");
                        }
                    } else {
                        ShowStatusInfo(ART_NOT_FOUND);
                    }
                }
            } else if (sta == "ClientRead_TOOMANY") { //'ClientRead;
                ShowStatusInfo(ART_TOO_MANY + " (" + jsFormatNumber(cnt, 0, -2, -2, -2) + ")");
            } else if (sta == "ClientPrint_TOOMANY") { //'ClientPrint;
                ShowStatusInfo(ART_TOO_MANY + " (" + jsFormatNumber(cnt, 0, -2, -2, -2) + ")");
            } else if (jsLeft(sta, 24) == "Article already exists (") { //'ClientAdd;
                ShowStatusInfo(ART_EXISTS);
            } else {
                alert(sta);
                ShowStatusInfo("");
            }
        } else {
            alert("StatusText: " + statusText + '\r\n' + "Status: " + status + '\r\n\r\n' + "ResponseText: " + responseText + '\r\n' + SRVFUNC_ERROR + ": " + appSta);
            ShowStatusInfo("");
        }
    } else {
        alert("Status: " + status + '\r\n\r\n' + "ResponseText: " + responseText + '\r\n\r\n' + ERROR_WORD + ": " + statusText);
        ShowStatusInfo("");
    }
} //ParseSrvInfo


/**
* Ei tee midagi, kõik on välja kommenteeritud.
*
* @method ExportToExcel
* @param {Object} outDom
*/
function ExportToExcel(outDom) {

    //window.status = "Writing local file ..."
    //var strm
    //set strm = new ActiveXObject("ADODB.Stream")
    //strm.Type = adTypeText
    //strm.Charset = "utf-8"
    //strm.LineSeparator = adCRLF
    //strm.Open()
    //strm.WriteText(  //    outDom.xml  //)
    //strm.SaveToFile("c:/EELex/Väljatrükid/list.xml", adSaveCreateOverWrite)
    //strm.Close()
    //set strm = null

    //window.status = "Creating Excel object ...";
    //window.onerror=null;
    //var oExcel
    //oExcel = GetObject(, "Excel.Application");
    //if((err.number != 0)){
    //    err.Clear;
    //   oExcel = new ActiveXObject("Excel.Application");
    //}
    //if((err.number != 0)){
    //    if((err.number == 429)){ //ActivevX component cant create object;
    //        alert("Ei saa Excelit luua!", jsvbCritical, "ExportToExcel: " + err.Source);
    //    }else{
    //  alert("Viga Exceli loomises!:" + '\t' + "0x" + Hex(err.number)) + " (" + err.number + ")" + '\r\n\r\n' +  err.Description,  jsvbCritical, "ExportToExcel: " + err.Source;
    //    }
    //    err.Clear;
    //    return;
    //}
    //window.detachEvent("onerror");
    //oExcel.Visible = false

    //window.status = "Loading Excel document ...";
    //oExcel.Workbooks.Add;
    //var ws
    //ws = oExcel.Workbooks[1].Sheets[1];
    //ws.Name = "Päringu tulemused";
    //ws.Cells(1, 1).Value = "Köide";
    //ws.Cells(1, 2).Value = "Märksõna";
    //ws.Cells(1, 3).Value = "Leid";
    //ws.Cells(1, 4).Value = "Koostaja";
    //ws.Cells(1, 5).Value = "Toimetaja";
    //ws.Cells(1, 6).Value = "Peatoimetaja";
    //ws.Range("A1:F1").Font.Bold = true

    //window.status = "Customizing Excel doc ...";
    //var art, arts, i, s
    //arts = outDom.selectNodes("sr/A");
    //for i = 1 to arts.length;
    //   art = arts(i - 1);
    ////    s = art.selectSingleNode("vnr").text
    ////    s = "," + art.selectSingleNode("md/t").text
    ////    s = "," + art.selectSingleNode("l/t").text
    ////    s = "," + art.selectSingleNode("K").text
    ////    s = "," + art.selectSingleNode("T").text
    ////    s = "," + art.selectSingleNode("PT").text
    ////    ws.Cells[i].Value = s
    ////    ws.Range("A" + i + ":F" + i).Value = s
    //    ws.Cells(i + 1, 1).Value = art.selectSingleNode("vnr").text;
    //    ws.Cells(i + 1, 2).Value = art.selectSingleNode("md/t").text;
    //    ws.Cells(i + 1, 3).Value = art.selectSingleNode("l/t").text;
    //    ws.Cells(i + 1, 4).Value = art.selectSingleNode("K").text;
    //    ws.Cells(i + 1, 5).Value = art.selectSingleNode("T").text;
    //    ws.Cells(i + 1, 6).Value = art.selectSingleNode("PT").text;
    ////    if(((i Mod 1000) = 0)){
    ////        spn_msg.innerText = i
    ////    }
    //next;
    //oExcel.Visible = true

} //ExportToExcel


/**
* 
*
* @method ShowStatusInfo
* @param {String} sExtraInfo
*/
function ShowStatusInfo(sExtraInfo) {
    var nStatusQILen, sStatusQI;
    nStatusQILen = 80;
    if ((sQryInfo.length > nStatusQILen)) {
        sStatusQI = jsLeft(sQryInfo, nStatusQILen) + " ...";
    } else {
        sStatusQI = sQryInfo;
    }
    sStatusQI = jsReplace(sStatusQI, "&lt;", "<");
    sStatusQI = jsReplace(sStatusQI, "&gt;", ">");
    window.status = sStatusQI + ": " + sExtraInfo;
} //ShowStatusInfo


/**
* 
*
* @method StopOperation
*/
function StopOperation() {
    inp_RunQuery.disabled = false;
    if (!(document.body.all("inp_RunQueryXML") == null)) {
        inp_RunQueryXML.disabled = false;
    }

    //07. juuni 2011
    img_ArtAdd.style.visibility = "visible";
    img_ArtExport.style.visibility = "visible"; //'Word väljatrükk;
    if (!(document.body.all("img_SrTools") == null)) {
        img_SrTools.style.visibility = "visible";
    }
    if (!(document.body.all("img_readFirst") == null)) {
        img_readFirst.style.visibility = "visible";
    }
    if (!(document.body.all("img_readPrev") == null)) {
        img_readPrev.style.visibility = "visible";
    }
    if (!(document.body.all("img_readNext") == null)) {
        img_readNext.style.visibility = "visible";
    }
    if (!(document.body.all("img_readLast") == null)) {
        img_readLast.style.visibility = "visible";
    }
    if (!(document.body.all("img_artHistory") == null)) {
        img_artHistory.style.visibility = "visible";
    }
    //10. juuli 2011: paneEkspressioonid juures sätitakse vastavalt 'bArtSaveAllowed' ja 'bArtDelAllowed'
    if ((bArtSaveAllowed)) {
        img_ArtSave.style.visibility = "visible";
    }
    if ((bArtDelAllowed)) {
        img_ArtDelete.style.visibility = "visible";
    }
    //07. juuni 2011 - lõpp

    statusAnim.style.visibility = "hidden";
    var interval = (new Date().getTime() - dtOpStart.getTime());
    var seconds = Math.floor(interval / 1000);
    window.status = window.status + "; (" + Math.floor(seconds / 60) + "m, " + (seconds % 60) + "s)";
} //StopOperation


//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------

/**
* 
*
* @method FillBrowseFrame
* @param {Object} oOutDomNode
*/
function FillBrowseFrame(oOutDomNode) {
    nBrRowIndex = -1;

    //The frames collection
    //provides access to the contents of an IFRAME.
    //sColor = document.frames("sFrameName").document.body.style.backgroundColor

    browseDoc.open("text/html", "replace");
    if (oOutDomNode) { //oOutDomNode: srvfuncs 'outDOM'
        browseDoc.write(oOutDomNode.transformNode(oXslBrowse));
    }
    browseDoc.close;

    var veerg, myImg;
    if (browseSortBy) {
        veerg = browseDoc.all(browseSortBy);
        myImg = browseDoc.createElement("IMG");
        myImg.id = "srtImg";
        myImg.width = 25;
        myImg.height = 11;
        if ((browseSortOrder == "ascending")) {
            myImg.src = "graphics/sort_up.gif";
        } else {
            myImg.src = "graphics/sort_down.gif";
        }
        veerg.insertAdjacentElement("beforeEnd", myImg);
    }
    if (filterBy) {
        veerg = browseDoc.all(filterBy);
        myImg = veerg.all("filterImg");
        myImg.src = "graphics/plus.ico";
        myImg.title = WORD_All;
    }

    //You can access the IFRAME object's properties, but ! its contents,
    //through the object model of the page where the IFRAME object resides
    if (oOutDomNode) {
        browseDoc.onclick = browseTableClick;
        browseDoc.onkeyup = bodyOnKeyUp;
    }
} //FillBrowseFrame


/**
* 
*
* @method browseTableClick
*/
function browseTableClick() {
    var oSrc = frame_Browse.event.srcElement;
    var oRow;
    var i, unStr, tarr;
    var sPrmDomXml, oPrmDom;

    var brTbl = browseDoc.getElementById("browseTable");

    if (!(oSrc.tagName == "SPAN" || oSrc.tagName == "TH" || oSrc.tagName == "IMG")) {
        if (oSrc.parentElement.className == "_md") {
            oSrc = oSrc.parentElement;
        }
    }

    if (oSrc.tagName == "SPAN" && oSrc.className == "_md") {
        if (nBrRowIndex > -1) {
            brTbl.rows(nBrRowIndex).style.backgroundColor = "";
        }
        oRow = oSrc.parentElement.parentElement;
        nBrRowIndex = oRow.rowIndex;
        brTbl.rows(nBrRowIndex).style.backgroundColor = "silver"

        //@vf, '||', G;
        tarr = oSrc.value.split("||");

        sCmdId = "BrowseRead";
        // nt vsl 'C&F': innerText ei kõlba
        sQryInfo = oSrc.innerHTML;

        var qM;
        qM = "MySql";
        if (frame_Browse.event.ctrlLeft) {
            qM = "XML";
        }

        sPrmDomXml = "<prm>" +
                "<cmd>" + sCmdId + "</cmd>" +
                "<vol>" + tarr[0] + "</vol>" +
                "<nfo>" + sQryInfo + "</nfo>" +
                "<G>" + tarr[1] + "</G>" +
                "<qM>" + qM + "</qM>" +
               "</prm>";

        oPrmDom = IDD("String", sPrmDomXml, false, false, null);
        if (oPrmDom.parseError.errorCode != 0) {
            ShowXMLParseError(oPrmDom);
            return;
        }
        StartOperation(oPrmDom);
    } else if ((oSrc.tagName == "TD" && oSrc.className == "_koondParing") || (oSrc.tagName == "SPAN" && oSrc.className == "_xsmall2")) {
        if (asuKoht.indexOf("/__shs_test/") < 0) {
            if (oSrc.tagName == "TD") {
                oRow = oSrc.parentElement;
            } else {
                oRow = oSrc.parentElement.parentElement;
            }
            var mTekst = oRow.cells(2).innerText;
            var selectedDics = oRow.cells(3).innerText;
            if (selectedDics) {
                selectedDics = ';' + dic_desc + ';' + selectedDics.replace(/, /g, ';') + ';';
                var search = "cmd=otsi&ms=" + encodeURIComponent(RemoveSymbols(mTekst, ' ')) + "&dics=" + selectedDics;
                // eelex.eki.ee või eelex.dyn.eki.ee
                window.open("http://" + location.hostname + "/run/SL/Koond/Koond.html?" + search, "_koondParing", "", false);
            }
        }
    } else if (oSrc.tagName == "TH") {
        var leiudNode, sortNode;
        leiudNode = oXslBrowse.documentElement.selectSingleNode("xsl:template[@match = 'outDOM']/html/body/div[@id = 'browseTableDiv']/table[@id = 'browseTable']/tbody/xsl:for-each");
        if (oSrc.id == browseSortBy) {
            if (browseSortOrder == "ascending") {
                browseSortOrder = "descending";
            } else {
                browseSortOrder = "ascending";
            }
        } else {
            browseSortBy = oSrc.id;
            browseSortOrder = "ascending";
        }
        sortNode = leiudNode.selectSingleNode("xsl:sort");
        if (browseSortBy == "") { //'jnr;
            if (sortNode) {
                leiudNode.removeChild(sortNode);
            }
        } else {
            if (!sortNode) {
                sortNode = leiudNode.insertBefore(oXslBrowse.createNode(NODE_ELEMENT, NS_XSL_PR + ":sort", NS_XSL), leiudNode.firstChild);
            }
            var rex, mdNodes, lNodes;
            if (browseSortBy == "../md") {
                //oBrowseNode : <outDOM>;
                //            if((oBrowseNode.selectSingleNode("sr/A/md/@p") == null)){
                mdNodes = oBrowseNode.selectNodes("sr/A/md");
                var mdNode, mdValT;
                for (i = 0; i < mdNodes.length; i++) {
                    mdNode = mdNodes[i];
                    mdValT = mdNode.text;
                    rex = /(&\w+;)/g;
                    mdValT = mdValT.replace(rex, "");
                    mdValT = RemoveSymbols(mdValT, ' ');
                    rex = /(\s+$)/g;
                    mdValT = mdValT.replace(rex, "");
                    if (frame_Browse.event.ctrlLeft) {
                        mdNode.setAttribute("p", jsStrReverse(mdValT));
                    } else {
                        mdNode.setAttribute("p", mdValT);
                    }
                }
                //            }
                sortNode.setAttribute("select", "../md/@p");
            } else if (browseSortBy == "t") {
                //oBrowseNode : <outDOM>;
                //            if((oBrowseNode.selectSingleNode("sr/A/l/t/@p") == null)){
                var lNode, lValT;
                lNodes = oBrowseNode.selectNodes("sr/A/l/t");
                for (i = 0; i < lNodes.length; i++) {
                    lNode = lNodes[i];
                    lValT = lNode.text;
                    rex = /(&\w+;)/g;
                    lValT = lValT.replace(rex, "");
                    lValT = RemoveSymbols(lValT, ' ');
                    rex = /(\s+$)/g;
                    lValT = lValT.replace(rex, "");
                    if ((frame_Browse.event.ctrlLeft)) {
                        lNode.setAttribute("p", jsStrReverse(lValT));
                    } else {
                        lNode.setAttribute("p", lValT);
                    }
                }
                //            }
                sortNode.setAttribute("select", "t/@p");
            } else {
                sortNode.setAttribute("select", browseSortBy);
            }
            sortNode.setAttribute("order", browseSortOrder);
        }
        FillBrowseFrame(oBrowseNode);
    } else if (oSrc.tagName == "IMG" && oSrc.id == "filterImg") {
        var leid, filtritav;
        unStr = JR;
        if (oSrc.parentElement.id == filterBy) {
            lNodes = oBrowseNode.selectNodes("sr/A/l");
            for (i = 0; i < lNodes.length; i++) {
                leid = lNodes[i];
                leid.setAttribute("show", "true");
            }
            filterBy = "";
        } else {
            lNodes = oBrowseNode.selectNodes("sr/A/l");
            for (i = 0; i < lNodes.length; i++) {
                leid = lNodes[i];
                filtritav = leid.selectSingleNode(oSrc.parentElement.id).text;
                if (unStr.indexOf(JR + filtritav + JR) > -1) {
                    leid.setAttribute("show", "false");
                } else {
                    unStr = unStr + filtritav + JR;
                    leid.setAttribute("show", "true");
                }
            }
            filterBy = oSrc.parentElement.id;
        }
        FillBrowseFrame(oBrowseNode);
    } else if (oSrc.tagName == "IMG" && oSrc.id == "changeTable") {
        if (oBrowseNode) { //oOutDomNode: srvfuncs 'outDOM'
            //            if (brTbl.getAttribute("soors") == "fromServer") {
            //                changeTable();
            //            }
            //            else {
            //                FillBrowseFrame(oBrowseNode);
            //            }

            var thisQm = oBrowseNode.selectSingleNode("r/qM").text;
            if (thisQm.indexOf("MySQL") > -1) {
                alert("Tabeli muutmiseks peab päring olema tehtud XML viisil.\n\n(Vajuta 'xml' nuppu)");
                return;
            }

            var brTblCols = document.getElementById("div_BrTableCols");
            var skeemiJupp = document.getElementById("div_skeemiJupp");
            skeemiJupp.innerHTML = "";

            //div_ElemsMenu ja div_AttrsMenu <tr>:
            //class = 'mi'; id = sFullPath; value = 'qname|name|URI|IsElement|kirjeldav'
            var aElemInfo = sSeldElemValue.split("|");
            var seldQn = aElemInfo[0];

            //sNodeTest algab artiklist: "q:A/..." jne
            var sNodeTest;
            if (sSeldAttrValue != "") {
                sNodeTest = jsMid(sSeldItemId, 0, sSeldItemId.lastIndexOf("/"));
            } else {
                sNodeTest = sSeldItemId;
            }
            if (yldStruDom.documentElement.getAttribute("pr_sd:ver") == "2.0") {
                var yldStruNode = yldStruDom.documentElement.selectSingleNode(sNodeTest);
                if (yldStruNode.selectNodes("*").length > 0) {
                    var ul = document.createElement("ul");
                    ul.style.marginLeft = "6mm";
                    skeemiJupp.appendChild(ul);

                    var minOcc = yldStruNode.getAttribute("pr_sd:minOcc");
                    var maxOcc = yldStruNode.getAttribute("pr_sd:maxOcc");
                    if (maxOcc == 2000000000) {
                        maxOcc = String.fromCharCode(0x221E);
                    }
                    var tekst = "[" + minOcc + ", " + maxOcc + "] - &lt;" + yldStruNode.nodeName + "&gt;";
                    var nimeAttr = yldStruNode.getAttribute("pr_sd:nimi");
                    if (nimeAttr) {
                        var kirjeldavad = nimeAttr.split(";");
                        var kirjeldav = kirjeldavad[appKeeled[sAppLang]];
                        tekst += " = " + kirjeldav;
                    }

                    var li = document.createElement("li");
                    li.innerHTML = tekst;
                    ul.appendChild(li);

                    lisaHarud(yldStruNode, li, "");

                    brTblCols.style.pixelLeft = 512;
                    brTblCols.style.pixelTop = 128;
                    brTblCols.style.display = "";
                }
                else {
                    alert("Tabeli muutmiseks peab päring olema tehtud mingist grupist, elemendi pealt, millel on mingi struktuur!");
                    return;
                }
            }
            else {
                alert("Skeemi genereerimine tegemata!");
                return;
            }
        }
    } else if (oSrc.tagName == "IMG" && oSrc.id == "copyTable") {
        if (brTbl) {
            var ctlRng = browseDoc.body.createControlRange();
            ctlRng.add(brTbl);
            ctlRng.select();
            ctlRng.execCommand("Copy");
        }
    }
} //browseTableClick


/**
* 
*
* @method lisaHarud
* @param {Object} yNode
* @param {Object} liNode
* @param {String} ulId
*/
function lisaHarud(yNode, liNode, ulId) {
    var harud = yNode.selectNodes("*");
    for (var haruJnr = 0; haruJnr < harud.length; haruJnr++) {
        var ul = document.createElement("ul");
        ul.style.marginLeft = "6mm";
        liNode.appendChild(ul);

        var li = document.createElement("li");
        var inserted = ul.appendChild(li);
        var uusId = "";
        if (ulId.length > 0) {
            uusId = ulId + "/" + harud[haruJnr].nodeName;
        }
        else {
            uusId = harud[haruJnr].nodeName;
        }

        var chk = document.createElement("input");
        chk.type = "checkbox";
        chk.id = uusId;
        inserted = li.appendChild(chk);

        var minOcc = harud[haruJnr].getAttribute("pr_sd:minOcc");
        var maxOcc = harud[haruJnr].getAttribute("pr_sd:maxOcc");
        if (maxOcc == 2000000000) {
            maxOcc = String.fromCharCode(0x221E); // lõpmatus
        }

        var tekst = "[" + minOcc + ", " + maxOcc + "] - &lt;" + harud[haruJnr].nodeName + "&gt;";
        var nimeAttr = harud[haruJnr].getAttribute("pr_sd:nimi");
        if (nimeAttr) {
            var kirjeldavad = nimeAttr.split(";");
            var kirjeldav = kirjeldavad[appKeeled[sAppLang]];
            tekst += " = " + kirjeldav;
        }

        var lbl = document.createElement("label");
        lbl.htmlFor = uusId;
        lbl.innerHTML = tekst;
        inserted = li.appendChild(lbl);

        lisaHarud(harud[haruJnr], li, uusId);
    }
} // lisaHarud


/**
* 
*
* @method veerudOkClick
*/
function veerudOkClick() {
    var brTblCols = document.getElementById("div_BrTableCols");
    brTblCols.style.display = "none";

    var xslBrowse3 = IDD("File", "xsl/browse3.xsl", true, false, null);
    if (xslBrowse3.parseError.errorCode != 0) {
        ShowXMLParseError(xslBrowse3);
        return;
    }
    xslBrowse3.setProperty("AllowDocumentFunction", true);
    xslBrowse3.setProperty("AllowXsltScript", true);
    xslBrowse3.setProperty("SelectionLanguage", "XPath");
    xslBrowse3.setProperty("SelectionNamespaces", sXmlNsList);

    xslBrowse3.documentElement.setAttribute("xmlns:pref", DICURI);
    xslBrowse3.documentElement.setAttribute("xmlns:" + DICPR, DICURI);

    var skeemiJupp = document.getElementById("div_skeemiJupp");
    var linnukesed = skeemiJupp.getElementsByTagName("input");

    // Define a regular expression for repeated words.
    // Regex rx = new Regex(@"\b(?<word>\w+)\s+(\k<word>)\b",
    //          RegexOptions.Compiled | RegexOptions.IgnoreCase);
    // /\b([a-z]+) \1\b/gi

    var ptrn = "", reksStr = "^", yhine, mitu = 0, mitu2 = 0, ixL, yksik, linnuke;
    for (ixL = 0; ixL < linnukesed.length; ixL++) {
        linnuke = linnukesed[ixL];
        if (linnuke.type == "checkbox") {
            if (linnuke.checked) {
                ptrn += " " + linnuke.id;
                mitu++;
                if (mitu == 1) {
                    reksStr += "(\\s([\\w:]+\\/)+)[\\w:\\/]*";
                }
                else {
                    reksStr += "\\1[\\w:\\/]*";
                }
            }
        }
    }
    reksStr += "$";
    var reks = new RegExp(reksStr);

    //    var reks = /(((^|\s)[a-z\:]+\/)+)(.*?)\1{1}/g;
    // var reks = /^(\s([a-z\:]+\/)+)[a-z\:\/]*\1{1}/g;

    // \w - Equivalent to [A-Za-z0-9_]
    //    var reks = new RegExp("^((\\s([\\w:]+\\/)+)[\\w:\\/]*){" + (mitu - 1) + "}\\2([\\w:\\/]*)$");
    //    var reks = new RegExp("^(\\s([\\w:]+\\/)+[\\w:\\/]+){" + (mitu - 1) + "}\\1");

    // If the global flag is set for a regular expression, 
    // exec searches the string beginning at the position indicated by the value of lastIndex. 
    //
    // If the global flag is not set, 
    // exec ignores the value of lastIndex and searches from the beginning of the string.
    var result = reks.exec(ptrn);
    if (result) {
        yhine = jsTrim(result[1]);
        if (yhine.substr(yhine.length - 1, 1) == "/") {
            yhine = yhine.substr(0, yhine.length - 1);
        }
    }

    var veerud = "<xsl:variable name='veerud' xmlns:xsl='" + NS_XSL + "'>";
    veerud += "<veerg>Märksõna(d)</veerg>";

    var sisu = "<xsl:for-each select=\"l/t/*\" xmlns:xsl='" + NS_XSL + "'>";
    if (yhine) {
        sisu += "<xsl:for-each select=\"" + yhine + "\">";
    }
    sisu += "<xsl:element name=\"tr\">";

    sisu += "<xsl:element name=\"td\">" +
        "<xsl:element name=\"span\">" +
        "<xsl:attribute name=\"class\">_md</xsl:attribute>" +
        "<xsl:attribute name=\"value\">" +
            "<xsl:value-of select=\"concat($vf, '||', $G)\" />" +
        "</xsl:attribute>" +
        "<xsl:value-of select=\"al:RS(string($md))\" disable-output-escaping=\"yes\" />" +
        "</xsl:element>" +
    "</xsl:element>";

    for (ixL = 0; ixL < linnukesed.length; ixL++) {
        linnuke = linnukesed[ixL];
        if (linnuke.type == "checkbox") {
            if (linnuke.checked) {

                mitu2++;
                yksik = linnuke.id;

                var tekst = linnuke.parentElement.getElementsByTagName("label")[0].innerText;
                var kirjeldav;
                if (tekst.indexOf(" = ") > -1) {
                    kirjeldav = tekst.substr(tekst.indexOf(" = ") + 3);
                }
                else {
                    kirjeldav = yksik.substr(yksik.lastIndexOf("/") + 1);
                }
                veerud += "<veerg>" + kirjeldav + "</veerg>";

                if (yhine) {
                    yksik = linnuke.id.substr(yhine.length + 1);
                }
                if (mitu2 < mitu) {
                    sisu += "<xsl:element name=\"td\">" +
                                "<xsl:for-each select=\"" + yksik + "\">" +
                                    "<xsl:if test=\"position() &gt; 1\">" +
                                        "<xsl:text> :: </xsl:text>" +
                                    "</xsl:if>" +
                                    "<xsl:value-of select=\"al:RS(.)\" disable-output-escaping=\"yes\" />" +
                                    "<xsl:for-each select=\"@*[local-name() = 'i']\">" +
                                      "<xsl:call-template name=\"att2\"></xsl:call-template>" +
                                    "</xsl:for-each>" +
                                "</xsl:for-each>" +
                        "</xsl:element>";
                }
                else {
                    //                    sisu += "<xsl:for-each select=\"" + yksik + "\">" +
                    //                        "<xsl:element name=\"td\">" +
                    //                        "<xsl:value-of select=\"al:RS(.)\" disable-output-escaping=\"yes\" />" +
                    //                        "</xsl:element>" +
                    //                    "</xsl:for-each>";
                    sisu += "<xsl:element name=\"td\">" +
                                "<xsl:for-each select=\"" + yksik + "\">" +
                                    "<xsl:if test=\"position() &gt; 1\">" +
                                        "<xsl:text> :: </xsl:text>" +
                                    "</xsl:if>" +
                                    "<xsl:value-of select=\"al:RS(.)\" disable-output-escaping=\"yes\" />" +
                                    "<xsl:for-each select=\"@*[local-name() = 'i']\">" +
                                      "<xsl:call-template name=\"att2\"></xsl:call-template>" +
                                    "</xsl:for-each>" +
                                "</xsl:for-each>" +
                        "</xsl:element>";
                }
            }
        }
    }
    veerud += "</xsl:variable>";

    sisu += "</xsl:element>"; // <tr>

    if (yhine) {
        sisu += "</xsl:for-each>"; // 'ühine'
    }
    sisu += "</xsl:for-each>"; // l/t/*

    var veerudVar = xslBrowse3.documentElement.selectSingleNode("xsl:variable[@name = 'veerud']");
    var tempDom = IDD("String", veerud, false, false, null);
    if (tempDom.parseError.errorCode == 0) {
        veerudVar.parentNode.replaceChild(tempDom.documentElement, veerudVar);
    }
    else {
        alert(tempDom.parseError.reason);
        return;
    }
    var veerudSisu = xslBrowse3.documentElement.selectSingleNode(".//tbody[@id = 'browseTableTBody']//xsl:for-each[@select = 'l/t/*']");
    if (!veerudSisu) {
        return;
    }

    tempDom = IDD("String", sisu, false, false, null);
    if (tempDom.parseError.errorCode == 0) {
        veerudSisu.parentNode.replaceChild(tempDom.documentElement, veerudSisu);
    }
    else {
        alert(tempDom.parseError.reason);
        return;
    }

    browseDoc.open("text/html", "replace");
    browseDoc.write(oBrowseNode.transformNode(xslBrowse3));
    browseDoc.close;

    nBrRowIndex = -1;
    browseDoc.onclick = browseTable3Click;
} // veerudOkClick



/**
* 
*
* @method veerudCancelClick
*/
function veerudCancelClick() {
    var brTblCols = document.getElementById("div_BrTableCols");
    brTblCols.style.display = "none";
} // veerudCancelClick


/**
* 
*
* @method browseTable3Click
*/
function browseTable3Click() {
    var oSrc = frame_Browse.event.srcElement;
    var oRow;
    var i, unStr, tarr;
    var sPrmDomXml, oPrmDom;

    var brTbl = browseDoc.getElementById("browseTable");

    if (!(oSrc.tagName == "SPAN" || oSrc.tagName == "TH" || oSrc.tagName == "IMG")) {
        if (oSrc.parentElement.className == "_md") {
            oSrc = oSrc.parentElement;
        }
    }

    if (oSrc.tagName == "SPAN" && oSrc.className == "_md") {
        if (nBrRowIndex > -1) {
            brTbl.rows(nBrRowIndex).style.backgroundColor = "";
        }
        oRow = oSrc.parentElement.parentElement;
        nBrRowIndex = oRow.rowIndex;
        brTbl.rows(nBrRowIndex).style.backgroundColor = "silver"

        //@vf, '||', G;
        tarr = oSrc.value.split("||");

        sCmdId = "BrowseRead";
        // nt vsl 'C&F': innerText ei kõlba
        sQryInfo = oSrc.innerHTML;

        var qM = "MySql";
        if (frame_Browse.event.ctrlLeft) {
            qM = "XML";
        }

        sPrmDomXml = "<prm>" +
                "<cmd>" + sCmdId + "</cmd>" +
                "<vol>" + tarr[0] + "</vol>" +
                "<nfo>" + sQryInfo + "</nfo>" +
                "<G>" + tarr[1] + "</G>" +
                "<qM>" + qM + "</qM>" +
               "</prm>";

        oPrmDom = IDD("String", sPrmDomXml, false, false, null);
        if (oPrmDom.parseError.errorCode != 0) {
            ShowXMLParseError(oPrmDom);
            return;
        }
        StartOperation(oPrmDom);
    } else if (oSrc.tagName == "IMG" && oSrc.id == "changeTable") {
        FillBrowseFrame(oBrowseNode);
    } else if (oSrc.tagName == "IMG" && oSrc.id == "copyTable") {
        if (brTbl) {
            var ctlRng = browseDoc.body.createControlRange();
            ctlRng.add(brTbl);
            ctlRng.select();
            ctlRng.execCommand("Copy");
        }
    }
} //browseTable3Click



/**
* 
*
* @method FillArtFrames
* @param {Object} oArtNode
* @param {Boolean} delURHistory
*/
function FillArtFrames(oArtNode, delURHistory) {

    //lisatakse tühjad tekstinoodid "" elementidele, millel pole alamelemente ega teksti
    AddEmptyTexts(oArtNode);

    var avatavad, avatav, kinniLahtid, kinniLahti, edOAttr, avatud;

    //xml võrdlemiseks muudatuste kindlakstegemisel, 'oArtNode' algab <A>
    oOrgArtNode = oArtNode.cloneNode(true);
    avatavad = oOrgArtNode.selectNodes(".//*/@" + DICPR + ":edO");
    avatavad.removeAll();

    artMuudatused = "";
    if ((delURHistory)) {
        urfragment = oEditDOM.createDocumentFragment();
        urindex = -1;
        urlast = urindex;

        if (!(yldStruDom == null)) {
            //Sõnapered: "maa" ja "töö": üle 30000 märgi;
            if ((oArtNode.xml.length > 10240)) {
                avatud = "0";
            } else {
                avatud = "1";
            }
            edOAttr = oArtNode.ownerDocument.createNode(NODE_ATTRIBUTE, DICPR + ":edO", DICURI);
            avatavad = yldStruDom.documentElement.selectNodes(".//*[@" + DICPR + ":edO]");
            for (i = 0; i < avatavad.length; i++) {
                avatav = avatavad[i];
                kinniLahtid = oArtNode.selectNodes(".//" + avatav.nodeName);
                for (j = 0; j < kinniLahtid.length; j++) {
                    kinniLahti = kinniLahtid[j];
                    //see siga ei tööta prefiksiga ..., vähemasti järgneva XSLt teisenduse jaoks;
                    //neid on küll, nt @O salvestamisel;
                    //ilmselt salvestamisel ikkagi käheb kõik korda ...;
                    //kinniLahti.setAttribute(DICPR + ":edO", "0");
                    edOAttr.value = avatud;
                    kinniLahti.attributes.setNamedItem(edOAttr.cloneNode(true));
                }
            }
        }
    }

    if ((oEditDOMRoot.hasChildNodes())) {
        oEditDOMRoot.replaceChild(oArtNode, oEditDOMRoot.firstChild);
    } else {
        oEditDOMRoot.appendChild(oArtNode);
    }

    artOrgString = getXmlString(oEditDOM);

    var oM1Node = oEditDOMRoot.selectSingleNode(first_default);
    sOrgMarkSona = oM1Node.text;
    sOrgHomnr = oM1Node.getAttribute(qn_homnr);
    if (sOrgHomnr == null)
        sOrgHomnr = '';

    var ptElem, pt, tlElem, tElem, t = '', tlTekst = '', klElem, kElem, k;
    ptElem = oEditDOMRoot.selectSingleNode(DICPR + ":A/" + DICPR + ":PT");
    if (ptElem) {
        pt = ptElem.text;
    } else {
        pt = "";
    }

    tElem = oEditDOMRoot.selectSingleNode(DICPR + ":A/" + qn_toimetaja);
    if (tElem) {
        t = tElem.text;
    }

    tlElem = oEditDOMRoot.selectSingleNode(DICPR + ":A/" + DICPR + ":TL");
    if (tlElem) {
        tlTekst = tlElem.text;
        if (dic_desc != 'psv') {
            if (t.length > 0) {
                tlTekst = t + ", " + tlTekst;
            }
        }
    }
    if (dic_desc == 'elt') {
        tlTekst = "";
        tlElem = oEditDOMRoot.selectSingleNode(DICPR + ":A/" + DICPR + ":lTL");
        if (tlElem) {
            tlTekst += tlElem.getAttribute(DICPR + ":nimi") + ", " + tlElem.getAttribute(DICPR + ":aeg");
        }
        tlElem = oEditDOMRoot.selectSingleNode(DICPR + ":A/" + DICPR + ":eTL");
        if (tlElem) {
            if (tlTekst) {
                tlTekst += "; ";
            }
            tlTekst += tlElem.getAttribute(DICPR + ":nimi") + ", " + tlElem.getAttribute(DICPR + ":aeg");
        }
    }

    klElem = oEditDOMRoot.selectSingleNode(DICPR + ":A/" + DICPR + ":KL");
    if (klElem) {
        kElem = oEditDOMRoot.selectSingleNode(DICPR + ":A/" + qn_autor);
        k = kElem.text;
    } else {
        k = "";
    }

    var msgSisu = "";
    if (k) {
        msgSisu = "<img src='graphics/msgbox_info_16_16.ico'><span style='color:green;'> " + jsReplace(ENTRY_STARTED, "[%s]", k) + "</span>";
    }
    if (tlTekst) {
        msgSisu = "<img src='graphics/msgbox_info_16_16.ico'><span style='color:blue;'> Artiklile on lisatud toimetamise lõpu märge: " + tlTekst + "</span>";
    }
    if (pt) {
        msgSisu = "<img src='graphics/msgbox_info_16_16.ico'><span style='color:red;'> " + jsReplace(ENTRY_SIGNED, "[%s]", pt) + "</span>";
    }

    spn_msg.innerHTML = msgSisu;

    bArtSaveAllowed = false;
    bArtDelAllowed = false;

    if ((pt != "")) {
        if (sUsrName == pt && bArtSignAllowed) { //bArtSignAllowed: srtegija ja ptd hulgas;
            bArtSaveAllowed = true;
            bArtDelAllowed = true;
        }
    } else {
        // 09. sept 11: toimetajad saavad üle kirjutada artikleid, millele on märgitud juurde toimetamise lõpp
        // nt PSV: Liivi Hollman lisab juurde videod Jelena lõpuni toimetatud artiklitele
        if ((srTegija)) {
            if (dic_desc == "psv") {
                bArtSaveAllowed = true;
                bArtDelAllowed = true;
            }
            else {
                if (tlTekst != '') {
                    if (sUsrName == t) {
                        bArtSaveAllowed = true;
                        bArtDelAllowed = true;
                    }
                }
                else {
                    bArtSaveAllowed = true;
                    bArtDelAllowed = true;
                }
            }
        }
    }

    div_ArtToolsMenu.innerHTML = "";
    if (srTegija) {
        if (!(document.all("img_ArtTools") == null)) {
            lisa_KL_TL_PT();
            lisaVeelArtToolse();
            if (!(div_ArtToolsMenu.innerHTML == "")) {
                bArtToolsEnabled = true;
            } else {
                bArtToolsEnabled = false;
            }
        }
        if ((zeus.indexOf(";" + sUsrName + ";") > -1)) {
            bArtSaveAllowed = true;
            bArtDelAllowed = true;
        }
    }

    //'16. juuni 2011
    //var tyhi
    //set tyhi = oEditDOMRoot.selectSingleNode(".//text()[. = '']")
    //if(! (tyhi == null)){
    //    'kui see on kunagi lisatud tähelepanu juthimiseks, siis olgu juba
    //    tyhi.text = "???----------------------------------------------------------------------???"
    //}

    oClicked = null;

    vaatedRefresh(2);

    fillImgFrame();

    if (!(document.all("img_artHistory") == null)) {
        var tblAjalugu, rida, veerg, artGuid;
        tblAjalugu = div_ArtHistoryMenu.all("tbl_ArtHistoryMenu");
        if ((tblAjalugu.rows.length == 100)) {
            tblAjalugu.deleteRow(tblAjalugu.rows.length - 1);
        }
        rida = tblAjalugu.insertRow(0);
        rida.className = "mi";
        artGuid = oEditDOMRoot.selectSingleNode(DICPR + ":A/" + qn_guid).text;
        rida.id = artGuid;
        rida.setAttribute("v", sFromVolume); //'"ief1" jne;
        veerg = rida.insertCell();
        veerg.style.width = "50%";
        veerg.innerHTML = sOrgMarkSona;
        veerg = rida.insertCell();
        veerg.innerHTML = new Date();
    }

} //FillArtFrames


/**
* 
*
* @method fillImgFrame
*/
function fillImgFrame() {
    var brdStyle, fiBodyHTML;
    brdStyle = "2px solid black"

    fiBodyHTML = ""

    //class='myText' kirjutatakse allpool html-i
    //
    if ((dic_desc == "od_")) {
        var tmen, tmet;
        tmen = oEditDOMRoot.selectSingleNode(DICPR + ":A/" + DICPR + ":P/" + DICPR + ":tmen").text;
        tmet = oEditDOMRoot.selectSingleNode(DICPR + ":A/" + DICPR + ":P/" + DICPR + ":tmet").text;
        //2013: mõttekriips "en dash";
        fiBodyHTML = "<p style='font-family:\"Arial\";font-weight:bold;font-size:large;'>" + "<i>" + sMSortVal + ": " + tmen + "</i> " + String.fromCharCode(0x2013) + " " + tmet + " <span id='addPic' class='myText' title='Lisa' style='font-size:small;'>&#xa0;Lisa pilt&#xa0;</span>" + "</p>";
    } else {
        fiBodyHTML = "<p style='font-family:\"Arial\";font-weight:bold;font-size:large;'>" + sMSortVal + ": <span id='addPic' class='myText' title='Lisa' style='font-size:small;'>&#xa0;Lisa pilt&#xa0;</span>" + "</p>";
    }


    var pildid, pilt, pf, imgId, olemas, mitu

    //A/P/plt - Oxford-Duden, Liivi-saksa järgi
    //
    pildid = oEditDOMRoot.selectNodes(DICPR + ":A/" + DICPR + ":P/" + DICPR + ":plt");
    olemas = true;
    mitu = document.frames("frame_Images").document.body.all.tags("DIV").length

    for (i = 0; i < pildid.length; i++) {
        pilt = pildid[i];
        pf = pilt.selectSingleNode(DICPR + ":pf").text; //'od_: '011_med.jpg';
        imgId = jsMid(pf, 0, pf.lastIndexOf("_")); //'od_: '011';
        if ((document.frames("frame_Images").document.body.all(imgId) == null)) {
            olemas = false;
        }
        fiBodyHTML = fiBodyHTML + "<div id='" + imgId + "'>" + "<span id='chPic' class='myText' title='Muuda'>Fail: " + pf + "</span> " + "<span id='rmvPic' class='myText' title='Eemalda' style='color:red;'>Eemalda</span>" + "<br/>" + "<img title='" + pf + "' src='__sr/" + dic_desc + "/pictures/" + pf + "'" + "style='border:" + brdStyle + ";'>" + "</img>" + "</div>" + "<br/>";
    }

    if ((pildid.length == 0)) {
        olemas = false;
    } else {
        if ((pildid.length != mitu)) {
            olemas = false;
        }
    }

    if (!(olemas)) {
        var imagesDoc, fiDocHTML;
        imagesDoc = document.frames("frame_Images").document.open("text/html", "replace");
        fiDocHTML = "<html>" + "<head>" + "<META HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=utf-8\"/>" + "<style type=\"text/css\">" + ".myText {background-color:silver;cursor:hand;}" + "</style>" + "</head>" + "<body>" + fiBodyHTML + "</body>" + "</html>"

        imagesDoc.write(fiDocHTML);

        imagesDoc.close;

        frame_Images.document.body.onclick = fiOnClick;
        frame_Images.document.body.ondblclick = showLargePicture;
    }

} //fillImgFrame


/**
* 
*
* @method imgImagesClick
*/
function imgImagesClick() {
    bringZIndexToFront("frame_Images");
} //imgImagesClick


/**
* 
*
* @method bringZIndexToFront
* @param {String} ziName
*/
function bringZIndexToFront(ziName) {

    document.all(ziName).style.zIndex = -1

    var ziNames, tarr, t2, i;
    ziNames = "div_appSisu,-2;frame_Browse,-3;frame_dbgPrint,-4;frame_Images,-5";
    tarr = ziNames.split(";");
    for (i = 0; i < tarr.length; i++) {
        t2 = tarr[i].split(",");
        if ((t2[0] != ziName)) {
            document.all(t2[0]).style.zIndex = parseInt(t2[1]);
        }
    }
} //bringZIndexToFront


/**
* 
*
* @method DeleteEmptys
* @param {Object} deleteFrom
*/
function DeleteEmptys(deleteFrom) {
    var oEmptyNodes
    oEmptyNodes = deleteFrom.selectNodes(".//*[normalize-space(.) = '' or normalize-space(.) = '-???-']");
    oEmptyNodes.removeAll
    oEmptyNodes = deleteFrom.selectNodes(".//*[not(text() or *)]");
    oEmptyNodes.removeAll
    oEmptyNodes = deleteFrom.selectNodes(".//@*[. = '' or . = '-???-'][not(local-name() = 'mm' or local-name() = 'mlm')]");
    oEmptyNodes.removeAll;
} //DeleteEmptys


/**
* 
*
* @method GetXSDDateTime
* @param {Object} dNow või String?
*/
function GetXSDDateTime(dNow) {
    var y4 = dNow.getFullYear();
    var mo2 = (dNow.getMonth() < 9 ? '0' : '') + (dNow.getMonth() + 1);
    var d2 = (dNow.getDate() < 10 ? '0' : '') + (dNow.getDate());
    var h2 = (dNow.getHours() < 10 ? '0' : '') + (dNow.getHours());
    var mi2 = (dNow.getMinutes() < 10 ? '0' : '') + (dNow.getMinutes());
    var s2 = (dNow.getSeconds() < 10 ? '0' : '') + (dNow.getSeconds());
    var sDateTime = y4 + '-' + mo2 + '-' + d2 + 'T' + h2 + ':' + mi2 + ':' + s2;
    return sDateTime;
} //GetXSDDateTime


/**
* 
*
* @method XMLChildTagsCount
* @param {Object} thisnode
* @param {String} thisname
*/
function XMLChildTagsCount(thisnode, thisname) {
    return parseInt(thisnode.selectNodes(thisname).length);
} //XMLChildTagsCount


/**
* 
*
* @method GetSchemaPosQuery
* @param {Object} seldElement
* @param {String} newElemQName
* @returns {String}
*/
function GetSchemaPosQuery(seldElement, newElemQName) {
    var GetSchemaPosQuery;
    var sPr, sUri, sBN, i, snPr, snQN;
    i = newElemQName.indexOf(":");
    if ((i > 0)) {
        sPr = jsMid(newElemQName, 0, i);
        sBN = jsMid(newElemQName, i + 1);
    } else {
        sPr = "";
        sBN = newElemQName;
    }
    sUri = oXmlNsm.getURI(sPr);

    var seldElementDecl, elFound, oParticle, nextpred;
    seldElementDecl = oXmlSc.getDeclaration(seldElement);

    var oXmlFrDom, aAnyNames;

    if ((seldElementDecl.type.itemType == SOMITEM_COMPLEXTYPE)) {
        if ((seldElementDecl.type.contentType > SCHEMACONTENTTYPE_TEXTONLY)) {
            if ((seldElementDecl.type.contentModel.particles.length > 0)) {
                if ((seldElementDecl.type.contentModel.itemType == SOMITEM_SEQUENCE)) {
                    if ((seldElementDecl.type.contentModel.particles[0].itemType == SOMITEM_ANY)) {
                        oXmlFrDom = IDD("file", "xml/" + dic_desc + "/aa_" + unName(seldElement.nodeName) + ".xml", false, false, null);
                        if ((oXmlFrDom.parseError.errorCode != 0)) {
                            GetSchemaPosQuery = "Suvaline";
                        } else {
                            aAnyNames = oXmlFrDom.documentElement.text.split("|");
                            elFound = false;
                            nextpred = "";
                            for (i = 0; i < aAnyNames.length; i++) {
                                if ((elFound)) {
                                    nextpred = nextpred + " or name() = '" + aAnyNames[i] + "'";
                                }
                                if ((aAnyNames[i] == newElemQName)) {
                                    elFound = true;
                                }
                            }
                            if (!(nextpred == "")) {
                                GetSchemaPosQuery = "*[" + jsMid(nextpred, 4) + "][1]";
                            } else {
                                GetSchemaPosQuery = "/.."; //'empty nodeset;
                            }
                        }
                    } else {
                        elFound = false;
                        nextpred = "";
                        var partiklid = seldElementDecl.type.contentModel.particles;
                        for (i = 0; i < partiklid.length; i++) {
                            oParticle = partiklid[i];
                            if (elFound) {
                                snPr = oXmlNsm.getPrefixes(oParticle.namespaceURI)[0];
                                if (!(snPr == "")) {
                                    snQN = snPr + ":" + oParticle.name;
                                } else {
                                    snQN = oParticle.name;
                                }
                                nextpred = nextpred + " or name() = '" + snQN + "'";
                            }
                            if ((oParticle.name == sBN && oParticle.namespaceURI == sUri)) {
                                elFound = true;
                            }
                        }
                        if (!(nextpred == "")) {
                            GetSchemaPosQuery = "*[" + jsMid(nextpred, 4) + "][1]";
                        } else {
                            if ((elFound)) {
                                GetSchemaPosQuery = "/.."; //'empty nodeset;
                            } else {
                                GetSchemaPosQuery = "Ei saa";
                            }
                        }
                    }
                } else { // if ((seldElementDecl.type.contentModel.itemType == SOMITEM_SEQUENCE)) { //no nt choice v all;
                    GetSchemaPosQuery = "Suvaline";
                }
            } else { // if ((seldElementDecl.type.contentModel.particles.length > 0)) {
                GetSchemaPosQuery = "Ei saa";
            }
        } else { // if ((seldElementDecl.type.contentType > SCHEMACONTENTTYPE_TEXTONLY)) {
            GetSchemaPosQuery = "Ei saa";
        }
    } else { // if ((seldElementDecl.type.itemType == SOMITEM_COMPLEXTYPE)) {
        GetSchemaPosQuery = "Ei saa";
    }
    return GetSchemaPosQuery;
} //GetSchemaPosQuery


/**
* 
*
* @method imgRecordClick
*/
function imgRecordClick() {
    bringZIndexToFront("div_appSisu");
} //imgRecordClick


/**
* 
*
* @method imgBrowseClick
*/
function imgBrowseClick() {
    if ((salvestaJaKatkesta())) {
        return;
    }
    bringZIndexToFront("frame_Browse");
} //imgBrowseClick

/**
* 
*
* @method imgArtPrintClick
*/
function imgArtPrintClick() {
    if ((oEditDOMRoot.hasChildNodes())) {
        var smdArgs;
        smdArgs = ifrviewdiv.outerHTML + JR + viewCSS.cssText;
        window.showModalDialog("html/artPrint.htm", smdArgs, "dialogHeight:768px;dialogWidth:1024px;center:yes;edge:sunken;help:no;resizable:yes;scroll:yes;status:no;unadorned:no");
    }
} //imgArtPrintClick

/**
* 
*
* @method ShowSchema
*/
function ShowSchema() {
    window.open("html/schema.htm", "_blank", "channelmode=no,directories=no,fullscreen=no,location=no,menubar=no,resizable=yes,scrollbars=yes,status=yes,titlebar=yes,toolbar=yes");
} //ShowSchema

/**
* 
*
* @method ShowTipsTricks
*/
function ShowTipsTricks() {
    window.open("help/tips.htm", "_blank", "channelmode=no,directories=no,fullscreen=no,location=no,menubar=no,resizable=yes,scrollbars=yes,status=yes,titlebar=yes,toolbar=yes");
} //ShowTipsTricks

/**
* 
*
* @method ShowDicHelp
*/
function ShowDicHelp() {
    if ((appDesc == "EXSA")) {
        window.open("help/j.htm", "_blank", "channelmode=no,directories=no,fullscreen=no,location=yes,menubar=no,resizable=yes,scrollbars=yes,status=yes,titlebar=yes,toolbar=yes");
    } else {
        window.open("http://eelex.eki.ee/~eelex/juhendid/eelex_juhend/EELex_juhend.htm", "_blank", "channelmode=no,directories=no,fullscreen=no,location=yes,menubar=no,resizable=yes,scrollbars=yes,status=yes,titlebar=yes,toolbar=yes");
    }

} //ShowDicHelp

/**
* 
*
* @method getAdvQuery
*/
function getAdvQuery() {
    //var sParms, smdArgs;
    //smdArgs = Array(window, oEditDOMRoot);
    //sParms = window.showModalDialog("html/qry_adv.htm",  smdArgs,  "dialogHeight:500px;dialogWidth:800px;center:yes;edge:sunken;help:no;resizable:yes;scroll:yes;status:no;unadorned:no");
    //if((sParms == "")){
    // return;
    //}
} //getAdvQuery

/**
* 
*
* @method ShowAdminXsl2
*/
function ShowAdminXsl2() {
    window.open("html/gen_xsl2.htm", "_blank", "channelmode=no,directories=no,fullscreen=no,location=no,menubar=no,resizable=yes,scrollbars=yes,status=yes,titlebar=yes,toolbar=yes");
} //ShowAdminXsl2


//-----------------------------------------------------------------------------------
//-------------------------- L I S A D ----------------------------------------------
//-----------------------------------------------------------------------------------
/**
* 
*
* @method bodyOnKeyUp
*/
function bodyOnKeyUp() {
    var oEvent, oSrc, sSrc, rng, i

    if (!(window.event == null)) {
        sSrc = "app";
        oEvent = window.event;
    } else if (!(frame_Browse.event == null)) {
        sSrc = "browse";
        oEvent = frame_Browse.event;
    }
    oSrc = oEvent.srcElement

    if (!(oEvent.ctrlKey || oEvent.shiftKey || oEvent.altKey)) {
        if ((oEvent.keyCode == 27)) { //ESC;
            document.releaseCapture();
            if ((oSrc.id == "oClickedSelect" || oSrc.id == "oClickedTextArea")) {
                if ((oSrc.id == "oClickedSelect")) {
                    oSrc.selectedIndex = -1;
                }
                oSrc.blur();
            }
        } else if ((oEvent.keyCode == 13)) { //Enter;
            if ((oSrc.id == "oClickedSelect" || oSrc.id == "oClickedTextArea")) {
                oSrc.blur();
            } else if ((divFrameEdit.contains(oSrc) && (oSrc.tagName == "SPAN" || oSrc.tagName == "IMG"))) {
                oSrc.click();
                //Ctrl + Enter on IE enda oma ...;
                //  }else if((oEvent.ctrlKey)){
                //   inp_RunQueryXML.click()
            } else {
                inp_RunQuery.click();
            }
        } else if ((oEvent.keyCode == 113)) { //F2;
            if ((divFrameEdit.contains(oSrc))) {
                if (oSrc.tagName == "SPAN" || oSrc.tagName == "IMG") {
                    oSrc.click();
                } else if (oSrc.id == "oClickedTextArea") {
                    var retVal, sLinkVols, opt, currTekst, oclid, smdArgs;
                    currTekst = oSrc.value;
                    sLinkVols = "";
                    var optionid = sel_Vol.options;
                    for (i = 0; i < optionid.length; i++) {
                        opt = optionid[i];
                        if ((opt.id == sAllVolId)) {
                            break;
                        }
                        sLinkVols = sLinkVols + "<option id='" + opt.id + "'";
                        if ((opt.selected == true)) {
                            sLinkVols = sLinkVols + " selected";
                        }
                        sLinkVols = sLinkVols + ">" + opt.text + "</option>";
                    }
                    smdArgs = currTekst + JR + dic_desc + JR + sLinkVols + JR + first_default + JR + oSrc.innerText + JR + sUsrName;
                    retVal = window.showModalDialog("html/listing.htm", smdArgs, "dialogHeight:200px;dialogWidth:500px;center:yes;edge:sunken;help:no;resizable:yes;scroll:yes;status:no;unadorned:no");
                    if (retVal != null) {
                        var tarr, newVal, guid, vol;
                        tarr = retVal.split(JR);
                        newVal = tarr[2];
                        guid = tarr[1];
                        vol = tarr[0]

                        oclid = oClicked.id

                        clickedNode.text = newVal;
                        //märksõna/termin;
                        if ((selectedNode.nodeName == qn_ms && selectedNode.nodeType == NODE_ELEMENT)) {
                            selectedNode.setAttribute(qn_sort_attr, getSortVal(selectedNode, true, true));
                        }

                        if (!(snDecl == null)) {
                            if ((snDecl.type.itemType == SOMITEM_COMPLEXTYPE)) {
                                if ((snDecl.type.attributes.length > 0)) {
                                    var kfFound, gAttr, kfAttr, oParticle, oAttr;
                                    kfFound = false;
                                    gAttr = "";
                                    kfAttr = "";
                                    for (i = 0; i < snDecl.type.attributes.length; i++) {
                                        oParticle = snDecl.type.attributes[i];
                                        if ((oParticle.name == "KF" || oParticle.name == "aKF") && oParticle.namespaceURI == DICURI) {
                                            kfFound = true;
                                            kfAttr = oParticle.name;
                                        }
                                        if ((oParticle.name == "g" || oParticle.name == "aG") && oParticle.namespaceURI == DICURI) {
                                            gAttr = oParticle.name;
                                        }
                                    }
                                    if ((kfFound)) {
                                        oAttr = oEditDOM.createNode(NODE_ATTRIBUTE, DICPR + ":" + kfAttr, DICURI);
                                        oAttr.text = vol;
                                        selectedNode.attributes.setNamedItem(oAttr);
                                    }
                                    if ((gAttr.length > 0)) {
                                        oAttr = oEditDOM.createNode(NODE_ATTRIBUTE, DICPR + ":" + gAttr, DICURI);
                                        oAttr.text = guid;
                                        selectedNode.attributes.setNamedItem(oAttr);
                                    }
                                }
                            }
                        }

                        oEditAll("ifrdiv").setAttribute("xmlChanged", 2);
                        oClicked = oEditAll(oclid);
                        if ((oViewAll("_copyDiv") == null)) {
                            if ((dic_desc == "evs")) {
                                var domCopy;
                                domCopy = oEditDOM.cloneNode(true);
                                TeisendaDOM(domCopy);
                                oViewAll("ifrviewdiv").innerHTML = domCopy.transformNode(oXslView);
                            } else {
                                oViewAll("ifrviewdiv").innerHTML = oEditDOM.transformNode(oXslView);
                            }
                        }
                        oClicked.focus()

                    }
                }
            }
        } else if ((oEvent.keyCode == 119)) { //F8;
            if ((divFrameEdit.contains(oSrc) && oSrc.id == "oClickedTextArea")) {
                if (!(oViewAll("_copyDiv") == null)) {
                    rng = document.selection.createRange();
                    rng.text = sTextToCopy;
                }
            }
        }
    } else {
        if ((oEvent.ctrlLeft && oEvent.shiftLeft) && !oEvent.altKey) {
            if (oEvent.keyCode == "1".charCodeAt(0)) {
                switchEdit(xsl1Edit);
            } else if (oEvent.keyCode == "2".charCodeAt(0)) {
                switchEdit(xsl2Edit);
            } else if (oEvent.keyCode == "3".charCodeAt(0)) {
                switchEdit(xsl3Edit);
            } else if (oEvent.keyCode == 37) { //nool vasakule;
                if (oEvent.srcElement.id != "oClickedTextArea") {
                    img_readPrev.focus();
                    img_readPrev.click();
                }
            } else if (oEvent.keyCode == 39) { //nool paremale;
                if (oEvent.srcElement.id != "oClickedTextArea") {
                    img_readNext.focus();
                    img_readNext.click();
                }
            } else if (oEvent.keyCode == "V".charCodeAt(0)) {
                img_ArtValidate.click();
            } else if (oEvent.keyCode == "S".charCodeAt(0)) {
                img_ArtSave.click();
            } else if (oEvent.keyCode == "K".charCodeAt(0)) {
                img_ArtDelete.click();
            } else if (oEvent.keyCode == "0".charCodeAt(0)) {
                if (eeLexAdmin.indexOf(";" + sUsrName + ";") > -1) {
                    //                    ShowAdminXsl2();
                    ShowSkeemiGen();
                }
            } else if (oEvent.keyCode == "9".charCodeAt(0)) {
                if (eeLexAdmin.indexOf(";" + sUsrName + ";") > -1) {
                    ShowAdminView();
                }
            } else if (oEvent.keyCode == 123) { //F12;
                bringZIndexToFront("frame_dbgPrint");
            }
        } else {
            if (oEvent.ctrlLeft && !(oEvent.altKey || oEvent.shiftKey)) {
                if (oSrc.id == "oClickedTextArea") {
                    if (oEvent.keyCode == 48) { // '0' ('=');
                        rng = document.selection.createRange();
                        rng.text = msAsendus;
                    } else if (oEvent.keyCode == 221) { // '-', ainult ek klaviatuuri korral !;
                        if (selectedNode.baseName == "xmv") {
                            var vasteNode, vasteOsa, osaErald;
                            osaErald = "|";
                            vasteNode = selectedNode.selectSingleNode("ancestor::" + DICPR + ":xg/" + DICPR + ":x");
                            i = vasteNode.text.indexOf(osaErald);
                            if (i > -1) {
                                vasteOsa = jsMid(vasteNode.text, 0, i);
                            } else {
                                vasteOsa = vasteNode.text;
                            }
                            rng = document.selection.createRange();
                            rng.text = vasteOsa;
                        }
                    } else if (oEvent.keyCode == 222) { // '~', tilde;
                        rng = document.selection.createRange();
                        rng.text = String.fromCharCode(0x0303) //kombineeriv tilde;
                    } else if (oEvent.keyCode == 49) { // '1';
                        rng = document.selection.createRange();
                        rng.text = String.fromCharCode(0x0300) //kombineeriv graavis;
                    } else if (oEvent.keyCode == 50) { // '2';
                        rng = document.selection.createRange();
                        rng.text = String.fromCharCode(0x0301) //kombineeriv akuut;
                    }
                }
            }
        }
    }

} //bodyOnKeyUp


/**
* 
*
* @method switchEdit
* @param {Object} srcElem
*/
function switchEdit(srcElem) {
    if ((srcElem.id == "xsl1Edit" && !(oXslEdit == oXsl1))) {
        oXslEdit = oXsl1;
        oEditAll("ifrdiv").innerHTML = oEditDOM.transformNode(oXslEdit);
    } else if ((srcElem.id == "xsl2Edit" && !(oXslEdit == oXsl2))) {
        oXslEdit = oXsl2;
        oEditAll("ifrdiv").innerHTML = oEditDOM.transformNode(oXslEdit);
    } else if ((srcElem.id == "xsl3Edit" && !(oXslEdit == oXsl3))) {
        oXslEdit = oXsl3;
        oEditAll("ifrdiv").innerHTML = oEditDOM.transformNode(oXslEdit);
    }
} //switchEdit


//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
/**
* 
*
* @method ChooseElement
*/
function ChooseElement() {
    //spn_ElemsMenu click
    var oSrc
    oSrc = window.event.srcElement;
    var nSrcX, nSrcY;
    var nVerGap;
    nVerGap = 4 //oSrc border "thin" (2?) ja parent TD padding (2?);
    nSrcX = tbl_Input.offsetLeft + oSrc.offsetLeft;
    nSrcY = window.event.screenY - window.screenTop - window.event.offsetY + oSrc.offsetHeight + nVerGap;
    ShowElemsMenu(nSrcX, nSrcY);
} //ChooseElement


/**
* 
*
* @method ShowElemsMenu
* @param {Int} nPosX
* @param {Int} nPosY
*/
function ShowElemsMenu(nPosX, nPosY) {
    div_ElemsMenu.style.pixelLeft = nPosX;
    div_ElemsMenu.style.pixelTop = nPosY;
    div_ElemsMenu.style.display = "";
    div_ElemsMenu.style.cursor = "default";
    div_ElemsMenu.setCapture();
} //ShowElemsMenu

/**
* 
*
* @method SwitchElemsMenu
*/
function SwitchElemsMenu() {
    //SwitchElemsMenu on div_ElemsMenu, div_ElemEnumsMenu, div_AttrEnumsMenu, div_ArtHistoryMenu div-idel
    //div_ImportDicts
    //onmouseover-ks ja onmouseout-ks

    var oSrc;
    var tarr;
    var oParticle;
    var sAttrsMenu;
    var oAttr;
    var sAttrURI, sAttrQN, sAttrReq;
    var sXsdXPath, oXsdNode, sKirjeldav;
    var sAttId, sAttClass;

    oSrc = window.event.srcElement;
    //spn_ElemsMenu: span otsitud elemendi infoga; klikates avaneb otsitava elemendi menüü
    //img_AttrEnumsMenu: kohe järgmine; img-ile klikates avaneb atribuudi väärtuste valik
    //img_ElemEnumsMenu: peale atribuudi teksti väärtust; img-ile klikates avaneb elemendi väärtuste valik

    //järgnev if(on vajalik nende stiilide muutmiseks, kui capture on div_ElemsMenu-l
    if ((oSrc.id == "spn_ElemsMenu" || oSrc.id == "img_AttrEnumsMenu" || oSrc.id == "img_ElemEnumsMenu" || oSrc.id == "img_ArtTools" || oSrc.id == "img_SrTools" || oSrc.id == "img_artHistory")) {
        SwitchTD(window.event);
    }

    if (oSrc.tagName == "TD") {
        if (div_ElemsMenu.contains(oSrc)) { // otsitava elemendi peamenüü
            if (window.event.type == "mouseover") { //'"sisse";
                if ((oSrc.parentElement.className == "mi" || oSrc.parentElement.className == "si")) {
                    oSrc.parentElement.className = "hi"

                    //div_ElemsMenu ja div_AttrsMenu <tr>: class = 'mi'; id = 'sFullPath';
                    //value: 'qname|name|URI|IsElement|sKirjeldav';

                    // mySql ühiste korral: "mySqlYhisedMs"
                    sCurrElemId = oSrc.parentElement.id;
                    // mySql ühiste korral: '${sqlSqnastik}|||1|${sqlSqnastikKirjeldav}'
                    tarr = oSrc.parentElement.value.split("|");

                    sAttrsMenu = "";
                    if (tarr[1]) { // 'name'
                        oParticle = oSchRootElems.itemByQName(tarr[1], tarr[2]);
                        if ((oParticle.itemType == SOMITEM_ELEMENT)) {
                            if ((oParticle.type.itemType == SOMITEM_COMPLEXTYPE)) {
                                if ((oParticle.type.attributes.length > 0)) {
                                    sAttId = sCurrElemId + "/@*";
                                    if ((sAttId == sSeldItemId)) {
                                        sAttClass = "si";
                                    } else {
                                        sAttClass = "mi";
                                    }
                                    sAttrsMenu = sAttrsMenu + "<tr class='" + sAttClass + "' " + "id='" + sAttId + "' " + "value='@*|||1|ükskõik milline atribuut' " + "title='ükskõik milline atribuut'>" + "<td colspan='2'>@*</td>" + "</tr>";
                                    var atribuudid = oParticle.type.attributes;
                                    for (i = 0; i < atribuudid.length; i++) {
                                        oAttr = atribuudid[i];
                                        if (!(oAttr.namespaceURI == "")) {
                                            sAttrURI = oAttr.namespaceURI;
                                            sAttrQN = oXmlNsm.getPrefixes(sAttrURI)[0] + ":" + oAttr.name;
                                        } else {
                                            sAttrURI = "";
                                            sAttrQN = oAttr.name;
                                        }
                                        sXsdXPath = ".//" + NS_XS_PR + ":attribute[@name='" + oAttr.name + "']/" + NS_XS_PR + ":annotation/" + NS_XS_PR + ":documentation[@xml:lang='" + sAppLang + "']";
                                        oXsdNode = oXsdDOM.documentElement.selectSingleNode(sXsdXPath);
                                        if (!(oXsdNode == null)) {
                                            sKirjeldav = oXsdNode.text;
                                        } else {
                                            sKirjeldav = sAttrQN;
                                        }
                                        sAttId = oSrc.parentElement.id + "/@" + sAttrQN;
                                        if ((sAttId == sSeldItemId)) {
                                            sAttClass = "si";
                                        } else {
                                            sAttClass = "mi";
                                        }
                                        if ((oAttr.use == SCHEMAUSE_REQUIRED)) {
                                            sAttrReq = " - [obl]";
                                        } else {
                                            sAttrReq = "";
                                        }
                                        sAttrsMenu = sAttrsMenu + "<tr class='" + sAttClass + "' " + "id='" + sAttId + "' " + "value='" + sAttrQN + "|" + oAttr.name + "|" + sAttrURI + "|1|" + sKirjeldav + "'>" + "<td>" + sKirjeldav + "</td>" + "<td>@" + sAttrQN + sAttrReq + "</td>" + "</tr>";
                                    }
                                }
                            }
                        }
                    } else {
                        if (sCurrElemId == "mySqlYhisedMs") {
                            var ridad = document.getElementById("divMySqlYhisedMs").getElementsByTagName("TR");
                            for (var ix = 0; ix < ridad.length; ix++) {
                                if (ridad[ix].id == sSeldItemId) {
                                    ridad[ix].className = "si";
                                } else {
                                    ridad[ix].className = "mi";
                                }
                            }
                            sAttrsMenu = document.getElementById("divMySqlYhisedMs").innerHTML;
                        }
                    }
                    if (sAttrsMenu) {
                        div_AttrsMenu.innerHTML = "<table id='tbl_AttrsMenu' width='100%' border='0' cellSpacing='0'>" + sAttrsMenu + "</table>";
                        div_AttrsMenu.style.pixelLeft = div_ElemsMenu.style.pixelLeft + div_ElemsMenu.offsetWidth;
                        div_AttrsMenu.style.pixelTop = div_ElemsMenu.style.pixelTop + oSrc.offsetTop - div_ElemsMenu.scrollTop;
                        div_AttrsMenu.style.display = "";
                    } else {
                        div_AttrsMenu.style.display = "none";
                        div_AttrsMenu.innerHTML = "";
                    }
                }
            } else if ((window.event.type == "mouseout")) { //'"välja";
                if (oSrc.parentElement.className == "hi") {
                    if (sSeldAttrValue == "") {
                        if (oSrc.parentElement.id == sSeldItemId) {
                            oSrc.parentElement.className = "si";
                        } else {
                            oSrc.parentElement.className = "mi";
                        }
                    } else {
                        if (oSrc.parentElement.id == sSeldItemId.substr(0, sSeldItemId.lastIndexOf("/"))) {
                            oSrc.parentElement.className = "si";
                        } else {
                            oSrc.parentElement.className = "mi";
                        }
                    }
                }
            }
        } else { // otsitava elemendi peamenüü atribuutide kõrvalmenüü
            if (oSrc.parentElement.className == "mi") {
                oSrc.parentElement.className = "hi";
            } else if (oSrc.parentElement.className == "hi") {
                oSrc.parentElement.className = "mi";
//            } else if (oSrc.parentElement.className == "si") {
//                oSrc.parentElement.className = "mi";
            }
        }
    }
} //SwitchElemsMenu


/**
* 
*
* @method ClickElemsMenu
*/
function ClickElemsMenu() {
    var oSrc, sCFP
    oSrc = window.event.srcElement;
    sCFP = div_ElemsMenu.componentFromPoint(window.event.clientX, window.event.clientY);
    if (sCFP.substr(0, 6) == "scroll") {
        div_ElemsMenu.doScroll(sCFP);
    } else if (div_ElemsMenu.contains(oSrc) || div_AttrsMenu.contains(oSrc)) {
        if (div_AttrsMenu.contains(oSrc)) {
            SetSelectedInfo(oSrc.parentElement.id, oSrc.parentElement.value);
        } else {
            SetSelectedInfo(oSrc.parentElement.id, "");
        }
        document.releaseCapture();
    } else {
        document.releaseCapture();
    }
} //ClickElemsMenu


/**
* 
*
* @method ShowElemEnums
*/
function ShowElemEnums() {
    if (!(div_ElemEnumsMenu.innerHTML == "")) {
        var oSrc, nX, nY, nVerGap;
        oSrc = window.event.srcElement;
        nVerGap = 4 //oSrc border "thin" (2?) ja parent TD padding (2?);
        nX = window.event.clientX + 2 * oSrc.offsetWidth;
        nY = window.event.screenY - window.screenTop - window.event.offsetY - oSrc.offsetTop - nVerGap;
        div_ElemEnumsMenu.style.pixelLeft = nX;
        div_ElemEnumsMenu.style.pixelTop = nY;
        div_ElemEnumsMenu.style.display = "";
        div_ElemEnumsMenu.style.cursor = "default";
        div_ElemEnumsMenu.setCapture();
    }
} //ShowElemEnums


/**
* 
*
* @method ClickElemEnums
*/
function ClickElemEnums() {
    var sCFP;
    sCFP = div_ElemEnumsMenu.componentFromPoint(window.event.clientX, window.event.clientY);
    if ((jsLeft(sCFP, 6) == "scroll")) {
        div_ElemEnumsMenu.doScroll(sCFP);
    } else if ((sCFP == "")) {
        inp_ElemText.value = window.event.srcElement.parentElement.value;
        document.releaseCapture();
    } else if ((sCFP == "outside")) {
        document.releaseCapture();
    }
} //ClickElemEnums


/**
* 
*
* @method ShowAttribEnums
*/
function ShowAttribEnums() {
    if (!(div_AttrEnumsMenu.innerHTML == "")) {
        var oSrc, nX, nY, nVerGap;
        oSrc = window.event.srcElement;
        nVerGap = 4 //oSrc border "thin" (2?) ja parent TD padding (2?);
        nX = window.event.clientX + 2 * oSrc.offsetWidth;
        nY = window.event.screenY - window.screenTop - window.event.offsetY - oSrc.offsetTop - nVerGap;
        div_AttrEnumsMenu.style.pixelLeft = nX;
        div_AttrEnumsMenu.style.pixelTop = nY;
        div_AttrEnumsMenu.style.display = "";
        div_AttrEnumsMenu.style.cursor = "default";
        div_AttrEnumsMenu.setCapture();
    }
} //ShowAttribEnums


/**
* 
*
* @method ClickAttribEnums
*/
function ClickAttribEnums() {
    var sCFP;
    sCFP = div_AttrEnumsMenu.componentFromPoint(window.event.clientX, window.event.clientY);
    if ((jsLeft(sCFP, 6) == "scroll")) {
        div_AttrEnumsMenu.doScroll(sCFP);
    } else if ((sCFP == "")) {
        inp_AttrText.value = window.event.srcElement.parentElement.value;
        document.releaseCapture();
    } else if ((sCFP == "outside")) {
        document.releaseCapture();
    }
} //ClickAttribEnums


/**
* 
*
* @method validateSR
*/
function validateSR() {
    if ((oEditDOMRoot.hasChildNodes())) {
        if ((ValidateXML(oEditDOM, oXsdSc))) {
            alert("Artikli kontroll\n\nArtikkel '" + sMSortVal + "' on korras!");
        }
    }
} //validateSR


/**
* 
*
* @method SetIfrViewLeftAlign
*/
function SetIfrViewLeftAlign() {
    ifrviewdiv.style.textAlign = "left"
} //SetIfrViewLeftAlign

/**
* 
*
* @method SetIfrViewCenterAlign
*/
function SetIfrViewCenterAlign() {
    ifrviewdiv.style.textAlign = "center"
} //SetIfrViewCenterAlign

/**
* 
*
* @method SetIfrViewRightAlign
*/
function SetIfrViewRightAlign() {
    ifrviewdiv.style.textAlign = "right"
} //SetIfrViewRightAlign

/**
* 
*
* @method SetIfrViewLeftAlign
*/
function SetIfrViewLeftAlign() {
    ifrviewdiv.style.textAlign = "justify"
} //SetIfrViewJustifyAlign


/**
* 
*
* @method showArtXML
*/
function showArtXML() {
    if ((window.event.ctrlLeft)) {
        var artXMLStr;
        artXMLStr = jsReplace(oEditDOM.xml, '\r\n', "¶" + '\r\n');
        artXMLStr = jsReplace(artXMLStr, '\t', "->" + '\t');
        alert("XML:\n\n" + artXMLStr);
    }
} //showArtXML


/**
* 
*
* @method spnMsgDelete
*/
function spnMsgDelete() {
    spn_msg.innerHTML = '';
} //spnMsgDelete


/**
* 
*
* @method updMuudatused
* @param {String} op
* @param {String} tekst
*/
function updMuudatused(op, tekst) {
    var n2idatav = tekst;
    if (n2idatav.length > 30) {
        n2idatav = n2idatav.substr(0, 30) + " {...}";
    }
    var muudetav;
    if (op == "S" || op == "K") { //'U ja R korral ei pruugi 'selectedNode'-i olla
        if (selectedNode) {
            muudetav = selectedNode.nodeName;
            if (clType == "at") {
                muudetav = "@" + muudetav;
            }
            muudetav = fatherNode.nodeName + "/" + muudetav;
        } else {
            muudetav = "Op.:";
        }
    }
    if (op == "S") {
        artMuudatused = artMuudatused + "|" + muudetav + " = '" + n2idatav + "'";
    } else if (op == "K") {
        //siin on miinusmärk, mitte sidekriips, ära uisa-päisa kustuta! :);
        artMuudatused = artMuudatused + "|" + muudetav + "['" + n2idatav + "'] − ";
    } else if (op == "U" || op == "R") {
        artMuudatused = artMuudatused + "|" + n2idatav;
    }
} //updMuudatused



/**
* 
*
* @method UndoArticle
*/
function UndoArticle() {
    if ((urindex > 0)) {
        urindex = urindex - 1;
        oEditDOMRoot.replaceChild(urfragment.childNodes(urindex).cloneNode(true), oEditDOMRoot.firstChild);
        oEditAll("ifrdiv").innerHTML = oEditDOM.transformNode(oXslEdit);
        updMuudatused("U", "U");
        if ((oViewAll("_copyDiv") == null)) {
            if ((dic_desc == "evs")) {
                var domCopy;
                domCopy = oEditDOM.cloneNode(true);
                TeisendaDOM(domCopy);
                oViewAll("ifrviewdiv").innerHTML = domCopy.transformNode(oXslView);
            } else {
                oViewAll("ifrviewdiv").innerHTML = oEditDOM.transformNode(oXslView);
            }
        }
    }
} //UndoArticle


/**
* 
*
* @method RedoArticle
*/
function RedoArticle() {
    if ((urindex < urlast)) {
        urindex = urindex + 1;
        oEditDOMRoot.replaceChild(urfragment.childNodes(urindex).cloneNode(true), oEditDOMRoot.firstChild);
        oEditAll("ifrdiv").innerHTML = oEditDOM.transformNode(oXslEdit);
        updMuudatused("R", "R");
        if ((oViewAll("_copyDiv") == null)) {
            if ((dic_desc == "evs")) {
                var domCopy;
                domCopy = oEditDOM.cloneNode(true);
                TeisendaDOM(domCopy);
                oViewAll("ifrviewdiv").innerHTML = domCopy.transformNode(oXslView);
            } else {
                oViewAll("ifrviewdiv").innerHTML = oEditDOM.transformNode(oXslView);
            }
        }
    }
} //RedoArticle



/**
* 
*
* @method volSelected
*/
function volSelected() {
    if ((inp_AttrText.disabled == false)) {
        inp_AttrText.setActive();
        inp_AttrText.focus();
        inp_AttrText.select();
    } else {
        inp_ElemText.setActive();
        inp_ElemText.focus();
        inp_ElemText.select();
    }
} //volSelected


var largePicId;

/**
* 
*
* @method showLargePicture
*/
function showLargePicture() {
    var oSrc
    oSrc = frame_Images.event.srcElement;
    if ((oSrc.tagName != "IMG")) {
        return;
    }

    largePicId = oSrc.parentElement.id

    window.open("html/show_pic_large.htm", "_blank", "channelmode=yes,directories=no,fullscreen=no,location=no,menubar=no,resizable=no,scrollbars=no,status=no,titlebar=no,toolbar=no")

} //showLargePicture



/**
* 
*
* @method fiOnClick
*/
function fiOnClick() {

    var oSrc
    oSrc = frame_Images.event.srcElement;
    if ((oSrc.tagName != "SPAN")) {
        return;
    }

    var currId;
    currId = oSrc.parentElement.id

    var pltElem, pfElem, sParms, newFile, smdArgs

    if ((oSrc.id == "chPic")) {
        //valitud ID, 'od_: '011';
        smdArgs = currId + JR + dic_desc + JR + sAppLang + JR + 'blahh' + JR + sUsrName;
        sParms = window.showModalDialog("html/setimage.htm", smdArgs, "dialogHeight:576px;dialogWidth:1024px;center:yes;edge:sunken;help:no;resizable:yes;scroll:yes;status:yes;unadorned:no");
        if (sParms == null) {
            return;
        }

        if ((sParms != currId)) {
            newFile = sParms + "_med.jpg";
            pfElem = oEditDOMRoot.selectSingleNode(DICPR + ":A/" + DICPR + ":P/" + DICPR + ":plt/" + DICPR + ":pf[. = '" + currId + "_med.jpg']");
            pfElem.text = newFile;
            fillImgFrame();
            oEditAll("ifrdiv").setAttribute("xmlChanged", 1); //'2: teha edit ala uuendus (transformNode), 1: mitte;
        }
    } else if ((oSrc.id == "rmvPic")) {
        pltElem = oEditDOMRoot.selectSingleNode(DICPR + ":A/" + DICPR + ":P/" + DICPR + ":plt[" + DICPR + ":pf ='" + currId + "_med.jpg']");
        pltElem.parentNode.removeChild(pltElem);
        fillImgFrame();
        oEditAll("ifrdiv").setAttribute("xmlChanged", 1); //'2: teha edit ala uuendus (transformNode), 1: mitte;
    } else if ((oSrc.id == "addPic")) {
        //valitud ID;
        //currId on praegu "", <p> on span sisaldaja;
        smdArgs = currId + JR + dic_desc + JR + sAppLang + JR + 'blahh' + JR + sUsrName;
        sParms = window.showModalDialog("html/setimage.htm", smdArgs, "dialogHeight:576px;dialogWidth:1024px;center:yes;edge:sunken;help:no;resizable:yes;scroll:yes;status:yes;unadorned:no");
        if (sParms == null) {
            return;
        }

        if ((sParms != currId)) {
            newFile = sParms + "_med.jpg";
            var pxis;
            pxis = oEditDOMRoot.selectSingleNode(DICPR + ":A/" + DICPR + ":P");
            pltElem = pxis.appendChild(GetAddElement(DICPR + ":plt", DICURI));
            pfElem = pltElem.selectSingleNode(DICPR + ":pf");
            pfElem.text = newFile;
            fillImgFrame();
            oEditAll("ifrdiv").setAttribute("xmlChanged", 1); //'2: teha edit ala uuendus (transformNode), 1: mitte;
        }
    }

} //fiOnClick


/**
* 
*
* @method showSrToolsMenu
*/
function showSrToolsMenu() {
    if (!(div_SrToolsMenu.innerHTML == "")) {
        var oSrc, nX, nY, nVerGap;
        oSrc = window.event.srcElement;
        nVerGap = 4;  //oSrc border "thin" (2?) ja parent TD padding (2?);
        nX = window.event.clientX + 2 * oSrc.offsetWidth;
        nY = window.event.screenY - window.screenTop - window.event.offsetY - oSrc.offsetTop - nVerGap;
        div_SrToolsMenu.style.pixelLeft = nX;
        div_SrToolsMenu.style.pixelTop = nY;
        div_SrToolsMenu.style.display = "";
        div_SrToolsMenu.style.cursor = "default";
        div_SrToolsMenu.setCapture();
    }
} //showSrToolsMenu


/**
* 
*
* @method ClickSrToolsMenu
*/
function ClickSrToolsMenu() {
    var sCFP;
    var tarr;
    var retVal;
    var smdArgs;
    retVal = "";
    sCFP = div_SrToolsMenu.componentFromPoint(window.event.clientX, window.event.clientY);
    if ((jsLeft(sCFP, 6) == "scroll")) {
        div_SrToolsMenu.doScroll(sCFP);
    } else if ((sCFP == "")) {
        //tr value
        var parConfFile, parConfField, parText;
        if (window.event.srcElement.parentElement.value == "idArtImport") {
            var sParms, impDicDesc, pathBase;
            if (oEditDOMRoot.hasChildNodes()) {
                smdArgs = "Eesti-Vene sõnaraamat,evs;Eesti-X sõnastikupõhi,ex_;ÕS 2006,qs_" + JR + "imporditav sõnastik";
                sParms = window.showModalDialog("html/mychoice.htm", smdArgs, "dialogHeight:300px;dialogWidth:375px;center:yes;edge:sunken;help:no;resizable:yes;scroll:yes;status:no;unadorned:no");
                if (sParms != null) {
                    tarr = sParms.split(JR);
                    impDicDesc = tarr[0];
                    pathBase = tarr[1];
                    smdArgs = impDicDesc + JR + sAppLang + JR + 'blahh' + JR + sUsrName + JR + pathBase;
                    sParms = window.showModalDialog("html/gethwds.htm", smdArgs, "dialogHeight:608px;dialogWidth:1024px;center:yes;edge:sunken;help:no;resizable:yes;scroll:yes;status:yes;unadorned:no");
                    if (sParms != null) {
                        //impVolNr, impMs, g, pathBase;
                        tarr = sParms.split(JR);

                        sCmdId = "ImportRead";
                        sQryInfo = tarr[1];

                        var sPrmDomXml, oPrmDom;
                        sPrmDomXml = "<prm>" + "<cmd>" + sCmdId + "</cmd>" + "<vol>" + impDicDesc + tarr[0] + "</vol>" + "<nfo>" + sQryInfo + "</nfo>" + "<axp>" + pathBase + "</axp>" + "<G>" + tarr[2] + "</G>" + "</prm>";

                        oPrmDom = IDD("String", sPrmDomXml, false, false, null);
                        if ((oPrmDom.parseError.errorCode != 0)) {
                            ShowXMLParseError(oPrmDom);
                            return;
                        }
                        StartOperation(oPrmDom);
                    }
                }
            }
        } else if ((window.event.srcElement.parentElement.value == "idOxfordDudenSisukord")) {
            showOxfordDudenSisukord();
        } else if ((window.event.srcElement.parentElement.value == "idOxfordDudenIndeksEng")) {
            showOxfordDudenIndeksEng();
        } else if ((window.event.srcElement.parentElement.value == "idOxfordDudenIndeksEst")) {
            showOxfordDudenIndeksEst();
        } else if ((window.event.srcElement.parentElement.value == "idEELexSetup")) {
            showEELexSetup();
        } else if ((window.event.srcElement.parentElement.value == "idBulkUpdate")) {
            var hulgiNimi;
            if (dic_desc == "sp_") {
                //                hulgiNimi = "openFindReplace"; //'openFindReplace;
                hulgiNimi = "hulgiParandused";
            } else {
                hulgiNimi = "hulgiParandused";
            }
            window.open("html/" + hulgiNimi + ".htm", "_blank", "width=1024,height=700,channelmode=no,directories=no,fullscreen=no,location=no,menubar=no,resizable=yes,scrollbars=yes,status=yes,titlebar=yes,toolbar=no");
        } else if ((window.event.srcElement.parentElement.value == "idViewLogs")) {
            showDicLogs();
        } else if ((window.event.srcElement.parentElement.value == "idVaateGen")) {
            ShowAdminView();
        } else if ((window.event.srcElement.parentElement.value == "idSkeemiGen")) {
            ShowSkeemiGen();
        } else if ((window.event.srcElement.parentElement.value == "idSrvXmlValidate")) {
            srvXmlValidate();
        } else if ((window.event.srcElement.parentElement.value == "idGetXMLCopy")) {
            smdArgs = dic_desc + JR + sAppLang + JR + '' + JR + sUsrName + JR + sel_Vol.options(sel_Vol.selectedIndex).id;
            window.showModalDialog("html/xmlCopy.htm", smdArgs, "dialogHeight:152px;dialogWidth:384px;center:yes;edge:sunken;help:no;resizable:yes;scroll:yes;status:yes;unadorned:no");
        } else if ((window.event.srcElement.parentElement.value == "idGetXMLImport")) {
            smdArgs = dic_desc + JR + sAppLang + JR + '' + JR + sUsrName + JR + sel_Vol.options(sel_Vol.selectedIndex).id;
            window.showModalDialog("html/xmlImport.htm", smdArgs, "dialogHeight:152px;dialogWidth:384px;center:yes;edge:sunken;help:no;resizable:yes;scroll:yes;status:yes;unadorned:no");
        } else if ((window.event.srcElement.parentElement.value == "idMsSarnased")) {
            showMsSarnased();
        } else if ((window.event.srcElement.parentElement.value == "idTyhjadViited")) {
            showTyhjadViited();
        } else if (window.event.srcElement.parentElement.value == "morfonolHulgi") {
        } else if ((window.event.srcElement.parentElement.value == "idExsaManPtd")) {
            parConfFile = window.event.srcElement.parentElement.getAttribute("confFile");
            parConfField = window.event.srcElement.parentElement.id;
            parText = window.event.srcElement.innerText;
            //parameetrid: sõn. kood [0]; kasutaja [1]; töökeel [2]; op. nimetus [3]; faili nimi [4]; välja nimi [5];
            smdArgs = dic_desc + JR + sUsrName + JR + sAppLang + JR + parText + JR + parConfFile + JR + parConfField;
            retVal = window.showModalDialog("html/getList.htm", smdArgs, "dialogHeight:608px;dialogWidth:1024px;center:yes;edge:sunken;help:no;resizable:yes;scroll:yes;status:yes;unadorned:no");
            if (retVal == "updated") {
                document.execCommand("Refresh", false);
            } //if((retVal == "updated")){
        } else if ((window.event.srcElement.parentElement.value == "idExsaManUsr")) {
            parConfFile = window.event.srcElement.parentElement.getAttribute("confFile");
            parConfField = window.event.srcElement.parentElement.id;
            parText = window.event.srcElement.innerText;
            //parameetrid: sõn. kood [0]; kasutaja [1]; töökeel [2]; op. nimetus [3]; faili nimi [4]; välja nimi [5];
            smdArgs = dic_desc + JR + sUsrName + JR + sAppLang + JR + parText + JR + parConfFile + JR + parConfField;
            retVal = window.showModalDialog("html/getList.htm", smdArgs, "dialogHeight:608px;dialogWidth:1024px;center:yes;edge:sunken;help:no;resizable:yes;scroll:yes;status:yes;unadorned:no");
            if (retVal == "updated") {
                document.execCommand("Refresh", false);
            } //if((retVal == "updated")){
        } else if ((window.event.srcElement.parentElement.value == "idExsaRemoveDict")) {
            kustutaSqnastik();
        } else if ((jsLeft(window.event.srcElement.parentElement.value, 5) == "delim")) {
            return;
        } else if ((jsRight(window.event.srcElement.parentElement.id, 5) == "_tyyp")) {

            //par: 0 ... 4-xsd faili nimi, 5-tüübi nimi, 6-kasutaja

            //        sSrToolsMenu = sSrToolsMenu +  //            "<tr class='mi' id='k_tyyp' value='xsd/ety/ety_tyybid.xsd'>" +  //                 "<td>Keel</td>" +  //            "</tr>"

            smdArgs = dic_desc + JR + sAppLang + JR + 'blahh' + JR + window.event.srcElement.innerText + JR + window.event.srcElement.parentElement.value + JR + window.event.srcElement.parentElement.id + JR + sUsrName;
            retVal = window.showModalDialog("html/getsimpletype.htm", smdArgs, "dialogHeight:608px;dialogWidth:1024px;center:yes;edge:sunken;help:no;resizable:yes;scroll:yes;status:yes;unadorned:no");
            if (retVal == "updated") {

                var sXSDFile = "xsd/schema_" + dic_desc + ".xsd";
                oXsdDOM = IDD("File", sXSDFile, false, false, null);
                oXsdDOM.setProperty("SelectionLanguage", "XPath");
                oXsdDOM.setProperty("SelectionNamespaces", jsTrim(sXsdNsList));

                oXsdSc = new ActiveXObject("Msxml2.XMLSchemaCache.6.0");
                oXsdSc.validateOnLoad = true;
                oXsdSc.add(DICURI, sXSDFile);

                oEditDOM = IDD("String", oEditDOM.xml, false, false, oXsdSc);
                oEditDOM.setProperty("SelectionLanguage", "XPath");
                oEditDOM.setProperty("SelectionNamespaces", sXmlNsList);
                oEditDOMRoot = oEditDOM.documentElement;

                oXmlSc = oEditDOM.namespaces;

                oSchRootElems = oXmlSc.getSchema(DICURI).elements;
                oSchRootAttrs = oXmlSc.getSchema(DICURI).attributes;

                if (window.event.srcElement.parentElement.id == 'xmllang_tyyp') {
                    var locnKeys = (new VBArray(impSchemaLocations.Keys())).toArray();
                    for (var itm in locnKeys) {
                        if ((jsLeft(impSchemaLocations.Item(locnKeys[itm]), 4) == dic_desc + "/")) { //'asub tüüpide DOM-is;
                            updKeelteValik(impSchemaLocations.Item(locnKeys[itm]));
                        }
                    }
                }

                if ((img_ElemEnumsMenu.disabled == false)) {
                    updElemEnumsMenu();
                }
                if ((img_AttrEnumsMenu.disabled == false)) {
                    updAttrEnumsMenu();
                }

            } //if((retVal == "updated")){
        }

        document.releaseCapture();

    } else if ((sCFP == "outside")) {
        document.releaseCapture();
    }
} //ClickSrToolsMenu


/**
* 
*
* @method kustutaSqnastik
*/
function kustutaSqnastik() {

    var xh, creator;
    var oRespDom, sta
    xh = exCGISync("tools.cgi", "exsaGetField" + JR + dic_desc + JR + sUsrName + JR + "" + JR + "items/item[@code = '" + dic_desc + "']/creator");
    if ((xh.statusText == "OK")) {
        oRespDom = xh.responseXML //responseXML: TypeName = DomDocument;
        sta = oRespDom.selectSingleNode("rsp/sta").text;
        if ((sta == "Success")) {
            creator = oRespDom.selectSingleNode("rsp/answer").text;
        } else {
            alert("Väärtuste leidmine ei õnnestunud!", jsvbCritical, document.title);
            return;
        }
    } else {
        alert(xh.status + ": " + xh.statusText + '\r\n\r\n' + xh.responseText, jsvbCritical);
        return;
    }

    if ((creator != sUsrName)) {
        alert("Sõnastikku saab kustutada ainult selle loonud kasutaja!", vbExclamation, "Sõnastiku kustutamine");
        return;
    }

    var nRetBtn;
    nRetBtn = confirm("Kas soovid kustutada terve sõnastiku" + '\r\n' + "'" + sDicName + "'?");
    if ((nRetBtn != 6)) {
        return;
    }

    xh = exCGISync("tools.cgi", "exsaKustutaSqnastik" + JR + dic_desc + JR + sUsrName);
    if ((xh.statusText == "OK")) {
        oRespDom = xh.responseXML //responseXML: TypeName = DomDocument;
        sta = oRespDom.selectSingleNode("rsp/sta").text;
        if ((sta == "Success")) {
            alert("Sõnastik '" + sDicName + "' kustutatud.", vbInformation, "Sõnastiku kustutamine");
            window.navigate("http://exsa.eki.ee/");
        } else {
            alert("Sõnastiku kustutamine ei õnnestunud!", jsvbCritical, document.title);
            return;
        }
    } else {
        alert(xh.status + ": " + xh.statusText + '\r\n\r\n' + xh.responseText, jsvbCritical);
        return;
    }

} //kustutaSqnastik


/**
* 
*
* @method showArtToolsMenu
*/
function showArtToolsMenu() {
    //div_ArtToolsMenu - art_le.cgi-s defineeritud,
    if (!(div_ArtToolsMenu.innerHTML == "")) {
        var oSrc, nX, nY, nVerGap;
        oSrc = window.event.srcElement;
        nVerGap = 4 //oSrc border "thin" (2?) ja parent TD padding (2?);
        nX = window.event.clientX + 2 * oSrc.offsetWidth;
        nY = window.event.screenY - window.screenTop - window.event.offsetY - oSrc.offsetTop - nVerGap;
        div_ArtToolsMenu.style.pixelLeft = nX;
        div_ArtToolsMenu.style.pixelTop = nY;
        div_ArtToolsMenu.style.display = "";
        div_ArtToolsMenu.style.cursor = "default";
        div_ArtToolsMenu.setCapture();
    }
} //showArtToolsMenu


/**
* 
*
* @method ClickArtToolsMenu
*/
function ClickArtToolsMenu() {
    var sCFP;
    sCFP = div_ArtToolsMenu.componentFromPoint(window.event.clientX, window.event.clientY);
    if ((jsLeft(sCFP, 6) == "scroll")) {
        div_ArtToolsMenu.doScroll(sCFP);
    } else if ((sCFP == "")) {
        //tr value
        if ((window.event.srcElement.parentElement.value == "idSignEntry")) { //'peatoimetaja märge;
            signEntry();
        } else if ((window.event.srcElement.parentElement.value == "idRemSignEntry")) { //'eemalda 'peatoimetaja märge;
            remSignEntry();
        } else if ((window.event.srcElement.parentElement.value == "idKoostamiseLopp")) { //'koostamise lõpp;
            koostamiseLopp();
        } else if ((window.event.srcElement.parentElement.value == "idRemKoostamiseLopp")) { //'eemalda 'koostamise lõpp;
            remKoostamiseLopp();
        } else if ((window.event.srcElement.parentElement.value == "idAddEmptyEquiv")) { //'Oxford-Duden: lisa tühjad vasted;
            addEmptyEquiv();
        } else if ((window.event.srcElement.parentElement.value == "idImportFromWord")) { //'Oxford-Duden: import Word-ist;
            importFromWord();
        } else if ((window.event.srcElement.parentElement.value == "idCompleteEntry")) { //'toimetamise lõpp;
            completeEntry();
        } else if ((window.event.srcElement.parentElement.value == "idRemCompleteEntry")) { //'eemalda 'toimetamise lõpp;
            remCompleteEntry();
        } else if ((window.event.srcElement.parentElement.value == "idCompleteEntryLatvian")) { //'toimetamise lõpp;
            completeEntryLatvian();
        } else if ((window.event.srcElement.parentElement.value == "idRemCompleteEntryLatvian")) { //'eemalda 'toimetamise lõpp;
            remCompleteEntryLatvian();
        } else if ((window.event.srcElement.parentElement.value == "idCompleteEntryEstonian")) { //'toimetamise lõpp;
            completeEntryEstonian();
        } else if ((window.event.srcElement.parentElement.value == "idRemCompleteEntryEstonian")) { //'eemalda 'toimetamise lõpp;
            remCompleteEntryEstonian();
        } else if ((window.event.srcElement.parentElement.value == "idDictionaryEntry")) { //'Haridus;
            artikliStaatus("HS");
        } else if ((window.event.srcElement.parentElement.value == "idDatabaseEntry")) { //'Haridus;
            artikliStaatus("AB");
        } else if ((window.event.srcElement.parentElement.value == "idDictionaryEntryUkr")) {
            artikliStaatus("UKR");
        } else if ((window.event.srcElement.parentElement.value == "idDatabaseEntryUkr")) {
            artikliStaatus("AB");
            //--------------------------------------------------------------------------------
        } else if ((window.event.srcElement.parentElement.value == "idDictionaryEntryVsl")) {
            artikliStaatus("VL");
        } else if ((window.event.srcElement.parentElement.value == "idDatabaseEntryVsl")) {
            artikliStaatus("AB");
            //--------------------------------------------------------------------------------
        } else if ((window.event.srcElement.parentElement.value == "idDictionaryEntryFin")) {
            artikliStaatus("FIN");
        } else if ((window.event.srcElement.parentElement.value == "idDatabaseEntryFin")) {
            artikliStaatus("AB");
            //--------------------------------------------------------------------------------
        } else if ((window.event.srcElement.parentElement.value == "idDictionaryEntrySS1")) {
            artikliStaatus("SS1");
        } else if ((window.event.srcElement.parentElement.value == "idDatabaseEntrySS1")) {
            artikliStaatus("AB");
            //--------------------------------------------------------------------------------
        } else if ((window.event.srcElement.parentElement.value == "idDictionaryEntryKNR")) {
            artikliStaatus("EKNR");
        } else if ((window.event.srcElement.parentElement.value == "idDatabaseEntryKNR")) {
            artikliStaatus("AB");
            //--------------------------------------------------------------------------------
        } else if ((window.event.srcElement.parentElement.value == "idDictionaryEntryPSV")) {
            artikliStaatus("PSV");
        } else if ((window.event.srcElement.parentElement.value == "idDatabaseEntryPSV")) {
            artikliStaatus("AB");
            //--------------------------------------------------------------------------------
        } else if ((window.event.srcElement.parentElement.value == "idDictionaryEntryMAR")) {
            artikliStaatus("MAR");
        } else if ((window.event.srcElement.parentElement.value == "idDatabaseEntryMAR")) {
            artikliStaatus("AB");
            //--------------------------------------------------------------------------------
        } else if ((window.event.srcElement.parentElement.value == "idDictionaryEntryEX")) {
            ABartikkelYesNo();
            //--------------------------------------------------------------------------------
        } else if ((window.event.srcElement.parentElement.value == "idMainEntry")) { //'EKSS;
            assignMainEntry();
        } else if ((window.event.srcElement.parentElement.value == "idSubEntry")) { //'EKSS;
            assignSubEntry();
        } else if (window.event.srcElement.parentElement.value == "idMoveToVolume") { //'PSV "vii AB köitesse";
            moveToVolume();
        }

        document.releaseCapture();
    } else if ((sCFP == "outside")) {
        document.releaseCapture();
    }
} //ClickArtToolsMenu



/**
* 
*
* @method moveToVolume
*/
function moveToVolume() {

    var sLinkVols = '';
    var volId = '';
    for (var ix = 0; ix < sel_Vol.options.length; ix++) {
        var opt = sel_Vol.options[ix];
        if (opt.id == sAllVolId) {
            break;
        }
        sLinkVols = sLinkVols + "<option id='" + opt.id + "'";
        if (opt.selected) {
            sLinkVols = sLinkVols + " selected";
            volId = opt.id;
        }
        sLinkVols = sLinkVols + ">" + opt.innerText + "</option>";
    }

    var smdArgs = new Array(dic_desc, sUsrName, sAppLang, sLinkVols);
    var retVal = window.showModalDialog("html/moveToVolume.htm", smdArgs, "dialogHeight:128px;dialogWidth:384px;center:yes;edge:sunken;help:no;resizable:yes;scroll:yes;status:no;unadorned:no");

    if (!retVal) {
        return;
    }
    if (volId == retVal) {
        return;
    }

    var vnr = retVal.substr(3, 1);
    var oConfigDOM = IDD("File", "shsconfig_" + dic_desc + ".xml", false, false, null);
    var vahemik = oConfigDOM.documentElement.selectSingleNode("vols/vol[@nr = '" + vnr + "']").text;
    // PSV teine köide 'AB' artiklid: <vol nr="2">AB: A - Y</vol>
    if (vahemik.indexOf(" - ") > -1) {
        vahemik = jsTrim(vahemik.substr(vahemik.indexOf(":") + 1));
        otsad = vahemik.split(" - ");
        var v6rreldav = sMSortVal;
        var puhas = RemoveSymbols(v6rreldav, ""); //'2. parm VÕIB OLLA;
        if (!((jsStrComp(jsLeft(puhas, otsad[0].length), otsad[0], 1) >= 0) && (jsStrComp(jsLeft(puhas, otsad[1].length), otsad[1], 1) <= 0))) {
            alert(CHK_VOL_ERR, jsvbCritical, CHK_VOL);
            return;
        }
    }

    sCmdId = "ClientDelete";
    sQryInfo = sMSortVal;

    var destVol = retVal;
    var sqlVol = sFromVolume;

    var artGuid = oEditDOMRoot.selectSingleNode(DICPR + ":A/" + qn_guid).text;
    var qM = "MySql";
    var seldQn = qn_ms;  //pärast otsitakse nn homonüümseid märksõnu, st millised veel sama märksõnaga on;
    var srchPtrn = "^" + sMSortVal + "$";
    var homonyymsed = '';
    var art_xpath = '', elm_xpath = '', sql = '', sPrmDomXml, oPrmDom;
    sPrmDomXml = "<prm>" +
                        "<cmd>" + sCmdId + "</cmd>" +
                        "<vol>" + sFromVolume + "</vol>" +
                        "<nfo>" + sQryInfo + "</nfo>" +
                        "<axp>" + art_xpath + "</axp>" +
                        "<exp>" + elm_xpath + "</exp>" +
                        "<wC>0</wC>" +
                        "<wS>1</wS>" +
                        "<fSrP>" + srchPtrn + "</fSrP>" +
                        "<G>" + artGuid + "</G>" +
                        "<sql>" + sql + "</sql>" +
                        "<dV>" + destVol + "</dV>" +
                        "<qn>" + seldQn + "</qn>" +
                        "<qM>" + qM + "</qM>" +
                    "</prm>";

    oPrmDom = IDD("String", sPrmDomXml, false, false, null);
    if (oPrmDom.parseError.errorCode != 0) {
        ShowXMLParseError(oPrmDom);
        return;
    }

    StartOperation(oPrmDom);

} //moveToVolume


/**
* 
*
* @method HandleViewSelectionChange
*/
function HandleViewSelectionChange() {
    if (!(oViewAll("_copyDiv") == null)) {
        var rng;
        rng = document.selection.createRange();
        sTextToCopy = rng.text;
    }
} //HandleViewSelectionChange


/**
* 
*
* @method checkRpmUpdates
* @returns {Boolean} 
*/
function checkRpmUpdates() {
    var checkRpmUpdates = true;
    if ((useMorfo)) {
        var updateRpmWeb, rpmWebVersion, curMorfVer;  //rpm - reeglipõhine morfoloogia;
        var oConfigDOM, cfgElem;
        oConfigDOM = IDD("File", "shsConfig.xml", false, false, null);
        //"4.1.8" oli 24. aprill 2009;
        //"4.1.9" oli 10. oktoober 2010;
        cfgElem = oConfigDOM.documentElement.selectSingleNode("rpmWebVersion");
        if (!(cfgElem == null)) {
            rpmWebVersion = cfgElem.text;
        } else {
            rpmWebVersion = "";
            return false; // kas jätkata?
        }
        try {
           // updateRpmWeb = eelexSWCtl.needsRpmUpdate(rpmWebVersion);
           // curMorfVer = eelexSWCtl.propMorfVer;
            if ((updateRpmWeb)) {
                var infoStr, smdArgs;
                infoStr = "Lokaalse morfoloogia versioon on '" + curMorfVer + "',<br />serveris on olemas uuem versioon: '" + rpmWebVersion + "'.";
                smdArgs = "../install/rpmWebMSI.msi" + JR + infoStr;
                window.showModalDialog("html/myinstall.htm", smdArgs, "dialogHeight:300px;dialogWidth:375px;center:yes;edge:sunken;help:no;resizable:yes;scroll:yes;status:no;unadorned:no");
                checkRpmUpdates = false //kas jätkata?;
            }
        }
        catch (e) {
            checkRpmUpdates = false //kas jätkata?;
        }
    }
    return checkRpmUpdates;
} //checkRpmUpdates


/**
* 
*
* @method showEELexSetup
*/
function showEELexSetup() {
    if (!checkRpmUpdates()) {
        return;
    }
    var retVal, smdArgs;
    smdArgs = dic_desc + JR + sAppLang + JR + 'trääs' + JR + sUsrName + JR + 'trääs';
    retVal = window.showModalDialog("html/eelex_setup.htm", smdArgs, "dialogHeight:480px;dialogWidth:640px;center:yes;edge:sunken;help:no;resizable:yes;scroll:yes;status:no;unadorned:no");
    if (retVal) {
        var tarr;
        tarr = retVal.split(JR);
        switch (tarr[0]) {
            case "colorsFonts":
                //retVal: colorsFonts
                setFontsSizes();
                window.status = "Fontide sätted edukalt salvestatud!";
                break;
            case "morf_ana":
                //retVal: morf_ana JR tul JR ls JR sqn JR vkkuju;
                ma_tul = parseInt(tarr[1]);
                ma_ls = parseInt(tarr[2]);
                ma_sqn = parseInt(tarr[3]);
                ma_vkkuju = parseInt(tarr[4]);
                window.status = MORF_ANA_SUCCESS;
                break;
            case "morf_syn":
                //retVal: morf_syn JR valtega JR vkkuju;
                ms_valtega = parseInt(tarr[1]);
                //sünteesi korral on parameeter teise jrk-ga, shsconfig-is on mõlemad analüüsi moodi;
                ms_vkkuju = (parseInt(tarr[2]) + 2) % 3;
                window.status = MORF_SYN_SUCCESS;
                break;
            case "eelex_setup":
                //retVal: eelex_setup JR setKeyboard JR doSpellCheck JR useMorfo;
                setKeyboard = jsStringToBoolean(tarr[1]);
                doSpellCheck = jsStringToBoolean(tarr[2]);
                useMorfo = jsStringToBoolean(tarr[3]);
                window.status = EELEX_SETUP_SUCCESS;
                break;
            case "morfoloogia/syntees":
                //retVal: "morfoloogia/syntees"
                window.status = "'morfoloogia/syntees' sätted edukalt salvestatud!"; ;
                break;
        }
    }
} //showEELexSetup;


/**
* 
*
* @method setFontsSizes
*/
function setFontsSizes() {
    var obj, tekst, cfgElem;
    var dicConfDom = IDD("File", "shsconfig_" + dic_desc + ".xml", false, false, null);
    cfgElem = dicConfDom.documentElement.selectSingleNode("colorsFonts/editArea/editFont");
    if (cfgElem) {
        tekst = cfgElem.text;
        textEditFont = tekst;
        if (tekst == '') {
            tekst = "Times New Roman";
        }
        obj = document.getElementById("ifrdiv");
        obj.style.fontFamily = tekst;
    }
    cfgElem = dicConfDom.documentElement.selectSingleNode("colorsFonts/viewArea/viewFont");
    if (cfgElem) {
        tekst = cfgElem.text;
        if (tekst == '') {
            tekst = "Times New Roman";
        }
        obj = document.getElementById("ifrviewdiv");
        obj.style.fontFamily = tekst;
    }
    cfgElem = dicConfDom.documentElement.selectSingleNode("colorsFonts/editArea/editFontSize");
    if (cfgElem) {
        tekst = cfgElem.text;
        if (tekst != '') {
            tekst += "pt";
        }
        obj = document.getElementById("ifrdiv");
        obj.style.fontSize = tekst;
    }
    cfgElem = dicConfDom.documentElement.selectSingleNode("colorsFonts/viewArea/viewFontSize");
    if (cfgElem) {
        tekst = cfgElem.text;
        if (tekst != '') {
            tekst += "pt";
        }
        obj = document.getElementById("ifrviewdiv");
        obj.style.fontSize = tekst;
    }
} // setFontsSizes


/**
* 
*
* @method updKeelteValik
* @param {String} schLocation
*/
function updKeelteValik(schLocation) {
    var tyybidDom = IDD("File", "xsd/" + schLocation, false, false, null);
    tyybidDom.setProperty("SelectionLanguage", "XPath");
    tyybidDom.setProperty("SelectionNamespaces", jsTrim(sXsdNsList));

    var valikuid = 0, xmlLangType, xmlLangEnums;
    var i, keel, enKeel, nativeKeel, appLangKeel;

    xmlLangType = tyybidDom.documentElement.selectSingleNode(NS_XS_PR + ":simpleType[@name = 'xmllang_tyyp']");
    if (xmlLangType != null) {
        xmlLangEnums = xmlLangType.selectNodes(NS_XS_PR + ":restriction/" + NS_XS_PR + ":enumeration");
        valikuid = xmlLangEnums.length;
        keelteValik = new Array();
    }
    if (valikuid > 0) {
        for (i = 0; i < valikuid; i++) {
            keel = xmlLangEnums[i];
            var sXsdXPath = NS_XS_PR + ":annotation/" + NS_XS_PR + ":documentation[@xml:lang='" + sAppLang + "']";
            var oXsdNode = keel.selectSingleNode(sXsdXPath);
            if (oXsdNode != null)
                appLangKeel = oXsdNode.text;
            else
                appLangKeel = '';
            keelteValik.push(keel.getAttribute("value") + JR + appLangKeel);
        }
    }
    else {
        if (keelteValik.length == 0) {
            var keeledDom, keeled;
            keeledDom = IDD("File", "iso639_1.xml", false, false, null);
            if (appDesc == "EXSA") { //'EXSA
                keeled = keeledDom.documentElement.selectNodes("record[not(@technical = '1')]");
            } else {
                keeled = keeledDom.documentElement.selectNodes("record");
            }
            for (i = 0; i < keeled.length; i++) {
                keel = keeled[i];
                enKeel = keel.selectSingleNode("name[lang('en')]").text;
                nativeKeel = keel.selectSingleNode("native").text;
                if (nativeKeel == null)
                    nativeKeel = enKeel;
                appLangKeel = keel.selectSingleNode("name[lang('" + sAppLang + "')]");
                if (appLangKeel != null)
                    appLangKeel = ' = ' + appLangKeel.text;
                else
                    appLangKeel = '';

                keelteValik.push(keel.getAttribute("code") + JR + nativeKeel + ' (' + enKeel + appLangKeel + ')');
            }
        }
    }
}


/**
* 
*
* @method getKeeledOptString
* @param {String} kVal
* @returns {String}
*/
function getKeeledOptString(kVal) {
    var opts = '';
    for (var i = 0; i < keelteValik.length; i++) {
        var keel = keelteValik[i].split(JR);
        opts += "<option id='" + keel[0] + "'";
        if (keel[0] == kVal) {
            opts += " selected";
        }
        opts += ">" + keel[0] + " - " + keel[1] + "</option>";
    }
    return opts;
}


/**
* 
*
* @method getEnumRows
* @returns {String} 
*/
function getEnumRows() {
    var trRows = '';
    for (var i = 0; i < keelteValik.length; i++) {
        var keel = keelteValik[i].split(JR);
        trRows += "<tr class='mi' " +
			"id='" + keel[0] + "' " +
			"value='" + keel[0] + "'" +
			"title=''>" +
				"<td>" + keel[0] + "</td>" +
				"<td>" + keel[1] + "</td>" +
			"</tr>";
    }
    return trRows;
}
