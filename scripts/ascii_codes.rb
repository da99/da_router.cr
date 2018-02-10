#!/usr/bin/env ruby

CODES = {}

[":?!@\#$%^&/_".chars, 'a'..'z', 'A'..'Z'].each { |group|
  group.each { |k|
    puts "#{k} #{k.ord}"
  }
}
