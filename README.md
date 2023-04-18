# raku-terminal-size
Terminal::Size - raku programming language library to get a tty size
Works on Linux, MacOS* and BSD*
## Example using STDOUT
```raku
#!/usr/bin/raku
use Terminal::Size;

my winsize $size = terminal-size();
my uint16  $rows = $size.rows; # 76
my uint16  $cols = $size.cols; # 310
```

## Example using custom IO::Handle
```raku
#!/usr/bin/raku
use Terminal::Size;

my $fd = "somefile.tty".IO.open: :r;

my $size = terminal-size($fd);

if !$size { # Failure
    note "Failed " ~ $size.exception.message;
    exit 1;
}

my uint16  $rows = $size.rows; # 76
my uint16  $cols = $size.cols; # 310
```

## Exported symbols
- &terminal-size( IO::Handle:D $fd = $*OUT )
- struct winsize

## Supported OS
- Linux
- *BSD  ( needs testing )
- MacOS ( needs testing )

## Method used to get the info
### In short it should support all POSIX compatible systems
```bash
ioctl $FD TIOCGWINSZ *winsize
```
