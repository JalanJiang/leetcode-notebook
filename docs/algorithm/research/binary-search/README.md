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

二分法递归写法：

思想：转变为求**第 K 小数**。

Tips：因为长度要分奇偶讨论，因此直接取 `(m + n + 1) / 2` 与 `(m + n + 2) / 2` 的平均值，奇偶就一样了。

```python
class Solution:
    def findMedianSortedArrays(self, nums1: List[int], nums2: List[int]) -> float:
        def findKthElement(arr1, arr2, k):
            # 默认 2 比 1 长
            length1, length2 = len(arr1), len(arr2)
            if length1 > length2:
                return findKthElement(arr2, arr1, k)

            # 如果 arr1 没有元素，直接返回 arr2 的第 k 小
            if length1 == 0:
                return arr2[k - 1] 

            # 等于 1 时单独处理
            if k == 1:
                return min(arr1[0], arr2[0])

            # 两者都有元素，对比 k/2 位置，但不超过数组长度
            mid1 = min(k//2, length1) - 1
            mid2 = min(k//2, length2) - 1
            if arr1[mid1] > arr2[mid2]:
                # 删除 arr 的部分
                return findKthElement(arr1, arr2[mid2+1:], k - mid2 - 1)
            else:
                return findKthElement(arr1[mid1+1:], arr2, k - mid1 - 1)

        l1, l2 = len(nums1), len(nums2)
        left, right = (l1 + l2 + 1)//2, (l1 + l2 + 2)//2
        return (findKthElement(nums1, nums2, left) + findKthElement(nums1, nums2, right)) / 2
```


## 34. 在排序数组中查找元素的第一个和最后一个位置

[原题链接](https://leetcode-cn.com/problems/find-first-and-last-position-of-element-in-sorted-array/)

### 解一：二分 + 线性查找

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

### 解二：两侧都使用二分查找

```python
class Solution:
    def searchRange(self, nums: List[int], target: int) -> List[int]:
        res = [-1, -1]
        if len(nums) == 0:
            return res

        left = 0
        right = len(nums) - 1
        while left < right:
            mid = (left + right) // 2
            if nums[mid] < target:
                left = mid + 1
            elif nums[mid] > target:
                right = mid - 1
            else:
                right = mid
        if nums[left] == target:
            res[0] = left

        left = 0
        right = len(nums) # 只有一个数的时候需要取到右边界
        while left < right:
            mid = (left + right) // 2
            if nums[mid] < target:
                left = mid + 1
            elif nums[mid] > target:
                right = mid
            else:
                left = mid + 1
        if nums[left - 1] == target:
            res[1] = left - 1

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

## 50. Pow(x, n)

[原题链接](https://leetcode-cn.com/problems/powx-n/)

### 思路：二分

利用分治的思想，$x^2n$ 均可以写作 $x^n * x^n$。

递归：

```go
func myPow(x float64, n int) float64 {
    if n >= 0 {
        return quickMul(x, n)
    }
    return 1 / quickMul(x, -n)
}

func quickMul(x float64, n int) float64 {
    if n == 0 {
        return 1
    }
    if n == 1 {
        return x
    }
    y := quickMul(x, n / 2)
    if n % 2 == 0 {
        return y * y
    } else {
        return y * y * x
    }
}
```

## 69. x 的平方根

[原题链接](https://leetcode-cn.com/problems/sqrtx/comments/)

### 思路

二分查找，注意边界值的处理。

<!-- tabs:start -->

#### **Python**

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

#### **Go**

```go
func mySqrt(x int) int {
    left := 0
    right := x
    ans := 0
    for left <= right {
        mid := (left + right) / 2
        // fmt.Println(mid)
        if mid * mid <= x {
            // 可能出现结果
            ans = mid
            left = mid + 1
        } else {
            right = mid - 1
        }
    }
    return ans
}
```

<!-- tabs:end -->

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
                    right = middle - 1
                elif  matrix[i][middle] < target:
                    left = middle + 1
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

## 153. 寻找旋转排序数组中的最小值

[原题链接](https://leetcode-cn.com/problems/find-minimum-in-rotated-sorted-array/)

### 思路

```python
class Solution:
    def findMin(self, nums: List[int]) -> int:
        left = 0
        right = len(nums) - 1
        while left < right:
            mid = (left + right) // 2
            if nums[mid] < nums[right]:
                # mid 可能是最小值
                right = mid
            else:
                # 最小值在 mid 右侧
                left = mid + 1
        return nums[left]
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

## 367. 有效的完全平方数

[原题链接](https://leetcode-cn.com/problems/valid-perfect-square/)

### 解一：暴力破解

#### **Python**

```python
class Solution:
    def isPerfectSquare(self, num: int) -> bool:
        i = 1
        while i * i <= num:
            if i * i == num:
                return True
            i += 1
        
        return False
```

#### **Go**

```go
func isPerfectSquare(num int) bool {
    i := 1
    for i * i <= num {
        if i * i == num {
            return true
        }
        i++
    }
    return false
}
```

### 解二：二分查找

#### **Python**

```python
class Solution:
    def isPerfectSquare(self, num: int) -> bool:
        left = 1
        right = num

        while left < right:
            mid = (left + right) >> 1
            tmp = mid * mid
            if tmp < num:
                left = mid + 1
            elif tmp > num:
                right = mid - 1
            else:
                return True
        
        return left * left == num
```

缩小查找范围：`right = num / 2`

```python
class Solution:
    def isPerfectSquare(self, num: int) -> bool:
        if num < 2:
            return True
        left = 1
        right = num // 2
        
        while left <= right:
            mid = (left + right) // 2
            tmp = mid * mid
            if tmp == num:
                return True
            elif tmp < num:
                left = mid + 1
            else:
                right = mid - 1
        return False
```

#### **Go**

```go
func isPerfectSquare(num int) bool {
    left := 0
    right := num

    for left < right {
        mid := (left + right) >> 1
        tmp := mid * mid
        if tmp < num {
            left = mid + 1
        } else if tmp > num {
            right = mid - 1
        } else {
            return true
        }
    }

    return left * left == num
}
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

## 475. 供暖器

[原题链接](https://leetcode-cn.com/problems/heaters/)

### 思路

题目要求计算**供暖器的最小加热半径**，即需要计算：

1. 距离每间房屋最近的供暖器距离
2. 这些距离中的**最长距离**即为最小加热半径

### 如何获得最近的供暖器？

供暖器和房屋都在一条水平线上，因此我们可以对两者进行排序，然后使用**二分查找**来搜索离房屋最近的供暖器。

由二分查找得出的供暖器位置可能存在三种情况：

1. 和房子的位置相同：说明可以直接供暖，半径 = 0
2. 小于房子的位置：该供暖器在房子的左侧，此时求出的供暖器是距离房子最近的供暖器
3. 大于房子的位置：该供暖器在房子的右侧，需要计算房子左侧的供暖器和房子的距离，两者取较小值

### 具体实现

<!-- tabs:start -->

#### **Python**

```python
class Solution:
    def findRadius(self, houses: List[int], heaters: List[int]) -> int:
        houses.sort()
        heaters.sort()
        res = 0
        # 每个房子被供暖需要的最小半径
        for house in houses:

            left = 0
            right = len(heaters) - 1
            while left < right:
                middle = left + (right - left) // 2
                if heaters[middle] < house:
                    left = middle + 1
                else:
                    right = middle
            
            # 供暖器和房子的位置相等
            if heaters[left] == house:
                house_res = 0
            # 此时是最接近房子的供暖器
            elif heaters[left] < house:
                house_res = house - heaters[left]
            # 供暖器不一定是最接近房子的
            else:
                # 第一个供暖器
                if left == 0:
                    house_res = heaters[left] - house
                else:
                    # 这个供暖器和前一个供暖期哪个更接近
                    house_res = min(heaters[left] - house, house - heaters[left - 1])

            res = max(house_res, res)

        return res
```

#### **Go**

```go
func findRadius(houses []int, heaters []int) int {
    sort.Ints(houses)
    sort.Ints(heaters)
    res := 0
    for _, house := range houses {
        left := 0
        right := len(heaters) - 1
        houseRes := 0
        // 二分查找
        for left < right {
            middle := left + (right - left) / 2
            if heaters[middle] < house {
                left = middle + 1
            } else {
                right = middle
            }
        }

        if heaters[left] == house {
            houseRes = 0
        } else if heaters[left] < house { // 供暖器在左侧
            houseRes = house - heaters[left]
        } else { // 供暖器在右侧
            if left == 0 {
                houseRes = heaters[left] - house
            } else {
                houseRes = getMin(heaters[left] - house, house - heaters[left - 1])
            }
        }

        res = getMax(res, houseRes)
    }

    return res
}

func getMin(a int, b int) int {
    if a < b {
        return a
    } else {
        return b
    }
}

func getMax(a int, b int) int {
    if a > b {
        return a
    } else {
        return b
    }
}
```

<!-- tabs:end -->

## 658. 找到 K 个最接近的元素

[原题链接](https://leetcode-cn.com/problems/find-k-closest-elements/)

### 解一：二分查找

在 `[0, length - k]` 区间查找最终答案的最左边界，对比方法是比较 `arr[mid] - x`（记作 `diff_left`） 和 `arr[mid + k] - x` （记作 `diff_right`）的大小：

1. `diff_left < diff_right`：说明此时 `arr[mid]` 距离 `x` 更近些，可以继续向左边扩展（但保留此 `mid` 位置），`right = mid`
2. `diff_left == diff_right`：此时两处一样近，可以继续向左边扩展（但保留此 `mid` 位置），`right = mid`
3. `diff_left > diff_right`：说明 `arr[mid + k]` 距离 `x` 更近些，向右边扩展，`left = mid + 1`

```python
class Solution:
    def findClosestElements(self, arr: List[int], k: int, x: int) -> List[int]:
        length = len(arr)
        left = 0
        right = length - k
        # 找到距离 k 最近的左边界
        while left < right:
            mid = (left + right) // 2
            left_diff = x - arr[mid]
            right_diff = arr[mid + k] - x
            print(left, right, left_diff, right_diff)
            if left_diff < right_diff:
                # 左边离 x 比较近，区间可以继续向左扩张
                right = mid
                # pass
            elif left_diff == right_diff:
                # 两边一样近，可以往左（取小值）
                right = mid
            else:
                # 右边离 x 比较近，区间向右扩张
                left = mid + 1

        return arr[left:left + k]
```

## 744. 寻找比目标字母大的最小字母

[原题链接](https://leetcode-cn.com/problems/find-smallest-letter-greater-than-target/)

### 思路

给你一个**排序后的字符列表**，和一个**目标字母**，要查找比这个字母**大**的**最小字母**，很容易就想到**二分查找**。

因为「在比较时，字母是依序循环出现的」，所以我们可以先处理特殊情况：**当我们要查找的字母大于等于列表的最后一个字母时，直接返回列表第一字母**。

下面说说二分查找。

首先定义好模板：

```python
left = 0
right = length

while left < right:
    mid = (left + rigt) // 2
    letter = letters[mid]
    # 其他逻辑……
```

此处我们取到的中间值 `letter` 与 `target` 存在三种大小关系：

- `letter == target`：两者相等。此时说明我们已经找到了目标字母，但我们要找的是比目标字母大的最小字母，所以我们需要把查找范围变成 `mid` 右侧，继续向更大的字母范围处查找，即 `left = mid + 1`
- `letter < target`：当前字母小于目标字母，说明目标值在 `mid` 右侧，同上 `left = mid + 1`
- `letter > target`：当前字母大于目标字母。此时当前字母可能就是我们要找的最终答案了，但也有可能答案在左侧范围，所以 `right = mid`，**保留当前字母位置**，且继续向左侧查找

### 具体实现

```python
class Solution:
    def nextGreatestLetter(self, letters: List[str], target: str) -> str:
        length = len(letters)
        # 循环的特殊情况
        if letters[length - 1] <= target:
            return letters[0]
        left = 0
        right = length - 1
        while left < right:
            mid = (left + right) // 2
            letter = letters[mid]
            if letter == target:
                # 等于目标值，往右找
                left = mid + 1
            elif letter < target:
                # 比目标值小，往右找
                left = mid + 1
            else:
                # 比目标值大，可能就是要找的数！
                right = mid
        return letters[left]
```

## 1095. 山脉数组中查找目标值

[原题链接](https://leetcode-cn.com/problems/find-in-mountain-array/)

### 思路

核心思想二分法：

1. 通过二分法寻找峰值
2. 二分法在峰值左侧寻找目标
3. 如果目标不在左侧，使用二分法在峰值右侧寻找目标

```python
# """
# This is MountainArray's API interface.
# You should not implement it, or speculate about its implementation
# """
#class MountainArray:
#    def get(self, index: int) -> int:
#    def length(self) -> int:

class Solution:
    def findInMountainArray(self, target: int, mountain_arr: 'MountainArray') -> int:
        length = mountain_arr.length()
        # print(length)
        # 找到峰值
        left = 0
        right = length - 1
        while left < right:
            mid = (left + right) // 2
            if mountain_arr.get(mid + 1) > mountain_arr.get(mid):
                # 峰值在右侧
                left = mid + 1
            else:
                right = mid
        # 峰值
        peak = left

        # 左侧二分查找
        left = 0
        right = peak
        while left <= right:
            mid = (left + right) // 2
            cur = mountain_arr.get(mid)
            if cur == target:
                return mid
            elif cur > target:
                right = mid - 1
            else:
                left = mid + 1

        # 右边二分查找：递减数组
        left = peak + 1
        right = length - 1
        while left <= right:
            mid = (left + right) // 2
            cur = mountain_arr.get(mid)
            if cur == target:
                return mid
            elif cur > target:
                left = mid + 1
            else:
                right = mid - 1
        
        return -1
```