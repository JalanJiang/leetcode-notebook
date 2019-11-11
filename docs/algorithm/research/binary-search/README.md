## 4. 寻找两个有序数组的中位数

[原题链接](https://leetcode-cn.com/problems/median-of-two-sorted-arrays/)

### 解一

`O(m + n)` 的算法，不满足题目的要求。

拿到题目首先想到的是归并排序“并”的过程，于是就直接写了。

```python
#
# @lc app=leetcode.cn id=4 lang=python
#
# [4] 寻找两个有序数组的中位数
#
class Solution(object):
    def findMedianSortedArrays(self, nums1, nums2):
        """
        :type nums1: List[int]
        :type nums2: List[int]
        :rtype: float
        """
        nums = list()

        length1 = len(nums1)
        length2 = len(nums2)

        i = 0
        j = 0

        while i < length1 and j < length2:
            n1 = nums1[i]
            n2 = nums2[j]

            if n1 < n2:
                nums.append(n1)
                i += 1
            else:
                nums.append(n2)
                j += 1

        while i < length1:
            nums.append(nums1[i])
            i += 1
        
        while j < length2:
            nums.append(nums2[j])
            j += 1

        length = len(nums)
        if length % 2 == 0:
            b = length / 2 
            a = b - 1
            res = (nums[a] + nums[b]) / 2.0
        else:
            index = (length - 1) / 2
            res = nums[index]
            
        return res
```

### 解二

`O(log(m + n))` 二分法。

```python
class Solution(object):
    def findMedianSortedArrays(self, nums1, nums2):
        """
        :type nums1: List[int]
        :type nums2: List[int]
        :rtype: float
        """
        length1 = len(nums1)
        length2 = len(nums2)
        
        if length1 > length2:
            return self.findMedianSortedArrays(nums2, nums1)
        
        left = 0
        right = length1
        
        k = (length1 + length2 + 1) // 2
        
        while left < right:
            m1 = left + (right - left) // 2
            m2 = k - m1
            if nums1[m1] < nums2[m2 - 1]:
                left = m1 + 1
            else:
                right = m1
        
        m1 = left
        m2 = k - m1
        
        if m1 > 0 and m2 > 0:
            c1 = max(nums1[m1 - 1], nums2[m2 - 1])
        else:
            if m1 > 0:
                c1 = nums1[m1 - 1]
            else:
                c1 = nums2[m2 - 1]
                
        if (length1 + length2) % 2 == 1:
            return c1

        if m1 < length1 and m2 < length2:
            c2 = min(nums1[m1], nums2[m2])
        else:
            if m1 < length1:
                c2 = nums1[m1]
            else:
                c2 = nums2[m2]
        
        return (c1 + c2) / 2.0
```


## 34. 在排序数组中查找元素的第一个和最后一个位置

[原题链接](https://leetcode-cn.com/problems/find-first-and-last-position-of-element-in-sorted-array/)

### 思路

先使用二分查找法找到 target 值，然后从找到 target 值的位置往左右两侧延伸，直到寻找到两侧的边界值。

```python
class Solution(object):
    def searchRange(self, nums, target):
        """
        :type nums: List[int]
        :type target: int
        :rtype: List[int]
        """
        length = len(nums)
        left = 0
        right = length - 1
        res = [-1, -1]

        while left <= right:
            mid = left + (right - left) // 2
            if nums[mid] == target:
                left = mid
                right = mid
                # 左侧边界往左延伸
                while left > 0 and nums[left - 1] == nums[left]:
                    left -= 1
                # 右侧边界往右延伸
                while right < length - 1 and nums[right + 1] == nums[right]:
                    right += 1
                res[0] = left
                res[1] = right
                break
            elif nums[mid] > target:
                right = mid - 1
            else:
                left = mid + 1

        return res
```


## 35. 搜索插入位置

[原题链接](https://leetcode-cn.com/problems/search-insert-position/)

### 解法一：顺序查找

```python
class Solution(object):
    def searchInsert(self, nums, target):
        """
        :type nums: List[int]
        :type target: int
        :rtype: int
        """
        i = 0
        while i < len(nums):
            if nums[i] < target:
                i = i + 1
            else:
                break
        return i
```

### 解法二：二分查找

```python
class Solution(object):
    def searchInsert(self, nums, target):
        """
        :type nums: List[int]
        :type target: int
        :rtype: int
        """
        length = len(nums)
        
        left = 0
        right = length - 1
        
        while left <= right:
            mid = (left + right) / 2
            if nums[mid] > target:
                right = mid - 1
            elif nums[mid] < target:
                left = mid + 1
            else:
                return mid
        return left
```


## 69. x 的平方根

[原题链接](https://leetcode-cn.com/problems/sqrtx/comments/)

### 思路

二分查找，注意边界值的处理。

```python
class Solution(object):
    def mySqrt(self, x):
        """
        :type x: int
        :rtype: int
        """
        i = 0
        j = x
        
        while i <= j:
            mid = (i + j) // 2
            num = mid * mid
            if num > x:
                if (mid-1)*(mid-1) < x:
                    return mid - 1
                j = mid - 1
            elif num < x:
                if (mid + 1) * (mid + 1) > x:
                    return mid
                i = mid + 1
            else:
                return mid

```

ps：看评论有很秀的牛顿迭代法，有空研究下。

## 74. 搜索二维矩阵

[原题链接](https://leetcode-cn.com/problems/search-a-2d-matrix/)

### 解法一

逐行进行二分查找。

```python
class Solution:
    def searchMatrix(self, matrix: List[List[int]], target: int) -> bool:
        m = len(matrix)
        if m == 0:
            return False
        n = len(matrix[0])
        if n == 0:
            return False
        
        for i in range(m):
            left = 0
            right = n - 1
            
            if matrix[i][right] < target:
                continue
            if matrix[i][left] > target:
                return False
                
            if matrix[i][right] == target or matrix[i][left] == target:
                return True
            
            while left <= right:
                middle = left + (right - left) // 2
                if matrix[i][middle] > target:
                    right -= 1
                elif  matrix[i][middle] < target:
                    left += 1
                else:
                    return True
            
        return False
```

### 解法二

将矩阵拉成直线后进行二分查找。

```go
func searchMatrix(matrix [][]int, target int) bool {
    m := len(matrix)
    if m == 0 {
        return false
    }
    n := len(matrix[0])
    if n == 0 {
        return false
    }
    
    length := m * n
    left := 0
    right := length - 1
    
    for left <= right {
        middle := left + (right - left) / 2
        // fmt.Printf("%d", middle)
        row := middle / n
        column := middle % n
        num := matrix[row][column]
        
        if num > target {
            right = middle - 1
        } else if num < target {
            left = middle + 1
        } else {
            return true
        }
    }
    
    return false
}
```

## 162. 寻找峰值

[原题链接](https://leetcode-cn.com/problems/find-peak-element/)

### 思路

二分查找。

```python
class Solution(object):
    def findPeakElement(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        
        left = 0
        right = len(nums) - 1
        
        while left + 1 < right:
            mid = (left + right) / 2
            if nums[mid - 1] < nums[mid]:
                # 峰值在 mid 右侧
                left = mid
            else:
                # 峰值在 mid 左侧
                right = mid
        
        if nums[left] > nums[right]:
            return left
        else:
            return right
```

### 错误的写法

一开始理解错题目了，直接查找最大值居然过了。。。

```python
class Solution(object):
    def findPeakElement(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        m = -float('inf')
        m_index = -1
        for i in range(len(nums)):
            t = nums[i]
            if t > m:
                m = t
                m_index = i
        return m_index
```


## 278. 第一个错误的版本

[原题链接](https://leetcode-cn.com/problems/first-bad-version/comments/)

### 顺序

顺序查找，导致 MemoryError

```python
# The isBadVersion API is already defined for you.
# @param version, an integer
# @return a bool
# def isBadVersion(version):

class Solution(object):
    def firstBadVersion(self, n):
        """
        :type n: int
        :rtype: int
        """
        for i in range(1, n + 1):
            if isBadVersion(i) == True:
                return i
```

### 二分

```python
# The isBadVersion API is already defined for you.
# @param version, an integer
# @return a bool
# def isBadVersion(version):

class Solution(object):
    def firstBadVersion(self, n):
        """
        :type n: int
        :rtype: int
        """
        left = 0
        right = n - 1
        while left <= right:
            mid = (left + right) // 2
            if isBadVersion(mid) == True:
                right = mid - 1
            else:
                left = mid + 1
        return left
```

## 374. 猜数字大小

[原题链接](https://leetcode-cn.com/problems/guess-number-higher-or-lower/)

### 思路

说是一道算法题，但感觉是道阅读理解题。

初看题目比较懵逼，题目的意思是：

- 提供了一个预先定义好的接口 `guess(int num)`
- 这个接口回返回 3 个结果：
  1. `-1`：代表你猜测的数字大了
  2. `1`：代表你猜测的数字小了
  3. `0`：代表你猜对了 `( •̀ᄇ• ́)ﻭ✧`

本质就是一个在 `1 ~ n` 范围内查找某个特定数的过程，用二分来做。

<!-- tabs:start -->

#### ** Python **

```python
# The guess API is already defined for you.
# @param num, your guess
# @return -1 if my number is lower, 1 if my number is higher, otherwise return 0
# def guess(num):

class Solution(object):
    def guessNumber(self, n):
        """
        :type n: int
        :rtype: int
        """
        left = 1
        right = n
        while left <= right:
            mid = left + (right - left) // 2
            # 猜测结果
            flag = guess(mid)
            if flag == -1:
                # 猜大了
                right = mid - 1
            elif flag == 1:
                # 猜小了
                left = mid + 1
            else:
                # 猜对了
                return mid
```

#### ** Java **

```java
/* The guess API is defined in the parent class GuessGame.
   @param num, your guess
   @return -1 if my number is lower, 1 if my number is higher, otherwise return 0
      int guess(int num); */

public class Solution extends GuessGame {
    public int guessNumber(int n) {
        int start = 1;
        int end = n;
        while(start < end) {
            int mid = start + (end - start) / 2;
            int result = guess(mid);
            if (result == 0) {
                return mid;
            } else if (result == -1) {
                end = mid - 1;
            } else if (result == 1) {
                start = mid + 1;
            }
        }
        
        return end;
    }
}
```

<!-- tabs:end -->