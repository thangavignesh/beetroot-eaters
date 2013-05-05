use strict;
use warnings;

use LWP::UserAgent;

my $ua = LWP::UserAgent->new(
    requests_redirectable => [],
);

my $res = $ua->get( shift );
print $res->status_line, "\n", 'Location: ', $res->header( 'location' ), "\n";

print $res->decoded_content;
