#!/usr/bin/perl -I /root/tgmanage
use strict;

use Net::IP;

BEGIN {
        require "include/config.pm";
        eval {
                require "include/config.local.pm";
        };
}

my $base = "/etc";
$base = $ARGV[0] if $#ARGV > -1;
$base .= "/" if not $base =~ m/\/$/ and not $base eq "";

my $tgname    = $nms::config::tgname;
my $pri_hostname     = $nms::config::pri_hostname;
my $pri_v4   = $nms::config::pri_v4;
my $pri_v6    = $nms::config::pri_v6;
my $sec_hostname     = $nms::config::sec_hostname;
my $sec_ptr   = $nms::config::sec_ptr;
my $sec_v6    = $nms::config::sec_v6;
my $ipv6zone = $nms::config::ipv6zone;

# FIXME: THIS IS NOT APPRORPIATE!
my $serial = `date +%Y%m%d01`;
chomp $serial;
# FIXME

my $zonefile;

$zonefile = $base . "bind/" . $tgname . ".gathering.org.zone";
if ( not -f  $zonefile )
{
	print $zonefile . "\n";
	open MAINZONE, ">" . $zonefile or die $! . " " . $zonefile;

	print MAINZONE <<"EOF";
\$TTL 3600
@	IN	SOA	$pri_hostname.$tgname.gathering.org.	abuse.gathering.org. (
			$serial; serial
			3600 ; refresh 
			1800 ; retry
			608400 ; expire
			3600 ) ; minimum and default TTL

		IN	NS	ns1.$tgname.gathering.org.
		IN	NS	ns2.$tgname.gathering.org.

ns1		IN	A	$pri_v4
ns1		IN	AAAA	$pri_v6
ns2		IN	A	$sec_ptr
ns2		IN	AAAA	$sec_v6
$pri_hostname		IN	A	$pri_v4
$pri_hostname		IN	AAAA	$pri_v6
$sec_hostname		IN	A	$sec_ptr
$sec_hostname		IN	AAAA	$sec_v6

; Generated by make-all-config.sh on the bootstrapping/nms server.
; Will not be overwritten unless it is missing ;)

EOF
	close MAINZONE;
}
else { print "Skipped TG-zone, file exists.\n"; }

$zonefile = $base . "bind/infra." . $tgname . ".gathering.org.zone";
if ( not -f  $zonefile )
{
	print $zonefile . "\n";
	open MAINZONE, ">" . $zonefile or die $! . " " . $zonefile;

	print MAINZONE <<"EOF";
\$TTL 3600
@	IN	SOA	$pri_hostname.$tgname.gathering.org.	abuse.gathering.org. (
			$serial; serial
			3600 ; refresh 
			1800 ; retry
			608400 ; expire
			3600 ) ; minimum and default TTL

		IN	NS	$pri_hostname.$tgname.gathering.org.
		IN	NS	$sec_hostname.$tgname.gathering.org.

; Generated by make-all-config.sh on the bootstrapping/nms server.
; Will not be overwritten unless it is missing ;)
EOF
	close MAINZONE;
}
else { print "Skipped infra-zone, file exists.\n"; }

$zonefile = $base . "bind/" . $ipv6zone . ".zone";
if ( not -f  $zonefile )
{
	print $zonefile . "\n";
	open IPV6ZONE, ">" . $zonefile or die $! . " " . $zonefile;

	print IPV6ZONE <<"EOF";
; autogenerated, and updated from dhcpd -- DO NOT TOUCH!
\$TTL 3600
@       IN      SOA     ns1.$tgname.gathering.org. abuse.gathering.org. (
			$serial; serial
                        3600 ; refresh
                        1800 ; retry
                        608400 ; expire
                        3600 ) ; minimum and default TTL

                IN      NS      ns1.$tgname.gathering.org.
                IN      NS      ns2.$tgname.gathering.org.

; WARNING! Do not edit this file directly!
; on the bootstrapping/nms server!

EOF
	my $ip_pri = new Net::IP( $pri_v6 ) or die ( "Error, new Net::IP for " . $pri_v6 );
	my $ip_sec = new Net::IP( $sec_v6 ) or die ( "Error, new Net::IP for " . $sec_v6 );
	print IPV6ZONE $ip_pri->reverse_ip() . " IN PTR ns1.$tgname.gathering.org.\n";
	print IPV6ZONE $ip_pri->reverse_ip() . " IN PTR $pri_hostname.$tgname.gathering.org.\n";
	print IPV6ZONE $ip_sec->reverse_ip() . " IN PTR ns2.$tgname.gathering.org.\n";
	print IPV6ZONE $ip_sec->reverse_ip() . " IN PTR $sec_hostname.$tgname.gathering.org.\n";
	close IPV6ZONE;
}
else { print "Skipped v6-reverse-zone, file exists.\n"; }
