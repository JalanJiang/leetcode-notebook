## 二进制中 1 的个数

[原题链接](https://www.nowcoder.com/practice/8ee967e43c2c4ec193b040ea7fbb10b8?tpId=13&tqId=11164&tPage=1&rp=1&ru=/ta/coding-interviews&qru=/ta/coding-interviews/question-ranking)

## 思路

去除 n 的位级表示中最低的那一位：

```
n       : 10110100
n-1     : 10110011
n&(n-1) : 10110000
```

复杂度 `O(M)`，M 表示 1 的个数。

```python
class Solution:
    def NumberOf1(self, n):
        # write code here
        count = 0
        if n < 0:
            n = n & 0xffffffff
        while n:
            count += 1
            n = (n - 1) & n
        return count
```

注：因为 python 的 int 是无线精度的，c++ 的 int 是 32 位的，所以 python 的负数相当于前面有无限个 1，要对 python 的负数做处理，否则会出现死循环。


