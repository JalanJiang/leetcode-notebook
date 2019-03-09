## 矩阵中的路径

[原题链接](https://www.nowcoder.com/practice/c61c6999eecb4b8f88a98f66b273a3cc?tpId=13&tqId=11218&tPage=1&rp=1&ru=/ta/coding-interviews&qru=/ta/coding-interviews/question-ranking)

## 思路

回溯法的经典题，递归求解。

- 维护一个和 matrix 同样大小的二维数组 mark，用于记录元素是否重复访问
- 往上、下、左、右四个方向扩展字符串，若不符合要求则回退

注意这里的输入测试用例为：一维list、int、int、一维list，需要重构一个 rows*cols 的 matrix。

```python
# -*- coding:utf-8 -*-
class Solution:
    def hasPath(self, matrix, rows, cols, path):
        if rows == 0 and cols == 0:
            return False
        mark = [[0 for _ in range(cols)] for _ in range(rows)]
        array = [list(matrix[cols*i:cols*(i+1)]) for i in range(rows)]
        for i in range(rows):
            for j in range(cols):
                if self.backtracking(array, path, i, j, 0, mark):
                    return True
        return False
    
    def backtracking(self, matrix, string, r, c, pathLength, mark):
        if len(string) == pathLength:
            return True
        rows = len(matrix)
        cols = len(matrix[0])
        if r < 0 or r >= rows or c < 0 or c >= cols or matrix[r][c] != string[pathLength] or mark[r][c] == 1:
            return False
        
        mark[r][c] = 1
        if self.backtracking(matrix, string, r + 1, c, pathLength + 1, mark) or self.backtracking(matrix, string, r - 1, c, pathLength + 1, mark) or self.backtracking(matrix, string, r, c + 1, pathLength + 1, mark) or self.backtracking(matrix, string, r, c - 1, pathLength + 1, mark):
            return True
        mark[r][c] = 0
        return False
```

## 其他

### python 二维 list 的构造

```python
mark = [[0 for _ in range(cols)] for _ in range(rows)]
```