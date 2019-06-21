# 第 122 场周赛

点击前往：[第 122 场周赛](https://leetcode-cn.com/contest/weekly-contest-122)

第一次参加，紧张的一批。

<img src="_img/weekly-122.png"/>

结果还可以吧，太躁了，感觉应该可以做三题。期待下次更 🐂🍺 一点~

## 985. 查询后的偶数和

[原题链接](https://leetcode-cn.com/contest/weekly-contest-122/problems/sum-of-even-numbers-after-queries/)

### 思路

挺简单的，最终的结果不需要每次依次相加，在原来的基础上加上或减去就好。

```python
class Solution(object):
    def sumEvenAfterQueries(self, A, queries):
        """
        :type A: List[int]
        :type queries: List[List[int]]
        :rtype: List[int]
        """
        answer = []
        s = 0
        for num in A:
            if num % 2 == 0:
                s = s + num        
        
        for i in range(len(A)):
            val = queries[i][0]
            index = queries[i][1]
            pre = A[index]
            if pre % 2 == 0 and val % 2 == 0:
                s = s + val
            if pre % 2 == 0 and val % 2 == 1:
                s = s - pre    
            if pre % 2 == 1 and val % 2 == 1:
                s = s + val + pre
            A[index] = pre + val            
            answer.append(s)
        
        return answer
```

## 986. 区间列表的交集

[原题链接](https://leetcode-cn.com/contest/weekly-contest-122/problems/interval-list-intersections/)

### 思路

简单题，考虑好所有情况就好了，包括 `[25, 25]` 这种也算一个区间的情况……

这题 debug 了两三次，漏了一些情况导致答案错误。

```python
# Definition for an interval.
# class Interval(object):
#     def __init__(self, s=0, e=0):
#         self.start = s
#         self.end = e

class Solution(object):
    def intervalIntersection(self, A, B):
        """
        :type A: List[Interval]
        :type B: List[Interval]
        :rtype: List[Interval]
        """
        res = []
        b_i = 0
        for a in A:
            a_start = a.start
            a_end = a.end
            tmp = []
            for j in range(b_i, len(B)):
                b_start = B[j].start
                b_end = B[j].end
                
                if a_end < b_start:
                    #b_i = b_i + 1
                    break
                    
                if a_end == b_start:
                    i = Interval(a_end, a_end)
                    res.append(i)
                    break
                    
                if b_end == a_start:
                    i = Interval(a_start, a_start)
                    res.append(i)
                    continue
                
                if b_start > a_start and b_start < a_end and b_end > a_end:
                    i = Interval(b_start, a_end)
                    print "a"
                    res.append(i)
                
                if a_start > b_start and a_start < b_end and a_end > b_end:
                    i = Interval(a_start, b_end)
                    print "b"
                    res.append(i)
                    
                if b_start >= a_start and b_end <= a_end:
                    i = Interval(b_start, b_end)
                    print "c"
                    res.append(i)
                elif a_start >= b_start and a_end <= b_end:
                    i = Interval(a_start, a_end)
                    print "d"
                    res.append(i)
        return res
```

## 988. 从叶结点开始的最小字符串

[原题链接](https://leetcode-cn.com/contest/weekly-contest-122/problems/smallest-string-starting-from-leaf/)

### 思路

这题规定时间内没做出来，后来想想挺简单的。

- 递归，求得所有路径
- 在所有路径中返回最小路径

```python
# Definition for a binary tree node.
# class TreeNode(object):
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def smallestFromLeaf(self, root):
        strs = []
        def dfs(t, s):
            s = chr(ord('a') + t.val) + s
            if t.left == None and t.right == None:
                strs.append(s)
            else:
                if t.left != None:
                    dfs(t.left, s)
                if t.right != None:
                    dfs(t.right, s)
        dfs(root, '')
        return min(strs)
```
