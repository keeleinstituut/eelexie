#!/usr/bin/perl

use strict;

#ma ei tea mis need teevad
use utf8;
use Encode 'decode_utf8';
binmode(STDOUT, ":utf8");

use Switch;
use XML::LibXML;
use CGI;
use Socket; #ja miks seda vaja on ?

use lib qw( ./ );
use SHS_list;
#use SHS_man;
use SHS_cfg (':dir', ':file');

my $q = new CGI;
print $q->header ( -charset => "UTF-8" );

#kogu nimekirja jaoks
my $dicparser = XML::LibXML->new();
my $LLDOM = $dicparser->parse_file(SHS_lexlist_file);
my $LLRoot = $LLDOM->getDocumentElement;


my $logi="";

my $id ="";
my $tyyp ="";

my $nimekeeled ="";

my $nameet ="";

my $er='';
my $workE ="";
my $testE ="";
my $comment ="";
my $note ="";
my $tostalist =""; #kõik sõnastikud
my $lf='';
my $load = 1; # kas laadida väljad failist 
my $nodes;
my $rnode; #ajutine kasutusel ühe lex node hoidmiseks
my $tmpnode; # teine muutuva tähendusega ajutine
my $num;

my %names;

if($q->request_method()eq "POST"){
    #salvesta muudatused

    $id =$q->param('id');         # peab exiteerima
    unless($id =~/^[a-z][a-z0-9][a-z0-9_]$/){
        $logi.='paha id !!!!!';
    }
    #?tühi jääb muutmata 
    $tyyp =$q->param('tyyp');     # loendist
    if($tyyp eq ''){
        my $llelement= SHS_list::getLLelement($id);
        if($llelement != undef){
            my ($tid, $ttyyp)= SHS_list::parseLLelement($llelement);
            $tyyp =$ttyyp;
        }
    }
    
    $workE =$q->param('workE');   # Tühi või W
    $testE =$q->param('testE');   # tühi või T
    #?passlik oleks test ka
    $er = $workE.$testE;


    foreach my $qnames ($q->param) {
        if($qnames =~m/^INnameLang_(.*)$/){
            my $langid = $1;
            my $nimitext = $q->param($qnames);
            if($langid eq 'et'){
                $nameet = $nimitext;
            }
            unless($nimitext eq "") { #sisuta keeled kaovad
                $names{$langid} = $nimitext;
                $nimekeeled .= getlangrpw($langid,$nimitext); 
            }
        }
    }

    
    
    $comment =$q->param('comment'); #võib tühi olla 
    $note =$q->param('note');     #võib tühi olla 
    $lf =$q->param('lf');     #võib tühi olla 
   
    
    if($nameet eq ''){
        $logi .= 'Eesti keelne nimi peab midagi sisaldama';
    }

    if($logi eq ""){ #kui sisend korras
        #? vead kirjuta 
        my $element = SHS_list::makeLLelement($id, $tyyp, $er, $lf, $note, $comment, %names);
        SHS_list::addAlterLLelement($id,$element, '');
        $logi ='Salvestatud.';
    }else{# ära lae vaid kohanda saadetud andmed
        $load = 0;
    }

}else{#kui oli get siis 
    # küsi lexid
    $id = $q->param('app_id');
    unless($id =~/^[a-z][a-z0-9][a-z0-9_]$/){
        $logi='paha id !!!!!';
    }
}

#?kui lexid korras siis loe andmed
#näita andmed

if($load){
    %names = ();
    my $llelement =SHS_list::getLLelement($id);
    if($llelement != undef){
    ($id, $tyyp, $er, $lf, $note, $comment, %names)= SHS_list::parseLLelement($llelement);
    }

    $nimekeeled ='';
    while (my ($key, $value) = each(%names)){
        if($key eq 'et'){
            $nameet = $value;
        }else{
            $nimekeeled .= getlangrpw($key,$value);
        }
    }
}


#er korda
switch ($er){
    case "" {$workE =  ""; $testE = "";}
    case "WT" {$workE = 'checked = "checked"'; $testE =  'checked = "checked"';}
    case "W" {$workE = 'checked = "checked"'; $testE = "";}
    case "T" {$workE = ""; $testE =  'checked = "checked"';}
    else { $logi .= "Error er;"}
}

#valikastuse märkimine
$tostalist ="";
my $lexid;
my $lextype;
my $lexname;

#<lex id="id_" type="xxx" er="WT" >
#    <name l="et">Eesti nimi</name>
#    <name l="en">English name</name>
#    <note>notetext</note>
#    <comment>Comment text</comment>
#</lex>
foreach my $rnode ($LLRoot->findnodes("lex")) {
     $lexid = $rnode->findvalue('@id');
     $lextype = $rnode->findvalue('@type');
     $lexname = $rnode->findvalue("name[\@l='et']");
     $tostalist .="<option value=\"$lexid\">$lexid ($lextype) - $lexname</option>"     
}

my %tyyp = { "" => "",
             "Yks" => "",
             "Mit" => "",
             "Trm" => "",
             "Muu" => "",
             "dev" => "",
             "tpl" => "",
             "Uus" => "",
             "xxx" => ""};
$tyyp{$tyyp}='selected="selected"';             


sub getlangrpw($$){
    my($lang, $text)= @_;
    my $el = '';
    $el .= "<tr id=\"INnameLang_$lang\">";
    $el .= "<td align=\"right\">";
    $el .= "nimi <a href=\"javascript:;\" onclick=\"replaceNameLang('$lang');\">$lang</a>:</td>";
    $el .= "<td>";
    $el .= "<input type=\"text\" id=\"TINnameLang_$lang\" name=\"INnameLang_$lang\" value=\"$text\" /></td>";
    $el .= "<td>";
    $el .= "<a href=\"javascript:;\" onclick=\"removeElement('INnameLang_$lang');\">Eemalda</a></td>";
    $el .= "</tr>";
    return $el;
}


# document out 
# kasutatud muutujad $logi $id %tyyp $nameet $workE $testE $comment $note $tostalist $nimekeeled

print<<"axa";
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
	<meta http-equiv="Content-type" content="text/html;charset=UTF-8" />
	<link rel="stylesheet" type="text/css" href="../eelex.css" />
		<title>$id sätted</title>
	    <style type="text/css">
            .style1
            {
                width: 100%;
            }
                    input
        {            width: 95%;
        }
        </style>
        
        <script type="text/javascript">
//<![CDATA[ 
function addNameLang()
{
    var name=promptname('en');
    if (name!=null && name!="")
    {
      
        var lb =  document.getElementById('langbefore');

        lb.parentNode.insertBefore(getlanel(name, ''),lb);
        
    }
}

function replaceNameLang(olang)
{
    var name=promptname(olang);
    if (name!=null && name!="")
    {

        var lb =  document.getElementById('INnameLang_'+olang);
        lb.parentNode.insertBefore(getlanel(name, document.getElementById('TINnameLang_'+olang).value),lb);
        
        removeElement('INnameLang_'+olang);
    }else{
         alert("ei vahetatud");
    }
}


function promptname(name)
{
    while (true)
    {
        name=prompt("Sisesta soovitud keele kood:",name);

        if (name!=null && name!="")
        {
            if(document.getElementById('INnameLang_'+name)!=null){
                alert("juba olemas");
            }else{
                return name;
            }
        }
        if (name==null)
        {
            //vist katkestus
            return '';
            
        }
        if(name=="")
        {
            alert("ei saa tühjaks jääda");
        }
        
    }
}

function getlanel(lang, text){
    var newEL = document.createElement('tr');
    

    newEL.insertCell(0).innerHTML = 'nimi <a href="javascript:;" onclick="replaceNameLang(\\''+lang+'\\');">'+lang+'</a>:';
    newEL.insertCell(1).innerHTML = '<input type="text" id="TINnameLang_'+lang+'" name="INnameLang_'+lang+'" value="'+text+'" />';
    newEL.insertCell(2).innerHTML = '<a href="javascript:;" onclick="removeElement(\\'INnameLang_'+lang+'\\');">Eemalda</a>';

    //alert(document.getElementById('langbefore').rowIndex);
    newEL.setAttribute('id','INnameLang_'+lang);
    
   //var x=document.getElementById('tr2').insertCell(0);
   //x.innerHTML="John";
    
   // alert(newEL.innerHTML);
    return newEL;
}

function removeElement(divNum) {
  var olddiv = document.getElementById(divNum);
  olddiv.parentNode.removeChild(olddiv);
}

//]]> 
        </script>
	</head>
	<body>
	<div id="kasutajad" class="sektsioon"><h2>EELexi sõnastiku suvandid</h2>
       <form id="uuseelex" action="shs_properties.cgi" method="post">
	    <table id="thetable" class="style1">
            <tr>
                <td align="right">
                    Sõnastiku id:</td>
                <td>
                     <input id="Hidden1" type="hidden" name="id" value="$id"/>
                    <h2>$id</h2></td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td align="right">
                    tüüp</td>
                <td>
                    <select id="Select1" name="tyyp">
                        <option $tyyp{''} value="">Tühi / Ei muuda</option>
                        <option $tyyp{'Yks'} value="Yks">Ükskeelne sõnastik</option>
                        <option $tyyp{'Mit'} value="Mit">Mitmekeelne sõnastik</option>
                        <option $tyyp{'Trm'} value="Trm">Termini baas</option>
                        <option $tyyp{'Muu'} value="Muu">Muu / liigitamata</option>
                        <option $tyyp{'Uus'} value="Uus">Uus sõnastik</option>
                        <option $tyyp{'tpl'} value="tpl">Sõnastikupõhi</option>
                        <option $tyyp{'dev'} value="dev">Arendus</option>
                        <option $tyyp{'xxx'} value="xxx">Määramata</option>
                    </select></td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr id="INnameLang_et">
                <td align="right">
                    nimi et</td>
                <td>
                    <input id="Text1" type="text" name="INnameLang_et" value="$nameet" /></td>
                <td>
                    Kohustuslik!
                    &nbsp;</td>
            </tr>
$nimekeeled            
            <tr id="langbefore">
                <td align="right">
                    Lisa nimi:</td>
                <td>
                    <input id="lisanimekeel" type="button" value="Lisa"  onclick="addNameLang();"/></td>
                <td>
                    Lisa sõnastiku nimi uues keeles.</td>
            </tr>
            
            <tr>
                <td align="right">
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td align="right">
                    ligipääs:</td>
                <td>
                    <label for="Checkbox1">tööversioon:</label><input id="Checkbox1" type="checkbox" name="workE" value ="W" $workE/>
                    <label for="Checkbox2">testversiopon:</label><input id="Checkbox2" type="checkbox" name="testE" value ="T" $testE/></td>
                <td>
                    Kas sisselogimise lehel on nupp lahti</td>
            </tr>
            <tr>
                <td align="right">
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td align="right">
                    kommentaar</td>
                <td>
                    <input id="Text3" type="text" name="comment" value="$comment" /></td>
                <td>
                    Näha ainult siin</td>
            </tr>
            <tr>
                <td align="right">
                    Märkus</td>
                <td>
                    <input id="Text4" type="text" name="note" value="$note"/></td>
                <td>
                    Näha sisselogimise lehel</td>
            </tr>
            <tr>
                <td align="right">
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td align="right">
                    Login fail</td>
                <td>
                    <input readonly="readonly" id="lf" type="text" name="lf" value="$lf" /></td>
                <td>
                    Ära muuda
                    &nbsp;</td>
            </tr>
            <tr>
                <td align="right">
                    &nbsp;</td>
                <td>
                    $logi</td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td align="right">
                    &nbsp;</td>
                <td>
                    <input id="Submit1" type="submit" value="submit" /></td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td align="right">
                    <a href="shs_list.cgi#$id">Tagasi nimekirja juurde</a>&nbsp;</td>
                <td>
                    &nbsp;</td>
                <td>
                    &nbsp;
                    </td>
                    
            </tr>
            
        </table>
       </form>
	 </div>
	</body>
</html>
axa
