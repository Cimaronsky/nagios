#!/usr/bin/perl

#Created by Krasi Nachev

my $what = $ARGV[0];
my %ERRORS=('OK'=>0,'WARNING'=>1,'CRITICAL'=>2);
my ($asterisk,$statd);
my $astd  = "/var/run/asterisk/asterisk.pid";   #Where is your asterisk PID file
my $grep = "ps ax |grep";

 unless (-e $astd) {
      print "CRITICAL - Asterisk\n";
       exit $ERRORS{'CRITICAL'};
}
  open ASTFILE,"$astd" or die "Can not open ASTFILE file: $!";
        $statd = readline(*ASTFILE);
         chomp $statd;
        $statd = `$grep $statd`;
      unless ($statd =~ m|asterisk|) {
           print "CRITICAL -Asterisk\n";
                    exit $ERRORS{'CRITICAL'};
         } else  {
          print "OK - Asterisk\n";
            exit $ERRORS{'OK'};

              }

