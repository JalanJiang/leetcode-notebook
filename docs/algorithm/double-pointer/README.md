## 16. 最接近的三数之和

[原题链接](https://leetcode-cn.com/problems/3sum-closest/)

### 思路

排序 + 双指针。

```python
class Solution:
    def threeSumClosest(self, nums: List[int], target: int) -> int:
        length = len(nums)
        if length < 3:
            return 0
        # 排序
        nums.sort()
        ans = nums[0] + nums[1] + nums[2]
        for i in range(length):
            num = nums[i]
            start = i + 1
            end = length - 1
            while start < end:
                s = num + nums[start] + nums[end]
                # 如果计算出的和 s 更接近 target，则更新 ans
                if abs(s - target) < abs(ans - target):
                    ans = s
                if s < target:
                    start += 1
                elif s > target:
                    end -= 1
                else:
                    return ans
        return ans
```

## 392. 判断子序列

[原题链接](https://leetcode-cn.com/problems/is-subsequence/)

### 思路

双指针。

指针 `i` 指向 `s` 第一个字符，指针 `j` 指向 `t` 第一个字符。逐一判断 `i` 所指向的字符是否在 `t` 中存在。

- 如果 `s[i] != t[j]`：`j = j + 1`，继续比对下一个字符
- 如果 `s[i] == t[j]`：`i = i + 1`，`j = j + 1`，继续进行下一个 `s[i]` 的查找

```python
class Solution(object):
    def isSubsequence(self, s, t):
        """
        :type s: str
        :type t: str
        :rtype: bool
        """
        s_length = len(s)
        t_length = len(t)
        
        i = 0
        j = 0
        
        while i < s_length and j < t_length:
            if s[i] == t[j]:
                i += 1
            j += 1
            
        return i == s_length
```

```swift
class Solution {
    func isSubsequence(_ s: String, _ t: String) -> Bool {
        var sLength = s.count
        var tLength = t.count
        
        var i = 0
        var j = 0
        
        var sArray = Array(s)
        var tArray = Array(t)
        
        while i < sLength && j < tLength {
            var sc = sArray[i]
            var tc = tArray[j]
            
            if sc == tc {
                i += 1
            }
            j += 1
        }
        
        return i == sLength
    }
}
```