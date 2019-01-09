## 顺时针打印数组

[原题链接](https://www.nowcoder.com/practice/9b4c81a02cd34f76be2659fa0d54342a?tpId=13&tqId=11172&tPage=1&rp=1&ru=/ta/coding-interviews&qru=/ta/coding-interviews/question-ranking)

### 思路

绕圈圈，取两边界值，理清思路就好。

```python
# -*- coding:utf-8 -*-
class Solution:
    # matrix类型为二维列表，需要返回列表
    def printMatrix(self, matrix):
        # write code here
        row_length = len(matrix)
        col_length = len(matrix[0])
        
        r1 = 0
        r2 = row_length - 1
        c1 = 0
        c2 = col_length - 1
        
        res_list = []
        while r1 <= r2 and c1 <= c2:
            for col in range(c1, c2 + 1):
                res_list.append(matrix[r1][col])
            for row in range(r1 + 1, r2 + 1):
                res_list.append(matrix[row][c2])
            if r1 != r2:
                for col in reversed(range(c1, c2)):
                    res_list.append(matrix[r2][col])
            if c1 != c2:
                for row in reversed(range(r1 + 1, r2)):
                    res_list.append(matrix[row][c1])
                    
            r1 = r1 + 1
            r2 = r2 - 1
            c1 = c1 + 1
            c2 = c2 - 1
                
        return res_list
```