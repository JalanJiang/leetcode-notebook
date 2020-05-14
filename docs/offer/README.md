## 面试题 01.06. 字符串压缩

[原题链接](https://leetcode-cn.com/problems/compress-string-lcci/)

### 思路

<!-- tabs:start -->

#### **Python**

```python
class Solution:
    def compressString(self, S: str) -> str:
        s_length = len(S)
        if s_length == 0:
            return S
        res = ''
        cur = ''
        count = 0
        for s in S:
            if s != cur:
                if cur != '':
                    res += cur + str(count)
                cur = s
                count = 1
            else:
                count += 1
        # 尾部处理
        res += cur + str(count)
        return res if len(res) < s_length else S
```

#### **Go**

Go 字符串相关知识点：

- `rune` -> `string`：`string(rune)`
- `int` -> `string`: `strconv.Itoa(int)`

```go
func compressString(S string) string {
    sLength := len(S)
    if sLength == 0 {
        return S
    }
    var res string
    var cur rune
    var empty rune
    var count int
    for _, s := range S {
        if s != cur {
            if cur != empty {
                res += string(cur) + strconv.Itoa(count)
            }
            cur = s
            count = 1
        } else {
            count += 1
        }
    }
    res += string(cur) + strconv.Itoa(count)
    if len(res) < sLength {
        return res
    }
    return S
}
```

<!-- tabs:end -->

## 面试题 01.07. 旋转矩阵

[原题链接](https://leetcode-cn.com/problems/rotate-matrix-lcci/)

### 思路

找出要进行顺时针旋转的四个位置分别是：`(i, j) (j, n-i-1) (n-i-1, n-j-1)`

```python
class Solution:
    def rotate(self, matrix: List[List[int]]) -> None:
        """
        Do not return anything, modify matrix in-place instead.
        """
        n = len(matrix)
        # 旋转交换的四个位置：(i, j) (j, n-i-1) (n-i-1, n-j-1) (n-j-1, i)
        # 枚举范围：宽 (n + 1)/2 高 n/2
        for i in range(n // 2):
            for j in range((n + 1) // 2):
                temp = matrix[i][j]
                matrix[i][j] = matrix[n - j - 1][i]
                matrix[n - j - 1][i] = matrix[n - i - 1][n - j - 1]
                matrix[n - i - 1][n - j - 1] = matrix[j][n - i - 1]
                matrix[j][n - i - 1] = temp
```

## 面试题03. 数组中重复的数字

[原题链接](https://leetcode-cn.com/problems/shu-zu-zhong-zhong-fu-de-shu-zi-lcof/)

找出数组中重复的数字。


在一个长度为 n 的数组 nums 里的所有数字都在 0～n-1 的范围内。数组中某些数字是重复的，但不知道有几个数字重复了，也不知道每个数字重复了几次。请找出数组中任意一个重复的数字。

示例 1：

```
输入：
[2, 3, 1, 0, 2, 5, 3]
输出：2 或 3 
```

限制：

`2 <= n <= 100000`

### 哈希

<!-- tabs:start -->

#### **Python**

```python
class Solution:
    def findRepeatNumber(self, nums: List[int]) -> int:
        m = dict()
        for n in nums:
            if n in m:
                return n
            m[n] = True
```

#### **Go**

```go
func findRepeatNumber(nums []int) int {
    m := make([]int, len(nums))
    for _, e := range nums {
        if m[e] == 1 {
            return e
        }
        m[e] = 1
    }
    return -1
}
```

<!-- tabs:end -->

## 面试题06. 从尾到头打印链表

[原题链接](https://leetcode-cn.com/problems/cong-wei-dao-tou-da-yin-lian-biao-lcof/)

输入一个链表的头节点，从尾到头反过来返回每个节点的值（用数组返回）。

**示例 1：**

```
输入：head = [1,3,2]
输出：[2,3,1]
```

限制：

`0 <= 链表长度 <= 10000`

### 解一：栈

根据「从尾到头反过来」的描述很容易想到有着「先进后出」特征的数据结构 —— **栈**。

我们可以利用栈完成这一逆序过程，将链表节点值按顺序逐个压入栈中，再按各个节点值的弹出顺序返回即可。

```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def reversePrint(self, head: ListNode) -> List[int]:
        stack = list()
        while head is not None:
            stack.append(head.val)
            head = head.next

        return stack[::-1]
```

复杂度：

- 时间复杂度：$O(n)$
- 空间复杂度：$O(n)$

### 解二：递归

递归也能模拟栈的逆序过程。

我们将链表节点传入递归函数，递归函数设计如下：

- 递归函数作用：将链表节点值逆序存入结果集
- 结束条件：当节点为空时
- 递归调用条件：当下一个节点不为空时

```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def reversePrint(self, head: ListNode) -> List[int]:
        res = []
        self.reverse(head, res)
        return res

    def reverse(self, head, res):
        if head is None:
            return 
        if head.next is not None:
            # 下一个节点不为空：递归调用
            self.reverse(head.next, res)
        res.append(head.val)
```

简化一下：

<!-- tabs:start -->

#### **Python**

```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def reversePrint(self, head: ListNode) -> List[int]:
        if head is None:
            return []
        res = self.reversePrint(head.next)
        res.append(head.val)
        return res
```

#### **Go**

```go
/**
 * Definition for singly-linked list.
 * type ListNode struct {
 *     Val int
 *     Next *ListNode
 * }
 */
func reversePrint(head *ListNode) []int {
    if head == nil {
        return []int{}
    }
    res := reversePrint(head.Next)
    return append(res, head.Val)
}
```

<!-- tabs:end -->

复杂度：

- 时间复杂度：$O(n)$
- 空间复杂度：$O(n)$

## 面试题 17.16. 按摩师

[原题链接](https://leetcode-cn.com/problems/the-masseuse-lcci/)

### 动态规划

- 用 `dp[0][i]` 表示不接 i 预约可以获得的最长预约时间
- 用 `dp[1][i]` 表示接 i 预约可以获得的最长预约时间

```python
class Solution:
    def massage(self, nums: List[int]) -> int:
        # dp[0][i] 不接
        # dp[1][i] 接
        length = len(nums)
        if length == 0:
            return 0
        dp = [[0 for _ in range(length)] for _ in range(2)]
        # 转移方程：dp[0][i] = max(dp[1][i - 1], dp[0][i - 1])
        # dp[1][i] = max(dp[0][i - 1] + nums[i])
        dp[1][0] = nums[0]
        for i in range(1, length):
            dp[0][i] = max(dp[1][i - 1], dp[0][i - 1])
            dp[1][i] = dp[0][i - 1] + nums[i]
        return max(dp[0][length - 1], dp[1][length - 1])
```

## 面试题 08.11. 硬币

[原题链接](https://leetcode-cn.com/problems/coin-lcci/)

### 思路

1. 遍历所有硬币
2. `dp[i - coin]` 表示去掉 coin 面额后的组合数量

```python
class Solution:
    def waysToChange(self, n: int) -> int:
        coins = [1, 5, 10, 25]
        dp = [0 for _ in range(n + 1)]
        dp[0] = 1
        for coin in coins:
            for i in range(coin, n + 1):
                dp[i] = (dp[i] + dp[i - coin]) % 1000000007
        return dp[n]
```

## 面试题 16.03. 交点

[原题链接](https://leetcode-cn.com/problems/intersection-lcci/)

### 思路

解方程题目。。。就是代码写得太丑了。

```python
class Solution:
    def intersection(self, start1: List[int], end1: List[int], start2: List[int], end2: List[int]) -> List[float]:
        # kx + b = y
        # 调换位置：x1 < x2, x3 < x4，避免后续判断
        x1, y1 = start1[0], start1[1]
        x2, y2 = end1[0], end1[1]
        if x1 > x2:
            x1, x2 = x2, x1
            y1, y2 = y2, y1
        x3, y3 = start2[0], start2[1]
        x4, y4 = end2[0], end2[1]
        if x3 > x4:
            x3, x4 = x4, x3
            y3, y4 = y4, y3

        # 判断是否有交点
        if x2 < x3 or x4 < x1 or max(y1, y2) < min(y3, y4) or max(y3, y4) < min(y1, y2):
            # 此时两线段不会有交点
            return ans

        # 计算斜率和参数
        b1, b2 = 0, 0
        if x1 == x2:
            k1 = None
        else:
            k1 = (y2 - y1) / (x2 - x1)
            b1 = y1 - k1 * x1
        if x3 == x4:
            k2 = None
        else:
            k2 = (y4 - y3) / (x4 - x3)
            b2 = y3 - k2 * x3

        # print(k1, b1, k2, b2)

        # 判断具体条件
        if k1 is None and k2 is None:
            if x1 == x3:
                # 垂直重合，判断 y 的交点
                if min(y1, y2) <= max(y3, y4):
                    return [x1, min(y1, y2)]
                if min(y3, y4) <= max(y1, y2):
                    return [x1, min(y3, y4)]
            return []

        if k1 is None:
            return [x1, k2 * x1 + b2]

        if k2 is None:
            return [x3, k1 * x3 + b1]
        
        if k1 == k2:
            # 平行或重叠
            if b1 == b2:
                # 相交
                # 找 x 区间的相交点
                if x3 >= x1 and x3 <= x2:
                    return [x3, y3]
                if x4 >= x1 and x4 <= x2:
                    return [x4, y4]
                if x1 >= x3 and x1 <= x4:
                    return [x1, y1]
                if x2 >= x3 and x2 <= x4:
                    return [x2, y2]
            return []

        # 相交，求交点
        x = (b2 - b1) / (k1 - k2)
        y = k1 * x + b1
        if x < x1 or x < x3 or x > x2 or x > x4 or y < min(y1, y2) or y < min(y3, y4) or y > max(y1, y2) or y > max(y3, y4):
            return []
        return [x, y]
```

## 面试题24. 反转链表

[原题链接](https://leetcode-cn.com/problems/fan-zhuan-lian-biao-lcof/)

### 解一

```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def reverseList(self, head: ListNode) -> ListNode:
        pre = None
        while head:
            next_node = head.next
            head.next = pre
            pre = head
            head = next_node
        return pre
```

### 解二：递归法

```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def reverseList(self, head: ListNode) -> ListNode:
        if head is None or head.next is None:
            return head
        # 自顶向下，把 head 的后面的头传进去翻转，得到的是翻转链表的尾巴，后面链表翻转完的尾巴就是 head.next
        cur = self.reverseList(head.next)
        # 翻转最后一个 head。由于链表翻转完的尾巴就是 head.next，要让 head 变为最后一个，那就是 head.next.next = head
        head.next.next = head
        # 断开链接
        head.next = None
        return cur
```

## 面试题56 - I. 数组中数字出现的次数

[原题链接](https://leetcode-cn.com/problems/shu-zu-zhong-shu-zi-chu-xian-de-ci-shu-lcof/)

### 思路：异或

1. 求出所有数异或的结果
2. 结果中为 1 的位表示两个数不同数字的位
3. 根据这个为 1 的位置把 `nums` 分成两组分别异或就可以得出结果

```python
class Solution:
    def singleNumbers(self, nums: List[int]) -> List[int]:
        ret = 0
        for n in nums:
            ret ^= n
        # 找出从右到左第一个为 1 的数
        index = 0
        while ret & 1 == 0:
            # 右移 1 位
            ret >>= 1
            index += 1
        a, b = 0, 0
        for n in nums:
            if (n >> index) & 1 == 0:
                a ^= n
            else:
                b ^= n
        return [a, b]
```

## 面试题57 - II. 和为s的连续正数序列

[原题链接](https://leetcode-cn.com/problems/he-wei-sde-lian-xu-zheng-shu-xu-lie-lcof/)

### 滑动窗口法

```python
class Solution:
    def findContinuousSequence(self, target: int) -> List[List[int]]:
        s = 0
        tmp = []
        res = []
        for i in range(1, target):
            s += i
            tmp.append(i)
            while s >= target:
                if s == target:
                    res.append(tmp[:])
                s -= tmp[0]
                del tmp[0]
        return res
```

## 面试题59 - II. 队列的最大值

[原题链接](https://leetcode-cn.com/problems/dui-lie-de-zui-da-zhi-lcof/)

### 思路

用一个双端队列，将队列最大值永远放在双端队列的队首。

<!-- tabs:start -->

#### **Python**

```python
class MaxQueue:

    def __init__(self):
        self.m = 0
        self.queue = []
        self.deque = []

    def max_value(self) -> int:
        if len(self.queue) == 0:
            return -1
        return self.deque[0]

    def push_back(self, value: int) -> None:
        self.queue.append(value)
        # 维护 deque
        while len(self.deque) > 0 and self.deque[-1] < value:
            # 从尾部删除这个值
            self.deque.pop()
        self.deque.append(value)

    def pop_front(self) -> int:
        if len(self.queue) == 0:
            return -1
        first = self.queue[0]
        del self.queue[0]
        if first == self.deque[0]:
            del self.deque[0]
        return first

# Your MaxQueue object will be instantiated and called as such:
# obj = MaxQueue()
# param_1 = obj.max_value()
# obj.push_back(value)
# param_3 = obj.pop_front()
```

#### **Go**

```go
type MaxQueue struct {
    Queue []int
    Deque []int
}


func Constructor() MaxQueue {
    var maxQueue MaxQueue
    maxQueue.Queue = make([]int, 0)
    maxQueue.Deque = make([]int, 0)
    return maxQueue
}


func (this *MaxQueue) Max_value() int {
    if len(this.Queue) == 0 {
        return -1
    }
    return this.Deque[0]
}


func (this *MaxQueue) Push_back(value int)  {
    // 维护双端队列
    this.Queue = append(this.Queue, value)
    for len(this.Deque) > 0 && value > this.Deque[len(this.Deque) - 1] {
        // 最后一个值出队
        this.Deque = this.Deque[:len(this.Deque) - 1]
    }
    this.Deque = append(this.Deque, value)
}


func (this *MaxQueue) Pop_front() int {
    if len(this.Queue) == 0 {
        return -1
    }
    first := this.Queue[0]
    if first == this.Deque[0] {
        // 删除第一个元素
        this.Deque = this.Deque[1:]
    }
    this.Queue = this.Queue[1:]
    return first
}


/**
 * Your MaxQueue object will be instantiated and called as such:
 * obj := Constructor();
 * param_1 := obj.Max_value();
 * obj.Push_back(value);
 * param_3 := obj.Pop_front();
 */
```

<!-- tabs:end -->

## 面试题62. 圆圈中最后剩下的数字

[原题链接](https://leetcode-cn.com/problems/yuan-quan-zhong-zui-hou-sheng-xia-de-shu-zi-lcof/)

### 思路

我们用 `f(n, m)` 表示从 n 个数中每次删除第 m 个数（共删除了 n - 1 次），最后留下的那个数的**序号**。

我们从 `f(n, m)` 场景下删除的第 1 个数是从序号 0 开始，向后数 m 个数得到的。删除第一个数后，将剩下 n - 1 个数，此时场景变为 `f(n - 1, m)`，用于表示从 n - 1 个数中每次删除第 m 个数最后留下的数的**序号**。

在往下看之前，我们先达成一个共识：**`f(n, m)` 与 `f(n - 1, m)` 得到的数是同一个数（最后剩下的数在每一轮中都不可能被删除），只是在它们所在的场景下，这个数字的序号不同罢了。**

那么，何谓「所在场景，序号不同」？

这里所说的「序号」与**所在场景下首次选取删除数字的出发点有关**，我们直接看下题目给出的 `n = 5, m = 3` 这个例子，已知答案为 3。

### 不同场景下的不同序号

#### f(n, m) 场景

此时 `n = 5`，由于我们从第 1 个数字出发，所以从第 1 个数字开始编号：

```
数字：
0 1 2 3 4
序号：
0 1 2 3 4
```

可以看到答案 3 在该场景下的序号为 3。

#### f(n - 1, m) 场景

此时，我们已经在 `f(n, m)` 场景下删除一个数了，这个数是 2，因此我们要从 3 开始重新编号：

```
数字：
0 1 3 4
序号：
2 3 0 1
```

答案 3 在该场景下的序号为 0。

### 两者序号的关系

我们知道，从 `f(n - m)` 场景下删除的第一个数的**序号**是 `(m - 1) % n`，那么 `f(n - 1, m)` 场景将使用被删除数字的下一个数，即序号 `m % n` 作为它的 0 序号。

设 `f(n - 1, m)` 的结果为 `x`，`x` 是从 `f(n, m)` 场景下序号为 `m % n` 的数字出发所获得的结果，因此，我们可以得出：`m % n + x` 是该数字在 `f (n, m)` 场景下的结果序号。即：

```
f(n, m) = m % n + x
```
但由于 `m % n + x` 可能会超过 n 的范围，所以我们再取一次模：

```
f(n , m) = (m % n + x) % n = (m + x) % n
```

将 `f(n - 1, m)` 代回，得到递推公式：

```
f(n, m) = (m + f(n - 1, m)) % n
```

有了递推公式后，想递归就递归，想迭代就迭代咯~

### 具体实现

```python
sys.setrecursionlimit(100000)

class Solution:
    def lastRemaining(self, n: int, m: int) -> int:
        return self.f(n, m)

    def f(self, n, m):
        if n == 0:
            return 0
        x = self.f(n - 1, m)
        return (m + x) % n
```

各位大佬的图实在画得太好了，我就不献丑了（逃

## 面试题68 - I. 二叉搜索树的最近公共祖先

同：235. 二叉搜索树的最近公共祖先