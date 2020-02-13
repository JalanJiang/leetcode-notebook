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