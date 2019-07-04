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

```

### 解法二：贪心

主要思想：每次都要跳到**能跳到更远位置**的点上。

```
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

