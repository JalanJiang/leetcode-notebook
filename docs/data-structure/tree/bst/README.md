## 220. 存在重复元素 III

[原题链接](https://leetcode-cn.com/problems/contains-duplicate-iii/)

### 思路

这道题的中文翻译真的很迷，先对题目再做一个翻译：

给定一个整数数组，判断数组中是否有两个不同的索引 `i` 和 `j`，使得：存在 `abs(i - j) <= k` 时，有 `abs(nums[i] - nums[j]) <=t`。

### 解一：暴力破解（超时）

取出元素 `nums[i]`，在 `i + 1 ~ i + k` 的范围内遍历是否存在 `abs(nums[i] - nums[j]) <= t` 的数，如果存在则返回 `True`。

```python
class Solution:
    def containsNearbyAlmostDuplicate(self, nums: List[int], k: int, t: int) -> bool:
        num_length = len(nums)
        for i in range(num_length):
            for j in range(i + 1, i + k + 1):
                if j < num_length:
                    if abs(nums[i] - nums[j]) <= t:
                        return True
        return False
```

### 解二：桶

使用 `nums[i] // (t + 1)` 计算桶编号，这样保证同一个桶中的元素差值不会超过 `t`，因此只要命中同一个桶即可返回 `True`。

因此题需要维护长度为 `k` 的滑动窗口，因此当元素大于 `K` 时需要清理桶中元素。

```python
class Solution:
    def containsNearbyAlmostDuplicate(self, nums: List[int], k: int, t: int) -> bool:
        if t < 0:
            return False
        bucket = dict()
        for i in range(len(nums)):
            bucket_num = nums[i] // (t + 1)
            if bucket_num in bucket:
                # 命中
                return True
            # 检查前后两个桶，因为范围是 2t
            if bucket_num + 1 in bucket and abs(bucket[bucket_num + 1] - nums[i]) <= t:
                return True
            if bucket_num - 1 in bucket and abs(bucket[bucket_num - 1] - nums[i]) <= t:
                return True
            bucket[bucket_num] = nums[i]
            if len(bucket) > k:
                # 弹出元素
                bucket.pop(nums[i - k] // (t + 1))
        return False
```

```go
func containsNearbyAlmostDuplicate(nums []int, k int, t int) bool {
    // var bucket map[int]int
    if t < 0 {
        return false
    }
    var bucket = make(map[int]int)
    for i := 0; i < len(nums); i++ {
        // 计算桶编号
        bucketNum := getBucketKey(nums[i], t + 1)
        // 是否命中桶
        if _, ok := bucket[bucketNum]; ok {
            // 存在
            return true
        }
        // 是否命中相邻桶
        if val, ok := bucket[bucketNum - 1]; ok {
            if val - nums[i] <= t && val - nums[i] >= -t {
                return true
            }
        }
        if val, ok := bucket[bucketNum + 1]; ok {
            if val - nums[i] <= t && val - nums[i] >= -t {
                return true
            }
        }
        bucket[bucketNum] = nums[i]
        // 多余元素弹出
        if len(bucket) > k {
            delete(bucket, getBucketKey(nums[i - k], t + 1))
        }
    }
    return false
}

func getBucketKey(num int, t int) int {
    if num < 0 {
        return (num + 1) / (t - 1)
    } else {
        return num / t
    }
}
```

### 解三：平衡二叉树


