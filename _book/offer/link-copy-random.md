## 复杂链表的复制

- [原题链接](https://www.nowcoder.com/practice/f836b2c43afc4b35ad6adc41ec941dba?tpId=13&tqId=11178&tPage=2&rp=1&ru=%2Fta%2Fcoding-interviews&qru=%2Fta%2Fcoding-interviews%2Fquestion-ranking)
- [LeetCode 138.复制带随机指针的链表](/link_list/138.html)

## 思路

1. 在每个节点后添加一个该节点的复制节点
2. 复制 `random` 指针
3. 拆分链表

```python
# -*- coding:utf-8 -*-
# class RandomListNode:
#     def __init__(self, x):
#         self.label = x
#         self.next = None
#         self.random = None
class Solution:
    # 返回 RandomListNode
    def Clone(self, pHead):
        # write code here
        if pHead is None:
            return None
        
        tmp = pHead
        while tmp:
            new_node = RandomListNode(tmp.label)
            new_node.next = tmp.next
            tmp.next = new_node
            tmp = new_node.next
            
        tmp = pHead
        while tmp:
            next_node = tmp.next
            random_node = tmp.random
            if random_node:
                next_node.random = random_node.next
            tmp = next_node.next
        
        cur_head = pHead
        new_head = pHead.next
        
        while cur_head is not None and cur_head.next is not None:
            next_node = cur_head.next
            cur_head.next = next_node.next
            cur_head = next_node
        
        return new_head
```