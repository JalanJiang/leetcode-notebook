## 698. 划分为k个相等的子集

[原题链接](https://leetcode-cn.com/problems/partition-to-k-equal-sum-subsets/)

### 思路

递归求解。

拆分的子问题为：凑齐一个和为 `avg` 的子集。

因此，我们先求出真个数组划分为 k 个子集后每个子集的和，即 `avg = sum / k`。

在递归函数中：

- 遍历函数 `nums`（已从大到小排序），逐一**凑**出子集
- 进行下一层递归条件：凑齐一个和为 `avg` 的子集
- 递归函数结束条件：已凑齐 `k` 个子集

```python
class Solution:
    def canPartitionKSubsets(self, nums: List[int], k: int) -> bool:
        length = len(nums)
        if length < k:
            return False
        
        s = sum(nums)
        # 求平均值
        avg, mod = divmod(s, k)
        # 不能整除，返回 False
        if mod:
            return False
        
        # 降序排序
        nums.sort(reverse=True)
        # 存储已经使用的下标
        used = set()
        def dfs(start, value, cnt):
            if value == avg:
                return dfs(0, 0, cnt - 1)
            
            if cnt == 0:
                return True
            
            for i in range(start, length):
                if i not in used and value + nums[i] <= avg:
                    used.add(i)
                    if dfs(i + 1, value + nums[i], cnt):
                        return True
                    used.remove(i)
            
            return False
            
        return dfs(0, 0, k)
```

## 779. 第K个语法符号

[原题链接](https://leetcode-cn.com/problems/k-th-symbol-in-grammar/)

### 思路

通过观察规律可知：**第 N 行第 K 个数是由第 N - 1 行第 (K + 1) / 2 个数得来的**。

并且：

- 当上一行的数字为 0 时，生成的数字是 `1 - (K % 2)`
- 当上一行的数字为 1 时，生成的数字是 `K % 2`

递归函数设计：

- 函数作用：返回第 `N` 行第 `K` 个数
- 当 `N == 1` 时结束递归

#### 具体实现

<!-- tabs:start -->

#### **Python**

```python
class Solution(object):
    def kthGrammar(self, N, K):
        if N == 1:
            return 0
        # 得到第 N 行第 K 位的数字
        return self.kthGrammar(N - 1, (K + 1) // 2) ^ (1 - K % 2)
```

#### **Go**

```go
func kthGrammar(N int, K int) int {
    if N == 1 {
        return 0
    }
    return kthGrammar(N - 1, (K + 1) / 2) ^ (1 - K % 2)
}
```

<!-- tabs:end -->

#### 复杂度

- 时间复杂度：$O(N)$
- 空间复杂度：$O(N)$