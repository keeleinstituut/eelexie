// JavaScript Document
// -----------------------------------------------------------------------------------
//  Prg. pakett        : EELex
//  Funktsioonide teek : ats_app.js
//  Kelle oma          : Ain Teesalu
//  Viimane muudatus   : 19.12.2012
// -----------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------

// -----------------------------------------------------------------------------------
// kataloogi nimi, kus asuvad htm ja js-id (dialoog aknad)
// -----------------------------------------------------------------------------------
var atsPrgCatal = "html";
// -----------------------------------------------------------------------------------

var progressEnd = 9; // set to number of progress <span>'s.
var progressColor = 'blue'; // set to progress bar color
var progressInterval = 1000; // set to time between updates (milli-seconds)

var progressAt = progressEnd;
var progressTimer;

function atsTestClick1()
{
  var sParms, smdArgs, psTrue = false, showDlg = true;
  smdArgs = new Array("Test1", "T2", "T3");
  // var zzRet = atsOnViit("tvt");
  // alert(zzRet);
  // atsTest();
  if (showDlg)
  {
    sParms = window.showModalDialog("html1/atsViewart.htm", smdArgs, "dialogHeight:300px;dialogWidth:400px;center:yes;edge:sunken;help:no;resizable:yes;scroll:yes;status:no;unadorned:no");
    if (! sParms)
    {
      return;
    }
    // inp_ElemText.value = sParms
    alert(sParms);
  }
  // -------------------------------------------------------------------------------
  if (salvestaJaKatkesta())
  {
    return;
  }
}
// atsTestClick
// -----------------------------------------------------------------------------------
function atsTestClick()
{
  var sParms, smdArgs, psTrue = false, showDlg = true;
  smdArgs = new Array("Test1", "T2", "T3");
  // var zzRet = atsOnViit("tvt");
  // alert(zzRet);
  // atsTest();
  if (showDlg)
  {
    sParms = window.showModalDialog("html/atsViewart.htm", smdArgs, "dialogHeight:300px;dialogWidth:400px;center:yes;edge:sunken;help:no;resizable:yes;scroll:yes;status:no;unadorned:no");
    if (! sParms)
    {
      return;
    }
    // inp_ElemText.value = sParms
    alert(sParms);
  }
  // -------------------------------------------------------------------------------
  if (salvestaJaKatkesta())
  {
    return;
  }
  var oPrmDom, qryMethod;
  // qryMethod = "MySql";
  qryMethod = "XML";
  if (window.event.srcElement.id == "inp_RunQueryXML")
  {
    qryMethod = "XML";
  }
  // Kahe param. GetQueryParams (ats)
  oPrmDom = atsGetQueryParams(qryMethod, sParms);
  if (! oPrmDom)
  {
    return;
  }
  sCmdId = "ClientRead";
  oPrmDom.documentElement.selectSingleNode("cmd").text = sCmdId;
  // "${DIC_DESC}2", "${DIC_DESC}All"
  if ((oPrmDom.documentElement.selectSingleNode("vol").text == ""))
  {
    // id = '${DIC_DESC}${volNr}';
    oPrmDom.documentElement.selectSingleNode("vol").text = sel_Vol.options(sel_Vol.selectedIndex).id;
  }
  // alert(oPrmDom.documentElement.text);
  StartOperation(oPrmDom)
}
// atsTestClick
// -----------------------------------------------------------------------------------
function atsRunQuery(sParms)
{
  var smdArgs, psTrue = false, showDlg = true, zzShow = false;
  // var zzRet = atsOnViit("tvt");
  // alert(zzRet);
  // at atsTest();
  if (! sParms)
  {
    return;
  }
  // at alert("atsRunQuery(sParms)-> " + sParms);
  // -------------------------------------------------------------------------------
  // if (salvestaJaKatkesta()) {
  //    return;
  // }
  var oPrmDom, qryMethod;
  // qryMethod = "MySql";
  qryMethod = "MySql";
  if (window.event.srcElement.id == "inp_RunQueryXML")
  {
    qryMethod = "XML";
  }

//alert(qryMethod);

  // Kahe param. GetQueryParams (ats)
  oPrmDom = atsGetQueryParams(qryMethod, sParms);
  if (! oPrmDom)
  {
    return;
  }
  sCmdId = "ClientRead";
  oPrmDom.documentElement.selectSingleNode("cmd").text = sCmdId;
  // "${DIC_DESC}2", "${DIC_DESC}All"
  //oPrmDom.documentElement.selectSingleNode("vol").text = dic_desc + "All";

  sel_Vol.options(sel_Vol.selectedIndex).id = dic_desc + "All";
  if ((oPrmDom.documentElement.selectSingleNode("vol").text == ""))
  {
    // id = '${DIC_DESC}${volNr}';

    //alert(dic_desc + "All");
    // vaadatakse läbi kõik Vol-id olenemata menüüs vol-i valikust
    oPrmDom.documentElement.selectSingleNode("vol").text = sel_Vol.options(sel_Vol.selectedIndex).id;
    //oPrmDom.documentElement.selectSingleNode("vol").text = dic_desc + "All";

  }
  // alert(oPrmDom.documentElement.text);
  atsStartOperation(oPrmDom);
  return zzShow;
}
// atsTestClick
// -----------------------------------------------------------------------------------
function atsStartOperation(oPrmDom)
{
  var cmdId;
  cmdId = oPrmDom.documentElement.selectSingleNode("cmd").text
  var axpNode, art_xpath
  axpNode = oPrmDom.documentElement.selectSingleNode("axp");
  if (! (axpNode == null))
  {
    art_xpath = axpNode.text;
    if (! (art_xpath == ""))
    {
      if (! (CheckXPath(art_xpath)))
      {
        return;
      }
    }
  }
  // esimeseks tuleb siis "app_lang", siis "dic_desc"
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
  if (! (document.body.all("inp_RunQueryXML") == null))
  {
    inp_RunQueryXML.disabled = true;
  }
  // 07. juuni 2011
  img_ArtAdd.style.visibility = "hidden";
  img_ArtExport.style.visibility = "hidden";
  // 'Word väljatrükk;
  if (! (document.body.all("img_SrTools") == null))
  {
    img_SrTools.style.visibility = "hidden";
  }
  if (! (document.body.all("img_readFirst") == null))
  {
    img_readFirst.style.visibility = "hidden";
  }
  if (! (document.body.all("img_readPrev") == null))
  {
    img_readPrev.style.visibility = "hidden";
  }
  if (! (document.body.all("img_readNext") == null))
  {
    img_readNext.style.visibility = "hidden";
  }
  if (! (document.body.all("img_readLast") == null))
  {
    img_readLast.style.visibility = "hidden";
  }
  if (! (document.body.all("img_artHistory") == null))
  {
    img_artHistory.style.visibility = "hidden";
  }
  if (! (document.body.all("img_artLink") == null))
  {
    img_artLink.style.visibility = "hidden";
  }
  img_ArtSave.style.visibility = "hidden";
  img_ArtDelete.style.visibility = "hidden";
  // 07. juuni 2011 - lõpp
  dtOpStart = new Date();
  statusAnim.style.visibility = "visible";
  atsQueryResponseAsync(oPrmDom);
}
// atsStartOperation
// -----------------------------------------------------------------------------------
function atsQueryResponseAsync(oPrmDom)
{
  xmlHTTPAsync = getXmlHttpObject();
  xmlHTTPAsync.onreadystatechange = atsDoHttpReadyStateChange;
  xmlHTTPAsync.open("POST", "srvfuncs.cgi", true);
  xmlHTTPAsync.setRequestHeader("Content-Type", "text/xml; charset='utf-8';");
  // cmd, vol, nfo, axp, exp[, q : A]
  xmlHTTPAsync.send(oPrmDom.xml);
}
// QueryResponseAsync
// -----------------------------------------------------------------------------------
function atsDoHttpReadyStateChange()
{
  if (xmlHTTPAsync.readyState == XMLHTTP_COMPLETED)
  {
    var oSrvRspDOM, rspNode, domsta;
    if (xmlHTTPAsync.statusText == "OK")
    {
      // sta, cnt, vol[, q : A | q : sr]
      oSrvRspDOM = IDD("", "", false, false, null);
      domsta = oSrvRspDOM.loadXML(xmlHTTPAsync.responseText);
      // responseXML : TypeName = DomDocument
      if (! domsta)
      {
        var pe = oSrvRspDOM.parseError;
        if (pe.errorCode != 0)
        {
          ShowXMLParseError(oSrvRspDOM);
        }
        oSrvRspDOM = IDD("String", "<rsp/>", false, false, null);
        rspNode = oSrvRspDOM.documentElement.appendChild(oSrvRspDOM.createNode(NODE_ELEMENT, "appSta", ""));
        rspNode.text = "AppFailure";
      }
      else
      {
        rspNode = oSrvRspDOM.documentElement.appendChild(oSrvRspDOM.createNode(NODE_ELEMENT, "appSta", ""));
        rspNode.text = "AppSuccess";
      }
    }
    else
      oSrvRspDOM = IDD("String", "<rsp/>", false, false, null);
    rspNode = oSrvRspDOM.documentElement.appendChild(oSrvRspDOM.createNode(NODE_ELEMENT, "statusText", ""));
    rspNode.text = xmlHTTPAsync.statusText;
    rspNode = oSrvRspDOM.documentElement.appendChild(oSrvRspDOM.createNode(NODE_ELEMENT, "status", ""));
    rspNode.text = xmlHTTPAsync.status;
    var nRTLen = 512;
    rspNode = oSrvRspDOM.documentElement.appendChild(oSrvRspDOM.createNode(NODE_ELEMENT, "responseText", ""));
    if (xmlHTTPAsync.responseText.length > nRTLen)
      rspNode.text = xmlHTTPAsync.responseText.substr(0, nRTLen) + " ...";
    else
      rspNode.text = xmlHTTPAsync.responseText;
    oSrvRspDOM.setProperty("SelectionLanguage", "XPath");
    oSrvRspDOM.setProperty("SelectionNamespaces", sXmlNsList);
    atsAsyncCompleted(oSrvRspDOM);
  }
}
// atsDoHttpReadyStateChange
// -----------------------------------------------------------------------------------
function atsAsyncCompleted(objXMLDom)
{
  // at ParseSrvInfo(objXMLDom);
  atsParseMyInfo(objXMLDom);
  StopOperation();
}
// atsAsyncCompleted
// -----------------------------------------------------------------------------------
function atsTestClickX()
{
  var ccDefQr = atsDefQuery(dic_desc);
  var ccDicpr = atsDicpr(dic_desc);
  alert(ccDicpr + ":" + ccDefQr);
}
// atsTestClickX
// -----------------------------------------------------------------------------------
function atsTestClick111()
{
  var sParms, smdArgs, psTrue = false, showDlg = true;
  smdArgs = new Array("Test1", "T2", "T3");
  if (showDlg)
  {
    sParms = window.showModalDialog("html/ats/ats_otsing.htm", smdArgs, "dialogHeight:300px;dialogWidth:400px;center:yes;edge:sunken;help:no;resizable:yes;scroll:yes;status:no;unadorned:no");
    if (! sParms)
    {
      return;
    }
    inp_ElemText.value = sParms
    // alert(sParms);
  }
  // -------------------------------------------------------------------------------
  if (salvestaJaKatkesta())
  {
    return;
  }
  atsSearchOne(sParms)
}
// atsTestClick111
// -----------------------------------------------------------------------------------
function atsGetQueryParams(qryMethod, inpText)
{
  var withCase, withSymbols;
  var ft, fa;
  withSymbols = 0;
  //if (inp_UseSymbols.checked)
  if (CheckForSymbols(inpText, "*? "))
  {
    withSymbols = 1;
  }
  else
  {
    if (inp_UseFakult.checked)
    {
      withSymbols = - 1;
    }
  }
  withCase = 1;
  if (inp_UseCase.checked)
  {
    withCase = 0;
  }
  if (withSymbols < 1)
  {
    ft = jsTrim(inpText);
    fa = jsTrim(inpText);
  }
  else
  {
    ft = inpText;
    fa = inpText;
  }
  // Otsitav element (atribuut) ja sSeldItemId, sSeldElemValue, sSeldAttrValue saadakse järgmiselt :
  //
  // ChooseElement -> ShowElemsMenu -> SwitchElemsMenu -> ClickElemsMenu ->
  // SetSelectedInfo -> HideDivMenu
  //
  // div_ElemsMenu ja div_AttrsMenu < tr > :
  // class = 'mi'; id = sFullPath; value = 'qname|name|URI|IsElement|kirjeldav'
  var aElemInfo, aAttrInfo, sNodeTest, qt, qtMySql, seldQn, artRada, elemRada, evPath;
  var otsitavInfo;
  var tarr, i, rb;
  aElemInfo = sSeldElemValue.split("|");
  // ===================================================================================================
  // otsingu väärtuseks ainult configist DefQuery
  var ccDefQr = atsDefQuery(dic_desc);
  var ccDicpr = atsDicpr(dic_desc);
  aElemInfo[0] = ccDicpr + ":" + ccDefQr;
  aElemInfo[1] = ccDefQr;
  seldQn = aElemInfo[0]
  // ===================================================================================================
  // alert("aElemInfox: " + sSeldElemValue);
  // qt : .// text(), self : : node(), text()
  qt = sel_queryType.options(sel_queryType.selectedIndex).id;
  if (qt == ".//text()")
  {
    qtMySql = "//text()";
  }
  else if (qt == "self::node()")
  {
    qtMySql = "//text()";
  }
  else if (qt == "text()")
  {
    qtMySql = "/text()";
  }
  // sNodeTest algab artiklist : "q:A/..." jne
  if (sSeldAttrValue != "")
  {
    sNodeTest = jsMid(sSeldItemId, 0, sSeldItemId.lastIndexOf("/"));
  }
  else
  {
    sNodeTest = sSeldItemId;
  }
  // sNodeTest algab artiklist : "q:A/..." jne
  artRada = qn_art;
  evPath = sNodeTest;
  if (sNodeTest == artRada)
  {
    // A
    elemRada = "";
  }
  else
  {
    if (inp_UseGlobal.checked)
    {
      elemRada = ".//" + seldQn;
      if (dic_desc == 'ss1' && seldQn == qn_ms)
      {
        // name() ja local - name() ei kehti MySql XPath - is
        elemRada = ".//*[self::s:m or self::s:tul or self::s:mm or self::s:rv]";
      }
      evPath = elemRada;
    }
    else
    {
      elemRada = jsMid(sNodeTest, sNodeTest.indexOf("/") + 1);
      // 'q:A/...;
    }
  }
  if (aElemInfo[3] == "1")
  {
    // '"päris" elemendid, mitte koondpäringud
    if (sNodeTest == artRada)
    {
      otsitavInfo = artRada;
    }
    else
    {
      otsitavInfo = elemRada;
    }
  }
  else
  {
    //        otsitavInfo = jsMid(sNodeTest, 4); // q : A / ...;
    otsitavInfo = "'salvestatud päring'";
  }
  if (sSeldAttrValue != "")
  {
    sQryInfo = "[" + aElemInfo[4] + " (" + otsitavInfo + ") [ '" + ft + "' (?: " + ft.length + ")][" + jsMid(sSeldItemId, sSeldItemId.lastIndexOf("/") + 1) + ": '" + fa + "']]";
  }
  else
  {
    sQryInfo = "[" + aElemInfo[4] + " (" + otsitavInfo + ") [ '" + ft + "' (?: " + ft.length + ")]]";
  }
  if (! inp_UseSymbols.checked)
  {
    if (inp_UseCase.checked)
    {
      sQryInfo = sQryInfo + ", " + CASE_INSENSITIVE + ", " + SYMS_EXCLUDED;
    }
    else
    {
      sQryInfo = sQryInfo + ", " + CASE_SENSITIVE + ", " + SYMS_EXCLUDED;
    }
  }
  else
  {
    if (inp_UseCase.checked)
    {
      sQryInfo = sQryInfo + ", " + CASE_INSENSITIVE + ", " + SYMS_INCLUDED;
    }
    else
    {
      sQryInfo = sQryInfo + ", " + CASE_SENSITIVE + ", " + SYMS_INCLUDED;
    }
  }
  if (inp_UseGlobal.checked)
  {
    sQryInfo = sQryInfo + ", " + GLOBAL_WORD;
  }
  else
  {
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
  // "päris" elemendid, valitud artikkel ning otsitakse kas tühja v olematut artiklit
  if (aElemInfo[3] == "1" && sNodeTest == artRada && (ft == "" || ft == "=NULL"))
  {
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
  // value = 'qname|name|URI|IsElement|kirjeldav'
  if (aElemInfo[3] == "1")
  {
    seldQnDecl = oSchRootElems.itemByQName(aElemInfo[1], aElemInfo[2]);
    if (seldQnDecl.type.itemType == SOMITEM_COMPLEXTYPE)
    {
      if (seldQnDecl.type.contentType == SCHEMACONTENTTYPE_TEXTONLY || seldQnDecl.type.contentType == SCHEMACONTENTTYPE_MIXED)
      {
        hasSeldText = true;
      }
    }
    else
    {
      hasSeldText = true;
    }
  }
  if (sSeldAttrValue != "")
  {
    // qname | name | URI | IsElement | kirjeldav;
    aAttrInfo = sSeldAttrValue.split("|");
    var mySqlMsAttNimi;
    if (seldQn == qn_ms)
    {
      if (aAttrInfo[0] == "xml:lang")
      {
        mySqlMsAttNimi = "ms_lang";
      }
      else
      {
        mySqlMsAttNimi = "ms_att_" + aAttrInfo[1];
      }
    }
    var rexBinary, attLikePtrn, atribuutValNimi;
    rexBinary = "";
    if (withCase == 1)
    {
      rexBinary = "BINARY ";
    }
    attLikePtrn = getMySqlLikePtrn(fa);
    atribuutValNimi = "val";
    // atribuutide väärtused on kas numbrid (@i) või mallid või @mvtl; ehk siis kõik need kaovad '_nos' teisendustel
    // seega on atribuutide puhul järgnev välja kommenteeritud
    //        if ((withSymbols < 1)) {
    //            atribuutValNimi = "val_nos";
    //        }
    if (fa == "*")
    {
      attXmlPred = "[@" + aAttrInfo[0] + "]";
      attSqlPred = attXmlPred;
      if (seldQn == qn_ms && ! (inp_UseGlobal.checked && dic_desc == 'ss1'))
      {
        mySqlAttCond = " AND msid." + mySqlMsAttNimi + " IS NOT NULL";
      }
      else
      {
        mySqlAttCond = " AND atribuudid_" + dic_desc + ".nimi = BINARY '" + aAttrInfo[0] + "'" + " AND atribuudid_" + dic_desc + ".elG = elemendid_" + dic_desc + ".elG";
      }
    }
    else if (fa == "")
    {
      attXmlPred = "[@" + aAttrInfo[0] + " = '']";
      attSqlPred = attXmlPred;
      if (seldQn == qn_ms && ! (inp_UseGlobal.checked && dic_desc == 'ss1'))
      {
        mySqlAttCond = " AND msid." + mySqlMsAttNimi + " = ''";
      }
      else
      {
        mySqlAttCond = " AND atribuudid_" + dic_desc + ".nimi = BINARY '" + aAttrInfo[0] + "'" + " AND atribuudid_" + dic_desc + "." + atribuutValNimi + " = ''" + " AND atribuudid_" + dic_desc + ".elG = elemendid_" + dic_desc + ".elG";
      }
    }
    else if (fa == "=NULL")
    {
      attXmlPred = "[not(@" + aAttrInfo[0] + ")]";
      attSqlPred = attXmlPred;
      if (seldQn == qn_ms && ! (inp_UseGlobal.checked && dic_desc == 'ss1'))
      {
        mySqlAttCond = " AND msid." + mySqlMsAttNimi + " IS NULL";
      }
      else
      {
        hasSeldText = false;
        // las otsib ExtractValue kaudu;
      }
    }
    else
    {
      //            if ((withSymbols < 1)) {
      //                if ((CheckForSymbols(fa, "*?0123456789 "))) { // '2. parm VÕIB OLLA;
      //                    rb = alert(CONT_QUERY_Q, vbQuestion, QUERY_WORD + ": @" + fa);
      //                    return null;
      //                }
      //            }
      attPtrn = jsReplace(fa, "&amp;", "&");
      attPtrn = getSrPn2(attPtrn, "XML");
      if (withCase == 0)
      {
        attPtrn = "(?i)" + attPtrn;
      }
      // "attPtrn" läheb XML funktsiooni parameetrina, seega peab ' asendama;
      attPtrn = jsReplace(attPtrn, "'", "\x27");
      //            if ((withSymbols < 1)) {
      //                attSubst = "&\\w+;|[^\\p{L}\\d\\s]";
      //            }
      attXmlPred = "[al_p:srch2(@" + aAttrInfo[0] + ", '" + attPtrn + "', '" + attSubst + "') > 0]";
      attSqlPred = "[@" + aAttrInfo[0] + getXPathPred(fa) + "]"
      if (seldQn == qn_ms && ! (inp_UseGlobal.checked && dic_desc == 'ss1'))
      {
        mySqlAttCond = " AND msid." + mySqlMsAttNimi + " LIKE " + rexBinary + attLikePtrn;
      }
      else
      {
        if (hasSeldText && mySqlDataVer == "2")
        {
          // 'muul juhul läheb "attSqlPred" kaudu MySql-i;
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
  if (seldQn == qn_ms && fakult.length > 0 && withSymbols == - 1)
  {
    fakPtrn = fakult;
  }
  mySqlPtrn = "";
  pQrySql = "";
  if (jsTrim(ft) == "=.")
  {
    alert("Not invented!", vbExclamation);
    return null;
  }
  else if (jsTrim(ft) == "!=.")
  {
    // elpred = "[not(.=preceding::" + xmltag + ")]";
    alert("Not invented!", vbExclamation);
    // if (hasSeldText) {
    //    // kui on 'hasSeldText', siis 'evPath' peaks olema kama
    //    qM = "MySql";
    //    pQrySql = getSqlQuery(seldQn, ft, hasSeldText, withSymbols, withCase, evPath, elemRada, mySqlAttCond);
    // }
    return null;
  }
  else if (jsLeft(jsTrim(ft), 2) == "§§")
  {
    withSymbols = 1;
    withCase = 1;
    qM = "XML";
    srchPtrn = jsTrim(ft).substr(2);
    srchPtrn = jsReplace(srchPtrn, "\\u", "\\p{Lu}");
    // 'suurtähed;
    srchPtrn = jsReplace(srchPtrn, "\\l", "\\p{Ll}");
    // 'väiketähed;
    srchPtrn = jsReplace(srchPtrn, "\\k", "[bcdfghjklmnpqrsšzžtvwx]");
    // 'eesti konsonandid;
    srchPtrn = jsReplace(srchPtrn, "\\v", "[aeiouõäöüy]");
    // 'eesti vokaalid;
    elpred = "[al_p:srch(.) > 0]";
    if (sNodeTest == artRada)
    {
      // A;
      elm_xpath = "self::node()";
      art_xpath = artRada + attXmlPred + "[" + qt + elpred + "]";
      evPath = artRada + attSqlPred + qtMySql;
    }
    else
    {
      arttingimus = elemRada + attXmlPred + "[" + qt + elpred + "]";
      elm_xpath = arttingimus;
      art_xpath = artRada + "[" + arttingimus + "]";
      evPath = elemRada + attSqlPred + qtMySql;
    }
  }
  else if (jsLeft(jsTrim(ft), 1) == "§")
  {
    elpred = "[" + jsTrim(ft).substr(1) + "]";
    if ((sNodeTest == artRada))
    {
      // A;
      elm_xpath = "self::node()";
      art_xpath = artRada + attXmlPred + elpred;
    }
    else
    {
      arttingimus = elemRada + attXmlPred + elpred;
      elm_xpath = arttingimus;
      art_xpath = artRada + "[" + arttingimus + "]";
    }
    // MySQL "extractValue" tegutseb juurika tasemel (ehk siis "A");
    evPath = evPath + attSqlPred + elpred + qtMySql;
    // •The : : operator == ! supported in combination with node types such as the following;
    if ((elpred.indexOf("::comment()") > - 1 || elpred.indexOf("::text()") > - 1 || elpred.indexOf("::processing-instruction()") > - 1 || elpred.indexOf("::node()") > - 1))
    {
      qM = "XML";
    }
    // axes ! supported in MySQL ExtractValue;
    if ((elpred.indexOf("following-sibling::") > - 1 || elpred.indexOf("following::") > - 1 || elpred.indexOf("preceding-sibling::") > - 1 || elpred.indexOf("preceding::") > - 1))
    {
      qM = "XML";
    }
    // functions ! supported in MySQL ExtractValue;
    if ((elpred.indexOf("id(") > - 1 || elpred.indexOf("lang(") > - 1 || elpred.indexOf("local-name(") > - 1 || elpred.indexOf("name(") > - 1 || elpred.indexOf("namespace-uri(") > - 1 || elpred.indexOf("normalize-space(") > - 1 || elpred.indexOf("starts-with(") > - 1 || elpred.indexOf("string(") > - 1 || elpred.indexOf("substring-after(") > - 1 || elpred.indexOf("substring-before(") > - 1 || elpred.indexOf("translate(") > - 1))
    {
      qM = "XML";
    }
    // ka Perl funktsioonid tuleb siit välja arvata (srch, srch2);
    if ((elpred.indexOf("al_p:srch") > - 1))
    {
      qM = "XML";
    }
    // kui XPath tingimuse SEES on on veel mingi tingimus ja sisemist tingimust rahuldab rohkem kui 1 juhus, ;
    // select * from vsl where extractvalue(art, "z:A[z:P/z:mg[z:m[not(@z:zs)] && z:etg/z:etgg/z:keel = 'ld']]//text()") != '' && vol_nr > 0; ;
    // select * from vsl where extractvalue(art, "z:A/z:P/z:mg[z:m[not(@z:zs)] && z:etg/z:etgg/z:keel = 'ld']//text()") != '' && vol_nr > 0; ;
    // MySQL ei suuda seda leida. Senikaua - kui selgusetu - olgu alati "XML";
    qM = "XML";
    withCase = 1;
    withSymbols = 1;
    // et kas elemendil on teksti ette näthud v mitte (hasSeldText)
    // kui 'false', siis läheb alati ExtractValue kaudu
    hasSeldText = false;
    pQrySql = atsSqlQuery(seldQn, ft, hasSeldText, withSymbols, withCase, evPath, elemRada, mySqlAttCond);
  }
  else
  {
    // serveris otsib 'srch' tectContent' abil, selles aga ' & amp; ' -> ' & ';
    srchPtrn = jsReplace(ft, "&amp;", "&");
    srchPtrn = getSrPn2(srchPtrn, "XML");
    hlPtrn = srchPtrn // hlPtrn : ainult MySql meetodi jaoks värvimisel;
    hlPtrn = jsReplace(hlPtrn, "^", "\\b");
    hlPtrn = jsReplace(hlPtrn, "$", "\\b");
    var qtTing;
    if (ft == "*")
    {
      withSymbols = 1;
      // XML : vahet pole; mysql : art_alt ja val_nos on tühjad. Vale tulemus
      elpred = "";
      qtTing = "";
      evPath = evPath + attSqlPred + qtMySql;
    }
    else if (ft == "")
    {
      withSymbols = 1;
      // XML : vahet pole; mysql : art_alt ja val_nos on tühjad. Vale tulemus
      elpred = "[. = '']";
      qtTing = elpred;
      evPath = evPath + attSqlPred + elpred + qtMySql;
    }
    else if (ft == "=NULL")
    {
      // 'A korral ei täideta, vt ülal;
      seldQn = artRada;
      hasSeldText = false;
      // otsitav element muutus < A > , sellel pole mysql tabelites teksti ega atribuute;
      withSymbols = 1;
      withCase = 1;
      //        elpred = "[not(" + elemRada + ")]" ' see vist ei käivitunud MySql XML-i "not()" iseärasuste tõttu
      elpred = "[count(" + elemRada + ") = 0]";
      qtTing = elpred;
      evPath = artRada + elpred + "//text()";
      // 'sõltumata "qtMySql" - ist
      attXmlPred = "";
      // 'ei ole kasutatav atr tingimus, kui otsime elementi, mida pole;
      mySqlAttCond = "";
    }
    else
    {
      if (withSymbols < 1)
      {
        if (CheckForSymbols(ft, "*? "))
        {
          // '2. parm VÕIB OLLA;
          //rb = alert(CONT_QUERY_Q + '\n' + QUERY_WORD + ": <" + ft + ">");
          //return null;
        }
      }
      elpred = "[al_p:srch(.) > 0]";
      qtTing = "[" + qt + elpred + "]";
      evPath = evPath + attSqlPred + qtMySql;
    }
    if (seldQn == artRada)
    {
      // A;
      elm_xpath = "self::node()";
      art_xpath = artRada + attXmlPred + qtTing;
    }
    else
    {
      arttingimus = elemRada + attXmlPred + qtTing;
      elm_xpath = arttingimus;
      art_xpath = artRada + "[" + arttingimus + "]";
    }
    // value = 'qname|name|URI|IsElement|kirjeldav';
    if (aElemInfo[3] == "1")
    {
      if (inp_UseGlobal.checked && dic_desc == 'ss1' && seldQn == qn_ms)
      {
        // pQrySql = getSqlQuery("x:yyyyy", ft, false, withSymbols, withCase, evPath, elemRada, mySqlAttCond);
        // * [self : : s : m or self : : s : tul or self : : s : mm or self : : s : rv]
        pQrySql = atsSqlQuery("s:m;s:tul;s:mm;s:rv", ft, hasSeldText, withSymbols, withCase, evPath, elemRada, mySqlAttCond);
      }
      else
      {
        pQrySql = atsSqlQuery(seldQn, ft, hasSeldText, withSymbols, withCase, evPath, elemRada, mySqlAttCond);
      }
    }
    //////        // kui küsida gruppe, siis päringutulemuste tabelis oleks vaja näha ka grupi atribuute :
    //////        // teksti omavate väljade korral käib päring vaikimisi MySQL kaudu, gruppide korral XML kaudu
    //////        if ( ! hasSeldText) {
    //////            qM = "XML";
    //////        }
  }
  if (aElemInfo[3] != "1")
  {
    // koond - v valmispäringud
    qM = aElemInfo[5];
    if (qM == "XML")
    {
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
  if ((oPrmDom.parseError.errorCode == 0))
  {
    // cmd ja vol täidetakse 'btnRunQuery' - is;
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
  // at alert(sQryInfo);
  // at alert(srchPtrn);
  return oPrmDom;
}
// atsGetQueryParams


/**
*
*
* @method atsSqlQuery
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
function atsSqlQuery(qn, txt, onTeksti, wsym, wcase, extvalpath, elRada, msAttCond) {
    var rexBinary, volId, volCond, ret;
    rexBinary = "";
    if (wcase == 1) {
        rexBinary = "BINARY ";
    }
    //volId = sel_Vol.options(sel_Vol.selectedIndex).id;
    volId = dic_desc + "All";
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
} //atsSqlQuery



// -----------------------------------------------------------------------------------
function atsDefQuery(dicdesc)
{
  var tekst, cfgElem, n;
  var dicConfDom = IDD("File", "shsconfig_" + dicdesc + ".xml", false, false, null);
  cfgElem = dicConfDom.documentElement.selectSingleNode("default_query");
  if (cfgElem)
  {
    tekst = cfgElem.text;
    n = tekst.lastIndexOf(":");
    if (n == - 1)
    {
      tekst = "";
    }
    else
    {
      tekst = tekst.substr(n + 1);
    }
  }
  return tekst
}
// atsDefQuery
// -----------------------------------------------------------------------------------
function atsLongDefQuery(dicdesc)
{
  var tekst, cfgElem, n;
  var dicConfDom = IDD("File", "shsconfig_" + dicdesc + ".xml", false, false, null);
  cfgElem = dicConfDom.documentElement.selectSingleNode("default_query");
  tekst = ""
  if (cfgElem)
  {
    tekst = cfgElem.text;
  }
  return tekst
}
// atsDefQuery
// -----------------------------------------------------------------------------------
function atsDicpr(dicdesc)
{
  var tekst, cfgElem;
  var dicConfDom = IDD("File", "shsconfig_" + dicdesc + ".xml", false, false, null);
  cfgElem = dicConfDom.documentElement.selectSingleNode("dicpr");
  if (cfgElem)
  {
    tekst = cfgElem.text;
  }
  return tekst
}
// atsDicpr
// -----------------------------------------------------------------------------------
function atsOnViit(xxContValue)
{
  //alert("Start");
  var nimi, i;
  var xxRet = false;
  try {
    var configDom = IDD("File", "config/view/gendViewConf_" + dic_desc + ".xml", false, false, null);
  }
  catch (er) {
    return xxRet;
  }
  if (configDom.parseError.errorCode != 0)
  {
    // ShowXMLParseError(configDom);
    return;
  }
  // at alert("End");
  // at alert("+++ " + DICPR);
  var configElements = configDom.documentElement.selectNodes("//elem[isLink=1]");
  // dic_vols_count = oConfigDOM.documentElement.selectNodes("vols/vol").length;
  //alert(configElements.length - 1);
  for (i = 0; i <= configElements.length - 1;
    i ++)
  {
    nimi = configElements(i).selectSingleNode("@name");
    tekst = nimi.value;
    n = tekst.lastIndexOf(":");
    if (n == - 1)
    {
      tekst = "";
    }
    else
    {
      tekst = DICPR + ":" + tekst.substr(n + 1);
    }
    //alert(tekst);
    if (xxContValue == tekst)
    {

      if (atsOkRun(dic_desc) == 1) {

        xxRet = true;
        return xxRet;
      } else {
        xxRet = false;
        return xxRet;
      }

    }
    // at alert("1. " + nimi.value + " --> " + tekst);
  }
  return xxRet;
}
// -----------------------------------------------------------------------------------
function atsTest()
{
  // alert("+++Start");
  var jooksevArtStr = getXmlString(oEditDOM);
  // at alert(jooksevArtStr);
  alert(selectedNode.nodeName);
  alert(selectedNode.text);
  var xxG = oEditDOMRoot.selectSingleNode("x:A");
  alert(xxG.selectSingleNode("x:G").text);
  // alert("+++End");
}
// -----------------------------------------------------------------------------------
function showArtLink()
{
  if (atsOnViit(selectedNode.nodeName))
  {
    if (! (document.body.all("img_artLink") == null))
    {
      img_artLink.style.visibility = "visible";
    }
  }
  else
  {
    if (! (document.body.all("img_artLink") == null))
    {
      img_artLink.style.visibility = "hidden";
    }
  }
}
// showArtLink
// -----------------------------------------------------------------------------------
function atsParseMyInfo(oRespDom)
{
  var sta, cnt, vol, zG, qM, appSta, statusText, status, responseText, xxx, ix;
  statusText = oRespDom.documentElement.selectSingleNode("statusText").text;
  status = parseInt(oRespDom.documentElement.selectSingleNode("status").text);
  responseText = oRespDom.documentElement.selectSingleNode("responseText").text;
  // alert("Kontroll!");
  var qInfoStr, printSr;
  // alert("RESP - > " + responseText);
  // alert("ccField - > " + ccField);
  if (statusText == "OK")
  {
    appSta = oRespDom.documentElement.selectSingleNode("appSta").text;
    if (appSta == "AppSuccess")
    {
      sta = oRespDom.documentElement.selectSingleNode("sta").text;
      cnt = oRespDom.documentElement.selectSingleNode("cnt").text;
      cnt = parseInt(cnt);
      vol = oRespDom.documentElement.selectSingleNode("vol").text;
      qM = oRespDom.documentElement.selectSingleNode("qM").text;
      // at alert("sCmdId=" + sCmdId);
      if (sta == "Success")
      {
        if (sCmdId == "ClientRead" || sCmdId == "BrowseRead" || sCmdId == "prevNextRead" || sCmdId == "msSarnased" || sCmdId == "tyhjadViited")
        {
          if (cnt == 0)
          {
            ShowStatusInfo(ART_NOT_FOUND + " [" + qM + "]");

            alert("Märksõna '" + ccField + "' ei leitud. Loo uus artikkel!");
            selectedNode.text = "";
            if (selectedNode.getAttribute(DICPR + ":i") != "")
            {
              selectedNode.removeAttribute(DICPR + ":i");
            }
            oEditAll("ifrdiv").setAttribute("xmlChanged", 2);
            vaatedRefresh(2);
          }
          else
          {
            // alert("atsParseMyInfo(cnt)-> " + cnt);
            if (cnt == 1)
            {
              // var zzArtElements = oRespDom.documentElement.selectNodes("..//A");
              // zG = zzArtElements(0).documentElement.selectSingleNode("G").text;
              // viwReadViewDB(vol, zG);
            }
            atsXmlValue(oRespDom, cnt, vol);
          }
        }
      }
    }
  }
}
// atsParseMyInfo
// -----------------------------------------------------------------------------------
function atsXmlValue(oMyXmlDom, zznt, zzvol)
{
  var i, zNzimi,cNzimi, zAttrHom, zArtElemCnt, zVol, zG, zzField;
  var tblAjalugu, rida, veerg, artGuid;
  var zzArtElements = oMyXmlDom.documentElement.selectNodes("..//A");
  var zzDicpr = atsDicpr(dic_desc);
  var zzDefQr = atsDefQuery(dic_desc);
  var zzMarkS = zzDicpr + ":" + zzDefQr;
  var zzVol = zzDicpr + ":vf"
  var dlgArgs = new Array();
  var ccElem = "";
  var showDlg = true;
  ccCount = zznt;
  if (zznt == 1)
  {
    var zzArtElements1 = oMyXmlDom.documentElement.selectNodes("..//" + zzDicpr + ":A");
    // alert(zzvol);
    zG = zzArtElements1(0).selectSingleNode(zzDicpr + ":G").text;
    // alert(zG);
    //alert(atsLongDefQuery(dic_desc));
    var zzArtElements2 = oMyXmlDom.documentElement.selectNodes("..//rsp");
    zzField = zzArtElements2(0).selectSingleNode(atsLongDefQuery(dic_desc)).text;
    zAttrHom = zzArtElements2(0).selectSingleNode(atsLongDefQuery(dic_desc)).getAttribute(zzDicpr + ":i");
    if (zAttrHom == null)
    {
      zAttrHom = "";
    }
    dlgArgs[0] = zzField + PD + zAttrHom + PD + zzvol + PD + zG;
    //alert(ZZZ);

    if (showDlg)
    {
      sParms = window.showModalDialog(atsPrgCatal + "/atsViewart.htm", dlgArgs, "dialogHeight:350px;dialogWidth:600px;center:yes;edge:sunken;help:no;resizable:yes;scroll:yes;status:no;unadorned:no");
      if (typeof(sParms) == "object")
      {
        if (sParms[0] != "")
        {
          // alert ("Return = " + sParms[0] + " " + sParms[1]);

          ccField = sParms[0];
          selectedNode.text = sParms[0];
          if (sParms[1] != "")
          {
            setMyNSAttribute (selectedNode, DICURI, DICPR + ":i", sParms[1]);
            //selectedNode.setAttribute(DICPR + ":i", sParms[1]);
          }
          else
          {
            selectedNode.removeAttribute(DICPR + ":i");
          }
          vaatedRefresh(2);
        }
        else
        {
          selectedNode.text = "";
          selectedNode.removeAttribute(DICPR + ":i");
          vaatedRefresh(2);
        }
      }
      else
      {

        selectedNode.text = "";
        selectedNode.removeAttribute(DICPR + ":i");
        vaatedRefresh(2);
      }
    }
    return;
  }
  //tblAjalugu = div_ArtViitMenu.all("tbl_ArtViitMenu");
  // at alert(tblAjalugu.rows.length);
  // if ((tblAjalugu.rows.length > 0)) {
  // tblAjalugu.deleteRow(tblAjalugu.rows.length - 1);
  // tblAjalugu.deleteRow(tblAjalugu.rows.all);
  // }
  //var zzRowsCnt = tblAjalugu.rows.length;
  //if (zzRowsCnt > 0)
  //{
  //   for (i = 1; i < tblAjalugu.rows.length + 1;
  //   i ++ )
  //   {
  //      tblAjalugu.deleteRow(0);
  //   }
  // }
  // at alert("atsXmlValue(length)-> " + zzArtElements.length);
  // at alert(zzArtElements.length);
  if (zzArtElements.length == 0)
  {
    zArtElemCnt = 1;
  }
  else
  {
    zArtElemCnt = zzArtElements.length;
  }

    var xChs = 0;
    try {
      zNzimi = zzArtElements(0).selectSingleNode("l/t/" + zzMarkS).text;
    }
    catch (er) {

     xChs = 1;
    //zzMarkS = zzDefQr;

    }


  for (i = 0; i < zArtElemCnt; i ++)
  {
    zVol = zzArtElements(i).selectSingleNode("vf").text;
    zG = zzArtElements(i).selectSingleNode("G").text;
    zNzimi = zzArtElements(i).selectSingleNode("md/t").text;
    cNzimi = atsSplitMS(zNzimi);

    if (cNzimi.indexOf(PD) != -1){
       var aNzimi = cNzimi.split(PD);
       zNzimi = aNzimi[0];
       zAttrHom = aNzimi[1];
    } else {
      zNzimi = cNzimi;
      zAttrHom = null;

    }

    if (zAttrHom == null)
    {
      zAttrHom = "";
    }

    //if (zNzimi.indexOf("Σ = ")!=-1) {
       //zNzimi = zNzimi.replace(/\Σ = /g,  '');
    //}





    dlgArgs[i] = zNzimi + PD + zAttrHom + PD + zVol + PD + zG;
  }
  if (showDlg)
  {
    sParms = window.showModalDialog(atsPrgCatal + "/atsViewart.htm", dlgArgs, "dialogHeight:350px;dialogWidth:600px;center:yes;edge:sunken;help:no;resizable:yes;scroll:yes;status:no;unadorned:no");
    if (typeof(sParms) == "object")
    {
      if (sParms[0] != "")
      {
        // alert ("Return = " + sParms[0] + " " + sParms[1]);
        ccField = sParms[0];
        setMyNSAttribute (selectedNode, DICURI, DICPR + ":i", sParms[0]);
        selectedNode.text = sParms[0];
        if (sParms[1] != "")
        {
          setMyNSAttribute (selectedNode, DICURI, DICPR + ":i", sParms[1]);
          //selectedNode.setAttribute(DICPR + ":i", sParms[1]);
        }
        else
        {
          selectedNode.removeAttribute(DICPR + ":i");
        }
        vaatedRefresh(2);
      }
      else
      {
        selectedNode.text = "";
        selectedNode.removeAttribute(DICPR + ":i");
        vaatedRefresh(2);
      }
    }
    else
    {

      selectedNode.text = "";
      selectedNode.removeAttribute(DICPR + ":i");
      vaatedRefresh(2);

    }
  }
}
// atsXmlValue
// --------------------------------------------------------------------------------
function showArtViit()
{
  if (ccCount > 1)
  {
    var oSrc, nX, nY, nVerGap
    oSrc = window.event.srcElement;
    nVerGap = 4 // oSrc border "thin" (2 ? ) ja parent TD padding (2 ? );
    // nX = window.event.clientX + 2 * oSrc.offsetWidth;
    // nY = window.event.screenY - window.screenTop - window.event.offsetY - oSrc.offsetTop - nVerGap;
    nX = 50;
    nY = 50;
    div_ArtViitMenu.style.pixelLeft = nX;
    div_ArtViitMenu.style.pixelTop = nY;
    div_ArtViitMenu.style.display = "";
    div_ArtViitMenu.style.cursor = "default";
    div_ArtViitMenu.setCapture();
  }
}
// showArtViit
// --------------------------------------------------------------------------------
function FillArtViitTabel()
{
  if (! (document.all("img_artLink") == null))
  {
    var tblAjalugu, rida, veerg, artGuid;
    tblAjalugu = div_ArtViitMenu.all("tbl_ArtViitMenu");
    if ((tblAjalugu.rows.length == 100))
    {
      tblAjalugu.deleteRow(tblAjalugu.rows.length - 1);
    }
    rida = tblAjalugu.insertRow(0);
    rida.className = "mi";
    artGuid = oEditDOMRoot.selectSingleNode(DICPR + ":A/" + qn_guid).text;
    rida.id = artGuid;
    rida.setAttribute("v", sFromVolume);
    // '"ief1" jne;
    veerg = rida.insertCell();
    veerg.style.width = "50%";
    veerg.innerHTML = sOrgMarkSona;
    veerg = rida.insertCell();
    veerg.innerHTML = new Date();
  }
}
// FillArtViitTabel
// --------------------------------------------------------------------------------
function ClickArtViitMenu()
{
  var sCFP, rida, artGuid, volId, veerg1, veerg2, veerg3, veerg4, sPrmDomXml, oPrmDom, oSrc;
  sCFP = div_ArtViitMenu.componentFromPoint(window.event.clientX, window.event.clientY);
  if ((jsLeft(sCFP, 6) == "scroll"))
  {
    div_ArtViitMenu.doScroll(sCFP);
  }
  else if ((sCFP == ""))
  {
    document.releaseCapture();
    oSrc = window.event.srcElement;
    if ((oSrc.tagName == "TD"))
    {
      // if ((salvestaJaKatkesta())) {
      //    return;
      // }
      rida = oSrc.parentElement;
      artGuid = rida.id;
      volId = rida.getAttribute("v");
      ccSaveStat = 0;
      viwReadViewDB(volId, artGuid);
      veerg1 = rida.all.tags("TD")[0];
      veerg2 = rida.all.tags("TD")[1];
      veerg3 = rida.all.tags("TD")[2];
      veerg4 = rida.all.tags("TD")[3];
      ccField = veerg1.innerText;
      ccHomNr = veerg2.innerText;
      if (ccSaveStat == 2)
      {
        selectedNode.text = veerg1.innerText;
        if (veerg2.innerText != "")
        {
          selectedNode.setAttribute(DICPR + ":i", veerg2.innerText);
        }
        else
        {
          selectedNode.removeAttribute(DICPR + ":i");
        }
        // oEditAll("ifrdiv").setAttribute("xmlChanged", 2);
        ccSaveStat == 0
      }
    }
  }
  else if ((sCFP == "outside"))
  {
    document.releaseCapture();
  }
}
// ClickArtViitMenu
// --------------------------------------------------------------------------------
// Lehkülje kuvamine
// --------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------
function viwReadViewDB(zzVol, zzG)
{
  sCmdId = "readArtHtml";
  var cmdXml = "<prm>" +
  "<cmd>" + sCmdId + "</cmd>" +
  "<vol>" + zzVol + "</vol>" +
  "<G>" + zzG + "</G>" +
  "</prm>";
  // alert("koond_dxf.js -> (2) -> " + cmdXml);
  var cmdXmlDom = IDD("String", cmdXml, false, false, null);
  if (! (cmdXmlDom && getXmlString(cmdXmlDom)))
  {
    // kui on viga, siis IE - s on xml = ''
    alert("Viga 'cmdXmlDom'-s");
    return;
  }
  viwStartOperation(cmdXmlDom);
}
// viwdoBrowseRead
// -----------------------------------------------------------------------------------
function viwStartOperation(oPrmDom)
{
  //    dhxBar.disableItem("btnSrch");
  dtOpStart = new Date();
  if (! (sCmdId == "readArtXml"))
  {
    var pagingElapsed = document.getElementById("spnPagingElapsed");
    // pagingElapsed.innerHTML = "";
  }
  // dhxLayout.progressOn();
  viwQueryResponseAsync(oPrmDom);
}
// viwStartOperation
// -----------------------------------------------------------------------------------
function viwQueryResponseAsync(oPrmDom)
{
  xmlHTTPAsync = viwGetXmlHttpObject();
  xmlHTTPAsync.onreadystatechange = viwDoHttpReadyStateChange;
  xmlHTTPAsync.open("POST", "Koond_srvfuncs.cgi", true);
  xmlHTTPAsync.setRequestHeader("Content-Type", "text/xml; charset='utf-8';");
  xmlHTTPAsync.send(getXmlString(oPrmDom));
}
// viwQueryResponseAsync
// -----------------------------------------------------------------------------------
function viwDoHttpReadyStateChange()
{
  if (xmlHTTPAsync.readyState == XMLHTTP_COMPLETED)
  {
    if (IsRequestSuccessful(xmlHTTPAsync))
    {
      var oSrvRspDOM = ParseHTTPResponse(xmlHTTPAsync);
      viwAsyncCompleted(oSrvRspDOM);
    }
    else
    {
      alert(xmlHTTPAsync.statusText);
      viwAsyncCompleted(null);
    }
  }
}
// doHttpReadyStateChange
// -----------------------------------------------------------------------------------
function viwGetXmlHttpObject()
{
  var xmlHttp = null;
  try
  {
    // Firefox, Opera 8.0 + , Safari, IE 7 +
    xmlHttp = new XMLHttpRequest();
  }
  catch (e)
  {
    try
    {
      // Internet Explorer 6 +
      xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
    }
    catch (e)
    {
      // IE 5.5 +
      xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
    }
  }
  return xmlHttp;
}
// -----------------------------------------------------------------------------------
function viwAsyncCompleted(objXMLDom)
{
  if (! objXMLDom)
  {
    // StopOperation();
    return;
  }
  viwParseSrvInfo(objXMLDom);
  // StopOperation();
}
// viwAsyncCompleted
// -----------------------------------------------------------------------------------
function viwParseSrvInfo(oRespDom)
{
  var sta, cnt, fullCnt, vastus, ix;
  var sParms, smdArgs, psTrue = false, showDlg = true;
  sta = getXmlNodeValue(oRespDom.documentElement.getElementsByTagName("sta")[0]);
  cnt = getXmlNodeValue(oRespDom.documentElement.getElementsByTagName("cnt")[0]);
  cnt = parseInt(cnt);
  if (sta == "Success")
  {
    if (sCmdId == "ClientRead")
    {
      fullCnt = getXmlNodeValue(oRespDom.documentElement.getElementsByTagName("fullCnt")[0]);
      if (fullCnt)
      {
        // kui oli esimene päring
        fullCnt = parseInt(fullCnt);
        pagingPageCount = Math.ceil(fullCnt / pagingRowsPerPage);
        var otsitav = jsTrim(dhxBarContent.getValue("txtElemOtsitav"));
        var pagingPealKiri = document.getElementById("spnPagingInfo");
        var nrStr = fullCnt.toLocaleString();
        if (nrStr.indexOf(".") > - 1)
        {
          nrStr = nrStr.substr(0, nrStr.indexOf("."));
        }
        else if (nrStr.indexOf(",") > - 1)
        {
          nrStr = nrStr.substr(0, nrStr.indexOf(","));
        }
        pagingPealKiri.innerHTML = opInfo + "'" + otsitav + "': " + nrStr + " märksõna";
        dhxBarPaging.forEachListOption("pageSelect", function (optionId)
          {
            dhxBarPaging.removeListOption("pageSelect", optionId);
          }
        );
        if (fullCnt > 0)
        {
          for (ix = 0; ix < pagingPageCount; ix ++)
          {
            //                    addListOption(parentId, optionId, pos, type, text, img)
            dhxBarPaging.addListOption("pageSelect", ix + 1, ix + 1, 'button', (ix + 1) + " lk.", null);
          }
        }
        else
        {
          dhxBarPaging.addListOption("pageSelect", 1, 1, 'button', "1. lk.", null);
        }
        setButtonSelectId(dhxBarPaging, "pageSelect", pagingPageNr, " / " + pagingPageCount + " lk.");
      }
      if (cnt == 0)
      {
        //                sbMain.setText("<img src='graphics/info.png' style='width:16px;'> " + sQryInfo + " - artikleid ei leitud [" + qM + "].");
        //            } else if (cnt == 1) {
        //                vastus = oRespDom.documentElement.getElementsByTagNameNS(DICURI, "A")[0];
        //                FillArtFrames(vastus, true);
        //                sbMain.setText("<img src='graphics/info.png' style='width:16px;'> " + sQryInfo + " - " + cnt + " artikkel [" + qM + "].");
      }
      else if (cnt > 0)
      {
        vastus = oRespDom.documentElement.getElementsByTagName("sr")[0];
        FillBrowseFrame(vastus);
        //                sbMain.setText("<img src='graphics/info.png' style='width:16px;'> " + sQryInfo + " - " + cnt + " artiklit [" + qM + "].");
      }
    }
    else if (sCmdId == "getRandomWord")
    {
      var w = getXmlSingleNodeValue(oRespDom.documentElement, "w");
      dhxBarContent.setValue("txtElemOtsitav", w);
    }
    else if (sCmdId == "srvSaveAs")
    {
      var zF = getXmlSingleNodeValue(oRespDom.documentElement, "zF");
      showZipDownLoad(zF);
    }
    else if (sCmdId == "readArtXml")
    {
      vastus = oRespDom.documentElement.getElementsByTagName("sr")[0];
      dhxLayout.cells("b").attachHTMLString(getXmlString(vastus));
    }
    else if (sCmdId == "readArtHtml")
    {
      vastus = getXmlSingleNode(oRespDom.documentElement, "sr").firstChild;
      // CDATA -> TextNode
      var artAsjad = vastus.nodeValue.split(JR);
      // CSS rules, html, hasHtml
      if (artAsjad[2])
      {
        smdArgs = new Array("1", "1", "1");
        smdArgs[1] = artAsjad[1];
        valaDiv.innerHTML = artAsjad[1];
      }
    }
  }
  else
  {
    alert(getXmlString(oRespDom));
    return;
  }
}
// viwParseSrvInfo
// -----------------------------------------------------------------------------------
// returns whether the HTTP request was successful
function IsRequestSuccessful(httpRequest)
{
  // IE : sometimes 1223 instead of 204
  var success = (httpRequest.status == 0 ||
    (httpRequest.status >= 200 && httpRequest.status < 300) ||
    httpRequest.status == 304 || httpRequest.status == 1223);
  return success;
}
// IsRequestSuccessful
// -----------------------------------------------------------------------------------
function setVala()
{
  var ifr = dhxLayout.cells("b").getFrame();
  var ifrDoc;
  if (_isIE)
  {
    ifrDoc = ifr.contentWindow.document;
  }
  else
  {
    ifrDoc = ifr.contentDocument;
  }
  valaDiv = ifrDoc.getElementById("valaDiv");
  valaCss = ifrDoc.getElementById("valaCss");
  valaDoc = ifrDoc;
}
// setVala
// -----------------------------------------------------------------------------------
function atsGoExeViit()
{
  atsXmlValue(oRespDom, cnt, vol);
  var oEvent, oSrc;
  if (!(window.click == null)) {
    sSrc = "app";
    oEvent = window.click;
  } else if (!(frame_Browse.click == null)) {
    sSrc = "browse";
    oEvent = frame_Browse.click;
  }
  oSrc = oEvent.srcElement;
  if (atsOnViit(selectedNode.nodeName))
  {
    var currTekst = oSrc.value;
    ccField = currTekst;
    alert(currTekst);
    atsRunQuery(currTekst);
  }
}
// atsGoExeViit
// -----------------------------------------------------------------------------------
function showArtWarrant()
{
  alert("Hoiatus:Viite kontrolli ei saa teha, kuna vaade ei ole genereeritud, vaid kirjutatud käsitsi!")
}
// showArtWarrant
// -----------------------------------------------------------------------------------
function atsGendViewConfYes()
{
  var configDom = IDD("File", "config/view/gendViewConf_" + dic_desc + ".xml", false, false, null);
  if (configDom.parseError.errorCode != 0)
  {
    if (!(document.body.all("img_artAttent") == null)) {
      img_artAttent.style.visibility = "visible";
    }
  }else {
    if (!(document.body.all("img_artAttent") == null)) {
      img_artAttent.style.visibility = "hidden";
    }
  }
}
// atsGendViewConfYes
// -----------------------------------------------------------------------------------
function trim(stringToTrim) {
  return stringToTrim.replace(/^\s+|\s+$/g, "");
}
// trim
// -----------------------------------------------------------------------------------
function ltrim(stringToTrim) {
  return stringToTrim.replace(/^\s+/, "");
}
// ltrim
// -----------------------------------------------------------------------------------
function rtrim(stringToTrim) {
  return stringToTrim.replace(/\s+$/, "");
}
// rtrim

// -----------------------------------------------------------------------------------
function atsYesSymbString(zString) {
  var wYesSymb = 0;
  var wLen = zString.length;

  // alert (zString + " == " + zString.substr(wLen-1,1));

  //if (zString.substr(wLen-1,1)=="*") {
  //   wYesSymb = 1;
  //}
  if (zString.indexOf("*")!=-1) {
    wYesSymb = 1;
  }
  if (zString.indexOf("?")!=-1) {
    wYesSymb = 1;
  }
  return wYesSymb;
}
// atsYesSymbString

// -----------------------------------------------------------------------------------
function atsNoDig(zString) {
  var wString = zString;
     wString = wString.replace(/\`/g,  '');
     wString = wString.replace(/\'/g,  '');
     wString = wString.replace(/\|/g,  '');
     wString = wString.replace(/\+/g,  '');
     wString = wString.replace(/\=/g,  '');
     wString = wString.replace(/\{/g,  '');
     wString = wString.replace(/\}/g,  '');
     wString = wString.replace(/\[/g,  '');
     wString = wString.replace(/\]/g,  '');
     wString = wString.replace(/\%/g,  '');
     wString = wString.replace(/\&/g,  '');
     wString = wString.replace(/\¤/g,  '');
     wString = wString.replace(/\£/g,  '');
     wString = wString.replace(/\#/g,  '');
     wString = wString.replace(/\@/g,  '');
     wString = wString.replace(/\"/g,  '');
     wString = wString.replace(/\!/g,  '');
     wString = wString.replace(/\-/g,  '');
     wString = wString.replace(/\_/g,  '');
     wString = wString.replace(/\~/g,  '');
     wString = wString.replace(/\ˇ/g,  '');
  return wString;
}
// atsYesSymbString

// -----------------------------------------------------------------------------------
function atsSplitMS(zString) {
   var wString = zString.split(" :: ");
   var cString = trim(wString[0]);
   var wPosit =cString.indexOf('[▫i=');
   if (wPosit != -1) {
      var wStr1 = cString.substring(0,wPosit);
      var wStr2 = cString.substring(wPosit);
      var aStr2 = wStr2.split('"');
      cString = trim(wStr1) + PD + trim(aStr2[1]);
  }
  return cString;
}
// atsSplitMS

// -----------------------------------------------------------------------------------
function atsOkRun(dicdesc)
{
  var tekst, cfgElem, n, xElexInd;
  n = 0;

  try {
    var dicConfDom = IDD("File", "shsConfig.xml", false, false, null);
  }
  catch (er) {
    return n;
  }

  try {
    cfgElem = dicConfDom.documentElement.selectSingleNode("vcont");
  }
  catch (er) {
    return n;
  }

  xElexInd = ";" + dicdesc + ";";
  if (cfgElem)
  {
    tekst = cfgElem.text;
    if (tekst != ";*;") {
      if (tekst.indexOf(xElexInd)!=-1) {
        n = 1;
      }
    } else {
      n = 1;
    }
  }
  return n;
}
// atsOkRun

function progress_clear() {
  for (var i = 1; i <= progressEnd; i++) document.getElementById('progress'+i).style.backgroundColor = 'transparent';
  progressAt = 0;
}
function progress_update() {
  document.getElementById('showbar').style.visibility = 'visible';
  progressAt++;
  if (progressAt > progressEnd) progress_clear();
  else document.getElementById('progress'+progressAt).style.backgroundColor = progressColor;
  progressTimer = setTimeout('progress_update()', progressInterval);
}
function progress_stop() {
  clearTimeout(progressTimer);
  progress_clear();
  document.getElementById('showbar').style.visibility = 'hidden';
}