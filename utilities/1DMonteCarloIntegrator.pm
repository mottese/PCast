#!/usr/bin/perl

use strict;
use warnings;

use POSIX;

our $pi = 3.14159;

#main();

sub main {
  my $a = 0;
  my $b = 5;
  my $n = 10000;

  my $result = integrate(\&f1, $a, $b, $n); #\&f1 is a reference to the f1 subroutine
  print "f1: " . $result . "\n\n";
  
  $result = integrate(\&f2, $a, $b, $n);
  print "f2: " . $result . "\n\n";
  
  $result = integrate(\&f3, $a, $b, $n);
  print "f3: " . $result . "\n";
}

#our 1st function f(x) = x^2
sub f1 {
  my $x = shift;
  return ($x * $x);
}

#our 2nd function f(x) = x^2 + 3x + 5
sub f2 {
  my $x = shift;
  return (($x * $x) + (3 * $x) + 5);
}

#our 3rd function f(x) = xcos(10x)
sub f3 {
  my $x = shift;
  return ($x * cos(10 * $x));
}





sub integrate {
  my ($f, $a, $b, $count) = @_;
  
  my $rangeReference = uniformRange($a, $b, $count);
  #my $rangeReference = chebyshevPoints($a, $b, $count);
  my @range = @$rangeReference; #dereference the range pointer
  
  my @mappedRange = map(&$f($_), @range); #functional style. using map to apply the given function to each element of the array
    
  my $sum = 0;
  for(my $i = 0; $i < @mappedRange; $i++) {
    $sum = $sum + $mappedRange[$i]; #sum up the elements of the array
  }
  
  return (($b - $a) / $count) * $sum; #function is broken into rectanges of width b-a/count, so you have to multiply the sum by that
}

sub uniformRange {
  my ($a, $b, $count) = @_;
  my @range;
  
  my $increment = ($b - $a) / ($count-1);
  for(my $i = 0; $i < $count; $i++) {
    $range[$i] = $increment * $i;
  }
  
  return \@range; #reference to the range array
}

sub chebyshevPoints {
  my ($a, $b, $count) = @_;
  my @range;
  
  for(my $i = 1; $i <= $count; $i++) {
    $range[$i - 1] = cos((((2*$i)-1)/(2*$count))*$pi);
	
	$range[$i - 1] = ((($range[$i - 1] - (-1)) * ($b - $a)) / 2) + $a; #scales from [-1, 1] to [a,b]
  } 
  
  return \@range; #reference to the range array
}

1;