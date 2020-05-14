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

## 365. 水壶问题

[原题链接](https://leetcode-cn.com/problems/water-and-jug-problem/)

### 解一：深度优先搜索

列举每次倒水的几种情况：

1. 把 x 倒空
2. 把 x 倒满
3. 把 y 倒空
4. 把 y 倒满
5. 把 x 倒入 y，直到 y 满或 x 空
6. 把 y 倒入 x，直到 x 满或 y 空

因为 Python 中会超过最大递归次数，所以用栈模拟递归过程。

```python
class Solution:
    def canMeasureWater(self, x: int, y: int, z: int) -> bool:
        # (x 剩余，y 剩余)
        stack = [(0, 0)]
        # 标记重复
        mark = set()
        while len(stack) > 0:
            remain_x, remain_y = stack.pop()
            if remain_x == z or remain_y == z or remain_x + remain_y == z:
                return True
            # 是否已标记过该情况
            if (remain_x, remain_y) in mark:
                continue
            mark.add((remain_x, remain_y))
            # 分情况讨论
            # 倒满 x
            stack.append((x, remain_y))
            # 倒满 y
            stack.append((remain_x, y))
            # 清空 x
            stack.append((0, remain_y))
            # 清空 y
            stack.append((remain_x, 0))
            # 把 x 倒进 y，直到 y 满或 x 空
            stack.append((remain_x - min(remain_x, y - remain_y), remain_y + min(remain_x, y - remain_y)))
            # 把 y 倒进 x，直到 x 满或 y 空
            stack.append((remain_x + min(remain_y, x - remain_x), remain_y - min(remain_y, x - remain_x)))
        return False
```

## 695. 岛屿的最大面积

[原题链接](https://leetcode-cn.com/problems/max-area-of-island/)

### 深度优先搜索

设计一个递归函数：输入坐标 `(i, j)`，返回该位置能构成岛屿的最大面积。

- 如果该位置不是岛屿，返回 0
- 如果该位置是岛屿，计算其上下左右位置的面积并相加（此过程不断递归）

```python
class Solution:
    def maxAreaOfIsland(self, grid: List[List[int]]) -> int:
        res = 0
        for i in range(len(grid)):
            for j in range(len(grid[0])):
                res = max(self.dfs(grid, i, j), res)
        return res

    def dfs(self, grid, i, j):
        """
        返回面积
        """
        if i < 0 or j < 0 or i >= len(grid) or j >= len(grid[0]) or grid[i][j] != 1:
            return 0
        # 避免重复计算
        grid[i][j] = 0
        # 是岛屿，面积为 1
        ans = 1
        # 四个方向
        for di, dj in [[0, -1], [0, 1], [-1, 0], [1, 0]]:
            # 计算四个方向总面积
            ans += self.dfs(grid, i + di, j + dj)
        return ans
```