# Tutvustus
EELex väljalase detsembril 2012. a.

EELex on serveripõhine tarkvara sõnastike loomiseks, toimetamiseks ja trükiettevalmistuseks; kasutajaliides töötab veebibrauseris. Sõnastikke hoitakse struktureeritult XML formaadis, piiranguid struktuuri keerukusele, sõnaraamatute arvule, kasutajate arvule ja nende rollidele (vaatajad, toimetajad, peatoimetaja) ning sõnaraamatu mahtudele ei ole. EELexi abil on valminud kümned Eesti Keele Instituudi viimaste aastate sõnaraamatud. Käesolev pakk sisaldab kogu tarkvara hetkeseisuga (v.a sõnaraamatud) ja üht kakskeelse sõnaraamatu näidist ~ 70 eeltäidetud artikliga.


# Serveri installeerimine
EELexi installeerimine oma arvutisse eeldab veebiserveri, MySQLi ja Perli olemasolu, nende esmast paigaldamist käesolev juhend ei hõlma.
Käesoleva juhendi koostamisel võeti aluseks näidispaigaldus Ubuntu GNU/Linux 12.04 64-bitisel platvormil, kuigi EELex töötab Eesti Keele Instituudis FreeBSD platvormil. Ubuntuga olid vaikimisi installeeritud Apache veebiserver (versioon 2.2.22) ja Perl (versioon 5.14.2). Serverisse installeeritavad lisakomponendid — Perli moodulid — sõltuvad serveri operatsioonisüsteemist. Ka Apache’i konfigureerimine on Apache’i versiooniti erinev. EELexi pakk sisaldab tööks vajaliku lisatarkvara. Serveri operatsioonisüsteemile nõudeid ei ole, kuid osa kasutajaliidese funktsionaalsusest eeldab Windowsi® ja Internet Exploreri® kasutamist.

Andmebaasiserver ja veebiserver ei pea füüsiliselt samas masinas töötama, samuti on mõeldav serveri ja kliendi kooskasutamine nt Windowsi tööarvutis, kuid sellised konfiguratsioonid pole testitud. Veebiserveriks võib peale soovitusliku Apache’i olla mistahes muu server, mis oskab kasutada Apache’i-laadset ligipääsuõiguste süsteemi ja kasutajate autoriseerimist Digest Authentication skeemiga.

EELex on välja töötatud Eesti Keele Instituudis. Eesti Keele Instituut ei võta endale mingit vastutust EELex paki installeerimisel ja kasutamisel tekkida võivate probleemide korral.


## Perli moodulid
Perli mooduleid võimalik installeerida mitmel moel: kasutades operatsioonisüsteemi paketihaldurit (nt Synaptic), Perli lisatarkvara (ActivePerli puhul PPM) või laadida moodulid käsitsi CPAN moodulite lehelt ning käivitada vastavad paigaldusskriptid. Seetõttu ei kirjeldata siinses juhendis moodulite täpset installeerimisprotsessi, vaid ainult loetletakse vajalikud moodulid.
Allolevas nimekirjas on toodud moodulid puudusid vaikimisi paigalduses ning tuli eraldi installeerida:
* HTTPD::User-Manage (1.66), (CPANis HTTPD::UserAdmin)
* XML::LibXML (2.0014)
* XML::LibXSLT (1.79)
* Data::GUID (0.046). Nõutavad mitmed alamkomponendid.
* IO::Compress::Zip (2.059)


## Paki paigaldamine
Kopeerige ```eelex_pakk_*.tgz``` veebiserveri juurkataloogi (```/var/www```) ja pakkige lahti. Tekib kataloog EELex ja selle alakataloogid. Veenduge, et EELex ja selle alakataloogid oleksid loetavad ja kirjutatavad nii teile kui veebiserverile, unixi puhul võib kasutada ```chown -R minukasutajanimi:www-data EELex``` (Apache’i vm veebiserveri grupp võib erineda Ubuntu tavapärasest nimest ```www-data``` ja olla näiteks ```www``` või ```httpd```)


## Apache’i konfiguratsioon
Erinevalt eelmisest installeerimisjuhendist on EELex seekord virtuaalserveriks sobivamal kujul. Kataloog EELex on EELexi süsteemi juurkataloog ning andmed selle kohta tuleb lisada ka Apache konfiguratsioonifaili (```/etc/apache2/sites-available/default```). Veebidokumentide ja -skriptide jaoks on alakataloog ```data/```, muud kõrgema taseme kataloogid ei tohi olla veebis ligipääsetavad.

```<Directory /var/www/EELex/data>
	AddHandler cgi-script .cgi
	DirectoryIndex index.html index.htm index.cgi
	Options ExecCGI FollowSymLinks MultiViews
	AllowOverride All
	Order allow,deny
	allow from all
</Directory>```

Kui Apache veebiserveri „mime.types“ failis ei ole ikoonifailid (*.ico) kirjeldatud, tuleb seda teha, lisades rea ```image/x-icon ico```.

Ärge unustage kontrollida, kas Apache’i moodul auth_digest on sisse lülitatud (sümlink ```/etc/apache2/mods-enabled/auth_digest.load``` on olemas).
*.cgi failides on Perl-i interpretaatori asukohaks märgitud ```/usr/bin/perl```. Kui see on antud serveris erinev, on võimalik nt teha symlink asukohaga ```/usr/bin/perl``` ning mis viitab tegelikule asukohale. Peale nende muudatuste tegemist on EELexi süsteem kättesaadav aadressil http://minuserver.minudomeen.ee/EELex.


## EELex kataloogipuu ülesehitus
Peale kodulehe ```index.html``` on näha kataloogid ```shs``` ja ```shs_test```. Need on vastavalt EELexi süsteemi tööbaasi kataloog ja testbaasi kataloog. Töö- ja testbaasi kataloogid on üldjuhul (peale nt faili .htaccess) identsed.

Edasine struktuur on järgmine:
```__sr```	sõnastikud eri kataloogides, nende all sõnasiku XML-failid ja meediafailid
```backup```	jooksva koopia kataloog
```config```	toimetamisala (xsl2*) ja vaate (view*) genereerimise konfiguratsioonifailid
```css```	üldkasutatavad ja sõnastikupõhised toimetamisala ja vaate CSS-failid
```graphics```	EELexis kasutatavad graafikafailid
```help```	EELexi toimetaja juhend jt help-failid
```html```	kliendiskriptide failid
```install```	IE-põhised installeeritavad lisakomponendid
```logs```	sõnastike logifailid eri kataloogides
```temp```	ajutine kataloog serverioperatsioonidel
```xml```	sõnastikuartikli XML valmisplokid
```xsd```	sõnastiku skeemi ja andmetüüpide failid
```xsl```	üldkasutatavad ja sõnastikupõhised XSL teisendusfailid


## Kasutajate haldus
Pakis on vaikimisi üks kasutaja kasutajanimega ```PKasutaja``` ja parooliga ```parool```. Kasutajal on lisaks näidissõnaraamatu peatoimetaja õigustele ka administraatori õigused. Kui otsustate pärast EELexiga tutvumist seda edaspidi kasutama jääda, on soovitatav lisada endanimeline kasutaja, luua sellele administraatori õigused ja Paki Kasutaja eemaldada (või vähemalt mitte jätta arendajate ega administraatorite grupi liikmeks).
Kasutajaõiguste kontroll on EELexis integreeritud veebiserveri ligipääsuõigustega. Kõik EELexi registreeritud kasutajanimed ja paroolid on koondatud faili ```/shs_users/shs_digest_users.txt``` ning suur osa töökataloogidest ja failidest on veebis nähtavad ainult registreeritud kasutajatele. Seda, kas kasutajal on õigused konkreetsele sõnaraamatule toimetaja või vaatajana, määrab tööversiooni jaoks fail ```/shs_users/shs_groups.txt``` ja testversiooni jaoks ```shs_test_groups.txt```. Nende sisu kasutab lisaks veebiserverile ka sõnastike liides. Toimetaja õigused on grupi grp_*sid+ liikmetel, vaataja õigused annab grupp quest_*sid+ (*sid+ on sõnastiku kolmetäheline identifikaator). Grupp shs_DEV on arendajatele, ning annab kõik õigused kõigile sõnaraamatutele. shs_TEH on sisemiseks kasutuseks.
Ehkki kasutajaid saab lisada ja kustutada veebiserveri standardvarustusse kuuluva programmiga htdigest, on EELexil töö hõlbustamiseks kaasas paar lisaprogrammi kataloogis ```EELex/shs_access/```. ```ankeet.cgi``` on uue kasutaja andmete sisestamiseks, ```halda.cgi``` sõnastikuõiguste andmiseks/keelamiseks olemasolevatele kasutajatele ning ```login.cgi``` kiireks sisselogimiseks sõnastikesse. Need abiprogrammid eeldavad, et sõnastikud on eelnevalt olemas ning nende andmed leitavad failis ```/lexlist.xml```.

### Kasutaja lisamine
* Uus kasutaja avab ```ankeet.cgi``` ning sisestab oma andmed. NB! kasutaja soovitud parool jääb lahtise tekstina kirja faili ```ankeet.txt```. NB! kui kasutaja ei ole nõus automaatselt genereeritud kasutajanimega kujul eesnime esitäht pluss perekonnanimi või kattub see kombinatsioon mõne olemasoleva kasutaja kasutajanimega, tuleb seda muuta käsitsi.
* Haldur (arendaja, peatoimetaja vm, s.t nõutav on grp_DEV) avab ```halda.cgi``` ning otsustab avanenud veebilehe ülemises osas kuvatud ootel ankeetide kohta, kas need kustutada (soovimatu kasutaja, spämm vms) või lisada uueks EELexi kasutajaks. NB! Muutused rakenduvad koheselt.
* Haldur klõpsab registreeritud kasutaja nimel lehe allpoolses osas ning saab lisada või ära võtta õigusi sõnaraamatutele.

### Kasutaja kustutamine
* tuleb avada ```halda.cgi```, klõpsata kasutajanimel ning klõpsata lingil Kustuta see kasutaja. Juhul, kui kasutajal oli eelnevalt täidetud ankeet, ilmub see nüüd tagasi ootel ankeetide nimekirja. See annab võimaluse kasutaja kas taastada (nt kogemata kustutamisel, taastuvad ka kõik varem kehtinud õigused sõnaraamatutele) või kustutada ka ankeet.

### Kasutaja muutmine
Parooli või oma meiliaadressi muutmine liidese kaudu on võimalik kaudsete vahenditega. Kasutaja täidab uue ankeedi muutunud andmetega ning halduril on paari klõpsuga võimalik olemasolev kasutaja kustutada, seejärel kustutada ootel ankeetide hulgast esimese(d) selle kasutaja ankeedi(d), jättes alles vaid nimekirjas viimase ja lisada kasutaja tagasi.
Tehniliste kontode ning arendajate-haldajate nimekirja saab grupifailis muuta ainult käsitsi.

# Abi ja küsimused
Lingid täiendavale dokumentatsioonile leiate [EELexi avalehelt](http://eelex.eki.ee/), küsimuste ja ettepanekutega palume pöörduda meilitsi eelex@eki.ee
