#!/usr/bin/perl

#see puhastab sõnastiku andmete seest kasutaja valitud väljad

use strict;
use utf8;
use Encode 'decode_utf8';
binmode(STDOUT, ":utf8");
use POSIX qw(strftime);
use XML::LibXML;
use CGI;


use lib qw( ./ );
use SHS_cfg (':dir', ':file');
my $dicparser = XML::LibXML->new();
my $xsURI ='http://www.w3.org/2001/XMLSchema';
my %sr=();
my $aste=0;
my @aadres = ();
my $aeg = strftime("%Y-%m-%dT%H:%M:%S", localtime);


my $q = new CGI;
print $q->header ( -charset => "UTF-8" );

my $id =$q->param('app_id'); 
my $svew = $q->param('app_ver'); 
my $versioon ='';
if($svew eq 'T'){
    $versioon=SHS_test_dir;
}else{
    $versioon=SHS_work_dir;
}


my $prefix = 'x';
my $uri = 'htte://midagi';

if(-e $versioon."shsconfig_${id}.xml"){
        
        my $things = $dicparser->parse_file($versioon."shsconfig_${id}.xml")->getDocumentElement;
        $prefix =   $things->findvalue("dicpr");
        $uri =   $things->findvalue("dicuri");
        
}else{
        print "Puudu: ".$versioon."shsconfig_${id}.xml";
        die("Puudu: ".$versioon."shsconfig_${id}.xml");
}
html1_P($id);
teeskeem($id,$versioon);
html1_F();

sub teeskeem{
	my ($inid,$ver)=@_;
	if(-r "${ver}xsd/schema_${inid}.xsd"){
		my $inDom = $dicparser->parse_file("${ver}xsd/schema_${inid}.xsd");
		$inDom->documentElement()->setNamespace($xsURI, 'xs', 0);
		praseelm($inDom->documentElement()->findnodes("xs:element[\@name='sr']")->get_node(0), 1, 1, $inDom->documentElement());
	}else{
		#print "ei loe /schema_${inid}.xsd\n";
	}
	
0;
}
sub praseelm{
my ($inel,$inmin,$inmax,$srn)=@_;

my $elnimi=$inel->findvalue('.//xs:annotation/xs:documentation[@xml:lang="et"]');
my $pnimi = $inel-> findvalue('@name');

  $aste=$aste+1;
  unless($pnimi eq 'sr' or $pnimi eq 'A'){
   push(@aadres, $prefix.':'.$pnimi);
  }
 
  
  html1_R($elnimi,$pnimi,$aste,join('/',@aadres), $inmin, $inmax);#$snimi,$silt, $sygavus, $aadress 

#sisu = sisu & pnimi & ", " & srstring & ", "
#TrukiElm(pnimi, min, max)
 foreach my $felems ($inel -> findnodes('.//xs:element') ) { 
  my $min='-2';
  my $max='-3';
  my $tmp = $felems->findnodes( "\@minOccurs" ) ;
  if ( $tmp->size() == 0 ) {
  } else {  # artiklis juba A sees olemas
     $min = $tmp ->get_node(0)->nodeValue ;
  }
  $tmp = $felems->findnodes( "\@maxOccurs" ) ;
  if ( $tmp->size() == 0 ) {
  } else { 
    $max= $tmp ->get_node(0)->nodeValue ;
    if($max eq 'unbounded'){
		$max=-1;
    }
  }
  my $tmp2 = substr($felems->findvalue("\@ref"),2);
  $tmp = $srn->findnodes( "xs:element[\@name='${tmp2}']")->get_node(0);
  #$els{$tmp->findvalue('@name') }={'min'=>$min, 'max'=>$max, };
  
  praseelm($tmp, $min, $max,$srn);

 }

my $obl;
	foreach my $telem ($inel->findnodes('.//xs:attribute')) {
	
	if( $telem->findvalue('@use') eq 'required'){
    $obl = 1 ;
	}else{
    $obl = 0 ;
	}
	my $atname = substr($telem->findvalue('@ref'),2 );

my $atenameet='--::--';
   eval  {
      my $atenode = $srn->findnodes( "xs:attribute[\@name='${atname}']")->get_node(0);
      $atenameet=$atenode->findvalue('.//xs:annotation/xs:documentation[@xml:lang="et"]');
   };
if($atname eq 'l:lang'){#  muuda pärast
$atname = 'lang';
$atenameet='XML Keel';
html1_R($atenameet,'@'.$atname,$aste+1,join('/',@aadres).'/@xml:'.$atname, $obl, 1);#$snimi,$silt, $sygavus, $aadress 
}else{
	#vaja funktsioon mis otsib nime
	 html1_R($atenameet,'@'.$atname,$aste+1,join('/',@aadres).'/@'.$prefix.':'.$atname, $obl, 1);#$snimi,$silt, $sygavus, $aadress 
	 }#hiljem
	 #html1_Rf();
	}
	
  #html1_Rf();
	unless($pnimi eq 'sr' or $pnimi eq 'A'){
    pop(@aadres);
	}
	$aste=$aste-1;
0;
}

sub html1_P(){
my ($id) = @_;
print <<"LoginPage3";	
<!DOCTYPE html>
<head>
    <meta http-equiv="Content-type" content="text/html;charset=UTF-8" />
    <title>Artiklite filtreerimine ($id)</title>
    <style type="text/css">
        .punane{
            color:red;
        }
        .umbris{
            padding: 5px;
            background-color: lightgray;
            margin: 5px;
        }
        .grupp{
            border-style: solid;
            border-width: 2px;
            padding: 5px;
            background-color: lightskyblue;
            margin: 5px;
            padding-left: 10px;

        }
        .element{
            border-style: solid;
            border-width: 1px;
            padding: 5px;
            background-color: white;
            margin: 5px;

        }
        .vooder,
        .vooderL{
            border-style: solid;
            border-width: 1px;
            padding: 5px;
            background-color: white;
            margin: 5px;
        }
        .hidden{
            visibility: hidden;
        }
    </style>
    <script>

        function rpv(s){
            if(s.className=="vooderL"){
                var nv = document.getElementById("pvooder");
                var obj = nv.cloneNode(true);
                obj.removeAttribute('id');
                s.parentNode.replaceChild(obj, s);    
            }
            
        }
        
        function rpvL(s){
            if(s.className=="vooder"){
                var nv = document.getElementById("pvooderL");
                var obj = nv.cloneNode(true);
                obj.removeAttribute('id');
                s.parentNode.replaceChild(obj, s);    
            }
            
        }
        
        function aadbox(s,vs){

            var ne = document.getElementById(vs);
            var nv = document.getElementById("pvooder");
            
            var p = s.parentNode;

            var obj = nv.cloneNode(true);
            obj.removeAttribute('id');
            p.parentNode.insertBefore(obj, p.nextSibling);

            obj = ne.cloneNode(true);
            obj.removeAttribute('id');
            p.parentNode.insertBefore(obj, p.nextSibling);

            vooright(document.getElementById("rrgrupp"));   
        }


       
        function rmbox(s)
        {
            rmboxP(s.parentNode);
        }
        
        function rmboxP(p)
        {
     
            var np = p.nextSibling;
            p.parentNode.removeChild(p);
            np.parentNode.removeChild(np);
            vooright(document.getElementById("rrgrupp"));  

        }

        //saatmise korral
        function makexxS(){
            var str = '';
            var rr = document.getElementById("rrgrupp");
            
            clg(rr); //puhasta tühjadest gruppidest
            vooright(rr);//puhasta and or õigeks
            str = pg(rr);

            uField(str,"")
            return true;
        }

        //muutuste korral
        function makexx(){
            var str = '';
            var rr = document.getElementById("rrgrupp");
            
            //clg(rr); //puhasta tühjadest gruppidest
            vooright(rr);//puhasta and or õigeks
            str = pg(rr);

            uField(str,"")
            return false;
        }

        //Kontrolli korral
        function makexxC(){
            var str = '';
            var rr = document.getElementById("rrgrupp");
            clg(rr); //puhasta tühjadest gruppidest
            vooright(rr);//puhasta and or õigeks
            str = pg(rr);
            var c = getQ(str);
            uField(str,c)
            return false;
        }
        
        function uField(s,c){
            //document.getElementById("cool").textContent  = c+s;
            if(c!=""){
               c=c+": ";
            }

            document.getElementById("cool").innerHTML  = c+s;
            if(s!="()"){
                var a = s.replace(/\\'/g,"\\\\'");
              s = '<xsl:template match="${prefix}:A"><xsl:if test="' + a + '"><xsl:copy><xsl:apply-templates select="@* | node()" /></xsl:copy></xsl:if></xsl:template>';
              document.getElementById('xlst').value =s;
            }else{
              document.getElementById('xlst').value ="";
            }
            
        }
        
        function getQ(s){
            var xmlhttp=new XMLHttpRequest();
            xmlhttp.open("POST","shs_counta.cgi",false);
            xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
            xmlhttp.send("id=${id}&prefix=${prefix}&er=${svew}&query="+s);
            if (xmlhttp.readyState==4 && xmlhttp.status==200)
            {
                return xmlhttp.responseText;
            }
            return xmlhttp.responseText;
        }

        function pe(s){
            var str = '';
            var inputs = s.getElementsByTagName("select"); //or document.forms[0].elements;
            for (var i = 0; i < inputs.length; i++) {
                if (inputs[i].previousSibling.previousSibling.checked) {
                    str= str+" not";
                }
                str= str+"(./" + inputs[i].value ;

                if (inputs[i].nextSibling.value) {
                    str= str+"='"+inputs[i].nextSibling.value +"'";
                }
                str= str+")";
            }
            return str;
        }

        function pv(s){
            var sels = s.getElementsByTagName('select');
            if(sels!= null){
                if(sels.length>0){
                    return sels[0].value;
                }
            }
            return '';
        }

        function pg(s){
            var str='(';
            var sels = s.getElementsByTagName('input');
            if(sels!= null){
                if(sels.length>0){
                    if(sels[0].checked){
                        str=' not(';
                    }
                }
            }

            //sels = s.getElementsByTagName('div');
            sels = s.childNodes;
            if(sels!= null){
                for (var i = 0; i < sels.length; i++) {
                    if(sels[i].className=="vooder"){
                        str = str + pv(sels[i]);
                    }
                    if(sels[i].className=="element"){
                        str = str + pe(sels[i]);
                    }
                    if(sels[i].className=="grupp"){
                        str = str + pg(sels[i]);
                    }
                }
            }
            return str+")";
        }

        function vooright(s){
            var lastVo=null;
            var sels = s.childNodes;
            if(sels!= null){
                for (var i = 0; i <sels.length; i++) {
                    if(sels[i].className=="vooder"){
                        if(lastVo==null){
                            rpvL(sels[i]);
                        }
                        lastVo=sels[i];
                        continue;
                    }
                    if(sels[i].className=="vooderL"){
                        if(lastVo!=null){
                            rpv(sels[i])
                        }
                        lastVo=sels[i];
                        continue;
                    }
                    if(sels[i].className=="grupp"){
                        vooright(sels[i]);
                        continue;
                    }
                }
            }
            if(lastVo.className!="vooderL"){
                rpvL(lastVo);
            }
        }

        function clg(s){
            var mitu = 0;
            var sels = s.childNodes;
            if(sels!= null){
                for (var i = 0; i <sels.length; i++) {
                    if(sels[i].className=="element"){
                        mitu=mitu+1;
                    }
                    if(sels[i].className=="grupp"){
                        var a = clg(sels[i]);
                        if(a==0){
                            //alert("Tühi grupp");
                            rmboxP(sels[i]);
                            i=i-1;
                        }else{
                            mitu=mitu+1;
                        }    
                    }
                }
            }
            return mitu;
        }

    </script>

</head>
<body>
    <form name="sender" action="shs_baseripF.cgi" onsubmit="return makexxS();" method="post">
        <input type="hidden" name="eelexid" value = "$id"/>
        <input type="hidden" name="workver" value = "$svew"/>
        <input type="hidden" name="xlst" id="xlst" value = ""/>
        <input type="submit" value="Skeemi juurde"/>
    </form>
    <input type="button" value="Sõnaartiklite valikutingimused" onclick="makexxC()"/>
    <div id="cool">
    </div>
    <div class="umbris"  onchange="makexx()"  onclick="makexx()" >

        <div class="grupp" id="rrgrupp">
            <input type="checkbox" class="cp1" name="cp1"><label >Eitus</label>
            <div class="vooderL" >
                <input type="button" value="Lisa tingimus" onclick="aadbox(this,'pelement')">
                <input type="button" value="Lisa rühmitus"  onclick="aadbox(this,'pgrupp')">
            </div>
        </div>
        <div class="hidden"></div>
    </div>
    <div class="hidden" id="peidus">
        <div class="vooder" id="pvooder">
            <select class="x" name="x">
                <option value="and">Ja</option>
                <option value="or">Või</option>
            </select>
            <input type="button" value="Lisa tingimus" onclick="aadbox(this,'pelement')">
            <input type="button" value="Lisa rühmitus"  onclick="aadbox(this,'pgrupp')">
        </div>
        <div class="vooderL" id="pvooderL">
            <input type="button" value="Lisa tingimus" onclick="aadbox(this,'pelement')">
            <input type="button" value="Lisa rühmitus"  onclick="aadbox(this,'pgrupp')">
        </div>
        <div class="element" id="pelement">
            <input type="checkbox" class="cp1" name="cp1"><label>Eitus</label><select class="elx" name="elx">
LoginPage3

1;
}
sub html1_R(){
my ($snimi,$silt, $sygavus, $aadress , $min, $max) = @_;
$sygavus-=2;
if($silt eq 'sr' or $silt eq 'A'){
  0;
  return;
}
my $syg= '| 'x$sygavus;
if($max == -1){
$max ="∞";
}
print <<"LoginPage3";	
<option value="$aadress">${syg}[$min, $max] &lt;$prefix:$silt&gt; = $snimi</option>
LoginPage3
1;
}



sub html1_F(){
my ($innode ) = @_;
print <<"LoginPage3";	
</select><input type="text" class="xpa" name="xpa">
            <input type="button" value="Kustuta tingimus"  onclick="rmbox(this)">
        </div>
        <div class="grupp" id="pgrupp" >
            <input type="checkbox" class="cp1" name="cp1"><label >Eitus</label>
            <input type="button" value="Kustuta rühmitus"  onclick="rmbox(this)">
            <div class="vooderL">
                <input type="button" value="Lisa tingimus" onclick="aadbox(this,'pelement')">
                <input type="button" value="Lisa rühmitus"  onclick="aadbox(this,'pgrupp')">
            </div>

            <div class="hidden"></div>
        </div>
    </div>
</body>
</html>

LoginPage3

1;
}
