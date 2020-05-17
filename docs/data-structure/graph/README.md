## 133. 克隆图

[原题链接](https://leetcode-cn.com/problems/clone-graph/)

### DFS

用字典 `mark` 记录遍历过的节点，`mark[node] = clone` 用于对应 `node` 的拷贝节点 `clone`。

```python
"""
# Definition for a Node.
class Node:
    def __init__(self, val = 0, neighbors = []):
        self.val = val
        self.neighbors = neighbors
"""
class Solution:
    def cloneGraph(self, node: 'Node') -> 'Node':
        # 记录访问过的节点
        mark = dict()

        def dfs(node):
            if node is None:
                return node
            if node in mark:
                return mark[node]

            clone = Node(node.val, [])
            mark[node] = clone # node 对应的克隆节点为 clone，记录在字典中
            for n in node.neighbors:
                clone.neighbors.append(dfs(n))

            # 返回克隆节点
            return clone

        return dfs(node)
```

### BFS

用辅助队列实现 BFS。

```python
"""
# Definition for a Node.
class Node:
    def __init__(self, val = 0, neighbors = []):
        self.val = val
        self.neighbors = neighbors
"""
class Solution:
    def cloneGraph(self, node: 'Node') -> 'Node':
        if node is None:
            return node

        # 记录 node 对应的拷贝
        mark = dict()
        # 辅助队列
        queue = list()
        queue.append(node)
        clone = Node(node.val, [])

        mark[node] = clone

        while len(queue) > 0:
            # 取出一个节点
            node = queue[0]
            del queue[0]
            # 遍历邻接节点
            for n in node.neighbors:
                if n not in mark:
                    mark[n] = Node(n.val, [])
                    # 新节点入队列
                    queue.append(n)
                mark[node].neighbors.append(mark[n])

        return clone
```

## 210. 课程表 II

[原题链接](https://leetcode-cn.com/problems/course-schedule-ii/)

### 思路

在图中找到循环。

```python
class Solution:
    def findOrder(self, numCourses: int, prerequisites: List[List[int]]) -> List[int]:
        length = len(prerequisites)
        if length == 0:
            return [i for i in range(numCourses)]
        # n = len(prerequisites[0])

        # 存储依赖关系
        degree = [0 for _ in range(numCourses)]
        relations = dict()
        for pre in prerequisites:
            nxt = pre[0]
            cur = pre[1]
            # 依赖关系
            if cur not in relations:
                relations[cur] = [nxt]
            else:
                relations[cur].append(nxt)
            # nxt 课程的度 + 1
            degree[nxt] += 1


        # 入度为 0 的入队
        queue = []
        for i in range(numCourses):
            if degree[i] == 0:
                queue.append(i)
        
        # 遍历队列
        ans = []
        while len(queue) > 0:
            first = queue[0]
            del queue[0]
            # if first not in ans:
            ans.append(first)
            # 获取下一批度为 0 的课程入队
            for course in relations.get(first, []):
                degree[course] -= 1
                if degree[course] == 0:
                    queue.append(course)

        return ans if len(ans) == numCourses else []
```

## 997. 找到小镇的法官

[原题链接](https://leetcode-cn.com/problems/find-the-town-judge)

### 思路

这是一道关于图的题。

用一个二维数组存储每个节点的入度和出度，入度 = N - 1 且 出度 = 0 的节点为法官。


```python
class Solution:
    def findJudge(self, N: int, trust: List[List[int]]) -> int:
        node = [[0, 0] for _ in range(N + 1)]

        # 记录
        for t in trust:
            node[t[0]][0] += 1
            node[t[1]][1] += 1
                
        for i in range(1, N + 1):
            n = node[i]
            if n[1] == N - 1 and n[0] == 0:
                return i

        return -1
```