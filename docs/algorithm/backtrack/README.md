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

## 46. 全排列

[原题链接](https://leetcode-cn.com/problems/permutations/)

### 思路：回溯

[参考题解](https://leetcode-cn.com/problems/permutations/solution/hui-su-suan-fa-xiang-jie-by-labuladong-2/)

```python
class Solution:
    def permute(self, nums: List[int]) -> List[List[int]]:
        def track_back(nums, track):
            if len(nums) == len(track):
                ans.append(track[:])
            # 遍历集合
            for n in nums:
                if n in track:
                    # 已经在决策树中
                    continue
                # 加入决策
                track.append(n)
                track_back(nums, track)
                # 回溯
                track.pop()
            
        ans = []
        track = []
        track_back(nums, track)
        return ans
```

## 216. 组合总和 III

[原题链接](https://leetcode-cn.com/problems/combination-sum-iii/)

回溯模板：

```
backtracking() {
    if (终止条件) {
        存放结果;
    }

    for (选择：选择列表（可以想成树中节点孩子的数量）) {
        递归，处理节点;
        backtracking();
        回溯，撤销处理结果
    }
}
```

### 题解

<!-- tabs:start -->

#### **Python**

```python
class Solution:
    def combinationSum3(self, k: int, n: int) -> List[List[int]]:
        ans = []
        '''
        element: 数组内答案
        start: 遍历的开始位置
        num: 剩余数字
        '''
        def dfs(element, start, num):
            # 符合条件，加入最终答案，结束递归
            if len(element) == k or num < 0:
                if len(element) == k and num == 0:
                    # print(element)
                    # 深拷贝
                    ans.append(element[:])
                return

            for i in range(start, 10):
                # 加入当前值
                element.append(i)
                # 递归
                dfs(element, i + 1, num - i)
                # 撤销选择，即回溯
                element.pop()

        dfs([], 1, n)
        return ans
```

#### **Go**

```go
func combinationSum3(k int, n int) [][]int {
    ans := [][]int{}
    dfs(&ans, []int{}, 1, n, k)
    return ans
}

func dfs(ans *[][]int, element []int, start int, num int, k int) {
    if len(element) == k || num <= 0 {
        if len(element) == k && num == 0 {
            temp := make([]int, k)
            copy(temp, element)
            *ans = append(*ans, temp)
        }
        return
    }

    for i:=start; i < 10; i++ {
        element = append(element, i)
        dfs(ans, element, i + 1, num - i, k)
        element = element[:len(element) - 1]
    }
}
```

<!-- tabs:end -->