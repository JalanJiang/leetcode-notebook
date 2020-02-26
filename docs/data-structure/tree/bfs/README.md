## 102. 二叉树的层次遍历

[原题链接](https://leetcode-cn.com/problems/binary-tree-level-order-traversal/)

### 思路

借助队列实现：

- 初始化队列 `q`，把根节点 `root` 塞进去
- 当 `q` 不为空时，遍历队列，依次取出队列中的节点：
    - 若该节点的左节点不为空：左节点入队列
    - 若该节点的右节点不为空：右节点入队列

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
    def levelOrder(self, root: TreeNode) -> List[List[int]]:
        queue = []
        queue.append(root)
        res = []
        while len(queue) > 0:
            length = len(queue)
            tmp = []
            for i in range(length):
                node = queue[0]
                del queue[0]
                if node is None:
                    continue
                tmp.append(node.val)
                queue.append(node.left)
                queue.append(node.right)
            if len(tmp) > 0:
                res.append(tmp)
        return res 
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
func levelOrder(root *TreeNode) [][]int {
    queue := make([]*TreeNode, 0)
    queue = append(queue, root)
    res := make([][]int, 0)
    for len(queue) > 0 {
        tmp := make([]int, 0)
        length := len(queue)
        for i := 0; i < length; i++ {
            q := queue[0]
            queue = queue[1:]
            if q == nil {
                continue
            }
            tmp = append(tmp, q.Val)
            queue = append(queue, q.Left)
            queue = append(queue, q.Right)
        }
        if len(tmp) > 0 {
            res = append(res, tmp)
        }
    }
    return res
}
```

<!-- tabs:end -->

## 108. 将有序数组转换为二叉搜索树
   
[原题链接](https://leetcode-cn.com/problems/convert-sorted-array-to-binary-search-tree/submissions/)

### 思路

二叉树中序遍历的逆过程。二分+递归解法。

左右等分建立左右子树，中间节点作为子树根节点，递归该过程。

```python
# Definition for a binary tree node.
# class TreeNode(object):
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution(object):
    def sortedArrayToBST(self, nums):
        """
        :type nums: List[int]
        :rtype: TreeNode
        """
        if not nums:
            return None
        else:
            mid  = (len(nums)) // 2
            node = TreeNode(nums[mid])
            
            left  = nums[0:mid]
            right = nums[mid+1:len(nums)]
            
            node.left  = self.sortedArrayToBST(left)
            node.right = self.sortedArrayToBST(right)
            
        return node
```

## 117. 填充每个节点的下一个右侧节点指针 II

[原题链接](https://leetcode-cn.com/problems/populating-next-right-pointers-in-each-node-ii/)

### 思路

层次遍历的变种考点。

```python
"""
# Definition for a Node.
class Node(object):
    def __init__(self, val, left, right, next):
        self.val = val
        self.left = left
        self.right = right
        self.next = next
"""
class Solution(object):
    def connect(self, root):
        """
        :type root: Node
        :rtype: Node
        """
        if root is None:
            return root
        
        q = list()
        q.append(root)
        
        while len(q) > 0:
            q_length = len(q)
            
            for i in range(q_length):
                node = q[0]
                del q[0]
                
                if i + 1 < q_length:
                    node.next = q[0]
                
                if node.left is not None:
                    q.append(node.left)
                    
                if node.right is not None:
                    q.append(node.right)
                
        return root
```

## 513. 找树左下角的值

[原题链接](https://leetcode-cn.com/problems/find-bottom-left-tree-value/comments/)

### 思路

- 层次遍历
- 队列存储，右子节点先入队列，左子节点再入队列。

```python
from collections import deque

class Solution(object):
    def findBottomLeftValue(self, root):
        """
        :type root: TreeNode
        :rtype: int
        """
        q = deque([root])
        while q:
            node = q.popleft()
            if node.right:
                q.append(node.right)
            if node.left:
                q.append(node.left)
        return node.val
```

## 637. 二叉树的层平均值

[原题链接](https://leetcode-cn.com/problems/average-of-levels-in-binary-tree/description/)

### 思路

BFS

- 往队列中 push 根节点
- 当队列不为空的时候，遍历整个队列
- 每遍历队列中的一个节点，就取出它的值并将其 pop。此时顺带检查它的左右子节点是否为空
    - 如果不为空，就将其子节点push进入队列中
- 这样，刚好遍历完一层节点，下一层的节点就全部存到队列中了。一层层循环下去直到最后一层，问题便顺利得到了解决

```python
from collections import deque

class Solution:
    def averageOfLevels(self, root):
        """
        :type root: TreeNode
        :rtype: List[float]
        """
        res = []
        q = deque([root])
        while q:
            curr_sum = 0
            node_num_this_layer = len(q)
            for i in range(0, node_num_this_layer):
                node = q.popleft();
                curr_sum += node.val
                if node.left:
                    q.append(node.left)
                if node.right:
                    q.append(node.right)
            res.append(1.0*curr_sum/node_num_this_layer)
        return res
```