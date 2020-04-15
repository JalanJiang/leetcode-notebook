## 200. 岛屿数量

[原题链接](https://leetcode-cn.com/problems/number-of-islands/)

### 思路

广度优先搜索 BFS。总结一下思想就是：一旦发现岛屿就找到与它相邻的岛屿并将它们沉没，那么下次再发现的岛屿就是新大陆了。

具体思路如下：

1. 初始化一个队列，用于放置**已经找到却还没有进行广度优先遍历**的岛屿
2. 遍历二维数组，如果发现岛屿（即发现 "1"），
   1. 陆地数量+1
   2. 将岛屿加入队列
   3. 将岛屿沉没（"1" -> "0"），防止后续重复计算
   4. 使用广度优先遍历，查找该岛屿的四个相邻位置上是否还有岛屿，如果发现了岛屿就把它加入队列并且沉没

```python
class Solution(object):
    def numIslands(self, grid):
        """
        :type grid: List[List[str]]
        :rtype: int
        """
        m = len(grid)
        if m == 0:
            return 0
        n = len(grid[0])
        # 初始化一个队列
        q = list()
        res = 0
        # 定义岛屿的四个相邻位置
        area = [(0, -1), (-1, 0), (0, 1), (1, 0)]

        for i in range(m):
            for j in range(n):
                cur = grid[i][j]
                # 遍历过程中发现了岛屿
                if cur == '1':
                    # 陆地数量+1
                    res += 1
                    # 入队列
                    q.append((i, j))
                    # 将岛屿沉没
                    grid[i][j] = '0'
                    
                # 如果队列不为空，就循环队列，将队列里已经存在的岛屿进行 BFS
                while len(q) > 0:
                    # 取出岛屿坐标
                    node_x, node_y = q[0]
                    del q[0]
                    # 判断岛屿的四个相邻位置是否还存在岛屿
                    for k in range(len(area)):
                        area_x, area_y = area[k]
                        node_area_x, node_area_y = node_x + area_x, node_y + area_y
                        if (node_area_x >= 0 and node_area_x < m) and (node_area_y >= 0 and node_area_y < n):
                            if grid[node_area_x][node_area_y] == '1':
                                # 相邻位置存在岛屿：入队列、把岛屿沉没
                                q.append((node_area_x, node_area_y))
                                grid[node_area_x][node_area_y] = '0'
                    
        return res
```

## 542. 01 矩阵

[原题链接](https://leetcode-cn.com/problems/01-matrix/)

### BFS：以 1 为源（超时）

```python
class Solution:
    def updateMatrix(self, matrix: List[List[int]]) -> List[List[int]]:
        m = len(matrix)
        if m == 0:
            return []
        n = len(matrix[0])

        ans = [[0 for _ in range(n)] for _ in range(m)]

        for i in range(m):
            for j in range(n):
                if matrix[i][j] == 0:
                    # 0 不处理
                    continue
                mark = [[0 for _ in range(n)] for _ in range(m)]
                step = 0
                queue = [(i, j, step)]
                while len(queue) > 0:
                    # bfs
                    x, y, s = queue[0][0], queue[0][1], queue[0][2]
                    del queue[0]
                    if mark[x][y]:
                        # 已经访问过，跳过
                        continue
                    # 处理
                    mark[x][y] = 1 # 访问标记
                    if matrix[x][y] == 0:
                        # 找到 0，进行标记，不继续遍历
                        ans[i][j] = s
                        break
                    
                    # 否则加入上下左右
                    directions = [[0, 1], [0, -1], [-1, 0], [1, 0]]
                    for d in directions:
                        n_x, n_y = x + d[0], y + d[1]
                        if n_x >= 0 and n_x < m and n_y >= 0 and n_y < n and mark[n_x][n_y] == 0:
                            # 坐标符合要求
                            # print(n_x, n_y, s + 1)
                            queue.append((n_x, n_y, s + 1))
        
        return ans
```

### BFS：以 0 为源

把所有 0 放入队列，每个 0 逐个向外 BFS 一圈标记相邻的 1，再把 BFS 到的 1 入队列……

```python
class Solution:
    def updateMatrix(self, matrix: List[List[int]]) -> List[List[int]]:
        m = len(matrix)
        if m == 0:
            return []
        n = len(matrix[0])

        queue = []

        for i in range(m):
            for j in range(n):
                # 把 0 放入队列
                if matrix[i][j] == 0:
                    queue.append((i, j))
                else:
                    # 把 1 标记为未访问过的结点
                    matrix[i][j] = -1
        directions = [[0, 1], [0, -1], [1, 0], [-1, 0]]
        while len(queue) > 0:
            x, y = queue[0][0], queue[0][1]
            del queue[0]
            for d in directions:
                n_x, n_y = x + d[0], y + d[1]
                if n_x >= 0 and n_x < m and n_y >= 0 and n_y < n and matrix[n_x][n_y] == -1:
                    matrix[n_x][n_y] = matrix[x][y] + 1
                    queue.append((n_x, n_y))

        return matrix
```

- 时间复杂度：$O(m * n)$

## 1162. 地图分析

[原题链接](https://leetcode-cn.com/problems/as-far-from-land-as-possible/)

### 解一：广度优先搜索

- 先遍历 `grid` 一次，把陆地都存入队列，作为 BFS 第一层
- 将队列中的陆地元素取出，分别向上下左右走一步，如果遇到了海洋则继续加入队列，作为 BFS 下一层
  - 遇到的海洋标记为 `2` 防止重复遍历

这样以来，BFS 走的最大层数就是最后要求的最远距离（将 曼哈顿距离 转为步数处理）。  

```python
class Solution:
    def maxDistance(self, grid: List[List[int]]) -> int:
        m = len(grid)
        if m == 0:
            return -1
        n = len(grid[0])
        queue = []
        for i in range(m):
            for j in range(n):
                if grid[i][j] == 1:
                    # 发现陆地，加入队列
                    queue.append([i, j])

        if len(queue) == 0 or len(queue) == m * n:
            return -1

        distance = -1
        while len(queue) > 0:
            distance += 1
            length = len(queue)
            for i in range(length):
                # 取出所有位置
                first = queue[0]
                x, y = first[0], first[1]
                del queue[0]
                # 上下左右四个方向
                if x - 1 >= 0 and grid[x - 1][y] == 0:
                    # 避免重复判断
                    grid[x - 1][y] = 2
                    queue.append([x - 1, y])
                if x + 1 < m and grid[x + 1][y] == 0:
                    grid[x + 1][y] = 2
                    queue.append([x + 1, y])
                if y - 1 >= 0 and grid[x][y - 1] == 0:
                    grid[x][y - 1] = 2
                    queue.append([x, y - 1])
                if y + 1 < n and grid[x][y + 1] == 0:
                    grid[x][y + 1] = 2 
                    queue.append([x, y + 1])
        
        return distance
```