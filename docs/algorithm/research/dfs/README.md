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