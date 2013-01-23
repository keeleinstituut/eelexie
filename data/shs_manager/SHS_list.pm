package SHS_list;
use strict;
use warnings;

use utf8;
use Encode 'decode_utf8';
binmode(STDOUT, ":utf8");


use HTTPD::UserAdmin();
use Digest::MD5;
use XML::LibXML;
use File::Basename;


use SHS_Carp;

#$SIG{__WARN__} = \&carp_hwl;
$SIG{__DIE__}  = \&carp_hdl;

use SHS_cfg (':dir', ':file');

my $dicparser = XML::LibXML->new();

#See tuleb uuesti üle käia
BEGIN {
    use Exporter ();
    our (@ISA, @EXPORT, @EXPORT_OK);
    @ISA = qw(Exporter);
    @EXPORT_OK = qw( &makeLLelement &parseLLelement &addAlterLLelement &deleteLLelement &getLLelement);
}
our @EXPORT_OK;


#<lex id="id_" type="xxx" er="WT" lf="">
#    <name l="et">Eesti nimi</name>
#    <name l="en">English name</name>
#    <note>notetext</note>
#    <comment>Comment text</comment>
#</lex>
#%name = ( 'et' => "nimi" , 'en' => "name" )
# teised muutujad lähevad lexlisti elemendiga samanimelistesse muutujatesse
#Andmed peavad enne kontrollitud olema
sub makeLLelement{
    my ($id, $type, $er, $lf, $note, $comment, %name)=@_;
    my $tnode;
    my $nnode = XML::LibXML::Element->new('lex' );
    $nnode->setAttribute( 'id', $id );
    $nnode->setAttribute( 'type', $type );
    $nnode->setAttribute( 'er', $er );
    $nnode->setAttribute( 'lf', $lf );
    
    #key keel ja value nimi
    while (my ($key, $value) = each(%name)){

        $tnode= $nnode->addNewChild('', 'name');
        $tnode->setAttribute('l', $key);
        $tnode->appendTextNode($value);
    }
    if ($comment ne "") {
        $tnode= $nnode->addNewChild('', 'comment');
        $tnode->appendTextNode($comment);
    }

    if ($note ne "") {
        $tnode= $nnode->addNewChild('', 'note');
        $tnode->appendTextNode($note);
    }

    return $nnode;
}

sub parseLLelement{
    my ($rnode)=@_;
    my ($id, $type, $er, $lf, $note, $comment, %name);

    $id = $rnode->findvalue('@id');
    $type = $rnode->findvalue('@type');
    $er = $rnode->findvalue('@er');
    $lf = $rnode->findvalue('@lf');

    foreach my $langnode ($rnode->findnodes("name")) {
        $name{$langnode->findvalue('@l')} = $langnode->findvalue('.');
    } 

    $comment = $rnode->findvalue('comment');
    $note = $rnode->findvalue('note');

    return ($id, $type, $er, $lf, $note, $comment, %name);
}

#lisab või kui olemas siis muudab lexlisti elemendi
#$rnode teed makeLLelement'iga.
#$tostakuhu ""- ei tõsta, "EsimenE" või sõnastiku id mille järele tõsta
#$id sama id mis 
sub addAlterLLelement{
    my ($id, $rnode, $tostakuhu)=@_;

    my $LLDOM = $dicparser->parse_file(SHS_lexlist_file);
    my $LLRoot = $LLDOM->getDocumentElement;

    my $nodes = $LLRoot->findnodes("lex[\@id='${id}']");
    my $num =$nodes->size();

    #ühe idga ei tohi mitu olla
    badLL($id,$num) if ($num > 1);

    if ($num == 0) {
        #lisame uue elemendi
        #kui ei ole määratud kuhu siis esmimeseks
        #ja tõstmise insert ajab asja korda
        if($tostakuhu eq ''){
            $tostakuhu = 'EsimenE';
        }
    }else{
        # 1 element, seega vahetame vanaga
        $nodes->get_node(1)->replaceNode($rnode);
    }

    #kas on vaja tõsta: ""- ei ole vaja, "EsimenE" või sõnastiku id mille järele tõsta
    if($tostakuhu ne ''){
        # keda liigutan $rnode
        # kus liigutan $LLRoot
        # mille suhtes liigutan $LLRoot->findnodes("lex[\@id='${tostakuhu}']")
        # esimene element $LLRoot->firstChild
        if($tostakuhu eq 'EsimenE'){
            $LLRoot->insertBefore($rnode, $LLRoot->firstChild);
        }else{
            $nodes = $LLRoot->findnodes("lex[\@id='${tostakuhu}']");
            $LLRoot->insertAfter($rnode, $nodes->get_node(1));
        }

    }#vaja tõsta
    if ($LLDOM->toFile(SHS_lexlist_file, 0)) {
        # edu
        return 1;
    }else {
        # ebaedu
        return 0;
    }

}

sub deleteLLelement{
    my ($id)=@_;

    my $LLDOM = $dicparser->parse_file(SHS_lexlist_file);
    my $LLRoot = $LLDOM->getDocumentElement;

    my $nodes = $LLRoot->findnodes("lex[\@id='${id}']");
    my $num =$nodes->size();

    #ühe idga ei tohi mitu olla
    badLL($id,$num) if ($num > 1);

    if ($num == 0) {
        #element puudub
        return 0;
    }else{
        # 1 element. kustutame
        $LLRoot->removeChild($nodes->get_node(1));
    }


    if ($LLDOM->toFile(SHS_lexlist_file, 0)) {
        # edu
        return 1;
    }else {
        # ebaedu
        return 0;
    }

}

#vastus 
sub getLLelement{
    my ($id)=@_;

    my $LLDOM = $dicparser->parse_file(SHS_lexlist_file);
    my $LLRoot = $LLDOM->getDocumentElement;

    my $nodes = $LLRoot->findnodes("lex[\@id='${id}']");
    my $num =$nodes->size();

   
    badLL($id,$num) if ($num > 1);
   

    if ($num == 0) {
        return 0;
    }else{
        # 1 element
        return $nodes->get_node(1);
    }

}

sub badLL{
    my ($id,$num)=@_;
    print "<h2>LEXLISTIS korduvad lex kirjed, $num ($id)</h2>";
    die "LEXLISTIS korduvad lex kirjed, $num ($id)";
1;
}

1;
