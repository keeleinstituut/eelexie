package SHS_cfg;
use strict;
use warnings;

use utf8;
use Encode 'decode_utf8';
binmode(STDOUT, ":utf8");


BEGIN {
    use Exporter ();
    our (@ISA, @EXPORT, @EXPORT_OK);
    @ISA = qw(Exporter);
    @EXPORT_OK = qw( SHS_root_dir SHS_work_dir SHS_test_dir SHS_backup_dir SHS_temp_dir SHS_dmacro_file SHS_lexlist_file SHS_templates_dir SHS_logs_dir SHS_dmacro_id_file);
    our %EXPORT_TAGS = ( dir => [ 'SHS_root_dir', 'SHS_work_dir', 'SHS_test_dir', 'SHS_backup_dir', 'SHS_temp_dir' , 'SHS_templates_dir', 'SHS_logs_dir'],
                          file => [ 'SHS_dmacro_file', 'SHS_dmacro_id_file', 'SHS_lexlist_file' ]);
}
our @EXPORT_OK;

#Sõnastiku taastamiseks Backupist
#use constant SHS_root_dir => '/koopiaKL/L/apache22/data/' ;

#use constant SHS_root_dir => '/koopiaEN/N/apache22/data/';
use constant SHS_root_dir => '/var/www/EELex/data/' ;
use constant SHS_root2_dir => '/var/www/EELex/data/shs_manager/' ;

use constant SHS_work_dir =>  SHS_root_dir.'__shs/' ;
use constant SHS_test_dir =>  SHS_root_dir.'__shs_test/' ;
use constant SHS_backup_dir =>  SHS_root2_dir.'__shs_backup/'; 
use constant SHS_templates_dir =>  SHS_root2_dir.'__shs_templates/' ;
use constant SHS_logs_dir =>  SHS_root2_dir.'__shs_logs/' ;
use constant SHS_temp_dir =>  SHS_root2_dir.'__shs_temp/';


use constant SHS_dmacro_file =>  SHS_root2_dir.'SHS_dmacro.xml';
use constant SHS_dmacro_id_file =>  SHS_root2_dir.'SHS_dmacro_id.xml';

use constant SHS_lexlist_file =>  SHS_root_dir.'lexlist.xml';



sub SHS_files() {
    return(SHS_root_dir,SHS_work_dir,SHS_test_dir ,SHS_backup_dir, SHS_temp_dir, SHS_logs_dir);
}


1;

