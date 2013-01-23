/**
* dxf.js
* Brauserisõltumatu versiooni proc_edit.js ja proc_app.js.
*
* @class dxf
*/
//Copyright© 2006 - 2012. Andres Loopmann, EKI, andres.loopmann@eki.ee. All rights reserved.
/**
* Palju muutujaid.
* 
* @property PaljuMuutujaid
*/
var asuKoht, asukohaInfo;
var brVer = "Unknown";

var DICPR, DICURI, dic_desc, dic_vols_count;
var sCmdId;
var sQryInfo; // päringu lahtiseletatud tekst

var dhxLayout, dhxBar, dhxAccord, artLayout, dhxTalaBar, dhxValaBar, brGrid, sbMain;
var elemInput;

var talaDoc, talaElement, talaDiv, talaXslXsl1, talaXslXsl2, talaXsl, talaXslProse, talaCss;
var valaDoc, valaElement, valaElementBgc, seldValaElementBgc = "yellow", valaDiv, valaXsl, valaXslProse, valaCss;

// ühekaupa EELex-ist
var trueTalaClick = true; // et kas klõpsati otse elemendile v hoopis vaates
var oClicked; // klõpsatud HTML element
var oClickedBorder; //tema border
var nodePath; // klõpsatud HTML-i XPath tee
var clType; // klõpsatu tüüp:   //et, etx1, etvw jt;
var clEditable; // kas on muudetav
var scv; // klõpsatud HTML-i originaaltekst (span content value)
var elemlang; // klõpsatud HTML-i lang atribuut

var clickedNode; // klõpsatud XML asi
var selectedNode; // element, mille küljes "clickedNode" on
var fatherNode; // "selectedNode" parent
var snQName; // "selectedNode" QName
var artMuudatused; // muudatused logide jaoks

var artOrgString; // oEditDOM algne xml, fillartframes alguses
var urArray, urIndex = -1; // undo/redo puhvrid, puhvrite indeks

var sUsrName; // EELex kasutajanimi
var srTegija; // kas on toimetaja v ainult vaataja
var sAppLang; // kasutajaliidese keel
var dest_language = ''; // vastekeele väärtused
var keelteValik; // @xml:lang väärtusteks
var sDicName; // sõnaraamatu nimetus
var qryMethod; // XML v MySql
var appDesc = ''; // EXSA v EELex vahelise erinevuse märkimiseks. EELex-is puudub
var eeLexAdmin; // arendajad

var cee; // uus, editeeritav <select> v <textarea>

// XML värk
var yldStruDom; // genereerimisel saadud skeemi XML-kujuline esitus
var oEditDOM; // Dom, millesse sisestatakse artikkel, ja milles kogu töö toimub, juurikaks <x:sr>
var oEditDOMRoot; // sõnastiku juurikas <sr>

// otsingul
var default_query, first_default;
var qn_sort_attr, qn_homnr, qn_guid, qn_toimetaja, qn_tkp, qn_autor, qn_akp, qn_art;
var neElems = "", neAttribs = "", fakult = "", msLsp = "", mySqlDataVer = "";

// märksõna keel (@xml:lang), tähestik
var msLang = '', msAlpha = '', msTranslSrc = '', msTranslDst = '';

// antud sõnastiku toimetajad
var srToimetajad = '';

// päringu tulemustest
var sFromVolume, dtOpStart;

// plokid, milledel on aT, aTA atribuudid (automaatse salvestusinfo jaoks)
var aTTAPlokid = '';

var sOrgMarkSona;
var sOrgHomnr;

var sDeldVolId, sAllVolId;

var bgColor = 'AntiqueWhite'; // gold, #D0E3EF, AntiqueWhite, khaki, WhiteSmoke
var editFont, editFontSize, viewFont, viewFontSize;


/**
* Käivitatakse EELexi laadides. Teeb kõik algseadistused. Näiteks ka kiirklahvid.
*
* @method bodyOnLoad
*/
function bodyOnLoad() {

    if (window.ActiveXObject) {
        return;
    }

    var fullAddress = window.location.href;

    asuKoht = fullAddress.substr(0, fullAddress.lastIndexOf("/") + 1); // koos '/'
    if (asuKoht.indexOf("/__shs_test/") < 0) {
        asukohaInfo = "";
    }
    else {
        asukohaInfo = " - T E S T B A A S";
        bgColor = "#D0E3EF";
    }
    brVer = getBrowserData();


    var spn_SrvParms = document.getElementById("spn_SrvParms");
    var tarr = spn_SrvParms.textContent.split("|");
    sUsrName = tarr[0];
    srTegija = jsStringToBoolean(tarr[1]);
    dic_desc = tarr[2];
    sAppLang = tarr[3];
    sDicName = tarr[4]; // Eesti keele põhisõnavara sõnastik
    qryMethod = tarr[5];

    var oConfigDOM, cfgElem, ix;

    oConfigDOM = IDD("File", "shsconfig_" + dic_desc + ".xml", false, false, null);
    if (!oConfigDOM) {
        alert("Puudub sõnastiku konf. fail 'shsconfig_" + dic_desc + ".xml'!");
        return;
    }
    try {
        DICPR = oConfigDOM.documentElement.getElementsByTagName("dicpr")[0].textContent;
        DICURI = oConfigDOM.documentElement.getElementsByTagName("dicuri")[0].textContent;
        dic_vols_count = getXmlNodesSnapshot(oConfigDOM.documentElement, "vols/vol").snapshotLength;
        default_query = oConfigDOM.documentElement.getElementsByTagName("default_query")[0].textContent;
        first_default = oConfigDOM.documentElement.getElementsByTagName("first_default")[0].textContent;
        qn_sort_attr = oConfigDOM.documentElement.getElementsByTagName("qn_sort_attr")[0].textContent;
    }
    catch (e) {
        alert(e.name + " 0x" + hex(e.number, true) + ": '" + e.description + "'.");
        return;
    }
    cfgElem = oConfigDOM.documentElement.getElementsByTagName("appDesc")[0]; //'EXSA, EELex;
    if (cfgElem) {
        appDesc = cfgElem.textContent;
    }

    msAlpha = "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsŠšZzŽžTtUuVvWwÕõÄäÖöÜüXxYy";
    cfgElem = oConfigDOM.documentElement.getElementsByTagName("msLang")[0];
    if (cfgElem) {
        msLang = cfgElem.textContent;
    }
    if (msLang) {
        cfgElem = oConfigDOM.documentElement.getElementsByTagName("msAlpha")[0];
        if (cfgElem) {
            msAlpha = cfgElem.textContent;
        }
        else {
            alert("Märksõna keel olemas ('" + msLang + "'), kuid puudub tähestik!");
            return;
        }
        cfgElem = oConfigDOM.documentElement.getElementsByTagName("msTranslSrc")[0];
        if (cfgElem)
            msTranslSrc = cfgElem.textContent;
        cfgElem = oConfigDOM.documentElement.getElementsByTagName("msTranslDst")[0];
        if (cfgElem)
            msTranslDst = cfgElem.textContent;
    }

    qn_ms = default_query.substr(default_query.lastIndexOf("/") + 1);
    qn_homnr = DICPR + ":i";
    qn_guid = DICPR + ":G";
    qn_toimetaja = DICPR + ":T";
    qn_tkp = DICPR + ":TA";
    qn_autor = DICPR + ":K";
    qn_akp = DICPR + ":KA";
    qn_art = DICPR + ":A";


    cfgElem = oConfigDOM.documentElement.getElementsByTagName("neelems")[0];
    if (cfgElem) {
        neElems = cfgElem.textContent;
    }
    cfgElem = oConfigDOM.documentElement.getElementsByTagName("neattribs")[0];
    if (cfgElem) {
        neAttribs = cfgElem.textContent;
    }
    cfgElem = oConfigDOM.documentElement.getElementsByTagName("fakult")[0];
    if (cfgElem) {
        fakult = cfgElem.textContent;
    }
    cfgElem = oConfigDOM.documentElement.getElementsByTagName("msLsp")[0];
    if (cfgElem) {
        msLsp = cfgElem.textContent;
    }
    cfgElem = oConfigDOM.documentElement.getElementsByTagName("mySqlDataVer")[0];
    if (cfgElem) {
        mySqlDataVer = cfgElem.textContent;
    }
    cfgElem = oConfigDOM.documentElement.getElementsByTagName("destLang")[0];
    if (cfgElem) {
        dest_language = cfgElem.textContent;
        if (dest_language == "et") { //'nt Pärtel Lippus: Inglise-eesti foneetika terminite sõnastik
            if (sAppLang == "et") {
                dest_language = "";
            }
        }
    }

    // fondid
    editFont = getXmlSingleNodeValue(oConfigDOM.documentElement, "colorsFonts/editArea/editFont");
    editFontSize = getXmlSingleNodeValue(oConfigDOM.documentElement, "colorsFonts/editArea/editFontSize");
    viewFont = getXmlSingleNodeValue(oConfigDOM.documentElement, "colorsFonts/viewArea/viewFont");
    viewFontSize = getXmlSingleNodeValue(oConfigDOM.documentElement, "colorsFonts/viewArea/viewFontSize");


    // tõlkekeeled, @xml:lang
    keelteValik = new Array();
    updKeelteValik(dic_desc + "/" + dic_desc + "_tyybid.xsd");


    var eelexConf = IDD("File", "shsConfig.xml", false, false, null);
    if (!eelexConf) {
        alert("Puudub EELex konf. fail 'shsConfig.xml'!");
        return;
    }
    try {
        eeLexAdmin = eelexConf.documentElement.getElementsByTagName("eeLexAdmin")[0].textContent;
    }
    catch (e) {
        alert(e.name + " 0x" + hex(e.number, true) + ": '" + e.description + "'.");
        return;
    }

    var userListDom = exCGISync("getusers.cgi", "id" + PD + dic_desc);
    srToimetajad = userListDom.responseText;



    talaXslXsl1 = IDD("File", "xsl/xsl1.xsl", false, false, null);

    talaXslXsl2 = IDD("File", "xsl/gendXsl2_" + dic_desc + ".xsl", false, false, null);
    if (!talaXslXsl2) {
        alert("Skeemi ja toimetamisala genereerimine tegemata!");
        return;
    }
    var talaXslNode = talaXslXsl2.documentElement.getElementsByTagNameNS(NS_XSL, "variable")[1]; // appLang
    if (talaXslNode) {
        if (talaXslNode.getAttribute("name") == "appLang") {
            talaXslNode.textContent = sAppLang;
        }
    }
    talaXslNode = talaXslXsl2.documentElement.getElementsByTagNameNS(NS_XSL, "variable")[9]; // tblBrdCol
    if (talaXslNode) {
        if (talaXslNode.getAttribute("name") == "tblBrdCol") {
            talaXslNode.textContent = "red";
        }
    }
    talaXslNode = talaXslXsl2.documentElement.getElementsByTagNameNS(NS_XSL, "variable")[10]; // addGroupPicture
    if (talaXslNode) {
        if (talaXslNode.getAttribute("name") == "addGroupPicture") {
            //            talaXslNode.textContent = "graphics/CopyHS.png";
        }
    }
    talaXslNode = talaXslXsl2.documentElement.getElementsByTagNameNS(NS_XSL, "variable")[11]; // delGroupPicture
    if (talaXslNode) {
        if (talaXslNode.getAttribute("name") == "delGroupPicture") {
            //            talaXslNode.textContent = "graphics/Trash.ico";
        }
    }
    talaXslNode = talaXslXsl2.documentElement.getElementsByTagNameNS(NS_XSL, "variable")[12]; // createGroupPicture
    if (talaXslNode) {
        if (talaXslNode.getAttribute("name") == "createGroupPicture") {
            //            talaXslNode.textContent = "graphics/Add.ico";
        }
    }
    talaXslNode = talaXslXsl2.documentElement.getElementsByTagNameNS(NS_XSL, "variable")[13]; // addLisadPicture
    if (talaXslNode) {
        if (talaXslNode.getAttribute("name") == "addLisadPicture") {
            //            talaXslNode.textContent = "graphics/Add.ico";
        }
    }
    talaXslNode = talaXslXsl2.documentElement.getElementsByTagNameNS(NS_XSL, "variable")[14]; // delLisadPicture
    if (talaXslNode) {
        if (talaXslNode.getAttribute("name") == "delLisadPicture") {
            //            talaXslNode.textContent = "graphics/Delete.ico";
        }
    }


    valaXsl = IDD("File", "xsl/gendView_" + dic_desc + ".xsl", false, false, null);
    if (!valaXsl) {
        alert("Vaate genereerimine tegemata!");
        return;
    }
    //piltide kontekst, pildiJuurikas
    var valaXslNode = valaXsl.documentElement.getElementsByTagNameNS(NS_XSL, "variable")[0]; // pildiJuurikas
    if (valaXslNode) {
        if (valaXslNode.getAttribute("name") == "pildiJuurikas") {
            valaXslNode.textContent = asuKoht + "__sr/";
        }
    }
    // kui ei ole MSIE, siis ka mitte value-of select="" disable-output-escaping="yes"
    valaXslNode = valaXsl.documentElement.getElementsByTagNameNS(NS_XSL, "variable")[3]; // msie
    if (valaXslNode) {
        if (valaXslNode.getAttribute("name") == "msie") {
            valaXslNode.textContent = "0";
        }
    }


    yldStruDom = IDD("File", "xml/" + dic_desc + "/stru_" + dic_desc + ".xml", false, false, null);
    if (!yldStruDom) {
        alert("Skeemi ja toimetamisala genereerimine tegemata!");
        return;
    }
    // The normalize method joins adjacent text nodes into a single text node and removes empty text nodes. 
    // Note: in Internet Explorer, the normalize method does not remove empty text nodes.
    yldStruDom.normalize();


    if (yldStruDom.documentElement.getAttribute("pr_sd:ver") == "2.0") {
        oEditDOM = IDD("", "", false, false, null);
        oEditDOMRoot = oEditDOM.appendChild(oEditDOM.createElementNS(DICURI, yldStruDom.documentElement.nodeName));
        var xmlLang = yldStruDom.documentElement.getAttribute("xml:lang");
        if (xmlLang) {
            oEditDOMRoot.setAttribute("xml:lang", xmlLang);
        }
    } else {
        alert("Skeemi ja toimetamisala genereerimine tegemata!");
        return;
    }

    talaXsl = talaXslXsl2;
    //    if (document.implementation && document.implementation.createDocument) {
    talaXslProse = new XSLTProcessor();
    if (talaXslProse) {
        talaXslProse.importStylesheet(talaXsl);
    } else {
        alert("\"new XSLTProcessor()\" nurjus ('tala')!");
        return;
    }

    valaXslProse = new XSLTProcessor();
    if (valaXslProse) {
        valaXslProse.importStylesheet(valaXsl);
    } else {
        alert("\"new XSLTProcessor()\" nurjus ('vala')!");
        return;
    }



    //    window.dhx_globalImgPath = "html/dhtmlx/dhtmlxCombo/codebase/imgs/";

    dhxLayout = new dhtmlXLayoutObject("parentId", "1C", "dhx_skyblue");
    dhxLayout.cells("a").hideHeader();
    //    dhxLayout.cont.obj._offsetTop = 10;
    //    dhxLayout.cont.obj._offsetHeight = -60;


    dhxBar = dhxLayout.cells("a").attachToolbar();
    dhxBar.setSkin("dhx_skyblue");
    dhxBar.setIconsPath("graphics/");

    var barNr = 0;
    dhxBar.addText("dhxBarMenu", ++barNr, "<div id='srMenu'></div>");
    var srMenuObj = document.getElementById("srMenu");
    var srMenu = new dhtmlXMenuObject(srMenuObj, "dhx_skyblue");
    srMenu.setIconsPath("graphics/");
    var menuXml =
        "<menu>" +
          "<item id='mnuSr' text='Sõnastik' img='hr_xp_shell32_16_256.ico'>" +
              "<item id='idViewLogs' text='Toimetamise logi' img='History.png'/>" +
              "<item id='idSrvXmlValidate' text='Köite valideerimine' img='CheckGrammarHS.png'/>" +
          "</item>" +
        "</menu>";
    srMenu.loadXMLString(menuXml);
    srMenu.attachEvent("onClick", function (id, zoneId, casState) {
        srMenuOnClick(id);
    });

    //    dhxBar.addButton(id, pos, text, imgEnabled, imgDisabled);
    dhxBar.addButton("btnValiArtikkel", ++barNr, null, "TableHS.png", null); // EditTableHS
    dhxBar.setItemToolTip("btnValiArtikkel", "Too esile otsingutulemuste loend");

    dhxBar.addSeparator("seprPealeLoendit", ++barNr);

    //    dhxBar.addButton(id, pos, text, imgEnabled, imgDisabled);
    dhxBar.addButton("btnLisaArtikkel", ++barNr, null, "NewWindow.png", null);
    dhxBar.setItemToolTip("btnLisaArtikkel", "Lisa uus artikkel");

    dhxBar.addSeparator("seprPealeLisamist", ++barNr);

    sDeldVolId = dic_desc + "0";
    sAllVolId = dic_desc + "All";

    cfgElem = oConfigDOM.documentElement.getElementsByTagName("vols")[0];
    if (cfgElem) {
        var vols = cfgElem.getElementsByTagName("vol");
        var opts = new Array();
        var optArr;
        for (ix = 0; ix < vols.length; ix++) {
            var vNr = vols[ix].getAttribute("nr");
            var vTekst = vols[ix].textContent;
            //id - id of the option;
            // type - obj|sep, whether this option is an object or a separator;
            // text - label of the option (only for objects);
            // img - path to the option image (only for objects).
            optArr = [dic_desc + vNr, 'obj', vNr + '. köide ' + vTekst, null];
            opts.push(optArr);
        }
        optArr = ['sep01', 'sep', '', ''];
        opts.push(optArr);
        optArr = [sAllVolId, 'obj', 'Kõik köited', null];
        opts.push(optArr);
        optArr = [sDeldVolId, 'obj', 'Kustutatud', null];
        opts.push(optArr);
    }
    else {
        return;
    }

    //    toolbar.addButtonSelect(id, pos, text, opts, imgEnabled, imgDisabled, renderSelect, openAll, maxOpen);
    dhxBar.addButtonSelect("volSelect", ++barNr, "Vali köide", opts, null, null, true, true);
    dhxBar.setWidth("volSelect", 100);

    setButtonSelectId("volSelect", dic_desc + "1");

    if (qryMethod == "MySql" && dic_vols_count > 1) {
        setButtonSelectId("volSelect", dic_desc + "All");
    }

    opts = [['elm_' + qn_ms, 'obj', 'märksõna', null]];
    dhxBar.addButtonSelect("elemSelect", ++barNr, "Element", opts, null, null, true, true);
    setButtonSelectId("elemSelect", 'elm_' + qn_ms);
    dhxBar.setWidth("elemSelect", 200);

    //    toolbar.addInput(id, pos, value, width);
    dhxBar.addInput("txtElemOtsitav", ++barNr, "", 400);

    //    dhxBar.addButton(id, pos, text, imgEnabled, imgDisabled);
    dhxBar.addButton("btnSrch", ++barNr, " Otsi ", null, null);
    dhxBar.setItemToolTip("btnSrch", "Käivita otsing");

    dhxBar.attachEvent("onClick", function (id) {
        toolBarOnClick(id);
    });
    dhxBar.attachEvent("onEnter", function (id, value) {
        otsing(qryMethod);
    });


    var inputs = dhxBar.cont.getElementsByTagName("input"); // 'DOMelem_input' on combo korral nt
    for (ix = 0; ix < inputs.length; ix++) {
        var thisInput = inputs[ix];
        if (thisInput.getAttribute("type") == "text" && thisInput.tagName == "INPUT") {
            elemInput = thisInput;
            break;
        }
    }


    dhxAccord = dhxLayout.cells("a").attachAccordion();
    //    dhxAccord.setIconsPath("html/dhtmlx/dhtmlxAccordion/codebase/imgs/dhxaccord_dhx_skyblue");

    dhxAccord.addItem("artikkel", "");
    dhxAccord.cells("artikkel").setText("Artikkel <span id='artikliInfo' style='font-weight:normal;'>[<span id='artMsTekst'></span><span id='artMsMuudetud' style='color:red;'></span>] - <span id='spnNodeXPath'></span></span>");


    artLayout = dhxAccord.cells("artikkel").attachLayout("2U");
    artLayout.cells("a").hideHeader();
    artLayout.cells("b").hideHeader();

    var talaBarWidth = artLayout.cells("a").getWidth();
    dhxTalaBar = artLayout.cells("a").attachToolbar();
    dhxTalaBar.setIconsPath("graphics/");

    barNr = 0;
    dhxTalaBar.addText("dhxTalaBarText", ++barNr, "<u>Toimetamisala</u>");

    dhxTalaBar.addButton("btnViewXsl1", ++barNr, "<span style='font-weight:bold;'> XML </span>", null, null);
    //    //    toolbar.addButtonTwoState(id, pos, text, imgEnabled, imgDisabled);
    //    dhxTalaBar.addButtonTwoState("btnViewXsl1", ++barNr, "<span style='font-weight:bold;'> XML </span>", null, null);
    //    dhxTalaBar.setItemState("btnViewXsl1", false); // state = true/false

    dhxTalaBar.addButton("btnViewXsl2", ++barNr, "<span style='font-weight:bold;'> Tabel </span>", null, null);
    //    //    toolbar.addButtonTwoState(id, pos, text, imgEnabled, imgDisabled);
    //    dhxTalaBar.addButtonTwoState("btnViewXsl2", ++barNr, "<span style='font-weight:bold;'> Tabel </span>", null, null);
    //    dhxTalaBar.setItemState("btnViewXsl2", true); // state = true/false

    dhxTalaBar.addSeparator("seprPealeToimetamisalaVaateid", ++barNr);


    dhxTalaBar.addButton("btnReadFirst", ++barNr, null, "DataContainer_MoveFirstHS.png", null);
    dhxTalaBar.setItemToolTip("btnReadFirst", "Esimene artikkel");
    dhxTalaBar.addButton("btnReadPrev", ++barNr, null, "DataContainer_MovePreviousHS.png", null);
    dhxTalaBar.setItemToolTip("btnReadPrev", "Eelmine artikkel");
    dhxTalaBar.addButton("btnReadNext", ++barNr, null, "DataContainer_MoveNextHS.png", null);
    dhxTalaBar.setItemToolTip("btnReadNext", "Järgmine artikkel");
    dhxTalaBar.addButton("btnReadLast", ++barNr, null, "DataContainer_MoveLastHS.png", null);
    dhxTalaBar.setItemToolTip("btnReadLast", "Viimane artikkel");

    dhxTalaBar.addSeparator("seprPealeNavigeerimist", ++barNr);


    dhxTalaBar.addText("dhxTalaBarDummy", ++barNr, " ");
    dhxTalaBar.setWidth("dhxTalaBarDummy", talaBarWidth - (28 * 16));

    dhxTalaBar.addSeparator("seprPealeDummyt", ++barNr);

    //    dhxTalaBar.addButton("btnSave", ++barNr, null, "Save.ico", "Save_disabled.ico");
    dhxTalaBar.addButton("btnSave", ++barNr, null, "saveHS.png", "saveHS_Gray.png");
    dhxTalaBar.setItemToolTip("btnSave", "Salvesta artikkel");
    // võib ju olla alles sisestatud artikkel oma tühjade kastidega
    //    dhxTalaBar.disableItem("btnSave");

    //    dhxTalaBar.addButton("btnDelete", ++barNr, null, "delart_16-16.ico");
    //    dhxTalaBar.addButton("btnDelete", ++barNr, null, "DeleteHS.png", "DeleteHS.png");
    dhxTalaBar.addButton("btnDelete", ++barNr, null, "delete.png", "DeleteHS.png");
    dhxTalaBar.setItemToolTip("btnDelete", "Kustuta artikkel");

    dhxTalaBar.addSeparator("seprPealeKustutamist", ++barNr);


    dhxTalaBar.addText("dhxTalaBarUndoRedoInfo", ++barNr, "(<span id='currBuffNr' title='Puhvri number'> </span>/<span id='buffCount' title='Puhvrite arv'> </span>)");
    dhxTalaBar.addButton("btnUndo", ++barNr, null, "Edit_UndoHS.png", "Edit_UndoHS_Gray.png");
    dhxTalaBar.setItemToolTip("btnUndo", "Tühista (\"Undo\")");
    dhxTalaBar.disableItem("btnUndo");
    dhxTalaBar.addButton("btnRedo", ++barNr, null, "Edit_RedoHS.png", "Edit_RedoHS_Gray.png");
    dhxTalaBar.setItemToolTip("btnRedo", "Taasta (\"Redo\")");
    dhxTalaBar.disableItem("btnRedo");

    dhxTalaBar.attachEvent("onClick", function (id) {
        dhxTalaBarOnClick(id);
    });

    var tala = artLayout.cells("a").attachURL("tala.htm");


    dhxValaBar = artLayout.cells("b").attachToolbar();
    dhxValaBar.setIconsPath("graphics/");

    barNr = 0;
    dhxValaBar.addText("dhxValaBarText", ++barNr, "<u>Vaade</u>");

    var vala = artLayout.cells("b").attachURL("vala.htm");


    dhxAccord.addItem("loend", "Loend");
    brGrid = dhxAccord.cells("loend").attachGrid();
    brGrid.setImagePath("html/dhtmlx/dhtmlxGrid/codebase/imgs/");
    brGrid.setHeader("Jnr,Kd.,Märksõna(d),Leid,K.,K. lõpp,T.,T. aeg,T. lõpp,Pt.");
    brGrid.setInitWidths("50,50,100,*,100,150,100,150,200,100");
    brGrid.setColAlign("center,center,left,left,left,left,left,left,left,left");
    brGrid.enableEditEvents(false, false, false); // click, dblclick, F2
    brGrid.setColSorting("int,str,str,str,str,str,str,str,str,str");
    brGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro,ro,ro,ro");
    brGrid.enableTooltips("false,false,false,false,false,false,false,false,false,false");
    brGrid.setSkin("xp");
    //    brGrid.enableAutoHeight(true); // aeglus
    brGrid.attachHeader(" ,#cspan,#text_search,#text_filter,#combo_filter,#text_filter,#combo_filter,#text_filter,#text_filter,#combo_filter");
    // setStyle(ss_header, ss_grid, ss_selCell, ss_selRow)
    //    brGrid.setStyle("background-color:navy;color:white; font-weight:bold;", "", "color:red;", "");
    //    brGrid.setStyle("", "background-color:" + bgColor + ";", "", "background-color:silver;");
    brGrid.init();
//    brGrid.enableSmartRendering(true);

    brGrid.attachEvent("onRowSelect", function (id, ind) {
        gridOnRowSelect(id, ind);
    });
    brGrid.attachEvent("onRightClick", function (id, ind, obj) {
        gridOnRightClick(id, ind, obj);
    });

    dhxAccord.setEffect(false); // tüütu
    tooEsileArtikkel();

    sbMain = dhxLayout.cells("a").attachStatusBar(); // returns status bar object

    if (talaXsl == talaXslXsl2) {
        dhxTalaBar.disableItem("btnViewXsl2");
        dhxTalaBar.enableItem("btnViewXsl1");
    } else if (talaXsl == talaXslXsl1) {
        dhxTalaBar.disableItem("btnViewXsl1");
        dhxTalaBar.enableItem("btnViewXsl2");
    }

    bodyOnResize();

    var xh, rspDom;
    xh = exCGISync("tools.cgi", "appOpen" + PD + dic_desc + PD + sUsrName + PD + brVer);
    if (xh.statusText == "OK") {
        rspDOM = ParseHTTPResponse(xh);
        if (rspDOM) {
            var opStatus = getXmlSingleNodeValue(rspDOM, "rsp/sta");
            if (opStatus == "Success") {
            } else {
            }
        }
    }


    elemInput.focus();

} //bodyOnLoad


/**
* Kutsutakse välja, kui keegi on riba (bar) peal vajutanud ja kutsub välja vajaliku funktsiooni.
*
* @method toolBarOnClick
* @param {String} clickedId
*/
function toolBarOnClick(clickedId) {
    var itmType = dhxBar.getType(clickedId);
    if (itmType == "buttonSelectButton") { // köidete, elementide
        if (clickedId.substr(0, 3) == dic_desc) { // mõne köite id
            var tekst = dhxBar.getListOptionText("volSelect", clickedId);
            dhxBar.setItemText("volSelect", tekst);
            elemInput.focus();
        } else if (clickedId.substr(0, 4) == "elm_") { // mõne elemendi id
            elemInput.focus();
        } else if (clickedId.substr(0, 4) == "att_") { // mõne atribuudi id
            //            elemInput.focus();
        }
    } else if (itmType == "button") {
        if (clickedId == "btnSrch") {
            otsing(qryMethod);
        } else if (clickedId == "btnValiArtikkel") {
            var isOp = dhxAccord.cells("artikkel").isOpened(); // returns true/false
            if (isOp) {
                tooEsileLoend();
            } else {
                tooEsileArtikkel();
            }
        } else if (clickedId == "btnLisaArtikkel") {
            imgArtAddClick();
        }
    }
} // toolBarOnClick


/**
* Kutsutakse välja, kui keegi klikib Toimetamisala ribal, ja kutsub välja vajaliku funktsiooni.
*
* @method dhxTalaBarOnClick
* @param {String} clickedId
*/
function dhxTalaBarOnClick(clickedId) {
    var currBuffNrElement;

    if (clickedId == "btnSave") {
        imgArtSaveClick();
    } else if (clickedId == "btnDelete") {
        kustutamine();
    } else if (clickedId == "btnViewXsl1") {
        talaXsl = talaXslXsl1;
        talaXslProse = new XSLTProcessor();
        talaXslProse.importStylesheet(talaXsl);
        vaatedRefresh(2, true, false);
        dhxTalaBar.disableItem("btnViewXsl1");
        dhxTalaBar.enableItem("btnViewXsl2");
    } else if (clickedId == "btnViewXsl2") {
        talaXsl = talaXslXsl2;
        talaXslProse = new XSLTProcessor();
        talaXslProse.importStylesheet(talaXsl);
        vaatedRefresh(2, true, false);
        dhxTalaBar.disableItem("btnViewXsl2");
        dhxTalaBar.enableItem("btnViewXsl1");
    } else if (clickedId == "btnUndo") {
        if (urIndex > 0) {
            urIndex--;
            oEditDOM = BuildXMLFromString(urArray[urIndex]);
            oEditDOMRoot = oEditDOM.documentElement;
            vaatedRefresh("UndoRedo", true, true);
            currBuffNrElement = document.getElementById("currBuffNr");
            currBuffNrElement.textContent = urIndex + 1;
        }
    } else if (clickedId == "btnRedo") {
        if (urIndex < urArray.length - 1) {
            urIndex++;
            oEditDOM = BuildXMLFromString(urArray[urIndex]);
            oEditDOMRoot = oEditDOM.documentElement;
            vaatedRefresh("UndoRedo", true, true);
            currBuffNrElement = document.getElementById("currBuffNr");
            currBuffNrElement.textContent = urIndex + 1;
        }
    } else if (clickedId == "btnReadFirst") {
        showPrevNextEntry(0);
    } else if (clickedId == "btnReadPrev") {
        showPrevNextEntry(-1);
    } else if (clickedId == "btnReadNext") {
        showPrevNextEntry(+1);
    } else if (clickedId == "btnReadLast") {
        showPrevNextEntry(1000000);
    }
} // dhxTalaBarOnClick


/**
* Kutsutakse välja, kui klikatakse Sõnastiku tööriistade menüü valikul. Ja käivitab vajaliku funktsiooni.
*
* @method srMenuOnClick
* @param {String} mnuItmId
*/
function srMenuOnClick(mnuItmId) {
    if (mnuItmId == "idViewLogs") {
        showDicLogs();
    } else if (mnuItmId == "idSrvXmlValidate") {
        srvXmlValidate();
    }
} // srMenuOnClick

/**
* Toob artikli esile ja näitab nuppu otsingutulemuste esiletoomiseks. 
*
* @method tooEsileArtikkel
*/
function tooEsileArtikkel() {
    dhxAccord.cells("artikkel").open();
    dhxBar.setItemImage("btnValiArtikkel", "TableHS.png");
    dhxBar.setItemToolTip("btnValiArtikkel", "Too esile otsingutulemuste loend");
}


/**
* Toob esile otsingutulemuste tabeli ja näitab nuppu artikli esiletoomiseks. 
*
* @method tooEsileLoend
*/
function tooEsileLoend() {
    dhxAccord.cells("loend").open();
    dhxBar.setItemImage("btnValiArtikkel", "AppWindow.png");
    dhxBar.setItemToolTip("btnValiArtikkel", "Too esile artikkel");
}


/**
* Käivitab otsingupäringu.
* 
* @method otsing
* @param {String} parQM Päringumeetod (XML või MySQL).
*/
function otsing(parQM) {

    var withCase = 0, withSymbols = 0;
    var ft, attXmlPred = "", attSqlPred = "", mySqlAttCond = "", sNodeTest, seldQn, qt, qtMySql;
    var artRada, elemRada, evPath, srchPtrn, fakPtrn = "", mySqlPtrn = "", hlPtrn = "", pQrySql = "";
    var hasSeldText = false;

    var qM = parQM;

    if (withSymbols < 1) {
        ft = jsTrim(dhxBar.getValue("txtElemOtsitav"));
    } else {
        ft = dhxBar.getValue("txtElemOtsitav");
    }

    sQryInfo = dhxBar.getItemText("volSelect") + ": " + dhxBar.getItemText("elemSelect") + " = '" + ft + "'";

    //sNodeTest algab artiklist: "q:A/..." jne
    sNodeTest = default_query;
    seldQn = sNodeTest.substr(sNodeTest.lastIndexOf("/") + 1);
    hasSeldText = true;

    //qt: .//text(), self::node(), text()
    qt = "self::node()";
    if (qt == ".//text()") {
        qtMySql = "//text()";
    } else if (qt == "self::node()") {
        qtMySql = "//text()";
    } else if (qt == "text()") {
        qtMySql = "/text()";
    }

    artRada = qn_art;
    evPath = sNodeTest;
    if (sNodeTest == artRada) { //A
        elemRada = "";
    } else {
        if (1 == 1) { // use_global linnuke
            elemRada = ".//" + seldQn;
            evPath = ".//" + seldQn;
        } else {
            elemRada = sNodeTest.substr(sNodeTest.indexOf("/") + 1); //'q:A/ - st edasi ...
        }
    }


    // valitud artikkel ning otsitakse kas tühja v olematut artiklit
    if (sNodeTest == artRada && (ft == "" || ft == "=NULL")) {
        return;
    }

    if (seldQn == qn_ms && fakult.length > 0 && withSymbols == -1) {
        fakPtrn = fakult;
    }


    if (ft == "=.") {
        return;
    } else if (ft == "!=.") {
        return;
    } else if (jsLeft(ft, 2) == "§§") {
        withSymbols = 1;
        withCase = 1;
        qM = "XML";
        srchPtrn = ft.substr(2);
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
    } else if (jsLeft(ft, 1) == "§") {
        elpred = "[" + jsTrim(ft).substr(1) + "]";
        if (sNodeTest == artRada) { //A;
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
        withSymbols = 1;
        withCase = 1;
        qM = "XML";
        // et kas elemendil on teksti ette näthud v mitte (hasSeldText)
        // kui 'false', siis läheb alati ExtractValue kaudu
        hasSeldText = false;
        pQrySql = getSqlQuery(seldQn, ft, hasSeldText, withSymbols, withCase, evPath, elemRada, mySqlAttCond);
    } else {

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
            evPath = artRada + elpred + "//text()" //'sõltumata "qtMySql" - ist
            attXmlPred = ""; //'ei ole kasutatav atr tingimus, kui otsime elementi, mida pole;
            mySqlAttCond = "";
        } else {
            ft = RemoveSymbols(ft, "*? ");

            //serveris otsib 'srch' tectContent' abil, selles aga '&amp;' -> '&';
            // juba "RemoveSymbols" - is tehtud
            srchPtrn = jsReplace(ft, "&amp;", "&");
            srchPtrn = getSrPn2(srchPtrn, "XML");

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
        if ("1" == "1") { // aElemInfo[3], IsElement
            pQrySql = getSqlQuery(seldQn, ft, hasSeldText, withSymbols, withCase, evPath, elemRada, mySqlAttCond);
        }

    }

    pQrySql += " LIMIT 500";
    art_xpath += "[position() &lt; 501]";

    var currentVolId = dhxBar.getListOptionSelected("volSelect");

    sCmdId = "ClientRead";
    var cmdXml = "<prm>" +
                    "<cmd>" + sCmdId + "</cmd>" +
                    "<vol>" + currentVolId + "</vol>" +
                    "<nfo>" + sQryInfo + "</nfo>" +
                    "<axp>" + art_xpath + "</axp>" +
                    "<exp>" + elm_xpath + "</exp>" +
                    "<wC>" + withCase + "</wC>" +
                    "<wS>" + withSymbols + "</wS>" +
                    "<evP>" + evPath + "</evP>" +
                    "<qn>" + seldQn + "</qn>" +
                    "<fSrP>" + srchPtrn + "</fSrP>" +
                    "<pFakPtrn>" + fakPtrn + "</pFakPtrn>" +
                    "<fMsqlP>" + mySqlPtrn + "</fMsqlP>" +
                    "<hlP>" + hlPtrn + "</hlP>" +
                    "<qM>" + qM + "</qM>" +
                    "<pQrySql>" + pQrySql + "</pQrySql>" +
                "</prm>";

    var cmdXmlDom = IDD("String", cmdXml, false, false, null);
    StartOperation(cmdXmlDom);
} // otsing


/**
* Avatud artikli kustutamine. Kontrollib, kas artikkel avatud, kas kasutaja ikka tahab kustutada ja seejärel kutsub kustutaArtikkel().
* 
* @method kustutamine
*/
function kustutamine() {
    if (!(oEditDOMRoot.hasChildNodes())) {
        return;
    }

    //DEL_WORD
    var nRetBtn = window.confirm("Kas soovid kustutada artikli '" + document.getElementById("artMsTekst").textContent + "'?");
    if (!nRetBtn) {
        return;
    }

    kustutaArtikkel()
} // kustutamine


/**
* Kustutab avatud artikli ära.
* 
* @method kustutaArtikkel
*/
function kustutaArtikkel() {
    var destVol, orgVolFile, sqlVol;
    if (sFromVolume == sDeldVolId) {
        //        sCmdId = "ClientRestore";
        //        if ((dic_vols_count > 1)) {
        //            orgVolFile = oEditDOMRoot.selectSingleNode(DICPR + ":A").getAttribute(DICPR + ":KF");
        //            if ((orgVolFile == "")) {
        //                orgVolFile = prompt("Sisesta köite number!");
        //                if ((orgVolFile == "" || parseInt(orgVolFile) < 1 || parseInt(orgVolFile) > dic_vols_count)) {
        //                    return;
        //                } else {
        //                    orgVolFile = dic_desc + orgVolFile;
        //                }
        //            }
        //            destVol = orgVolFile;
        //        } else {
        //            destVol = dic_desc + "1";
        //        }
        //        sqlVol = destVol;
        return;
    } else {
        sCmdId = "ClientDelete";
        destVol = sDeldVolId;
        sqlVol = sFromVolume;
    }

    var msNode, sMarkSona, homNr, sMSortVal;
    msNode = getXmlSingleNode(oEditDOMRoot, first_default);
    if (msNode) {
        sMarkSona = msNode.textContent;
    }
    if (!sMarkSona) {
        alert("Ei salvesta ... (<m>)");
        return;
    }
    homNr = msNode.getAttribute(DICPR + ":i");
    sMSortVal = msNode.getAttribute(qn_sort_attr);
    if (!sMSortVal) {
        alert("Ei salvesta ... (@O)");
        return;
    }

    sQryInfo = sMSortVal;

    var artGuid, qM, seldQn, srchPtrn, homonyymsed, art_xpath, elm_xpath, sql;
    artGuid = getXmlSingleNode(oEditDOMRoot, DICPR + ":A/" + qn_guid).textContent;
    qM = "MySql";
    seldQn = qn_ms;  //pärast otsitakse nn homonüümseid märksõnu, st millised veel sama märksõnaga on;
    srchPtrn = "^" + sMSortVal + "$";
    homonyymsed = "";
    //    if (!(oXslEdit == oXsl1)) {
    homonyymsed = jsMid(first_default, first_default.indexOf("/") + 1) + "[. = " + GCV(sMarkSona, "", 2);
    sql = "SELECT " + dic_desc + ".md AS md, " + "msid.ms AS l, " + "msid.ms_att_i AS ms_att_i, " + "msid.ms_att_liik AS ms_att_liik, " + "msid.ms_att_ps AS ms_att_ps, " + "msid.ms_att_tyyp AS ms_att_tyyp, " + "msid.ms_att_mliik AS ms_att_mliik, " + "msid.ms_att_k AS ms_att_k, " + "msid.ms_att_mm AS ms_att_mm, " + "msid.ms_att_st AS ms_att_st, " + "msid.ms_att_vm AS ms_att_vm, " + "msid.ms_att_all AS ms_att_all, " + "msid.ms_att_uus AS ms_att_uus, " + "msid.ms_att_zs AS ms_att_zs, " + dic_desc + ".G AS G, " + dic_desc + ".art AS art, " + dic_desc + ".K AS K, " + dic_desc + ".T AS T, " + dic_desc + ".TA AS TA, " + dic_desc + ".PT AS PT, " + dic_desc + ".vol_nr AS vol_nr " + "FROM msid, " + dic_desc + " " + "WHERE (" + dic_desc + ".G = msid.G " + "AND msid.dic_code = '" + dic_desc + "' " + "AND (msid.ms = \"" + sMarkSona + "\"";
    homonyymsed = homonyymsed + "]";
    sql = sql + ") " + "AND msid.vol_nr = " + jsMid(sqlVol, 3, 1);
    sql = sql + ") "; //'WHERE tingimuse lõpp;
    sql = sql + "ORDER BY " + dic_desc + ".ms_att_OO";
    elm_xpath = homonyymsed;
    homonyymsed = DICPR + ":A[" + homonyymsed + "]";
    art_xpath = homonyymsed;
    //    }

    var cmdXml = "<prm>" +
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

    var cmdXmlDom = IDD("String", cmdXml, false, false, null);
    StartOperation(cmdXmlDom);

} //kustutaArtikkel


/**
* Käivitab operatsiooni, mille vastus jõuab pikka rada pidi funktsioonile ParseSrvInfo.
* 
* @method StartOperation
* @param {Object} oPrmDom
@example 
	// See on funktsioonist kustutaArtikkel:
    var cmdXml = "<prm>" +
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
	var cmdXmlDom = IDD("String", cmdXml, false, false, null);
    StartOperation(cmdXmlDom);

*/
function StartOperation(oPrmDom) {
    var cmdId = oPrmDom.documentElement.getElementsByTagName("cmd")[0].textContent;

    //esimeseks tuleb siis "app_lang", siis "dic_desc", lõppu kasutajanimi
    var nNode;
    nNode = oPrmDom.documentElement.insertBefore(oPrmDom.createElement("dic_desc"), oPrmDom.documentElement.firstChild);
    nNode.textContent = dic_desc;
    nNode = oPrmDom.documentElement.insertBefore(oPrmDom.createElement("app_lang"), oPrmDom.documentElement.firstChild);
    nNode.textContent = sAppLang;
    nNode = oPrmDom.documentElement.appendChild(oPrmDom.createElement("un"));
    nNode.textContent = sUsrName;

    sbMain.setText("");

    dhxBar.disableItem("btnSrch");

    dtOpStart = new Date();
    dhxLayout.progressOn();
    QueryResponseAsync(oPrmDom);
} //StartOperation


/**
* Käivitub, kui serverist päring tagasi tuleb. Ajax päringu abifunktsioon.
* 
* @method asyncCompleted
* @param {Object} objXMLDom
*/ 
function asyncCompleted(objXMLDom) {
    if (!objXMLDom) {
        StopOperation();
        return;
    }

    ParseSrvInfo(objXMLDom);
    StopOperation();

} //asyncCompleted


/**
* Ajax päringu abifunktsioon. Paneb progress bari kinni.
* 
* @method StopOperation
*/
function StopOperation() {
    dhxBar.enableItem("btnSrch");

    dhxLayout.progressOff();
    var interval = (new Date().getTime() - dtOpStart.getTime());
    var seconds = Math.floor(interval / 1000);
    //    window.status = window.status + "; (" + Math.floor(seconds / 60) + "m, " + (seconds % 60) + "s)";
} //StopOperation


/**
* Töötleb serveri vastuseid. Funktsiooniga StartOperation tehtud päringute vastused jõuavad siia.
* 
* @method ParseSrvInfo
* @param {Object} oRespDom XML Dom.
*/
function ParseSrvInfo(oRespDom) {
    var sta, cnt, vol, qM, vastus;

    sta = oRespDom.documentElement.getElementsByTagName("sta")[0].textContent;
    cnt = oRespDom.documentElement.getElementsByTagName("cnt")[0].textContent;
    cnt = parseInt(cnt);
    vol = oRespDom.documentElement.getElementsByTagName("vol")[0].textContent;
    qM = oRespDom.documentElement.getElementsByTagName("qM")[0].textContent;
    if (sta == "Success") {
        if (sCmdId == "ClientRead" || sCmdId == "BrowseRead" || sCmdId == "prevNextRead" || sCmdId == "msSarnased" || sCmdId == "tyhjadViited") {
            if (cnt == 0) {
                sbMain.setText("<img src='graphics/info.png' style='width:16px;'> " + sQryInfo + " - artikleid ei leitud [" + qM + "].");
            } else if (cnt == 1) {

                setButtonSelectId("volSelect", vol);
                sFromVolume = vol;

                vastus = oRespDom.documentElement.getElementsByTagNameNS(DICURI, "A")[0];
                FillArtFrames(vastus, true);
                tooEsileArtikkel();

                talaDiv.scrollIntoView(true);
                valaDiv.scrollIntoView(true);

                sbMain.setText("<img src='graphics/info.png' style='width:16px;'> " + sQryInfo + " - " + cnt + " artikkel [" + qM + "].");

            } else if (cnt > 1 || cnt == -1) {
                vastus = oRespDom.documentElement.getElementsByTagName("outDOM")[0];
                FillBrowseFrame(vastus);
                tooEsileLoend();
                sbMain.setText("<img src='graphics/info.png' style='width:16px;'> " + sQryInfo + " - " + cnt + " artiklit [" + qM + "].");
            }
        } else if (sCmdId == "ClientWrite") {
            if (cnt == 1) {

                //                setButtonSelectId("volSelect", vol);
                //                sFromVolume = vol;

                vastus = oRespDom.documentElement.getElementsByTagNameNS(DICURI, "A")[0];
                FillArtFrames(vastus, false);
                //                tooEsileArtikkel();

                //                talaDiv.scrollIntoView(true);
                //                valaDiv.scrollIntoView(true);

                sbMain.setText("<img src='graphics/info.png' style='width:16px;'> '" + sQryInfo + "' edukalt salvestatud [" + qM + "].");

            } else if (cnt > 1) {
                vastus = oRespDom.documentElement.getElementsByTagName("outDOM")[0];
                // "Homonüümsete kontroll sihtköites"
                sQryInfo = vastus.getAttribute("qinfo");
                FillBrowseFrame(vastus);
                tooEsileLoend();
                sbMain.setText("<img src='graphics/info.png' style='width:16px;'> " + sQryInfo + " - " + cnt + " artiklit [" + qM + "].");
            } else if (cnt == 0) {
                // homonüümsete kontrollil läks midagi metsa
                vastus = oRespDom.documentElement.getElementsByTagNameNS(DICURI, "A")[0];
                FillArtFrames(vastus, false);

                sbMain.setText("<img src='graphics/info.png' style='width:16px;'> '" + sQryInfo + "' edukalt salvestatud [" + qM + "] (Homonüümsete kontroll = 0!).");
            }
        } else if (sCmdId == "ClientAdd") {
            if (cnt == 1) {

                setButtonSelectId("volSelect", vol);
                sFromVolume = vol;

                vastus = oRespDom.documentElement.getElementsByTagNameNS(DICURI, "A")[0];
                FillArtFrames(vastus, true);
                tooEsileArtikkel();

                talaDiv.scrollIntoView(true);
                valaDiv.scrollIntoView(true);

                sbMain.setText("<img src='graphics/info.png' style='width:16px;'> '" + sQryInfo + "' edukalt lisatud [" + qM + "].");

            } else if (cnt > 1) {
                vastus = oRespDom.documentElement.getElementsByTagName("outDOM")[0];
                // "Homonüümsete kontroll sihtköites"
                sQryInfo = vastus.getAttribute("qinfo");
                FillBrowseFrame(vastus);
                tooEsileLoend();
                sbMain.setText("<img src='graphics/info.png' style='width:16px;'> " + sQryInfo + " - " + cnt + " artiklit [" + qM + "].");
            }
        } else if (sCmdId == "ClientDelete") {

            oClicked = null;
            oEditDOMRoot.removeChild(oEditDOMRoot.firstChild);

            vaatedRefresh(2, true, true);

            //0 peaks näitama, et ühtegi (homonüümset) ei jäänud;
            if (cnt == 0) {
                sbMain.setText("<img src='graphics/info.png' style='width:16px;'> '" + sQryInfo + "' edukalt kustutatud [" + qM + "].");
                sFromVolume = "";
            } else {
                vastus = oRespDom.documentElement.getElementsByTagName("outDOM")[0];
                // "Homonüümsete kontroll sihtköites"
                sQryInfo = vastus.getAttribute("qinfo");
                FillBrowseFrame(vastus);
                tooEsileLoend();
                sbMain.setText("<img src='graphics/info.png' style='width:16px;'> " + sQryInfo + " - " + cnt + " artiklit [" + qM + "].");
            }
        } else if (sCmdId == "srvXmlValidate") {
            if (cnt > 0) {
                vastus = oRespDom.documentElement.getElementsByTagName("outDOM")[0];
                FillBrowseFrame(vastus);
                tooEsileLoend();
            }
            sbMain.setText(sQryInfo + " - Vigaseid artikleid " + cnt + " tk [" + qM + "].");
        }
    }
    else {
        alert(getXmlString(oRespDom));
        return;
    }

    //                } else if ((sCmdId == "ClientDelete")) {
    //                    oEditDOMRoot.removeChild(oEditDOMRoot.firstChild);
    //                    //kui art puudub, on view.xsl tulemusena HTML-is ikkagi 10 BR-i ...;
    //                    oEditAll("ifrdiv").innerHTML = oEditDOM.transformNode(oXslEdit);
    //                    oViewAll("ifrviewdiv").innerHTML = oEditDOM.transformNode(oXslView);
    //                    //0 peaks näitama, et ühtegi homonüümset ei jäänud;
    //                    if ((cnt == 0)) {
    //                        ShowStatusInfo(DEL_OK + " [" + qM + "]");
    //                        sFromVolume = "";
    //                    } else {
    //                        oBrowseNode = oRespDom.documentElement.selectSingleNode("outDOM");
    //                        sQryInfo = oBrowseNode.getAttribute("qinfo");
    //                        filterBy = "";
    //                        FillBrowseFrame(oBrowseNode);
    //                        bringZIndexToFront("frame_Browse");
    //                        ShowStatusInfo(jsReplace(ART_MANY_FOUND, "[%s]", jsFormatNumber(cnt, 0, -2, -2, -2)) + " [" + qM + "]");
    //                    }
    //                } else if ((sCmdId == "ClientRestore")) {
    //                    oEditDOMRoot.removeChild(oEditDOMRoot.firstChild);
    //                    //kui art puudub, on view.xsl tulemusena HTML-is ikkagi 10 BR-i ...;
    //                    oEditAll("ifrdiv").innerHTML = oEditDOM.transformNode(oXslEdit);
    //                    oViewAll("ifrviewdiv").innerHTML = oEditDOM.transformNode(oXslView);
    //                    //1 peaks näitama, et sihtköites on 1 homonüümne;
    //                    if ((cnt == 1)) {
    //                        ShowStatusInfo(DEL_OK + " [" + qM + "]");
    //                        sFromVolume = "";
    //                    } else if ((cnt > 1)) {
    //                        oBrowseNode = oRespDom.documentElement.selectSingleNode("outDOM");
    //                        sQryInfo = oBrowseNode.getAttribute("qinfo");
    //                        filterBy = "";
    //                        FillBrowseFrame(oBrowseNode);
    //                        bringZIndexToFront("frame_Browse");
    //                        ShowStatusInfo(jsReplace(ART_MANY_FOUND, "[%s]", jsFormatNumber(cnt, 0, -2, -2, -2)) + " [" + qM + "]");
    //                    }

} //ParseSrvInfo


/**
* Sätib Vaateala elemendi taustavärvi (jätab meelde, mis oli elemendi värv enne aktiivseks tegemist ja kui element enam aktiivne pole, paneb meelde jäetud värvi tagasi). 
* 
* @method SetValaElement
*/
function SetValaElement() {
    if (valaElement) {
        valaElement.style.backgroundColor = valaElementBgc;
    }
    valaElement = valaDoc.getElementById(oClicked.id);
    if (valaElement) {
        valaElementBgc = valaElement.style.backgroundColor;
        valaElement.style.backgroundColor = seldValaElementBgc;
        valaElement.scrollIntoView();
    }
} // SetValaElement


/**
* Arvatavasti otsib põhielemente. TODO
* 
* @method getMajors
* @param {Object} yldStruNode
* @param {Object} editDomNode
*/
function getMajors(yldStruNode, editDomNode) {
    var useRequiredStr = yldStruNode.getAttribute("pr_sd:useRequired");
    if (useRequiredStr) {
        useRequiredStr = useRequiredStr.substr(1, useRequiredStr.length - 2); // semikoolonid alguses ja lõpus
        var useRequired = useRequiredStr.split(";");
        for (var ix2 = 0; ix2 < useRequired.length; ix2++) {
            var yldStruAttr = yldStruNode.attributes.getNamedItem(useRequired[ix2]);
            var uusAttr = oEditDOM.createAttributeNS(yldStruAttr.namespaceURI, useRequired[ix2]);
            getReqValue(uusAttr, yldStruAttr);
            // Returns the removed attribute node or null if no attribute was removed !!
            var oldAttr = editDomNode.attributes.setNamedItemNS(uusAttr);
        }
    }
    if (yldStruNode.getAttribute("pr_sd:ct") != 2) { // 1, 3, ''
        getReqValue(editDomNode, yldStruNode);
    }
    // XPathResult tüüpi, evaluate meetod
    var majorElements = getXmlNodes(yldStruNode, "*[@pr_sd:major = '1']");
    if (majorElements) {
        var iter = majorElements.iterateNext();
        while (iter) {
            var frDocNode = editDomNode.appendChild(oEditDOM.createElementNS(DICURI, iter.nodeName));
            getMajors(iter, frDocNode);
            iter = majorElements.iterateNext();
        }
    }
} // getMajors



/**
* Tegeleb klikkidega Toimetamisalal. Sarnane funktsioon Vaatealale on handleView.
* 
* @method handleEdit
* @param {Object} thisEvent
*/
function handleEdit(thisEvent) {

    var thisTarget = thisEvent.target ? thisEvent.target : thisEvent.srcElement;
    var oSrc = thisTarget;

    //parandamisel vaate stiilis:
    //entiteedid pannakase kaldkirjas, alakaareke mingi teise (MS Mincho) fondiga;
    //hiirega saab pihta ainult "I" - le, "B" - le või "FONT" - ile; osa spane on em teisendustest
    if (oSrc.tagName == "FONT" || oSrc.tagName == "B" || oSrc.tagName == "I") {
        oSrc = oSrc.parentElement;
    }

    var tnode, tarr;

    //xsl1 - s ei ole LI-del id-sid, SP uuel toimetamisel (17juun11) on ja vaates tehakse halliks terve vastav 'LI'
    if (oSrc.tagName == "SPAN" || oSrc.tagName == "LI") {
        oClicked = oSrc;
        if (oClicked.className == "delatt") {
            var attElement = oClicked.nextSibling;
            var attId = attElement.id;
            if (attId) {
                var attXmlNode = getXmlSingleNode(oEditDOMRoot, attId);
                if (attXmlNode) {
                    var attrOwner = attXmlNode.ownerElement;
                    attrOwner.removeAttributeNode(attXmlNode);
                    setATTAPlokid(attrOwner);
                    vaatedRefresh(2, true, true);
                    return;
                }
            }
        }
        if (trueTalaClick && oClicked.id.length > 0) {
            SetValaElement();
        }
        SetVars(thisEvent);
        if (clEditable) {
            SetEdits();
        }
    } else if (oSrc.tagName == "UL") {
        //SP, 17juun11

    } else if (oSrc.tagName == "IMG") {
        //0 - creategrupp/addgrupp/addlisad/dellisad ... kinniLahti ...;
        //1 - MIDA luua/lisada (QN);
        //2 - rajaID;
        tarr = oSrc.id.split("|");

        var frdoc, frDocRoot, yldStruNode, lisatav;
        var follNimed, refNode;

        if (tarr[0] == "creategrupp" || tarr[0] == "addgrupp" || tarr[0] == "addlisad" || tarr[0] == "dellisad" || tarr[0] == "addAttr" || tarr[0] == "delgrupp" || tarr[0] == "kinniLahti" || tarr[0] == "sndListen") {

            tnode = getXmlSingleNode(oEditDOMRoot, tarr[2]);

            if (tnode) {
                if (tarr[0] == "kinniLahti") {
                } else if (tarr[0] == "creategrupp") {
                    follNimed = getFollowingSiblings(tarr[2], tarr[1]);
                    if (follNimed != "Ei saa") {
                        if (follNimed.length > 0) {
                            refNode = getXmlSingleNode(tnode, follNimed);
                        }
                        if (yldStruDom.documentElement.getAttribute("pr_sd:ver") == "2.0") {
                            frdoc = oEditDOM.createDocumentFragment();
                            frDocRoot = frdoc.appendChild(oEditDOM.createElementNS(DICURI, tarr[1]));
                            yldStruNode = getXmlSingleNode(yldStruDom, ".//" + tarr[1]);
                            if (yldStruNode) {
                                getMajors(yldStruNode, frDocRoot);
                            }
                            lisatav = frDocRoot;
                        }
                        if (lisatav) {
                            tnode.insertBefore(lisatav, refNode);
                            AddGruppChecks(lisatav);  //@nrl, tähendusnumbrite ümberarvutused;
                            setATTAPlokid(lisatav);
                            vaatedRefresh(2, true, true);
                        }
                    }
                } else if (tarr[0] == "addgrupp") {
                    refNode = tnode.nextSibling;
                    if (yldStruDom.documentElement.getAttribute("pr_sd:ver") == "2.0") {
                        frdoc = oEditDOM.createDocumentFragment();
                        frDocRoot = frdoc.appendChild(oEditDOM.createElementNS(DICURI, tnode.nodeName));
                        yldStruNode = getXmlSingleNode(yldStruDom, ".//" + tnode.nodeName);
                        if (yldStruNode) {
                            getMajors(yldStruNode, frDocRoot);
                        }
                        lisatav = frDocRoot;
                    }
                    if (lisatav) {
                        tnode.parentNode.insertBefore(lisatav, refNode);
                        AddGruppChecks(lisatav);  //@nrl, tähendusnumbrite ümberarvutused;
                        setATTAPlokid(lisatav);
                        vaatedRefresh(2, true, true);
                    }
                } else if (tarr[0] == "addlisad") {
                    var olemas = ";";
                    var allElems = getXmlNodes(tnode, "*");
                    if (allElems) {
                        var iter = allElems.iterateNext();
                        while (iter) {
                            olemas += iter.nodeName + ";";
                            iter = allElems.iterateNext();
                        }
                        if (yldStruDom.documentElement.getAttribute("pr_sd:ver") == "2.0") {
                            yldStruNode = getXmlSingleNode(yldStruDom, ".//" + tnode.nodeName);
                            // [not(@pr_sd:ct = '2')]
                            var lisatavad = getXmlNodes(yldStruNode, "*");
                            if (lisatavad) {
                                lisatav = lisatavad.iterateNext();
                                while (lisatav) {
                                    if (olemas.indexOf(';' + lisatav.nodeName + ';') < 0) {
                                        follNimed = getFollowingSiblings(tarr[2], lisatav.nodeName);
                                        if (follNimed != "Ei saa") {
                                            refNode = null;
                                            if (follNimed.length > 0) {
                                                refNode = getXmlSingleNode(tnode, follNimed);
                                            }
                                            var uus = oEditDOM.createElementNS(DICURI, lisatav.nodeName);
                                            getMajors(lisatav, uus);
                                            var lisatud = tnode.insertBefore(uus, refNode);
                                        }
                                    }
                                    lisatav = lisatavad.iterateNext();
                                }
                                setATTAPlokid(tnode);
                                vaatedRefresh(2, true, true);
                            }
                        }
                    }
                } else if (tarr[0] == "dellisad") {
                    var maha = getXmlSingleNode(tnode, "*[normalize-space(.) = '']");
                    while (maha) {
                        maha.parentNode.removeChild(maha);
                        maha = getXmlSingleNode(tnode, "*[normalize-space(.) = '']");
                    }
                    setATTAPlokid(tnode);
                    vaatedRefresh(2, true, true);
                } else if (tarr[0] == "delgrupp") {
                    tnode.parentNode.removeChild(tnode);
                    setATTAPlokid(tnode);
                    vaatedRefresh(2, true, true);
                } else if (tarr[0] == "addAttr") {
                    if (yldStruDom.documentElement.getAttribute("pr_sd:ver") == "2.0") {
                        yldStruNode = getXmlSingleNode(yldStruDom, ".//" + tnode.nodeName);
                        var yldStruAttr = yldStruNode.attributes.getNamedItem(tarr[1]);
                        var uusAttr = oEditDOM.createAttributeNS(DICURI, tarr[1]);
                        getReqValue(uusAttr, yldStruAttr);
                        // Returns the removed attribute node or null if no attribute was removed !!
                        var oldAttr = tnode.attributes.setNamedItemNS(uusAttr);

                        var tyybiAttrNimi = "pr_sd:att_" + tarr[1].replace(":", "_") + "_tn";
                        var tyybiNimi = yldStruNode.getAttribute(tyybiAttrNimi);
                        var tyybiQName = tyybiNimi.split(":");

                        if (uusAttr.value == '' && tyybiQName[0] == "tyybid") {
                            var loend;
                            var tyybiFail = "xsd/" + dic_desc + "/" + dic_desc + "_tyybid.xsd";
                            var tyybidDom = IDD("File", tyybiFail, false, false, null);
                            if (tyybidDom.evaluate) {
                                var tyybiXPath = "xs:simpleType[@name = '" + tyybiQName[1] + "']"
                                var xpathResult = tyybidDom.evaluate(tyybiXPath, tyybidDom.documentElement, NSResolver, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
                                if (xpathResult.singleNodeValue) {
                                    var tyybiNode = xpathResult.singleNodeValue;
                                    try {
                                        var enumIterator = tyybidDom.createNodeIterator(tyybiNode, NodeFilter.SHOW_ELEMENT, ElementCheckerXS, false);

                                        loend = new Array();
                                        var loendur = -1;

                                        // get the first matching node
                                        var enumNode = enumIterator.nextNode();

                                        while (enumNode) {

                                            loendur += 1;

                                            var enumValue = enumNode.getAttribute("value");
                                            loend.push(enumValue);
                                            enumNode = enumIterator.nextNode();
                                        }
                                    }
                                    catch (e) {
                                        //        alert("Your browser does not support the createNodeIterator method!");
                                        alert(e.name + " 0x" + hex(e.number, true) + ": '" + e.description + "'.");
                                        return;
                                    }
                                }
                            }
                            if (loendur == 0) {
                                uusAttr.value = loend[0];
                            }
                        } // if (uusAttr.value == '' && tyybiQName[0] == "tyybid") {
                        setATTAPlokid(tnode);
                        vaatedRefresh(2, true, true);
                    } // if (yldStruDom.documentElement.getAttribute("pr_sd:ver") == "2.0") {
                } else if (tarr[0] == "sndListen") {
                    //                            var nX, nY;
                    //                            nX = event.clientX;
                    //                            nY = event.clientY - (div_ArtJWPlayerImage.style.pixelWidth / 2); // ico on ruudukujuline, height asemel width
                    //                    var jwpi = document.getElementById("div_ArtJWPlayerImage");
                    //                    jwpi.style.pixelLeft = 480;
                    //                    jwpi.style.pixelTop = 320;
                    //                    jwpi.style.display = "";
                    //                    var flvFile = "__sr/" + dic_desc + "/__heli/" + tnode.textContent;
                    //                        events: { onError: function (event) { sndError(event); }, onPlay: function (event) { sndStarted(event); }, onComplete: function () { sndCompleted(); } }
                    //                    var opts = {
                    //                        autostart: true,
                    //                        flashplayer: "html/jwplayer/player.swf",
                    //                        file: flvFile,
                    //                        controlbar: "none",
                    //                        icons: false,
                    //                        wmode: "transparent",
                    //                        width: 0,
                    //                        height: 0
                    //                    };
                    //                    jwplayer("div_ArtJWPlayer").setup(opts);
                }
            } // if (tnode) {
        }
    } else if (oSrc.tagName == "A") {
        window.open(oSrc.href, oSrc.target);
        thisEvent.preventDefault();
    }
} //handleEdit


/**
*  Tühi funktsioon. Vaata kommentaari.
* 
* @method sndError
* @param {Object} evnt
*/
function sndError(evnt) {
    //    var jwpi = document.getElementById("div_ArtJWPlayerImage");
    //    jwpi.style.display = "none";
    //    alert(evnt.message);
}


/**
*  Tühi funktsioon. Vaata kommentaari.
* 
* @method sndStarted
* @param {Object} evnt
*/
function sndStarted(evnt) {
    //    var jwpi = document.getElementById("div_ArtJWPlayerImage");
    //    jwpi.style.display = "";
    //    alert('started:\n' + evnt.oldstate);
}


/**
*  Tühi funktsioon. Vaata kommentaari.
* 
* @method sndCompleted
*/
function sndCompleted() {
    //    var jwpi = document.getElementById("div_ArtJWPlayerImage");
    //    jwpi.style.display = "none";
}


/**
*  Tegeleb klikkidega Vaatealal. Sarnane funktsioon Toimetamisalale on 
* 
* @method handleView
* @param {Object} thisEvent
*/
function handleView(thisEvent) {

    if (valaElement) {
        valaElement.style.backgroundColor = valaElementBgc;
    }

    var thisTarget = thisEvent.target ? thisEvent.target : thisEvent.srcElement;
    var oSrc = thisTarget;

    //entiteedid pannakase kaldkirjas, alakaareke mingi teise (MS Mincho) fondiga;
    //hiirega saab pihta ainult "I" - le, "B" - le või "FONT" - ile; osa spane on em teisendustest
    if (oSrc.tagName == "FONT" || oSrc.tagName == "B" || oSrc.tagName == "I" || oSrc.tagName == "U") {
        oSrc = oSrc.parentElement;
    }

    var elId, thisElement;
    if (oSrc.tagName == "A") {
        elId = oSrc.parentElement.id; //SPAN id, nt "f:A[1]/f:P[1]/f:mvt[1]/text()[1]";
        thisEvent.preventDefault();
        return; // generaatoris ei kasutata <A>
    } else {
        elId = oSrc.id; //SPAN id, nt "f:A[1]/f:P[1]/f:mvt[1]/text()[1]";
    }
    //HTML:li
    if (elId.substr(0, 5) == "HTML:") {
        elId = elId.substr(elId.indexOf("/") + 1);
    }

    if (elId.length > 0) {
        thisElement = getXmlSingleNode(oEditDOMRoot, elId);
    }

    if (!thisElement) { // nt pildid vaates on ilma ID-ta
        if (oSrc.tagName != "IMG")
            return;
    }

    var msTekst = "";
    var tNoded, iter;
    if (thisElement) { //nt "divFrameView" ei ole
        if (thisElement.nodeType == Node.TEXT_NODE) {
            // XPathResult tüüpi, evaluate meetod
            tNoded = getXmlNodes(thisElement.parentNode, "text()");
            if (tNoded) {
                iter = tNoded.iterateNext();
                while (iter) {
                    msTekst += getXmlString(iter);
                    iter = tNoded.iterateNext();
                }
            }
            thisElement = thisElement.parentNode;
        } else if (thisElement.nodeType == Node.ATTRIBUTE_NODE) { // ÕS 2006 mvt/@kuhu
            msTekst = thisElement.textContent;
            thisElement = thisElement.ownerElement;
        }
    }

    if (oSrc.tagName == "SPAN" && oSrc.className.indexOf(" lingike") > -1) {

        //        if (salvestaJaKatkesta()) {
        //            return;
        //        }

        // kui aga klõpsamisel on vaja hoopis näidata pilti (its: iref/@dst)
        var href, fullHREF;
        href = thisElement.getAttribute(DICPR + ":dst");
        if (href) {
            fullHREF = asuKoht + '__sr/' + dic_desc + '/__pildid/' + href;
            window.open(fullHREF, '_blank');
            return;
        }
        // its: stn/@href
        href = thisElement.getAttribute(DICPR + ":href");
        if (href) {
            window.open(href, '_blank');
            return;
        }


        // nt har viidatakse artiklis 'performance' märksõnale 'happening', mis on tsitaatsõna (liik='z')
        // teistes aga vsl: 'pentaad' -> 'pent-'

        var qM = "MySql";
        if (thisEvent.ctrlKey) {
            qM = "XML";
        }

        sQryInfo = jsTrim(msTekst);

        var kfAttr, gAttr;
        kfAttr = thisElement.getAttribute(DICPR + ":KF"); // # "ief1" jne
        if (!kfAttr) {
            kfAttr = thisElement.getAttribute(DICPR + ":aKF");
        }
        gAttr = thisElement.getAttribute(DICPR + ":g");
        if (!gAttr) {
            gAttr = thisElement.getAttribute(DICPR + ":aG");
        }

        var elpred, arttingimus, art_xpath, elm_xpath, evPath, pQrySql;
        var withCase, withSymbols;
        var cmdXml, cmdXmlDom;

        //combo valikust saadud andmed ...;
        if (kfAttr && gAttr) {
            sCmdId = "BrowseRead";

            cmdXml = "<prm>" +
                             "<cmd>" + sCmdId + "</cmd>" +
                             "<vol>" + kfAttr + "</vol>" +
                             "<nfo>" + sQryInfo + "</nfo>" +
                             "<G>" + gAttr + "</G>" +
                             "<qM>" + qM + "</qM>" +
                         "</prm>";

            cmdXmlDom = IDD("String", cmdXml, false, false, null);
            StartOperation(cmdXmlDom);

        } else {

            var currentVolId = dhxBar.getListOptionSelected("volSelect");

            //            var i, vahemik;
            //            //vajalik köide paika!;
            //            //(vali "Kõik köited");
            //            //(sel_Vol.selectedIndex = sel_Vol.options.length - 2);
            //            if (dic_vols_count > 1) {
            //                var oConfigDOM, vollid, otsad;
            //                oConfigDOM = IDD("File", "shsconfig_" + dic_desc + ".xml", false, false, null);
            //                if (oConfigDOM.parseError.errorCode != 0) {
            //                    ShowXMLParseError(oConfigDOM);
            //                    return;
            //                }
            //                vollid = oConfigDOM.documentElement.selectNodes("vols/vol");
            //                for (i = 0; i < vollid.length; i++) {
            //                    vahemik = vollid[i].text;
            //                    // PSV teine köide 'AB' artiklid: <vol nr="2">AB: A - Y</vol>
            //                    if (vahemik.indexOf(":") > -1) {
            //                        vahemik = jsTrim(vahemik.substr(vahemik.indexOf(":") + 1));
            //                    }
            //                    otsad = vahemik.split(" - ");
            //                    if (((jsStrComp(jsLeft(RemoveSymbols(msTekst, " "), otsad[0].length), otsad[0], 1) >= 0) && (jsStrComp(jsLeft(RemoveSymbols(msTekst, " "), otsad[1].length), otsad[1], 1) <= 0))) {
            //                        sel_Vol.selectedIndex = i;
            //                        break;
            //                    }
            //                }
            //                oConfigDOM = null;
            //            }

            var vHomTing, homNrNode, mySqlMsAttCond;
            vHomTing = "";
            mySqlMsAttCond = "";
            //<mvt>  -viide märksõnale; <lvt> - SP-s viide pereliikmele;
            homNrNode = thisElement.getAttribute(DICPR + ":iv");
            if (!homNrNode) {
                homNrNode = getXmlSingleNode(thisElement, DICPR + ":vhom");
                if (homNrNode)
                    homNrNode = homNrNode.textContent;
            }
            if (!homNrNode) {
                //sõnaperedes ja SS1-s <mvt> küljes;
                homNrNode = thisElement.getAttribute(DICPR + ":i");
            }
            if (homNrNode) {
                vHomTing = "[@" + DICPR + ":i = '" + homNrNode + "']";
            }

            var qn, otsitav = msTekst;
            if (thisElement.localName == "lvt") { // sp_ viide pereliikmele
                qn = DICPR + ":ml";
                if (vHomTing.length > 0) {
                    //lähtutud SP pereliikmete @i, temale viidatakse <lvt> abil;
                    mySqlMsAttCond = " AND atribuudid_" + dic_desc + ".nimi = '" + DICPR + ":i'" + " AND atribuudid_" + dic_desc + ".val = '" + homNrNode + "'" + " AND atribuudid_" + dic_desc + ".elG = elemendid_" + dic_desc + ".elG";
                }
            } else if (thisElement.baseName == "mstvt") { // its viide mõistele
                qn = DICPR + ":Gmst";
                otsitav = thisElement.getAttribute(DICPR + ":Gmst");
            } else {
                qn = qn_ms;
                if (vHomTing.length > 0) {
                    mySqlMsAttCond = " AND msid.ms_att_i = " + homNrNode;
                }
            }

            if (!otsitav)
                return;

            //tuleb märkidega ja tõstutundlik otsing (Liivi-saksas tõstutundetu);
            var srchPtrn = getSrPn2(otsitav, "XML")

            withSymbols = "1";
            withCase = "1";
            elpred = "[. = " + GCV(otsitav, "", 2) + "]";
            if (dic_desc == "ldw") {
                withCase = "0";
                elpred = "[al_p:srch(.) > 0]";
            }

            arttingimus = ".//" + qn + vHomTing + elpred;
            art_xpath = default_query.substr(0, default_query.indexOf("/")) + "[" + arttingimus + "]";
            elm_xpath = arttingimus;
            evPath = ".//" + qn + vHomTing + "/text()";

            pQrySql = getSqlQuery(qn, otsitav, true, withSymbols, withCase, evPath, "", mySqlMsAttCond);

            sCmdId = "ClientRead";

            cmdXml = "<prm>" +
                                        "<cmd>" + sCmdId + "</cmd>" +
                                        "<vol>" + currentVolId + "</vol>" +
                                        "<nfo>" + sQryInfo + "</nfo>" +
                                        "<axp>" + art_xpath + "</axp>" +
                                        "<exp>" + elm_xpath + "</exp>" +
                                        "<wC>" + withCase + "</wC>" +
                                        "<wS>" + withSymbols + "</wS>" +
                                        "<fSrP>" + srchPtrn + "</fSrP>" +
                                        "<qn>" + qn + "</qn>" +
                                        "<qM>" + qM + "</qM>" +
                                        "<pQrySql>" + pQrySql + "</pQrySql>" +
                                     "</prm>";

            cmdXmlDom = IDD("String", cmdXml, false, false, null);
            StartOperation(cmdXmlDom);
        }

    } else if (oSrc.tagName == "SPAN") {
        if (elId.length > 0) {
            valaElement = oSrc;

            valaElementBgc = valaElement.style.backgroundColor;
            valaElement.style.backgroundColor = seldValaElementBgc;

            talaElement = talaDoc.getElementById(elId);
            if (talaElement) {
                talaElement.scrollIntoView();
                talaElement.focus();
                trueTalaClick = false;
                talaElement.click();
                trueTalaClick = true;
            }
        }
    } else if (oSrc.tagName == "IMG") {
        if (oSrc.id == "exit_copy") {
        }
        else {
            window.open(oSrc.src, '_blank');
        }
    }

} //handleView


/**
*  Arvatavasti tegeleb klikkidega Vaatealal.
* 
* @method handleView
* @param {Object} thisEvent
*/
function handleContext(event) {
    //    if (event.target.tagName == "DIV") {
    //        if (event.target.getAttribute("title") == "MySQL | XML" || event.target.parentElement.getAttribute("title") == "MySQL | XML") {
    //            otsing("XML");
    //        }
    //    }
    event.preventDefault();
} // handleContext



/**
*  Brauseri akna suuruse muutmise korral kaasajastab komponentide suuruse.
* 
* @method bodyOnResize
*/
function bodyOnResize() {
    dhxLayout.setSizes();
    dhxAccord.setSizes();
    artLayout.setSizes();
} // bodyOnResize


/**
*  Seadistab Toimetamisala (taustavärv, tala.css, font, ...). (TODO kus seda kutsutakse?)
* 
* @method setTala
*/
function setTala() {
    if (!talaDoc) {
        var ifr = artLayout.cells("a").getFrame();
        var ifrDoc;
        if (_isIE) {
            ifrDoc = ifr.contentWindow.document;
        } else {
            ifrDoc = ifr.contentDocument;
        }
        ifrDoc.body.style.backgroundColor = bgColor;
        talaDiv = ifrDoc.getElementById("talaDiv");

        if (editFont) {
            talaDiv.style.fontFamily = editFont;
        }
        if (editFontSize) {
            talaDiv.style.fontSize = editFontSize + 'pt';
        }

        talaCss = ifrDoc.getElementById("talaCss");
        var d = new Date();
        // The getTime method returns an integer value representing the number of milliseconds between midnight, 
        // January 1, 1970 and the time value in the Date object
        var t = Math.floor(d.getTime() / 1000);
        talaCss.setAttribute("href", "css/gendEdit_" + dic_desc + ".css?p=" + t);

        talaDoc = ifrDoc;
    }
} // setTala


/**
*  Seadistab Vaateala (taustavärv, vala.css, font, ...). (TODO kus seda kutsutakse?)
* 
* @method setVala
*/
function setVala() {
    if (!valaDoc) {
        var ifr = artLayout.cells("b").getFrame();
        var ifrDoc;
        if (_isIE) {
            ifrDoc = ifr.contentWindow.document;
        } else {
            ifrDoc = ifr.contentDocument;
        }
        ifrDoc.body.style.backgroundColor = bgColor;
        valaDiv = ifrDoc.getElementById("valaDiv");

        if (viewFont) {
            valaDiv.style.fontFamily = viewFont;
        }
        if (viewFontSize) {
            valaDiv.style.fontSize = viewFontSize + 'pt';
        }

        valaCss = ifrDoc.getElementById("valaCss");
        var d = new Date();
        // The getTime method returns an integer value representing the number of milliseconds between midnight, 
        // January 1, 1970 and the time value in the Date object
        var t = Math.floor(d.getTime() / 1000);
        valaCss.setAttribute("href", "css/gendView_" + dic_desc + ".css?p=" + t);

        valaDoc = ifrDoc;
    }
} // setVala


/**
*  Teeb XML prefiksist nimeruumi URI.
* 
* @method NSResolver
* @param {String} nsPrefix
*/
function NSResolver(nsPrefix) {
    if (nsPrefix == DICPR) {
        return DICURI;
    } else if (nsPrefix == SDPR) {
        return SDURI;
    } else if (nsPrefix == NS_XS_PR) {
        return NS_XS;
    } else if (nsPrefix == "xml") {
        return NS_XML;
    } else if (nsPrefix == NS_XSL_PR) {
        return NS_XSL;
    }
    return null;
}


/**
*  Toimetamisala abifunktsioon toimetamisel andmete salvestasmiseks. Peaks tulema blurri korral. Kutsutakse välja funktsioonis handleEdit.
* 
* @method SetVars
* @param {Object} currEvent
*/
function SetVars(currEvent) {

    scv = oClicked.textContent;

    elemlang = oClicked.lang;

    nodePath = oClicked.id;
    if (nodePath.substr(0, 5) == "HTML:") {
        nodePath = nodePath.substr(nodePath.indexOf("/") + 1);
    }

    document.getElementById("spnNodeXPath").innerHTML = nodePath;

    var tarr = oClicked.className.split(" ");
    //"ehitatud" elementidel on struktuur, tühja koha klikkamine ei tohi pahandusi tekitada
    //className peab alati koosnema vähemalt 3-st
    if (tarr.length > 2) {
        clType = tarr[0].substr(0, 2);  //et, en, at jt;
    } else {
        clType = "";
        clEditable = false;
        clickedNode = null;
        selectedNode = null
        fatherNode = null;
        snQName = "";
        return;
    }


    //clickedNode mõte on eristada #text erinevaid tükke elementide sees

    //väärtuse klikkamisel on:
    //elemendi teksti korral on clickedNode-iks #text ning selectedNode-ks element ise
    //atribuudi teksti korral on nii clickedNode-iks kui ka selectedNode-ks atribuut ise
    //kommentaari teksti korral on clickedNode-iks #comment ning selectedNode-ks element, milles kommentaar paikneb

    //nime klikkamisel on:
    //nii elemendi kui ka atribuudi (praegu - 20mai 2006 - pole) nime korral on clickedNode-ks ja selectedNode-ks
    //element või atribuut ise

    //fatherNode on:
    //elemendi korral elemendi parentElement
    //atribuudi korral element, millele atribuut kuulub

    var xmlLangNode;
    if (nodePath != "") { //'nt ec ("element create") korral = ""

        if (oEditDOM.evaluate) {
            var xpathResult = oEditDOM.evaluate(nodePath, oEditDOMRoot, NSResolver, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
            // while (param = params.iterateNext())
            if (xpathResult.singleNodeValue) {
                clickedNode = xpathResult.singleNodeValue;
                if (clickedNode.nodeType == Node.TEXT_NODE) {
                    selectedNode = clickedNode.parentNode;
                    fatherNode = selectedNode.parentNode;
                    xmlLangNode = selectedNode;
                } else if (clickedNode.nodeType == Node.ATTRIBUTE_NODE) {
                    selectedNode = clickedNode;
                    fatherNode = selectedNode.ownerElement;
                    xmlLangNode = fatherNode;
                } else if (clickedNode.nodeType == Node.ELEMENT_NODE) {
                    selectedNode = clickedNode;
                    fatherNode = selectedNode.parentNode;
                    xmlLangNode = selectedNode;
                }
                //                if (!elemlang) {
                //                    while (xmlLangNode) {
                //                        elemlang = xmlLangNode.getAttribute("xml:lang");
                //                        if (elemlang) {
                //                            break;
                //                        }
                //                        xmlLangNode = xmlLangNode.parentNode;
                //                    }
                //                }
                snQName = selectedNode.nodeName;
            }
        }

        //        //viga juhul, kui clickedNode on null, nt ANY sees mitte ettenähtud element ??;
        //        clickedNode = oEditDOMRoot.selectSingleNode(nodePath);
        //        if ((clickedNode.nodeType == NODE_TEXT || clickedNode.nodeType == NODE_COMMENT || clickedNode.nodeType == NODE_CDATA_SECTION)) {
        //            selectedNode = clickedNode.parentNode;
        //        } else {
        //            selectedNode = clickedNode;
        //        }
        //        fatherNode = selectedNode.selectSingleNode(".."); //'atribuudil ei ole parentNode-t

        //        try {
        //            //viga juhul, kui elementi skeemis pole ...;
        //            snDecl = oXmlSc.getDeclaration(selectedNode);
        //            if (!(snDecl.namespaceURI == "")) {
        //                sPr = oXmlNsm.getPrefixes(snDecl.namespaceURI).item(0);
        //                if ((sPr == "")) {
        //                    snQName = snDecl.name;
        //                } else {
        //                    snQName = sPr + ":" + snDecl.name;
        //                }
        //            } else {
        //                snQName = snDecl.name;
        //            }
        //            if ((snDecl.itemType == SOMITEM_ELEMENT)) {
        //                xsdPath = ".//" + NS_XS_PR + ":element[@name='" + snDecl.name + "']/" + NS_XS_PR + ":annotation/" + NS_XS_PR + ":documentation[@xml:lang='" + sAppLang + "']";
        //            } else if ((snDecl.itemType == SOMITEM_ATTRIBUTE)) {
        //                xsdPath = ".//" + NS_XS_PR + ":attribute[@name='" + snDecl.name + "']/" + NS_XS_PR + ":annotation/" + NS_XS_PR + ":documentation[@xml:lang='" + sAppLang + "']";
        //            }
        //            xsdNode = oXsdDOM.documentElement.selectSingleNode(xsdPath);
        //            if (!(xsdNode == null)) {
        //                cmHeading = jsReplace(jsTrim(xsdNode.text), ";", "");
        //            } else {
        //                cmHeading = snQName;
        //            }
        //        }
        //        catch (e) {
        //            snDecl = null;
        //            snQName = clickedNode.nodeName;
        //            cmHeading = snQName;
        //        }

        //        snKirjeldavQName = cmHeading + " (";
        //        if ((snDecl.itemType == SOMITEM_ATTRIBUTE)) {
        //            snKirjeldavQName = snKirjeldavQName + "@";
        //        }
        //        snKirjeldavQName = snKirjeldavQName + snQName + ")"

        //        try {
        //            //juhul, kui elementi skeemis pole ...;
        //            pnDecl = oXmlSc.getDeclaration(fatherNode);
        //        }
        //        catch (e) {
        //            pnDecl = null;
        //        }

        //        if ((clType == "en" || clType == "an")) {
        //            cmHeading = "'" + cmHeading + "'";
        //        } else if ((clType == "et" || clType == "ct")) {
        //            cmHeading = "'" + cmHeading + "' " + jsMid(nodePath, nodePath.lastIndexOf("/") + 1);
        //        } else if ((clType == "at")) {
        //            cmHeading = "'@" + cmHeading + "' " + VALUE_WORD;
        //        }
        //        spn_NodeInfo.title = "[" + oClicked.tagName + ": " + snKirjeldavQName + "]: lang: '" + elemlang + "'; className: '" + oClicked.className + "'; nodeType: " + clickedNode.nodeType + " (" + clickedNode.nodeTypeString + ")"

    } else { //nt ec ("element create") korral = "";
        clickedNode = null;
        selectedNode = null
        fatherNode = null;
        snQName = "";
        return;
    }

    var elemNoEditOtsitav, attrNoEditOtsitav;
    if (neElems.indexOf("/") > -1) {
        elemNoEditOtsitav = fatherNode.nodeName + "/" + selectedNode.nodeName;
    } else {
        elemNoEditOtsitav = selectedNode.nodeName;
    }
    if (neAttribs.indexOf("/") > -1) {
        attrNoEditOtsitav = fatherNode.nodeName + "/@" + selectedNode.nodeName;
    } else {
        attrNoEditOtsitav = selectedNode.nodeName;
    }
    clEditable = false;
    if (clickedNode) {
        if (clickedNode.nodeType == Node.TEXT_NODE || clickedNode.nodeType == Node.ATTRIBUTE_NODE) {
            if (tarr[2] == "edit") {
                clEditable = true;
            }
            if (clickedNode.nodeType == Node.TEXT_NODE) {
                if (neElems.indexOf(";" + elemNoEditOtsitav + ";") > -1) {
                    clEditable = false;
                }
            } else if (clickedNode.nodeType == Node.ATTRIBUTE_NODE) {
                if (neAttribs.indexOf(";" + attrNoEditOtsitav + ";") > -1) {
                    clEditable = false;
                }
            }
            if (currEvent.ctrlKey && eeLexAdmin.indexOf(";" + sUsrName + ";") > -1) {
                clEditable = true;
            }
        }
    }

} //SetVars




/**
* Toimetamisala abifunktsioon. Teeb toimetamiseks kasti. Kutsutakse välja funktsioonis handleEdit. TODO
* 
* @method SetEdits
*/
function SetEdits() {
    var cee = oClicked;

    oClickedBorder = oClicked.style.border;
    oClicked.style.border = "red 2px solid";

    //mT - meedia tüüp
    var mT = '';

    if (selectedNode.nodeType == Node.ELEMENT_NODE) {
        if (snQName != "x:link") { // its::<link> elemendil on küll @mT, kuid parandada tuleb @href ennast
            mT = selectedNode.getAttribute(DICPR + ":mT"); //'Pärtel Lippus - foneetika terminite sõnastik, pildifail;
            if (!mT) {
                mT = "";
            }
        }
    } else if (selectedNode.nodeType == Node.ATTRIBUTE_NODE) { // 'its' link/@href
        //        if (selectedNode.baseName == 'href') {
        //            mT = fatherNode.getAttribute(DICPR + ":mT");
        //        }
    }

    if (mT == "") {
        if (snQName == "n:aa") { //'Eesti kohanimeraamat: kirjandus; teos: autor aasta;
            mT = "pikkLoend";
        } else if (snQName == "x:stn") { // its: standard
            mT = "pikkLoend";
        } else if (snQName == "c:vbf") { //'põhisõnavara sõnastik; viipe fail;
            mT = "flashPlayer";
        } else if (snQName == "x:pilt") { //'its pilt <pilt>
            mT = "flashPlayerImage";
        } else if (snQName == "x:dst") { //'its: link pildile iref/@dst
            mT = "flashPlayerImage";
        }
    } else {
        if (mT == "img") { //'pilt;
            mT = "flashPlayerImage";
        } else if (mT == "f?v") {
            mT = "flashPlayer";
        } else if (mT == "snd") {
            mT = "flashPlayerSound";
        }
    }

    if (!trueTalaClick) {
        if (mT) {
            oClicked.style.border = oClickedBorder
            return;
        }
    }


    var yldStruNode, yldStruNodePath, tyybiNimi, xpathResult;
    yldStruNodePath = nodePath.replace(/(\[\d+\])/g, "");
    if (yldStruNodePath.substr(yldStruNodePath.lastIndexOf("/")) == "/text()") {
        // yldStru - st saame leida elemente ja atribuute
        yldStruNodePath = yldStruNodePath.substr(0, yldStruNodePath.lastIndexOf("/"));
    }
    if (yldStruDom.evaluate) {
        xpathResult = yldStruDom.evaluate(yldStruNodePath, yldStruDom.documentElement, NSResolver, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
        if (xpathResult.singleNodeValue) {
            yldStruNode = xpathResult.singleNodeValue;
            if (yldStruNode.nodeType == Node.ELEMENT_NODE) {
                var it = yldStruNode.getAttribute("pr_sd:it");
                if (it == SOMITEM_SIMPLETYPE) { // 8704
                    tyybiNimi = yldStruNode.getAttribute("pr_sd:tn");
                } else if (it == SOMITEM_COMPLEXTYPE) { // 9216
                    var ct = yldStruNode.getAttribute("pr_sd:ct");
                    if (ct == SCHEMACONTENTTYPE_TEXTONLY) { // 1
                        tyybiNimi = yldStruNode.getAttribute("pr_sd:tn");
                    } else if (ct == SCHEMACONTENTTYPE_MIXED) { // 3
                        tyybiNimi = "xs:string";
                    }
                } else { // kõik, mis eraldi tüübiga, on ka märgitud tüübinimega (xs:string nt)
                    tyybiNimi = yldStruNode.getAttribute("pr_sd:tn");
                }
            }
            else if (yldStruNode.nodeType == Node.ATTRIBUTE_NODE) {
                var tyybiAttrNimi = "pr_sd:att_" + yldStruNode.nodeName.replace(":", "_") + "_tn";
                tyybiNimi = yldStruNode.ownerElement.getAttribute(tyybiAttrNimi);
            }
        }
    }

    if (tyybiNimi) {

        var smdArgs, retVal;
        var opts = "";
        var seldInd = -1;

        var tyybiQName = tyybiNimi.split(":");

        var tyybiFail = "xsd/" + dic_desc + "/" + dic_desc + "_tyybid.xsd";

        if (mT == "pikkLoend" && tyybiQName[0] == "tyybid") {
            smdArgs = new Array(dic_desc, tyybiFail, tyybiQName[1], scv, sAppLang);
            retVal = window.showModalDialog("html/listingLoend.htm", smdArgs, "dialogHeight:300px;dialogWidth:1024px;center:yes;edge:sunken;help:no;resizable:yes;scroll:yes;status:no;unadorned:no");
            oClicked.style.border = oClickedBorder;
            if (retVal) {
                if (retVal != scv) {
                    clickedNode.textContent = retVal;
                    oClicked.innerHTML = retVal;
                    updMuudatused("S", retVal);
                    ValueChecks(retVal, scv) //märksõna, hom.nr, kom;
                    vaatedRefresh(1, true, true);
                }
            }
            return;
        } else if (mT == "flashPlayer") {
            smdArgs = new Array(dic_desc, sAppLang, sUsrName, scv, "/__video/");
            retVal = window.showModalDialog("html/showVideo.htm", smdArgs, "dialogHeight:600px;dialogWidth:800px;center:yes;edge:sunken;help:no;resizable:yes;scroll:yes;status:no;unadorned:no");
            oClicked.style.border = oClickedBorder;
            if (retVal) {
                if (retVal != scv) {
                    clickedNode.textContent = retVal;
                    oClicked.innerHTML = retVal;
                    updMuudatused("S", retVal);
                    vaatedRefresh(1, true, true);
                }
            }
            return;
        } else if (mT == "flashPlayerImage") {
            smdArgs = new Array(dic_desc, sAppLang, sUsrName, scv, "/__pildid/");
            retVal = window.showModalDialog("html/showVideo.htm", smdArgs, "dialogHeight:600px;dialogWidth:800px;center:yes;edge:sunken;help:no;resizable:yes;scroll:yes;status:no;unadorned:no");
            oClicked.style.border = oClickedBorder;
            if (retVal) {
                if (retVal != scv) {
                    clickedNode.textContent = retVal;
                    oClicked.innerHTML = retVal;
                    updMuudatused("S", retVal);
                    vaatedRefresh(1, true, true);
                }
            }
            return;
        } else if (mT == "flashPlayerSound") {
            smdArgs = new Array(dic_desc, sAppLang, sUsrName, scv, "/__heli/");
            retVal = window.showModalDialog("html/showVideo.htm", smdArgs, "dialogHeight:600px;dialogWidth:800px;center:yes;edge:sunken;help:no;resizable:yes;scroll:yes;status:no;unadorned:no");
            oClicked.style.border = oClickedBorder;
            if (retVal) {
                if (retVal != scv) {
                    clickedNode.textContent = retVal;
                    oClicked.innerHTML = retVal;
                    updMuudatused("S", retVal);
                    vaatedRefresh(1, true, true);
                }
            }
            return;
        }

        if (tyybiQName[0] == "tyybid") {
            var tyybidDom = IDD("File", tyybiFail, false, false, null);
            if (tyybidDom.evaluate) {
                var tyybiXPath = "xs:simpleType[@name = '" + tyybiQName[1] + "']"
                xpathResult = tyybidDom.evaluate(tyybiXPath, tyybidDom.documentElement, NSResolver, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
                if (xpathResult.singleNodeValue) {
                    var tyybiNode = xpathResult.singleNodeValue;
                    try {
                        var enumIterator = tyybidDom.createNodeIterator(tyybiNode, NodeFilter.SHOW_ELEMENT, ElementCheckerXS, false);

                        var loendur = -1;

                        // get the first matching node
                        var enumNode = enumIterator.nextNode();

                        while (enumNode) {

                            var optTitle;
                            var optKirjeldav, optVasteKirjeldav;

                            loendur += 1;

                            var enumValue = enumNode.getAttribute("value");
                            optTitle = enumValue;
                            var annotNode = enumNode.getElementsByTagNameNS(NS_XS, "annotation")[0];
                            var docnNodes = annotNode.getElementsByTagNameNS(NS_XS, "documentation");
                            for (var ix = 0; ix < docnNodes.length; ix++) {
                                if (docnNodes[ix].getAttribute("xml:lang") == sAppLang) {
                                    optKirjeldav = jsTrim(docnNodes[ix].textContent);
                                    if (!dest_language) {
                                        break;
                                    }
                                    else {
                                        continue;
                                    }
                                }
                                if (dest_language) {
                                    if (docnNodes[ix].getAttribute("xml:lang") == dest_language) {
                                        optVasteKirjeldav = jsTrim(docnNodes[ix].textContent);
                                    }
                                }
                            }

                            if (optKirjeldav) {
                                optTitle += " - " + optKirjeldav;
                                if (optVasteKirjeldav) {
                                    optTitle += " / " + optVasteKirjeldav;
                                }
                            }

                            opts += "<option id='" + enumValue + "'>" + optTitle + "</option>";
                            if (enumValue == scv) {
                                seldInd = loendur + 1; //sest ette tuleb veel tühi;
                            }

                            enumNode = enumIterator.nextNode();
                        }
                        oClicked.innerHTML = "<select id='oClickedSelect' tabIndex='0'>" + "<option id=''></option>" + opts + "</select>";
                        cee = oClicked.firstChild;
                        if (seldInd > -1) {
                            cee.options[seldInd].selected = true;
                        }
                    }
                    catch (e) {
                        //        alert("Your browser does not support the createNodeIterator method!");
                        alert(e.name + " 0x" + hex(e.number, true) + ": '" + e.description + "'.");
                    }
                }
            }
        } else if (tyybiQName[0] == "xs") {
            if (tyybiNimi == "xs:language") {
                opts = getKeeledOptString(scv);
                oClicked.innerHTML = "<select id='oClickedSelect' tabIndex='0'>" + "<option id=''></option>" + opts + "</select>";
                cee = oClicked.firstChild;
            } else if (tyybiNimi == "xs:boolean") {
                opts += "<option id='false'>ei  - false</option>";
                opts += "<option id='true'>jah - true</option>";
                if (scv == "false") {
                    seldInd = 1; //sest ette tuleb veel tühi;
                } else if (scv == "true") {
                    seldInd = 2; //sest ette tuleb veel tühi;
                }
                oClicked.innerHTML = "<select id='oClickedSelect' tabIndex='0'>" + "<option id=''></option>" + opts + "</select>";
                cee = oClicked.firstChild;
                if (seldInd > -1) {
                    cee.options[seldInd].selected = true;
                }
            } else if (tyybiNimi == "xs:decimal") {
                oClicked.innerHTML = "<input id='oClickedTextArea' tyybiNimi='xs:decimal' type='text' style='width:95%;' tabIndex='0'></input>";
                cee = oClicked.firstChild;
                cee.value = scv;
            } else if (tyybiNimi == "xs:positiveInteger") {
                oClicked.innerHTML = "<input id='oClickedTextArea' tyybiNimi='xs:positiveInteger' type='text' style='width:95%;' tabIndex='0'></input>";
                cee = oClicked.firstChild;
                cee.value = scv;
            } else if (tyybiNimi == "xs:dateTime") {
                oClicked.innerHTML = "<input id='oClickedTextArea' tyybiNimi='xs:dateTime' type='text' style='width:95%;' tabIndex='0'></input>";
                cee = oClicked.firstChild;
                cee.value = scv;
            } else { // ka xs:string ning veel midagi?
                var parWidth = oClicked.parentElement.offsetWidth;
                var taStyle = "width:" + (parWidth - 10) + "px;";
                oClicked.innerHTML = "<textarea id='oClickedTextArea' tyybiNimi='" + tyybiNimi + "' style='" + taStyle + "' rows='1' tabIndex='0'></textarea>";
                cee = oClicked.firstChild;
                cee.value = scv;

                if (scv == "-???-" || scv == "|???|" || scv == "|vaste|" || scv == "|tõlge|") {
                    cee.select();
                }
            }
        }
    } else { // tyybiNimi
        oClicked.style.border = oClickedBorder;
        return;
    }

    if (cee.tagName == "INPUT" || cee.tagName == "TEXTAREA") {
        cee.addEventListener("keyup", txtInpOnKeyUp, true);
    }
    cee.addEventListener("blur", HandleCeeBlur, true);

    cee.focus();

} //SetEdits

/**
* Enteri puhul blurrib toimetamise kastikese.
* 
* @method txtInpOnKeyUp
* @param {Object} event
*/
function txtInpOnKeyUp(event) {
    var keyCode = ('which' in event) ? event.which : event.keyCode;
    var target = event.target ? event.target : event.srcElement;
    if (keyCode == 13) {
        target.blur();
    }
} // txtInpOnKeyUp

/**
* Uuendab keelte valikut, kui on olemas xmllang_tyyp; muidu loetakse failist iso639_1.xml.
* 
* @method updKeelteValik
* @param {String} schLocation
*/
function updKeelteValik(schLocation) {
    var keelteDom = IDD("File", "xsd/" + schLocation, false, false, null);

    var xpathResult, enumIterator, enumNode, loendur, ix, appLangKeel;

    if (keelteDom.evaluate) {
        var tyybiXPath = "xs:simpleType[@name = 'xmllang_tyyp']"
        xpathResult = keelteDom.evaluate(tyybiXPath, keelteDom.documentElement, NSResolver, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
        if (xpathResult.singleNodeValue) {
            keelteValik = new Array();
            var tyybiNode = xpathResult.singleNodeValue;
            try {
                enumIterator = keelteDom.createNodeIterator(tyybiNode, NodeFilter.SHOW_ELEMENT, ElementCheckerXS, false);

                loendur = -1;

                // get the first matching node
                enumNode = enumIterator.nextNode();

                while (enumNode) {

                    loendur += 1;

                    var enumValue = enumNode.getAttribute("value");
                    var annotNode = enumNode.getElementsByTagNameNS(NS_XS, "annotation")[0];
                    var docnNodes = annotNode.getElementsByTagNameNS(NS_XS, "documentation");
                    appLangKeel = '';
                    for (ix = 0; ix < docnNodes.length; ix++) {
                        if (docnNodes[ix].getAttribute("xml:lang") == sAppLang) {
                            appLangKeel = jsTrim(docnNodes[ix].textContent);
                            break;
                        }
                    }

                    keelteValik.push(enumValue + PD + appLangKeel);

                    enumNode = enumIterator.nextNode();
                }
            }
            catch (e) {
                //        alert("Your browser does not support the createNodeIterator method!");
                alert(e.name + " 0x" + hex(e.number, true) + ": '" + e.description + "'.");
            }
        } else {
            if (keelteValik.length == 0) {
                keelteDom = IDD("File", "iso639_1.xml", false, false, null);
                try {
                    enumIterator = keelteDom.createNodeIterator(keelteDom.documentElement, NodeFilter.SHOW_ELEMENT, ElementCheckerXS, false);

                    loendur = -1;

                    // get the first matching node
                    enumNode = enumIterator.nextNode();

                    while (enumNode) {

                        loendur += 1;

                        var enKeel = '', nativeKeel;
                        appLangKeel = '';
                        var nameNodes = enumNode.getElementsByTagName("name");
                        for (ix = 0; ix < nameNodes.length; ix++) {
                            var xmlLangAttr = nameNodes[ix].getAttribute("xml:lang");
                            if (xmlLangAttr) {
                                if (xmlLangAttr == sAppLang) {
                                    appLangKeel = jsTrim(nameNodes[ix].textContent);
                                }
                            } else {
                                enKeel = jsTrim(nameNodes[ix].textContent);
                            }
                        }
                        nameNodes = enumNode.getElementsByTagName("native")[0];
                        if (nameNodes) {
                            nativeKeel = nameNodes.textContent;
                        }
                        else {
                            nativeKeel = enKeel;
                        }
                        if (appLangKeel) {
                            appLangKeel = ' = ' + appLangKeel;
                        }

                        keelteValik.push(enumNode.getAttribute("code") + PD + nativeKeel + ' (' + enKeel + appLangKeel + ')');

                        enumNode = enumIterator.nextNode();
                    }
                }
                catch (e) {
                    //        alert("Your browser does not support the createNodeIterator method!");
                    alert(e.name + " 0x" + hex(e.number, true) + ": '" + e.description + "'.");
                }
            }
        }
    }
} // updKeelteValik


/**
* Koostatakse HTML optionite loend Toimetamisalale keele valikuks.
* 
* @method getKeeledOptString
* @param {String} kVal Keele kood.
* @returns {String} Optionsite loend <option> jne.
*/
function getKeeledOptString(kVal) {
    var opts = '';
    for (var i = 0; i < keelteValik.length; i++) {
        var keel = keelteValik[i].split(PD);
        opts += "<option id='" + keel[0] + "'";
        if (keel[0] == kVal) {
            opts += " selected";
        }
        opts += ">" + keel[0] + " - " + keel[1] + "</option>";
    }
    return opts;
} // getKeeledOptString


/**
* Kutsutakse toimetamiskastikese blurri korral. 
* 
* @method HandleCeeBlur
* @param {Object} event 
*/
function HandleCeeBlur(event) {
    var nsv;  //new span value

    var oBlur = event.target ? event.target : event.srcElement;

    var checkSta = false, kontrollida = true;

    if (oBlur.tagName == "SELECT") {
        if (oBlur.selectedIndex > -1) {
            nsv = jsTrim(oBlur.options[oBlur.selectedIndex].id);
        }
        else {
            nsv = scv;  //vana väärtus tagasi;
        }
        if (nsv) { // üldse ei luba tühja teksti
            checkSta = true;
        }
        kontrollida = false;
    } else if (oBlur.tagName == "TEXTAREA" || oBlur.tagName == "INPUT") {
        nsv = jsTrim(oBlur.value);
        if (nsv != scv || nsv == '') {
            var tyybiNimi = oBlur.getAttribute("tyybiNimi");
            var rex;
            switch (tyybiNimi) {
                case "xs:decimal":
                    rex = /^\d+[,\.]\d+$/;
                    if (nsv.match(rex)) {
                        nsv = nsv.replace(",", ".");
                        checkSta = true;
                    }
                    break;
                case "xs:positiveInteger":
                    rex = /^\d+$/;
                    if (nsv.match(rex)) {
                        checkSta = true;
                    }
                    break;
                case "xs:dateTime":
                    rex = /^\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}$/;
                    if (nsv.match(rex)) {
                        checkSta = true;
                    }
                    break;
                case "xs:string":
                    //                    if (doSpellCheck) {
                    //                    }
                    if (nsv) { // üldse ei luba tühja teksti
                        checkSta = true;
                    }
                    break;
                default:
                    if (nsv) { // üldse ei luba tühja teksti
                        checkSta = true;
                    }
                    break;
            }
        }
        else {
            checkSta = true; // tekst olemas ja sama mis enne
        }
    }
    if (!checkSta) {
        oBlur.focus();
        oBlur.select();
        return;
    }

    if (oBlur.tagName == "INPUT" || oBlur.tagName == "TEXTAREA") {
        oBlur.removeEventListener("keyup", txtInpOnKeyUp, true);
    }
    oBlur.removeEventListener("blur", HandleCeeBlur, true);
    oClicked.style.border = oClickedBorder;

    oClicked.innerHTML = scv;

    if (nsv != scv) {

        if (kontrollida) {
            nsv = tekstiTeisendused(nsv);
        }

        clickedNode.textContent = nsv;
        oClicked.innerHTML = nsv;

        updMuudatused("S", nsv);

        ValueChecks(nsv, scv);  //märksõna, hom.nr, kom;

        vaatedRefresh(2, true, true);
    }

    oClicked.focus();

} //HandleCeeBlur


/**
* Teisendab Date objekti stringiks. 
* 
* @method GetXSDDateTime
* @param {Object} dNow 
* @returns {String} Kuupäev EELexis kasutataval kujul.
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
* TODO Kui toimetamisalale tuleb liiga pikk tekst, siis algusosa on nähtav ja ülejäänu ei ole nähtav (30. tähemärgist edasi). 
* 
* @method updMuudatused
* @param {String} op S, K, U, R
* @param {String} tekst Töödeldav tekst
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
        artMuudatused += "|" + muudetav + " = '" + n2idatav + "'";
    } else if (op == "K") {
        //siin on miinusmärk, mitte sidekriips, ära uisa-päisa kustuta! :);
        artMuudatused += "|" + muudetav + "['" + n2idatav + "'] − ";
    } else if (op == "U" || op == "R") {
        artMuudatused += "|" + n2idatav;
    }
} //updMuudatused


/**
* TODO
* 
* @method FillArtFrames
* @param {Object} oArtNode XML node
* @param {String} delURHistory
*/
function FillArtFrames(oArtNode, delURHistory) {

    //    //lisatakse tühjad tekstinoodid "" elementidele, millel pole alamelemente ega teksti
    //    AddEmptyTexts(oArtNode);

    //    var avatavad, avatav, kinniLahtid, kinniLahti, edOAttr, avatud;

    //    //xml võrdlemiseks muudatuste kindlakstegemisel, 'oArtNode' algab <A>
    //    oOrgArtNode = oArtNode.cloneNode(true);
    //    avatavad = oOrgArtNode.selectNodes(".//*/@" + DICPR + ":edO");
    //    avatavad.removeAll();

    //    if ((delURHistory)) {
    //        urfragment = oEditDOM.createDocumentFragment();
    //        urindex = -1;
    //        urlast = urindex;

    //        if (!(yldStruDom == null)) {
    //            //Sõnapered: "maa" ja "töö": üle 30000 märgi;
    //            if ((oArtNode.xml.length > 10240)) {
    //                avatud = "0";
    //            } else {
    //                avatud = "1";
    //            }
    //            edOAttr = oArtNode.ownerDocument.createNode(NODE_ATTRIBUTE, DICPR + ":edO", DICURI);
    //            avatavad = yldStruDom.documentElement.selectNodes(".//*[@" + DICPR + ":edO]");
    //            for (i = 0; i < avatavad.length; i++) {
    //                avatav = avatavad[i];
    //                kinniLahtid = oArtNode.selectNodes(".//" + avatav.nodeName);
    //                for (j = 0; j < kinniLahtid.length; j++) {
    //                    kinniLahti = kinniLahtid[j];
    //                    //see siga ei tööta prefiksiga ..., vähemasti järgneva XSLt teisenduse jaoks;
    //                    //neid on küll, nt @O salvestamisel;
    //                    //ilmselt salvestamisel ikkagi käheb kõik korda ...;
    //                    //kinniLahti.setAttribute(DICPR + ":edO", "0");
    //                    edOAttr.value = avatud;
    //                    kinniLahti.attributes.setNamedItem(edOAttr.cloneNode(true));
    //                }
    //            }
    //        }
    //    }


    if (oEditDOMRoot.hasChildNodes()) {
        oEditDOMRoot.replaceChild(oArtNode, oEditDOMRoot.firstChild);
    } else {
        oEditDOMRoot.appendChild(oArtNode);
    }


    if (delURHistory) {
        urArray = new Array();
        urIndex = -1;
    } else { // ainult ClientWrite
        urArray = urArray.slice(0, urIndex + 1);
    }
    artMuudatused = "";
    artOrgString = getXmlString(oEditDOM);
    urIndex = urArray.push(artOrgString) - 1;

    var oM1Node = null;
    if (oEditDOM.evaluate) {
        var xpathResult = oEditDOM.evaluate(first_default, oEditDOMRoot, NSResolver, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
        // while (param = params.iterateNext())
        if (xpathResult.singleNodeValue) {
            oM1Node = xpathResult.singleNodeValue;
            if (oM1Node.nodeType == Node.ELEMENT_NODE) {
                sOrgMarkSona = oM1Node.textContent;
            }
            sOrgHomnr = oM1Node.getAttribute(qn_homnr);
        }
    }

    var ptElem, pt = '', tElem, t = '', tlElem, tlTekst = '', klElem, kElem, k = '';
    ptElem = oEditDOMRoot.firstChild.getElementsByTagNameNS(DICURI, "PT")[0];
    if (ptElem) {
        pt = ptElem.textContent;
    }
    tElem = oEditDOMRoot.firstChild.getElementsByTagNameNS(DICURI, "T")[0];
    if (tElem) {
        t = tElem.textContent;
    }
    tlElem = oEditDOMRoot.firstChild.getElementsByTagNameNS(DICURI, "TL")[0];
    if (tlElem) {
        tlTekst = tlElem.textContent;
        if (dic_desc != 'psv') {
            if (t.length > 0) {
                tlTekst = t + ", " + tlTekst;
            }
        }
    }
    klElem = oEditDOMRoot.firstChild.getElementsByTagNameNS(DICURI, "KL")[0];
    if (klElem) {
        kElem = oEditDOMRoot.firstChild.getElementsByTagNameNS(DICURI, "K")[0];
        k = kElem.textContent;
    }

    var msgSisu;
    if (k) {
        msgSisu = "<img src='graphics/Info.ico'><span style='color:green;'> " + String("Artiklile on lisatud koostamise lõpu märge '[%s]' poolt.").replace("[%s]", k) + "</span>";
    }
    if (tlTekst) {
        msgSisu = "<img src='graphics/Info.ico'><span style='color:blue;'> Artiklile on lisatud toimetamise lõpu märge: '" + tlTekst + "'.</span>";
    }
    if (pt) {
        msgSisu = "<img src='graphics/Info.ico'><span style='color:red;'> " + String("Artiklile on lisatud peatoimetaja märge '[%s]' poolt.").replace("[%s]", pt) + "</span>";
    }

    if (msgSisu) {
        sbMain.setText(msgSisu);
    }

    //    bArtSaveAllowed = false;
    //    bArtDelAllowed = false;

    //    if ((pt != "")) {
    //        if (sUsrName == pt && bArtSignAllowed) { //bArtSignAllowed: srtegija ja ptd hulgas;
    //            bArtSaveAllowed = true;
    //            bArtDelAllowed = true;
    //        }
    //    } else {
    //        // 09. sept 11: toimetajad saavad üle kirjutada artikleid, millele on märgitud juurde toimetamise lõpp
    //        // nt PSV: Liivi Hollman lisab juurde videod Jelena lõpuni toimetatud artiklitele
    //        if ((srTegija)) {
    //            if (dic_desc == "psv") {
    //                bArtSaveAllowed = true;
    //                bArtDelAllowed = true;
    //            }
    //            else {
    //                if (tlTekst != '') {
    //                    if (sUsrName == t) {
    //                        bArtSaveAllowed = true;
    //                        bArtDelAllowed = true;
    //                    }
    //                }
    //                else {
    //                    bArtSaveAllowed = true;
    //                    bArtDelAllowed = true;
    //                }
    //            }
    //        }
    //    }

    //    div_ArtToolsMenu.innerHTML = "";
    //    if (srTegija) {
    //        if (!(document.all("img_ArtTools") == null)) {
    //            lisa_KL_TL_PT();
    //            lisaVeelArtToolse();
    //            if (!(div_ArtToolsMenu.innerHTML == "")) {
    //                bArtToolsEnabled = true;
    //            } else {
    //                bArtToolsEnabled = false;
    //            }
    //        }
    //        if ((zeus.indexOf(";" + sUsrName + ";") > -1)) {
    //            bArtSaveAllowed = true;
    //            bArtDelAllowed = true;
    //        }
    //    }

    //    //'16. juuni 2011
    //    //var tyhi
    //    //set tyhi = oEditDOMRoot.selectSingleNode(".//text()[. = '']")
    //    //if(! (tyhi == null)){
    //    //    'kui see on kunagi lisatud tähelepanu juthimiseks, siis olgu juba
    //    //    tyhi.text = "???----------------------------------------------------------------------???"
    //    //}

    //    oClicked = null;

    var artMsTekstElement = document.getElementById("artMsTekst");
    if (artMsTekstElement) {
        artMsTekstElement.textContent = "'" + sOrgMarkSona + "'";
    }

    vaatedRefresh(2, true, true);

    //    if (!(document.all("img_artHistory") == null)) {
    //        var tblAjalugu, rida, veerg, artGuid;
    //        tblAjalugu = div_ArtHistoryMenu.all("tbl_ArtHistoryMenu");
    //        if ((tblAjalugu.rows.length == 100)) {
    //            tblAjalugu.deleteRow(tblAjalugu.rows.length - 1);
    //        }
    //        rida = tblAjalugu.insertRow(0);
    //        rida.className = "mi";
    //        artGuid = oEditDOMRoot.selectSingleNode(DICPR + ":A/" + qn_guid).text;
    //        rida.id = artGuid;
    //        rida.setAttribute("v", sFromVolume); //'"ief1" jne;
    //        veerg = rida.insertCell();
    //        veerg.style.width = "50%";
    //        veerg.innerHTML = sOrgMarkSona;
    //        veerg = rida.insertCell();
    //        veerg.innerHTML = new Date();
    //    }

} //FillArtFrames



/**
* Uuendab Toimetamisala ja Vaateala.
* 
* @method vaatedRefresh
* @param {String} nr Eristab, kas on "UndoRedo" või mitte.
* @param {Boolean} uuendaTala 
* @param {Boolean} uuendaVala
*/
function vaatedRefresh(nr, uuendaTala, uuendaVala) {

    var oclid, newFragment;

    if (uuendaTala) {
        if (oClicked) {
            oclid = oClicked.id;
        }
        newFragment = talaXslProse.transformToFragment(oEditDOM, document);
        talaDiv.innerHTML = "";
        // kui XSL-iga peaks mingi jama olema ...
        if (newFragment) {
            talaDiv.appendChild(newFragment);
            if (oclid) {
                oClicked = talaDoc.getElementById(oclid);
            }
        }
    }

    if (uuendaVala) {
        newFragment = valaXslProse.transformToFragment(oEditDOM, document);
        valaDiv.innerHTML = "";
        if (newFragment) {
            valaDiv.appendChild(newFragment);
        }
    }

    var artMsMuudetudElement = document.getElementById("artMsMuudetud");
    if (artOrgString) {
        var jooksevArtStr = getXmlString(oEditDOM);
        if (jooksevArtStr == artOrgString) {
            artMsMuudetudElement.textContent = "";
            // võib ju olla alles sisestatud artikkel oma tühjade kastidega
            //            dhxTalaBar.disableItem("btnSave");
        }
        else {
            artMsMuudetudElement.textContent = "*";
            //            dhxTalaBar.enableItem("btnSave");
        }

        if (jooksevArtStr != urArray[urIndex]) {
            // vist ei ole võimalik igasugu NS-de pärast stringe ikka täpselt võrrelda
            if (nr != "UndoRedo") {
                urArray = urArray.slice(0, urIndex + 1);
                urIndex = urArray.push(jooksevArtStr) - 1;
            }
        }

        var currBuffNrElement = document.getElementById("currBuffNr");
        currBuffNrElement.textContent = urIndex + 1;
        var buffCountElement = document.getElementById("buffCount");
        buffCountElement.textContent = urArray.length;

        if (urIndex <= 0) {
            dhxTalaBar.disableItem("btnUndo");
        } else {
            dhxTalaBar.enableItem("btnUndo");
        }
        if (urIndex >= urArray.length - 1) {
            dhxTalaBar.disableItem("btnRedo");
        } else {
            dhxTalaBar.enableItem("btnRedo");
        }

    }
} //vaatedRefresh


/**
* TODO
* 
* @method ElementChecker
* @param {Object} node
* @returns {String} A või ...
*/
function ElementChecker(node) {
    if (node.nodeName == 'A') {
        return NodeFilter.FILTER_ACCEPT;
    }
    return NodeFilter.FILTER_SKIP;
} // ElementChecker


/**
* TODO
* 
* @method ElementCheckerXS
* @param {Object} node
* @returns {String} xs:enumeration, record või ...
*/
function ElementCheckerXS(node) {
    if (node.nodeName == 'xs:enumeration') {
        return NodeFilter.FILTER_ACCEPT;
    }
    if (node.nodeName == 'record') {
        return NodeFilter.FILTER_ACCEPT;
    }
    return NodeFilter.FILTER_SKIP;
} // ElementCheckerXS


/**
* Lõhub stringi ;-ga juppideks ja kirjutab tükid optionideks.
* 
* @method getLoadXmlString
* @param {String} s
* @returns {String} HTML optionid.
*/
function getLoadXmlString(s) {
    var arr = s.split(";");
    var opts = "<complete>";
    for (var ix = 0; ix < arr.length; ix++) {
        if (arr[ix]) { // alguses ja lõpus ;
            opts += "<option value='" + arr[ix] + "'>" + arr[ix] + "</option>";
        }
    }
    opts += "</complete>";
    return opts;
} // getLoadXmlString


/**
* TODO Koostab otsingutulemuste tabeli.
* 
* @method FillBrowseFrame
* @param {Object} outDOMNode
*/
function FillBrowseFrame(outDOMNode) {

    brGrid.clearAll(); // deletes all rows in the grid (kui argumendiks on veel 'true', siis koos päisega)

    // outDOMNode: <outDOM>, atribuudid @qinfo, @leide
    // firstChild: <sr>, neid võib mitu olla
    var artiklid = getXmlNodesSnapshot(outDOMNode, "sr/A"), artikleid = 0, ix, artikkel;
    if ('snapshotLength' in artiklid) {
        artikleid = artiklid.snapshotLength;
    } else if ('length' in artiklid) {
        artikleid = artiklid.length;
    }

    var toimetajad = ";";
    var koostajad = ";";
    var peaToimetajad = ";";

    var rowsXml = "<rows>";
    for (ix = 0; ix < artikleid; ix++) {
        if ('snapshotLength' in artiklid) {
            artikkel = artiklid.snapshotItem(ix);
        } else if ('length' in artiklid) {
            artikkel = artiklid[ix];
        }
        var volFile = getXmlSingleNodeValue(artikkel, "vf");
        var volNr = volFile.substr(3, 1);
        var G = getXmlSingleNodeValue(artikkel, "G");
        var mdTekst = getXmlSingleNodeValue(artikkel, "md/t");
        mdTekst = "<![CDATA[<span style='text-decoration:underline;color:blue;cursor:pointer;'>" + entitiesToHtml(mdTekst) + "</span>]]>";
        var lTekst = getXmlSingleNodeValue(artikkel, "l");
        //            var ut = getXmlString(ANode.getElementsByTagName("l")[0].getElementsByTagName("t")[0]);
        //            ut = "<![CDATA[" + ut + "]]>";
        var KTekst = getXmlSingleNodeValue(artikkel, "K");
        if (koostajad.indexOf(";" + KTekst + ";") < 0) {
            koostajad += KTekst + ";";
        }
        var KLTekst = getXmlSingleNodeValue(artikkel, "KL");
        var TTekst = getXmlSingleNodeValue(artikkel, "T");
        if (toimetajad.indexOf(";" + TTekst + ";") < 0) {
            toimetajad += TTekst + ";";
        }
        var TATekst = getXmlSingleNodeValue(artikkel, "TA");
        var TLTekst = getXmlSingleNodeValue(artikkel, "TL");
        var PTTekst = getXmlSingleNodeValue(artikkel, "PT");
        if (peaToimetajad.indexOf(";" + PTTekst + ";") < 0) {
            peaToimetajad += PTTekst + ";";
        }
        var kirjeNr = ix + 1;

        rowsXml += "<row id='" + kirjeNr + "'>";
        rowsXml += "<userdata name='artKeys'>" + volFile + ";" + G + "</userdata>";
        rowsXml += "<cell>" + kirjeNr + "</cell>";
        rowsXml += "<cell>" + romanize(volNr) + "</cell>";
        rowsXml += "<cell>" + mdTekst + "</cell>";
        rowsXml += "<cell>" + lTekst + "</cell>";
        rowsXml += "<cell>" + KTekst + "</cell>";
        rowsXml += "<cell>" + KLTekst + "</cell>";
        rowsXml += "<cell>" + TTekst + "</cell>";
        rowsXml += "<cell>" + TATekst + "</cell>";
        rowsXml += "<cell>" + TLTekst + "</cell>";
        rowsXml += "<cell>" + PTTekst + "</cell>";
        rowsXml += "</row>";
    }
    rowsXml += "</rows>";
    brGrid.parse(rowsXml);

    var cmb = brGrid.getFilterElement(4);
    cmb.loadXMLString(getLoadXmlString(koostajad));
    cmb = brGrid.getFilterElement(6);
    cmb.loadXMLString(getLoadXmlString(toimetajad));
    cmb = brGrid.getFilterElement(9);
    cmb.loadXMLString(getLoadXmlString(peaToimetajad));

} //FillBrowseFrame


/**
* Otsingutulemuste nimekirjas millelegi peale klikates käivitub.
* 
* @method gridOnRowSelect
* @param {String} rowId
* @param {String} colInd
*/
function gridOnRowSelect(rowId, colInd) {
    if (colInd == 2) { // märksõna veerg
        doBrowseRead(qryMethod, rowId, colInd);
    }
} // gridOnRowSelect


/**
* Teeb XML päringu. Otsingutulemuste nimekirjas millelegi peale klikates käivitub.
* 
* @method gridOnRightClick
* @param {String} rowId
* @param {String} colInd
* @param {String} evntObj
*/
function gridOnRightClick(rowId, colInd, evntObj) {
    if (colInd == 2) { // märksõna veerg
        doBrowseRead("XML", rowId, colInd);
    }
} // gridOnRightClick

/**
* Teeb BrowseRead päringu. Otsingutulemuste nimekirjas millelegi peale klikates käivitub.
* 
* @method doBrowseRead
* @param {String} qM Query Method
* @param {String} rowId
* @param {String} colInd
*/
function doBrowseRead(qM, rowId, colInd) {
    sQryInfo = brGrid.cells(rowId, colInd).getValue();
    var userdata = brGrid.getUserData(rowId, "artKeys");
    var udData = userdata.split(";");
    sCmdId = "BrowseRead";
    var cmdXml = "<prm>" +
            "<cmd>" + sCmdId + "</cmd>" +
            "<vol>" + udData[0] + "</vol>" +
            "<nfo>" + sQryInfo + "</nfo>" +
            "<G>" + udData[1] + "</G>" +
            "<qM>" + qM + "</qM>" +
        "</prm>";

    var cmdXmlDom = IDD("String", cmdXml, false, false, null);
    StartOperation(cmdXmlDom);
} // doBrowseRead


/**
* 
* 
* @method setButtonSelectId
* @param {Object} buttonSelectId 
* @param {Object} listOptId
*/
function setButtonSelectId(buttonSelectId, listOptId) {
    dhxBar.setListOptionSelected(buttonSelectId, listOptId);
    var seldTekst = dhxBar.getListOptionText(buttonSelectId, listOptId);
    dhxBar.setItemText(buttonSelectId, seldTekst);
} // setButtonSelectId

