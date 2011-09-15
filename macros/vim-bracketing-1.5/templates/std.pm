########################################################################
#  Description:
#
#  «filename»
#	«full description»
#
########################################################################
#
#  Attributes:
# 	«attribute name»	«description of attribute»
# 	«attribute name»	«description of attribute»
# 	«attribute name»	«description of attribute»
#
########################################################################
#
#  Methods:
#	«method name»( «arguments» )
#		«description of method and options»
#
########################################################################
#
#  Administration:
#
#    Author:		Stephen Riehm, PC-Plus Computing, Germany
#    Maintainer:	Author
#    Creation date:	«today's date»
#    Version date:	$Id:$
#
#    $Log:$
#
########################################################################

package «the name of the package»;
use strict;

#
# «comments about module - with description of args and function»
#
sub new
{
    my $class = shift;
    my %parameters = @_;
    my $self = {};
    my $option;
    my $value;
    my %defaults = (
	    «attribute» => «value»,
	    );

    #
    # set up initial state, first by using the defaults, and then by
    # using the parameters bassed by the user
    #
    %{$self} = %defaults;
    while( ( $option, $value ) = each( %parameters ) )
    {
	$option =~ s/^-//;
	if( ! defined( $defaults{$option} ) )
	{
	    warn "$class->new(): Invalid option $option\n";
	}
	$self->{$option} = $value;
    }

    «extra initialisation - preferably a call to an extra init functin»

    return bless $self, $class;
}

########################################################################
#
# Generic routines for getting and setting attributes of this class
#
########################################################################

#
# the user simply needs to supply the name of the attribute which
# should be retrieved. (calculated or normal)
#
sub get
{
    my $self = shift;
    my $varName = shift;
    my $value = undef;

    # attributes which can only be retreived via a function call
    # $value = $self->get«»()	if $varName eq "«»";

    # attributes which may be retreived directly
    $value = $self->{$varName}	if $value == undef; 

    return( $value );
}

#
# the user needs to supply the name of the attribute, and the value that
# it should be set to.
#
# This caters for read only attributes, and attributes which can only
# be set via a function.
#
sub set
{
    my $self = shift;
    my $varName = shift;
    my $value = "@_";
    my $return = undef;

    # read only attribute simply ignore the incomming value
    # $return = $self->{$varName}		if $varName eq "«»";

    # attributes which may only be set via a function
    # $return = $self->set«»( $value )		if $varName eq "«»";

    # attributes which may be set directly (default)
    $return = ( $self->{$varName} = $value )	if $varName == undef;

    return( $return );
}

1;
