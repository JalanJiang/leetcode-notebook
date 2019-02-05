## 从上往下打印二叉树

[原题链接](https://www.nowcoder.com/practice/7fe2212963db4790b57431d9ed259701?tpId=13&tqId=11175&tPage=1&rp=1&ru=/ta/coding-interviews&qru=/ta/coding-interviews/question-ranking)

## 思路

二叉树的层次遍历么，借助一个队列就可以了。

```python
# -*- coding:utf-8 -*-
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    # 返回从上到下每个节点值列表，例：[1,2,3]
    def PrintFromTopToBottom(self, root):
        if root is None:
            return []
        # write code here
        queue = []
        res = []
        queue.append(root)
        while len(queue) > 0:
            q_len = len(queue)
            for i in range(0, q_len):
                r = queue[0]
                del queue[0]
                if r is None:
                    continue
                res.append(r.val)
                queue.append(r.left)
                queue.append(r.right)
        return res
```