## 39. 组合总和

[原题链接](https://leetcode-cn.com/problems/combination-sum/)

### 思路

回溯法。

1. 先对 `candidates` 进行递增排序
2. 外层循环遍历排序后的 `candidates`，
   1. 如果遍历到的数 `nums[i] == target`，则直接把 `nums[i]` 添加到结果列表中
   2. 如果遍历到的数 `nums[i] != target`，则进入 `backtrack` 递归

然后说一下 `backtrack`：

1. 遍历 `candidates`，遍历范围为 `nums[i]` 的下标 `i` 到 `len(candidates) - 1`
2. 判断剩余值：
   1. 如果等于 0，则加入结果列表，结束递归
   2. 如果大于 0，则继续递归
   3. 如果小于 0，则结束递归

```python
class Solution(object):
    def combinationSum(self, candidates, target):
        """
        :type candidates: List[int]
        :type target: int
        :rtype: List[List[int]]
        """
        
        nums = sorted(candidates)
        res = []
        for i in range(len(nums)):
            # self.backtrack(target, i, [], nums, res)
            if nums[i] == target:
                res.append([nums[i]])
            else:
                self.backtrack(target - nums[i], i, [nums[i]], nums, res)
        return res
            
        
    def backtrack(self, cur, index, combination, nums, res):
        for i in range(index, len(nums)):
            num = nums[i]
            tmp = cur - num
            if tmp == 0:
                combination.append(num)
                res.append(combination)
                return
            elif tmp > 0:
                # 继续往下走
                self.backtrack(tmp, i, combination + [num], nums, res)
            else:
                return
```