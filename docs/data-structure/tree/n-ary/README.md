## 429. N叉树的层序遍历

[原题链接](https://leetcode-cn.com/problems/n-ary-tree-level-order-traversal/)

### 解一：迭代

用队列辅助。

```python
"""
# Definition for a Node.
class Node:
    def __init__(self, val=None, children=None):
        self.val = val
        self.children = children
"""
class Solution:
    def levelOrder(self, root: 'Node') -> List[List[int]]:
        queue = []
        res = []
        queue.append(root)
        while len(queue) > 0:
            q_length = len(queue)
            tmp = []
            for i in range(q_length):
                first = queue[0]
                del queue[0]
                if first is None:
                    continue
                tmp.append(first.val)
                for child in first.children:
                    queue.append(child)
            if len(tmp) > 0:
                res.append(tmp)
        return res
```

- 时间复杂度：$O(n)$，n 为节点数量
- 空间复杂度：$O(n)$

### 解二：递归

```python
"""
# Definition for a Node.
class Node:
    def __init__(self, val=None, children=None):
        self.val = val
        self.children = children
"""
class Solution:
    def levelOrder(self, root: 'Node') -> List[List[int]]:
        res = []
        self.helper(res, root, 0)
        return res
    
    def helper(self, res, root, level):
        if root is None:
            return
        if len(res) == level:
            res.append([])
        res[level].append(root.val)
        for child in root.children:
            self.helper(res, child, level + 1)
```

- 时间复杂度：$O(n)$
- 空间复杂度：最坏 $O(n)$，最好 $O(logn)$

## 589. N叉树的前序遍历

[原题链接](https://leetcode-cn.com/problems/n-ary-tree-preorder-traversal/)

### 解一：递归

```python
"""
# Definition for a Node.
class Node:
    def __init__(self, val=None, children=None):
        self.val = val
        self.children = children
"""
class Solution:
    def preorder(self, root: 'Node') -> List[int]:
        res = []
        self.helper(root, res)
        return res

    def helper(self, root, res):
        if root is None:
            return
        res.append(root.val)
        children = root.children
        for child in children:
            self.helper(child, res)
```

### 解二：遍历

用栈辅助。

1. 首先，将 `root` 压入栈中
2. 在栈不为空时，对栈进行遍历，每次弹出栈顶元素
3. 若栈顶元素节点不为空，则将该节点值放入结果集中，且将该节点的子节点**从右至左**压入栈中（这样弹出时就是从左至右，符合前序遍历的顺序）

```python
"""
# Definition for a Node.
class Node:
    def __init__(self, val=None, children=None):
        self.val = val
        self.children = children
"""
class Solution:
    def preorder(self, root: 'Node') -> List[int]:
        stack = []
        stack.append(root)
        res = []
        while len(stack) > 0:
            top = stack.pop()
            if top is None:
                continue
            res.append(top.val)
            # 反序插入子节点
            children = top.children
            for i in range(len(children) - 1, -1, -1):
                child = children[i]
                stack.append(child)
        return res
```

## 590. N叉树的后序遍历

[原题链接](https://leetcode-cn.com/problems/n-ary-tree-postorder-traversal/)

### 解一：递归

```python
"""
# Definition for a Node.
class Node:
    def __init__(self, val=None, children=None):
        self.val = val
        self.children = children
"""
class Solution:
    def postorder(self, root: 'Node') -> List[int]:
        res = []
        self.healper(root, res)
        return res

    def healper(self, root, res):
        if root is None:
            return
        children = root.children
        for child in children:
            self.healper(child, res)
        res.append(root.val)
```

### 解二：迭代

用一个辅助栈。

后序遍历的顺序是：子节点从左至右 -> 根节点。因此我们可以先把「根节点 -> 子节点从右至左」写入结果集中，在返回时再将结果集反序。

```python
"""
# Definition for a Node.
class Node:
    def __init__(self, val=None, children=None):
        self.val = val
        self.children = children
"""
class Solution:
    def postorder(self, root: 'Node') -> List[int]:
        res = []
        stack = []
        stack.append(root)
        while len(stack):
            top = stack.pop()
            if top is None:
                continue
            res.append(top.val)
            for child in top.children:
                stack.append(child)
        return res[::-1]
```