## 5130. 等价多米诺骨牌对的数量

[原题链接](https://leetcode-cn.com/contest/weekly-contest-146/problems/number-of-equivalent-domino-pairs/)

### 思路

用一个二维数组存储多米诺骨牌出现的次数，`mark[i][j]` 代表 `[i, j]` 出现次数。

当我们遇到一张新牌 `[x, y]` 时，可以通过 `mark[x, y]` 和 `mark[y, x]` 得知 `[x, y]` 与 `[y, x]` 牌型出现的次数，从而得出等价骨牌对为 `mark[x, y] + mark[y, x]`。

注：当 `i == j` 时，此时 `[i, j]` 和 `[j, i]` 为同一张牌，无需重复计算 `[j, i]` 出现的情况。

```python
class Solution:
    def numEquivDominoPairs(self, dominoes: List[List[int]]) -> int:
        mark = [[0 for _ in range(10)] for _ in range(10)]
        res = 0
        for dominoe in dominoes:
            i = dominoe[0]
            j = dominoe[1]
            if mark[i][j] > 0:
                res += mark[i][j]
            if i != j:
                if mark[j][i] > 0:
                    res += mark[j][i]
            mark[i][j] += 1
        return res
```