## 数值的整数次方

[原题链接](https://www.nowcoder.com/practice/1a834e5e3e1a4b7ba251417554e07c00?tpId=13&tqId=11165&tPage=1&rp=1&ru=/ta/coding-interviews&qru=/ta/coding-interviews/question-ranking)
[leetcode](https://leetcode-cn.com/problems/powx-n/submissions/)

## 思路

递归求解

`(x*x)^n/2` 可以通过递归求解，并且每次递归 n 都减小一半，因此整个算法的时间复杂度为 O(logN)
 
```python
# -*- coding:utf-8 -*-
class Solution:
    def Power(self, base, exponent):
        # write code here
        if exponent == 0:
            return 1
        if exponent == 1:
            return base
        
        flag = 0
        if exponent < 0:
            exponent = -exponent
            flag = 1
        
        p = self.Power(base * base, exponent//2)
        if exponent % 2 == 1:
            p = p * base
        
        if flag == 1:
            return 1/p
        else:
            return p
```