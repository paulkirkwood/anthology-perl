package Anthology;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application.
#
# Note that ORDERING IS IMPORTANT here as plugins are initialized in order,
# therefore you almost certainly want to keep ConfigLoader at the head of the
# list if you're using it.
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    -Debug
    ConfigLoader
    Static::Simple
/;

extends 'Catalyst';

our $VERSION = '0.01';

__PACKAGE__->config(
    name => 'Anthology',
    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
    enable_catalyst_header => 1, # Send X-Catalyst header
);

__PACKAGE__->config(map => {
    'text/x-yaml' => 'YAML',
    'application/json' => 'JSON',
});
 
# Start the application
__PACKAGE__->setup();

=encoding utf8

=head1 NAME

Anthology - Catalyst based application

=head1 SYNOPSIS

    script/anthology_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<Anthology::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Paul

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
