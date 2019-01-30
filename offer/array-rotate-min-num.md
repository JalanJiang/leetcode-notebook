## 旋转数组的最小数字

[原题链接](https://www.nowcoder.com/practice/9f3231a991af4f55b95579b44b7a01ba?tpId=13&tqId=11159&tPage=1&rp=1&ru=/ta/coding-interviews&qru=/ta/coding-interviews/question-ranking)

## 思路

二分法：

```python
# -*- coding:utf-8 -*-
class Solution:
    def minNumberInRotateArray(self, rotateArray):
        # write code here
        if len(rotateArray) == 0:
            return 0
        
        l = 0
        r = len(rotateArray) - 1
        
        while l < r:
            mid = (l + r) // 2
            if rotateArray[mid] < rotateArray[r]:
                r = mid
            else:
                l = mid + 1
        return rotateArray[l]
```