## 把二叉树打印成多行

[原题链接](https://www.nowcoder.com/practice/445c44d982d04483b04a54f298796288?tpId=13&tqId=11213&tPage=1&rp=1&ru=/ta/coding-interviews&qru=/ta/coding-interviews/question-ranking) 

## 思路

和 [从上往下打印二叉树](/offer/tree-bfs.md) 一样。

```python
# -*- coding:utf-8 -*-
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None
class Solution:
    # 返回二维列表[[1,2],[4,5]]
    def Print(self, pRoot):
        # write code here
        
        if pRoot is None:
            return []
        
        q = []
        q.append(pRoot)
        res = []
        
        while len(q) > 0:
            size = len(q)
            tmp = []
            for i in range(size):
                root = q[0]
                del q[0]
                if root is None:
                    continue
                tmp.append(root.val)
                q.append(root.left)
                q.append(root.right)
            if len(tmp) > 0:
                res.append(tmp)
            
        return res
```