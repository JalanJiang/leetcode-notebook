## 重建二叉树

[原题链接](https://www.nowcoder.com/practice/8a19cbe657394eeaac2f6ea9b0f6fcf6?tpId=13&tqId=11157&tPage=1&rp=1&ru=%2Fta%2Fcoding-interviews&qru=%2Fta%2Fcoding-interviews%2Fquestion-ranking)

## 思路

前序遍历的第一个值为根节点的值，使用这个值将中序遍历结果分成两部分，左部分为树的左子树中序遍历结果，右部分为树的右子树中序遍历的结果。

![](https://cyc2018.github.io/CS-Notes/pics/_u91CD_u5EFA_u4E8C_u53C9_u6811-21548502782193.gif)

```python
# -*- coding:utf-8 -*-
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None
class Solution:
    # 返回构造的TreeNode根节点
    def reConstructBinaryTree(self, pre, tin):
        # write code here
        if not pre or not tin:
            return None
        root = TreeNode(pre.pop(0))
        tin_index = tin.index(root.val)
        root.left = self.reConstructBinaryTree(pre, tin[:tin_index])
        root.right = self.reConstructBinaryTree(pre, tin[tin_index+1:])
        return root
```