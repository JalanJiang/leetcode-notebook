## 94. 二叉树的中序遍历

[原题链接](https://leetcode-cn.com/problems/binary-tree-inorder-traversal/submissions/)

### 解法一

- 递归

```
void dfs(TreeNode root) {
    dfs(root.left);
    visit(root);
    dfs(root.right);
}
```

```python
class Solution(object):
    def inorderTraversal(self, root):
        """
        :type root: TreeNode
        :rtype: List[int]
        """
        l = []
        self.visitNode(root, l)
        return l
        
    def visitNode(self, root, l):
        if root is None:
            return
        self.visitNode(root.left, l)
        l.append(root.val)
        self.visitNode(root.right, l)
```

### 解法二

非递归法。

- 寻找当前节点的左节点，依次入栈

```python
class Solution(object):
    def inorderTraversal(self, root):
        """
        :type root: TreeNode
        :rtype: List[int]
        """
        stack = []
        cur = root
        res = []
        while stack or cur:
            while cur:
                stack.append(cur)
                cur = cur.left
            node = stack.pop()
            res.append(node.val)
            cur = node.right
        return res
```


## 98. 验证二叉搜索树

[原题链接](https://leetcode-cn.com/problems/validate-binary-search-tree/submissions/)

### 思路

中序遍历为升序

```python
# Definition for a binary tree node.
# class TreeNode(object):
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution(object):
    def isValidBST(self, root):
        """
        :type root: TreeNode
        :rtype: bool
        """
        res = []
        self.middleOrder(res, root)
        
        for i in range(1, len(res)):
            if res[i - 1] >= res[i]:
                return False
        return True
    
    def middleOrder(self, res, root):
        if root is not None:
            self.middleOrder(res, root.left)
            res.append(root.val)
            self.middleOrder(res, root.right)
        else:
            return
```

## 105. 从前序与中序遍历序列构造二叉树

[原题链接](https://leetcode-cn.com/problems/construct-binary-tree-from-preorder-and-inorder-traversal/)

### 思路

先来了解一下前序遍历和中序遍历是什么。

- 前序遍历：遍历顺序为 父节点->左子节点->右子节点
- 后续遍历：遍历顺序为 左子节点->父节点->右子节点

我们可以发现：**前序遍历的第一个元素为根节点，而在后序遍历中，该根节点所在位置的左侧为左子树，右侧为右子树。**

例如在例题中：

> 前序遍历 preorder = [3,9,20,15,7]
> 中序遍历 inorder = [9,3,15,20,7]

`preorder` 的第一个元素 3 是整棵树的根节点。`inorder` 中 3 的左侧 `[9]` 是树的左子树，右侧 `[15, 20, 7]` 构成了树的右子树。

所以构建二叉树的问题本质上就是：

1. 找到各个子树的根节点 `root`
2. 构建该根节点的左子树
3. 构建该根节点的右子树

整个过程我们可以用递归来完成。

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

## 144. 二叉树的前序遍历

[原题链接](https://leetcode-cn.com/problems/binary-tree-preorder-traversal/submissions/)

### 解法一

递归法

```python
class Solution(object):
    def preorderTraversal(self, root):
        """
        :type root: TreeNode
        :rtype: List[int]
        """
        l = []
        self.visitNode(root, l)
        return l
        
    def visitNode(self, root, l):
        if root is None:
            return
        l.append(root.val)
        self.visitNode(root.left, l)
        self.visitNode(root.right, l)
```

### 解法二

非递归，使用 list 模拟栈。

```python
class Solution(object):
    def preorderTraversal(self, root):
        """
        :type root: TreeNode
        :rtype: List[int]
        """
        stack = []
        stack.append(root)
        res = []
        while stack:
            node = stack.pop()
            if node is None:
                continue
            res.append(node.val)
            if node.right:
                stack.append(node.right)
            if node.left:
                stack.append(node.left)
        return res
```

## 145. 二叉树的后序遍历

[原题链接](https://leetcode-cn.com/problems/binary-tree-postorder-traversal/)

### 解法一

- 递归

后序遍历：

```
void dfs(TreeNode root) {
    dfs(root.left);
    dfs(root.right);
    visit(root);
}
```

```python
class Solution(object):
    def postorderTraversal(self, root):
        """
        :type root: TreeNode
        :rtype: List[int]
        """
        l = []
        self.visitRoot(root, l)
        return l
    
    def visitRoot(self, root, l):
        if root is None:
            return
        self.visitRoot(root.left, l)
        self.visitRoot(root.right, l)
        l.append(root.val)
```

### 解法二

- 后序遍历顺序为 left->right->root，反序后为：root->right->left
- 用栈实现 root->right->left 的顺序，再将列表反序

```python
class Solution(object):
    def postorderTraversal(self, root):
        """
        :type root: TreeNode
        :rtype: List[int]
        """
        stack = []
        stack.append(root)
        res = []
        while stack:
            node = stack.pop()
            if node is None:
                continue
            stack.append(node.left)
            stack.append(node.right)
            res.append(node.val)
        res.reverse()
        return res
```

## 230. 二叉搜索树中第K小的元素

[原题链接](https://leetcode-cn.com/problems/kth-smallest-element-in-a-bst/)

### 思路

二叉搜索树的中序遍历是递增序列

```python
# Definition for a binary tree node.
# class TreeNode(object):
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution(object):
    def kthSmallest(self, root, k):
        """
        :type root: TreeNode
        :type k: int
        :rtype: int
        """
        res = []
        self.visitNode(root, res)
        return res[k - 1]
    
    def visitNode(self, root, res):
        if root is None:
            return
        self.visitNode(root.left, res)
        res.append(root.val)
        self.visitNode(root.right, res)
```