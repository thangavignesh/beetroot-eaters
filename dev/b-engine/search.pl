#!/usr/bin/perl

BEGIN{
	push @INC, "/apps/beetroot-eaters/dev/b-engine/modules/share/perl/5.10.1";
	push @INC, "/apps/beetroot-eaters/dev/b-engine/modules/share/perl/5.14.2";
}

require "AHRSearch.pm";
use URI::Escape;

my $URL = "http://www.patentlens.net";
$objSearch = new AHRSearch->new();
$objContent = $objSearch->{_browser}->get("$URL/daisy/patentlens/ip/around-the-world.html");
	
$continents = $objSearch->getContinents($objContent->decoded_content);

foreach my $region ( keys %{$continents} )
{
	printf "---------------------------------------\n";
	printf "%s: %s\n", $region, $continents->{$region};
	printf "---------------------------------------\n";
	$objContent = $objSearch->{_browser}->get("$URL".$continents->{$region});
	my $agencies = $objSearch->getAgencies($objContent->decoded_content);	
	
	foreach my $agency ( keys %{$agencies} )
	{
		printf "%s: %s\n", $agency, $agencies->{$agency};
	}
}


 exit(0);

