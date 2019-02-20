## 平衡二叉树

[原题链接](https://www.nowcoder.com/practice/8b3b95850edb4115918ecebdf1b4d222?tpId=13&tqId=11192&tPage=2&rp=1&ru=%2Fta%2Fcoding-interviews&qru=%2Fta%2Fcoding-interviews%2Fquestion-ranking)

## 思路

首先看一下 [平衡二叉树的概念](https://baike.baidu.com/item/%E5%B9%B3%E8%A1%A1%E4%BA%8C%E5%8F%89%E6%A0%91/10421057?fr=aladdin)。

具体求解思路：

- 递归计算左右子树的高度
- 通过高度差值判断是否为平衡二叉树

```python
# -*- coding:utf-8 -*-
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None
class Solution:
    is_balance = True
    def IsBalanced_Solution(self, pRoot):
        # write code here
        self.height(pRoot)
        return self.is_balance
        
    def height(self, root):
        if root is None:
            return 0
        left = self.height(root.left)
        right = self.height(root.right)
        
        if abs(left - right) > 1:
            self.is_balance = False
        return 1 + max(left, right)
```