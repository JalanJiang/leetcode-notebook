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