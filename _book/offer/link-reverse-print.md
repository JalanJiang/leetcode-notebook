## 从尾到头打印链表

[原题链接](https://www.nowcoder.com/practice/d0267f7f55b3412ba93bd35cfa8e8035?tpId=13&tqId=11156&tPage=1&rp=1&ru=/ta/coding-interviews&qru=/ta/coding-interviews/question-ranking)

### 思路一

放入栈中再逐一打印。

```python
# -*- coding:utf-8 -*-
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    # 返回从尾部到头部的列表值序列，例如[1,2,3]
    def printListFromTailToHead(self, listNode):
        # write code here
        stack = []
        while listNode:
            stack.append(listNode.val)
            listNode = listNode.next
        
        result = []
        while len(stack) > 0:
            result.append(stack.pop())
        
        return result 
```

### 思路二

递归。

```python
# -*- coding:utf-8 -*-
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    # 返回从尾部到头部的列表值序列，例如[1,2,3]
    def __init__(self):
        self.result = []
    
    def printListFromTailToHead(self, listNode):
        # write code here
        if listNode is not None:
            self.printListFromTailToHead(listNode.next)
            self.result.append(listNode.val)
        return self.result
```