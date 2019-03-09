## 树的子结构

- [原题链接](https://www.nowcoder.com/practice/6e196c44c7004d15b1610b9afca8bd88?tpId=13&tqId=11170&tPage=1&rp=1&ru=/ta/coding-interviews&qru=/ta/coding-interviews/question-ranking)
- [Leetcode](https://leetcode-cn.com/problems/subtree-of-another-tree/)

## 思路


对于两棵二叉树来说，要判断B是不是A的子结构：

1. 在树 A 中查找与 B 根节点的值一样的节点
    - 通常对于查找树中某一个节点，采用递归的方法来遍历整棵树
2. 判断树A中以R为根节点的子树是不是和树B具有相同的结构
    - 同样利用到了递归的方法
    - 如果节点R的值和树的根节点不相同，则以R为根节点的子树和树B肯定不具有相同的节点
    - 如果它们值是相同的，则递归的判断各自的左右节点的值是不是相同
    - 递归的终止条件：达到了树A或者树B的叶节点
    
```python
# -*- coding:utf-8 -*-
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None
class Solution:
    def HasSubtree(self, pRoot1, pRoot2):
        # write code here
        result = False
        if pRoot1 != None and pRoot2 != None:
            if pRoot1.val == pRoot2.val:
                result = self.DoesTree1haveTree2(pRoot1, pRoot2)
            if not result:
                result = self.HasSubtree(pRoot1.left, pRoot2)
            if not result:
                result = self.HasSubtree(pRoot1.right, pRoot2)
        return result
    # 用于递归判断树的每个节点是否相同
    # 需要注意的地方是: 前两个if语句不可以颠倒顺序
    # 如果颠倒顺序, 会先判断pRoot1是否为None, 其实这个时候pRoot2的结点已经遍历完成确定相等了, 但是返回了False, 判断错误
    def DoesTree1haveTree2(self, pRoot1, pRoot2):
        if pRoot2 == None:
            return True
        if pRoot1 == None:
            return False
        if pRoot1.val != pRoot2.val:
            return False
        return self.DoesTree1haveTree2(pRoot1.left, pRoot2.left) and self.DoesTree1haveTree2(pRoot1.right, pRoot2.right)
```
