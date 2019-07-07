## 45. 跳跃游戏 II

[原题链接](https://leetcode-cn.com/problems/jump-game-ii/)

妈个鸡和少棉一起做这道题做了快一个小时。。。

### 解法一：动态规划（超时）

第一个想到的方法是动态规划。

假设跳到 `x` 位置的最少次数为 `dp[x]`，再假设我们能跳到 `x` 位置的坐标为 `n1, n2, ..., nx`，那么很容易得到公式：

```
dp[x] = min(dp[n1], dp[n2], ..., dp[nx]) + 1
```

```python
class Solution(object):
    def jump(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        length = len(nums)
        dp = [0 for _ in range(length)]
        
        for i in range(length):
            num = nums[i]
            for j in range(1, num + 1):
                if i + j < length:
                    if dp[i + j] == 0:
                        dp[i + j] = dp[i] + 1
                    else:
                        dp[i + j] = min(dp[i] + 1, dp[i + j])
                                        
        return dp[length - 1]
```

### 解法二：贪心

主要思想：每次都要跳到**能跳到更远位置**的点上。

```python
class Solution(object):
    def jump(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        length = len(nums)
        if length == 1:
            return 0
        res = 0
        i = 0
        
        while i < length:
            num = nums[i]
            if i + num >= length - 1:
                res += 1
                break
                
            tmp = nums[i+1:i+num+1]
            max_num = nums[i + 1] + i + 1
            max_index = 0
            # 找能跳到最远距离的数
            for j in range(len(tmp)):
                if tmp[j] + j + i >= max_num:
                    max_index = j
                    max_num = tmp[j] + j + i
            
            i = max_index + i + 1
            res += 1
                                    
        return res
```

## 122. 买卖股票的最佳时机 II

[原题链接](https://leetcode-cn.com/problems/best-time-to-buy-and-sell-stock-ii/)

### 思路

经典贪心算法，总结一下就是：

- 如果发现明天会跌那就明天买
- 如果发现明天会涨那就马上卖掉

```python
class Solution(object):
    def maxProfit(self, prices):
        """
        :type prices: List[int]
        :rtype: int
        """
        max_prices = 0
        for i in range(len(prices) - 1):
            tmp = prices[i + 1] - prices[i]
            if tmp > 0:
                max_prices += tmp
        return max_prices
```

## 621. 任务调度器

[原题链接](https://leetcode-cn.com/problems/task-scheduler/)

### 思路

完成所有任务的最短时间取决于**出现次数最多的任务数量**。

看下题目给出的例子

```
输入: tasks = ["A","A","A","B","B","B"], n = 2
输出: 8
执行顺序: A -> B -> (待命) -> A -> B -> (待命) -> A -> B.
```

因为相同任务必须要有时间片为 `n` 的间隔，所以我们先把出现次数最多的任务 A 安排上（当然你也可以选择任务 B）。例子中 `n = 2`，那么任意两个任务 A 之间都必须间隔 2 个单位的时间：

```
A -> (单位时间) -> (单位时间) -> A -> (单位时间) -> (单位时间) -> A
```

中间间隔的单位时间可以用来安排别的任务，也可以处于“待命”状态。当然，为了使总任务时间最短，我们要尽可能地把单位时间分配给其他任务。现在把任务 B 安排上：

```
A -> B -> (单位时间) -> A -> B -> (单位时间) -> A -> B
```

很容易观察到，前面两个 A 任务一定会固定跟着 2 个单位时间的间隔。最后一个 A 之后是否还有任务跟随取决于**是否存在与任务 A 出现次数相同的任务**。

该例子的计算过程为：

```
(任务 A 出现的次数 - 1) * (n + 1) + (出现次数为 3 的任务个数)，即：

(3 - 1) * (2 + 1) + 2 = 8
```

所以整体的解题步骤如下：

1. 计算每个任务出现的次数
2. 找出出现次数最多的任务，假设出现次数为 `x`
3. 计算至少需要的时间 `(x - 1) * (n + 1)`，记为 `min_time`
4. 计算出现次数为 `x` 的任务总数 `count`，计算最终结果为 `min_time + count`

### 特殊情况

然而存在一种特殊情况，例如：

```
输入: tasks = ["A","A","A","B","B","B","C","C","D","D"], n = 2
输出: 10
执行顺序: A -> B -> C -> A -> B -> D -> A -> B -> C -> D
```

此时如果按照上述方法计算将得到结果为 `8`，比数组总长度 `10` 要小，应返回数组长度。

### 代码实现

```python
class Solution(object):
    def leastInterval(self, tasks, n):
        """
        :type tasks: List[str]
        :type n: int
        :rtype: int
        """
        length = len(tasks)
        if length <= 1:
            return length
        
        # 用于记录每个任务出现的次数
        task_map = dict()
        for task in tasks:
            task_map[task] = task_map.get(task, 0) + 1
        # 按任务出现的次数从大到小排序
        task_sort = sorted(task_map.items(), key=lambda x: x[1], reverse=True)
        
        # 出现最多次任务的次数
        max_task_count = task_sort[0][1]
        # 至少需要的最短时间
        res = (max_task_count - 1) * (n + 1)
        
        for sort in task_sort:
            if sort[1] == max_task_count:
                res += 1
        
        # 如果结果比任务数量少，则返回总任务数
        return res if res >= length else length
```

## 376. 摆动序列

[原题链接](https://leetcode-cn.com/problems/wiggle-subsequence/)

### 解法一：贪心

**摆动序列**的特点为：所有数连成折线图，折线图出现**折点**时则发生摆动。

因此：

- 用变量 `forward` 表示此时折线图的走向趋势
- 用变量 `diff` 表示当前出现点的走向趋势

如果折线图向上走，此时出现的点向下走，那么就会出现**折点**，此时把结果 +1。

```python
class Solution(object):
    def wiggleMaxLength(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        length = len(nums)
        if length < 2:
            return length
        
        forward = nums[1] - nums[0]
        res = 1 if forward == 0 else 2
        
        for i in range(1, length):
            diff = nums[i] - nums[i - 1]
            if (diff > 0 and forward <= 0) or (diff < 0 and forward >= 0):
                res += 1
                forward = diff
            
        return res
```

## 955. 删列造序 II

[原题链接](https://leetcode-cn.com/problems/delete-columns-to-make-sorted-ii/)

### 思路

逐个比较两个相邻字符串的每个字符。假设相邻的两个字符串是 `s1` 和 `s2`，参与对比的两个字符分别为 `c1` 和 `c2`，这两个字符的对比无非就三种情况：

1. `c1 < c2`，是字典序：此时 `s1` 和 `s2` 符合字典序要求，我们无需再比对之后的字符串了
2. `c1 > c2`，非字典序：此时 `s1` 和 `s2` 不符合字典序的要求，该索引为必须要删除的索引。如果该索引还没有被删除（也有可能在其他比较的过程中删除了），我们就把这个要删除的索引记录下来，并且把要求的结果 `D.length + 1`，并且从头开始比对所有字符串
3. `c1 == c2`：这种情况比较特殊，看似是字典序，但这两个字符后其他字符的情况将决定 `s1` 和 `s2` 是否为字序。因此遇到两个字符相等的情况时，我们依然要继续比对字符串之后的其他字符

### 实现

```python
class Solution(object):
    def minDeletionSize(self, A):
        """
        :type A: List[str]
        :rtype: int
        """
        res = 0
        a_length = len(A)
        s_length = len(A[0])
        if a_length == 1:
            return 0
        
        # 记录已经删除的列
        mark = [0 for _ in range(s_length)]
        
        i = 1
        while i < a_length:
            pre_a = A[i - 1]
            cur_a = A[i]
            for j in range(s_length):
                # 如果是非字典序且该列还没有删除
                if pre_a[j] > cur_a[j] and mark[j] == 0:
                    mark[j] = 1
                    res += 1
                    # 重制 i 的位置，从第一个字符串开始重新比较
                    i = 0
                # 如果该列相等或该列已删除
                if pre_a[j] == cur_a[j] or mark[j] == 1:
                    continue
                break
            i += 1
                    
        return res
```

```swift
class Solution {
    func minDeletionSize(_ A: [String]) -> Int {
        var res = 0
        var aLength = A.count
        var sLength = A[0].count
        if aLength == 1 {
            return 0
        }
        
        var mark = [Int](repeating: 0, count: sLength)
        
        var i = 1
        while i < aLength {
            var preA = Array(A[i - 1])
            var curA = Array(A[i])
            for j in 0...sLength-1 {
                if preA[j] > curA[j] && mark[j] == 0 {
                    res += 1
                    mark[j] = 1
                    i = 0
                }
                
                if preA[j] == curA[j] || mark[j] == 1 {
                    continue
                }
                
                break
            }
            i += 1
        }
        return res
    }
}
```