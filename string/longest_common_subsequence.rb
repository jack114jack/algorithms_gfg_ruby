require 'minitest/autorun'

class LCS
  def initialize(s1, s2)
    @s1 = s1
    @s2 = s2

    @s1l = s1.length
    @s2l = s2.length
  end

  def find
    raise NotImplementedError
  end
end

class RecursiveLCS < LCS
  def find
    recursive_find(@s1, @s2, @s1l, @s2l)
  end

  def recursive_find(s1, s2, s1l, s2l)
    return 0 if s1l == 0 || s2l == 0
  
    if s1[s1l - 1] == s2[s2l - 1]
      return 1 + recursive_find(s1, s2, s1l - 1, s2l - 1)
    else
      return [recursive_find(s1, s2, s1l - 1, s2l), recursive_find(s1, s2, s1l, s2l - 1)].max
    end
  end
end

class MemoizeLCS < LCS
  def find
    memo = Array.new(@s1l+1) { Array.new(@s2l+1) }
    memoize_find(@s1, @s2, @s1l, @s2l, memo)
  end

  def memoize_find(s1, s2, s1l, s2l, memo)
    return 0 if s1l == 0 || s2l == 0
  
    return memo[s1l][s2l] if memo[s1l][s2l]
  
    if s1[s1l-1] == s2[s2l-1]
      memo[s1l][s2l] = 1 + memoize_find(s1, s2, s1l-1, s2l-1, memo)
      return memo[s1l][s2l]
    else
      memo[s1l][s2l] = [memoize_find(s1, s2, s1l-1, s2l, memo), memoize_find(s1, s2, s1l, s2l-1, memo)].max
      return memo[s1l][s2l]
    end
  end
end

class BottomUpLCS < LCS
  def find
    dp = Array.new(@s1l) { Array.new(@s2l) { 0 } }

    1..(@s1l+1).each do |i|
      1..(@s2+1).each do |j|
        if @s1[i] == @s2[j]
          dp[i][j] = dp[i-1][j-1]
        else
          dp[i][j] = [dp[i][j-1], dp[i-1][j]].max
        end
      end
    end

    dp[@s1l][@s2l]
  end
end

class LCSFactory
  def self.find(method, s1, s2)
    case method
    when :mem
      MemoizeLCS.new(s1, s2).find
    when :rec
      RecursiveLCS.new(s1, s2).find
    when :bot
      RecursiveLCS.new(s1, s2).find
    else
      raise "Unknown #{method}"
    end
  end
end

class TestLongestCommonSubSequence < Minitest::Test
  def test_find_lcs_using_recursion
    assert_equal 2, LCSFactory.find(:rec, "ABC", "ACD")
    assert_equal 4, LCSFactory.find(:rec, "AGGTAB", "GXTXAYB")
    assert_equal 1, LCSFactory.find(:rec, "ABC", "CBA")
  end

  def test_find_lcs_using_memoization
    assert_equal 2, LCSFactory.find(:mem, "ABC", "ACD")
    assert_equal 4, LCSFactory.find(:mem, "AGGTAB", "GXTXAYB")
    assert_equal 1, LCSFactory.find(:mem, "ABC", "CBA")
  end
end
