# 第 134 场周赛

点击前往 [第 133 场周赛](https://leetcode-cn.com/contest/weekly-contest-134)

**完成情况**

没有做满 1 小时 30 分，大概用 1 小时的时间完成了两题。

<img src="_img/weekly-134.png" />

第一题简单题，但一开始题意理解错了，导致解答的时候漏了一种情况。

第二题和上周竞赛某题挺像的，依旧没有用递归来写，怕写错了，递归的写法还是要加强。

**总结**

- 递归练习

## 5039. 移动石子直到连续

[原题链接](https://leetcode-cn.com/contest/weekly-contest-134/problems/moving-stones-until-consecutive/)

### 思路

- 先对输入的 a b c 进行排序，得到 x y z
- 计算 x 与 y 的距离 `y - x`，记为 `left`；y 与 z 的距离 `z - y`，记为 `right`

分成以下几种情况：

- `left == 1` 时，即 x 与 y 相邻：
    - `right == 1`，z 与 y 也相邻：那么无需任何移动
    - `right != 1`，z 与 y 不相邻：可移动的最小次数为 1，最大次数为 `right - 1`
- `left != 1` 时，即 x 与 y 不相邻：
    - `right == 1`，z 与 y 相邻：可移动的最小次数为 1，最大次数为 `left - 1`
    - `right != 1`，z 与 y 不相邻：若 `left == 2` 或 `right == 2`，那么最小次数为 1，否则最小次数为 2；最大次数为 `right - 1 + left - 1`
        
代码写的太丑了。。。

```python
class Solution(object):
    def numMovesStones(self, a, b, c):
        """
        :type a: int
        :type b: int
        :type c: int
        :rtype: List[int]
        """
        t = [0 for _ in range(3)]
        t[0] = a
        t[1] = b
        t[2] = c
        t.sort()
        res = [0, 0]
        x = t[0]
        y = t[1]
        z = t[2]
        
        left = y - x
        right = z - y
        
        if left == 1:
            if right == 1:
                return res
            else:
                min_n = 1
                max_n = right - 1
        else:
            if right == 1:
                min_n = 1
                max_n = left - 1
            else:
                if left == 2 or right == 2:
                    min_n = 1
                else:
                    min_n = 2
                max_n = right - 1 + left - 1
        
        res[0] = min_n
        res[1] = max_n
        
        return res
```

## 5040. 边框着色

[原题链接](https://leetcode-cn.com/contest/weekly-contest-134/problems/coloring-a-border/)

### 思路

从 `(r0, c0)` 开始往四个方向走，如果发现走到的下一个格子是界外或是连通分量外，则将上一个格子标记为 `color`。

这里用 `mark` 二维数组存储是否已经走过了某个格子。

和上周竞赛的 [距离顺序排列矩阵单元格](/weekly/133/1030.md) 问题很像，但我感觉应该还有更好的方法吧。待复盘补充。

```python
class Solution(object):
    def colorBorder(self, grid, r0, c0, color):
        """
        :type grid: List[List[int]]
        :type r0: int
        :type c0: int
        :type color: int
        :rtype: List[List[int]]
        """
        R = len(grid)
        C = len(grid[0])
        
        tmp = []
        mark = [[0 for _ in range(C)] for _ in range(R)]
        mark[r0][c0] = 1
        co = grid[r0][c0]
        tmp.append([r0, c0])
        
        while tmp:
            for i in range(len(tmp)):
                t = tmp[0]
                r = t[0]
                c = t[1]
                del tmp[0]
                if r + 1 < R:
                    if mark[r+1][c] == 0:
                        if grid[r+1][c] == co:
                            tmp.append([r+1, c])
                            mark[r+1][c] = 1
                        else:
                            grid[r][c] = color
                else:
                    grid[r][c] = color
                    
                if r - 1 >= 0:
                    if mark[r-1][c] == 0:
                        if grid[r-1][c] == co:
                            tmp.append([r-1, c])
                            mark[r-1][c] = 1
                        else:
                            grid[r][c] = color
                else:
                    grid[r][c] = color
                    
                if c + 1 < C:
                    if mark[r][c+1] == 0:
                        if grid[r][c+1] == co:
                            tmp.append([r, c+1])
                            mark[r][c+1] = 1
                        else:
                            grid[r][c] = color
                else:
                    grid[r][c] = color
                    
                if c - 1 >= 0:
                    if mark[r][c-1] == 0:
                        if grid[r][c-1] == co:
                            tmp.append([r, c-1])
                            mark[r][c-1] = 1
                        else:
                            grid[r][c] = color
                else:
                    grid[r][c] = color
            
        return grid
```

## 5041. 不相交的线

[原题链接](https://leetcode-cn.com/contest/weekly-contest-134/problems/uncrossed-lines/)

### 思路

设 `A[0] ~ A[x]` 与 `B[0] ~ B[y]` 的最大连线数为 `f(x, y)`，那么对于任意位置的 `f(i, j)` 而言：

- 如果 `A[i] == B[j]`，即 `A[i]` 和 `B[j]` 可连线，此时 `f(i, j) = f(i - 1, j - 1) + 1`
- 如果 `A[i] != B[j]`，即 `A[i]` 和 `B[j]` 不可连线，此时最大连线数取决于 `f(i - 1, j)` 和 `f(i, j - 1)` 的较大值


```python
class Solution(object):
    def maxUncrossedLines(self, A, B):
        """
        :type A: List[int]
        :type B: List[int]
        :rtype: int
        """
        a_length = len(A)
        b_length = len(B)
        
        res = [[0 for _ in range(b_length + 1)] for _ in range(a_length + 1)]
        
        for i in range(a_length):
            for j in range(b_length):
                if A[i] == B[j]:
                    res[i + 1][j + 1] = res[i][j] + 1
                else:
                    res[i + 1][j + 1] = max(res[i + 1][j], res[i][j + 1])
        
        return res[a_length][b_length]
```
