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

2020.05.03 复盘：

```python
class Solution:
    def maxSubArray(self, nums: List[int]) -> int:
        length = len(nums)
        if length == 0:
            return 0
        dp = [0 for _ in range(length)]
        dp[0] = nums[0]
        for i in range(1, length):
            dp[i] = max(dp[i - 1] + nums[i], nums[i])
        return max(dp)
```

## 55. 跳跃游戏

[原题链接](https://leetcode-cn.com/problems/jump-game/comments/)

### 思路一

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
                # 把最后一个位置不断往前推
                end = i
        
        if end == 0:
            return True
        else:
            return False
```

### 思路二

用 `mark[i]` 标记是否可以到达位置 `i`。

```python
class Solution:
    def canJump(self, nums: List[int]) -> bool:
        length = len(nums)
        mark = [False for _ in range(length)]
        mark[0] = True
        begin = 1
        for i in range(length):
            n = nums[i]
            if mark[i]:
                # 可以到达
                for j in range(begin - i, n + 1):
                    jump = i + j
                    if jump == length - 1:
                        return True
                    if jump >= length:
                        break
                    mark[jump] = True
                begin = i + n + 1 if i + n + 1 < length else length - 1
        return mark[length - 1]
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

## 63. 不同路径 II

[原题链接](https://leetcode-cn.com/problems/unique-paths-ii/)

### 思路

动态规划。将到达格子 [i, j] 的路径数记为 `dp[i][j]`，因为一个格子只能从它上边或左边的格子到达，所以有：

```
dp[i][j] = dp[i - 1][j] + dp[i][j - 1]
```

当某个格子存在障碍物时，这个格子是无法到达的，因此 `dp[i][j] = 0`。

```python
class Solution:
    def uniquePathsWithObstacles(self, obstacleGrid: List[List[int]]) -> int:
        # m * n 矩阵
        m = len(obstacleGrid)
        if m == 0:
            return 0
        n = len(obstacleGrid[0])
        
        # 第一个格子或最后一个格子有障碍物，直接返回 0
        if obstacleGrid[0][0] == 1 or obstacleGrid[m - 1][n - 1] == 1:
            return 0
        
        dp = [[0 for _ in range(n)] for _ in range(m)]
        
        for i in range(m):
            for j in range(n):
                
                # 第一步特殊处理
                if i == 0 and j == 0:
                    dp[0][0] = 1
                    continue
                
                # 有障碍物则走不到这个格子
                if obstacleGrid[i][j] == 1:
                    dp[i][j] = 0
                else:
                    if i > 0 and j > 0:
                        dp[i][j] = dp[i - 1][j] + dp[i][j - 1]
                    else:
                        if i == 0:
                            dp[i][j] = dp[i][j - 1]
                        if j == 0:
                            dp[i][j] = dp[i - 1][j]
                            
        return dp[m - 1][n - 1]
```

### 复杂度

- 时间复杂度：`O(m * n)`
- 空间复杂度：我这里初始化了一个 `dp`，所以空间复杂度为 `O(m * n)`。也可以直接使用原数组 `obstacleGrid`，这样空间复杂度就是 `O(1)`。

## 64. 最小路径和

[原题链接](https://leetcode-cn.com/problems/minimum-path-sum/)

### 思路

动态规划。

只能通过该点的左边或是上边到达某个点，因此 `dp[x][y] = min(dp[x - 1][y], dp[x][y - 1]) + grid[x][y]`。

注意边界处理。

```python
class Solution:
    def minPathSum(self, grid: List[List[int]]) -> int:
        m = len(grid)
        if m == 0:
            return 0
        n = len(grid[0])
        
        dp = [[0 for _ in range(n)] for _ in range(m)]
        
        for i in range(m):
            for j in range(n):
                if i == 0 and j == 0:
                    dp[i][j] = grid[i][j]
                    continue
                
                if i == 0:
                    dp[i][j] = dp[i][j-1] + grid[i][j]
                elif j == 0:
                    dp[i][j] = dp[i-1][j] + grid[i][j]
                else:
                    dp[i][j] = min(dp[i-1][j], dp[i][j-1]) + grid[i][j]
                    
        return dp[m-1][n-1]
```

### 复杂度

- 时间复杂度 `O(m*n)`
- 空间复杂度：`O(m*n)`（如果复用 `grid` 的话也可以达到 `O(1)`）

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

## 72. 编辑距离

[原题链接](https://leetcode-cn.com/problems/edit-distance/)

### 动态规划

用 `dp[i][j]` 表示 `words1` 前 `i` 个字符到 `words2` 前 `j` 个字符的编辑距离。

<!-- tabs:start -->

#### **Python**

```python
class Solution:
    def minDistance(self, word1: str, word2: str) -> int:
        length1 = len(word1)
        length2 = len(word2)
        # 如果有字符串为空
        if length1 == 0 or length2 == 0:
            return length1 + length2

        dp = [[0 for _ in range(length2 + 1)] for _ in range(length1 + 1)]

        # 初始化边界值
        for i in range(length1 + 1):
            dp[i][0] = i
        for j in range(length2 + 1):
            dp[0][j] = j

        # 计算 dp
        # 从字符串末尾插入或更新字符
        # 状态转移方程：
        # 末尾相同时：dp[i][j] = dp[i - 1][j - 1]
        # 末尾不同时（替换或插入操作）：dp[i][j] = min(dp[i - 1][j] + 1, dp[i][j - 1] + 1, dp[i - 1][j - 1] + 1)
        for i in range(1, length1 + 1):
            for j in range(1, length2 + 1):
                if word1[i - 1] == word2[j - 1]:
                    dp[i][j] = dp[i - 1][j - 1]
                else:
                    dp[i][j] = min(dp[i - 1][j - 1], dp[i - 1][j], dp[i][j - 1]) + 1

        return dp[length1][length2]
```

#### **Go**

```go
func minDistance(word1 string, word2 string) int {
    length1 := len(word1)
    length2 := len(word2)
    var dp = make([][]int, length1 + 1)
    for i := 0; i < length1 + 1; i++ {
        dp[i] = make([]int, length2 + 1)
    }
    // 初始化
    for i := 0; i < length1 + 1; i++ {
        dp[i][0] = i
    }
    for j := 0; j < length2 + 1; j++ {
        dp[0][j] = j
    }
    // 计算 dp
    for i := 1; i < length1 + 1; i ++ {
        for j := 1; j < length2 + 1; j++ {
            if word1[i - 1] == word2[j - 1] {
                dp[i][j] = dp[i - 1][j - 1]
            } else {
                dp[i][j] = getMin(dp[i - 1][j - 1], getMin(dp[i - 1][j], dp[i][j - 1])) + 1
            }
        }
    }
    return dp[length1][length2]
}

func getMin(a int, b int) int {
    if a < b {
        return a
    }
    return b
}
```

<!-- tabs:end -->


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

## 123. 买卖股票的最佳时机 III

[原题链接](https://leetcode-cn.com/problems/best-time-to-buy-and-sell-stock-iii/)

### 思路

这个系列的题真是折磨人呐。首先还是要先确定需要记录几个状态值。

对于某一天来说，可能会发生的情况：

1. 第一次被买入
2. 第一次被卖出
3. 第二次被买入
4. 第二次被卖出

按题目要求，我们最终要求出的是**第二次被卖出**所能获得的最大收益。

我们分别用 4 个变量来表示这 4 种情况下所能获得的最大收益：

1. 在某天完成第一次买入的最大收益 `first_buy`
2. 在某天完成第一次被卖出的最大收益 `first_sell`
3. 在某天完成第二次被买入的最大收益 `second_buy`
4. 在某天完成第二次被卖出最大收益 `second_sell`

可以得出状态转移公式：

```
first_buy = max(first_buy, -price)
first_sell = max(first_sell, first_buy + price)
second_buy = max(second_buy, first_sell - price)
second_sell = max(second_sell, second_buy + price)
```

其中 `price` 为某天股票的价格。

```python
class Solution:
    def maxProfit(self, prices: List[int]) -> int:
        first_buy = float('-inf')
        first_sell = 0
        second_buy = float('-inf')
        second_sell = 0
        
        for price in prices:
            first_buy = max(first_buy, -price)
            first_sell = max(first_sell, first_buy + price)
            second_buy = max(second_buy, first_sell - price)
            second_sell = max(second_sell, second_buy + price)
            
        return second_sell
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

## 120. 三角形最小路径和

[原题链接](https://leetcode-cn.com/problems/triangle/)

### 思路

动态规划状态转移公式：`dp[i][j] = min(dp[i - 1][j - 1], dp[i - 1][j]) + trangle[i][j]`

```python
class Solution:
    def minimumTotal(self, triangle: List[List[int]]) -> int:
        # n 行
        n = len(triangle)
        dp = [[0] * i for i in range(1, n + 1)]
        # print(dp)
        dp[0][0] = triangle[0][0]
        
        for i in range(1, n ):
            for j in range(i + 1):
                if j == 0:
                    dp[i][j] = dp[i - 1][j] + triangle[i][j]
                elif j == i:
                    dp[i][j] = dp[i - 1][j - 1] + triangle[i][j]
                else:
                    dp[i][j] = min(dp[i - 1][j - 1], dp[i - 1][j]) + triangle[i][j]
                    
        return min(dp[-1])
```

## 213. 打家劫舍 II

[原题链接](https://leetcode-cn.com/problems/house-robber-ii/)

### 思路

动态规划。

[打家劫舍](https://leetcode-cn.com/problems/house-robber/) 的升级版，加入了一个限制条件：**第一间屋子和最后一间屋子不能同时被抢**。即，**要么抢第一间，要么抢最后一间**。

因此，可以把问题拆分为两个基础版的 [打家劫舍](https://leetcode-cn.com/problems/house-robber/)：

1. 去掉第一间，打劫一次
2. 去掉最后一间，打劫一次
3. 取两次打劫能获得的最大值

对于基础版打家劫舍而言，设打劫到第 `i` 家的最大收益为 `dp[i]`，则有：

```
dp[i] = max(dp[i - 2] + nums[i], dp[i - 1])
```

```python
class Solution:
    def rob(self, nums: List[int]) -> int:
        
        length = len(nums)
        if length == 0:
            return 0
        if length == 1:
            return nums[0]
        if length == 2:
            return max(nums[0], nums[1])
        
        def rob_action(nums):
            length = len(nums)
            dp = [0 for _ in range(length)]
            dp[0] = nums[0]
            dp[1] = max(nums[0], nums[1])
            for i in range(2, length):
                dp[i] = max(dp[i - 2] + nums[i], dp[i - 1])
            return dp
        
        # 去掉第一间
        nums1 = nums[1:]
        dp1 = rob_action(nums1)
        # 去掉最后一间
        nums2 = nums[:-1]
        dp2 = rob_action(nums2)
        
        return max(dp1[-1], dp2[-1])
```

## 221. 最大正方形

[原题链接](https://leetcode-cn.com/problems/maximal-square/)

### 思路

`dp[i][j]` 存储下标 `[i][j]` 处最大的正方形边长。

```python
class Solution:
    def maximalSquare(self, matrix: List[List[str]]) -> int:
        m = len(matrix)
        if m == 0:
            return 0
        n = len(matrix[0])
        
        dp = [[0 for _ in range(n + 1)] for _ in range(m + 1)]
        
        max_size = 0
        for i in range(1, m + 1):
            for j in range(1, n + 1):
                if matrix[i - 1][j - 1] == "1":
                    dp[i][j] = min(dp[i - 1][j], dp[i][j - 1], dp[i - 1][j - 1]) + 1
                    max_size = max(max_size, dp[i][j])

        return max_size * max_size
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

### 解一：动态规划

设到某位置 n 的最长上升子序列为 `f(n)`，那么有：

```
f(n) = max(f(n), f(x) + 1) (nums[n] > numx[x] and n > x)
```

<!-- tabs:start -->

#### **Python**

```python
class Solution:
    def lengthOfLIS(self, nums: List[int]) -> int:
        length = len(nums)
        if length == 0:
            return 0
        dp = [1 for _ in range(length)]
        for i in range(length):
            for j in range(i):
                if nums[j] < nums[i]:
                    dp[i] = max(dp[i], dp[j] + 1)
        return max(dp)
```

#### **Go**

```go
func lengthOfLIS(nums []int) int {
    length := len(nums)
    // 初始化
    dp := make([]int, length)
    for i := 0; i < length; i++ {
        dp[i] = 1
    }
    
    for i := 0; i < length; i++ {
        for j := 0; j < i; j++ {
            if nums[j] < nums[i] {
                // dp
                if dp[j] + 1 > dp[i] {
                    dp[i] = dp[j] + 1
                }
            }
        }
    }

    // 返回最大 dp
    res := 0
    for i := 0; i < length; i++ {
        if dp[i] > res {
            res = dp[i]
        }
    }

    return res
}
```

<!-- tabs:end -->

- 时间复杂度：$O(n^2)$
- 空间复杂度：$O(n)$

### 解二：贪心 + 二分

- 贪心：尾部元素尽可能小才更「有机会上升」
- 二分：使用二分查找找到要更新的元素

使用一个辅助列表 `tails`，用 `tails[i]` 表示长度为 `i` 的上升队列尾部最小元素，`tails` 为递增序列。

那么：

- 如果 `num > tails[-1]`，直接追加 `num` 到 `tails` 尾部，且上升序列长度加 1
- 否则在 `tails` 使用二分查找，找到第一个比 `num` 小的元素 `tails[k]`，并更新 `tails[k + 1] = num`

```python
class Solution:
    def lengthOfLIS(self, nums: List[int]) -> int:
        # 当前长度
        res = 0
        length = len(nums)
        # tails[i] 代表上升子序列长度为 i 时尾部数字
        tails = []
        for num in nums:
            if len(tails) == 0 or num > tails[-1]:
                # 如果 tails 为空，或 num 大于 tails 最后一位数，追加 num
                tails.append(num)
            else:
                # 使用二分查找，找到第一个比 num 小的数
                left = 0
                right = len(tails) - 1
                loc = right
                while left <= right:
                    mid = (left + right) // 2
                    if tails[mid] >= num:
                        # 找左区间
                        loc = mid
                        right = mid - 1
                    else:
                        # 找右区间
                        left = mid + 1
                tails[loc] = num
        return len(tails)
```

## 303. 区域和检索 - 数组不可变

[原题链接](https://leetcode-cn.com/problems/range-sum-query-immutable/)

### 思路

动态规划前缀和。

<!-- tabs:start -->

#### **Python**

```python
class NumArray:

    def __init__(self, nums: List[int]):
        length = len(nums)
        self.sum_nums = [0 for _ in range(length)]
        for i in range(length):
            if i == 0:
                self.sum_nums[i] = nums[i]
            else:
                self.sum_nums[i] = self.sum_nums[i - 1] + nums[i]


    def sumRange(self, i: int, j: int) -> int:
        if i == 0:
            return self.sum_nums[j]
        else:
            return self.sum_nums[j] - self.sum_nums[i - 1]


# Your NumArray object will be instantiated and called as such:
# obj = NumArray(nums)
# param_1 = obj.sumRange(i,j)
```

#### **Go**

```go
type NumArray struct {
    sums []int
}


func Constructor(nums []int) NumArray {
    length := len(nums)
    sums := make([]int, length)
    for i, num := range nums {
        if i == 0 {
            sums[i] = num
        } else {
            sums[i] = sums[i - 1] + num
        }
    }
    return NumArray{sums}
}


func (this *NumArray) SumRange(i int, j int) int {
    if i == 0 {
        return this.sums[j]
    } else {
        return this.sums[j] - this.sums[i - 1]
    }
}


/**
 * Your NumArray object will be instantiated and called as such:
 * obj := Constructor(nums);
 * param_1 := obj.SumRange(i,j);
 */
```

<!-- tabs:end -->

## 304. 二维区域和检索 - 矩阵不可变

[原题链接](https://leetcode-cn.com/problems/range-sum-query-2d-immutable/)

### 解法一：二维前缀和

<!-- tabs:start -->

#### **Python**

```python
class NumMatrix:

    def __init__(self, matrix: List[List[int]]):
        m = len(matrix)
        n = len(matrix[0]) if matrix else 0
        self.sums = [[0 for _ in range(n + 1)] for _ in range(m + 1)]

        for i in range(m):
            for j in range(n):
                self.sums[i + 1][j + 1] = self.sums[i][j + 1] + self.sums[i + 1][j] - self.sums[i][j] + matrix[i][j]


    def sumRegion(self, row1: int, col1: int, row2: int, col2: int) -> int:
        return self.sums[row2 + 1][col2 + 1] - self.sums[row2 + 1][col1] - self.sums[row1][col2 + 1] + self.sums[row1][col1]


# Your NumMatrix object will be instantiated and called as such:
# obj = NumMatrix(matrix)
# param_1 = obj.sumRegion(row1,col1,row2,col2)
```

#### **Go**

```go
type NumMatrix struct {
    sums [][]int
}


func Constructor(matrix [][]int) NumMatrix {
    m := len(matrix)
    if m == 0 {
        return NumMatrix{}
    }
    n := len(matrix[0])
    sums := make([][]int, m + 1)
    // 初始化第 0 行
    sums[0] = make([]int, n + 1)
    for i, row := range matrix {
        sums[i + 1] = make([]int, n + 1)
        for j, num := range row {
            sums[i + 1][j + 1] = sums[i][j + 1] + sums[i + 1][j] - sums[i][j] + num
        }
    }

    return NumMatrix{sums}
}


func (this *NumMatrix) SumRegion(row1 int, col1 int, row2 int, col2 int) int {
    return this.sums[row2 + 1][col2 + 1] - this.sums[row2 + 1][col1] - this.sums[row1][col2 + 1] + this.sums[row1][col1]
}


/**
 * Your NumMatrix object will be instantiated and called as such:
 * obj := Constructor(matrix);
 * param_1 := obj.SumRegion(row1,col1,row2,col2);
 */
```

<!-- tabs:end -->

## 309. 最佳买卖股票时机含冷冻期

[原题链接](https://leetcode-cn.com/problems/best-time-to-buy-and-sell-stock-with-cooldown/)

### 思路

用 `buy`、`sell`、`cooldown` 三个数组分别存储购买、卖出和冷冻期三个状态。

状态转移方程如下：

```
sell[i] 表示截至第 i 天，最后一个操作是卖时的最大收益
buy[i] 表示截至第 i 天，最后一个操作是买时的最大收益
cool[i] 表示截至第 i 天，最后一个操作是冷冻期时的最大收益

sell[i] = max(buy[i - 1] + prices[i], sell[i - 1])
buy[i] = max(cooldown[i - 1] - prices[i], buy[i - 1])
cooldown[i] = max(cooldown[i-1], max(sell[i-1], buy[i-1]))
```

```python
class Solution:
    def maxProfit(self, prices: List[int]) -> int:
        length = len(prices)
        if length == 0:
            return 0
        
        sell = [0 for _ in range(length)]
        buy = [0 for _ in range(length)]
        cooldown = [0 for _ in range(length)]
        
        buy[0] = -prices[0]
        
        for i in range(1, length):
            sell[i] = max(buy[i - 1] + prices[i], sell[i - 1])
            buy[i] = max(cooldown[i - 1] - prices[i], buy[i - 1])
            cooldown[i] = max(cooldown[i-1], max(sell[i-1], buy[i-1]))
            
        return sell[-1]
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

### 解法一

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

### 解法二

奇偶数的二进制规律：

- 奇数二进制数总比前一个偶数二进制数多 1 个 1（即最后 1 位）
- 偶数二进制数 `x` 中 1 的个数总等于 `x / 2` 中 1 的个数（除 2 等于右移 1 位，即抹去最后一位 0）

<!-- tabs:start -->

c

```python
class Solution:
    def countBits(self, num: int) -> List[int]:
        ans = [0 for _ in range(num + 1)]
        for i in range(num + 1):
            if i % 2 == 0:
                # 偶数
                ans[i] = ans[i // 2]
            else:
                # 奇数
                ans[i] = ans[i - 1] + 1
        return ans
```

#### **Go**

```go
func countBits(num int) []int {
    ans := make([]int, num + 1)
    for i := 0; i <= num; i++ {
        if i % 2 == 0 {
            ans[i] = ans[i / 2]
        } else {
            ans[i] = ans[i - 1] + 1
        }
    }
    return ans
}
```

<!-- tabs:end -->

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

## 494. 目标和

[原题链接](https://leetcode-cn.com/problems/target-sum/)

### 解一：递归遍历所有情况

**本方法超出时间限制**。

<!-- tabs:start -->

#### **Python**

```python
class Solution:
    
    res = 0

    def findTargetSumWays(self, nums: List[int], S: int) -> int:
        length = len(nums)

        def helper(index, cur):
            if index == length:
                print('res' + str(cur))
                if cur == S:
                    self.res += 1
                    pass
                return
            for op in ["+", "-"]:
                helper(index + 1, eval(str(cur) + op + str(nums[index])))

            # 或直接调用两次递归：
            # helper(index + 1, cur + nums[index])
            # helper(index + 1, cur - nums[index])

        helper(0, 0)
        return self.res
```

#### **Go**

```go
var count int = 0

func findTargetSumWays(nums []int, S int) int {
    helper(nums, 0, 0, S)
    return count
}

func helper(nums []int, cur int, index int, S int) {
    if index == len(nums) {
        if cur == S {
            count += 1
        }
        return
    }
    helper(nums, cur + nums[index], index + 1, S)
    helper(nums, cur - nums[index], index + 1, S)
}
```

<!-- tabs:end -->

- 时间复杂度：$O(2^n)$
- 空间复杂度：$O(n)$（递归调用栈）

### 解二：动态规划

`dp[i][j]` 带表前 `i` 个数可得到和为 `j` 的组合数量。那么有推导式：

```
dp[i][j] = dp[i - 1][j - nums[i]] + dp[i - 1][j + nums[i]]
```

也可写作：

```
dp[i][j + nums[i]] += dp[i - 1][j]
dp[i][j - nums[i]] += dp[i - 1][j]
```

<!-- tabs:start -->

#### **Python**

```python
class Solution:
    def findTargetSumWays(self, nums: List[int], S: int) -> int:
        # 初始化
        length = len(nums)
        dp = [[0 for _ in range(2001)] for _ in range(length)]
        dp[0][nums[0] + 1000] = 1
        dp[0][-nums[0] + 1000] += 1
        
        for i in range(1, length):
            for s in range(-1000, 1001):
                if dp[i - 1][s + 1000] > 0:
                    # 防止越界
                    dp[i][s + nums[i] + 1000] += dp[i - 1][s + 1000]
                    dp[i][s - nums[i] + 1000] += dp[i - 1][s + 1000]
        
        return 0 if S > 1000 else dp[length - 1][S + 1000]
```

#### **Go**

```go
func findTargetSumWays(nums []int, S int) int {
    length := len(nums)
    var dp [21][2001]int
    dp[0][nums[0] + 1000] = 1
    dp[0][-nums[0] + 1000] += 1
    for i := 1; i < length; i++ {
        for j := -1000; j < 1001; j++ {
            if dp[i - 1][j + 1000] > 0 {
                dp[i][j + nums[i] + 1000] += dp[i - 1][j + 1000]
                dp[i][j - nums[i] + 1000] += dp[i - 1][j + 1000]
            }
        } 
    }
    if S > 1000 {
        return 0
    }
    return dp[length - 1][S + 1000]
}
```

<!-- tabs:end -->

### 【TODO】解三：01 背包

## 740. 删除与获得点数

[原题链接](https://leetcode-cn.com/problems/delete-and-earn/)

### 思路

太困了，题解明天补充。

```python
class Solution:
    def deleteAndEarn(self, nums: List[int]) -> int:
        if len(nums) == 0:
            return 0
        nums_map = dict()
        for num in nums:
            nums_map[num] = nums_map.get(num, 0) + 1
        # 去重 + 排序
        nums_list = sorted(list(set(nums)))
        dp = dict()
        dp[nums_list[0]] = nums_list[0] * nums_map[nums_list[0]]
        
        for i in range(1, len(nums_list)):
            num = nums_list[i]
            points = nums_map.get(num, 0) * num
            pre_num = nums_list[i - 1]
            if i == 1:
                if pre_num == num - 1:
                    dp[num] = max(dp[pre_num], points)
                else:
                    dp[num] = dp[pre_num] + points
            else:
                ppre_num = nums_list[i - 2]
                if pre_num == num - 1:
                    dp[num] = max(dp.get(ppre_num, 0) + nums_map.get(num, 0) * num, dp.get(pre_num, 0))
                else:
                    dp[num] = dp[pre_num] + points
                
        return dp[nums_list[-1]]
```

## 887. 鸡蛋掉落

[原题链接](https://leetcode-cn.com/problems/super-egg-drop/)

### 动态规划

`(K, N)` 中 `K` 表示鸡蛋数，`N` 表示楼层数量。那么从 `X` 层楼扔鸡蛋时：

- 鸡蛋碎了：状态变为 `(K-1, X-1)`
- 鸡蛋没碎：状态变为 `(K, N - X)`

有状态转移方程如下：

$dp(K, N) = 1 + min(max(dp(K - 1, X - 1), dp(K, N - X)))$

初始化值：

1. 当只有 1 个鸡蛋时，有几层楼就要扔几次
2. 当只有 1 层楼时，只要扔一次
3. 0 层或 0 个鸡蛋时均初始化为 0
4. 因为要求「最小值」，所以初始化其他数值时尽量给到最大值，可以赋值楼层数量 + 1

```go
func superEggDrop(K int, N int) int {
    var dp [][]int
    // 初始化
    for i := 0; i <= K; i++ {
        tmp := make([]int, N + 1)
        for j := 0; j <= N; j++ {
            tmp[j] = j + 1
            if i == 0 {
                // 0 个蛋
                tmp[j] = 0
            }
            if i == 1 {
                // 1 个蛋
                tmp[j] = j
            }
            if j == 0 {
                // 0 层楼
                tmp[j] = 0
            }
            if j == 1 {
                // 1 层楼
                tmp[j] = 1
            }
        }
        dp = append(dp, tmp)
    }

    for i:=2; i <= K; i++ {
        for j := 2; j <= N; j++ {
            left := 1
            right := j
            for left <= right {
                mid := (left + right) / 2
                if dp[i][j - mid] < dp[i - 1][mid - 1] {
                    right = mid - 1
                } else {
                    left = mid + 1
                }
            }
            t1 := j + 1
            t2 := j + 1
            if left <= j {
                t1 = getMax(dp[i][j - left], dp[i - 1][left - 1])
            }
            if right >= 1 {
                t2 = getMax(dp[i][j - right], dp[i - 1][right - 1])
            }
            dp[i][j] = getMin(t1, t2) + 1
        }
    }
    return dp[K][N]
}

func getMax(a int, b int) int {
    if a > b {
        return a
    }
    return b
}

func getMin(a int, b int) int {
    if a < b {
        return a
    }
    return b
}
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

## 983. 最低票价

[原题链接](https://leetcode-cn.com/problems/minimum-cost-for-tickets/)

### 解一：动态规划

从后往前进行动态规划，用 `dp[i]` 代表从第 `i` 天到最后一天需要的最低票价。

- 当 `i` 无需出行时，依据贪心法则：`dp[i] = dp[i + 1]`，即在第 `i` 天无需购票
- 当 `i` 需要出行，`dp[i] = min(costs[j] + dp[i + j])`，`j` 的取值是 1/7/30。如果第 `i` 天出行，我们买了 `j` 天的票，那么后续 `j` 天都不需要购票事宜了，所以只要加上 `dp[i + j]` 的票价即可。

<!-- tabs:start -->

#### **Python**

```python
class Solution:
    def mincostTickets(self, days: List[int], costs: List[int]) -> int:
        ans = 0
        dp = [0 for _ in range(400)]
        for i in range(365, 0, -1):
            if i in days:
                # 需要出行
                min_dp = float('inf')
                min_dp = min(costs[0] + dp[i + 1], costs[1] + dp[i + 7], costs[2] + dp[i + 30])
                dp[i] = min_dp
            else:
                # 不需要出行
                dp[i] = dp[i + 1]
        # print(dp[20])
        return dp[1]
```

#### **Go**

```go
func mincostTickets(days []int, costs []int) int {
    dp := make([]int, 400)
    dayMap := make(map[int]int)
    for _, day := range days {
        dayMap[day] = 1
    }
    for i := 365; i > 0; i-- {
        // 从后向前动态规划
        if _, ok := dayMap[i]; ok {
            // 该天出行
            cost0 := costs[0] + dp[i + 1]
            cost1 := costs[1] + dp[i + 7]
            cost2 := costs[2] + dp[i + 30]
            dp[i] = getMin(getMin(cost0, cost1), cost2)
        } else {
            // 该天不出行
            dp[i] = dp[i + 1]
        }
    }

    return dp[1]
}

func getMin(a int, b int) int {
    if a < b {
        return a
    }
    return b
}
```

<!-- tabs:end -->

## 1137. 第 N 个泰波那契数

[原题链接](https://leetcode-cn.com/problems/n-th-tribonacci-number/)

### 动态规划

```
dp[i] = dp[i - 1] + dp[i - 2] + dp[i - 3]
```

<!-- tabs:start -->

#### **Python**

```python
class Solution:
    def tribonacci(self, n: int) -> int:
        dp = [0 for _ in range(38)]
        dp[1] = 1
        dp[2] = 1
        
        for i in range(3, n + 1):
            dp[i] = dp[i - 1] + dp[i - 2] + dp[i - 3]
        
        return dp[n]
```

<!-- tabs:end -->

### 迭代

<!-- tabs:start -->

#### **Java**

```java
class Solution {
    public int tribonacci(int n) {
        int[] topThree = new int[]{0, 1, 1};

        if (n < 3) return topThree[n];

        for (int i = 3; i <= n; i++) {
            int temp = topThree[0] + topThree[1] + topThree[2];
            topThree[0] = topThree[1];
            topThree[1] = topThree[2];
            topThree[2] = temp;
        }
        return topThree[2];
    }
}
```

<!-- tabs:end -->

### 递归

<!-- tabs:start -->

#### **Python**

- [Python 缓存机制与 functools.lru_cache](http://kuanghy.github.io/2016/04/20/python-cache)

```python
import functools

class Solution:
    @functools.lru_cache(None)
    def tribonacci(self, n: int) -> int:
        if n == 0:
            return 0
        if n == 1:
            return 1
        if n == 2:
            return 1
        return self.tribonacci(n - 3) + self.tribonacci(n - 2) + self.tribonacci(n - 1)
```

<!-- tabs:end -->

## 1025. 除数博弈

[原题链接](https://leetcode-cn.com/problems/divisor-game/)

### 思路

当 `N = 1` 时Alice 会输，当 `N = 2` 时 Alice 会赢……

以 `dp(N)` 代表 `N` 时先手的输赢。

在 `N` 中找到约数 `j`，若 `dp(N - j) == False`（Bob 输） 则说明 Alice 获胜。

```python
class Solution:
    def divisorGame(self, N: int) -> bool:
        dp = [False for _ in range(N + 1)]
        if N <= 1:
            return False
        dp[1] = False
        dp[2] = True
        for i in range(3, N + 1):
            for j in range(1, i // 2):
                # i 的约数是否存在 dp[j] 为 False，此时 Alice 获胜
                if i % j == 0 and dp[i - j] is False:
                    dp[i] = True
        return dp[N]
```