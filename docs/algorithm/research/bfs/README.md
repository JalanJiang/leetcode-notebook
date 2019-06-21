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