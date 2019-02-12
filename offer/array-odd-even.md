## 调整数组顺序使奇数位于偶数前面

[原题链接](https://www.nowcoder.com/practice/beb5aa231adc45b2a5dcc5b62c93f593?tpId=13&tqId=11166&tPage=1&rp=1&ru=%2Fta%2Fcoding-interviews&qru=%2Fta%2Fcoding-interviews%2Fquestion-ranking)

## 解法一

使用额外空间，奇数和偶数分开存储。得益于 Python 的简单写法。

时间复杂度为 `O(n)`。

```python
# -*- coding:utf-8 -*-
class Solution:
    def reOrderArray(self, array):
        # write code here
        if array is None:
            return []
        
        length = len(array)
        if length == 0:
            return []
        
        left = []
        right = []
        for a in array:
            if a % 2 == 0:
                right.append(a)
            else:
                left.append(a)
        return left + right
```

## 解法二

使用交换的方式，不使用额外空间。因为相对位置不可改变，也不能通过双指针的方法来解了。

借鉴插入排序的方法：

- 记录已经完成排序的奇数数字个数
- 寻找下一个奇数
- 将该奇数插入到奇数队列末尾

```python
# -*- coding:utf-8 -*-
class Solution:
    def reOrderArray(self, array):
        # write code here
        if array is None:
            return []
        
        length = len(array)
        if length == 0:
            return []
        
        k = 0 #已经完成排序的奇数数字个数
        for i in range(length):
            left = array[i]
            if left % 2 == 1:
                j = i
                while j > k:
                    tmp = array[j]
                    array[j] = array[j - 1]
                    array[j - 1] = tmp
                    j = j - 1
                k = k + 1
        return array
```