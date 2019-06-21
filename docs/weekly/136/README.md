# 第 136 场周赛

点击前往：[第 136 场周赛](https://leetcode-cn.com/contest/weekly-contest-136)

## 5055. 困于环中的机器人

[原题链接](https://leetcode-cn.com/contest/weekly-contest-136/problems/robot-bounded-in-circle/)

### 思路

模拟机器人走位，重复指令 4 次，如果回到原点就说明在绕圈。

```python
class Solution(object):
    def isRobotBounded(self, instructions):
        """
        :type instructions: str
        :rtype: bool
        """
        instructions *= 4
        
        forward_list = [(0, 1), (-1, 0), (0, -1), (1, 0)]
        forward = 0
        
        x, y = 0, 0
        
        for i in instructions:
            if i == "L":
                forward += 1
            if i == 'R':
                forward += 3
            forward %= 4
            
            if i == "G":
                x, y = x + forward_list[forward][0], y + forward_list[forward][1]
            
        return x == 0 and y ==0
```

## 5056. 不邻接植花

[原题链接](https://leetcode-cn.com/contest/weekly-contest-136/problems/flower-planting-with-no-adjacent/)

### 思路

填色问题。

一开始的思路错了，想按照连接顺序从小到大直接用 1, 2, 3, 4 ... 填色。正确的思路应该是先找到要填色花园 i 的其他相邻花园的颜色，然后找一个还没用过的颜色给当前花园上色。


```python
class Solution(object):
    def gardenNoAdj(self, N, paths):
        """
        :type N: int
        :type paths: List[List[int]]
        :rtype: List[int]
        """
        info = dict()
        res = [None for _ in range(N)]
        mark = [0 for _ in range(N)]
        
        for p in paths:
            a = p[0] - 1
            b = p[1] - 1
            if a not in info:
                info[a] = set()
            if b not in info:
                info[b] = set()
            info[a].add(b)
            info[b].add(a)
        
        #print info
        
        def dfs(i):
            tmp = set()
            if i in info:
                for other in info[i]:
                    tmp.add(res[other])
            for c in range(4):
                c = c + 1
                if c not in tmp:
                    res[i] = c
                    break
                    

        for i in range(N):
            if res[i] is None:
                dfs(i)
        
        return res
```

----

一开始写的智障代码，思路错误 + 超时。

```python
class Solution(object):
    def gardenNoAdj(self, N, paths):
        """
        :type N: int
        :type paths: List[List[int]]
        :rtype: List[int]
        """
        info = dict()
        res = [1 for _ in range(N)]
        mark = [0 for _ in range(N)]
        
        if len(paths) == 0:
            return res
        
        for p in paths:
            a = p[0]
            b = p[1]
            
            if a not in info:
                info[a] = set()
            if b not in info:
                info[b] = set()
                
            info[a].add(b)
            info[b].add(a)
            
        for i in range(N):
            index = i + 1
            if info.has_key(index):
                for g in info[index]:
                    if index == 5:
                        print "g=", g
                    if g > index and res[g - 1] == res[i]:
                        if res[mark[g - 1]] + 1 != res[i]:
                            res[g - 1] = res[mark[g - 1]] + 1
                        else:
                            res[g - 1] = res[i] + 1
                    mark[g - 1] = index - 1
        
        return res
                
        
```

