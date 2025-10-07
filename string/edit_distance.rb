require 'minitest/autorun'

def edit_distance(s1, s2)
  dp = Array.new(s1.length+1){ Array.new(s2.length+1) }

  (s2.length+1).times { |i| dp[0][i] = i }
  (s1.length+1).times { |i| dp[i][0] = i }

  (1..s1.length).each do |i|
    (1..s2.length).each do |j|
      if s1[i-1] == s2[j-1]
        dp[i][j] = dp[i-1][j-1]
      else
        dp[i][j] = 1+[dp[i][j-1], dp[i-1][j-1], dp[i-1][j]].min
      end
    end
  end

  dp[s1.length][s2.length]
end

class EditDistanceTest < Minitest::Test
  def test_edit_distance
    assert_equal 1, edit_distance("geek", "gesek")
    assert_equal 0, edit_distance("gfg", "gfg")
    assert_equal 3, edit_distance("abcd", "bcfe")
  end
end
