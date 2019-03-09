## 二叉树的下一个节点

[原题链接](https://www.nowcoder.com/practice/9023a0c988684a53960365b889ceaf5e?tpId=13&tqId=11210&tPage=1&rp=1&ru=/ta/coding-interviews&qru=/ta/coding-interviews/question-ranking)

### 思路

- 中序遍历顺序：左节点->父节点->右节点
- 如果该节点有右子节点：取该右子节点的最左节点
- 如果该节点没有右子节点：向上遍历找父节点
    - 如果父节点的左子节点为该节点：返回该父节点

```python
# -*- coding:utf-8 -*-
# class TreeLinkNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None
#         self.next = None
class Solution:
    def GetNext(self, pNode):
        # write code here
        if pNode.right is not None:
            node = pNode.right
            while node.left is not None:
                node = node.left
            return node
        else:
            while pNode.next is not None:
                parent = pNode.next
                if parent.left == pNode:
                    return parent
                pNode = pNode.next
        return None
```