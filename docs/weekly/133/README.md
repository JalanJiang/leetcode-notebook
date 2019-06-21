# 第 133 场周赛

点击前往 [第 133 场周赛](https://leetcode-cn.com/contest/weekly-contest-133)

**完成情况**

完成两题。

<img src="_img/weekly-133.png" />

第一题其实挺简单的，结果一直在乱想是贪心还是动态规划啥的，脑子直接卡机了……其实问题往往没有那么复杂。

第二题没有想清楚思路就开始写了，结果导致改了很多遍，浪费了很多时间。

**总结**

- 构思后再码

## 1029. 两地调度

[原题链接](https://leetcode-cn.com/contest/weekly-contest-133/problems/two-city-scheduling/)

### 思路

核心思想：看某个人前往 A 还是前往 B 的成本更大。

计算去 A 和去 B 的成本差值，假设记为 `d`，如果 `d` 值很大，表示去 A 的成本更高，则去 A 的优先级降低。

```python
class Solution(object):
    def twoCitySchedCost(self, costs):
        """
        :type costs: List[List[int]]
        :rtype: int
        """
        N = len(costs) / 2
        count = 0
        dif = []
        for i in range(len(costs)):
            c = costs[i]
            dif.append([c[0] - c[1], i])
        dif.sort()
        for d in dif:
            index = d[1]
            if N > 0:
                count += costs[index][0]
            else:
                count += costs[index][1]
            N -= 1
        return count
```

## 1030. 距离顺序排列矩阵单元格

[原题链接](https://leetcode-cn.com/contest/weekly-contest-133/problems/matrix-cells-in-distance-order/)

### 思路

从 `(r0, c0)` 往上下左右出发，能打到的单元格距离为 `1`，将这组单元格放入列表，遍历该列表，继续往上下左右出发……

我这里用一个二维数组 `mark` 来记录单元格是否遍历过了。

```python
class Solution(object):
    def allCellsDistOrder(self, R, C, r0, c0):
        """
        :type R: int
        :type C: int
        :type r0: int
        :type c0: int
        :rtype: List[List[int]]
        """
        max_r = R - 1
        max_c = C - 1
        
        res = []
        tmp = []
        mark = [[0 for _ in range(C)] for _ in range(R)]
        mark[r0][c0] = 1
        res.append([r0, c0])
        tmp.append([r0, c0])
        
        while tmp:
            for i in range(len(tmp)):
                t = tmp[0]
                r = t[0]
                c = t[1]
                del tmp[0]
                print[r, c]
                if r + 1 < R:
                    if mark[r+1][c] == 0:
                        tmp.append([r+1, c])
                        mark[r+1][c] = 1
                if r - 1 >= 0:
                    if mark[r-1][c] == 0:
                        tmp.append([r-1, c])
                        mark[r-1][c] = 1
                if c + 1 < C:
                    if mark[r][c+1] == 0:
                        tmp.append([r, c+1])
                        mark[r][c+1] = 1
                if c - 1 >= 0:
                    if mark[r][c-1] == 0:
                        tmp.append([r, c-1])
                        mark[r][c-1] = 1
            res += tmp
        return res
```

## 1031. 两个非重叠子数组的最大和

[原题链接](https://leetcode-cn.com/contest/weekly-contest-133/problems/maximum-sum-of-two-non-overlapping-subarrays/)

### 思路

- 记前 i 项的和为 `s[i + 1]`
- 则区间长度可以表示为：`s[i+L] - s[i] + s[j+M] - s[j]`，求这个长度的最大值即可

```python
class Solution(object):
    def maxSumTwoNoOverlap(self, A, L, M):
        """
        :type A: List[int]
        :type L: int
        :type M: int
        :rtype: int
        """
        s = [0]
        length = len(A)
        for i in range(length):
            s.append(s[i] + A[i])
            
        res = 0
        for i in range(length):
            for j in range(length):
                if self.checkij(i, j, L, M, length) == True:
                    res = max(res, s[i+L] - s[i] + s[j+M] - s[j])
        return res
           
    # 判断 i j 取值是否可行
    def checkij(self, i, j, L, M, length):
        if i + L <= length and j + M <= length and (i + L <= j or j + M <= i):
            return True
        else:
            return False
```