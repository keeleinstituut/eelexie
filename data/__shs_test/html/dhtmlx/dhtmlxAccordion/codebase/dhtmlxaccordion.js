//v.3.0 build 110713

/*
Copyright DHTMLX LTD. http://www.dhtmlx.com
You allowed to use this component or parts of it under GPL terms
To use it on other terms or get Professional edition of the component please contact us at sales@dhtmlx.com
*/
function dhtmlXAccordionItem(){}
function dhtmlXAccordion(f,h){if(window.dhtmlXContainer){var e=this;this.skin=h!=null?h:"dhx_skyblue";if(f==document.body){this._isAccFS=!0;document.body.className+=" dhxacc_fullscreened";var g=document.createElement("DIV");g.className="dhxcont_global_layout_area";f.appendChild(g);this.cont=new dhtmlXContainer(f);this.cont.setContent(g);f.adjustContent(f,0);this.base=document.createElement("DIV");this.base.className="dhx_acc_base_"+this.skin;this.base.style.overflow="hidden";this.base.style.position=
"absolute";this._adjustToFullScreen=function(){this.base.style.left="2px";this.base.style.top="2px";this.base.style.width=parseInt(g.childNodes[0].style.width)-4+"px";this.base.style.height=parseInt(g.childNodes[0].style.height)-4+"px"};this._adjustToFullScreen();g.childNodes[0].appendChild(this.base);this._resizeTM=null;this._resizeTMTime=400;this._doOnResize=function(){window.clearTimeout(e._resizeTM);e._resizeTM=window.setTimeout(function(){e._adjustAccordion()},e._resizeTMTime)};this._adjustAccordion=
function(){document.body.adjustContent(document.body,0);this._adjustToFullScreen();this.setSizes()};dhtmlxEvent(window,"resize",this._doOnResize)}else this.base=typeof f=="string"?document.getElementById(f):f,this.base.className="dhx_acc_base_"+this.skin,this.base.innerHTML="";this.w=this.base.offsetWidth;this.h=this.base.offsetHeight;this.skinParams={dhx_blue:{cell_height:24,cell_space:1,content_offset:1},dhx_skyblue:{cell_height:27,cell_space:-1,content_offset:-1},dhx_black:{cell_height:24,cell_space:1,
content_offset:1},dhx_web:{cell_height:26,cell_space:9,content_offset:0,cell_pading_max:1,cell_pading_min:0}};this.sk=this.skinParams[this.skin];this.setSkinParameters=function(a,b){isNaN(a)||(this.sk.cell_space=a);isNaN(b)||(this.sk.content_offset=b);this._reopenItem()};this.setSkin=function(a){if(this.skinParams[a]){this.skin=a;this.sk=this.skinParams[this.skin];this.base.className="dhx_acc_base_"+this.skin+(this._r?" dhx_acc_rtl":"");for(var b in this.idPull)this.idPull[b].skin=this.skin;this._reopenItem()}};
this.idPull={};this.opened=null;this.cells=function(a){return this.idPull[a]==null?null:this.idPull[a]};this.itemH=90;this.multiMode=!1;this.enableMultiMode=function(){var a=0,b;for(b in this.idPull)a++;if(a==0)this.userOffset||(this.skinParams.dhx_skyblue.cell_space=3),this.multiMode=!0};this.userOffset=!1;this.setOffset=function(a,b){this.userOffset=!0;isNaN(a)||(this.skinParams[this.skin].cell_space=a);isNaN(b)||(this.skinParams[this.skin].content_offset=b);this.setSizes()};this.imagePath="";this.setIconsPath=
function(a){this.imagePath=a};this.addItem=function(a,b){var c=document.createElement("DIV");c.className="dhx_acc_item";c.dir="ltr";c._isAcc=!0;c.skin=this.skin;this.base.appendChild(c);if(this.multiMode)c.h=this.itemH;var d=document.createElement("DIV");d._idd=a;d.className="dhx_acc_item_label";d.innerHTML="<span>"+b+"</span><div class='dhx_acc_item_label_btmbrd'>&nbsp;</div><div class='dhx_acc_item_arrow'></div><div class='dhx_acc_hdr_line_l'></div><div class='dhx_acc_hdr_line_r'></div>";d.onselectstart=
function(a){a=a||event;a.returnValue=!1};d.onclick=function(){if(e.multiMode||!e.idPull[this._idd]._isActive)e.multiMode?e.idPull[this._idd]._isActive?e.checkEvent("onBeforeActive")?e.callEvent("onBeforeActive",[this._idd,"close"])&&e.closeItem(this._idd,"dhx_accord_outer_event"):e.closeItem(this._idd,"dhx_accord_outer_event"):e.checkEvent("onBeforeActive")?e.callEvent("onBeforeActive",[this._idd,"open"])&&e.openItem(this._idd,"dhx_accord_outer_event"):e.openItem(this._idd,"dhx_accord_outer_event"):
e.checkEvent("onBeforeActive")?e.callEvent("onBeforeActive",[this._idd,"open"])&&e.openItem(this._idd,"dhx_accord_outer_event"):e.openItem(this._idd,"dhx_accord_outer_event")};d.onmouseover=function(){this.className="dhx_acc_item_label dhx_acc_item_lavel_hover"};d.onmouseout=function(){this.className="dhx_acc_item_label"};c.appendChild(d);var i=document.createElement("DIV");i.className="dhxcont_global_content_area";c.appendChild(i);var f=new dhtmlXContainer(c);f.setContent(i);c.adjustContent(c,this.sk.cell_height+
this.sk.content_offset);c._id=a;this.idPull[a]=c;c.getId=function(){return this._id};c.setText=function(a){e.setText(this._id,a)};c.getText=function(){return e.getText(this._id)};c.open=function(){e.openItem(this._id)};c.isOpened=function(){return e.isActive(this._id)};c.close=function(){e.closeItem(this._id)};c.setIcon=function(a){e.setIcon(this._id,a)};c.clearIcon=function(){e.clearIcon(this._id)};c.dock=function(){e.dockItem(this._id)};c.undock=function(){e.undockItem(this._id)};c.show=function(){e.showItem(this._id)};
c.hide=function(){e.hideItem(this._id)};c.setHeight=function(a){e.setItemHeight(this._id,a)};c.moveOnTop=function(){e.moveOnTop(this._id)};c._doOnAttachMenu=function(){e._reopenItem()};c._doOnAttachToolbar=function(){e._reopenItem()};c._doOnAttachStatusBar=function(){e._reopenItem()};c._doOnFrameContentLoaded=function(){e.callEvent("onContentLoaded",[this])};this.openItem(a);this.multiMode||this._defineLastItem();return c};this.openItem=function(a,b,c){if(!this._openBuzy)if(this._enableOpenEffect&&
!c)(!this.multiMode||!this.idPull[a]._isActive)&&this._openWithEffect(a,null,null,null,null,b);else if(this.multiMode)for(var d in this.idPull){if(this.idPull[d]._isActive||d==a)this.idPull[d].style.height=this.idPull[d].h+"px",this.idPull[d].childNodes[1].style.display="",this.skin=="dhx_web"&&this.idPull[d]._setPadding(this.skinParams[this.skin].cell_pading_max,"dhxcont_acc_dhx_web"),this.idPull[d].adjustContent(this.idPull[d],this.sk.cell_height+this.sk.content_offset,null,null,this.idPull[d]==
this._lastVisible()&&this.skin!="dhx_web"?0:this.sk.cell_space),this.idPull[d].updateNestedObjects(),this.idPull[d]._isActive=!0,this._updateArrows(),b=="dhx_accord_outer_event"&&d==a&&this.callEvent("onActive",[a,!0])}else if(!a||!this.idPull[a]._isActive||c){var e=0;for(d in this.idPull)if(this.idPull[d].style.height=this.sk.cell_height+(this.idPull[d]!=this._lastVisible()&&d!=a?this.sk.cell_space:0)+"px",d!=a)this.idPull[d].childNodes[1].style.display="none",this.skin=="dhx_web"&&this.idPull[d]._setPadding(this.skinParams[this.skin].cell_pading_min,
""),this.idPull[d]._isActive=!1,e+=this.idPull[d].offsetHeight;e=this.base.offsetHeight-e;if(a)this.idPull[a].style.height=e+"px",this.idPull[a].childNodes[1].style.display="",this.skin=="dhx_web"&&this.idPull[a]._setPadding(this.skinParams[this.skin].cell_pading_max,"dhxcont_acc_dhx_web"),this.idPull[a].adjustContent(this.idPull[a],this.sk.cell_height+this.sk.content_offset,null,null,this.idPull[a]==this._lastVisible()?0:this.sk.cell_space),this.idPull[a].updateNestedObjects(),this.idPull[a]._isActive=
!0,b=="dhx_accord_outer_event"&&this.callEvent("onActive",[a,!0]);this._updateArrows()}};this._lastVisible=function(){for(var a=null,b=this.base.childNodes.length-1;b>=0;b--)!this.base.childNodes[b]._isHidden&&!a&&(a=this.base.childNodes[b]);return a};this.closeItem=function(a,b){if(this.idPull[a]!=null&&this.idPull[a]._isActive&&!this._openBuzy)this._enableOpenEffect?this._openWithEffect(this.multiMode?a:null,null,null,null,null,b):(this.idPull[a].style.height=this.sk.cell_height+(this.idPull[a]!=
this._lastVisible()?this.sk.cell_space:0)+"px",this.idPull[a].childNodes[1].style.display="none",this.skin=="dhx_web"&&this.idPull[a]._setPadding(this.skinParams[this.skin].cell_pading_min,""),this.idPull[a]._isActive=!1,b=="dhx_accord_outer_event"&&this.callEvent("onActive",[a,!1]),this._updateArrows())};this._updateArrows=function(){for(var a in this.idPull){for(var b=this.idPull[a].childNodes[0],c=null,d=0;d<b.childNodes.length;d++)String(b.childNodes[d].className).search("dhx_acc_item_arrow")!=
-1&&(c=b.childNodes[d]);if(c!=null)c.className="dhx_acc_item_arrow "+(this.idPull[a]._isActive?"item_opened":"item_closed"),c=null}};this.setText=function(a,b,c){if(e.idPull[a]!=null){for(var d=e.idPull[a].childNodes[0],i=null,f=0;f<d.childNodes.length;f++)d.childNodes[f].tagName!=null&&String(d.childNodes[f].tagName).toLowerCase()=="span"&&(i=d.childNodes[f]);isNaN(c)?i.innerHTML=b:(i.style.paddingLeft=c+"px",i.style.paddingRight=c+"px")}};this.getText=function(a){if(e.idPull[a]!=null){for(var b=
e.idPull[a].childNodes[0],c=null,d=0;d<b.childNodes.length;d++)b.childNodes[d].tagName!=null&&String(b.childNodes[d].tagName).toLowerCase()=="span"&&(c=b.childNodes[d]);return c.innerHTML}};this._initWindows=function(a){if(window.dhtmlXWindows){if(!this.dhxWins&&(this.dhxWins=new dhtmlXWindows,this.dhxWins.setSkin(this.skin),this.dhxWins.setImagePath(this.imagePath),this.dhxWinsIdPrefix="",!a))return;var b=this.dhxWinsIdPrefix+a;if(this.dhxWins.window(b))this.dhxWins.window(b).show();else{var c=this,
d=this.dhxWins.createWindow(b,20,20,320,200);d.setText(this.getText(a));d.button("close").hide();d.attachEvent("onClose",function(a){a.hide()});d.addUserButton("dock",99,this.dhxWins.i18n.dock,"dock");d.button("dock").attachEvent("onClick",function(){c.cells(a).dock()})}}};this.dockWindow=function(a){if(this.idPull[a]._isUnDocked&&this.dhxWins&&this.dhxWins.window(this.dhxWinsIdPrefix+a))this.dhxWins.window(this.dhxWinsIdPrefix+a).moveContentTo(this.idPull[a]),this.dhxWins.window(this.dhxWinsIdPrefix+
a).close(),this.idPull[a]._isUnDocked=!1,this.showItem(a),this.callEvent("onDock",[a])};this.undockWindow=function(a){if(!this.idPull[a]._isUnDocked)this._initWindows(a),this.idPull[a].moveContentTo(this.dhxWins.window(this.dhxWinsIdPrefix+a)),this.idPull[a]._isUnDocked=!0,this.hideItem(a),this.callEvent("onUnDock",[a])};this.setSizes=function(){this._reopenItem()};this.showItem=function(a){if(this.idPull[a]!=null&&this.idPull[a]._isHidden)this.idPull[a]._isUnDocked?this.dockItem(a):(this.idPull[a].className=
"dhx_acc_item",this.idPull[a]._isHidden=!1,this._defineLastItem(),this._reopenItem())};this.hideItem=function(a){if(this.idPull[a]!=null&&!this.idPull[a]._isHidden)this.closeItem(a),this.idPull[a].className="dhx_acc_item_hidden",this.idPull[a]._isHidden=!0,this._defineLastItem(),this._reopenItem()};this._reopenItem=function(){var a=null,b;for(b in this.idPull)this.idPull[b]._isActive&&!this.idPull[b]._isHidden&&(a=b);this.openItem(a,null,!0)};this.forEachItem=function(a){for(var b in this.idPull)a(this.idPull[b])};
this._enableOpenEffect=!1;this._openStep=10;this._openStepIncrement=5;this._openStepTimeout=10;this._openBuzy=!1;this.setEffect=function(a){this._enableOpenEffect=a==!0?!0:!1};this._openWithEffect=function(a,b,c,d,e,f){if(this.multiMode){if(!e)this._openBuzy=!0,e=this._openStep,this.idPull[a]._isActive?(b=a,a=null,c=this.sk.cell_height+(this.idPull[b]!=this._lastVisible()?this.sk.cell_space:0),this.idPull[b].childNodes[1].style.display=""):(d=this.idPull[a].h,this.idPull[a].childNodes[1].style.display=
"");var g=!1;if(a){var h=parseInt(this.idPull[a].style.height)+e;h>d&&(h=d,g=!0);this.idPull[a].style.height=h+"px"}if(b)h=parseInt(this.idPull[b].style.height)-e,h<c&&(h=c,g=!0),this.idPull[b].style.height=h+"px";e+=this._openStepIncrement;if(g){if(a)this.idPull[a].adjustContent(this.idPull[a],this.sk.cell_height+this.sk.content_offset,null,null,this.idPull[a]==this._lastVisible()?0:this.sk.cell_space),this.idPull[a].updateNestedObjects(),this.idPull[a]._isActive=!0;if(b)this.idPull[b].childNodes[1].style.display=
"none",this.idPull[b]._isActive=!1;this._updateArrows();this._openBuzy=!1;a&&f=="dhx_accord_outer_event"&&this.callEvent("onActive",[a,!0]);b&&f=="dhx_accord_outer_event"&&this.callEvent("onActive",[b,!1])}else{var k=this;window.setTimeout(function(){k._openWithEffect(a,b,c,d,e,f)},this._openStepTimeout)}}else{if(!e&&(this._openBuzy=!0,e=this._openStep,a))this.idPull[a].childNodes[1].style.display="";if(!b||!c||!d){var d=c=0,j;for(j in this.idPull){var n=this.sk.cell_height+(this.idPull[j]!=this._lastVisible()&&
j!=a?this.sk.cell_space:0);this.idPull[j]._isActive&&a!=j&&(b=j,c=n);j!=a&&(d+=n)}d=this.base.offsetHeight-d}g=!1;if(a){var l=parseInt(this.idPull[a].style.height)+e;l>d&&(g=!0)}if(b){var m=parseInt(this.idPull[b].style.height)-e;m<c&&(g=!0)}e+=this._openStepIncrement;g&&(l=d,m=c);if(b)this.idPull[b].style.height=m+"px";if(a)this.idPull[a].style.height=l+"px";if(g){if(b)this.idPull[b].childNodes[1].style.display="none",this.idPull[b]._isActive=!1;if(a)this.idPull[a].adjustContent(this.idPull[a],this.sk.cell_height+
this.sk.content_offset,null,null,this.idPull[a]==this._lastVisible()?0:this.sk.cell_space),this.idPull[a].updateNestedObjects(),this.idPull[a]._isActive=!0;this._updateArrows();this._openBuzy=!1;f=="dhx_accord_outer_event"&&a&&this.callEvent("onActive",[a,!0])}else k=this,window.setTimeout(function(){k._openWithEffect(a,b,c,d,e,f)},this._openStepTimeout)}};this.setActive=function(a){this.openItem(a)};this.isActive=function(a){return this.idPull[a]._isActive===!0?!0:!1};this.dockItem=function(a){this.dockWindow(a)};
this.undockItem=function(a){this.undockWindow(a)};this.setItemHeight=function(a,b){if(this.multiMode&&!isNaN(b))this.idPull[a].h=b,this._reopenItem()};this.setIcon=function(a,b){if(this.idPull[a]!=null){for(var c=this.idPull[a].childNodes[0],d=null,e=0;e<c.childNodes.length;e++)c.childNodes[e].className=="dhx_acc_item_icon"&&(d=c.childNodes[e]);if(d==null)d=document.createElement("IMG"),d.className="dhx_acc_item_icon",c.insertBefore(d,c.childNodes[0]),this.setText(a,null,20);d.src=this.imagePath+
b}};this.clearIcon=function(a){if(this.idPull[a]!=null){for(var b=this.idPull[a].childNodes[0],c=null,d=0;d<b.childNodes.length;d++)b.childNodes[d].className=="dhx_acc_item_icon"&&(c=b.childNodes[d]);c!=null&&(b.removeChild(c),c=null,this.setText(a,null,0))}};this.moveOnTop=function(a){this.idPull[a]&&!(this.base.childNodes.length<=1)&&(this.base.insertBefore(this.idPull[a],this.base.childNodes[0]),this.setSizes())};this._defineLastItem=function(){if(!this.multiMode)for(var a=!1,b=this.base.childNodes.length-
1;b>=0;b--)if(this.base.childNodes[b].className.search("last_item")>=0){if(this.base.childNodes[b]._isHidden||a)this.base.childNodes[b].className=String(this.base.childNodes[b].className).replace(/last_item/gi,"")}else!this.base.childNodes[b]._isHidden&&!a&&(this.base.childNodes[b].className+=" last_item",a=!0)};this.removeItem=function(a){var b=this.idPull[a],c=b.childNodes[0];c.onclick=null;c.onmouseover=null;c.onmouseout=null;c.onselectstart=null;c._idd=null;c.className="";for(b._dhxContDestruct();c.childNodes.length>
0;)c.removeChild(c.childNodes[0]);c.parentNode&&c.parentNode.removeChild(c);for(c=null;b.childNodes.length>0;)b.removeChild(b.childNodes[0]);b._dhxContDestruct=null;b._doOnAttachMenu=null;b._doOnAttachToolbar=null;b._doOnAttachStatusBar=null;b.clearIcon=null;b.close=null;b.dock=null;b.getId=null;b.getText=null;b.hide=null;b.isOpened=null;b.open=null;b.setHeight=null;b.setIcon=null;b.setText=null;b.show=null;b.undock=null;b.parentNode&&b.parentNode.removeChild(b);b=null;this.idPull[a]=null;try{delete this.idPull[a]}catch(d){}};
this.unload=function(){for(var a in this.skinParams){this.skinParams[a]=null;try{delete this.skinParams[a]}catch(b){}}this.skinParams=null;for(a in this.idPull)this.removeItem(a);this.userOffset=this.unload=this.undockWindowunload=this.undockWindow=this.undockItem=this.w=this.skin=this.showItem=this.setText=this.setSkinParameters=this.setSkin=this.setSizes=this.setOffset=this.setItemHeight=this.setIconsPath=this.setIcon=this.setEffect=this.setActive=this.removeItem=this.openItem=this.multiMode=this.itemH=
this.isActive=this.imagePath=this.hideItem=this.h=this.getText=this.forEachItem=this.eventCatcher=this.enableMultiMode=this.dockWindow=this.dockItem=this.detachEvent=this.closeItem=this.clearIcon=this.checkEvent=this.cells=this.callEvent=this.attachEvent=this.addItem=this._updateArrows=this._reopenItem=this._lastVisible=this._initWindows=this.sk=this.idPull=null;if(this._isAccFS==!0)_isIE?window.detachEvent("onresize",this._doOnResize):window.removeEventListener("resize",this._doOnResize,!1),this._resizeTMTime=
this._resizeTM=this._adjustToFullScreen=this._adjustAccordion=this._doOnResize=this._isAccFS=null,document.body.className=String(document.body.className).replace("dhxacc_fullscreened",""),this.cont.obj._dhxContDestruct(),this.cont.dhxcont.parentNode&&this.cont.dhxcont.parentNode.removeChild(this.cont.dhxcont),this.cont.dhxcont=null,this.cont=this.cont.setContent=null;if(this.dhxWins)this.dhxWins.unload(),this.dhxWins=null;this.base.className="";this.base=null;for(a in this)try{delete this[a]}catch(c){}};
this._initWindows();dhtmlxEventable(this);return this}else alert(this.i18n.dhxcontalert)}dhtmlXAccordion.prototype.i18n={dhxcontalert:"dhtmlxcontainer.js is missed on the page"};
(function(){dhtmlx.extend_api("dhtmlXAccordion",{_init:function(f){return[f.parent,f.skin]},icon_path:"setIconsPath",items:"_items",effect:"setEffect",multi_mode:"enableMultiMode"},{_items:function(f){for(var h=[],e=[],g=0;g<f.length;g++){var a=f[g];this.addItem(a.id,a.text);a.img&&this.cells(a.id).setIcon(a.img);a.height&&this.cells(a.id).setHeight(a.height);if(a.open===!0)h[h.length]=a.id;if(a.open===!1)e[e.length]=a.id}for(var b=0;b<h.length;b++)this.cells(h[b]).open();for(b=0;b<e.length;b++)this.cells(e[b]).close()}})})();

//v.3.0 build 110713

/*
Copyright DHTMLX LTD. http://www.dhtmlx.com
You allowed to use this component or parts of it under GPL terms
To use it on other terms or get Professional edition of the component please contact us at sales@dhtmlx.com
*/
