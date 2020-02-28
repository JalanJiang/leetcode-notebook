## 101. 对称二叉树

[原题链接](https://leetcode-cn.com/problems/symmetric-tree/description/)

### 解一：递归

递归法，判断二叉树是否为镜像对称。

镜像特点：

- 根节点：左节点值 = 右节点值
- 非根节点：左节点值 = 兄弟节点的右节点值

因此，可对每两个镜像节点做如下判断：

```
if 节点A为空:
    if 节点B为空:
        return 是镜像
    else:
        return 不是镜像
else:
    if 节点B为空:
        return 不是镜像
    else:
        if 节点A值 == 节点B值:
            return 是镜像
        else:
            return 不是镜像
```

对接下来的节点进行递归：

- A节点的左节点与B节点的右节点
- A节点的右节点与B节点的左节点

<!-- tabs:start -->

#### **Python**

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def isSymmetric(self, root):
        """
        :type root: TreeNode
        :rtype: bool
        """
        if root is None:
            return True
        else:
            return self.checkElement(root.left, root.right)

    def checkElement(self, left_root, right_root):
        if left_root is None or right_root is None:
            return left_root == right_root
        if left_root.val != right_root.val:
            return False
        return self.checkElement(left_root.left, right_root.right) and self.checkElement(left_root.right, right_root.left)
```

#### **Go**

```go
/**
 * Definition for a binary tree node.
 * type TreeNode struct {
 *     Val int
 *     Left *TreeNode
 *     Right *TreeNode
 * }
 */
func isSymmetric(root *TreeNode) bool {
    if root == nil {
        return true
    }
    return symmetric(root.Left, root.Right)
}

func symmetric(left *TreeNode, right *TreeNode) bool {
    if left == nil || right == nil {
        return left == right
    }
    if left.Val != right.Val {
        return false
    }
    return symmetric(left.Left, right.Right) && symmetric(left.Right, right.Left)
}
```

<!-- tabs:end -->

## 687. 最长同值路径

[原题链接](https://leetcode-cn.com/problems/longest-univalue-path/description/)

### 思路

树的路径问题，使用递归。

- 对左右节点调用递归函数，分别得到：
    - 左节点相同值路径
    - 右节点相同值路径
- 同值路径计算：
    - 左节点存在且与当前节点值相同，left++；不同：left=0
    - 右节点存在且与当前节点值相同，right++；不同：right=0
    - 结果 `result = max(result, left + right)`
    
### Python

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution(object):
    max_length = 0
    def longestUnivaluePath(self, root):
        """
        :type root: TreeNode
        :rtype: int
        """
        if not root:
            return 0
        self.getMaxLen(root, root.val)
        return self.max_length
        
    
    def getMaxLen(self, root, val):
        if not root:
            return 0
        
        left = self.getMaxLen(root.left, root.val)
        right = self.getMaxLen(root.right, root.val)
        
        if root.left and root.left.val == root.val:
            left = left + 1
        else:
            left = 0
        
        if root.right and root.right.val == root.val:
            right = right + 1
        else:
            right = 0
            
        self.max_length = max(self.max_length, left + right)
        
        # 选择较大路径值与 parent 相连
        return max(left, right)
```