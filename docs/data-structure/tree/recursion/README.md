## 100. 相同的树

[原题链接](https://leetcode-cn.com/problems/same-tree/submissions/)

### 思路

递归：

- 两个节点有一为 `None` 时：返回 `False`
- 两个节点都为 `None`：返回 `True`
- 两个节点都存在：
  - 值不同：返回 `False`
  - 值相同：返回 `True`

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def isSameTree(self, p: TreeNode, q: TreeNode) -> bool:
        if p is None and q is None:
            return True
        if p is None or q is None:
            return False

        if p.val != q.val:
            return False
            
        return self.isSameTree(p.left, q.left) and self.isSameTree(p.right, q.right)
```

- 时间复杂度：$O(n)$
- 空间复杂度：最优情况（完全平衡二叉树）为$O(log_n)$，最坏情况（完全不平衡二叉树）为$O(n)$

## 104. 二叉树的最大深度

- [原题链接](https://leetcode-cn.com/problems/maximum-depth-of-binary-tree/description/)
- [详解链接](https://juejin.im/post/5de254ce51882523467752d0)

### 自顶向下

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
    depth = 0
    def maxDepth(self, root: TreeNode) -> int:
        self.depth = 0
        self.handler(root, 1)
        return self.depth
        
    def handler(self, root, depth):
        if root is None:
            return
        self.depth = max(self.depth, depth)
        self.handler(root.left, depth + 1)
        self.handler(root.right, depth + 1)
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

var depth int
func maxDepth(root *TreeNode) int {
    depth = 0
    handler(root, 1)
    return depth
}

func handler(root *TreeNode, curDepth int) {
    if root == nil {
        return
    }
    if curDepth > depth {
        depth = curDepth
    }
    handler(root.Left, curDepth + 1)
    handler(root.Right, curDepth + 1)
}
```

<!-- tabs:end -->

### 自底向上

「自底向上」：我们首先对所有子节点递归地调用函数，然后根据返回值和根节点本身的值得到答案。

取左右子树最大深度值 + 1（1 为到 root 节点的深度）

<!-- tabs:start -->

#### **Python**

```python
class Solution(object):
    def maxDepth(self, root):
        """
        :type root: TreeNode
        :rtype: int
        """
        if root is None:
            return 0
        else:
            return max(self.maxDepth(root.left), self.maxDepth(root.right)) + 1
```

20210113 复盘：

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def maxDepth(self, root: TreeNode) -> int:
        if root is None:
            return 0
        left_depth = self.maxDepth(root.left) + 1
        right_depth = self.maxDepth(root.right) + 1
        return max(left_depth, right_depth)
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
func maxDepth(root *TreeNode) int {
    if root == nil {
        return 0
    }
    return max(maxDepth(root.Left), maxDepth(root.Right)) + 1
}

func max(a int, b int) int {
    if a > b {
        return a
    }
    return b
}
```

<!-- tabs:end -->


## 105. 从前序与中序遍历序列构造二叉树

[原题链接](https://leetcode-cn.com/problems/construct-binary-tree-from-preorder-and-inorder-traversal/)

### 思路

先来了解一下前序遍历和中序遍历是什么。

- 前序遍历：遍历顺序为 父节点->左子节点->右子节点
- 中序遍历：遍历顺序为 左子节点->父节点->右子节点

我们可以发现：**前序遍历的第一个元素为根节点，而在中序遍历中，该根节点所在位置的左侧为左子树，右侧为右子树。**

例如在例题中：

> 前序遍历 preorder = [3,9,20,15,7]
> 中序遍历 inorder = [9,3,15,20,7]

`preorder` 的第一个元素 3 是整棵树的根节点。`inorder` 中 3 的左侧 `[9]` 是树的左子树，右侧 `[15, 20, 7]` 构成了树的右子树。

所以构建二叉树的问题本质上就是：

1. 找到各个子树的根节点 `root`
2. 构建该根节点的左子树
3. 构建该根节点的右子树

整个过程我们可以用递归来完成。

<!-- tabs:start -->

#### **Python**

```python
# Definition for a binary tree node.
# class TreeNode(object):
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution(object):
    def buildTree(self, preorder, inorder):
        """
        :type preorder: List[int]
        :type inorder: List[int]
        :rtype: TreeNode
        """
        if len(inorder) == 0:
            return None
        # 前序遍历第一个值为根节点
        root = TreeNode(preorder[0])
        # 因为没有重复元素，所以可以直接根据值来查找根节点在中序遍历中的位置
        mid = inorder.index(preorder[0])
        # 构建左子树
        root.left = self.buildTree(preorder[1:mid+1], inorder[:mid])
        # 构建右子树
        root.right = self.buildTree(preorder[mid+1:], inorder[mid+1:])
        
        return root
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
func buildTree(preorder []int, inorder []int) *TreeNode {
    if len(preorder) == 0 {
        return nil
    }
    root := new(TreeNode)
    // 前序遍历第一个是根元素
    root.Val = preorder[0]
    // 找到位置
    rootIndex := findRootIndex(inorder, root.Val)
    // 构造左右子树
    root.Left = buildTree(preorder[1:1+rootIndex], inorder[:rootIndex])
    root.Right = buildTree(preorder[1+rootIndex:], inorder[rootIndex+1:])

    return root
}

func findRootIndex(inorder []int, rootVal int) int {
    for i, val := range inorder {
        if val == rootVal {
            return i
        }
    }
    return 0
}
```

<!-- tabs:end -->

## 106. 从中序与后序遍历序列构造二叉树

[原题链接](https://leetcode-cn.com/problems/construct-binary-tree-from-inorder-and-postorder-traversal/)

### 思路

和 [105. 从前序与中序遍历序列构造二叉树](https://leetcode-cn.com/problems/construct-binary-tree-from-preorder-and-inorder-traversal/) 这道题一样的思路。

先看一下什么是中序遍历和后序遍历：

- 中序遍历：左节点 -> 根节点 -> 右节点
- 后序遍历：左节点 -> 右节点 -> 根节点

我们可以得知：

- 在后序遍历中：最后一个节点为根节点
- 在中序遍历中：根节点左侧为该树的左子树，右侧为该树的右子树

例如在例题中：

> 中序遍历 inorder = [9,3,15,20,7]
> 后序遍历 postorder = [9,15,7,20,3]

后序遍历 `postorder` 最后一个节点 `3` 为该树的根节点，`inorder` 中 `3` 的左侧 `[9]` 是树的左子树，右侧 `[15, 20, 7]` 则是树的右子树。

所以可以把问题拆分为：

1. 找到树的根节点 `root`
2. 构建该根节点的左子树
3. 构建该根节点的右子树

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
    def buildTree(self, inorder: List[int], postorder: List[int]) -> TreeNode:
        
        if len(inorder) == 0:
            return None
        
        # 后序遍历最后一个节点为根节点
        root = TreeNode(postorder[-1])
        
        # 根节点在中序遍历中的位置
        index = inorder.index(postorder[-1])
        
        # 构造左子树
        root.left = self.buildTree(inorder[:index], postorder[:index])
        
        # 构造右子树
        root.right = self.buildTree(inorder[index+1:], postorder[index:len(postorder) - 1])
        
        return root
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
func buildTree(inorder []int, postorder []int) *TreeNode {
    postorderLength := len(postorder)
    if postorderLength == 0 {
        return nil
    }

    rootVal := postorder[postorderLength - 1]

    // 找出 root 在中序遍历中的位置
    index := findIndex(inorder, rootVal)
    root := new(TreeNode)
    root.Val = rootVal
    root.Left = buildTree(inorder[:index], postorder[:index])
    root.Right = buildTree(inorder[index + 1:], postorder[index:postorderLength - 1])

    return root
}

func findIndex(array []int, num int) int {
    for i, a := range array {
        if a == num {
            return i
        }
    }
    return 0
}
```

<!-- tabs:end -->

## 110. 平衡二叉树

[原题链接](https://leetcode-cn.com/problems/balanced-binary-tree/description/)

和 [104](/tree/104.md) 的套路一样，加上对比逻辑而已。

### 解一：自顶向下

对每个节点都计算它左右子树的高度，判断是否为平衡二叉树。

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def isBalanced(self, root: TreeNode) -> bool:
        if root is None:
            return True
        left_depth = self.helper(root.left, 0)
        right_depth = self.helper(root.right, 0)
        if abs(left_depth - right_depth) > 1:
            # 不平衡
            return False
        return self.isBalanced(root.left) and self.isBalanced(root.right)

    def helper(self, root, depth):
        """
        返回节点高度
        """
        if root is None:
            return depth
        left_depth = self.helper(root.left, depth + 1)
        right_depth = self.helper(root.right, depth + 1)
        return max(left_depth, right_depth)
```

- 时间复杂度：$O(nlogn)$。最差情况需要遍历树的所有节点，判断每个节点的最大高度又需要遍历该节点的所有子节点。如果树是倾斜的，则会到达 $O(n^2)$ 复杂度。详见[题解中的复杂度分析](https://leetcode-cn.com/problems/balanced-binary-tree/solution/ping-heng-er-cha-shu-by-leetcode/)。
- 空间复杂度：$O(n)$。如果树完全倾斜（退化成链），递归栈将包含所有节点。

### 解二：自底向上

自顶向下的高度计算存在大量冗余，每次计算高度时，同时都要计算子树的高度。

从底自顶返回二叉树高度，如果某子树不是平衡树，提前进行枝剪。

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
    res = True
    def isBalanced(self, root: TreeNode) -> bool:
        self.helper(root, 0)
        return self.res

    def helper(self, root, depth):
        if root is None:
            return depth
        left_depth = self.helper(root.left, depth + 1)
        right_depth = self.helper(root.right, depth + 1)
        if abs(left_depth - right_depth) > 1:
            self.res = False
            # 提前返回
            return 0 
        return max(left_depth, right_depth)
```

- 时间复杂度：$O(n)$。n 为树的节点数，最坏情况需要遍历所有节点。
- 空间复杂度：$O(n)$。完全不平衡时需要的栈空间。

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
var res bool

func isBalanced(root *TreeNode) bool {
    res = true
    helper(root, 0)
    return res
}

func helper(root *TreeNode, depth int) int {
    if root == nil {
        return depth
    }
    leftDepth := helper(root.Left, depth + 1)
    rightDepth := helper(root.Right, depth + 1)
    if leftDepth - rightDepth > 1 || leftDepth - rightDepth < -1 {
        res = false
        return 0
    }
    if leftDepth > rightDepth {
        return leftDepth
    } else {
        return rightDepth
    }
}
```

<!-- tabs:end -->


## 111. 二叉树的最小深度

[原题链接](https://leetcode-cn.com/problems/minimum-depth-of-binary-tree/description/)

### 思路

- 递归
- 深度优先 dfs

```python
class Solution(object):
    def minDepth(self, root):
        """
        :type root: TreeNode
        :rtype: int
        """
        if root is None:
            return 0
        if root.left is None and root.right is None:
            return 1
        
        if root.left is None:
            return self.minDepth(root.right) + 1
        elif root.right is None:
            return self.minDepth(root.left) + 1
        else:
            return min(self.minDepth(root.left), self.minDepth(root.right)) + 1
```

## 112. 路径总和

[原题链接](https://leetcode-cn.com/problems/path-sum/description/)

### 思路

- 递归
- True 的条件为：
    - 节点为叶子节点
    - 最终相加和为 sum
- False 的条件为：一直找到叶子节点了还是没有找到那个节点

<!-- tabs:start -->

#### **Python**

```python
class Solution(object):
    def hasPathSum(self, root, sum):
        """
        :type root: TreeNode
        :type sum: int
        :rtype: bool
        """
        if root is None:
            # 如果传入节点为空则直接返回 False
            return False
        if root.left is None and root.right is None and root.val == sum:
            return True
        return self.hasPathSum(root.left, sum - root.val) or self.hasPathSum(root.right, sum - root.val)
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
func hasPathSum(root *TreeNode, sum int) bool {
    if root == nil {
        return false
    }
    // 该节点为叶子节点
    if root.Left == nil && root.Right == nil {
        return sum == root.Val
    }
    // 递归
    return hasPathSum(root.Left, sum - root.Val) || hasPathSum(root.Right, sum - root.Val)
}
```

<!-- tabs:end -->

## 116. 填充每个节点的下一个右侧节点指针

[原题链接](https://leetcode-cn.com/problems/populating-next-right-pointers-in-each-node/)

### 解一：递归

- `root.left.next = root.right`
- 利用已经处理好的 `next` 指针：`root.right.next = root.next.left`

<!-- tabs:start -->

#### **Python**

```python
"""
# Definition for a Node.
class Node:
    def __init__(self, val: int = 0, left: 'Node' = None, right: 'Node' = None, next: 'Node' = None):
        self.val = val
        self.left = left
        self.right = right
        self.next = next
"""
class Solution:
    def connect(self, root: 'Node') -> 'Node':
        self.handler(root)
        return root

    def handler(self, root):
        if root is None or root.left is None:
            return None
        root.left.next = root.right
        if root.next is not None:
            root.right.next = root.next.left
        # 关联节点
        self.connect(root.left)
        # 关联右节点
        self.connect(root.right)
```

<!-- tabs:end -->

## 226. 翻转二叉树

[原题链接](https://leetcode-cn.com/problems/invert-binary-tree/description/)

### 思路

递归翻转呗~

```python
class Solution(object):
    def invertTree(self, root):
        """
        :type root: TreeNode
        :rtype: TreeNode
        """
        if root:
            self.invertTree(root.left)
            self.invertTree(root.right)
            l = root.left
            r = root.right
            root.right = l
            root.left = r
        return root
```

## 235. 二叉搜索树的最近公共祖先

[原题链接](https://leetcode-cn.com/problems/lowest-common-ancestor-of-a-binary-search-tree/)

### 解一：递归

分为几种情况：

1. `p` 与 `q` 分列 `root` 节点两个子树，则直接返回 `root`
2. `p` 与 `q` 其中之一等于 `root`，则直接返回 `root`
3. 如果 `p` 和 `q` 都在 `root` 左子树，则递归左子树
4. 如果 `p` 和 `q` 都在 `root` 右子树，则递归右子树

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
    def lowestCommonAncestor(self, root: 'TreeNode', p: 'TreeNode', q: 'TreeNode') -> 'TreeNode':
        if root is None:
            return root
        # 当前节点为 p 或 q
        if p.val == root.val or q.val == root.val:
            return root
        # 两个节点分别在左右两个子树
        if (p.val < root.val and q.val > root.val) or (p.val > root.val and q.val < root.val):
            return root
        # 两个节点都在左子树
        if p.val < root.val and q.val < root.val:
            return self.lowestCommonAncestor(root.left, p, q)
        # 两个节点都在右子树
        if p.val > root.val and q.val > root.val:
            return self.lowestCommonAncestor(root.right, p, q)
```

<!-- tabs:end -->

### 解二：迭代

@TODO

## 236. 二叉树的最近公共祖先

[原题链接](https://leetcode-cn.com/problems/lowest-common-ancestor-of-a-binary-tree/)（同 [面试题68 - II. 二叉树的最近公共祖先](https://leetcode-cn.com/problems/er-cha-shu-de-zui-jin-gong-gong-zu-xian-lcof/)）

### 递归法

因为找两个节点的公共祖先，所以从上往下递归遍历。

- 如果 `root` 等于 `q` 或 `p` 其中之一，则直接返回 `root`
- 接着查找 `root` 的左右子树
- 如果 `p` 与 `q` 不在左子树中，则必定在右子树中

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
    def lowestCommonAncestor(self, root: TreeNode, p: TreeNode, q: TreeNode) -> TreeNode:
        if root is None or root == p or root == q:
            return root
        
        # 在左子树找
        left = self.lowestCommonAncestor(root.left, p, q)
        # 在右子树找
        right = self.lowestCommonAncestor(root.right, p, q)

        if left is None and right is None:
            return None
        if left is None:
            return right
        if right is None:
            return left

        return root
```

#### **Go**

```go
/**
 * Definition for TreeNode.
 * type TreeNode struct {
 *     Val int
 *     Left *ListNode
 *     Right *ListNode
 * }
 */
 func lowestCommonAncestor(root, p, q *TreeNode) *TreeNode {
     if root == nil || root == p || root == q {
         return root
     }

     // 寻找左子树
     left := lowestCommonAncestor(root.Left, p, q)
     // 寻找右子树
     right := lowestCommonAncestor(root.Right, p, q)

     if left == nil && right == nil {
         return nil
     }
     if left == nil {
         return right
     }
     if right == nil {
         return left
     }
     
     return root
}
```

<!-- tabs:end -->

## 337. 打家劫舍 III

[原题链接](https://leetcode-cn.com/problems/house-robber-iii/description/)

求本节点+孙子更深节点 vs 儿子节点+重孙更深的节点的比较

### 解法一

- 递归
    - 终止条件：我们什么时候知道抢劫（根）的答案，而没有任何计算？当然，当树空了——我们没有什么可抢的，所以金额是零
    - 递归关系：即如何从rob(root.left)，rob(root.right)等等获取rob(root)。从树根的角度来看，最后只有两个场景：根被抢劫或没有被抢劫。如果是这样，由于“我们不能抢夺任何两个直接关联的房子”的限制，下一层可用的子树就是四个“孙子树”(root.left.left，root.left.right ，root.right.left，root.right.right)。但是，如果root不被抢劫，则下一级可用子树就是两个“子树”(root.left，root.right)。我们只需要选择产生更多金钱的场景
- 第一种：从根节点开始取值
- 第二种：从根节点的左右节点开始取值

超时了。。。

```python
class Solution(object):
    def rob(self, root):
        """
        :type root: TreeNode
        :rtype: int
        """
        if root is None:
            return 0
        val1 = root.val
        if root.left is not None:
            val1 = val1 + self.rob(root.left.left) + self.rob(root.left.right)
        if root.right is not None:
            val1 = val1 + self.rob(root.right.left) + self.rob(root.right.right)
        val2 = self.rob(root.left) + self.rob(root.right)
        return max(val1, val2)
```

### 解法二

- 用到了一个有两个元素的列表，分别保存了之前层的，不取节点和取节点的情况
- 然后遍历左右子树，求出当前节点取和不取能得到的值，再返回给上一层
- robcurr 是当前节点能达到的最大值，最终返回 root 节点 robcurr 的值

```python
class Solution(object):
    def rob(self, root):
        """
        :type root: TreeNode
        :rtype: int
        """
        def dfs(root):
            # from bottom to top
            if not root: return [0, 0] # before layer, no robcurr, robcurr
            robleft = dfs(root.left)
            robright = dfs(root.right)
            norobcurr = robleft[1] + robright[1]
            robcurr = max(root.val + robleft[0] + robright[0], norobcurr)
            return [norobcurr, robcurr]
        return dfs(root)[1]
```

## 404. 左叶子之和

[原题链接](https://leetcode-cn.com/problems/sum-of-left-leaves/description/)

### 思路

递归递归

```python
class Solution(object):
    def sumOfLeftLeaves(self, root):
        """
        :type root: TreeNode
        :rtype: int
        """
        if root is None:
            return 0
        if self.isLeaf(root.left):
            return root.left.val + self.sumOfLeftLeaves(root.right)
        else:
            return self.sumOfLeftLeaves(root.right) + self.sumOfLeftLeaves(root.left)
    
    def isLeaf(slef, tree_node):
        if tree_node is None:
            return False
        if tree_node.left is None and tree_node.right is None:
            return True
        else:
            return False
```

## 437. 路径总和 III

[原题链接](https://leetcode-cn.com/problems/path-sum-iii/description/)

### 思路

- `pathSumWithRoot` 计算以 root 为根节点存在的路径
- `pathSum` 遍历了整棵树

```python
class Solution(object):
    def pathSum(self, root, sum):
        """
        :type root: TreeNode
        :type sum: int
        :rtype: int
        """
        if root is None:
            return 0
        return self.pathSumWithRoot(root, sum) + self.pathSum(root.left, sum) + self.pathSum(root.right, sum)
        
    
    def pathSumWithRoot(self, root, sum):
        result = 0
        if root is None:
            return result
        if root.val == sum:
            result = result + 1
        result = result + self.pathSumWithRoot(root.left, sum - root.val) + self.pathSumWithRoot(root.right, sum - root.val)
        return result
```

## 450. 删除二叉搜索树中的节点

[原题链接](https://leetcode-cn.com/problems/delete-node-in-a-bst/)

### 思路

要删除的节点共有三种情况：

1. 是叶节点：直接删除
2. 有右子树：找它的后继节点交换（值）并删除后继节点
3. 有左子树：找到它的前驱节点交换（值）并删除前驱节点

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def deleteNode(self, root: TreeNode, key: int) -> TreeNode:
        # 找到节点
        if root is None:
            return None
        if key > root.val:
            # 找右子树
            root.right = self.deleteNode(root.right, key)
        elif key < root.val:
            # 找左子树
            root.left = self.deleteNode(root.left, key)
        else:
            # 找到节点
            if root.left is None and root.right is None:
                # 删除的节点是叶子节点
                root = None
            elif root.right is not None:
                # 有右子树，找后继节点
                root.val = self.successor(root)
                # 删除这个后继节点
                root.right = self.deleteNode(root.right, root.val)
            else:
                # 有左子树，找前驱节点
                root.val = self.predecessor(root)
                root.left = self.deleteNode(root.left, root.val)

        return root

    def successor(self, root):
        # 后继节点：比节点大的最小节点
        root = root.right
        while root.left is not None:
            root = root.left
        return root.val

    def predecessor(self, root):
        # 前驱节点
        root = root.left
        while root.right is not None:
            root = root.right
        return root.val
```

## 538. 把二叉搜索树转换为累加树

[原题链接](https://leetcode-cn.com/problems/convert-bst-to-greater-tree/)

### 思路

二叉搜索树有一个特性：它的中序遍历结果是递增序列。由此我们很容易知道，它的**反中序遍历**就是一个递减序列了。

题目要求「使得每个节点的值是原来的节点值加上所有大于它的节点值之和」，那么只要使用该树的反中序遍历，把先遍历到的节点值都加到当前节点上，即可得到一个「累加树」。

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:

    num = 0

    def convertBST(self, root: TreeNode) -> TreeNode:

        # 递归
        def recursion(root: TreeNode):
            if root is None:
                return
            recursion(root.right)
            root.val += self.num
            self.num = root.val
            recursion(root.left)
        
        recursion(root)
        return root
```

## 543. 二叉树的直径

[原题链接](https://leetcode-cn.com/problems/diameter-of-binary-tree/description/)

### 思路

和 [104](/tree/104.md) 的套路一样，加上取 max 逻辑而已。

<!-- tabs:start -->

#### **Python**

```python
class Solution(object):
    max_length = 0
    def diameterOfBinaryTree(self, root):
        """
        :type root: TreeNode
        :rtype: int
        """
        self.depth(root)
        return self.max_length
        
    def depth(self, root):
        if root is None:
            return 0
        else:
            l = self.depth(root.left)
            r = self.depth(root.right)
            cur_length = l + r
            if cur_length > self.max_length:
                self.max_length = cur_length
            return max(l, r) + 1
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
var res int

func diameterOfBinaryTree(root *TreeNode) int {
    helper(root)
    return res
}

func helper(root *TreeNode) int {
    if root == nil {
        return 0
    }
    leftDepth := helper(root.Left)
    rightDepth := helper(root.Right)
    length := leftDepth + rightDepth
    res = getMax(res, length)
    return getMax(leftDepth, rightDepth) + 1
}

func getMax(a int, b int) int {
    if a > b {
        return a
    }
    return b
}
```

<!-- tabs:end -->

## 572. 另一个树的子树

[原题链接](https://leetcode-cn.com/problems/subtree-of-another-tree/description/)

### 思路

与 [437](/tree/437.md) 递归思路类似。

`t` 是否为 `s` 的子树，存在三种情况：

- `t` 与 `s` 相同
- `t` 是 `s` 的左子树
- `t` 是 `s` 的右子树

```python
class Solution(object):
    def isSubtree(self, s, t):
        """
        :type s: TreeNode
        :type t: TreeNode
        :rtype: bool
        """
        if s is None:
            return False
        return self.isSubtreeWithRoot(s, t) or self.isSubtree(s.left, t) or self.isSubtree(s.right, t)
        
    def isSubtreeWithRoot(self, s, t):
        """
        t 与 s 是否相同
        """
        if s is None and t is None:
            return True
        if s is None or t is None:
            return False
        if s.val != t.val:
            return False
        return self.isSubtreeWithRoot(s.left, t.left) and self.isSubtreeWithRoot(s.right, t.right)
```

```go
/**
 * Definition for a binary tree node.
 * type TreeNode struct {
 *     Val int
 *     Left *TreeNode
 *     Right *TreeNode
 * }
 */
func isSubtree(s *TreeNode, t *TreeNode) bool {
    if s == nil {
        return false
    }
    return isSubtree(s.Left, t) || isSubtree(s.Right, t) || isSubtreeWithRoot(s, t)
}

func isSubtreeWithRoot(s *TreeNode, t *TreeNode) bool {
    if s == nil && t == nil {
        return true
    }
    if s == nil || t == nil {
        return false
    }
    if s.Val != t.Val {
        return false
    }
    return isSubtreeWithRoot(s.Left, t.Left) && isSubtreeWithRoot(s.Right, t.Right)
}
```

## 617. 合并二叉树

[原题链接](https://leetcode-cn.com/problems/merge-two-binary-trees/description/)

### 思路

递归合并，代码写的跟 shi 一样。。。

```python
class Solution(object):
    def mergeTrees(self, t1, t2):
        """
        :type t1: TreeNode
        :type t2: TreeNode
        :rtype: TreeNode
        """
        if t1 is None and t2 is None:
            return None
        
        if t1:
            n1 = t1.val
        else:
            n1 = 0
        
        if t2:
            n2 = t2.val
        else:
            n2 = 0
        
        new_root = TreeNode(n1 + n2)
        first = new_root
        self.mergeNode(t1, t2, new_root)
        return first
        
    def mergeNode(self, t1, t2, new_root):
        
        if t1 is None and t2 is None:
            return
        
        # left
        n1 = 0
        n2 = 0
        if t1:
            t1_left = t1.left
            if t1_left:
                n1 = t1_left.val
        else:
            t1_left = None
        if t2:
            t2_left = t2.left
            if t2_left:
                n2 = t2.left.val
        else:
            t2_left = None
        if t1_left is None and t2_left is None:
            new_root.left = None
        else:
            n = n1 + n2
            new_root.left = TreeNode(n)
        
        n1 = 0
        n2 = 0
        if t1:
            t1_right = t1.right
            if t1_right:
                n1 = t1_right.val
        else:
            t1_right = None
        if t2:
            t2_right = t2.right
            if t2_right:
                n2 = t2.right.val
        else:
            t2_right = None
        if t1_right is None and t2_right is None:
            new_root.right = None
        else:
            n = n1 + n2
            new_root.right = TreeNode(n)
        
        if new_root.left:
            self.mergeNode(t1_left, t2_left, new_root.left)
        if new_root.right:
            self.mergeNode(t1_right, t2_right, new_root.right)
```

## 671. 二叉树中第二小的节点

[原题链接](https://leetcode-cn.com/problems/second-minimum-node-in-a-binary-tree/description/)
 
### 思路

递归找第二小节点

- 如果和父节点值一样大，继续往下找
- 左右子树取最小值返回

```python
class Solution(object):
    def findSecondMinimumValue(self, root):
        """
        :type root: TreeNode
        :rtype: int
        """
        if root is None:
            return -1
        if root.left is None and root.right is None:
            return -1
        l_val = root.left.val
        r_val = root.right.val
        if l_val == root.val:
            l_val = self.findSecondMinimumValue(root.left)
        if r_val == root.val:
            r_val = self.findSecondMinimumValue(root.right)
        if l_val != -1 and r_val != -1:
            return min(l_val, r_val)
        elif l_val == -1:
            return r_val
        else:
            return l_val
```

## 700. 二叉搜索树中的搜索

[原题链接](https://leetcode-cn.com/problems/search-in-a-binary-search-tree/)

### 递归

递归设计：

- 递归函数作用：返回目标节点
- 函数返回时机：
  - 节点为空
  - 找到目标节点
- 递归调用时机：搜索左子树或右子树时

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
    def searchBST(self, root: TreeNode, val: int) -> TreeNode:
        if root is None:
            return None
        root_val = root.val
        if root_val == val:
            return root
        if val < root.val:
            return self.searchBST(root.left, val)
        if val > root.val:
            return self.searchBST(root.right, val)
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
func searchBST(root *TreeNode, val int) *TreeNode {
    if root == nil {
        return nil
    }
    rootVal := root.Val
    if rootVal == val {
        return root
    } else if rootVal < val {
        return searchBST(root.Right, val)
    } else {
        return searchBST(root.Left, val)
    }
}
```

<!-- tabs:end -->

## 783. 二叉搜索树结点最小距离

[原题链接](https://leetcode-cn.com/problems/minimum-distance-between-bst-nodes/)

### 解一

感觉我这个想法可能比较奇怪。

要找「任意两节点的差的最小值」，即需要找每个节点和其他某节点的能达到的最小差值。

又因为这是一个二叉搜索树，所以对于节点 `root` 来说，和它值最接近的某节点 `node` 应该来自于：

1. `root` 左子树的最右子结点
2. `root` 右子树的最左子结点

通过递归来解决这个问题。

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    val = float('inf')
    
    def minDiffInBST(self, root: TreeNode) -> int:
        
        def dfs(root):
            if root is None:
                return
            
            #print(root.val)
            
            # 左子树的最右子节点，右子树的最左子节点
            if root.left is not None:
                tmp = root.left
                while tmp.right is not None:
                    tmp = tmp.right
                left = root.val - tmp.val
                self.val = min(self.val, left)
            
            if root.right is not None:
                tmp = root.right
                while tmp.left is not None:
                    tmp = tmp.left
                right = tmp.val - root.val
                self.val = min(self.val, right)
            
            dfs(root.left)
            dfs(root.right)
                
        dfs(root)
        return self.val
```

### 解二

二叉搜索树的重要特性：**中序遍历结果为升序排列**。

利用该特性先生成一个有序排列，之后计算差值。

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def minDiffInBST(self, root: TreeNode) -> int:
        
        def dfs(arr, root):
            if root is None:
                return
            dfs(arr, root.left)
            arr.append(root.val)
            dfs(arr, root.right)
            
        arr = []
        dfs(arr, root)
        res = float('inf')
        for i in range(1, len(arr)):
            diff = arr[i] - arr[i - 1]
            res = min(res, diff)
            
        return res
```

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

## 894. 所有可能的满二叉树

[原题链接](https://leetcode-cn.com/problems/all-possible-full-binary-trees/)

### 思路

如果你要构造一颗有 N 个节点的二叉树，你会怎么做？

首先，你肯定会先 new 一个根结点~~对象~~ `root`，然后为它构造左子树，再为它构造右子树。

那么对它的左子树 `root.left` 而言，它同样需要构造左子树和右子树。右子树 `root.right` 亦然。

因此，**你的所有子树都是一棵满二叉树**。

「给你一个整数 `N`，构造出一棵包含 `N` 个节点的满二叉树」。**这句话是题目本身，也是无数个被拆分出的子问题。**

### 满二叉树如何构造？

> 满二叉树是一类二叉树，其中每个结点恰好有 0 或 2 个子结点。

如果你要为某节点分配一个左节点，那么一定也要为它分配一个右节点。因此，如果 `N` 为偶数，那一定无法构成一棵满二叉树。

为了列出所有满二叉树的排列，我们可以为左子树分配 `x` 节点，为右子树分配 `N - 1 - x`（其中减 1 减去的是根节点）节点，然后**递归**地构造左右子树。

`x` 的数目从 1 开始，每次循环递增数目 2（多增加 2 个节点，等于多增加 1 层）。

### 递归过程

递归最关心的两个问题是：

1. 结束条件
2. 自身调用

对于这个问题来说，结束条件为：

1. 当 `N` 为偶数时：无法构造满二叉树，返回空数组
2. 当 `N == 1` 时：树只有一个节点，直接返回包含这个节点的数组
3. 当完成 `N` 个节点满二叉树构造时：返回结果数组

当需要构造左右子树时，就进行自身调用。具体的看代码吧~

### 实现

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    # 子问题：构造一棵满二叉树
    def allPossibleFBT(self, N: int) -> List[TreeNode]:
        res = []
        if N == 1:
            return [TreeNode(0)]
        # 结点个数必须是奇数
        if N % 2 == 0:
            return []
        
        # 左子树分配一个节点
        left_num = 1
        # 右子树可以分配到 N - 1 - 1 = N - 2 个节点
        right_num = N - 2
        
        while right_num > 0:
            # 递归构造左子树
            left_tree = self.allPossibleFBT(left_num)
            # 递归构造右子树
            right_tree = self.allPossibleFBT(right_num)
            # 具体构造过程
            for i in range(len(left_tree)):
                for j in range(len(right_tree)):
                    root = TreeNode(0)
                    root.left = left_tree[i]
                    root.right = right_tree[j]
                    res.append(root)
            left_num += 2
            right_num -= 2
        
        return res     
```