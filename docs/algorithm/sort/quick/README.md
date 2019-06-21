## 75. Sort Colors

https://leetcode.com/problems/sort-colors/description/

### 方法一：快排

```python
# -*- coding: utf-8 -*-


class Solution(object):
    def sortColors(self, nums):
        """
        :type nums: List[int]
        :rtype: void Do not return anything, modify nums in-place instead.
        """
        self.quickSort(nums, 0, len(nums)-1)
        #print nums

    def quickSort(self, nums, left, right):
        if left > right:
            return
        i = left
        j = right
        tmp = nums[i]
        while i != j:
            while nums[j] >= tmp and j > i:
                j = j - 1
            while nums[i] <= tmp and i < j:
                i = i + 1
            if i < j:
                t = nums[i]
                nums[i] = nums[j]
                nums[j] = t
        # 交换基准数
        nums[left] = nums[i]
        nums[i] = tmp
        self.quickSort(nums, left, i-1)
        self.quickSort(nums, i+1, right)
```

### 方法二：冒泡排序

```python
# -*- coding: utf-8 -*-


class Solution(object):
    def sortColors(self, nums):
        """
        :type nums: List[int]
        :rtype: void Do not return anything, modify nums in-place instead.
        """
        #self.quickSort(nums, 0, len(nums)-1)
        self.popSort(nums)


    def popSort(self, nums):
        i = 0
        j = len(nums) - 1
        while i < j:
            for index in range(0, j):
                a = nums[index]
                b = nums[index + 1]
                if a > b:
                    nums[index + 1] = a
                    nums[index] = b
            j = j - 1
```

### 方法三：选择排序

```python
# -*- coding: utf-8 -*-


class Solution(object):
    def sortColors(self, nums):
        """
        :type nums: List[int]
        :rtype: void Do not return anything, modify nums in-place instead.
        """
        self.selectSort(nums)

    def selectSort(self, nums):
        i = 0
        while i < len(nums):
            index = 0
            min = nums[i]
            for j in range(i, len(nums)):
                if nums[j] < min:
                    min = nums[j] #找到最小值
                    index = j
            if i != j:
                tmp = nums[i]
                nums[i] = min
                nums[index] = tmp
                i = i + 1
```