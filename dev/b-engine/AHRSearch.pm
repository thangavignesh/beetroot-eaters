package AHRSearch;

use LWP;
use HTML::TagParser;
use Data::Dumper;

sub new {
	my $self = {
					_browser => LWP::UserAgent->new(
									requests_redirectable => []
								       ),
					_response => undef,
					_debug    => 0
				};
				bless $self, 'AHRSearch';
				return $self;
		}
	



sub parseOutput
{
	my($self, $content) = @_;
	my @result = ();
	
	@matches = ($content =~ m/<!-- results listing -->(.*?)<!-- links to other result pages-->/ig);
	@matchList = split(/-->\s+<br\/>/, $matches[0]);
	print "\nMatched List: ". $#matchList;
	foreach my $content (@matchList)
	{
		if($content =~ m/<a\s+href="(.*?)"\s+class="title">(.*?)<\/a>\s+<br>(.*?)$/ig)
		{
			my @recordSet = ["$1","$2","$3"];
			push @result, @recordSet;	
		}
	}
	return @result;
}

sub getContinents(;$)
{
	my($self, $content) = @_;
	my $objHTML = HTML::TagParser->new($content);
	my $continents = {};
	my @aTags = $objHTML->getElementsByTagName("a");
	foreach my $element ( @aTags )
	{
		if( $element->attributes->{title} =~ m/^.*Region(.*?)$/gi)
		{
			my $region = $1;
			chomp( $region );
			$continents->{$region} = $element->attributes->{href};	
		}
	}	
	return $continents;
}

sub getAgencies(;$)
{
	my($self, $content) = @_;
	my $objHTML = HTML::TagParser->new($content);
	my @aTags = $objHTML->getElementsByTagName("a");
	my $agencies = {};

	foreach my $element ( @aTags )
	{
		if( $element->attributes->{target} =~ m/new/gi )
		{
			$agencies->{$element->innerText} = $element->attributes->{href};
		}
	}
	return $agencies;
}
1;
