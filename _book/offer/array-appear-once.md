## 数组中只出现一次的数字

[原题链接](https://www.nowcoder.com/practice/e02fdb54d7524710a7d664d082bb7811?tpId=13&tqId=11193&tPage=2&rp=1&ru=%2Fta%2Fcoding-interviews&qru=%2Fta%2Fcoding-interviews%2Fquestion-ranking)

## 思路

### 解法一

- hash
- 额外空间

```python
# -*- coding:utf-8 -*-
class Solution:
    # 返回[a,b] 其中ab是出现一次的两个数字
    def FindNumsAppearOnce(self, array):
        # write code here
        has = dict()
        for a in array:
            if a in has:
                has[a] = has[a] + 1
            else:
                has[a] = 1
        res = []
        for k, v in has.items():
            if v == 1:
                res.append(k)
        return res
```