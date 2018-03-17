#!/usr/bin/perl

use strict;
use warnings;
use IO::Socket::SSL;
use Mail::POP3Client;

main();

sub connect_to_server
{
    my ($server, $port, $user, $password) = @_; 

    my $socket = IO::Socket::SSL->new(PeerAddr => $server,
				      PeerPort => $port,
				      Proto    => 'tcp') || die "No socket!";
    my $pop = Mail::POP3Client->new();
    $pop->User($user);
    $pop->Pass($password);
    $pop->Socket($socket);
    $pop->Connect();
    return $pop;
}

sub get_message
{
    my $connect = shift;
    
    for (my $i = 1; $i <= $connect->Count(); $i++) 
    {
	foreach ($connect->Head($i)) 
	{
	    #/^(From|Subject):\s+/i and print $_, "\n";
	    /^Subject:\s?Zabbix/i and print $_, "\n";
	    #connect->Delete($1);
	}
    }
    $connect->Close();
}

sub send_to_zabbix
{
  
}

sub parse_argv
{
    return $server, $port, $user, $password
}

sub main
{
    my ($server, $port, $user, $password) = parse_argv();
    my $connect = connect_to_server($server, $port, $user, $password);
    get_message($connect);
}
