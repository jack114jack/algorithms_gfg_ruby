require 'minitest/autorun'

class TestCheckForAnagram < Minitest::Test
  def test_check_for_anagram_sub
    assert_equal true, check_for_anagram_sub("geeks", "kseeg")
    assert_equal false, check_for_anagram_sub("allergy", "allergyy")
  end

  def test_check_for_anagram_eql
    assert_equal true, check_for_anagram_eql("geeks", "kseeg")
    assert_equal false, check_for_anagram_eql("allergy", "allergyy")
  end
end

def check_for_anagram_sub(s1, s2)
  farr = Array.new(26){0}

  s1.chars.each do |s|
    farr[s.ord - 'a'.ord] += 1
  end

  s2.chars.each do |s|
    farr[s.ord - 'a'.ord] -= 1
  end

  farr.each do |f|
    return false if f != 0
  end

  true
end

def check_for_anagram_eql(s1, s2)
  farr = Array.new(26){0}

  s1.chars.each do |s|
    farr[s.ord - 'a'.ord] += 1
  end

  s1h = farr.join
  farr = Array.new(26){0}

  s2.chars.each do |s|
    farr[s.ord - 'a'.ord] += 1
  end

  s2h = farr.join

  s1h == s2h
end

require 'benchmark'

Benchmark.bm do |x|
  x.report(:eql) { check_for_anagram_eql("abc"*1000, "abc"*1000) }
  x.report(:sub) { check_for_anagram_sub("abc"*1000, "abc"*1000) }
end
