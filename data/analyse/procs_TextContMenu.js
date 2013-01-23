
var openmenuid;

//-----------------------------------------------------------------------------------
function SwitchCMenu() {
    //käsitleb nii cmenu (tavaline kontekstmenüü)
    //kui ka tn_cmenu (mixed=true #text sees tekkiv kontekstmenüü)
    //onmouseover-it ja onmouseout-i
    //ühel ajal korraga nad lahti ei ole, capture on korraga ühel neist
    var cmel, pixY, opnMnuHeight, subMenu;

    cmel = event.srcElement;
    if (cmel.className == "mi") {
        //et vahepeal openmenuid ära ei kaoks;
        if ((cmel.parentElement.id == "cmenu" || cmel.parentElement.id == "tn_cmenu")) {
            if (openmenuid) { //'alammenüü id;
                document.getElementById(openmenuid).style.display = "none";
                openmenuid = "";
            }
        }
        cmel.className = "hi";
        if ((cmel.parentElement.id == "cmenu")) {
            if ((cmel.id == "add_before")) {
                openmenuid = "sm_before";
            } else if ((cmel.id == "add_after")) {
                openmenuid = "sm_after";
            } else if ((cmel.id == "add_insert")) {
                openmenuid = "sm_insert";
            } else if ((cmel.id == "add_attrs")) {
                openmenuid = "sm_attrs";
            } else if ((cmel.id == "paste_node")) {
                openmenuid = "paste_node_options";
            } else if ((cmel.id == "assembleAndComplete")) {
                openmenuid = "aacContMenu";
            }
            if (openmenuid) {
                subMenu = document.getElementById(openmenuid);
                if (subMenu.innerHTML != "") {
                    subMenu.style.pixelLeft = cmenu.style.pixelLeft + cmenu.offsetWidth;
                    subMenu.style.pixelTop = cmenu.style.pixelTop + cmel.offsetTop;
                    subMenu.style.display = "";
                }
            }
        }
        if ((cmel.parentElement.id == "tn_cmenu")) {
            if ((jsLeft(cmel.id, 7) == "tn_add_")) { //'before, after, insert;
                openmenuid = "tn_sm_" + jsMid(cmel.id, 7);
            } else if ((jsLeft(cmel.id, 4) == "sym_")) { //'queries, entities, styles, latin_1, latin_2, marks, combin, greek, cyrillic, udmurtian, mari, mymisc, etymology;
                openmenuid = "insert_" + jsMid(cmel.id, 4);
            }
            if ((openmenuid != "")) {
                subMenu = document.getElementById(openmenuid);
                if ((subMenu.innerHTML != "")) {
                    subMenu.style.display = "";
                    subMenu.style.pixelLeft = tn_cmenu.style.pixelLeft + (2 * tn_cmenu.offsetWidth) / 3;
                    opnMnuHeight = subMenu.offsetHeight;
                    if ((opnMnuHeight > tn_cmenu.offsetHeight)) {
                        //üles v alla liikudes on asi erinev: sellepärast veel lahutatud 'cmel.offsetHeight';
                        if ((window.event.screenY - window.screenTop - cmel.offsetTop - cmel.offsetHeight < (opnMnuHeight - tn_cmenu.offsetHeight))) {
                            pixY = tn_cmenu.style.pixelTop;
                        } else {
                            pixY = tn_cmenu.style.pixelTop + tn_cmenu.offsetHeight - opnMnuHeight;
                        }
                    } else {
                        pixY = tn_cmenu.style.pixelTop + cmel.offsetTop - (opnMnuHeight / 4);
                    }
                    subMenu.style.pixelTop = pixY;
                }
            }
        }
    } else if ((cmel.className == "hi")) {
        cmel.className = "mi";
    } else if ((cmel.className == "mi_span")) {
        cmel.className = "hi_span";
        if (!(jsLeft(cmel.id, 7) == "switch_")) {
            if ((cmel.parentElement.style.pixelTop - window.screenTop < document.getElementById("big_character").offsetHeight)) {
                pixY = cmel.parentElement.style.pixelTop + cmel.parentElement.offsetHeight;
            } else {
                pixY = cmel.parentElement.style.pixelTop - 82;
            }
            //big_character: html, x, y, fontStyle, fontFamily;
            ShowBigCharacter(cmel.innerHTML, cmel.parentElement.style.pixelLeft + cmel.offsetLeft, pixY, cmel.style.fontStyle, cmel.style.fontFamily);
        }
    } else if ((cmel.className == "hi_span")) {
        HideBigCharacter();
        cmel.className = "mi_span";
    }
} //SwitchCMenu


//-----------------------------------------------------------------------------------
function DisplayTNCMenu(posx, posy) {
    tn_cmenu.style.pixelLeft = posx;
    tn_cmenu.style.pixelTop = posy;
    tn_cmenu.style.display = "";
    tn_cmenu.style.cursor = "default";
    tn_cmenu.setCapture();
} //DisplayTNCMenu

//-----------------------------------------------------------------------------------
function ClickTNCMenu() {
    var cmel
    cmel = window.event.srcElement

    //peamenüü (tn_cmenu) sees olevad div-id
    //"<div style='width:100%' class='mi' id='tn_add_before'>Lisa ette</div>"
    //"<div style='width:100%' class='mi' id='tn_add_insert'>Lisa sisse</div>"
    //"<div style='width:100%' class='mi' id='tn_add_after'>Lisa järele</div>"
    //"<div style='width:100%' class='mi' id='del_tn'>Kustuta</div>"

    if ((cmel.className == "dl" || cmel.className == "md")) {
        return;
    }

    //klõps põhimenüüs
    if ((cmel.parentElement.id == "tn_cmenu")) {
        if ((openmenuid == "")) {
            if ((cmel.className == "hi")) {
                cmel.className = "mi";
            } else if ((cmel.className == "hi_span")) {
                cmel.className = "mi_span";
            }
            document.releaseCapture();
        }
        //klõps alammenüüdes või üldse kuskil mujal
    } else {
        if ((cmel.className == "hi")) {
            cmel.className = "mi";
        } else if ((cmel.className == "hi_span")) {
            cmel.className = "mi_span";
        }
        document.releaseCapture();
    }

    //cmel.id =
    //qn(0); item.uri(1); typename(item)(2); typename(item.type)(3);
    //item.type.contentType(4); item.type.name(5); item.minOcc(6);
    //item.maxOcc(7); kirjeldav(8); item.name(9)
    var tarr;
    tarr = cmel.id.split(";")

    var norm_elem = null;

    //ette, sisse, järele alammenüüd:
    //tn_sm_before, tn_sm_insert, tn_sm_after
    var newnode, tt, tt1, tt2, rng, i;

    if (cmel.parentElement.id.substr(0, 6) == "tn_sm_") { // ette, sisse, järele
        if (yldStruDom.documentElement.getAttribute("pr_sd:ver") == "2.0") {
            newnode = oEditDOM.createDocumentFragment();
            var frDocRoot = newnode.appendChild(oEditDOM.createNode(NODE_ELEMENT, tarr[0], tarr[1]));
            var yldStruNode = yldStruDom.selectSingleNode(".//" + tarr[0]);
            getMajors(yldStruNode, frDocRoot);
        }
        else {
            newnode = GetAddElementFromFile(tarr[0], tarr[1]);
        }
    }

    if ((cmel.parentElement.id == "tn_sm_before")) {
        norm_elem = selectedNode;
        norm_elem.insertBefore(newnode, clickedNode);
    } else if ((cmel.parentElement.id == "tn_sm_insert")) {
        norm_elem = selectedNode;
        tt = contextClicked.value;
        rng = document.selection.createRange();
        rng.text = JR;
        i = contextClicked.value.indexOf(JR);
        tt1 = jsMid(contextClicked.value, 0, i);
        tt2 = jsMid(contextClicked.value, i + 1);
        oClicked.innerHTML = tt

        var dfr, tnode;
        dfr = oEditDOM.createDocumentFragment();

        if ((tt1 != "")) {
            tnode = oEditDOM.createNode(NODE_TEXT, "", "");
            tnode.text = tt1;
            dfr.appendChild(tnode);
        }
        dfr.appendChild(newnode);
        if ((tt2 != "")) {
            tnode = oEditDOM.createNode(NODE_TEXT, "", "");
            tnode.text = tt2;
            dfr.appendChild(tnode);
        }
        norm_elem.replaceChild(dfr, clickedNode);
    } else if ((cmel.parentElement.id == "tn_sm_after")) {
        norm_elem = selectedNode;
        norm_elem.insertBefore(newnode, clickedNode.nextSibling);
    } else if ((cmel.id == "del_tn")) {
        norm_elem = selectedNode;
        norm_elem.removeChild(clickedNode);
    } else if ((jsLeft(cmel.parentElement.id, 7) == "insert_")) {
        rng = document.selection.createRange();
        tt = cmel.value;
        tt = jsReplace(tt, "<", "&lt;");
        tt = jsReplace(tt, ">", "&gt;");
        // rng.text = cmel.value
        rng.text = tt;
    } else if ((jsLeft(cmel.id, 7) == "switch_")) { //'bold, em, sub, sup, u vahetused;
        rng = document.selection.createRange();
        tt1 = cmel.value;  //muutuja alustav osa, &ba; nt;
        tt2 = jsMid(tt1, 0, tt1.length - 2) + "l;";
        var lopuTyhik;
        lopuTyhik = "";
        if ((jsRight(rng.text, 1) == " ")) {
            lopuTyhik = " ";
        }
        tt = jsTrim(rng.text);
        if ((jsLeft(tt, tt1.length) == tt1)) { //algabki muutuja algosaga ...;
            tt = jsMid(tt, tt.indexOf(";") + 1);
            tt = jsMid(tt, 0, tt.lastIndexOf("&"));
            rng.text = tt + lopuTyhik;
        } else {
            rng.text = tt1 + tt + tt2 + lopuTyhik;
        }
    } else if ((cmel.id == "add_copied")) {
        rng = document.selection.createRange();
        rng.text = sTextToCopy;
    }
    //norm_elem: märk muudatustest
    if (norm_elem) {
        norm_elem.normalize();
        setATTAPlokid(norm_elem);
        vaatedRefresh(2);
    }
} //ClickTNCMenu


//-----------------------------------------------------------------------------------
function DisableContextMenu() {
    event.returnValue = false;
} //DisableContextMenu


//-----------------------------------------------------------------------------------
function HideDivMenu() {
    var dam = document.getElementById("div_AttrsMenu");
    if (dam) {
        dam.style.display = "none"; //'otsitava elemendi atribuutide kõrvalmenüü;
    }
    //kõikvõimalikud kõrvalmenüüd
    if (openmenuid) { //'elemendi ja teksti kontekstmenüü kõrvalmenüüd (lisa ette, muutujad, tähed jm)
        document.getElementById(openmenuid).style.display = "none";
        openmenuid = "";
    }
    var bc = document.getElementById("big_character");
    if (bc)
        bc.style.display = "none"; //'lisatav täht suurelt;
    //menüü ise
    var divObj = event.srcElement;
    divObj.style.display = "none";
    divObj.style.cursor = "auto";
} //HideDivMenu


//-----------------------------------------------------------------------------------
function ShowBigCharacter(cHTML, x, y, fs, ff) {
    big_character.innerHTML = cHTML;
    big_character.style.fontStyle = fs;
    big_character.style.fontFamily = ff;
    big_character.style.pixelLeft = x;
    big_character.style.pixelTop = y;
    big_character.style.display = "";
} //ShowBigCharacter

//-----------------------------------------------------------------------------------
function HideBigCharacter() {
    big_character.innerHTML = "";
    big_character.style.display = "none";
} //HideBigCharacter


//-----------------------------------------------------------------------------------
function FillInsertSymbolsMenu() {

    var menuItem = document.getElementById("tn_cmenu");
    if (!menuItem) {
        document.body.appendChild(document.createElement("<div id=\"tn_cmenu\" style=\"display:none; position:absolute; width:300px;background-color:menu; border:outset 3px gray\" onmouseover=\"SwitchCMenu()\" onmouseout=\"SwitchCMenu()\" onclick=\"ClickTNCMenu()\" oncontextmenu=\"DisableContextMenu()\" onlosecapture=\"HideDivMenu()\"></div>"));
    }
    menuItem = document.getElementById("insert_symbols");
    if (!menuItem) {
        document.body.appendChild(document.createElement("<div id=\"insert_symbols\" style=\"display:none; position:absolute; width:2px;background-color:menu; border:outset 3px gray\"></div>"));
    }
    menuItem = document.getElementById("insert_queries");
    if (!menuItem) {
        document.body.appendChild(document.createElement("<div id=\"insert_queries\" style=\"display:none; position:absolute; width:366px;background-color:menu; border:outset 3px gray\"></div>"));
    }
    menuItem = document.getElementById("insert_entities");
    if (!menuItem) {
        document.body.appendChild(document.createElement("<div id=\"insert_entities\" style=\"display:none; position:absolute; width:366px;background-color:menu; border:outset 3px gray\"></div>"));
    }
    menuItem = document.getElementById("insert_latin_1");
    if (!menuItem) {
        document.body.appendChild(document.createElement("<div id=\"insert_latin_1\" style=\"display:none; position:absolute; width:460px;background-color:menu; border:outset 3px gray\"></div>"));
    }
    menuItem = document.getElementById("insert_latin_2");
    if (!menuItem) {
        document.body.appendChild(document.createElement("<div id=\"insert_latin_2\" style=\"display:none; position:absolute; width:460px;background-color:menu; border:outset 3px gray\"></div>"));
    }
    menuItem = document.getElementById("insert_marks");
    if (!menuItem) {
        document.body.appendChild(document.createElement("<div id=\"insert_marks\" style=\"display:none; position:absolute; width:366px;background-color:menu; border:outset 3px gray\"></div>"));
    }
    menuItem = document.getElementById("insert_combin");
    if (!menuItem) {
        document.body.appendChild(document.createElement("<div id=\"insert_combin\" style=\"display:none; position:absolute; width:366px;background-color:menu; border:outset 3px gray\"></div>"));
    }
    menuItem = document.getElementById("insert_greek");
    if (!menuItem) {
        document.body.appendChild(document.createElement("<div id=\"insert_greek\" style=\"display:none; position:absolute; width:366px;background-color:menu; border:outset 3px gray\"></div>"));
    }
    menuItem = document.getElementById("insert_cyrillic");
    if (!menuItem) {
        document.body.appendChild(document.createElement("<div id=\"insert_cyrillic\" style=\"display:none; position:absolute; width:366px;background-color:menu; border:outset 3px gray\"></div>"));
    }
    menuItem = document.getElementById("insert_udmurtian");
    if (!menuItem) {
        document.body.appendChild(document.createElement("<div id=\"insert_udmurtian\" style=\"display:none; position:absolute; width:366px;background-color:menu; border:outset 3px gray\"></div>"));
    }
    menuItem = document.getElementById("insert_mari");
    if (!menuItem) {
        document.body.appendChild(document.createElement("<div id=\"insert_mari\" style=\"display:none; position:absolute; width:366px;background-color:menu; border:outset 3px gray\"></div>"));
    }
    menuItem = document.getElementById("insert_etymology");
    if (!menuItem) {
        document.body.appendChild(document.createElement("<div id=\"insert_etymology\" style=\"display:none; position:absolute; width:366px;background-color:menu; border:outset 3px gray\"></div>"));
    }
    menuItem = document.getElementById("insert_pronunc");
    if (!menuItem) {
        document.body.appendChild(document.createElement("<div id=\"insert_pronunc\" style=\"display:none; position:absolute; width:366px;background-color:menu; border:outset 3px gray\"></div>"));
    }
    menuItem = document.getElementById("big_character");
    if (!menuItem) {
        document.body.appendChild(document.createElement("<div id=\"big_character\" style=\"display:none; position:absolute; height:80px; width:80px;background-color:menu; border:outset 3px gray; text-align:center; font-size:xx-large\"></div>"));
    }



//    if ((document.body.all("tn_cmenu") == null)) {
//        document.body.appendChild(document.createElement("<div id=\"tn_cmenu\" style=\"display:none; position:absolute; width:300px;background-color:menu; border:outset 3px gray\" onmouseover=\"SwitchCMenu()\" onmouseout=\"SwitchCMenu()\" onclick=\"ClickTNCMenu()\" oncontextmenu=\"DisableContextMenu()\" onlosecapture=\"HideDivMenu()\"></div>"));
//    }
//    if ((document.body.all("insert_symbols") == null)) {
//        document.body.appendChild(document.createElement("<div id=\"insert_symbols\" style=\"display:none; position:absolute; width:2px;background-color:menu; border:outset 3px gray\"></div>"));
//    }
//    if ((document.body.all("insert_queries") == null)) {
//        document.body.appendChild(document.createElement("<div id=\"insert_queries\" style=\"display:none; position:absolute; width:366px;background-color:menu; border:outset 3px gray\"></div>"));
//    }
//    if ((document.body.all("insert_entities") == null)) {
//        document.body.appendChild(document.createElement("<div id=\"insert_entities\" style=\"display:none; position:absolute; width:366px;background-color:menu; border:outset 3px gray\"></div>"));
//    }
//    if ((document.body.all("insert_latin_1") == null)) {
//        document.body.appendChild(document.createElement("<div id=\"insert_latin_1\" style=\"display:none; position:absolute; width:460px;background-color:menu; border:outset 3px gray\"></div>"));
//    }
//    if ((document.body.all("insert_latin_2") == null)) {
//        document.body.appendChild(document.createElement("<div id=\"insert_latin_2\" style=\"display:none; position:absolute; width:460px;background-color:menu; border:outset 3px gray\"></div>"));
//    }
//    if ((document.body.all("insert_marks") == null)) {
//        document.body.appendChild(document.createElement("<div id=\"insert_marks\" style=\"display:none; position:absolute; width:366px;background-color:menu; border:outset 3px gray\"></div>"));
//    }
//    if ((document.body.all("insert_combin") == null)) {
//        document.body.appendChild(document.createElement("<div id=\"insert_combin\" style=\"display:none; position:absolute; width:366px;background-color:menu; border:outset 3px gray\"></div>"));
//    }
//    if ((document.body.all("insert_greek") == null)) {
//        document.body.appendChild(document.createElement("<div id=\"insert_greek\" style=\"display:none; position:absolute; width:366px;background-color:menu; border:outset 3px gray\"></div>"));
//    }
//    if ((document.body.all("insert_cyrillic") == null)) {
//        document.body.appendChild(document.createElement("<div id=\"insert_cyrillic\" style=\"display:none; position:absolute; width:366px;background-color:menu; border:outset 3px gray\"></div>"));
//    }
//    if ((document.body.all("insert_udmurtian") == null)) {
//        document.body.appendChild(document.createElement("<div id=\"insert_udmurtian\" style=\"display:none; position:absolute; width:366px;background-color:menu; border:outset 3px gray\"></div>"));
//    }
//    if ((document.body.all("insert_mari") == null)) {
//        document.body.appendChild(document.createElement("<div id=\"insert_mari\" style=\"display:none; position:absolute; width:366px;background-color:menu; border:outset 3px gray\"></div>"));
//    }
//    if ((document.body.all("insert_etymology") == null)) {
//        document.body.appendChild(document.createElement("<div id=\"insert_etymology\" style=\"display:none; position:absolute; width:366px;background-color:menu; border:outset 3px gray\"></div>"));
//    }
//    if ((document.body.all("insert_pronunc") == null)) {
//        document.body.appendChild(document.createElement("<div id=\"insert_pronunc\" style=\"display:none; position:absolute; width:366px;background-color:menu; border:outset 3px gray\"></div>"));
//    }
//    if ((document.body.all("big_character") == null)) {
//        document.body.appendChild(document.createElement("<div id=\"big_character\" style=\"display:none; position:absolute; height:80px; width:80px;background-color:menu; border:outset 3px gray; text-align:center; font-size:xx-large\"></div>"));
//    }

    var vlyh, ixCode, hex4Nr;
    vlyh = "&vt;" + String.fromCharCode("0x" + jsMid(FRACTION_SLASH, 3, 4)) + String.fromCharCode("0x" + jsMid(RIGHTWARDS_ARROW, 3, 4));
    var inssym

    //Põhimenüü
    inssym = "";
    inssym = inssym + "<div style='width:100%' class='mi' id='sym_queries'>Päringud</div>";
    inssym = inssym + "<div style='width:100%' class='mi' id='sym_entities'>" + MNU_INS_SYM_ENTS_STYLES + "</div>";
    inssym = inssym + "<div style='width:100%' class='mi' id='sym_latin_1'>" + MNU_INS_SYM_LATIN_1 + "</div>";
    inssym = inssym + "<div style='width:100%' class='mi' id='sym_latin_2'>" + MNU_INS_SYM_LATIN_2 + "</div>";
    inssym = inssym + "<div style='width:100%' class='mi' id='sym_marks'>" + MNU_INS_SYM_SYM_LIGATURES + "</div>";
    inssym = inssym + "<div style='width:100%' class='mi' id='sym_combin'>" + MNU_INS_SYM_COMB_SYM + "</div>";
    inssym = inssym + "<div style='width:100%' class='mi' id='sym_greek'>" + MNU_INS_SYM_GREEK + "</div>";
    inssym = inssym + "<div style='width:100%' class='mi' id='sym_cyrillic'>" + MNU_INS_SYM_CYRILLIC + "</div>";
    inssym = inssym + "<div style='width:100%' class='mi' id='sym_pronunc'>" + MNU_INS_SYM_PRONUNCIATION + "</div>";
    inssym = inssym + "<div style='width:100%' class='mi' id='sym_etymology'>" + MNU_INS_SYM_ETHYMOLOGY + "</div>";
    inssym = inssym + "<div style='width:100%' class='mi' id='sym_udmurtian'>" + MNU_INS_SYM_UDMURTIAN + "</div>";
    inssym = inssym + "<div style='width:100%' class='mi' id='sym_mari'>" + MNU_INS_SYM_MARI + "</div>";
    insert_symbols.innerHTML = inssym

    inssym = "";
    inssym = inssym + "<div style='width:100%' class='md'>'Päringud'</div>";
    //(?õ) - jätab kirjastiilide muutujad arvestamata
    inssym = inssym + "<div class='mi' value='§§[^a-zA-ZšžõäöüŠŽÕÄÖÜ_,&;!\\d\\s\\-\\.\\/\\(\\)\\[\\]]'>MITTE (eesti + märgid)</div>";
    inssym = inssym + "<div class='mi' value='§§[^a-zA-Zа-яА-ЯёЁšžõäöüŠŽÕÄÖÜ_,&;!\\d\\s\\-\\.\\/\\(\\)\\[\\]]'>MITTE (eesti + vene + märgid)</div>";
    inssym = inssym + "<div class='mi' value='§§[^а-яА-ЯёЁ_,&;!\\d\\s\\-\\.\\/\\(\\)\\[\\]]]'>MITTE (vene + märgid)</div>";
    insert_queries.innerHTML = inssym

    inssym = "";
    inssym = inssym + "<div style='width:100%' class='md'>'" + MNU_INS_SYM_ENTS_STYLES + "'</div>";
    inssym = inssym + "<span class='mi_span' title='Kursiivis ehk: &ehk;' value='&ehk;' style='font-style:italic'>ehk</span>";
    inssym = inssym + "<span class='mi_span' title='Kursiivis Hrl: &Hrl;' value='&Hrl;' style='font-style:italic'>Hrl</span>";
    inssym = inssym + "<span class='mi_span' title='Kursiivis hrl: &hrl;' value='&hrl;' style='font-style:italic'>hrl</span>";
    inssym = inssym + "<span class='mi_span' title='Kursiivis ja: &ja;' value='&ja;' style='font-style:italic'>ja</span>";
    inssym = inssym + "<span class='mi_span' title='Kursiivis jne: &jne;' value='&jne;' style='font-style:italic'>jne</span>";
    inssym = inssym + "<span class='mi_span' title='Kursiivis jt: &jt;' value='&jt;' style='font-style:italic'>jt</span>";
    inssym = inssym + "<span class='mi_span' title='Kursiivis ka: &ka;' value='&ka;' style='font-style:italic'>ka</span>";
    inssym = inssym + "<span class='mi_span' title='Kursiivis nt: &nt;' value='&nt;' style='font-style:italic'>nt</span>";
    inssym = inssym + "<span class='mi_span' title='Kursiivis puudub: &puudub;' value='&puudub;' style='font-style:italic'>puudub</span>";
    inssym = inssym + "<span class='mi_span' title='Kursiivis v: &v;' value='&v;' style='font-style:italic'>v</span>";
    inssym = inssym + "<span class='mi_span' title='vd: 1)  &vt;  (raamatus),  2)  ->  (veebis)' value='1)  &vt;  (raamatus),  2)  " + RIGHTWARDS_ARROW + "  (veebis)'>vd</span>";
    inssym = inssym + "<span class='mi_span' title='Viitelühend' value='" + vlyh + "'>" + vlyh + "</span>";
    inssym = inssym + "<span class='mi_span' title='Kursiivis vm: &vm;' value='&vm;' style='font-style:italic'>vm</span>";
    inssym = inssym + "<span class='mi_span' title='Kursiivis vms: &vms;' value='&vms;' style='font-style:italic'>vms</span>";
    // Lisatud Vene õpilase ÕSi tarbeks
    inssym = inssym + "<span class='mi_span' title='Kursiivis напр.: +напр.;' value='+напр.;' style='font-style:italic'>напр.</span>";
    inssym = inssym + "<span class='mi_span' title='Kursiivis и др.: +и др.;' value='+и др.;' style='font-style:italic'>и&nbsp;др.</span>";
    inssym = inssym + "<span class='mi_span' title='Kursiivis и т. п.: +и т. п.;' value='+и т. п.;' style='font-style:italic'>и&nbsp;т.&nbsp;п.</span>";
    inssym = inssym + "<span class='mi_span' title='Kursiivis г.: +г.;' value='+г.;' style='font-style:italic'>г.</span>";
    inssym = inssym + "<span class='mi_span' title='Väiksem kui <' value='&lt;'>&lt;</span>";
    inssym = inssym + "<span class='mi_span' title='Suurem kui >' value='&gt;'>&gt;</span>";
    inssym = inssym + "<span class='mi_span' title='Kirjastiili muutuse algus: &ema;' value='&ema;'>&ema;</span>";
    inssym = inssym + "<span class='mi_span' title='Kirjastiili muutuse lõpp: &eml;' value='&eml;'>&eml;</span>";
    inssym = inssym + "<span class='mi_span' title='Alaindeksi algus: &suba;' value='&suba;'>&suba;</span>";
    inssym = inssym + "<span class='mi_span' title='Alaindeksi lõpp: &subl;' value='&subl;'>&subl;</span>";
    inssym = inssym + "<span class='mi_span' title='Ülaindeksi algus: &supa;' value='&supa;'>&supa;</span>";
    inssym = inssym + "<span class='mi_span' title='Ülaindeksi lõpp: &supl;' value='&supl;'>&supl;</span>";
    inssym = inssym + "<span class='mi_span' title='Poolpaks algus: &ba;' value='&ba;'>&ba;</span>";
    inssym = inssym + "<span class='mi_span' title='Poolpaks lõpp: &bl;' value='&bl;'>&bl;</span>";
    inssym = inssym + "<span class='mi_span' title='Allajoonitud algus: &la;' value='&la;'>&la;</span>";
    inssym = inssym + "<span class='mi_span' title='Allajoonitud lõpp: &ll;' value='&ll;'>&ll;</span>";
    insert_entities.innerHTML = inssym

    inssym = "";
    inssym = inssym + "<div style='width:100%' class='md'>'" + MNU_INS_SYM_LATIN_1 + "'</div>";
    inssym = inssym + "<span class='mi_span' value='&#x0041;' title='U+0041'>&#x0041;</span>"; //'A
    inssym = inssym + "<span class='mi_span' value='&#x0061;' title='U+0061'>&#x0061;</span>"; //'a
    inssym = inssym + "<span class='mi_span' value='&#x00C0;' title='U+00C0'>&#x00C0;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00E0;' title='U+00E0'>&#x00E0;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00C1;' title='U+00C1'>&#x00C1;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00E1;' title='U+00E1'>&#x00E1;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00C2;' title='U+00C2'>&#x00C2;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00E2;' title='U+00E2'>&#x00E2;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00C3;' title='U+00C3'>&#x00C3;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00E3;' title='U+00E3'>&#x00E3;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00C5;' title='U+00C5'>&#x00C5;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00E5;' title='U+00E5'>&#x00E5;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0100;' title='U+0100'>&#x0100;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0101;' title='U+0101'>&#x0101;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0102;' title='U+0102'>&#x0102;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0103;' title='U+0103'>&#x0103;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0104;' title='U+0104'>&#x0104;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0105;' title='U+0105'>&#x0105;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01CD;' title='U+01CD'>&#x01CD;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01CE;' title='U+01CE'>&#x01CE;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01E0;' title='U+01E0'>&#x01E0;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01E1;' title='U+01E1'>&#x01E1;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01FA;' title='U+01FA'>&#x01FA;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01FB;' title='U+01FB'>&#x01FB;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0200;' title='U+0200'>&#x0200;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0201;' title='U+0201'>&#x0201;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0202;' title='U+0202'>&#x0202;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0203;' title='U+0203'>&#x0203;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E00;' title='U+1E00'>&#x1E00;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E01;' title='U+1E01'>&#x1E01;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EA0;' title='U+1EA0'>&#x1EA0;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EA1;' title='U+1EA1'>&#x1EA1;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EA2;' title='U+1EA2'>&#x1EA2;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EA3;' title='U+1EA3'>&#x1EA3;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EA4;' title='U+1EA4'>&#x1EA4;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EA5;' title='U+1EA5'>&#x1EA5;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EA6;' title='U+1EA6'>&#x1EA6;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EA7;' title='U+1EA7'>&#x1EA7;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EA8;' title='U+1EA8'>&#x1EA8;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EA9;' title='U+1EA9'>&#x1EA9;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EAA;' title='U+1EAA'>&#x1EAA;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EAB;' title='U+1EAB'>&#x1EAB;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EAC;' title='U+1EAC'>&#x1EAC;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EAD;' title='U+1EAD'>&#x1EAD;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EAE;' title='U+1EAE'>&#x1EAE;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EAF;' title='U+1EAF'>&#x1EAF;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EB0;' title='U+1EB0'>&#x1EB0;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EB1;' title='U+1EB1'>&#x1EB1;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EB2;' title='U+1EB2'>&#x1EB2;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EB3;' title='U+1EB3'>&#x1EB3;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EB4;' title='U+1EB4'>&#x1EB4;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EB5;' title='U+1EB5'>&#x1EB5;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EB6;' title='U+1EB6'>&#x1EB6;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EB7;' title='U+1EB7'>&#x1EB7;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00C4;' title='U+00C4'>&#x00C4;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00E4;' title='U+00E4'>&#x00E4;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01DE;' title='U+01DE'>&#x01DE;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01DF;' title='U+01DF'>&#x01DF;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0042;' title='U+0042'>&#x0042;</span>"; //'B
    inssym = inssym + "<span class='mi_span' value='&#x0062;' title='U+0062'>&#x0062;</span>"; //'b
    inssym = inssym + "<span class='mi_span' value='&#x0182;' title='U+0182'>&#x0182;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0183;' title='U+0183'>&#x0183;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0184;' title='U+0184'>&#x0184;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0185;' title='U+0185'>&#x0185;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E02;' title='U+1E02'>&#x1E02;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E03;' title='U+1E03'>&#x1E03;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E04;' title='U+1E04'>&#x1E04;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E05;' title='U+1E05'>&#x1E05;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E06;' title='U+1E06'>&#x1E06;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E07;' title='U+1E07'>&#x1E07;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0043;' title='U+0043'>&#x0043;</span>"; //'C
    inssym = inssym + "<span class='mi_span' value='&#x0063;' title='U+0063'>&#x0063;</span>"; //'c
    inssym = inssym + "<span class='mi_span' value='&#x00C7;' title='U+00C7'>&#x00C7;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00E7;' title='U+00E7'>&#x00E7;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0106;' title='U+0106'>&#x0106;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0107;' title='U+0107'>&#x0107;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0108;' title='U+0108'>&#x0108;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0109;' title='U+0109'>&#x0109;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x010A;' title='U+010A'>&#x010A;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x010B;' title='U+010B'>&#x010B;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x010C;' title='U+010C'>&#x010C;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x010D;' title='U+010D'>&#x010D;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0187;' title='U+0187'>&#x0187;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0188;' title='U+0188'>&#x0188;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E08;' title='U+1E08'>&#x1E08;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E09;' title='U+1E09'>&#x1E09;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0044;' title='U+0044'>&#x0044;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0064;' title='U+0064'>&#x0064;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00D0;' title='U+00D0'>&#x00D0;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00F0;' title='U+00F0'>&#x00F0;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x010E;' title='U+010E'>&#x010E;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x010F;' title='U+010F'>&#x010F;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0110;' title='U+0110'>&#x0110;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0111;' title='U+0111'>&#x0111;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x018B;' title='U+018B'>&#x018B;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x018C;' title='U+018C'>&#x018C;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E0A;' title='U+1E0A'>&#x1E0A;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E0B;' title='U+1E0B'>&#x1E0B;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E0C;' title='U+1E0C'>&#x1E0C;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E0D;' title='U+1E0D'>&#x1E0D;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E0E;' title='U+1E0E'>&#x1E0E;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E0F;' title='U+1E0F'>&#x1E0F;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E10;' title='U+1E10'>&#x1E10;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E11;' title='U+1E11'>&#x1E11;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E12;' title='U+1E12'>&#x1E12;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E13;' title='U+1E13'>&#x1E13;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0045;' title='U+0045'>&#x0045;</span>"; //'E
    inssym = inssym + "<span class='mi_span' value='&#x0065;' title='U+0065'>&#x0065;</span>"; //'e
    inssym = inssym + "<span class='mi_span' value='&#x00C8;' title='U+00C8'>&#x00C8;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00E8;' title='U+00E8'>&#x00E8;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00C9;' title='U+00C9'>&#x00C9;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00E9;' title='U+00E9'>&#x00E9;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00CA;' title='U+00CA'>&#x00CA;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00EA;' title='U+00EA'>&#x00EA;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00CB;' title='U+00CB'>&#x00CB;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00EB;' title='U+00EB'>&#x00EB;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0112;' title='U+0112'>&#x0112;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0113;' title='U+0113'>&#x0113;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0114;' title='U+0114'>&#x0114;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0115;' title='U+0115'>&#x0115;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0116;' title='U+0116'>&#x0116;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0117;' title='U+0117'>&#x0117;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0118;' title='U+0118'>&#x0118;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0119;' title='U+0119'>&#x0119;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x011A;' title='U+011A'>&#x011A;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x011B;' title='U+011B'>&#x011B;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0204;' title='U+0204'>&#x0204;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0205;' title='U+0205'>&#x0205;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0206;' title='U+0206'>&#x0206;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0207;' title='U+0207'>&#x0207;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E14;' title='U+1E14'>&#x1E14;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E15;' title='U+1E15'>&#x1E15;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E16;' title='U+1E16'>&#x1E16;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E17;' title='U+1E17'>&#x1E17;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E18;' title='U+1E18'>&#x1E18;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E19;' title='U+1E19'>&#x1E19;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E1A;' title='U+1E1A'>&#x1E1A;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E1B;' title='U+1E1B'>&#x1E1B;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E1C;' title='U+1E1C'>&#x1E1C;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E1D;' title='U+1E1D'>&#x1E1D;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EB8;' title='U+1EB8'>&#x1EB8;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EB9;' title='U+1EB9'>&#x1EB9;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EBA;' title='U+1EBA'>&#x1EBA;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EBB;' title='U+1EBB'>&#x1EBB;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EBC;' title='U+1EBC'>&#x1EBC;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EBD;' title='U+1EBD'>&#x1EBD;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EBE;' title='U+1EBE'>&#x1EBE;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EBF;' title='U+1EBF'>&#x1EBF;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EC0;' title='U+1EC0'>&#x1EC0;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EC1;' title='U+1EC1'>&#x1EC1;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EC2;' title='U+1EC2'>&#x1EC2;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EC3;' title='U+1EC3'>&#x1EC3;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EC4;' title='U+1EC4'>&#x1EC4;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EC5;' title='U+1EC5'>&#x1EC5;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EC6;' title='U+1EC6'>&#x1EC6;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EC7;' title='U+1EC7'>&#x1EC7;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0046;' title='U+0046'>&#x0046;</span>"; //'F
    inssym = inssym + "<span class='mi_span' value='&#x0066;' title='U+0066'>&#x0066;</span>"; //'f
    inssym = inssym + "<span class='mi_span' value='&#x0191;' title='U+0191'>&#x0191;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0192;' title='U+0192'>&#x0192;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E1E;' title='U+1E1E'>&#x1E1E;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E1F;' title='U+1E1F'>&#x1E1F;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0047;' title='U+0047'>&#x0047;</span>"; //'G
    inssym = inssym + "<span class='mi_span' value='&#x0067;' title='U+0067'>&#x0067;</span>"; //'g
    inssym = inssym + "<span class='mi_span' value='&#x011C;' title='U+011C'>&#x011C;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x011D;' title='U+011D'>&#x011D;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x011E;' title='U+011E'>&#x011E;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x011F;' title='U+011F'>&#x011F;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0120;' title='U+0120'>&#x0120;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0121;' title='U+0121'>&#x0121;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0122;' title='U+0122'>&#x0122;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0123;' title='U+0123'>&#x0123;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01E4;' title='U+01E4'>&#x01E4;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01E5;' title='U+01E5'>&#x01E5;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01E6;' title='U+01E6'>&#x01E6;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01E7;' title='U+01E7'>&#x01E7;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01F4;' title='U+01F4'>&#x01F4;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01F5;' title='U+01F5'>&#x01F5;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E20;' title='U+1E20'>&#x1E20;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E21;' title='U+1E21'>&#x1E21;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0048;' title='U+0048'>&#x0048;</span>"; //'H
    inssym = inssym + "<span class='mi_span' value='&#x0068;' title='U+0068'>&#x0068;</span>"; //'h
    inssym = inssym + "<span class='mi_span' value='&#x0124;' title='U+0124'>&#x0124;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0125;' title='U+0125'>&#x0125;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0126;' title='U+0126'>&#x0126;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0127;' title='U+0127'>&#x0127;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E22;' title='U+1E22'>&#x1E22;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E23;' title='U+1E23'>&#x1E23;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E24;' title='U+1E24'>&#x1E24;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E25;' title='U+1E25'>&#x1E25;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E26;' title='U+1E26'>&#x1E26;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E27;' title='U+1E27'>&#x1E27;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E28;' title='U+1E28'>&#x1E28;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E29;' title='U+1E29'>&#x1E29;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E2A;' title='U+1E2A'>&#x1E2A;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E2B;' title='U+1E2B'>&#x1E2B;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0049;' title='U+0049'>&#x0049;</span>"; //'I
    inssym = inssym + "<span class='mi_span' value='&#x0069;' title='U+0069'>&#x0069;</span>"; //'i
    inssym = inssym + "<span class='mi_span' value='&#x00CC;' title='U+00CC'>&#x00CC;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00EC;' title='U+00EC'>&#x00EC;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00CD;' title='U+00CD'>&#x00CD;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00ED;' title='U+00ED'>&#x00ED;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00CE;' title='U+00CE'>&#x00CE;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00EE;' title='U+00EE'>&#x00EE;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00CF;' title='U+00CF'>&#x00CF;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00EF;' title='U+00EF'>&#x00EF;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0128;' title='U+0128'>&#x0128;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0129;' title='U+0129'>&#x0129;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x012A;' title='U+012A'>&#x012A;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x012B;' title='U+012B'>&#x012B;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x012C;' title='U+012C'>&#x012C;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x012D;' title='U+012D'>&#x012D;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x012E;' title='U+012E'>&#x012E;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x012F;' title='U+012F'>&#x012F;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0130;' title='U+0130'>&#x0130;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0131;' title='U+0131'>&#x0131;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01CF;' title='U+01CF'>&#x01CF;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01D0;' title='U+01D0'>&#x01D0;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0208;' title='U+0208'>&#x0208;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0209;' title='U+0209'>&#x0209;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x020A;' title='U+020A'>&#x020A;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x020B;' title='U+020B'>&#x020B;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E2C;' title='U+1E2C'>&#x1E2C;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E2D;' title='U+1E2D'>&#x1E2D;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E2E;' title='U+1E2E'>&#x1E2E;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E2F;' title='U+1E2F'>&#x1E2F;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EC8;' title='U+1EC8'>&#x1EC8;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EC9;' title='U+1EC9'>&#x1EC9;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1ECA;' title='U+1ECA'>&#x1ECA;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1ECB;' title='U+1ECB'>&#x1ECB;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x004A;' title='U+004A'>&#x004A;</span>"; //'J
    inssym = inssym + "<span class='mi_span' value='&#x006A;' title='U+006A'>&#x006A;</span>"; //'j
    inssym = inssym + "<span class='mi_span' value='&#x0134;' title='U+0134'>&#x0134;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0135;' title='U+0135'>&#x0135;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x004B;' title='U+004B'>&#x004B;</span>"; //'K
    inssym = inssym + "<span class='mi_span' value='&#x006B;' title='U+006B'>&#x006B;</span>"; //'k
    inssym = inssym + "<span class='mi_span' value='&#x0136;' title='U+0136'>&#x0136;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0137;' title='U+0137'>&#x0137;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0198;' title='U+0198'>&#x0198;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0199;' title='U+0199'>&#x0199;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01E8;' title='U+01E8'>&#x01E8;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01E9;' title='U+01E9'>&#x01E9;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E30;' title='U+1E30'>&#x1E30;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E31;' title='U+1E31'>&#x1E31;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E32;' title='U+1E32'>&#x1E32;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E33;' title='U+1E33'>&#x1E33;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E34;' title='U+1E34'>&#x1E34;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E35;' title='U+1E35'>&#x1E35;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x004C;' title='U+004C'>&#x004C;</span>"; //'L
    inssym = inssym + "<span class='mi_span' value='&#x006C;' title='U+006C'>&#x006C;</span>"; //'l
    inssym = inssym + "<span class='mi_span' value='&#x0139;' title='U+0139'>&#x0139;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x013A;' title='U+013A'>&#x013A;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x013B;' title='U+013B'>&#x013B;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x013C;' title='U+013C'>&#x013C;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x013D;' title='U+013D'>&#x013D;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x013E;' title='U+013E'>&#x013E;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x013F;' title='U+013F'>&#x013F;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0140;' title='U+0140'>&#x0140;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0141;' title='U+0141'>&#x0141;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0142;' title='U+0142'>&#x0142;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E36;' title='U+1E36'>&#x1E36;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E37;' title='U+1E37'>&#x1E37;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E38;' title='U+1E38'>&#x1E38;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E39;' title='U+1E39'>&#x1E39;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E3A;' title='U+1E3A'>&#x1E3A;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E3B;' title='U+1E3B'>&#x1E3B;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E3C;' title='U+1E3C'>&#x1E3C;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E3D;' title='U+1E3D'>&#x1E3D;</span>";
    //A - L
    insert_latin_1.innerHTML = inssym

    inssym = "";
    inssym = inssym + "<div style='width:100%' class='md'>'" + MNU_INS_SYM_LATIN_2 + "'</div>";
    inssym = inssym + "<span class='mi_span' value='&#x004D;' title='U+004D'>&#x004D;</span>"; //'M
    inssym = inssym + "<span class='mi_span' value='&#x006D;' title='U+006D'>&#x006D;</span>"; //'m
    inssym = inssym + "<span class='mi_span' value='&#x1E3E;' title='U+1E3E'>&#x1E3E;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E3F;' title='U+1E3F'>&#x1E3F;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E40;' title='U+1E40'>&#x1E40;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E41;' title='U+1E41'>&#x1E41;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E42;' title='U+1E42'>&#x1E42;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E43;' title='U+1E43'>&#x1E43;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x004E;' title='U+004E'>&#x004E;</span>"; //'N
    inssym = inssym + "<span class='mi_span' value='&#x006E;' title='U+006E'>&#x006E;</span>"; //'n
    inssym = inssym + "<span class='mi_span' value='&#x00D1;' title='U+00D1'>&#x00D1;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00F1;' title='U+00F1'>&#x00F1;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0143;' title='U+0143'>&#x0143;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0144;' title='U+0144'>&#x0144;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0145;' title='U+0145'>&#x0145;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0146;' title='U+0146'>&#x0146;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0147;' title='U+0147'>&#x0147;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0148;' title='U+0148'>&#x0148;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x014A;' title='U+014A'>&#x014A;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x014B;' title='U+014B'>&#x014B;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E44;' title='U+1E44'>&#x1E44;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E45;' title='U+1E45'>&#x1E45;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E46;' title='U+1E46'>&#x1E46;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E47;' title='U+1E47'>&#x1E47;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E48;' title='U+1E48'>&#x1E48;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E49;' title='U+1E49'>&#x1E49;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E4A;' title='U+1E4A'>&#x1E4A;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E4B;' title='U+1E4B'>&#x1E4B;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x004F;' title='U+004F'>&#x004F;</span>"; //'O
    inssym = inssym + "<span class='mi_span' value='&#x006F;' title='U+006F'>&#x006F;</span>"; //'o
    inssym = inssym + "<span class='mi_span' value='&#x00D2;' title='U+00D2'>&#x00D2;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00F2;' title='U+00F2'>&#x00F2;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00D3;' title='U+00D3'>&#x00D3;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00F3;' title='U+00F3'>&#x00F3;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00D4;' title='U+00D4'>&#x00D4;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00F4;' title='U+00F4'>&#x00F4;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00D8;' title='U+00D8'>&#x00D8;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00F8;' title='U+00F8'>&#x00F8;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x014C;' title='U+014C'>&#x014C;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x014D;' title='U+014D'>&#x014D;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x014E;' title='U+014E'>&#x014E;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x014F;' title='U+014F'>&#x014F;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0150;' title='U+0150'>&#x0150;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0151;' title='U+0151'>&#x0151;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01A0;' title='U+01A0'>&#x01A0;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01A1;' title='U+01A1'>&#x01A1;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01D1;' title='U+01D1'>&#x01D1;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01D2;' title='U+01D2'>&#x01D2;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01EA;' title='U+01EA'>&#x01EA;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01EB;' title='U+01EB'>&#x01EB;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01EC;' title='U+01EC'>&#x01EC;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01ED;' title='U+01ED'>&#x01ED;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01FE;' title='U+01FE'>&#x01FE;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01FF;' title='U+01FF'>&#x01FF;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x020C;' title='U+020C'>&#x020C;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x020D;' title='U+020D'>&#x020D;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x020E;' title='U+020E'>&#x020E;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x020F;' title='U+020F'>&#x020F;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E50;' title='U+1E50'>&#x1E50;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E51;' title='U+1E51'>&#x1E51;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E52;' title='U+1E52'>&#x1E52;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E53;' title='U+1E53'>&#x1E53;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1ECC;' title='U+1ECC'>&#x1ECC;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1ECD;' title='U+1ECD'>&#x1ECD;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1ECE;' title='U+1ECE'>&#x1ECE;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1ECF;' title='U+1ECF'>&#x1ECF;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1ED0;' title='U+1ED0'>&#x1ED0;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1ED1;' title='U+1ED1'>&#x1ED1;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1ED2;' title='U+1ED2'>&#x1ED2;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1ED3;' title='U+1ED3'>&#x1ED3;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1ED4;' title='U+1ED4'>&#x1ED4;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1ED5;' title='U+1ED5'>&#x1ED5;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1ED6;' title='U+1ED6'>&#x1ED6;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1ED7;' title='U+1ED7'>&#x1ED7;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1ED8;' title='U+1ED8'>&#x1ED8;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1ED9;' title='U+1ED9'>&#x1ED9;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EDA;' title='U+1EDA'>&#x1EDA;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EDB;' title='U+1EDB'>&#x1EDB;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EDC;' title='U+1EDC'>&#x1EDC;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EDD;' title='U+1EDD'>&#x1EDD;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EDE;' title='U+1EDE'>&#x1EDE;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EDF;' title='U+1EDF'>&#x1EDF;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EE0;' title='U+1EE0'>&#x1EE0;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EE1;' title='U+1EE1'>&#x1EE1;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EE2;' title='U+1EE2'>&#x1EE2;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EE3;' title='U+1EE3'>&#x1EE3;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00D5;' title='U+00D5'>&#x00D5;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00F5;' title='U+00F5'>&#x00F5;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E4C;' title='U+1E4C'>&#x1E4C;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E4D;' title='U+1E4D'>&#x1E4D;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E4E;' title='U+1E4E'>&#x1E4E;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E4F;' title='U+1E4F'>&#x1E4F;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00D6;' title='U+00D6'>&#x00D6;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00F6;' title='U+00F6'>&#x00F6;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0050;' title='U+0050'>&#x0050;</span>"; //'P
    inssym = inssym + "<span class='mi_span' value='&#x0070;' title='U+0070'>&#x0070;</span>"; //'p
    inssym = inssym + "<span class='mi_span' value='&#x01A4;' title='U+01A4'>&#x01A4;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01A5;' title='U+01A5'>&#x01A5;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E54;' title='U+1E54'>&#x1E54;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E55;' title='U+1E55'>&#x1E55;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E56;' title='U+1E56'>&#x1E56;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E57;' title='U+1E57'>&#x1E57;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0051;' title='U+0051'>&#x0051;</span>"; //'Q
    inssym = inssym + "<span class='mi_span' value='&#x0071;' title='U+0071'>&#x0071;</span>"; //'q
    inssym = inssym + "<span class='mi_span' value='&#x0052;' title='U+0052'>&#x0052;</span>"; //'R
    inssym = inssym + "<span class='mi_span' value='&#x0072;' title='U+0072'>&#x0072;</span>"; //'r
    inssym = inssym + "<span class='mi_span' value='&#x0154;' title='U+0154'>&#x0154;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0155;' title='U+0155'>&#x0155;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0156;' title='U+0156'>&#x0156;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0157;' title='U+0157'>&#x0157;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0158;' title='U+0158'>&#x0158;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0159;' title='U+0159'>&#x0159;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0210;' title='U+0210'>&#x0210;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0211;' title='U+0211'>&#x0211;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0212;' title='U+0212'>&#x0212;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0213;' title='U+0213'>&#x0213;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E58;' title='U+1E58'>&#x1E58;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E59;' title='U+1E59'>&#x1E59;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E5A;' title='U+1E5A'>&#x1E5A;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E5B;' title='U+1E5B'>&#x1E5B;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E5C;' title='U+1E5C'>&#x1E5C;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E5D;' title='U+1E5D'>&#x1E5D;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E5E;' title='U+1E5E'>&#x1E5E;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E5F;' title='U+1E5F'>&#x1E5F;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0053;' title='U+0053'>&#x0053;</span>"; //'S
    inssym = inssym + "<span class='mi_span' value='&#x0073;' title='U+0073'>&#x0073;</span>"; //'s
    inssym = inssym + "<span class='mi_span' value='&#x015A;' title='U+015A'>&#x015A;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x015B;' title='U+015B'>&#x015B;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x015C;' title='U+015C'>&#x015C;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x015D;' title='U+015D'>&#x015D;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x015E;' title='U+015E'>&#x015E;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x015F;' title='U+015F'>&#x015F;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E60;' title='U+1E60'>&#x1E60;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E61;' title='U+1E61'>&#x1E61;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E62;' title='U+1E62'>&#x1E62;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E63;' title='U+1E63'>&#x1E63;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E64;' title='U+1E64'>&#x1E64;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E65;' title='U+1E65'>&#x1E65;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E68;' title='U+1E68'>&#x1E68;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E69;' title='U+1E69'>&#x1E69;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0160;' title='U+0160'>&#x0160;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0161;' title='U+0161'>&#x0161;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E66;' title='U+1E66'>&#x1E66;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E67;' title='U+1E67'>&#x1E67;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0054;' title='U+0054'>&#x0054;</span>"; //'T
    inssym = inssym + "<span class='mi_span' value='&#x0074;' title='U+0074'>&#x0074;</span>"; //'t
    inssym = inssym + "<span class='mi_span' value='&#x0162;' title='U+0162'>&#x0162;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0163;' title='U+0163'>&#x0163;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0164;' title='U+0164'>&#x0164;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0165;' title='U+0165'>&#x0165;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0166;' title='U+0166'>&#x0166;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0167;' title='U+0167'>&#x0167;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01AC;' title='U+01AC'>&#x01AC;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01AD;' title='U+01AD'>&#x01AD;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E6A;' title='U+1E6A'>&#x1E6A;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E6B;' title='U+1E6B'>&#x1E6B;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E6C;' title='U+1E6C'>&#x1E6C;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E6D;' title='U+1E6D'>&#x1E6D;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E6E;' title='U+1E6E'>&#x1E6E;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E6F;' title='U+1E6F'>&#x1E6F;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E70;' title='U+1E70'>&#x1E70;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E71;' title='U+1E71'>&#x1E71;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0055;' title='U+0055'>&#x0055;</span>"; //'U
    inssym = inssym + "<span class='mi_span' value='&#x0075;' title='U+0075'>&#x0075;</span>"; //'u
    inssym = inssym + "<span class='mi_span' value='&#x00D9;' title='U+00D9'>&#x00D9;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00F9;' title='U+00F9'>&#x00F9;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00DA;' title='U+00DA'>&#x00DA;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00FA;' title='U+00FA'>&#x00FA;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00DB;' title='U+00DB'>&#x00DB;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00FB;' title='U+00FB'>&#x00FB;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0168;' title='U+0168'>&#x0168;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0169;' title='U+0169'>&#x0169;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x016A;' title='U+016A'>&#x016A;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x016B;' title='U+016B'>&#x016B;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x016C;' title='U+016C'>&#x016C;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x016D;' title='U+016D'>&#x016D;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x016E;' title='U+016E'>&#x016E;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x016F;' title='U+016F'>&#x016F;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0170;' title='U+0170'>&#x0170;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0171;' title='U+0171'>&#x0171;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0172;' title='U+0172'>&#x0172;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0173;' title='U+0173'>&#x0173;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01AF;' title='U+01AF'>&#x01AF;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01B0;' title='U+01B0'>&#x01B0;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01D3;' title='U+01D3'>&#x01D3;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01D4;' title='U+01D4'>&#x01D4;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0214;' title='U+0214'>&#x0214;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0215;' title='U+0215'>&#x0215;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0216;' title='U+0216'>&#x0216;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0217;' title='U+0217'>&#x0217;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E72;' title='U+1E72'>&#x1E72;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E73;' title='U+1E73'>&#x1E73;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E74;' title='U+1E74'>&#x1E74;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E75;' title='U+1E75'>&#x1E75;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E76;' title='U+1E76'>&#x1E76;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E77;' title='U+1E77'>&#x1E77;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E78;' title='U+1E78'>&#x1E78;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E79;' title='U+1E79'>&#x1E79;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E7A;' title='U+1E7A'>&#x1E7A;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E7B;' title='U+1E7B'>&#x1E7B;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EE4;' title='U+1EE4'>&#x1EE4;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EE5;' title='U+1EE5'>&#x1EE5;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EE6;' title='U+1EE6'>&#x1EE6;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EE7;' title='U+1EE7'>&#x1EE7;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EE8;' title='U+1EE8'>&#x1EE8;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EE9;' title='U+1EE9'>&#x1EE9;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EEA;' title='U+1EEA'>&#x1EEA;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EEB;' title='U+1EEB'>&#x1EEB;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EEC;' title='U+1EEC'>&#x1EEC;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EED;' title='U+1EED'>&#x1EED;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EEE;' title='U+1EEE'>&#x1EEE;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EEF;' title='U+1EEF'>&#x1EEF;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EF0;' title='U+1EF0'>&#x1EF0;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EF1;' title='U+1EF1'>&#x1EF1;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00DC;' title='U+00DC'>&#x00DC;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00FC;' title='U+00FC'>&#x00FC;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01D5;' title='U+01D5'>&#x01D5;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01D6;' title='U+01D6'>&#x01D6;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01D7;' title='U+01D7'>&#x01D7;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01D8;' title='U+01D8'>&#x01D8;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01D9;' title='U+01D9'>&#x01D9;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01DA;' title='U+01DA'>&#x01DA;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01DB;' title='U+01DB'>&#x01DB;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01DC;' title='U+01DC'>&#x01DC;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0056;' title='U+0056'>&#x0056;</span>"; //'V
    inssym = inssym + "<span class='mi_span' value='&#x0076;' title='U+0076'>&#x0076;</span>"; //'v
    inssym = inssym + "<span class='mi_span' value='&#x1E7C;' title='U+1E7C'>&#x1E7C;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E7D;' title='U+1E7D'>&#x1E7D;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E7E;' title='U+1E7E'>&#x1E7E;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E7F;' title='U+1E7F'>&#x1E7F;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0057;' title='U+0057'>&#x0057;</span>"; //'W
    inssym = inssym + "<span class='mi_span' value='&#x0077;' title='U+0077'>&#x0077;</span>"; //'w
    inssym = inssym + "<span class='mi_span' value='&#x0174;' title='U+0174'>&#x0174;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0175;' title='U+0175'>&#x0175;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E80;' title='U+1E80'>&#x1E80;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E81;' title='U+1E81'>&#x1E81;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E82;' title='U+1E82'>&#x1E82;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E83;' title='U+1E83'>&#x1E83;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E84;' title='U+1E84'>&#x1E84;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E85;' title='U+1E85'>&#x1E85;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E86;' title='U+1E86'>&#x1E86;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E87;' title='U+1E87'>&#x1E87;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E88;' title='U+1E88'>&#x1E88;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E89;' title='U+1E89'>&#x1E89;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0058;' title='U+0058'>&#x0058;</span>"; //'X
    inssym = inssym + "<span class='mi_span' value='&#x0078;' title='U+0078'>&#x0078;</span>"; //'x
    inssym = inssym + "<span class='mi_span' value='&#x1E8A;' title='U+1E8A'>&#x1E8A;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E8B;' title='U+1E8B'>&#x1E8B;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E8C;' title='U+1E8C'>&#x1E8C;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E8D;' title='U+1E8D'>&#x1E8D;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0059;' title='U+0059'>&#x0059;</span>"; //'Y
    inssym = inssym + "<span class='mi_span' value='&#x0079;' title='U+0079'>&#x0079;</span>"; //'y
    inssym = inssym + "<span class='mi_span' value='&#x00DD;' title='U+00DD'>&#x00DD;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00FD;' title='U+00FD'>&#x00FD;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0176;' title='U+0176'>&#x0176;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0177;' title='U+0177'>&#x0177;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0178;' title='U+0178'>&#x0178;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00FF;' title='U+00FF'>&#x00FF;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01B3;' title='U+01B3'>&#x01B3;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01B4;' title='U+01B4'>&#x01B4;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E8E;' title='U+1E8E'>&#x1E8E;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E8F;' title='U+1E8F'>&#x1E8F;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EF2;' title='U+1EF2'>&#x1EF2;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EF3;' title='U+1EF3'>&#x1EF3;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EF4;' title='U+1EF4'>&#x1EF4;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EF5;' title='U+1EF5'>&#x1EF5;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EF6;' title='U+1EF6'>&#x1EF6;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EF7;' title='U+1EF7'>&#x1EF7;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EF8;' title='U+1EF8'>&#x1EF8;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1EF9;' title='U+1EF9'>&#x1EF9;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x005A;' title='U+005A'>&#x005A;</span>"; //'Z
    inssym = inssym + "<span class='mi_span' value='&#x007A;' title='U+007A'>&#x007A;</span>"; //'z
    inssym = inssym + "<span class='mi_span' value='&#x0179;' title='U+0179'>&#x0179;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x017A;' title='U+017A'>&#x017A;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x017B;' title='U+017B'>&#x017B;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x017C;' title='U+017C'>&#x017C;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01B5;' title='U+01B5'>&#x01B5;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01B6;' title='U+01B6'>&#x01B6;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E90;' title='U+1E90'>&#x1E90;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E91;' title='U+1E91'>&#x1E91;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E92;' title='U+1E92'>&#x1E92;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E93;' title='U+1E93'>&#x1E93;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E94;' title='U+1E94'>&#x1E94;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1E95;' title='U+1E95'>&#x1E95;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x017D;' title='U+017D'>&#x017D;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x017E;' title='U+017E'>&#x017E;</span>";
    //M - Z
    insert_latin_2.innerHTML = inssym

    inssym = "";
    //LIGATUURID
    inssym = inssym + "<div style='width:100%' class='md'>'" + MNU_INS_SYM_SYM_LIGATURES + "'</div>";
    inssym = inssym + "<span class='mi_span' value='&#x00C6;'>&#x00C6;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00E6;'>&#x00E6;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0132;'>&#x0132;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0133;'>&#x0133;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0152;'>&#x0152;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0153;'>&#x0153;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01C4;'>&#x01C4;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01C5;'>&#x01C5;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01C6;'>&#x01C6;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01C7;'>&#x01C7;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01C8;'>&#x01C8;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01C9;'>&#x01C9;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01CA;'>&#x01CA;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01CB;'>&#x01CB;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01CC;'>&#x01CC;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01E2;'>&#x01E2;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01E3;'>&#x01E3;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01F1;'>&#x01F1;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01F2;'>&#x01F2;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01F3;'>&#x01F3;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01FC;'>&#x01FC;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x01FD;'>&#x01FD;</span>";

    //sümbolid
    inssym = inssym + "<span class='mi_span' title='katus U+005E' value='" + CIRCUMFLEX + "'>" + CIRCUMFLEX + "</span>";
    inssym = inssym + "<span class='mi_span' title='graavis U+0060' value='" + GRAVE + "'>" + GRAVE + "</span>";
    inssym = inssym + "<span class='mi_span' title='tagurpidi hüüumärk U+00A1' value='" + INVERTED_EXCLAMATION + "'>" + INVERTED_EXCLAMATION + "</span>";
    inssym = inssym + "<span class='mi_span' title='sent U+00A2' value='" + CENT_SIGN + "'>" + CENT_SIGN + "</span>";
    inssym = inssym + "<span class='mi_span' title='jeen U+00A5' value='" + YEN_SIGN + "'>" + YEN_SIGN + "</span>";
    inssym = inssym + "<span class='mi_span' title='U+00A6' value='" + BROKEN_BAR + "'>" + BROKEN_BAR + "</span>";
    inssym = inssym + "<span class='mi_span' title='treema U+00A8' value='" + DIAERESIS + "'>" + DIAERESIS + "</span>";
    inssym = inssym + "<span class='mi_span' title='U+00A9' value='" + COPYRIGHT_SIGN + "'>" + COPYRIGHT_SIGN + "</span>";
    inssym = inssym + "<span class='mi_span' title='eitus U+00AC' value='" + NOT_SIGN + "'>" + NOT_SIGN + "</span>";
    inssym = inssym + "<span class='mi_span' title='U+00AE' value='" + REGISTERED_SIGN + "'>" + REGISTERED_SIGN + "</span>";
    inssym = inssym + "<span class='mi_span' title='makron U+00AF' value='" + MACRON + "'>" + MACRON + "</span>";
    inssym = inssym + "<span class='mi_span' title='kraad U+00B0' value='" + DEGREE_SIGN + "'>" + DEGREE_SIGN + "</span>";
    inssym = inssym + "<span class='mi_span' title='akuut U+00B4' value='" + ACUTE + "'>" + ACUTE + "</span>";
    inssym = inssym + "<span class='mi_span' title='mikro U+00B5' value='" + MICRO_SIGN + "'>" + MICRO_SIGN + "</span>";
    inssym = inssym + "<span class='mi_span' title='U+00B6' value='" + PILCROW_SIGN + "'>" + PILCROW_SIGN + "</span>";
    inssym = inssym + "<span class='mi_span' title='punkt keskel U+00B7' value='" + MIDDLE_DOT + "'>" + MIDDLE_DOT + "</span>";
    inssym = inssym + "<span class='mi_span' title='sedilla U+00B8' value='" + CEDILLA + "'>" + CEDILLA + "</span>";
    inssym = inssym + "<span class='mi_span' title='tagurpidi küsimärk U+00BF' value='" + INVERTED_QUESTION + "'>" + INVERTED_QUESTION + "</span>";
    inssym = inssym + "<span class='mi_span' title='korrutamismärk U+00D7' value='" + MULTIPLICATION_SIGN + "'>" + MULTIPLICATION_SIGN + "</span>";
    inssym = inssym + "<span class='mi_span' title='jagamismärk U+00F7' value='" + DIVISION_SIGN + "'>" + DIVISION_SIGN + "</span>"

    //veel sümboleid ...
    inssym = inssym + "<span class='mi_span' title='mõttekriips U+2013' value='" + EN_DASH + "'>" + EN_DASH + "</span>";
    inssym = inssym + "<span class='mi_span' title='mõttekriips akuudiga U+2013 U+0301' value='&#x2013;&#x0301;'>&#x2013;&#x0301;</span>";
    inssym = inssym + "<span class='mi_span' title='vasakpoolne ülakoma U+2018' value='" + LEFT_SINGLE_QUOTATION_MARK + "'>" + LEFT_SINGLE_QUOTATION_MARK + "</span>";
    inssym = inssym + "<span class='mi_span' title='parempoolne ülakoma U+2019' value='" + RIGHT_SINGLE_QUOTATION_MARK + "'>" + RIGHT_SINGLE_QUOTATION_MARK + "</span>";
    inssym = inssym + "<span class='mi_span' title='pistoda U+2020' value='&#x2020;'>&#x2020;</span>";
    inssym = inssym + "<span class='mi_span' title='topeltpistoda U+2021' value='&#x2021;'>&#x2021;</span>";
    inssym = inssym + "<span class='mi_span' title='vasakpoolne alumine jutumärk U+201E' value='" + DOUBLE_LOW9_QUOTATION_MARK + "'>" + DOUBLE_LOW9_QUOTATION_MARK + "</span>";
    inssym = inssym + "<span class='mi_span' title='parempoolne jutumärk U+201D' value='" + RIGHT_DOUBLE_QUOTATION_MARK + "'>" + RIGHT_DOUBLE_QUOTATION_MARK + "</span>";
    inssym = inssym + "<span class='mi_span' title='priim (minutid, jalad) U+2032' value='" + PRIME + "'>" + PRIME + "</span>";
    inssym = inssym + "<span class='mi_span' title='topeltpriim (sekundid, tollid) U+2033' value='" + DOUBLE_PRIME + "'>" + DOUBLE_PRIME + "</span>"

    inssym = inssym + "<span class='mi_span' title='Oom U+2126' value='" + OHM_SIGN + "'>" + OHM_SIGN + "</span>";
    inssym = inssym + "<span class='mi_span' title='Ongström U+212B' value='" + ANGSTROM_SIGN + "'>" + ANGSTROM_SIGN + "</span>"

    inssym = inssym + "<span class='mi_span' title='vasakule nool U+2190' value='" + LEFTWARDS_ARROW + "'>" + LEFTWARDS_ARROW + "</span>";
    inssym = inssym + "<span class='mi_span' title='üles nool U+2191' value='" + UPWARDS_ARROW + "'>" + UPWARDS_ARROW + "</span>";
    inssym = inssym + "<span class='mi_span' title='paremale nool U+2192' value='" + RIGHTWARDS_ARROW + "'>" + RIGHTWARDS_ARROW + "</span>";
    inssym = inssym + "<span class='mi_span' title='alla nool U+2193' value='" + DOWNWARDS_ARROW + "'>" + DOWNWARDS_ARROW + "</span>";
    inssym = inssym + "<span class='mi_span' title='väike suurtäht U U+1D1C' value='&#x1D1C;'>&#x1D1C;</span>";
    inssym = inssym + "<span class='mi_span' title='modif väike suurtäht U U+1D41' value='&#x1D41;'>&#x1D41;</span>";
    inssym = inssym + "<span class='mi_span' title='poolik o alumine U+1D17' value='&#x1D17;'>&#x1D17;</span>";
    inssym = inssym + "<span class='mi_span' title='modif poolik o alumine U+1D55' value='&#x1D55;'>&#x1D55;</span>";
    inssym = inssym + "<span class='mi_span' title='alakaar U+203F' value='&#x203F;'>&#x203F;</span>";
    inssym = inssym + "<span class='mi_span' title='naeratus U+2323' value='&#x2323;'>&#x2323;</span>";
    inssym = inssym + "<span class='mi_span' title='alumine pool ringist U+25E1' value='&#x25E1;'>&#x25E1;</span>";
    inssym = inssym + "<span class='mi_span' title='täpp U+2022' value='" + BULLET + "'>" + BULLET + "</span>";
    inssym = inssym + "<span class='mi_span' title='kolmnurkne täpp U+2023' value='" + TRIANGULAR_BULLET + "'>" + TRIANGULAR_BULLET + "</span>"

    inssym = inssym + "<span class='mi_span' title='must ruuduke U+25A0' value='&#x25A0;'>&#x25A0;</span>";
    inssym = inssym + "<span class='mi_span' title='valge ruuduke U+25A1' value='&#x25A1;'>&#x25A1;</span>";
    inssym = inssym + "<span class='mi_span' title='valge ruuduke ümarate nurkadega U+25A2' value='&#x25A2;'>&#x25A2;</span>";
    inssym = inssym + "<span class='mi_span' title='valge ruuduke väikese musta ruudukesega U+25A3' value='&#x25A3;'>&#x25A3;</span>";
    inssym = inssym + "<span class='mi_span' title='väike must ruuduke U+25AA' value='&#x25AA;'>&#x25AA;</span>";
    inssym = inssym + "<span class='mi_span' title='väike valge ruuduke U+25AB' value='&#x25AB;'>&#x25AB;</span>";
    inssym = inssym + "<span class='mi_span' title='must ristkülik U+25AC' value='&#x25AC;'>&#x25AC;</span>";
    inssym = inssym + "<span class='mi_span' title='valge ristkülik U+25AD' value='&#x25AD;'>&#x25AD;</span>";
    inssym = inssym + "<span class='mi_span' title='must vertikaalne ristkülik U+25AE' value='&#x25AE;'>&#x25AE;</span>";
    inssym = inssym + "<span class='mi_span' title='valge vertikaalne ristkülik U+25AF' value='&#x25AF;'>&#x25AF;</span>";
    inssym = inssym + "<span class='mi_span' title='must rööpkülik U+25B0' value='&#x25B0;'>&#x25B0;</span>";
    inssym = inssym + "<span class='mi_span' title='valge rööpkülik U+25B1' value='&#x25B1;'>&#x25B1;</span>";
    inssym = inssym + "<span class='mi_span' title='must tipuga üles kolmnurk U+25B2' value='&#x25B2;'>&#x25B2;</span>";
    inssym = inssym + "<span class='mi_span' title='valge tipuga üles kolmnurk U+25B3' value='&#x25B3;'>&#x25B3;</span>";
    inssym = inssym + "<span class='mi_span' title='valge tipuga paremale kolmnurk U+25B7' value='&#x25B7;'>&#x25B7;</span>";
    inssym = inssym + "<span class='mi_span' title='must tipuga paremale kolmnurk U+25BA' value='&#x25BA;'>&#x25BA;</span>";
    inssym = inssym + "<span class='mi_span' title='must tipuga alla kolmnurk U+25BC' value='&#x25BC;'>&#x25BC;</span>";
    inssym = inssym + "<span class='mi_span' title='valge tipuga alla kolmnurk U+25BD' value='&#x25BD;'>&#x25BD;</span>";
    inssym = inssym + "<span class='mi_span' title='valge tipuga vasakule kolmnurk U+25C1' value='&#x25C1;'>&#x25C1;</span>";
    inssym = inssym + "<span class='mi_span' title='must tipuga vasakule kolmnurk U+25C4' value='&#x25C4;'>&#x25C4;</span>";
    inssym = inssym + "<span class='mi_span' title='must ruutu U+25C6' value='&#x25C6;'>&#x25C6;</span>";
    inssym = inssym + "<span class='mi_span' title='valge ruutu U+25C7' value='&#x25C7;'>&#x25C7;</span>";
    inssym = inssym + "<span class='mi_span' title='seest tühi romb (Lozenge) U+25CA' value='&#x25CA;'>&#x25CA;</span>";
    inssym = inssym + "<span class='mi_span' title='seest tühi ring (White Circle) U+25CB' value='&#x25CB;'>&#x25CB;</span>";
    inssym = inssym + "<span class='mi_span' title='seest täis ring (Black Circle) U+25CF' value='&#x25CF;'>&#x25CF;</span>"

    inssym = inssym + "<span class='mi_span' title='pluss-miinus U+00B1' value='&#x00B1;'>&#x00B1;</span>";
    inssym = inssym + "<span class='mi_span' title='murrukriips U+2044' value='&#x2044;'>&#x2044;</span>";
    inssym = inssym + "<span class='mi_span' title='jagamiskriips U+2215' value='&#x2215;'>&#x2215;</span>";
    inssym = inssym + "<span class='mi_span' title='lõpmatus U+221E' value='&#x221E;'>&#x221E;</span>";
    inssym = inssym + "<span class='mi_span' title='kuulub U+2208' value='&#x2208;'>&#x2208;</span>";
    inssym = inssym + "<span class='mi_span' title='ei kuulu U+2209' value='&#x2209;'>&#x2209;</span>";
    inssym = inssym + "<span class='mi_span' title='MOTT U+220E' value='&#x220E;'>&#x220E;</span>";
    inssym = inssym + "<span class='mi_span' title='loogiline JA U+2227' value='&#x2227;'>&#x2227;</span>";
    inssym = inssym + "<span class='mi_span' title='loogiline VÕI U+2228' value='&#x2228;'>&#x2228;</span>";
    inssym = inssym + "<span class='mi_span' title='ühisosa U+2229' value='&#x2229;'>&#x2229;</span>";
    inssym = inssym + "<span class='mi_span' title='ühend U+222A' value='&#x222A;'>&#x222A;</span>";
    inssym = inssym + "<span class='mi_span' title='integraal U+222B' value='&#x222B;'>&#x222B;</span>";
    inssym = inssym + "<span class='mi_span' title='unaarne ühend U+22C3' value='&#x22C3;'>&#x22C3;</span>";
    inssym = inssym + "<span class='mi_span' title='suletud ühend U+2A4C' value='&#x2A4C;'>&#x2A4C;</span>";
    inssym = inssym + "<span class='mi_span' title='meetriline lühenduskaar U+23D1' value='&#x23D1;'>&#x23D1;</span>"

    inssym = inssym + "<span class='mi_span' title='radioaktiivne U+2622' value='&#x2622;'>&#x2622;</span>";
    inssym = inssym + "<span class='mi_span' title='sirp ja vasar U+262D' value='&#x262D;'>&#x262D;</span>";
    inssym = inssym + "<span class='mi_span' title='rahu U+262E' value='&#x262E;'>&#x262E;</span>";
    inssym = inssym + "<span class='mi_span' title='yin yang U+262F' value='&#x262F;'>&#x262F;</span>";
    inssym = inssym + "<span class='mi_span' title='Veenus U+2640' value='&#x2640;'>&#x2640;</span>";
    inssym = inssym + "<span class='mi_span' title='Marss U+2642' value='&#x2642;'>&#x2642;</span>";
    //inssym = inssym + "<span class='mi_span' title='valge kuningas U+2654' value='&#x2654;'>&#x2654;</span>"
    //inssym = inssym + "<span class='mi_span' title='valge lipp U+2655' value='&#x2655;'>&#x2655;</span>"
    //inssym = inssym + "<span class='mi_span' title='valge vanker U+2656' value='&#x2656;'>&#x2656;</span>"
    //inssym = inssym + "<span class='mi_span' title='valge oda U+2657' value='&#x2657;'>&#x2657;</span>"
    //inssym = inssym + "<span class='mi_span' title='valge ratsu U+2658' value='&#x2658;'>&#x2658;</span>"
    //inssym = inssym + "<span class='mi_span' title='valge ettur U+2659' value='&#x2659;'>&#x2659;</span>"
    //inssym = inssym + "<span class='mi_span' title='must kuningas U+265A' value='&#x265A;'>&#x265A;</span>"
    //inssym = inssym + "<span class='mi_span' title='must lipp U+265B' value='&#x265B;'>&#x265B;</span>"
    //inssym = inssym + "<span class='mi_span' title='must vanker U+265C' value='&#x265C;'>&#x265C;</span>"
    //inssym = inssym + "<span class='mi_span' title='must oda U+265D' value='&#x265D;'>&#x265D;</span>"
    //inssym = inssym + "<span class='mi_span' title='must ratsu U+265E' value='&#x265E;'>&#x265E;</span>"
    //inssym = inssym + "<span class='mi_span' title='must ettur U+265F' value='&#x265F;'>&#x265F;</span>"

    inssym = inssym + "<span class='mi_span' title='must poti mast U+2660' value='&#x2660;'>&#x2660;</span>";
    inssym = inssym + "<span class='mi_span' title='valge ärtu mast U+2661' value='&#x2661;'>&#x2661;</span>";
    inssym = inssym + "<span class='mi_span' title='valge ruutu mast U+2662' value='&#x2662;'>&#x2662;</span>";
    inssym = inssym + "<span class='mi_span' title='must risti mast U+2663' value='&#x2663;'>&#x2663;</span>"

    inssym = inssym + "<span class='mi_span' title='veerandnoot U+2669' value='&#x2669;'>&#x2669;</span>";
    inssym = inssym + "<span class='mi_span' title='kaheksandiknoot U+266A' value='&#x266A;'>&#x266A;</span>";
    inssym = inssym + "<span class='mi_span' title='kaheksandikud U+266B' value='&#x266B;'>&#x266B;</span>";
    inssym = inssym + "<span class='mi_span' title='kuueteistkümnendikud U+266C' value='&#x266C;'>&#x266C;</span>";
    inssym = inssym + "<span class='mi_span' title='bemoll U+266D' value='&#x266D;'>&#x266D;</span>";
    inssym = inssym + "<span class='mi_span' title='bekaar U+266E' value='&#x266E;'>&#x266E;</span>";
    inssym = inssym + "<span class='mi_span' title='diees U+266F' value='&#x266F;'>&#x266F;</span>"

    //inssym = inssym + "<span class='mi_span' title='breevis U+02D8' value='&#x02D8;'>&#x02D8;</span>"
    //inssym = inssym + "<span class='mi_span' title='makron akuudiga U+02C9 U+0301' value='&#x02C9;&#x0301;'>&#x02C9;&#x0301;</span>"


    //inssym = inssym + "<span class='mi_span' title='g-võti U+1D11E [font-family:symbola]' value='&#x1D11E;' style='font-family:symbola'>&#x1D11E;</span>"
    inssym = inssym + "<span class='mi_span' title='U+1D11F [font-family:symbola] g clef' value='&gclef;' style='font-family:symbola'>&#x1D11E;</span>"

    //inssym = inssym + "<span class='mi_span' title='U+1D11F [font-family:symbola]' value='&#x1D11F;' style='font-family:symbola'>&#x1D11F;</span>"
    inssym = inssym + "<span class='mi_span' title='U+1D11F [font-family:symbola] g clef ottava alta' value='&gclefottavaalta;' style='font-family:symbola'>&#x1D11F;</span>"

    //inssym = inssym + "<span class='mi_span' title='U+1D120 [font-family:symbola]' value='&#x1D120;' style='font-family:symbola'>&#x1D120;</span>"
    inssym = inssym + "<span class='mi_span' title='U+1D11F [font-family:symbola] g clef ottava bassa' value='&gclefottavabassa;' style='font-family:symbola'>&#x1D120;</span>"

    //inssym = inssym + "<span class='mi_span' title='U+1D121 [font-family:symbola]' value='&#x1D121;' style='font-family:symbola'>&#x1D121;</span>"
    inssym = inssym + "<span class='mi_span' title='U+1D11F [font-family:symbola] c clef' value='&cclef;' style='font-family:symbola'>&#x1D121;</span>"

    //inssym = inssym + "<span class='mi_span' title='U+1D122 [font-family:symbola]' value='&#x1D122;' style='font-family:symbola'>&#x1D122;</span>"
    inssym = inssym + "<span class='mi_span' title='U+1D11F [font-family:symbola] f clef' value='&fclef;' style='font-family:symbola'>&#x1D122;</span>"

    //inssym = inssym + "<span class='mi_span' title='U+1D123 [font-family:symbola]' value='&#x1D123;' style='font-family:symbola'>&#x1D123;</span>"
    inssym = inssym + "<span class='mi_span' title='U+1D11F [font-family:symbola] f clef ottava alta' value='&fclefottavaalta;' style='font-family:symbola'>&#x1D123;</span>"

    //inssym = inssym + "<span class='mi_span' title='U+1D124 [font-family:symbola]' value='&#x1D124;' style='font-family:symbola'>&#x1D124;</span>"
    inssym = inssym + "<span class='mi_span' title='U+1D11F [font-family:symbola] f clef ottava bassa' value='&fclefottavabassa;' style='font-family:symbola'>&#x1D124;</span>"

    //inssym = inssym + "<span class='mi_span' title='U+1D125 [font-family:symbola]' value='&#x1D125;' style='font-family:symbola'>&#x1D125;</span>"
    inssym = inssym + "<span class='mi_span' title='U+1D11F [font-family:symbola] drum clef 1' value='+drumclef1;' style='font-family:symbola'>&#x1D125;</span>"

    //inssym = inssym + "<span class='mi_span' title='U+1D126 [font-family:symbola]' value='&#x1D126;' style='font-family:symbola'>&#x1D126;</span>"
    inssym = inssym + "<span class='mi_span' title='U+1D11F [font-family:symbola] drum clef 2' value='+drumclef2;' style='font-family:symbola'>&#x1D126;</span>"

    //inssym = inssym + "<span class='mi_span' title='fermaat U+1D110 [font-family:symbola]' value='&#x1D110;' style='font-family:symbola'>&#x1D110;</span>"
    inssym = inssym + "<span class='mi_span' title='fermaat U+1D110 [font-family:symbola] fermata' value='&fermata;' style='font-family:symbola'>&#x1D110;</span>";
    //1D10B = D834, DD0B
    //inssym = inssym + "<span class='mi_span' title='segno U+1D10B [font-family:symbola]' value='&#x1D10B;' style='font-family:symbola'>&#x1D10B;</span>"
    inssym = inssym + "<span class='mi_span' title='segno U+1D10B [font-family:symbola] segno' value='&segno;' style='font-family:symbola'>&#x1D10B;</span>"

    //Margiti soovitud WingDings fondi asjad (lähendatud Unicode-le) 05. juuni 2011
    inssym = inssym + "<span class='mi_span' title='üles paremale suunatud pliiats U+2710' value='&#x2710;'>&#x2710;</span>";
    inssym = inssym + "<span class='mi_span' title='valged käärid U+2704' value='&#x2704;'>&#x2704;</span>";
    inssym = inssym + "<span class='mi_span' title='ümbrik U+2709' value='&#x2709;'>&#x2709;</span>";
    inssym = inssym + "<span class='mi_span' title='liivakell U+231B' value='&#x231B;'>&#x231B;</span>";
    inssym = inssym + "<span class='mi_span' title='kirjutav käsi U+270D' value='&#x270D;'>&#x270D;</span>";
    inssym = inssym + "<span class='mi_span' title='valge paremale suunatud nimetissõrm U+261E' value='&#x261E;'>&#x261E;</span>";
    inssym = inssym + "<span class='mi_span' title='valge hapu nägu U+2639' value='&#x2639;'>&#x2639;</span>";
    inssym = inssym + "<span class='mi_span' title='valge naeratav nägu U+263A' value='&#x263A;'>&#x263A;</span>";
    inssym = inssym + "<span class='mi_span' title='valge kiirtega päike U+263C' value='&#x263C;'>&#x263C;</span>";
    inssym = inssym + "<span class='mi_span' title='lumehelves U+2744' value='&#x2744;'>&#x2744;</span>";
    inssym = inssym + "<span class='mi_span' title='huviväärsus U+2318' value='&#x2318;'>&#x2318;</span>";
    inssym = inssym + "<span class='mi_span' title='ringikujuline mustal taustal paremale nool U+27B2' value='&#x27B2;'>&#x27B2;</span>";
    inssym = inssym + "<span class='mi_span' title='topeltnool vasakule U+21D0' value='&#x21D0;'>&#x21D0;</span>";
    inssym = inssym + "<span class='mi_span' title='topeltnool üles U+21D1' value='&#x21D1;'>&#x21D1;</span>";
    inssym = inssym + "<span class='mi_span' title='topeltnool paremale U+21D2' value='&#x21D2;'>&#x21D2;</span>";
    inssym = inssym + "<span class='mi_span' title='topeltnool alla U+21D3' value='&#x21D3;'>&#x21D3;</span>";
    inssym = inssym + "<span class='mi_span' title='topeltnool vasakule, paremale U+21D4' value='&#x21D4;'>&#x21D4;</span>";
    inssym = inssym + "<span class='mi_span' title='linnukesega märkeruut U+2611' value='&#x2611;'>&#x2611;</span>";
    inssym = inssym + "<span class='mi_span' title='tagurpidi väike v U+028C' value='&#x028C;'>&#x028C;</span>";
    inssym = inssym + "<span class='mi_span' title='väike kreeka lambda suurtäht U+1D27' value='&#x1D27;'>&#x1D27;</span>";
    insert_marks.innerHTML = inssym

    inssym = "";
    inssym = inssym + "<div style='width:100%' class='md'>'" + MNU_INS_SYM_COMB_SYM + "'</div>";
    inssym = inssym + "<span class='mi_span' title='komb. graavis U+0300' value='" + COMBINING_GRAVE + "'>" + COMBINING_GRAVE + "</span>";
    inssym = inssym + "<span class='mi_span' title='komb. akuut U+0301' value='" + COMBINING_ACUTE + "'>" + COMBINING_ACUTE + "</span>";
    inssym = inssym + "<span class='mi_span' title='komb. katus U+0302' value='" + COMBINING_CIRCUMFLEX + "'>" + COMBINING_CIRCUMFLEX + "</span>";
    inssym = inssym + "<span class='mi_span' title='komb. tilde U+0303' value='" + COMBINING_TILDE + "'>" + COMBINING_TILDE + "</span>";
    inssym = inssym + "<span class='mi_span' title='komb. makron U+0304' value='" + COMBINING_MACRON + "'>" + COMBINING_MACRON + "</span>";
    inssym = inssym + "<span class='mi_span' title='komb. ülajoon U+0305' value='" + COMBINING_OVERLINE + "'>" + COMBINING_OVERLINE + "</span>";
    inssym = inssym + "<span class='mi_span' title='komb. kaar U+0306' value='" + COMBINING_BREVE + "'>" + COMBINING_BREVE + "</span>";
    inssym = inssym + "<span class='mi_span' title='komb. ülapunkt U+0307' value='" + COMBINING_DOT_ABOVE + "'>" + COMBINING_DOT_ABOVE + "</span>";
    inssym = inssym + "<span class='mi_span' title='komb. treema U+0308' value='" + COMBINING_DIAERESIS + "'>" + COMBINING_DIAERESIS + "</span>";
    inssym = inssym + "<span class='mi_span' title='komb. kolmveerandpikkus U+1DFE' value='&#x1DFE;'>&#x1DFE;</span>";
    for (ixCode = 777; ixCode <= 879; ixCode++) {
        hex4Nr = jsStrRepeat(4 - hex(ixCode, true).constructor, "0") + hex(ixCode, true);
        inssym = inssym + "<span class='mi_span' title=' U+" + hex4Nr + "' value='&#x" + hex4Nr + ";'>&#x" + hex4Nr + ";</span>";
    }
    insert_combin.innerHTML = inssym

    inssym = "";
    inssym = inssym + "<div style='width:100%' class='md'>'" + MNU_INS_SYM_GREEK + "'</div>";
    inssym = inssym + "<span class='mi_span' title='Alfa' value='&Alpha;'>&Alpha;</span>";
    inssym = inssym + "<span class='mi_span' title='alfa' value='&alpha;'>&alpha;</span>";
    inssym = inssym + "<span class='mi_span' title='Beeta' value='&Beta;'>&Beta;</span>";
    inssym = inssym + "<span class='mi_span' title='beeta' value='&beta;'>&beta;</span>";
    inssym = inssym + "<span class='mi_span' title='Gamma' value='&Gamma;'>&Gamma;</span>";
    inssym = inssym + "<span class='mi_span' title='gamma' value='&gamma;'>&gamma;</span>";
    inssym = inssym + "<span class='mi_span' title='Delta' value='&Delta;'>&Delta;</span>";
    inssym = inssym + "<span class='mi_span' title='delta' value='&delta;'>&delta;</span>";
    inssym = inssym + "<span class='mi_span' title='Epsilon' value='&Epsilon;'>&Epsilon;</span>";
    inssym = inssym + "<span class='mi_span' title='epsilon' value='&epsilon;'>&epsilon;</span>";
    inssym = inssym + "<span class='mi_span' title='Dzeeta' value='&Zeta;'>&Zeta;</span>";
    inssym = inssym + "<span class='mi_span' title='dzeeta' value='&zeta;'>&zeta;</span>";
    inssym = inssym + "<span class='mi_span' title='Eeta' value='&Eta;'>&Eta;</span>";
    inssym = inssym + "<span class='mi_span' title='eeta' value='&eta;'>&eta;</span>";
    inssym = inssym + "<span class='mi_span' title='Teeta' value='&Theta;'>&Theta;</span>";
    inssym = inssym + "<span class='mi_span' title='teeta' value='&theta;'>&theta;</span>";
    inssym = inssym + "<span class='mi_span' title='Ioota' value='&Iota;'>&Iota;</span>";
    inssym = inssym + "<span class='mi_span' title='ioota' value='&iota;'>&iota;</span>";
    inssym = inssym + "<span class='mi_span' title='Kapa' value='&Kappa;'>&Kappa;</span>";
    inssym = inssym + "<span class='mi_span' title='kapa' value='&kappa;'>&kappa;</span>";
    inssym = inssym + "<span class='mi_span' title='Lambda' value='&Lambda;'>&Lambda;</span>";
    inssym = inssym + "<span class='mi_span' title='lambda' value='&lambda;'>&lambda;</span>";
    inssym = inssym + "<span class='mi_span' title='Müü' value='&Mu;'>&Mu;</span>";
    inssym = inssym + "<span class='mi_span' title='müü' value='&mu;'>&mu;</span>";
    inssym = inssym + "<span class='mi_span' title='Nüü' value='&Nu;'>&Nu;</span>";
    inssym = inssym + "<span class='mi_span' title='nüü' value='&nu;'>&nu;</span>";
    inssym = inssym + "<span class='mi_span' title='Ksii' value='&Xi;'>&Xi;</span>";
    inssym = inssym + "<span class='mi_span' title='ksii' value='&xi;'>&xi;</span>";
    inssym = inssym + "<span class='mi_span' title='Omikron' value='&Omicron;'>&Omicron;</span>";
    inssym = inssym + "<span class='mi_span' title='omikron' value='&omicron;'>&omicron;</span>";
    inssym = inssym + "<span class='mi_span' title='Pii' value='&Pi;'>&Pi;</span>";
    inssym = inssym + "<span class='mi_span' title='pii' value='&pi;'>&pi;</span>";
    inssym = inssym + "<span class='mi_span' title='Roo' value='&Rho;'>&Rho;</span>";
    inssym = inssym + "<span class='mi_span' title='roo' value='&rho;'>&rho;</span>";
    inssym = inssym + "<span class='mi_span' title='Sigma' value='&Sigma;'>&Sigma;</span>";
    inssym = inssym + "<span class='mi_span' title='sigma' value='&sigma;'>&sigma;</span>";
    inssym = inssym + "<span class='mi_span' title='Tau' value='&Tau;'>&Tau;</span>";
    inssym = inssym + "<span class='mi_span' title='tau' value='&tau;'>&tau;</span>";
    inssym = inssym + "<span class='mi_span' title='Üpsilon' value='&Upsilon;'>&Upsilon;</span>";
    inssym = inssym + "<span class='mi_span' title='üpsilon' value='&upsilon;'>&upsilon;</span>";
    inssym = inssym + "<span class='mi_span' title='Fii' value='&Phi;'>&Phi;</span>";
    inssym = inssym + "<span class='mi_span' title='fii' value='&phi;'>&phi;</span>";
    inssym = inssym + "<span class='mi_span' title='Hii' value='&Chi;'>&Chi;</span>";
    inssym = inssym + "<span class='mi_span' title='hii' value='&chi;'>&chi;</span>";
    inssym = inssym + "<span class='mi_span' title='Psii' value='&Psi;'>&Psi;</span>";
    inssym = inssym + "<span class='mi_span' title='psii' value='&psi;'>&psi;</span>";
    inssym = inssym + "<span class='mi_span' title='Oomega' value='&Omega;'>&Omega;</span>";
    inssym = inssym + "<span class='mi_span' title='oomega' value='&omega;'>&omega;</span>";
    insert_greek.innerHTML = inssym

    inssym = "";
    inssym = inssym + "<div style='width:100%' class='md'>'" + MNU_INS_SYM_CYRILLIC + "'</div>";
    inssym = inssym + "<span class='mi_span' value='&#x0410;' title='U+0410'>&#x0410;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0430;' title='U+0430'>&#x0430;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0411;' title='U+0411'>&#x0411;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0431;' title='U+0431'>&#x0431;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0412;' title='U+0412'>&#x0412;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0432;' title='U+0432'>&#x0432;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0413;' title='U+0413'>&#x0413;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0433;' title='U+0433'>&#x0433;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0414;' title='U+0414'>&#x0414;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0434;' title='U+0434'>&#x0434;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0415;' title='U+0415'>&#x0415;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0435;' title='U+0435'>&#x0435;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0401;' title='U+0401'>&#x0401;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0451;' title='U+0451'>&#x0451;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0416;' title='U+0416'>&#x0416;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0436;' title='U+0436'>&#x0436;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0417;' title='U+0417'>&#x0417;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0437;' title='U+0437'>&#x0437;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0418;' title='U+0418'>&#x0418;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0438;' title='U+0438'>&#x0438;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0419;' title='U+0419'>&#x0419;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0439;' title='U+0439'>&#x0439;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x041A;' title='U+041A'>&#x041A;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x043A;' title='U+043A'>&#x043A;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x041B;' title='U+041B'>&#x041B;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x043B;' title='U+043B'>&#x043B;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x041C;' title='U+041C'>&#x041C;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x043C;' title='U+043C'>&#x043C;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x041D;' title='U+041D'>&#x041D;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x043D;' title='U+043D'>&#x043D;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x041E;' title='U+041E'>&#x041E;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x043E;' title='U+043E'>&#x043E;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x041F;' title='U+041F'>&#x041F;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x043F;' title='U+043F'>&#x043F;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0420;' title='U+0420'>&#x0420;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0440;' title='U+0440'>&#x0440;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0421;' title='U+0421'>&#x0421;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0441;' title='U+0441'>&#x0441;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0422;' title='U+0422'>&#x0422;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0442;' title='U+0442'>&#x0442;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0423;' title='U+0423'>&#x0423;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0443;' title='U+0443'>&#x0443;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0424;' title='U+0424'>&#x0424;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0444;' title='U+0444'>&#x0444;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0425;' title='U+0425'>&#x0425;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0445;' title='U+0445'>&#x0445;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0426;' title='U+0426'>&#x0426;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0446;' title='U+0446'>&#x0446;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0427;' title='U+0427'>&#x0427;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0447;' title='U+0447'>&#x0447;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0428;' title='U+0428'>&#x0428;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0448;' title='U+0448'>&#x0448;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0429;' title='U+0429'>&#x0429;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0449;' title='U+0449'>&#x0449;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x042A;' title='U+042A'>&#x042A;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x044A;' title='U+044A'>&#x044A;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x042B;' title='U+042B'>&#x042B;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x044B;' title='U+044B'>&#x044B;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x042C;' title='U+042C'>&#x042C;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x044C;' title='U+044C'>&#x044C;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x042D;' title='U+042D'>&#x042D;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x044D;' title='U+044D'>&#x044D;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x042E;' title='U+042E'>&#x042E;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x044E;' title='U+044E'>&#x044E;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x042F;' title='U+042F'>&#x042F;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x044F;' title='U+044F'>&#x044F;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0462;' title='suur jätt U+0462'>&#x0462;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0463;' title='väike jätt U+0463'>&#x0463;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0406;' title='suur I U+0406'>&#x0406;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0456;' title='väike I U+0456'>&#x0456;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0472;' title='suur fita U+0472'>&#x0472;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0473;' title='väike fita U+0473'>&#x0473;</span>";
    insert_cyrillic.innerHTML = inssym

    inssym = "";
    inssym = inssym + "<div style='width:100%' class='md'>'" + MNU_INS_SYM_UDMURTIAN + "'</div>";
    inssym = inssym + "<span class='mi_span' value='&#x04DC;' title='U+04DC'>&#x04DC;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x04DD;' title='U+04DD'>&#x04DD;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x04DE;' title='U+04DE'>&#x04DE;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x04DF;' title='U+04DF'>&#x04DF;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x04E4;' title='U+04E4'>&#x04E4;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x04E5;' title='U+04E5'>&#x04E5;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x04F4;' title='U+04F4'>&#x04F4;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x04F5;' title='U+04F5'>&#x04F5;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x04E6;' title='U+04E6'>&#x04E6;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x04E7;' title='U+04E7'>&#x04E7;</span>";
    insert_udmurtian.innerHTML = inssym

    inssym = "";
    inssym = inssym + "<div style='width:100%' class='md'>'" + MNU_INS_SYM_MARI + "'</div>";
    inssym = inssym + "<span class='mi_span' value='&#x04A4;' title='CYRILLIC CAPITAL LIGATURE EN GHE - U+04A4'>&#x04A4;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x04A5;' title='CYRILLIC SMALL LIGATURE EN GHE - U+04A5'>&#x04A5;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x04E6;' title='CYRILLIC CAPITAL LETTER O WITH DIAERESIS - U+04E6'>&#x04E6;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x04E7;' title='CYRILLIC SMALL LETTER O WITH DIAERESIS - U+04E7'>&#x04E7;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x04F0;' title='CYRILLIC CAPITAL LETTER U WITH DIAERESIS - U+04F0'>&#x04F0;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x04F1;' title='CYRILLIC SMALL LETTER U WITH DIAERESIS - U+04F1'>&#x04F1;</span>";
    insert_mari.innerHTML = inssym

    inssym = "";
    inssym = inssym + "<div style='width:100%' class='md'>'" + MNU_INS_SYM_PRONUNCIATION + "'</div>";
    inssym = inssym + "<span class='mi_span' value='&#x1D9E;' title='modif väike eeta U+1D9E'>&#x1D9E;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x00F0;' title='väike eeta U+00F0'>&#x00F0;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1D4A;' title='modif väike šva U+1D4A'>&#x1D4A;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0259;' title='väike šva U+0259'>&#x0259;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1D51;' title='modif väike ng U+1D51'>&#x1D51;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x014B;' title='väike ng U+014B'>&#x014B;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0275;' title='väike pulgaga o U+0275'>&#x0275;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1DBF;' title='modif väike teeta U+1DBF'>&#x1DBF;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x03B8;' title='väike teeta U+03B8'>&#x03B8;</span>";
    inssym = inssym + "<span class='mi_span' value='(n)' title='eelneva täishääliku ninahääldus'>(n)</span>";
    inssym = inssym + "<span class='mi_span' value='(r)' title='nõrgalt häälduv r (pms ingl)'>(r)</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0299;' title='kapiteel-B U+0299'>&#x0299;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1D05;' title='kapiteel-D U+1D05'>&#x1D05;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0262;' title='kapiteel-G U+0262'>&#x0262;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1D0D;' title='kapiteel-M U+1D0D'>&#x1D0D;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0274;' title='kapiteel-N U+0274'>&#x0274;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0280;' title='kapiteel-R U+0280'>&#x0280;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1D22;' title='kapiteel-Z U+1D22'>&#x1D22;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0254;' title='lahtine o U+0254'>&#x0254;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x0250;' title='kummuli a U+0250'>&#x0250;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x1D43;' title='üla-a U+1D43'>&#x1D43;</span>";
    inssym = inssym + "<span class='mi_span' value='&#x02DB;' title='ogonek U+02DB'>&#x02DB;</span>";
    insert_pronunc.innerHTML = inssym

    inssym = "";
    inssym = inssym + "<div style='width:100%' class='md'>'" + MNU_INS_SYM_ETHYMOLOGY + "'</div>";
    inssym = inssym + "<span class='mi_span' title='a ringi ja makroniga' value='&#x00E5;&#x0304;'>&#x00E5;&#x0304;</span>";
    inssym = inssym + "<span class='mi_span' title='pööratud e U+01DD' value='&#x01DD;'>&#x01DD;</span>";
    inssym = inssym + "<span class='mi_span' title='pööratud e ülakaarega' value='ə̑'>ə̑</span>";
    inssym = inssym + "<span class='mi_span' title='e alakaarega' value='e̮'>e̮</span>";
    inssym = inssym + "<span class='mi_span' title='i alakaarega' value='i̮'>i̮</span>";
    inssym = inssym + "<span class='mi_span' title='ezh karoniga' value='" + String.fromCharCode(0x01EF) + "'>" + String.fromCharCode(0x01EF) + "</span>"; //'väike ezh;
    inssym = inssym + "<span class='mi_span' title='ezh' value='" + String.fromCharCode(0x0292) + "'>" + String.fromCharCode(0x0292) + "</span>"; //'väike ezh;
    inssym = inssym + "<span class='mi_span' title='ezh karoni ja akuudiga' value='" + String.fromCharCode(0x01EF) + String.fromCharCode(0x0301) + "' style='width:48px;'>" + String.fromCharCode(0x01EF) + String.fromCharCode(0x0301) + "</span>"; //'väike ezh + kombineeruv;
    inssym = inssym + "<span class='mi_span' title='ezh akuudiga' value='" + String.fromCharCode(0x0292) + String.fromCharCode(0x0301) + "' style='width:48px;'>" + String.fromCharCode(0x0292) + String.fromCharCode(0x0301) + "</span>";
    inssym = inssym + "<span class='mi_span' title='e vasakule poole nooleotsaga all' value='e" + String.fromCharCode(0x0354) + "'>e" + String.fromCharCode(0x0354) + "</span>";
    inssym = inssym + "<span class='mi_span' title='i vasakule poole nooleotsaga all' value='i" + String.fromCharCode(0x0354) + "'>i" + String.fromCharCode(0x0354) + "</span>";
    inssym = inssym + "<span class='mi_span' title='e paremale poole nooleotsaga all' value='e" + String.fromCharCode(0x0355) + "'>e" + String.fromCharCode(0x0355) + "</span>";
    inssym = inssym + "<span class='mi_span' title='i paremale poole nooleotsaga all' value='i" + String.fromCharCode(0x0355) + "'>i" + String.fromCharCode(0x0355) + "</span>";
    inssym = inssym + "<span class='mi_span' title='kõrisulghäälik  U+0294' value='&#x0294;'>&#x0294;</span>";
    inssym = inssym + "<span class='mi_span' title='õ tsirkumfleksiga all' value='õ" + String.fromCharCode(0x032D) + "'>õ" + String.fromCharCode(0x032D) + "</span>";
    inssym = inssym + "<span class='mi_span' title='þ' value='þ'>þ</span>";
    inssym = inssym + "<span class='mi_span' title='ß' value='ß'>ß</span>";
    inssym = inssym + "<span class='mi_span' title='Latin capital letter B with stroke' value='Ƀ'>&#x0243;</span>";
    inssym = inssym + "<span class='mi_span' title='Latin small letter B with stroke' value='ƀ'>&#x0180;</span>";
    insert_etymology.innerHTML = inssym;
} //FillInsertSymbolsMenu;
