## 938. 二叉搜索树的范围和

[原题链接](https://leetcode-cn.com/problems/range-sum-of-bst/)

### 思路

题目本来的意思比较难懂。其实意思是 `L` 和 `R` 之间**中序遍历**的结点值的和。

使用递归解决。

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def rangeSumBST(self, root: TreeNode, L: int, R: int) -> int:
        if root == None:
            return 0
        if root.val > R:
            return self.rangeSumBST(root.left, L, R)
        elif root.val < L:
            return self.rangeSumBST(root.right, L, R)
        else:
            return root.val + self.rangeSumBST(root.left, L, R) + self.rangeSumBST(root.right, L, R)
```