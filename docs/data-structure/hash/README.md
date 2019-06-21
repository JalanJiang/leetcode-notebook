## 1. 两数之和

[原题链接](https://leetcode-cn.com/problems/two-sum/submissions/)

### 解法一

利用哈希表，时间复杂度 O(n)，空间复杂度 O(n)。

- 用 HashMap 存储数组元素和索引的映射
- 在访问到 nums[i] 时，判断 HashMap 中是否存在 target - nums[i]
    - 如果存在说明：target - nums[i] 所在的索引和 i 就是要找的两个数
    - 如果不存在：将 nums 加入 HashMap

```python
class Solution(object):
    def twoSum(self, nums, target):
        """
        :type nums: List[int]
        :type target: int
        :rtype: List[int]
        """
        hash_dict = dict()
        res_list = list()
        
        for key, value in enumerate(nums):
            other = target - value
            if other in hash_dict:
                res_list.append(hash_dict[other])
                res_list.append(key)
                break
            else:
                hash_dict[value] = key
        
        return res_list
```

### 解法二

时间复杂度 O(nlogn)，空间复杂度 O(1)。

- 排序
- 二分查找




## 128. 最长连续序列

[原题链接](https://leetcode-cn.com/problems/longest-consecutive-sequence/submissions/)

### 解法一

题目要求 O(n) 复杂度。

- 用哈希表存储每个**端点值**对应连续区间的长度
- 若数已在哈希表中：跳过不做处理
- 若是新数加入：
    - 取出其左右相邻数已有的连续区间长度 left 和 right
    - 计算当前数的区间长度为：cur_length = left + right + 1
    - 根据 cur_length 更新最大长度 max_length 的值
    - 更新区间两端点的长度值

```python
class Solution(object):
    def longestConsecutive(self, nums):
        hash_dict = dict()
        
        max_length = 0
        for num in nums:
            if num not in hash_dict:
                left = hash_dict.get(num - 1, 0)
                right = hash_dict.get(num + 1, 0)
                
                cur_length = 1 + left + right
                if cur_length > max_length:
                    max_length = cur_length
                
                hash_dict[num] = cur_length
                hash_dict[num - left] = cur_length
                hash_dict[num + right] = cur_length
                
        return max_length
```

### 解法二：超时的垃圾解法

用哈希表存了每个数出现的次数，果断超时。

```python
class Solution(object):
    def longestConsecutive(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        hash_dict = dict()
        for num in nums:
            if num in hash_dict:
                hash_dict[num] = hash_dict[num] + 1
            else:
                hash_dict[num] = 1
        
        max_length = 0
        for key in hash_dict:
            cur = key
            count = 0
            while cur in hash_dict:
                count = count + 1
                cur = cur + 1
            if count > max_length:
                max_length = count
        
        return max_length
```


## 217. 存在重复元素

[原题链接](https://leetcode-cn.com/problems/contains-duplicate/submissions/)

### 思路

哈希表

```python
class Solution(object):
    def containsDuplicate(self, nums):
        """
        :type nums: List[int]
        :rtype: bool
        """
        hash_map = dict()
        
        for num in nums:
            if num in hash_map:
                return True
            hash_map[num] = 1
        
        return False
```

也可以用 set，一样的

```python
class Solution:
    def containsDuplicate(self, nums):
        """
        :type nums: List[int]
        :rtype: bool
        """
        set1 = set(nums)
        if len(set1) == len(nums):
            return False
        else:
            return True
```


## 350. 两个数组的交集 II

[原题链接](https://leetcode-cn.com/problems/intersection-of-two-arrays-ii/)

### 解法一

使用 hash 表的方式。

空间复杂度 `O(n)`，时间复杂度 `O(n)`。

```python
class Solution(object):
    def intersect(self, nums1, nums2):
        """
        :type nums1: List[int]
        :type nums2: List[int]
        :rtype: List[int]
        """
        hash_map = dict()
        
        for n in nums1:
            if n not in hash_map:
                hash_map[n] = 1
            else:
                hash_map[n] = hash_map[n] + 1
        
        res = list()
        for n in nums2:
            if n in hash_map and hash_map[n] != 0:
                res.append(n)
                hash_map[n] = hash_map[n] - 1
        
        return res
```

### 解法二

排序 + 双指针，不需要额外空间。




## 454. 四数相加 II

[原题链接](https://leetcode-cn.com/problems/4sum-ii/)

### 思路

1. 遍历 `A` 和 `B` 所有元素和的组合情况，并记录在 `ab_map` 中，`ab_map` 的 `key` 为两数和，`value` 为该两数和出现的次数
2. 遍历 `C` 和 `D` 所有元素和的组合情况，取和的负值判断其是否在 `ab_map` 中，若存在则取出 `ab_map` 对应的 `value` 值，`count = count + value`

```python
class Solution(object):
    def fourSumCount(self, A, B, C, D):
        """
        :type A: List[int]
        :type B: List[int]
        :type C: List[int]
        :type D: List[int]
        :rtype: int
        """
        count = 0
        ab_map = dict()
        
        for a in A:
            for b in B:
                ab_map[a + b] = ab_map.get(a + b, 0) + 1
            
        for c in C:
            for d in D:
                s = -(c + d)
                if s in ab_map:
                    count += ab_map[s]
        
        return count
```


## 594. 最长和谐子序列

[原题链接](https://leetcode-cn.com/problems/longest-harmonious-subsequence/submissions/)

### 思路

- 数值出现个数放入 hash 表
- 计算相差值为 1 的两个数出现的次数

```python
class Solution(object):
    def findLHS(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        hash_dict = dict()
        for num in nums:
            if num in hash_dict:
                hash_dict[num] = hash_dict[num] + 1
            else:
                hash_dict[num] = 1
                
        max_length = 0
        
        for key in hash_dict:
            if key - 1 in hash_dict:
                cur_length = hash_dict[key] + hash_dict[key - 1]
                if cur_length > max_length:
                    max_length = cur_length
        
        return max_length
```


