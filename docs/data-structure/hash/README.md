## 1. 两数之和

[原题链接](https://leetcode-cn.com/problems/two-sum/submissions/)

### 解法一：暴力

```python
class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        length = len(nums)
        for i in range(length):
            for j in range(i + 1, length):
                if nums[i] + nums[j] == target:
                    return [i, j]
```

- 时间复杂度：$O(n^2)$
- 空间复杂度：$O(1)$

### 解法二：一遍哈希

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

2020.06.02 复盘：

```python
class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        table = dict()
        for i in range(len(nums)):
            n = nums[i]
            tmp = target - n
            if tmp in table:
                return [i, table[tmp]]
            else:
                table[n] = i
```

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

## 355. 设计推特

[原题链接](https://leetcode-cn.com/problems/design-twitter/)

### 偷懒排序法

```python
class Node:
    def __init__(self, time, tweet_id, nxt):
        """
        链表节点
        """
        self.time = 0
        self.nxt = nxt
        self.tweet_id = tweet_id

class Twitter:

    def __init__(self):
        """
        Initialize your data structure here.
        """
        self.time = 0
        # 用户哈希
        self.tweets = dict()
        self.followers = dict()
        

    def postTweet(self, userId: int, tweetId: int) -> None:
        """
        Compose a new tweet.
        """
        # node = Node(self.time, tweetId, None)
        # if userId in self.tweets:
        #     head = self.tweet[userId]
        #     node.nxt = head
        # self.tweets[userId] = node
        # self.time += 1
        if userId not in self.tweets:
            self.tweets[userId] = []
        self.tweets[userId].append([self.time, tweetId])
        self.time += 1


    def getNewsFeed(self, userId: int) -> List[int]:
        """
        Retrieve the 10 most recent tweet ids in the user's news feed. Each item in the news feed must be posted by users who the user followed or by the user herself. Tweets must be ordered from most recent to least recent.
        """
        ans = []
        # 取出关注的用户
        followers = self.followers.get(userId, set())
        # print(self.tweets)
        tweets = []
        if userId in self.tweets:
            tweets = self.tweets[userId]
        # print(tweets)
        # print(followers)
        for follower in followers:
            # tweets.extend(self.tweets[follower])
            if follower in self.tweets:
                tweets = tweets + self.tweets[follower]
        tweets.sort(key=lambda x: x[0], reverse=True)
        # print(tweets)
        # print(tweets)
        # print([x[1] for x in tweets[:10]])
        return [x[1] for x in tweets[:10]]

    def follow(self, followerId: int, followeeId: int) -> None:
        """
        Follower follows a followee. If the operation is invalid, it should be a no-op.
        """
        if followerId == followeeId:
            # 不允许自己关注自己
            return
        if followerId not in self.followers:
            self.followers[followerId] = set()
        self.followers[followerId].add(followeeId)


    def unfollow(self, followerId: int, followeeId: int) -> None:
        """
        Follower unfollows a followee. If the operation is invalid, it should be a no-op.
        """
        if followerId not in self.followers:
            return
        self.followers[followerId].discard(followeeId)

# Your Twitter object will be instantiated and called as such:
# obj = Twitter()
# obj.postTweet(userId,tweetId)
# param_2 = obj.getNewsFeed(userId)
# obj.follow(followerId,followeeId)
# obj.unfollow(followerId,followeeId)
```

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

## 560. 和为K的子数组

[原题链接](https://leetcode-cn.com/problems/subarray-sum-equals-k/)

### 思路一：暴力破解

1. 固定左边界
2. 枚举右边界

```go
func subarraySum(nums []int, k int) int {
    length := len(nums)
    ans := 0
    for left := 0; left < length; left++ {
        s := 0
        for right := left; right < length; right++ {
            s += nums[right]
            if s == k {
                ans += 1
            }
        }
    }
    return ans
}
```

- 时间复杂度：$O(n^2)$
- 空间复杂度：$O(1)$

### 思路二：前缀和 + 哈希

用 `pre[i]` 表示 `[0, ..., i]` 的和。

因此，`[j, ..., i]` 的和为 k 可以表示为：`pre[i] - pre[j - 1] == k`。

移项后：`pre[j - 1] == pre[i] - k`，因此，只要统计 `pre[i] - k` 即可。

<!-- tabs:start -->

#### **Python**

```python
class Solution:
    def subarraySum(self, nums: List[int], k: int) -> int:
        ans, pre = 0, 0
        nums_dict = dict()
        nums_dict[0] = 1
        for i in range(len(nums)):
            pre += nums[i]
            ans += nums_dict.get(pre - k, 0)
            nums_dict[pre] = nums_dict.get(pre, 0) + 1
        return ans
```

#### **Go**

```go
func subarraySum(nums []int, k int) int {
    length := len(nums)
    pre := 0
    ans := 0
    m := map[int]int{}
    m[0] = 1
    for i := 0; i < length; i++ {
        pre += nums[i]
        if _, ok := m[pre - k]; ok {
            ans += m[pre - k]
        }
        m[pre] += 1
    }
    return ans
}
```

<!-- tabs:end -->


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

## 706. 设计哈希映射

[原题链接](https://leetcode-cn.com/problems/design-hashmap/)

### 思路

1. 哈希映射设计：如何通过 `key` 找到合适的桶
2. 哈希碰撞处理：许多 `key` 都映射在一个桶里，如何进行这些值的存储与查找

```python
class Bucket:
    def __init__(self):
        self.bucket = []
    
    def put(self, key, value):
        for i in range(len(self.bucket)):
            k, v = self.bucket[i][0], self.bucket[i][1]
            if k == key:
                self.bucket[i] = (key, value)
                return
        self.bucket.append((key, value))
    
    def get(self, key):
        for i in range(len(self.bucket)):
            k, v = self.bucket[i][0], self.bucket[i][1]
            if k == key:
                return v
        return -1

    def remove(self, key):
        for i, kv in enumerate(self.bucket):
            if key == kv[0]:
                # 删除元素问题
                del self.bucket[i]

class MyHashMap:

    def __init__(self):
        """
        Initialize your data structure here.
        """
        self.bucket_count = 2069
        self.hash_map = [Bucket() for _ in range(self.bucket_count)]
        

    def put(self, key: int, value: int) -> None:
        """
        value will always be non-negative.
        """
        bucket_num = key % self.bucket_count
        self.hash_map[bucket_num].put(key, value)


    def get(self, key: int) -> int:
        """
        Returns the value to which the specified key is mapped, or -1 if this map contains no mapping for the key
        """
        bucket_num = key % self.bucket_count
        return self.hash_map[bucket_num].get(key)
        

    def remove(self, key: int) -> None:
        """
        Removes the mapping of the specified value key if this map contains a mapping for the key
        """
        bucket_num = key % self.bucket_count
        self.hash_map[bucket_num].remove(key)
        


# Your MyHashMap object will be instantiated and called as such:
# obj = MyHashMap()
# obj.put(key,value)
# param_2 = obj.get(key)
# obj.remove(key)
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