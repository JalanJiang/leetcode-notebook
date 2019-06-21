# 第 138 场周赛

点击前往 [第 138 场周赛](https://leetcode-cn.com/contest/weekly-contest-138)

**完成情况**

半小时完成前两题。第三题没看懂，第四题最后没有调出来。

<img src="_img/weekly-138.png">

## 1051. 高度检查器

[原题链接](https://leetcode-cn.com/contest/weekly-contest-138/problems/height-checker/)

### 思路

排序 + 对比。

```python
class Solution(object):
    def heightChecker(self, heights):
        """
        :type heights: List[int]
        :rtype: int
        """
        res_heights = sorted(heights)
        cnt = 0
        
        for i in range(len(heights)):
            if heights[i] != res_heights[i]:
                cnt += 1
                
        return cnt
```

## 1052. 爱生气的书店老板

[原题链接](https://leetcode-cn.com/contest/weekly-contest-138/problems/grumpy-bookstore-owner/)

### 思路

求生气的时候 X 段时间内能产生的最大客流量。

结果 = 已经可以获得的客流量 + 生气的时候 X 段时间内能产生的最大客流量

```python
class Solution(object):
    def maxSatisfied(self, customers, grumpy, X):
        """
        :type customers: List[int]
        :type grumpy: List[int]
        :type X: int
        :rtype: int
        """
        happy_cnt = 0
        
        unhappy_list = []
        
        customers_cnt = len(customers)
        
        for i in range(customers_cnt):
            if grumpy[i] == 1:
                unhappy_list.append(customers[i])
            else:
                unhappy_list.append(0)
                happy_cnt += customers[i]
        
        pre = 0
        for i in range(X):
            pre += unhappy_list[i]
        
        max_unhappy_cnt = pre
        for i in range(X, customers_cnt):
            cur = pre - unhappy_list[i - X] + unhappy_list[i]
            max_unhappy_cnt = max(max_unhappy_cnt, cur)
            pre = cur
            
        return happy_cnt + max_unhappy_cnt
```

## 1053. 交换一次的先前排列

[原题链接](https://leetcode-cn.com/contest/weekly-contest-138/problems/previous-permutation-with-one-swap/)

### 思路

1. 从后向前，找到第一个非递减的数（第一个产生递增行为的数），标记下标为 `i`
2. 从后向前遍历到下标 `i`，找到第一个小于 `i` 的数字，标记下标为 `j`
3. 交换 `A[i]` 和 `A[j]`

但其实第三个测试用例是错的。。。比赛的时候看了半天没看懂。。说什么好

```python
class Solution(object):
    def prevPermOpt1(self, A):
        """
        :type A: List[int]
        :rtype: List[int]
        """
        length = len(A)

        for i in range(length - 2, -1, -1):
            if A[i] > A[i + 1]:
                break
        else:
            return A
    
        
        for j in range(length - 1, i, -1):
            if A[j] < A[i]:
                break
        
        A[i], A[j] = A[j], A[i]
        
        return A
```

## 1054. 距离相等的条形码

[原题链接](https://leetcode-cn.com/contest/weekly-contest-138/problems/distant-barcodes/)

### 思路

1. 按出现次数对数字进行排列
2. 把出现最多的数排在奇数位置
3. 然后剩余数字依次填满剩余奇数位和偶数位

```python
class Solution(object):
    def rearrangeBarcodes(self, barcodes):
        """
        :type barcodes: List[int]
        :rtype: List[int]
        """
        barcode_map = dict()
        
        for barcode in barcodes:
            if barcode not in barcode_map:
                barcode_map[barcode] = 0
            barcode_map[barcode] += 1
            
        barcode_sort = sorted(barcode_map.items(), key=lambda x: x[1], reverse=True)
            
        barcode_length = len(barcodes)
        res = [0 for _ in range(barcode_length)]
        
        index = 0
        while len(barcode_sort):
            cur = barcode_sort[0]
            cur_num = cur[0]
            cur_cnt = cur[1]
            
            while cur_cnt > 0:
                if index % 2 == 0 and index > barcode_length - 1:
                    index = 1
                res[index] = cur_num
                cur_cnt -= 1
                index += 2
                
            del barcode_sort[0]
            
        return res
            
```