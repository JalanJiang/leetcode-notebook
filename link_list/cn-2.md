## cn-255. 用队列实现栈

[原题链接](https://leetcode-cn.com/problems/add-two-numbers/description/)

### 思路

- 从链表头部开始，每个节点的数字各自相加
    - 相加结果 > 9，则进位 1 给下一个节点，%10 的值赋值
    - 相加结果 <= 9，则直接赋值
- 要考虑一些乱七八糟的情况，例如
    - 两个链表长度不一
    
### Python

代码写的跟 shi 一样。。。

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