## 剪绳子

[原题链接](https://leetcode-cn.com/problems/integer-break/submissions/)

## 思路

### 贪心

数学题了，尽量剪成长度为 3 或长度为 2 的小段，这样乘积最大。

时间与空间复杂度都是 `O(1)`。

```python
class Solution(object):
    def integerBreak(self, n):
        """
        :type n: int
        :rtype: int
        """
        if n < 2:
            return 0
        if n == 2:
            return 1
        if n == 3:
            return 2
        
        count_3 = n // 3
        if n - count_3 * 3 == 1:
            count_3 = count_3 - 1
        count_2 = (n - count_3 * 3) // 2
        
        return int(math.pow(3, count_3) * math.pow(2, count_2))
```

### 动态规划

- 计算每个长度的最大乘积
- 通过已经计算出的最大乘积算出结果

时间复杂度 `O(n*n)`，空间复杂度 `O(n)`。

```python
class Solution(object):
    def integerBreak(self, n):
        """
        :type n: int
        :rtype: int
        """
        if n < 2:
            return 0
        if n == 2:
            return 1
        if n == 3:
            return 2
        
        res_dict = dict()
        res_dict[0] = 0
        res_dict[1] = 1
        res_dict[2] = 2
        res_dict[3] = 3
        
        for i in range(4, n + 1):
            for j in range(1, i // 2 + 1):
                tmp = res_dict[j] * res_dict[i - j]
                if i not in res_dict:
                    res_dict[i] = tmp
                else:
                    if tmp > res_dict[i]:
                        res_dict[i] = tmp
        
        return res_dict[n]
```