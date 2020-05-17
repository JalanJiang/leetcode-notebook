## 2. 两数相加

[原题链接](https://leetcode-cn.com/problems/add-two-numbers/description/)

### 思路

- 从链表头部开始，每个节点的数字各自相加
    - 相加结果 > 9，则进位 1 给下一个节点，%10 的值赋值
    - 相加结果 <= 9，则直接赋值
- 要考虑一些乱七八糟的情况，例如
    - 两个链表长度不一
    
```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def addTwoNumbers(self, l1, l2):
        """
        :type l1: ListNode
        :type l2: ListNode
        :rtype: ListNode
        """
        next = 0
        l3 = None
        root = None
        while l1 is not None or next != 0 or l2 is not None:
            if l1 is None:
                n1 = 0
            else:
                n1 = l1.val

            if l2 is None:
                n2 = 0
            else:
                n2 = l2.val

            n3 = n1 + n2 + next
            if n3 > 9:
                n3 = n3 % 10
                next = 1
            else:
                next = 0

            if l3 is None:
                l3 = ListNode(n3)
                root = l3
            else:
                l3.next = ListNode(n3)
                l3 = l3.next
                #break

            if l1 is not None:
                l1 = l1.next

            if l2 is not None:
                l2 = l2.next

        return root
```


## 19. 删除链表的倒数第N个节点

[原题链接](https://leetcode-cn.com/problems/remove-nth-node-from-end-of-list/description/)

### 解法一

循环两次。

- 倒数第 n 个元素为正数第 n1 个元素
- 特殊情况：删除第一个元素

```python
class Solution(object):
    def removeNthFromEnd(self, head, n):
        """
        :type head: ListNode
        :type n: int
        :rtype: ListNode
        """
        list_length = 0
        tmp = head
        while tmp:
            list_length = list_length + 1
            tmp = tmp.next
        n1 = list_length - n + 1
        
        tmp = head
        count = 1
        while tmp:
            if n1 == 1:
                head = head.next
                break
            if count == n1 - 1:
                tmp.next = tmp.next.next
            count = count + 1
            tmp = tmp.next
        return head
```

### 解法二

快慢指针，只需要一次循环。

- 使用两个指针 cur、pre，cur 比 pre 先行 n 步
- 当 cur 到达末尾时，pre 所指的下一个元素即是要删除的元素

```python
class Solution(object):
    def removeNthFromEnd(self, head, n):
        """
        :type head: ListNode
        :type n: int
        :rtype: ListNode
        """
        pre = head
        cur = head
        tmpn = n
        while n:
            cur = cur.next
            n = n - 1
        if cur is None: 
            return head.next
        while cur.next:
            pre = pre.next
            cur = cur.next
        pre.next = pre.next.next
        return head
```

## 21. 合并两个有序链表

[原题链接](https://leetcode-cn.com/problems/merge-two-sorted-lists/description/)

### 思路

递归呗

### Python

```python
class Solution(object):
    def mergeTwoLists(self, l1, l2):
        """
        :type l1: ListNode
        :type l2: ListNode
        :rtype: ListNode
        """
        if l1 is None:
            return l2
        if l2 is None:
            return l1
        head = None
        if l1.val < l2.val:
            head = l1
            head.next = self.mergeTwoLists(l1.next, l2)
        else:
            head = l2
            head.next = self.mergeTwoLists(l1, l2.next)
        return head
```

## 24. 两两交换链表中的节点

### 思路

- 为方便统一化创建空节点 `cur`
- 交换呗，没啥好说
- 注意返回头节点

### Python

```python
class Solution(object):
    def swapPairs(self, head):
        """
        :type head: ListNode
        :rtype: ListNode
        """
        cur = ListNode(0)
        cur.next = head
        first = cur
        while cur.next and cur.next.next:
            n1 = cur.next
            n2 = n1.next
            n3 = n2.next
            cur.next = n2
            n2.next = n1
            n1.next = n3
            cur = n1
        return first.next
```

## 25. K 个一组翻转链表

[原题链接](https://leetcode-cn.com/problems/reverse-nodes-in-k-group/)

### 思路

模拟过程。

```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def reverseKGroup(self, head: ListNode, k: int) -> ListNode:
        cur_idx = 0
        ans = ListNode(0)

        # 计算链表长度
        length = 0
        tmp = head
        while tmp is not None:
            length += 1
            tmp = tmp.next

        # 上一个节点
        pre = None
        pre_range_tail, range_head = ans, ans
        while head is not None and cur_idx + k <= length:
            for i in range(k):
                if i == 0:
                    # 记录头部指针
                    range_head = head
                if i == k - 1:
                    # 记录尾部节点
                    range_tail = head
                # 记录已遍历节点数量
                cur_idx += 1
                # 获取下一个节点
                next_node = head.next
                # 反转链表，指向上一个节点
                head.next = pre
                # 当前节点成为下一轮的「上一个节点」
                pre = head
                # 继续遍历下一个节点
                head = next_node
            # 前后两个链表相连
            pre_range_tail.next = range_tail
            # print(ans)
            pre_range_tail = range_head
            # print(ans)
            # 一轮结束，改变指针连接
            # range_head.next = head
            # 一轮结束后，改变 pre 指向
            pre = None

        # 如果有剩余节点，继续连接
        range_head.next = head

        return ans.next
```

- 事件复杂度：O(n)
- 空间复杂度：O(1)

## 61. 旋转链表

[原题链接](https://leetcode-cn.com/problems/rotate-list/solution/chuan-zhen-yin-xian-by-liweiwei1419/)

### 思路

双指针

```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def rotateRight(self, head: ListNode, k: int) -> ListNode:
        # 倒数第 n + 1 个节点变成尾部
        # 修改导出第 n + 1 个节点的 next 指针，指向 Null
        # 修改尾节点指针，指向头部
        if head is None:
            return None
        # 计算链表长度
        tmp = head
        length = 0
        while tmp.next is not None:
            length += 1
            tmp = tmp.next
        tail = tmp
        length += 1
        
        # 计算移动位
        k %= length
        # 不需要移动
        if k == 0:
            return head

        i = head
        j = head

        # j 先走 k 步
        for l in range(k):
            j = j.next

        while j.next is not None:
            j = j.next
            i = i.next

        # 得到 i
        i_next = i.next
        tail.next = head
        i.next = None

        return i_next
```


## 83. 删除排序链表中的重复元素

[原题链接](https://leetcode-cn.com/problems/remove-duplicates-from-sorted-list/description/)

### 思路

- 如果当前节点和下一个节点值相同，则指向下下个节点
- 注意边界值，None 就没有下一个节点啦

### Python

```python
class Solution(object):
    def deleteDuplicates(self, head):
        """
        :type head: ListNode
        :rtype: ListNode
        """
        tmp = head
        while tmp:
            if tmp.next:
                if tmp.val == tmp.next.val:
                    tmp.next = tmp.next.next
                else:
                    tmp = tmp.next
            else:
                tmp = tmp.next
        return head
```

## 86. 分隔链表

[原题链接](https://leetcode-cn.com/problems/partition-list/)

### 思路

创建两个链表。比 `x` 小的节点放在左链表中，比 `x` 大的节点放在右链表中，最后将两个链表连接。

⚠️注：记得把链表尾部置空。

```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def partition(self, head: ListNode, x: int) -> ListNode:
        left = ListNode(0)
        right = ListNode(0)

        res = left
        right_head = right

        while head is not None:
            if head.val < x:
                left.next = head
                left = left.next
            else:
                right.next = head
                right = right.next
            head = head.next
        
        # 拼接链表
        left.next = right_head.next
        right.next = None # 防止形成环
    
        return res.next
```

## 92. 反转链表 II

[原题链接](https://leetcode-cn.com/problems/reverse-linked-list-ii/)

### 思路

需要找到几个关键节点：

1. 开始翻转的节点 `begin`
2. 开始翻转节点的前一个节点 `begin_pre`
3. 结束翻转的节点 `end`
4. 结束翻转节点的下一个节点 `end_next`

从 `begin` 到 `end` 位置执行反转操作。此段链表翻转后需要：

1. 修改 `begin_pre` 节点的指针，指向 `end` 节点：`begin_pre.next = end`
2. 修改 `begin` 节点的指针，指向 `end_next` 节点：`begin.next = end_next`

注意：`m` 可能会等于 `n`。

```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def reverseBetween(self, head: ListNode, m: int, n: int) -> ListNode:
        if head is None:
            return head

        if m == n:
            return head

        index = 0 
        pre = None
        cur = head
        begin_pre = None
        begin = None
        end = None
        end_next = None

        while cur is not None:
            index += 1
            next_cur = cur.next

            if index == m:
                # 记录开始节点
                begin = cur
            if index == m - 1:
                begin_pre = cur
            if index == n:
                # 记录结束位置
                end = cur
            if index == n + 1:
                end_next = cur
            
            if index > m and index <= n:
                # 翻转
                cur.next = pre
            pre = cur
            cur = next_cur

        # 修改指针位置
        begin.next = end_next
        if begin_pre is None:
            # 从头开始翻转了
            return end
        else:
            begin_pre.next = end
            return head
```


## 138. 复制带随机指针的链表

[原题链接](https://leetcode-cn.com/problems/copy-list-with-random-pointer/comments/)

### 思路

- 在每个节点后插入复制节点 new_node，构成新链表
- 给出每个复制节点的 random 指向
- 拆分链表

```python
# Definition for singly-linked list with a random pointer.
# class RandomListNode(object):
#     def __init__(self, x):
#         self.label = x
#         self.next = None
#         self.random = None

class Solution(object):
    def copyRandomList(self, head):
        """
        :type head: RandomListNode
        :rtype: RandomListNode
        """
        
        if head is None:
            return None
        
        cur_head = head
        while cur_head:
            label = cur_head.label
            new_node = RandomListNode(label)
            new_node.next = cur_head.next
            cur_head.next = new_node
            cur_head = new_node.next
        
        cur_head = head
        while cur_head:
            new_node = cur_head.next
            if cur_head.random:
                new_node.random = cur_head.random.next
            cur_head = new_node.next
        
        cur_head = head
        new_head = head.next
        while cur_head is not None and cur_head.next:
            next_node = cur_head.next
            cur_head.next = next_node.next
            cur_head = next_node
        
        return new_head
```


## 141. 环形链表

[原题链接](https://leetcode-cn.com/problems/linked-list-cycle/submissions/)

### 思路

快慢指针，就像跑步的套圈行为。如果出现"套圈相遇"，那么就是有环。

```python
# Definition for singly-linked list.
# class ListNode(object):
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution(object):
    def hasCycle(self, head):
        """
        :type head: ListNode
        :rtype: bool
        """
        if head is None:
            return False
        
        slow = head
        fast = head.next
        
        while slow != fast:
            if slow is None or fast is None or fast.next is None:
                return False
            
            slow = slow.next
            fast = fast.next.next
            
        return True
```

另一种写法：

```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def hasCycle(self, head: ListNode) -> bool:
        slow = head
        fast = head

        while fast is not None and fast.next is not None:
            fast = fast.next.next
            slow = slow.next
            if fast == slow:
                return True

        return False
```

## 147. 对链表进行插入排序

[原题链接](https://leetcode-cn.com/problems/insertion-sort-list/)

### Tail 优化版

```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def insertionSortList(self, head: ListNode) -> ListNode:
        if head is None or head.next is None:
            return head

        # 固定头部
        new_head = ListNode(float("-inf"))

        cur = head
        pre = new_head

        # 加入尾部
        tail = new_head

        while cur is not None:
            if tail.val < cur.val:
                tail.next = cur
                tail = cur
                cur = cur.next
            else:
                cur_next = cur.next
                # 此时：tail.next = cur，会产生循环，故断开
                tail.next = cur_next
                while pre.next is not None and pre.next.val < cur.val:
                    pre = pre.next
                cur.next = pre.next
                pre.next = cur
                cur = cur_next
                pre = new_head

        return new_head.next
```

## 148. 排序链表

[原题链接](https://leetcode-cn.com/problems/sort-list/)

### 解一：归并 + 额外空间

```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def sortList(self, head: ListNode) -> ListNode:
        # 只有一个节点或没有节点时，直接返回
        if head is None or head.next is None:
            return head

        # 切分
        slow = head
        fast = head.next
        while fast is not None and fast.next is not None:
            fast = fast.next.next
            slow = slow.next

        r = slow.next
        slow.next = None # 切断
        left = self.sortList(head)
        right = self.sortList(r)

        # 合并
        h = ListNode(0) # 构造新链表
        res = h

        while left is not None and right is not None:
            if left.val < right.val:
                h.next = left
                left = left.next
            else:
                h.next = right
                right = right.next
            h = h.next
        
        # 加入未排序的部分
        h.next = left if left else right

        return res.next
```

### 解二：归并（无需额外空间）

@todo

## 160. 相交链表

[原题链接](https://leetcode-cn.com/problems/intersection-of-two-linked-lists/description/)

核心思想：消除长度差。

### 解法一

- 找出两个链表的长度差值 step
- 快慢指针，长的链表先走 step 步，然后循环两个链表
- 找到相同节点则返回，否则返回 None

### Python

```python
class Solution(object):
    def getIntersectionNode(self, headA, headB):
        """
        :type head1, head1: ListNode
        :rtype: ListNode
        """
        length_a = 0
        length_b = 0
        a = headA
        b = headB
        
        while a:
            a = a.next
            length_a = length_a + 1
                
        while b:
            b = b.next
            length_b = length_b + 1
        
        step = abs(length_a - length_b)
        a = headA
        b = headB
        if length_a > length_b:
            while step > 0:
                a = a.next
                step = step - 1
        if length_a < length_b:
            while step > 0:
                b = b.next
                step = step - 1
        
        while a != b:
            a = a.next
            b = b.next
        return a
```

### 解法二

设两个指针 `pa` 和 `pb` 分别指向 A 链表和 B 链表的表头，然后开始遍历。

当 `pa` 到达末尾时，将 `pa` 重置到链表 B 的头部；当 `pb` 到达尾部时，将 `pb` 重置到链表 A 的头部。用这种方法来消除 `pa` 和 `pb` 走过长度的长度差，如果 A 和 B 相交，那么 `pa` 和 `pb` 必定相遇。

```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def getIntersectionNode(self, headA: ListNode, headB: ListNode) -> ListNode:
        pa = headA
        pb = headB

        while pa != pb:
            # 不相交就继续走
            if pa is None:
                pa = headB
            else:
                pa = pa.next
            
            if pb is None:
                pb = headA
            else:
                pb = pb.next

        return pa
```

- 时间复杂度：$O(m + n)$
- 空间复杂度：$O(1)$

## 206. 反转链表

[原题链接](https://leetcode-cn.com/problems/reverse-linked-list/)

### 迭代法

- 给一个新的链表
- 让原链表的节点与原链表断开连接

### Python

```python
class Solution(object):
    def reverseList(self, head):
        """
        :type head: ListNode
        :rtype: ListNode
        """
        newList = None #新链表
        pre = None
        curNode = head

        while curNode:
            tmp = curNode.next
            curNode.next = newList #让当前节点与原链表断开连接
            newList = curNode #赋值给新链表
            curNode = tmp

        return newList
```

```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def reverseList(self, head: ListNode) -> ListNode:
        if head is None:
            return None

        pre = head
        cur = head.next

        while cur is not None:
            next_cur = cur.next
            cur.next = pre
            pre = cur
            cur = next_cur

        head.next = None
        return pre       
```

### 递归法

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
        
        # 取下一个节点
        node = self.reverseList(head.next)

        next_node = head.next
        next_node.next = head
        head.next = None

        return node
```

## 234. 回文链表

[原题链接](https://leetcode-cn.com/problems/palindrome-linked-list/description/)

### 解法一

- 反转链表
- 循环比较
- 空间复杂度 O(n)，不是很棒棒

```python
class Solution(object):
    def isPalindrome(self, head):
        """
        :type head: ListNode
        :rtype: bool
        """
        l = head
        pre = None
        cur = None
        end = None
        while l:
            cur = ListNode(l.val)
            cur.next = end
            end = cur
            l = l.next
        
        while head:
            if head.val != cur.val:
                return False
            head = head.next
            cur = cur.next
        return True
```

### 解法二

- 设置快慢指针，当快指针走完时，慢指针刚好走到中点
- 原地将后半段反转，进行回文

## 237. 删除链表中的节点

[原题链接](https://leetcode-cn.com/problems/delete-node-in-a-linked-list/)

### 思路分析

如果我们要在链表中删除一个节点，一般的操作是：

1. 修改要删除节点的上一个节点的指针
2. 将该指针指向要删除节点的下一个节点

例如，在链表 `[4, 5, 1, 9]` 中，当我们要删除节点 `5` 时，我们会修改节点 `5` 上一个节点 `4` 的指针，让它指向节点 `5` 的下一个节点，即节点 `1`：

![修改节点 4 的指针，让它指向节点 1](https://pic.leetcode-cn.com/188c3905565b3609d3ce670cf1b73320908de4f6e1bdea61ab3a1b7442359def-file_1574907780588)

**但这道题只告诉我们要删除的节点，我们并不知道该节点的上一个节点是什么**，这时候又该如何是好呢？

既然我们要删除一个节点时需要知道它的上一个节点，如果我们无法得知上一个节点，我们就**找一个可以知道上一个节点的节点，把它变成要删除的节点，然后删除它**。

这样听起来好像有些拗口？没事，直接看一个例子！

还是 `[4, 5, 1, 9]` 链表，还是删除节点 `5`。

首先，我们把节点 `5` 下一个节点的值赋给它，把它变成一个「不需要删除」的节点：

![把节点 5 下一个节点的值赋给它](https://pic.leetcode-cn.com/6e65c25f7a28a7c8900fb0e8b9205b91cda81d920fb0014d606f6468a7008506-file_1574907780596)

这样一来，第二个节点 `1` 和第三个节点 `1`，无论我们删除其中的哪一个，都可以得到最终结果 `[4, 1, 9]`。既然第二个节点不好删除，那我们就果断删除第三个啦~

改变第二个节点 `1` 的指针，将它指向第 4 个节点 `9`，这样一来，第三个节点 `1` 就被删除了：

![改变第 2 个节点的指针，让它指向第 4 个节点](https://pic.leetcode-cn.com/10d4294214a45a545cecb6f072dd6b01a9e090ca67bc8d22003aed2c248a6e49-file_1574907780593)

### 具体实现

<!-- tabs:start -->

#### **Python**

```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def deleteNode(self, node):
        """
        :type node: ListNode
        :rtype: void Do not return anything, modify node in-place instead.
        """
        node.val = node.next.val
        node.next = node.next.next
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
func deleteNode(node *ListNode) {
    node.Val = node.Next.Val
    node.Next = node.Next.Next
}
```

<!-- tabs:end -->

### 复杂度

- 时间复杂度 `O(1)`
- 空间复杂度 `O(1)`

### 总结一下

这道题没有给出链表的头节点，而是直接给出要删除的节点，让我们进行原地删除。我们对于该节点的前一个节点一无所知，所以无法直接执行删除操作。因此，**我们将要删除节点的 `next` 节点的值赋值给要删除的节点，转而去删除 `next` 节点，从而达成目的。**

题目中指明了「给定的节点为非末尾节点」且「链表至少包含两个节点」，所以上述方案是切实可行的。


## 328. 奇偶链表

[原题链接](https://leetcode-cn.com/problems/odd-even-linked-list/description/)

### 思路

- 定义奇偶两个链表 l1 l2
- 分别构造
- 两链表串联

直接上代码：

```python
class Solution(object):
    def oddEvenList(self, head):
        """
        :type head: ListNode
        :rtype: ListNode
        """
        head1 = ListNode(0)
        head2 = ListNode(0)
        l1 = head1
        l2 = head2
        while head:
            head1.next = head
            next_node = head.next
            head2.next = next_node
            if next_node:
                head = next_node.next
            else:
                head = None
            head1 = head1.next
            head2 = head2.next
        head1.next = l2.next
        return l1.next
```

## 445. 两数相加 II

### 解法一

- 反转链表
- 逐位相加，注意进位
- 最终输出的链表长度不能只和最长链表长度相同，要考虑到最高位的进位情况

```python
class Solution(object):
    def addTwoNumbers(self, l1, l2):
        """
        :type l1: ListNode
        :type l2: ListNode
        :rtype: ListNode
        """
        pre = None
        t1 = l1
        t2 = l2
        while t1:
            next_node = t1.next
            cur = t1
            cur.next = pre
            pre = t1
            t1 = next_node
        t1 = cur
        
        pre = None
        while t2:
            next_node = t2.next
            cur = t2
            cur.next = pre
            pre = t2
            t2 = next_node
        t2 = cur
        
        count = 0
        end = None
        while t1 or t2:
            if t1:
                n1 = t1.val
                t1 = t1.next
            else:
                n1 = 0
                
            if t2:
                n2 = t2.val
                t2 = t2.next
            else:
                n2 = 0
            
            n = n1 + n2 + count
            if n > 9:
                n = n % 10
                count = 1
            else:
                count = 0
            
            cur = ListNode(n)
            cur.next = end
            end = cur
        
        if count == 1:
            cur = ListNode(1)
            cur.next = end
    
        return cur
```

### 解法二

考虑不反转链表实现，可以用栈，Python 中就用 list `append()` 和 `pop()` 来即可。

```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def addTwoNumbers(self, l1: ListNode, l2: ListNode) -> ListNode:
        stack1 = list()
        stack2 = list()

        while l1 is not None:
            stack1.append(l1.val)
            l1 = l1.next
        
        while l2 is not None:
            stack2.append(l2.val)
            l2 = l2.next

        add_num = 0
        res = None
        while len(stack1) > 0 or len(stack2) > 0:
            num1, num2 = 0, 0

            if len(stack1) > 0:
                num1 = stack1.pop()
            
            if len(stack2) > 0:
                num2 = stack2.pop()

            num = num1 + num2 + add_num
            if num > 9:
                add_num = 1
            else:
                add_num = 0
            num %= 10

            cur = ListNode(num)
            cur.next = res
            res = cur

        if add_num == 1:
            cur = ListNode(1)
            cur.next = res
            res = cur

        return res
```

### 解法三

递归

## 725. 分隔链表

[原题链接](https://leetcode-cn.com/problems/split-linked-list-in-parts/description/)

### 解法一

愚蠢暴力解法，感觉应该会有更棒棒的方法。

- 计算分割方法，设链表长度为 length：
    - 如果 length <= k：分割成 length 份的 1 位元素和 k-length 份的 None
    - 如果 length > k：计算两个数值 n1 = length // k，n2 = length % k
        - n1：每份至少要有的元素个数
        - n2：有 n2 份的元素个数为 n1+1
- 将上诉分割方法存储在一个 list 中，循环链表按 list 的数值进行分割

```python
class Solution(object):
    def splitListToParts(self, root, k):
        """
        :type root: ListNode
        :type k: int
        :rtype: List[ListNode]
        """
        head = root
        length = 0
        while head:
            length = length + 1
            head = head.next
        
        length_list = []
        if length <= k:
            count = k
            length_list = [1 for _ in range(length)]
            length_list2 = []
            if length < k:
                length_list2 = [0 for _ in range(k - length)]
            length_list = length_list + length_list2
        else:
            n1 = length // k
            n2 = length % k
            length_list = [n1+1 for _ in range(n2)]
            length_list2 = [n1 for _ in range(k-n2)]
            length_list = length_list + length_list2
        
        res_list = []
        for length in length_list:
            step = length
            cur = ListNode(0)
            first = cur
            if step == 0:
                res_list.append(None)
            else:
                while step:
                    first.next = ListNode(root.val)
                    root = root.next
                    step = step - 1
                    first = first.next
            if cur.next:
                res_list.append(cur.next)
        return res_list
```

## 876. 链表的中间结点

[原题链接](https://leetcode-cn.com/problems/middle-of-the-linked-list/solution/)

### 快慢指针

fast 比 slow 速度快 2 倍。这样一来，fast 到达链表尾部后，slow 正好到达中间：

```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def middleNode(self, head: ListNode) -> ListNode:
        slow = head
        fast = head

        while fast is not None and fast.next is not None:
            fast = fast.next.next
            slow = slow.next
            
        return slow
```