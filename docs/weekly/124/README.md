# 第 124 场周赛

点击前往：[第 124 场周赛](https://leetcode-cn.com/contest/weekly-contest-124)

## 993. 二叉树的堂兄弟节点

[原题链接](https://leetcode-cn.com/contest/weekly-contest-124/problems/cousins-in-binary-tree/)

### 解法一

- 递归求出对应节点的深度
- 递归判断两个节点是否属于同个父节点

```python
# Definition for a binary tree node.
# class TreeNode(object):
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution(object):
    def isCousins(self, root, x, y):
        """
        :type root: TreeNode
        :type x: int
        :type y: int
        :rtype: bool
        """
        # get depth
        x_depth = self.getDepth(root, x, 0)
        y_depth = self.getDepth(root, y, 0)
        
        #print x_depth
        #print y_depth
        
        if x_depth != y_depth or x_depth == 0 or y_depth == 0:
            return False
        
        # get parent
        parent = self.isParent(root, x, y)
        print(parent)
        if parent == False:
            return True
        else:
            return False
        
    
    def getDepth(self, root, target, depth):
        if root is None:
            return 0
        else:
            #print root.val
            if root.val == target:
                return depth
            else:
                return max(self.getDepth(root.left, target, depth + 1), self.getDepth(root.right, target, depth + 1))
            
    def isParent(self, root, x, y):
        if root is None:
            return False
        else:
            if root.left is not None and root.right is not None:
                if (root.left.val == x and root.right.val == y) or (root.left.val == y and root.right.val == x):
                    return True
                else:
                    return self.isParent(root.left, x, y) or self.isParent(root.right, x, y)
            else:
                return self.isParent(root.left, x, y) or self.isParent(root.right, x, y)
```

### 解法二

参照：[从上往下打印二叉树](/offer/tree-bfs.html)

借助队列，一层一层遍历。

```python
# Definition for a binary tree node.
# class TreeNode(object):
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution(object):
    def isCousins(self, root, x, y):
        """
        :type root: TreeNode
        :type x: int
        :type y: int
        :rtype: bool
        """
        def find(x):
            q=collections.deque()
            q.append((root, None, 0))
            while q:
                node, p, d = q.popleft()
                if node.val == x:
                    return p, d
                else:
                    if node.left is not None:
                        q.append((node.left, node, d+1))
                    if node.right is not None:
                        q.append((node.right, node, d+1))
        px, dx = find(x)
        py, dy = find(y)
        return dx == dy and px != py
```

## 994. 腐烂的橘子

[原题链接](https://leetcode-cn.com/contest/weekly-contest-124/problems/rotting-oranges/)

### 思路

基本思路：从 `1` 出发搜索，返回找到 `2` 需要走的步数（即分钟数），求得该步数的最大值。

解决方法借助**队列**，如果走到的下一个点还是 `1` 则入队列，作为下次搜索的起点。

```python
class Solution(object):
    minute = 0
    def orangesRotting(self, grid):
        """
        :type grid: List[List[int]]
        :rtype: int
        """
        row = len(grid)
        col = len(grid[0])
        
        ans = 0
        for i in range(row):
            for j in range(col):
                if grid[i][j] == 1:
                    ans = max(ans, self.bfs(i, j, grid))
        
        if ans < float('inf'):
            return ans
        
        return -1
        

    def bfs(self, x, y, grid):
        row = len(grid)
        col = len(grid[0])
        
        ds = ((0, 1), (0, -1), (1, 0), (-1, 0))
        q = list()
        visit = [[0] * col for _ in range(row)]
        q.append((x, y, 0))
        
        while q:
            i, j, s = q[0]
            del q[0]
            if visit[i][j] == 1:
                continue
            visit[i][j] = 1
            for di, dj in ds:
                ni, nj = i + di, j + dj
                if 0 <= ni < row and 0 <= nj < col:
                    if grid[ni][nj] == 1:
                        q.append((ni, nj, s + 1))
                    if grid[ni][nj] == 2:
                        return s + 1
        return float('inf')
```