## 215. Kth Largest Element in an Array

[原题链接](https://leetcode-cn.com/problems/kth-largest-element-in-an-array/comments/)

### 思路

- 堆排
- 在重新调整堆时弹出第 k 个元素
- 时间复杂度 O(NlogK)，空间复杂度 O(K)

```python
class Solution(object):
    def findKthLargest(self, nums, k):
        """
        :type nums: List[int]
        :type k: int
        :rtype: int
        """
        length = len(nums)
        # 构建大顶堆
        for i in reversed(range(0, length / 2)):
            self.adjustHeap(nums, i, length)
        
        count = 0
        for j in reversed(range(0, length)):
            count = count + 1
            if count == k:
                return nums[0]
            self.swap(nums, 0, j)
            length = length - 1
            self.adjustHeap(nums, 0, length)
            
        
    def adjustHeap(self, nums, i, length):
        while True:
            k = i * 2 + 1 #left node
            if k >= length:
                return
            if k + 1 < length and nums[k+1] > nums[k]:
                k = k + 1
            if nums[k] > nums[i]:
                self.swap(nums, i, k)
                i = k
            else:
                return
                
    def swap(self, nums, i, j):
        temp = nums[i]
        nums[i] = nums[j]
        nums[j] = temp
```

之前傻逼了，全部排序完才弹出。

```python
# -*- coding: utf-8 -*-
class Solution(object):
    def findKthLargest(self, nums, k):
        """
        :type nums: List[int]
        :type k: int
        :rtype: int
        """
        # 构建堆
        length = len(nums)
        for i in reversed(range(0, length/2)):
            nums = self.adjustHeap(nums, i, length)
        # 交换元素
        for j in reversed(range(0, length)):
            nums = self.swap(nums, j, 0)
            length = length - 1
            nums = self.adjustHeap(nums, 0, length)
        return nums[-k]

    def adjustHeap(self, nums, i, length):
        """
        :type nums: List[int] heap
        :type i: int 当前节点
        :type length: int heap长度
        """
        while True:
            k = i * 2 + 1
            if k >= length:
                break
            if (k + 1 < length) and (nums[k + 1] > nums[k]):
                k = k + 1
            if nums[k] > nums[i]:
                self.swap(nums, k, i)
                i = k
            else:
                break
        return nums

    def swap(self, nums, a, b):
        """
        :param nums: List[int] heap
        :param a: int
        :param b: int
        :return: List[int]
        """
        temp = nums[a]
        nums[a] = nums[b]
        nums[b] = temp
        return nums
```

## 347. 前K个高频元素

[原题链接](https://leetcode-cn.com/problems/top-k-frequent-elements/)

### 思路

1. 使用哈希表对每个元素出现的次数进行统计
2. 根据元素出现次数进行排序处理

根据题目对复杂度的要求，选择了堆排序。需要维护一个大顶堆。

```python
class Solution(object):
    def topKFrequent(self, nums, k):
        """
        :type nums: List[int]
        :type k: int
        :rtype: List[int]
        """
        count_dict = dict()
        for n in nums:
            count_dict[n] = count_dict.get(n, 0) + 1
        
        count_list = list()
        for key in count_dict:
            count_list.append((key, count_dict[key]))
                    
        length = len(count_list)
        for i in range(length/2 - 1, -1, -1):
            self.adjust_heap(count_list, i, length)
                    
        res = list()
        count = 0
        for j in range(length - 1, -1, -1):
            count += 1
            res.append(count_list[0][0])
            # 将堆顶元素弹出
            self.swap(count_list, 0, j)
            if count == k:
                return res
            # 维护堆
            length -= 1
            self.adjust_heap(count_list, 0, length)
            
    def adjust_heap(self, nums, i, length):
        """
        维护堆
        """
        while True:
            k = i * 2 + 1
            if k >= length:
                return
            # 左右节点取较小数
            if k + 1 < length and nums[k + 1][1] > nums[k][1]:
                k += 1
            if nums[k][1] > nums[i][1]:
                self.swap(nums, k, i)
                i = k
            else:
                return
                
    def swap(self, nums, i, j):
        """
        元素交换
        """
        tmp = nums[i]
        nums[i] = nums[j]
        nums[j] = tmp
```

### 复杂度

- 时间复杂度：`O(nlogn)`
- 空间复杂度：`O(n)`