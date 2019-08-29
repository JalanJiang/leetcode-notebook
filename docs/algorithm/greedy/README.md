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

## 402. 移掉K位数字

[原题链接](https://leetcode-cn.com/problems/remove-k-digits/)

### 解一：贪心

如果要剩下的数字最小，那么数字从左开始的每一位都要尽可能地小，因此我们要从剩余数字的高位开始，在**有效范围**内找到最小的数字。

何为有效范围？

比如这个栗子：

```
输入: num = "1432219", k = 3
```

要求删除 3 位数字，留下 4 位数字。那么第 1 位数字的查找有效范围是 `1432`，即下标 `0 ~ 3`。因为如果我们再往后选择，比如选择第 5 位数字 2，那么我们就无法完整地凑齐 4 位数字了。

可以观察到规律：

- 第 1 位数字有效范围：下标 `0 ~ 3`
- 第 2 位数字有效范围：下标 `1 ~ 4`
- 第 3 位数字有效范围：下标 `2 ~ 5`
- ……

假设我们要从长度为 `length` 的字符串 `num` 中删除 `k` 位数字，那么第 `x` 个数字的有效查找范围是下标 `x-1 ~ k+x-1`。

整理一下思路：

1. 从高位开始逐一查找每一位数字尽可能小的取值。其中，第 `x` 位数字的有效取值范围是 `x-1 ~ k+x-1`
2. 找到最小值后记录最小值 `min_num` 以及对应的下标 `min_index`
3. 设置下一轮的查找开始位置为 `min_index + 1` 
4. 循环此过程，直到完成所有数字的查找

```python
class Solution:
    def removeKdigits(self, num: str, k: int) -> str:
        num_length = len(num)
        if num_length <= k:
            return "0"
        
        left_count = num_length - k
        res = ""
        count = 0
        begin = 0
        
        while count < left_count:
            min_index = 0
            min_num = float('inf')
            for i in range(begin, k + count + 1):
                # 找到最小数
                if int(num[i]) < min_num:
                    min_index = i
                    min_num = int(num[i])
            # 把找到的最小数加入结果列表
            res += str(min_num)
            # 设置下一轮查找范围的起点
            begin = min_index + 1
            count += 1
            
        return "0" if len(res) == 0 else str(int(res))
```

### 踩坑

- [Swift String 转数组](https://stackoverflow.com/questions/39299782/cannot-invoke-initializer-for-type-with-an-argument-list-of-type-element)

## 435. 无重叠区间

[原题链接](https://leetcode-cn.com/problems/non-overlapping-intervals/)

### 思路

1. 按区间左侧值对数组 `intervals` 升序排序
2. 当出现区间重叠时，删除 `end` 更大的区间

```python
class Solution:
    def eraseOverlapIntervals(self, intervals: List[List[int]]) -> int:
        length = len(intervals)
        if length <= 1:
            return 0
        intervals.sort(key=lambda x: x[0])
        
        pre_end = intervals[0][1]
        res = 0
        for i in range(1, length):
            if intervals[i][0] < pre_end:
                res += 1
                pre_end = min(pre_end, intervals[i][1])
            else:
                pre_end = intervals[i][1]
            
        return res
```

## 406. 根据身高重建队列

[原题链接](https://leetcode-cn.com/problems/queue-reconstruction-by-height/)

### 思路

先对原数组按 `h` 降序、`k` 升序排序。然后遍历数组，根据元素的 `k` 值进行「插队操作」：直接把元素插入数组下标为 `k` 的位置。

这样排序的理由是：

1. `k` 值表示排在这个人前面且身高大于或等于 `h` 的人数，按 `h` 降序排序可以确定身高更高者的人数
2. 按 `k` 降序排序则先处理排在更前面的数，避免更多的元素交换操作

```python
class Solution:
    def reconstructQueue(self, people: List[List[int]]) -> List[List[int]]:
        # 对 people 排序：按 h 降序，k 升序
        people.sort(key=lambda x: (-x[0], x[1]))
        length = len(people)
        
        i = 0
        while i < length:
            cur_people = people[i]
            k = cur_people[1]
            if k < i:
                # 从后往前遍历，进行「插队」步骤的元素交换
                for j in range(i , k, -1):
                    people[j] = people[j - 1]
                people[k] = cur_people
            i += 1
        
        return people
```

## 452. 用最少数量的箭引爆气球

[原题链接](https://leetcode-cn.com/problems/minimum-number-of-arrows-to-burst-balloons/)

### 思路

1. 对 `points` 按 `begin` 进行升序排序
2. 循环遍历 `points` 判断相邻位置的区间是否发生重叠
   - 如果重叠：说明只需要一支箭就可以射穿，并把重叠区间的 `end` 值记录下来，用于比较下一次的区间重叠情况
   - 如果不重叠：需要射出的箭数量 + 1

```python
class Solution:
    def findMinArrowShots(self, points: List[List[int]]) -> int:
        length = len(points)
        if length == 0:
            return 0
        res = 1
        # 排序
        points.sort(key=lambda x: x[0])
        
        end = points[0][1]
        # 遍历
        for i in range(1, length):
            if points[i][0] > end:
                res += 1
                end = points[i][1]
            else:
                end = min(end, points[i][1])
                
        return res
```

## 455. 分发饼干

[原题链接](https://leetcode-cn.com/problems/assign-cookies/submissions/)

### 思路

贪心问题。**优先满足胃口小的小朋友的需求**。

1. 对 `g` 和 `s` 升序排序
2. 初始化两个指针 `i` 和 `j` 分别指向 `g` 和 `s` 初始位置
3. 对比 `g[i]` 和 `s[j]`
    - `g[i] <= s[j]`：饼干满足胃口，把能满足的孩子数量加 1，并移动指针 `i = i + 1`，`j = j + 1`
    - `g[i] > s[j]`：无法满足胃口，`j` 右移，继续查看下一块饼干是否可以满足胃口

```python
class Solution(object):
    def findContentChildren(self, g, s):
        """
        :type g: List[int]
        :type s: List[int]
        :rtype: int
        """
        res = 0
        g.sort()
        s.sort()
        
        g_length = len(g)
        s_length = len(s)
        
        i = 0
        j = 0
        while i < g_length and j < s_length:
            if g[i] <= s[j]:
                # 可以满足胃口，把小饼干喂给小朋友
                res += 1
                i += 1
                j += 1
            else:
                # 不满足胃口，查看下一块小饼干
                j += 1
                
        return res
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

## 649. Dota2 参议院

[原题链接](https://leetcode-cn.com/problems/dota2-senate/)

### 思路

1. 创建两个队列 `rq` 和 `dq` 用于分别存储 `R` 和 `D` 在 `senate` 中的下标值，`length` 代表 `senate` 长度
2. 从队列头部弹出下标值 `r` 和 `d`，比较两者的大小
   - 如果 `r > d`：则保留 `d` 值，将 `d + length` 放置到队列 `dq` 末尾
   - 如果 `r < d`：则保留 `r` 值，将 `r + length` 放置到队列 `rq` 末尾
3. 重复过程 2，直到有队列为空
4. 最终不为空的队列所在阵营宣布胜利！

```python
class Solution:
    def predictPartyVictory(self, senate: str) -> str:
        rq = list()
        dq = list()
        length = len(senate)
        
        for i in range(length):
            c = senate[i]
            if c == "R":
                rq.append(i)
            else:
                dq.append(i)
                
        while len(rq) > 0 and len(dq) > 0:
            r = rq[0]
            d = dq[0]
            
            if r > d:
                # 保留 r
                dq.append(d + length)
            else:
                rq.append(r + length)
                
            del rq[0]
            del dq[0]
            
        return "Dire" if len(rq) == 0 else "Radiant"
```

## 659. 分割数组为连续子序列

[原题链接](https://leetcode-cn.com/problems/split-array-into-consecutive-subsequences/)

### 思路

使用两个哈希表：

- 哈希表 `counter` 用于存储元素出现的次数，`counter[n]` 代表 n 出现的次数
- 哈希表 `end` 用于存储以元素结尾的连续子序列（指至少包含三个连续整数的子序列）个数，`end[n]` 代表以 n 结尾的连续子序列的个数

**过程如下**：

遍历数组 `nums`：

- 若元素 `n` 的出现次数 `count[n] == 0`：跳过该元素
- 若元素 `n` 的出现次数 `count[n] > 0`：
  - 存在以元素 `n - 1` 结尾的连续子序列，即 `end[n - 1] > 0`，将元素添加到该子序列的末尾，操作数据：
      1. 以 `n - 1` 结尾的子序列数量减 1：`end[n - 1] -= 1`
      2. 以 `n` 结尾的子序列数量加 1：`end[n] += 1`
  - 不存在以元素 `n - 1` 结尾的连续子序列，此时判断是否能以 `n` 作为开头构建连续子序列，即判断 `counter[n + 1]` 与 `counter[n + 2]` 的值是否均大于 0：
    - 若不能构成：返回 `False`
    - 若可以构成，操作数据：
      1. `n + 1` 元素数量减 1：`counter[n + 1] -= 1`
      2. `n + 2` 元素数量减 1：`counter[n + 2] -= 1`
      3. 以 `n + 2` 元素结尾的子序列数量加 1：`end[n + 2] += 1`

```python
class Solution:
    def isPossible(self, nums: List[int]) -> bool:
        # 记录元素出现次数
        counter = dict()
        for n in nums:
            counter[n] = counter.get(n, 0) + 1
            
        end = dict()
        for n in nums:
            if counter[n] == 0:
                continue
                
            counter[n] -= 1
            if end.get(n - 1, 0) > 0:
                # 添加到已有子序列的末尾
                end[n - 1] -= 1
                end[n] = end.get(n, 0) + 1
            elif counter.get(n + 1, 0) > 0 and counter.get(n + 2, 0) > 0:
                # 添加到子序列头部
                counter[n + 1] -= 1
                counter[n + 2] -= 1
                end[n + 2] = end.get(n + 2, 0) + 1
            else:
                return False
        return True
```

## 738. 单调递增的数字

[原题链接](https://leetcode-cn.com/problems/monotone-increasing-digits/)

### 思路

将 `N` 从高位往低位遍历，遍历过程中做两件事：

1. 记录遇到的最大值和最大值所在位置，假设分别记为 `max_num` 和 `begin`
2. 比较相邻数字，若遇到后一位数比当前数小时（非递增），退出遍历

此时，我们将 `max_index` 位置的数减去 1，并将 `begin` 位置后的数都置为 9，所得出的数就是我们想要的结果。

### 举例

拿 `N = 332` 举个栗子。

遍历过程：

1. 拿到数字 3，为当前最大值，记录 `max_num = 3`，`begin = 0`；与后一位数比较，`3 == 3`，继续遍历
2. 拿到数字 3，没有大于 `max_num`，因此不更新最大值和最大值所在位置；与后一位数比较发现 `3 > 2`，出现非递增，退出遍历

遍历结束后我们拿到 `begin = 0`，因此我们把 `begin` 位置的数减 1，即把第一位数减去 1，第 1 位后的其他数置 9，得到：`299`。

### 实现

```python
class Solution:
    def monotoneIncreasingDigits(self, N: int) -> int:
        nums = list(str(N))
        length = len(nums)
        begin = 0
        # N 是否符合条件
        is_result = True
        max_num = float('-inf')
        
        # 从前往后观察
        for i in range(1, length):
            num = int(nums[i])
            pre_num = int(nums[i - 1])
            # 记录最大值
            if pre_num > max_num:
                begin = i - 1
                max_num = pre_num
            if pre_num > num:
                is_result = False
                break
        
        # 如果 N 本身符合条件，直接返回 N
        if is_result:
            return N
        
        # begin 位置减去 1，后面全部替换为 9
        nums[begin] = str(int(nums[begin]) - 1)
        for i in range(begin + 1, length):
            nums[i] = '9'
                    
        return int("".join(nums))
```

### 复杂度

- 时间复杂度：`O(n)`
- 空间复杂度：`O(n)`

## 955. 删列造序 II

[原题链接](https://leetcode-cn.com/problems/delete-columns-to-make-sorted-ii/)

### 思路

逐个比较两个相邻字符串的每个字符。假设相邻的两个字符串是 `s1` 和 `s2`，参与对比的两个字符分别为 `c1` 和 `c2`，这两个字符的对比无非就三种情况：

1. `c1 < c2`，是字典序：此时 `s1` 和 `s2` 符合字典序要求，我们无需再比对之后的字符串了
2. `c1 > c2`，非字典序：此时 `s1` 和 `s2` 不符合字典序的要求，该索引为必须要删除的索引。如果该索引还没有被删除（也有可能在其他比较的过程中删除了），我们就把这个要删除的索引记录下来，并且把要求的结果 `D.length + 1`，并且从头开始比对所有字符串
3. `c1 == c2`：这种情况比较特殊，看似是字典序，但这两个字符后其他字符的情况将决定 `s1` 和 `s2` 是否为字序。因此遇到两个字符相等的情况时，我们依然要继续比对字符串之后的其他字符

### 实现

<!-- tabs:start -->

#### ** Python **

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

#### ** Swift **

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

<!-- tabs:end -->