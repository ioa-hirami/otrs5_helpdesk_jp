# OTRS config file (automatically generated)
# VERSION:1.1
package Kernel::Config::Files::ZZZAuto;
use strict;
use warnings;
no warnings 'redefine';
use utf8;
sub Load {
    my ($File, $Self) = @_;
delete $Self->{'PreferencesGroups'}->{'SpellDict'};
$Self->{'CheckMXRecord'} =  '0';
delete $Self->{'NodeID'};
$Self->{'SecureMode'} =  '1';
}
1;
