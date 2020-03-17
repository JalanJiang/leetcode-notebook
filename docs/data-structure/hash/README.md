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

## 575. 分糖果

[原题链接](https://leetcode-cn.com/problems/distribute-candies/)

### 总体思路

题目的意思是把所有的糖果分成两份，其中一份要尽可能拥有最多种类的糖果。

假设糖果一共有 `x` 颗，糖果种类有 `y` 种，那么分成两份后每份有糖果 `x / 2`：

- 如果 `y >= x / 2`，那么可以直接拿出 `x / 2` 种糖果
- 如果 `y < x / 2`，那么最多也只能分配到 `y` 种糖果了

所以这道题只要求出糖果的种类 `y` 即可。而求出糖果种类的方法也有好几种。

### 解法一：字典

将糖果种类的数字值作为 key 存储在字典中，糖果一旦存在则进行标记，并将糖果种类加一。

<!-- tabs:start -->

#### **Python**

```python
class Solution:
    def distributeCandies(self, candies: List[int]) -> int:
        length = len(candies)
        each = length // 2
        type_dict = dict()
        type_cnt = 0
        
        for c in candies:
            if type_dict.get(c, 0) == 0:
                type_dict[c] = 1
                type_cnt += 1
        
        if type_cnt >= each:
            return each
        else:
            return type_cnt
```

#### **Go**

```go
func distributeCandies(candies []int) int {
    var candiesMap map[int]bool
    candiesMap = make(map[int]bool)
    var candiesCount = 0
    for i := 0; i < len(candies); i++ {
        candie := candies[i]
        _, ok := candiesMap[candie]
        // candie 不存在，开始计数
        if !ok {
            candiesMap[candie] = true
            candiesCount += 1
        }
    }
    var each = len(candies) / 2
    if candiesCount >= each {
        return each
    } else {
        return candiesCount
    }
}
```

#### **Java**

```java
class Solution {
    public int distributeCandies(int[] candies) {
        if (candies == null || candies.length <= 0) return 0;
        Map<Integer, Integer> type = new HashMap<Integer, Integer>();
        int typeCount = 0;
        for (int i = 0; i < candies.length; i++) {
            if (!type.containsKey(candies[i])) {
                type.put(candies[i], 1);
                typeCount++;
            }
        }
        
        if (typeCount >= candies.length / 2) {
            return candies.length / 2;
        } else {
            return typeCount;
        }
    }
}
```

<!-- tabs:end -->

- 时间复杂度 O(n)
- 空间复杂度 O(n)

### 解法二：集合

利用集合无重复元素的特性，将数据存入集合，从而求出糖果的种类。

```python
class Solution:
    def distributeCandies(self, candies: List[int]) -> int:
        each = len(candies) // 2
        candies_set = set(candies)
        return each if each <= len(candies_set) else len(candies_set)
```

- 时间复杂度 O(n)
- 空间复杂度 O(n)

### 解法三：先排序

先对数组进行排序，然后将相邻的数字进行对比，如果相邻数字不同，则说明出现了新种类的糖果。

<!-- tabs:start -->

#### **Python**

```python
class Solution:
    def distributeCandies(self, candies: List[int]) -> int:
        length = len(candies)
        each = length // 2
        candies.sort()
        count = 1
        for i in range(1, length):
            if candies[i] != candies[i - 1]:
                count += 1
        return each if each <= count else count
```

#### **Go**

```go
import (
    "sort"
)

func distributeCandies(candies []int) int {
    var length = len(candies)
    var each = length / 2
    var count = 1
    sort.Ints(candies)
    for i := 1; i < length; i ++ {
        if candies[i] != candies[i - 1] {
            count++
        }
    }
    
    if count >= each {
        return each
    } else {
        return count
    }
}
```

<!-- tabs:end -->

- 时间复杂度：O(nlogn)
- 空间复杂度：O(1)

### 解法四：Python Counter

```python
from collections import Counter

class Solution:
    def distributeCandies(self, candies: List[int]) -> int:
        each = len(candies) // 2
        candies_count = len(Counter(candies))
        return each if candies_count >= each else candies_count
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

## 705. 设计哈希集合

[原题链接](https://leetcode-cn.com/problems/design-hashset/)

### 解一：数组模拟

此题应当要用普通的数据结构实现哈希集合。

题目指出「所有的值都在 `[0, 1000000]` 的范围内」，因此我们可以设计 100 个桶，每个桶内容纳 10000 个值，正好可以容纳下所有的数据。

哈希函数的映射规则：`hash_table[key % bucket][key // bucket]`

```python
class MyHashSet:
    def __init__(self):
        """
        Initialize your data structure here.
        """
        # 给出 100 个桶
        self.bucket = 100
        # 桶内元素
        self.bucket_num = 10000
        # 初始化
        self.hash_table = [[] for _ in range(self.bucket)]
        
    def add(self, key: int) -> None:
        if not self.hash_table[key % self.bucket]:
            self.hash_table[key % self.bucket] = [0] * self.bucket_num
        self.hash_table[key % self.bucket][key // self.bucket] = 1

    def remove(self, key: int) -> None:
        if self.hash_table[key % self.bucket]:
            self.hash_table[key % self.bucket][key // self.bucket] = 0

    def contains(self, key: int) -> bool:
        """
        Returns true if this set contains the specified element
        """
        if not self.hash_table[key % self.bucket]:
            return False
        return self.hash_table[key%self.bucket][key//self.bucket] == 1
        

# Your MyHashSet object will be instantiated and called as such:
# obj = MyHashSet()
# obj.add(key)
# obj.remove(key)
# param_3 = obj.contains(key)
```

### 解二：链表模拟

## 1160. 拼写单词

[原题链接](https://leetcode-cn.com/problems/find-words-that-can-be-formed-by-characters/)

### 思路

使用哈希表存储 `chars` 中每个字符出现的次数，在遍历 `words` 时判断每个单词的字母是否可以命中 `chars` 的哈希表。

<!-- tabs:start -->

#### **Python**

```python
class Solution:
    def countCharacters(self, words: List[str], chars: str) -> int:
        res = 0
        word_dict = dict()
        # 词汇统计
        for c in chars:
            if c not in word_dict:
                word_dict[c] = 0
            word_dict[c] += 1
        
        # 开始拼写
        for word in words:
            tmp_word_dict = word_dict.copy()
            get = True
            for c in word:
                if c in tmp_word_dict:
                    if tmp_word_dict[c] == 0:
                        get = False
                        break
                    else:
                        tmp_word_dict[c] -= 1
                else:
                    get = False
                    break
            if get:
                res += len(word)

        return res
```

#### **Go**

```go
func countCharacters(words []string, chars string) int {
    var res int
    var wordMap = make(map[string]int)
    // 统计 chars
    for _, c := range chars {
        if _, ok := wordMap[string(c)]; !ok {
            // 不存在
            wordMap[string(c)] = 0
        }
        wordMap[string(c)] += 1
    }

    // 统计 word 单词数，与统计比较
    for _, word :=  range words {
        everyWordMap := make(map[string]int)
        for _, c := range word {
            if _, ok := everyWordMap[string(c)]; !ok {
                everyWordMap[string(c)] = 0
            }
            everyWordMap[string(c)] += 1
        }

        // 判断是否命中
        get := true
        for c, count := range everyWordMap {
            if mapCount, ok := wordMap[string(c)]; ok {
                // 存在
                if count > mapCount {
                    get = false
                    break
                }
            } else {
                get = false
                break
            }
        }
        if get {
            res += len(word)
        }
    }
    return res
}
```

<!-- tabs:end -->