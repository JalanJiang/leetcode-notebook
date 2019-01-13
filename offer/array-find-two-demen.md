## 二维数组中的查找

[原题链接](https://www.nowcoder.com/practice/abc3fe2ce8e146608e868a70efebf62e?tpId=13&tqId=11154&tPage=1&rp=1&ru=/ta/coding-interviews&qru=/ta/coding-interviews/question-ranking)

Leetcode 中的 240 题。

### 思路

从左下角开始找起

```python
# -*- coding:utf-8 -*-
class Solution:
    # array 二维列表
    def Find(self, target, array):
        # write code here
        row = len(array)
        if row == 0:
            return False
        col = len(array[0])
        
        i = row - 1
        j = 0
        while i >= 0 and j < col:
            n = array[i][j]
            if target == n:
                return True
            elif target > n:
                j = j + 1
            else:
                i = i - 1
                
        return False
```

复杂度：`O(M + N) + O(1)`