## 二叉树的镜像

- [原题链接](https://www.nowcoder.com/practice/564f4c26aa584921bc75623e48ca3011?tpId=13&tqId=11171&tPage=1&rp=1&ru=/ta/coding-interviews&qru=/ta/coding-interviews/question-ranking)
- [Leetcode](http://jalan.space/leetcode-notebook/tree/226.html)

## 思路

- 递归

```python
# -*- coding:utf-8 -*-
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None
class Solution:
    # 返回镜像树的根节点
    def Mirror(self, root):
        # write code here
        if root is not None:
            self.Mirror(root.left)
            self.Mirror(root.right)
            
            l = root.left
            r = root.right
            root.left = r
            root.right = l
        return root
```