# 第 121 场周赛

## 984. 不含 AAA 或 BBB 的字符串

[原题链接](https://leetcode-cn.com/contest/weekly-contest-121/problems/string-without-aaa-or-bbb/)

### 思路

考虑 a 在前的情况：

- 当 A == 0 时：插入 b
- 当 B == 0 时：插入 a
- 当 A > B 时：插入 aab
- 当 B > A 时：插入 abb

注：如果 B > A，则先将 bb 入队列。

```python
class Solution(object):
    def strWithout3a3b(self, A, B):
        """
        :type A: int
        :type B: int
        :rtype: str
        """
        
        res_list = []
        
        if A == 0 and B == 0:
            return ""
        
        if B > A and A != 0:
            res_list.append("bb")
            B = B - 2
        
        while A != 0 or B != 0:
            
            if A == 0:
                res_list.append("b")
                B = B - 1
                continue
                
            if B == 0:
                res_list.append("a")
                A = A - 1
                continue
                
            if A > B:
                res_list.append("aa")
                A = A - 2
                res_list.append("b")
                B = B - 1
            elif B > A:
                res_list.append("a")
                A = A - 1
                res_list.append("bb")
                B = B - 2
            else:
                res_list.append("a")
                A = A - 1
                res_list.append("b")
                B = B - 1 
            
        return "".join(res_list)  
```
