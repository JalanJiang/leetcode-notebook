## 两个链表的第一个公共节点

- [原题链接](https://www.nowcoder.com/practice/6ab1d9a29e88450685099d45c9e31e46?tpId=13&tqId=11189&tPage=2&rp=1&ru=%2Fta%2Fcoding-interviews&qru=%2Fta%2Fcoding-interviews%2Fquestion-ranking)
- [Leetcode 题解](http://jalan.space/leetcode-notebook/link_list/160.html)

## 思路

- 找出两个链表的长度差
- 利用快慢指针

```python
# -*- coding:utf-8 -*-
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None
class Solution:
    def FindFirstCommonNode(self, pHead1, pHead2):
        # write code here
        length1 = 0
        tmp1 = pHead1
        while tmp1:
            tmp1 = tmp1.next
            length1 += 1
        
        length2 = 0
        tmp2 = pHead2
        while tmp2:
            tmp2 = tmp2.next
            length2 += 1
        
        step = abs(length1 - length2)
        if length1 > length2:
            while step > 0:
                pHead1 = pHead1.next
                step -= 1
        
        if length2 > length1:
            while step > 0:
                pHead2 = pHead2.next
                step -= 1
        
        while pHead1 != pHead2:
            pHead1 = pHead1.next
            pHead2 = pHead2.next
        return pHead1
```