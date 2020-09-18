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

## 357. 计算各个位数不同的数字个数

[原题链接](https://leetcode-cn.com/problems/count-numbers-with-unique-digits/)

### 解法一：回溯

用 `tags` 数组标记 0~9 数字出现的次数，再调用递归后进行回溯。注意对 0 进行特殊处理。

```python
class Solution:
    ans = 0
    tags = [] # 记录数字出现的次数
    def countNumbersWithUniqueDigits(self, n: int) -> int:
        # 0-9 的数字
        self.tags = [0 for _ in range(10)]
        # 枚举所有数字：回溯
        """
        r: 轮次
        num: 数字
        """
        def dfs(r, num = 0):
            if r <= 0:
                # 结束递归
                return

            for i in range(10):
                # 循环 0-9
                if num % 10 != i and self.tags[i] == 0:
                    # 条件枝剪
                    self.ans += 1
                    # 数字出现标记
                    self.tags[i] = 1
                    dfs(r - 1, num * 10 + i)
                    # 回溯
                    self.tags[i] = 0

        dfs(n)
        # 补充 0
        return self.ans + 1
```

### 解法二：动态规划

排列组合。

- `f(0) = 1`
- `f(1) = 9`
- `f(2) = 9 * 9 + f(1)`
  - 第一个数字选择 1~9
  - 第二个数在 0~9 中选择和第一个数不同的数
- `f(3) = 9 * 9 * 8 + f(2)`

可以推出动态规划方程：

```
dp[i] = sum + dp[i - 1]
```

```python
class Solution:
    def countNumbersWithUniqueDigits(self, n: int) -> int:
        dp = [0 for _ in range(n + 1)]
        # n = 1 时
        dp[0] = 1

        for i in range(1, n + 1):
            s = 9
            for j in range(1, i):
                s *= (10 - j)
            dp[i] = s + dp[i - 1]

        return dp[n]
```