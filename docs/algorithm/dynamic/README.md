## 5. 最长回文子串

- [原题链接](https://leetcode-cn.com/problems/longest-palindromic-substring/)
- [官方题解](https://leetcode-cn.com/problems/longest-palindromic-substring/solution/)

### 解法一：动态规划

[Python - 实现对求解最长回文子串的动态规划算法](https://blog.csdn.net/bailang_zhizun/article/details/80538774) 这篇文章讲得很好。

```python
class Solution(object):
    def longestPalindrome(self, s):
        """
        :type s: str
        :rtype: str
        """
        s_length = len(s)
        mark = [[0 for i in range(s_length)] for _ in range(s_length)]
        max_length = 0
        max_sub_str = ""
        
        for j in range(0, s_length):
            for i in range(0, j + 1):
                if j - i <= 1:
                    if s[i] == s[j]:
                        mark[i][j] = 1
                        if max_length < j - i + 1:
                            max_sub_str = s[i:j+1]
                            max_length = j - i + 1
                else:
                    if s[i] == s[j] and mark[i+1][j-1]:
                        mark[i][j] = 1
                        if max_length < j - i + 1:
                            max_sub_str = s[i:j+1]
                            max_length = j - i + 1
        return max_sub_str
```

## 39. Combination Sum

[原题链接](https://leetcode.com/problems/combination-sum/description/)

### 题目

Given a set of candidate numbers (candidates) (without duplicates) and a target number (target), find all unique combinations in candidates where the candidate numbers sums to target.

The same repeated number may be chosen from candidates unlimited number of times.

Note:

- All numbers (including target) will be positive integers.
- The solution set must not contain duplicate combinations.

Example 1:

    Input: candidates = [2,3,6,7], target = 7,
    A solution set is:
    [
      [7],
      [2,2,3]
    ]
    
Example 2:

    Input: candidates = [2,3,5], target = 8,
    A solution set is:
    [
      [2,2,2,2],
      [2,3,3],
      [3,5]
    ]
    
### Python

```python
class Solution(object):
    def combinationSum(self, candidates, target):
        """
        :type candidates: List[int]
        :type target: int
        :rtype: List[List[int]]
        """
        res = []
        candidates.sort()
        self.dfs(target, 0, [], res, candidates)
        return res

    def dfs(self, target, index, tmp_list, res, nums):
        if target < 0:
            return
        if target == 0:
            res.append(tmp_list)
            return
        for i in xrange(index, len(nums)):
            self.dfs(target - nums[i], i, tmp_list + [nums[i]], res, nums)
```


## 40. Combination Sum II

[原题链接](https://leetcode.com/problems/combination-sum-ii/description/)

### 题目

Given a collection of candidate numbers (candidates) and a target number (target), find all unique combinations in candidates where the candidate numbers sums to target.

Each number in candidates may only be used once in the combination.

Note:

- All numbers (including target) will be positive integers.
- The solution set must not contain duplicate combinations.

Example 1:

    Input: candidates = [10,1,2,7,6,1,5], target = 8,
    A solution set is:
    [
      [1, 7],
      [1, 2, 5],
      [2, 6],
      [1, 1, 6]
    ]

Example 2:

    Input: candidates = [2,5,2,1,2], target = 5,
    A solution set is:
    [
      [1,2,2],
      [5]
    ]

### Python

```python
class Solution(object):
    def combinationSum2(self, candidates, target):
        """
        :type candidates: List[int]
        :type target: int
        :rtype: List[List[int]]
        """
        res = []
        candidates.sort()
        self.dfs(target, 0, [], res, candidates)
        return res

    def dfs(self, target, index, tmp_list, res, nums):
        if target < 0:
            return
        if target == 0:
            if tmp_list not in res:
                res.append(tmp_list)
            return
        for i in xrange(index, len(nums)):
            self.dfs(target - nums[i], i + 1, tmp_list + [nums[i]], res, nums)
```


## 53. 最大子序和

[原题链接](https://leetcode-cn.com/problems/maximum-subarray/)

### 思路

动态规划。

1. 定义一个函数 `f(n)`，以第 n 个数为结束点的子数列的最大和，存在一个递推关系 `f(n) = max(f(n-1) + A[n], A[n])`
2. 将这些最大和保存下来后，取最大的那个就是，最大子数组和

```python
class Solution(object):
    def maxSubArray(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        sum_num = 0
        max_num = nums[0]
        for n in nums:
            sum_num += n
            if sum_num > max_num:
                max_num = sum_num
            if sum_num < 0:
                sum_num = 0 
        return max_num
```


## 55. 跳跃游戏

[原题链接](https://leetcode-cn.com/problems/jump-game/comments/)

### 思路

数组从后往前遍历：

- 如果该位置能跳跃到达最后一位：截断数组，置数组最后一位下标 `end = i`
- 该位置不能跳跃到达最后一位：继续向前遍历

遍历结束后判断 `end` 的位置，如果数组仅剩一位元素则返回 `True`。

```python
class Solution(object):
    def canJump(self, nums):
        """
        :type nums: List[int]
        :rtype: bool
        """
        length = len(nums)
        if length == 1:
            return True
        
        end = length - 1
        for i in reversed(range(length - 1)):
            if i + nums[i] >= end:
                end = i
        
        if end == 0:
            return True
        else:
            return False
```


## 62. 不同路径

[原题链接](https://leetcode-cn.com/problems/unique-paths/submissions/)

### 思路

动态规划。

走到一个格子的路径只有两种：

1. 从该格子左边的格子
2. 从该格子右边的格子

假设格子的坐标是 `(x, y)`，设能走到该格子的路径共有 `f(x, y)` 条。可以得出：

```
f(x, y) = f(x - 1, y) + f(x, y - 1)
```

即：**走到某个格子的路径数 = 走到其左边格子的路径数 + 走到其右边格子的路径数**。

得出这个公式就好办了，我们套公式来做~

```python
class Solution(object):
    def uniquePaths(self, m, n):
        """
        :type m: int
        :type n: int
        :rtype: int
        """
        if m == 0 or n == 0:
            return 0
        
        dp = [[0 for _ in range(n)] for _ in range(m)]
        dp[0][0] = 1
                
        for i in range(m):
            for j in range(n):
                if i - 1 >= 0:
                    dp[i][j] += dp[i - 1][j]
                if j - 1 >= 0:
                    dp[i][j] += dp[i][j - 1]
                
        return dp[m-1][n-1]
```

### 复杂度：

- 时间复杂度：`O(m*n)`
- 空间复杂度：`O(2n)`


## 70. 爬楼梯

[原题链接](https://leetcode-cn.com/problems/climbing-stairs/)

### 解题思路

### 方法一

递归，时间复杂度为 `O(n^2)`，会超时

```python
class Solution(object):
    def climbStairs(self, n):
        """
        :type n: int
        :rtype: int
        """
        return self.get_res(n)

    def get_res(self, n):
        if n < 1:
            return 0
        if n == 1:
            return 1
        if n == 2:
            return 2
        return self.get_res(n-1) + self.get_res(n-2)
```

### 方法二

斐波拉契数列。

```python
class Solution(object):
    def climbStairs(self, n):
        """
        :type n: int
        :rtype: int
        """
        a = 1
        b = 1
        for i in range(n):
            a, b = b, a+b
        return a
```

```python
class Solution(object):
    def climbStairs(self, n):
        """
        :type n: int
        :rtype: int
        """
        if n <= 2:
            return n
        
        pre1 = 1
        pre2 = 2
        
        for i in range(2, n):
            cur = pre1 + pre2
            pre1 = pre2
            pre2 = cur
            
        return cur
```


## 95. 不同的二叉搜索树 II

[原题链接](https://leetcode-cn.com/problems/unique-binary-search-trees-ii/)

### 思路

动态规划 + 递归。

如果将 i 作为跟节点，那么 `[1, i)` 为 i 的左子树节点，`(i, n]` 为右子树节点。

问题就被拆分为两个子问题了：

1. 求左子树的所有排列
2. 求右子树的所有排列

```python
# Definition for a binary tree node.
# class TreeNode(object):
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution(object):
    def generateTrees(self, n):
        """
        :type n: int
        :rtype: List[TreeNode]
        """
        res = []
        if n < 1:
            return res
        else:
            return self.generateBST(1, n)
        
    def generateBST(self, start, end):
        res = []
        if start > end:
            res.append(None)
            return res
        else:
            for i in range(start, end + 1):
                # 左子树
                left_tree = self.generateBST(start, i - 1)
                # 右子树
                right_tree = self.generateBST(i + 1, end)
                # 左子树、右子树的所有排列
                for left in left_tree:
                    for right in right_tree:
                        root = TreeNode(i)
                        root.left = left
                        root.right = right
                        res.append(root)
            return res
```


## 96. 不同的二叉搜索树
   
[原题链接](https://leetcode-cn.com/problems/unique-binary-search-trees/)

### 思路

动态规划。

- 设 n 个节点存在的二叉排序树的个数是 `G(n)`
- 设以 i 为根节点的二叉搜索树的个数为 `f(i)`

那么可以得到：

```
G(n) = f(1) + f(2) + f(3) + ... + f(n)
```

即：

```
G(n) = G(0) * G(n-1) + G(1) * G(n-2) + ... + G(n-1) * G(0)
```

```python
class Solution(object):
    def numTrees(self, n):
        """
        :type n: int
        :rtype: int
        """
        dp = [0 for _ in range(n + 1)]
        dp[0] = 1
        dp[1] = 1
        
        for i in range(2, n + 1):
            for j in range(1, i + 1):
                dp[i] += dp[j - 1] * dp[i - j]
        return dp[n]
```


## 152. 乘积最大子序列

- [原题连接](https://leetcode-cn.com/problems/maximum-product-subarray/submissions/)

### 思路

动态规划，两个数组放置最大值与最小值。

```python
class Solution(object):
    def maxProduct(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        length = len(nums)
        max_list = [0 for _ in range(length)]
        min_list = [0 for _ in range(length)]
        max_list[0] = nums[0]
        min_list[0] = nums[0]
        res = nums[0]
        
        for i in range(1, length):
            max_list[i] = max(max_list[i - 1] * nums[i], max(min_list[i - 1] * nums[i], nums[i]))
            min_list[i] = min(max_list[i - 1] * nums[i], min(min_list[i - 1] * nums[i], nums[i]))
            res = max(res, max_list[i])
        
        return res
```


## 198. 打家劫舍

[原题链接](https://leetcode-cn.com/problems/house-robber/)

### 思路

动态规划。

设打劫到第 `i` 家的最大收益为 `dp[i]`，则有：

```
dp[i] = max(dp[i - 2] + nums[i], dp[i - 1])
```

```python
class Solution(object):
    def rob(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        
        if not nums:
            return 0
        if len(nums) < 3:
            return max(nums)
        
        dp = [0 for _ in range(len(nums))]
        dp[0] = nums[0]
        dp[1] = max(nums[0], nums[1])
        
        for i in range(2, len(nums)):
            dp[i] = max(dp[i - 2] + nums[i], dp[i - 1])
            
        return dp[-1]
```


## 279. 完全平方数

[原题链接](https://leetcode-cn.com/problems/perfect-squares/)

### 思路

动态规划。

设 `f(n)` 表示组成和的完全平方数的最少个数，那么有：

```lisp
f(n) = min(f(n - num1), f(n - num2), ... , f(n - numx)) + 1
```

其中 `num1 ~ numx` 为若干个符合条件的完全平方数。

```python
import math

#f(12) = min(f(1), f(4), f(9)) + 1

class Solution(object):
    def numSquares(self, n):
        """
        :type n: int
        :rtype: int
        """
        max_num = int(math.floor(n ** 0.5))
        # 列出符合条件的完全平方数
        nums = [i*i for i in range(1, max_num + 1)]
        
        dp = dict()
        dp[0] = 0
        dp[1] = 1
        
        for i in range(1, n + 1):
            count = float('inf')
            for num in nums:
                if i - num >= 0:
                    count = min(count, dp[i - num] + 1)
                else:
                    break
            dp[i] = count
            
        return dp[n]
```

论动态规划，这题和 [322. 零钱兑换](https://leetcode-cn.com/problems/coin-change/) 思路挺像的。



## 300. 最长上升子序列

[原题链接](https://leetcode-cn.com/problems/longest-increasing-subsequence/)

### 思路

动态规划。

设到某位置 n 的最长上升子序列为 `f(n)`，那么有：

```
f(n) = max(f(n), f(x) + 1) (nums[n] > numx[x] and n > x)
```

```python
class Solution(object):
    def lengthOfLIS(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        length = len(nums)
        if length == 0:
            return 0
        
        dp = [1 for _ in range(length)]
        
        for i in range(1, length):
            for j in range(i):
                if nums[i] > nums[j]:
                    dp[i] = max(dp[i], dp[j] + 1)
        
        return max(dp)
```


## 322. 零钱兑换

[原题链接](https://leetcode-cn.com/problems/coin-change/comments/)

### 思路

比较典型的动态规划问题。

假设 `f(n)` 代表要凑齐金额为 n 所要用的最少硬币数量，那么有：

```
f(n) = min(f(n - c1), f(n - c2), ... f(n - cn)) + 1
```

其中 `c1 ~ cn` 为硬币的所有面额。

----

再具体解释一下这个公式吧，例如这个示例：

```
输入: coins = [1, 2, 5], amount = 11
输出: 3 
解释: 11 = 5 + 5 + 1
```

题目求的值为 `f(11)`，第一次选择硬币时我们有三种选择。

假设我们取面额为 1 的硬币，那么接下来需要凑齐的总金额变为 `11 - 1 = 10`，即 `f(11) = f(10) + 1`，这里的 `+1` 就是我们取出的面额为 1 的硬币。

同理，如果取面额为 2 或面额为 5 的硬币可以得到：

- `f(11) = f(9) + 1`
- `f(11) = f(6) + 1`

所以：

```
f(11) = min(f(10), f(9), f(6)) + 1
```

Python 代码：

```python
class Solution(object):
    def coinChange(self, coins, amount):
        """
        :type coins: List[int]
        :type amount: int
        :rtype: int
        """
        res = [0 for _ in range(amount + 1)]
        m = float('inf')
        
        for i in range(1, amount + 1):
            cost = float('inf')
            for c in coins:
                if i - c >= 0:
                    cost = min(cost, res[i - c] + 1)
            res[i] = cost
        
        if res[amount] == float('inf'):
            return -1
        else:
            return res[amount]
```


## 338. 比特位计数

[原题链接](https://leetcode-cn.com/problems/counting-bits/description/)

### 思路

动态规划无疑了

考虑二进制数的规律。

`[000,001,010,011,100,101,110,111]`，分别对应 `[0,1,2,3,4,5,6,7]`

- 4-7 的二进制数既是对 0-3 的二进制数的最高位从0变成1
- 后面的二进制数都是在之前所有二进制的最高位加一位1。

### python

```python
class Solution(object):
    def countBits(self, num):
        """
        :type num: int
        :rtype: List[int]
        """
        List1 = [0]
        while(len(List1)<=num):
            List2 = [i+1 for i in List1]
            List1 = List1+List2
 
        return List1[:num+1]
```

## 714. 买卖股票的最佳时机含手续费

[原题链接](https://leetcode-cn.com/problems/best-time-to-buy-and-sell-stock-with-transaction-fee/)

### 思路

```python
class Solution(object):
    def maxProfit(self, prices, fee):
        """
        :type prices: List[int]
        :type fee: int
        :rtype: int
        """
        # cash：不持有
        cash = 0
        # hold：持有
        hold = -prices[0]
        for i in range(1, len(prices)):
            p = prices[i]
            # 选择卖出或不变
            cash = max(cash, hold + prices[i] - fee)
            # 选择买入或不变
            hold = max(hold, cash - prices[i])
        return cash
```

## 898. 子数组按位或操作

[原题链接](https://leetcode-cn.com/problems/bitwise-ors-of-subarrays/)

### 思路

动态规划，`dp[i]` 存储所有以 `i` 结尾的子数组的或结果（集合）。

由于数据规模为 `1 <= A.length <= 50000`，因此无法使用 `O(n^2)` 的算法。参考 [花花酱 LeetCode 898. Bitwise ORs of Subarrays - 刷题找工作 EP222](https://www.bilibili.com/video/av31142168) 的讲解，说的非常详细了，也大致了解到如何根据问题规模确定复杂度了。

```python
class Solution:
    def subarrayBitwiseORs(self, A: List[int]) -> int:
        cur = set()
        res = set()
        # cur 存储以 a 结尾的所有子数组的或结果
        for a in A:
            cur = {n | a for n in cur} | {a}
            res |= cur
        return len(res)
```