unit module Terminal::Size:ver<1.0.1>:auth<zef:demayl>;
use NativeCall;

# from termios.h
class winsize is repr('CStruct') is export {
    has uint16 $.rows;      #/* Number of rows, in characters */
    has uint16 $.cols;      #/* Number of columns, in characters */
    has uint16 $.xpixel;    #/* Width, in pixels */
    has uint16 $.ypixel;    #/* Height, in pixels */

    method gist() {
        return "rows={self.rows} cols={self.cols} pixels={self.xpixel}x{self.ypixel}"
    }

}

constant TIOCGWINSZ = 0x5413;
constant EBADF 		= 9;  # Bad file descriptor
constant EFAULT 	= 14; # Bad struct address
constant ENOTTY 	= 25; # Not a tty

# tcgetwinsize
sub ioctl(int32 $fd, int32 $cmd, winsize $winsize) returns int32 is native { * }

my $err := cglobal('libc.so.6', 'errno', int32);

multi sub terminal-size(IO::Handle:D $fd = $*OUT --> winsize) is export {

	fail "File does not represent a terminal device capable of remembering a window size." unless $fd.t;

	my winsize $winsize .= new;
	my $result = ioctl($fd.native-descriptor, TIOCGWINSZ, $winsize);

	if $result == -1 {
		given $err {
			when EBADF  { fail "Bad file descriptor"	}
			when EFAULT { fail "Bad address. See the struct" }
			when ENOTTY { fail "File does not represent a terminal device capable of remembering a window size." }
			default     { fail "Unknown err code '$err'" }
		}
	}

	$winsize
}

multi sub terminal-size(IO::Handle:U) { fail "FD is closed" }

