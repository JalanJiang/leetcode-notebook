### Sliding Window Approach 


```
1. Fixed window length k
2. dynamic
3. dynamic with hashmap
4. max update during window increase, 
   min update during window size decrease
```

- **Longest Continuous Increasing Subsequence** | LeetCode 674.

```
class Solution:
    def findLengthOfLCIS(self, nums: List[int]) -> int:
        res = left = 0
        for right in range(len(nums)):
            if right and nums[right]<=nums[right-1]:
                left = right
            res = max(res, right - left + 1)
        return [res]
```


-  **Permutation in String** | LeetCode 567. 
 

 
```
# the nice thing about this pieces of code is that it represents \
# fix window_size sliding window technique.

class Solution:
    def checkInclusion(self, s1: str, s2: str) -> bool:
        l1 = len(s1)
        l2 = len(s2)
        if s1 == s2:
            return True
        if l1 > l2:
            return False

        dict1 = dict(zip(list('abcdefghijklmnopqrstuvwxyz'), [0]*26))
        dict2 = dict(zip(list('abcdefghijklmnopqrstuvwxyz'), [0]*26))

        for i in range(l1):
            dict1[s1[i]] += 1
            dict2[s2[i]] += 1
        
        if dict1 == dict2:
            return True
        
        for i in range(l2 - l1):
            dict2[s2[i]] -= 1
            dict2[s2[i + l1]] += 1
            if dict2 == dict1:
                return True
        return False
```

- Maximum Average Subarray I |  643.
```
# 定长的先处理0-k-1，在处理k-length-1，用 for range 处理

class Solution:
    def findMaxAverage(self, nums: List[int], k: int) -> float:
        res = 0.0
        for i in range(k):
            res += nums[i]
        max_ = res
        for i in range(k, len(nums)):
            res += nums[i]-nums[i-k]
            max_ = max(max_,res)

        return max_/k
```
- [https://medium.com/@zengruiwang/sliding-window-technique-360d840d5740](https://medium.com/@zengruiwang/sliding-window-technique-360d840d5740)
- [https://www.youtube.com/watch?v=MK-NZ4hN7rs](https://www.youtube.com/watch?v=MK-NZ4hN7rs)



## 219. 存在重复元素 II

[原题链接](https://leetcode-cn.com/problems/contains-duplicate-ii/)

### 思路

滑动窗口

```python
class Solution(object):
    def containsNearbyDuplicate(self, nums, k):
        """
        :type nums: List[int]
        :type k: int
        :rtype: bool
        """
        if len(nums) <= 1 or k <= 0:
            return False
        
        record = set()
        for i in range(len(nums)):
            num = nums[i]
            
            if num in record:
                return True
            
            record.add(num)
            if len(record) >= k + 1:
                record.remove(nums[i - k])
            
        return False
```

## 239. 滑动窗口最大值

[原题链接](https://leetcode-cn.com/problems/sliding-window-maximum/)

### 解一：暴力

不断对比得出每个窗口的最大值。



```python
class Solution:
    def maxSlidingWindow(self, nums: List[int], k: int) -> List[int]:
        length = len(nums)
        if length == 0 or k == 0:
            return []
        max_num = max(nums[:k])
        res = [max_num] 
        for i in range(k, length):
            if nums[i] > max_num:
                max_num = nums[i]
            else:
                if nums[i - k] == max_num:
                    max_num = max(nums[i - k + 1:i+1])
            res.append(max_num)
            
        return res
```

### 解二：动态规划

把数组按 k 从左到右分为 n 个窗口。

- `left[i]` 表示从左到右遍历时从窗口开始位置（左边界）到下标 `i` 窗口内的最大值
- `right[i]` 表示从右到左遍历时从窗口开始位置（右边界）到下标 `i` 窗口内的最大值

当窗口移动到下标 `x` 位置时，要求的结果为 `max(right[x], left[x + k - 1])`。

```python
class Solution:
    def maxSlidingWindow(self, nums: List[int], k: int) -> List[int]:
        res = []
        length = len(nums)
        if length == 0 or k == 0:
            return []
        
        # 构造 left
        left = [0 for _ in range(length)]
        for i in range(length):
            if i % k == 0:
                left[i] = nums[i]
            else:
                left[i] = max(left[i - 1], nums[i])
                                
        # 构造 right
        right = [0 for _ in range(length)]
        for i in range(length - 1, -1, -1):
            if i % k == 0 or i == length - 1:
                right[i] = nums[i]
            else:
                right[i] = max(right[i + 1], nums[i])
                                        
        for i in range(length - k + 1):
            res.append(max(right[i], left[i + k - 1]))
        
        return res
```

该方法时间复杂度 $O(n)$，空间复杂度 $O(n)$。


## 567. 字符串的排列

[原题链接](https://leetcode-cn.com/problems/permutation-in-string/)

### 思路

计算 s2 中是否存在子串与 s1 拥有相同字母数

- 先计算 s1 每个字母出现次数
- 在 s2 上放置 "滑动窗口"，计算与 s1 等长的字串是否拥有与 s1 相同的字符数

```python
class Solution:
    def checkInclusion(self, s1: str, s2: str) -> bool:
        s1_length = len(s1)
        s2_length = len(s2)
        if s1_length > s2_length:
            return False
        
        count1 = [0 for _ in range(26)]
        count2 = [0 for _ in range(26)]
        ord_a = ord('a')
        
        # s1 字符个数记录
        for c in s1:
            count1[ord(c) - ord_a] += 1
                    
        # s2 第一个窗口字符记录
        for i in range(s1_length):
            count2[ord(s2[i]) - ord_a] += 1
            
        """
        是否匹配
        """
        def is_match(count1, count2):
            for i in range(len(count1)):
                if count1[i] != count2[i]:
                    return False
            return True
        
        if is_match(count1, count2):
            return True
            
        for i in range(s1_length, s2_length):
            left = ord(s2[i - s1_length]) - ord_a
            count2[left] -= 1
            count2[ord(s2[i]) - ord_a] += 1
            if is_match(count1, count2):
                return True
        
        return False
```

- 时间复杂度：$O(l1 + (l2 - l1) * 26)$（$l1$ 为字符串 s1 长度，$l2$ 为字符串 s2 长度）
- 空间复杂度：$O(1)$

### 优化方案

维护一个变量 `count` 用于记录相同字母的位数，如果最终 `count == 26` 则说明完全包含。

```python
class Solution:
    def checkInclusion(self, s1: str, s2: str) -> bool:
        length1 = len(s1)
        length2 = len(s2)
        if length2 < length1:
            return False
        
        count1 = [0 for _ in range(26)]
        count2 = [0 for _ in range(26)]
        
        ord_a = ord('a')
        
        for i in range(length1):
            c1 = s1[i]
            c2 = s2[i]
            count1[ord(c1) - ord_a] += 1
            count2[ord(c2) - ord_a] += 1
        
        # 计算相同字母位数
        count = 0
        for i in range(26):
            if count1[i] == count2[i]:
                count += 1
                
        for i in range(length1, length2):
            
            if count == 26:
                return True
            
            left_c = s2[i - length1]
            left_index = ord(left_c) - ord_a
            right_c = s2[i]
            right_index = ord(right_c) - ord_a
            
            if count2[left_index] == count1[left_index]:
                count -= 1
            if count2[right_index] == count1[right_index]:
                count -= 1
            
            count2[left_index] -= 1
            count2[right_index] += 1
            
            if count2[left_index] == count1[left_index]:
                count += 1
            if count2[right_index] == count1[right_index]:
                count += 1
            
        return count == 26
```

- 时间复杂度：$O(l1 + (l2 - l1))$（$l1$ 为字符串 s1 长度，$l2$ 为字符串 s2 长度）
- 空间复杂度：$O(1)$
