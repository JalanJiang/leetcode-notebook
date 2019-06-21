## 295. 数据流的中位数

[原题链接](https://leetcode-cn.com/problems/find-median-from-data-stream/comments/)

### 笨蛋解法

这题用 `O(n)` 是会超时的。

```python
class MedianFinder(object):

    def __init__(self):
        """
        initialize your data structure here.
        """
        self.nums = list()
        

    def addNum(self, num):
        """
        :type num: int
        :rtype: None
        """
        length = len(self.nums)
        if length == 0:
            self.nums.append(num)
        else:
            for i in range(len(self.nums)):
                tmp = self.nums[i]
                if num <= tmp:
                    self.nums.insert(i, num)
                    break
                if i == len(self.nums) - 1:
                    self.nums.append(num)
        print self.nums
        

    def findMedian(self):
        """
        :rtype: float
        """
        length = len(self.nums)
        if length % 2 == 0:
            right = length / 2
            left = right - 1
            return float(self.nums[left] + self.nums[right]) / 2
        else:
            return self.nums[(length - 1) / 2]
        


# Your MedianFinder object will be instantiated and called as such:
# obj = MedianFinder()
# obj.addNum(num)
# param_2 = obj.findMedian()
```

### 双堆

1. 元素入最小堆，
2. 弹出最小堆栈顶元素，放入最大堆中（保证最小堆的堆，都比最大堆的堆顶大）
3. 最后即可取出最小堆的最大元素和最大堆的最小元素（即有序数组中中间的两个元素）

```python
from heapq import *
class MedianFinder(object):

    def __init__(self):
        """
        initialize your data structure here.
        """
        self.max_h = []
        self.min_h = []
        heapify(self.max_h)
        heapify(self.min_h)
        

    def addNum(self, num):
        """
        :type num: int
        :rtype: None
        """
        heappush(self.min_h, num)
        heappush(self.max_h, -heappop(self.min_h))
        if len(self.min_h) < len(self.max_h):
            heappush(self.min_h, -heappop(self.max_h))

    def findMedian(self):
        """
        :rtype: float
        """
        max_len = len(self.max_h)
        min_len = len(self.min_h)
        
        if max_len == min_len:
            return (-self.max_h[0] + self.min_h[0]) / 2.
        else:
            return self.min_h[0] * 1.
        


# Your MedianFinder object will be instantiated and called as such:
# obj = MedianFinder()
# obj.addNum(num)
# param_2 = obj.findMedian()
```

### 参考资料

- [python堆排序heapq](https://www.jianshu.com/p/e003872fa7b9)


