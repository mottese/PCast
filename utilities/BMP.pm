#!/usr/bin/perl

use strict;
use warnings;

package BMP;



sub new {
  my $class = shift;
  my($width, $height) = @_;  
  
  my $row_padding = (3 * $width) % 4;
  $row_padding = $row_padding ? (4 - $row_padding) : 0;
  my $row_size = 3 * $width + $row_padding;
  my $data_size = $height * $row_size;
  my $header_size = 54;
  my $file_size = $header_size + $data_size;
  my @rgb;
  $rgb[$width-1][$height-1][2] = undef; # Sizes array to width x height x 3 (3 for RGB)

  my $this = bless {
    _width  => $width,
    _height => $height,
    _row_padding => $row_padding,
    _row_size => $row_size,
    _data_size => $data_size,
    _header_size => $header_size,
    _file_size => $file_size,
    _rgb => \@rgb,
  }, $class;
  
  return $this;
}



sub getWidth {
  my($this) = @_;
  return $this->{_width};
}



sub getHeight {
  my($this) = @_;
  return $this->{_height};
}



sub set {
  my($this, $x, $y, $r, $g, $b) = @_;
  
  if ($r > 255) {
    $r = 255;
  }
  if ($g > 255) {
    $g = 255;
  }
  if ($b > 255) {
    $b = 255;
  }
  
  ${$this->{_rgb}}[$x][$y][0] = $r;
  ${$this->{_rgb}}[$x][$y][1] = $g;
  ${$this->{_rgb}}[$x][$y][2] = $b;
  
  return $this->{_rgb};
}


# Returns 24-bit pixel value in the form (Blue, Green, Red)
sub get {
  my($this, $x, $y) = @_;
  
  my $red = ${$this->{_rgb}}[$x][$y][0];
  if (not defined $red) {
    $red = 0;
  }
  
  my $green = ${$this->{_rgb}}[$x][$y][1];
  if (not defined $green) {
    $green = 0;
  }
  
  my $blue = ${$this->{_rgb}}[$x][$y][2];
  if (not defined $blue) {
    $blue = 0;
  }
  
  my $R = pack("C", $red);
  my $G = pack("C", $green);
  my $B = pack("C", $blue);

  return $B . $G . $R; 
}



sub print {
  my ($this, $fh) = @_;
  binmode($fh);
  
  #if ($ENV{'REQUEST_METHOD'})
  #{
  #  print CGI->header(
  #    -type => 'image/bmp',
  #    -Content_length => $file_size,
  #    -'content-disposition' => 'inline; filename="image.bmp"',
  #    -filename => 'image.bmp'
  #  );
  #}
  
  print $fh "\x42\x4D";                       # BMP magic number
  print $fh pack("V", $this->{_file_size});
  print $fh "\0\0\0\0";                       # Reserved
  print $fh pack("V", $this->{_header_size}); # Offset to the image data

  print $fh "\x28\0\0\0";                     # Header size (40 bytes)
  print $fh pack("V", $this->{_width});       # Bitmap width
  print $fh pack("V", $this->{_height});      # Bitmap height
  print $fh "\1\0";                           # Number of color planes
  print $fh "\x18\0";                         # Bits per pixel (24-bits)
  print $fh "\0\0\0\0";                       # Compression method
  print $fh pack("V", $this->{_data_size});   # Image data size
  print $fh "\x13\x0B\0\0";                   # Horizontal resolution (px/m)
  print $fh "\x13\x0B\0\0";                   # Vertical resolution (px/m)
  print $fh "\0\0\0\0";                       # Number of colors in palette
  print $fh "\0\0\0\0";                       # Number of important colors

  # Start of bitmap data
  for (my $y = $this->{_height} - 1; $y >= 0; $y = $y - 1) {
    for (my $x = 0; $x < $this->{_width}; $x = $x + 1) {
      print $fh get($this, $x, $y);
    }

    # Row padding
    for (my $p = 0; $p < $this->{_row_padding}; $p = $p + 1) {
      print $fh "\0";
    }
  }
 
}

1;








