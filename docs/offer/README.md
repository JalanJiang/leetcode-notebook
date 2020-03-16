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

## 面试题68 - I. 二叉搜索树的最近公共祖先

同：235. 二叉搜索树的最近公共祖先