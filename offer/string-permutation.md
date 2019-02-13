## 字符串的排列

[原题链接](https://www.nowcoder.com/practice/fe6b651b66ae47d7acce78ffdd9a96c7?tpId=13&tqId=11180&tPage=2&rp=1&ru=%2Fta%2Fcoding-interviews&qru=%2Fta%2Fcoding-interviews%2Fquestion-ranking)

## 思路

1. 选出所有可能放在第一位的字符，即：把第一个字符与剩余部分每个字符交换一次
2. 求出除第一个字符外的所有字符的全排列
3. 由 1 和 2 得出可以使用递归实现

```python
# -*- coding:utf-8 -*-
class Solution:
    def Permutation(self, ss):
        # write code here
        out = []
        if len(ss) == 0:
            return out
        charlist = list(ss)
        self.per(charlist, 0, out)
        res = []
        for o in out:
            res.append(''.join(o))
        res.sort()
        return res
    
    def per(self, ss, begin, out):
        if begin == len(ss) - 1:
            out.append(ss[:])
        else:
            for i in range(begin, len(ss)):
                if ss[begin] == ss[i] and begin != i:
                    continue
                else:
                    ss[begin], ss[i] = ss[i], ss[begin]
                    self.per(ss, begin + 1, out)
                    ss[begin], ss[i] = ss[i], ss[begin]
```

## 参考资料

- [《剑指offer》【字符串的排列】（python版）](https://blog.csdn.net/qq_20141867/article/details/80933497)