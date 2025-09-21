require 'minitest/autorun'

class TestWildcardPatternMatching < Minitest::Test
  def test_positive_wilcard_pattern_matching
    str = "abcde"
    pat = "a?c*"
    assert_equal true, wilcard_pattern_matching(str, pat), "For #{str} and #{pat}"

    str = "a cde"
    pat = "a?c*"
    assert_equal true, wilcard_pattern_matching(str, pat), "For #{str} and #{pat}"

    str = "baaabab"
    pat = "*****ba*****ab"
    assert_equal true, wilcard_pattern_matching(str, pat), "For #{str} and #{pat}"

    str = "abc"
    pat = "*"
    assert_equal true, wilcard_pattern_matching(str, pat), "For #{str} and #{pat}"
  end

  def test_negative_wilcard_pattern_matching
    str = "baaabab"
    pat = "a*ab"
    assert_equal nil, wilcard_pattern_matching(str, pat), "For #{str} and #{pat}"
  end
end

def wilcard_pattern_matching(str, pat)
  str = str.chars
  pat = pat.gsub(/\*+/, "*").chars

  strl = str.length
  patl = pat.length

  dp = Array.new(strl+1) { Array.new(patl+1) }
  
  if patl > 0 && pat[0] == "*"
    dp[0][1] = true
  end

  dp[0][0] = true

  1.upto(strl) do |i|
    1.upto(patl) do |j|
      if str[i-1] == pat[j-1] || pat[j-1] == "?"
        dp[i][j] = dp[i-1][j-1]
      elsif pat[j-1] == "*"
        dp[i][j] = dp[i-1][j] || dp[i][j-1]
      end
    end
  end

  dp[strl][patl]
end
