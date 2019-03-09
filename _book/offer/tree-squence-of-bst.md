## 二叉搜索树的后序遍历序列

[原题链接](https://www.nowcoder.com/practice/a861533d45854474ac791d90e447bafd?tpId=13&tqId=11176&tPage=1&rp=1&ru=/ta/coding-interviews&qru=/ta/coding-interviews/question-ranking)

## 思路

在后序遍历得到的序列中，最后一个数字是树的根节点的值。数组中前面的数字可以分为两部分：

1. 第一部分是左子树结点的值，它们都比根结点的值小
2. 第二部分是右子树结点的值，它们都比根结点的值大

根据上述性质，所以我们可以写一个递归函数：

递归的终止条件是当前树的结点总数为 0

判断是否是二叉排序树的方法：

- 找到第一个大于根结点的结点位置，将数组分为两部分
- 判断右子树中的全部结点是否均大于根结点的值

```python
# -*- coding:utf-8 -*-
class Solution:
    def VerifySquenceOfBST(self, sequence):
        # write code here
        if sequence is None or len(sequence) == 0:
            return False
        
        length = len(sequence)
        root = sequence[length-1]
        
        for i in range(length):
            if sequence[i] > root:
                break
        
        for j in range(i, length-1):
            if sequence[j] <= root:
                return False
            
        left = True
        if i > 0:
            left = self.VerifySquenceOfBST(sequence[0:i])
        
        right = True
        if i < len(sequence) - 1:
            right = self.VerifySquenceOfBST(sequence[i:-1])
            
        return left and right
```