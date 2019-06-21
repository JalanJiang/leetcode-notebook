# 第 129 场周赛

点击前往：[第 129 场周赛](https://leetcode-cn.com/contest/weekly-contest-129)

## 1020. 将数组分成和相等的三个部分

[原题链接](https://leetcode-cn.com/contest/weekly-contest-129/problems/partition-array-into-three-parts-with-equal-sum/)

### 思路

一开始想错了方法，想要暴力解决，二次循环导致超时。后面改成用数组存储数字和，也是需要嵌套循环，陷入思维误区了。

其实判断是否 `%3 == 0` 再找出三组 `s == sum // 3` 即可。

```python
class Solution(object):
    def canThreePartsEqualSum(self, A):
        """
        :type A: List[int]
        :rtype: bool
        """
        s = 0
        length = len(A)
        for n in A:
            s = s + n
        if s % 3 == 0:
            div = s / 3
        else:
            return False
        
        g = 0
        tmp = 0


        for i in range(length):
            tmp = A[i] + tmp
            if tmp == div:
                g = g + 1
                tmp = 0
        if g == 3:
            return True
        else:
            return False
```

## 1022. 可被 K 整除的最小整数

[原题链接](https://leetcode-cn.com/contest/weekly-contest-129/problems/smallest-integer-divisible-by-k/)

### 思路

暴力叠加求解。

```python
class Solution(object):
    def smallestRepunitDivByK(self, K):
        """
        :type K: int
        :rtype: int
        """
        num = 0
        for i in range(2 * K):
            num = num * 10 + 1
            num %= K
            if num == 0:
                return i + 1
        return -1
```