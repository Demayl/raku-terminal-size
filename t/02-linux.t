use v6;
use Test;
use Terminal::Size;

plan 4;

if $*KERNEL !~~ 'linux' {
    skip-rest "Not a Linux based OS";
    exit 0;
}

my $pty = $*OUT.t ?? 'stderr' !! "ptmx";

# XXX just a hack to pass tests without pty allocated
my $fd = "/dev/$pty".IO.open: :r;

unless $fd.t {
    skip-rest "tty not allocated";
    exit 0;
}

#shell "stty rows 60 cols 50 -F /dev/$pty";

my $proc = shell "stty -F /dev/$pty size", :out;

my $rows-cols = $proc.out.slurp(:close);
my $size = terminal-size($fd);
my ( $rows, $cols ) = $rows-cols.chomp.split(" ");

ok $size, "Got size";
is $rows, $size.rows, 'OK rows';
is $cols, $size.cols, 'OK cols';
is $proc.exitcode, 0, "Got size with stty";

done-testing;
