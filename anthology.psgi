use strict;
use warnings;

use Anthology;

my $app = Anthology->apply_default_middlewares(Anthology->psgi_app);
$app;

