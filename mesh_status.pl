#!/usr/bin/perl

# 06/2014 arnim@posteo.de
use JSON;
use Data::Dumper;

$tmpfile = "/tmp/mesh_status.tmp";
$results = {};

system("batadv-vis -f jsondoc > $tmpfile");

my $json;

{
 local $/; #Enable 'slurp' mode
 open my $fh, "<", "$tmpfile" || die "Konnte json file $tmpfile nicht öffnen\n";
 $json = <$fh>;
 close $fh;
}
        
my $data = decode_json($json);


my @primarys = @{ $data->{'vis'} };


foreach my $p ( @primarys ) {
    @clients =  @{ $p->{'clients'} };
    
#    print "P: ".$p->{'primary'}."\n";
    $pr = $p->{'primary'};

    $clientcount = scalar(@clients)-1;
    $results->{$pr}->{clients} = $clientcount;
}

$nodes = 0;
$total_clients = 0;
foreach $r (keys %$results) {
    print "Knoten:".$r.":".$results->{$r}->{'clients'}."\n";
    $nodes++;
    $total_clients = $total_clients + $results->{$r}->{'clients'};
}

print "Total:$nodes:$total_clients\n";
unlink($tmpfile); 
