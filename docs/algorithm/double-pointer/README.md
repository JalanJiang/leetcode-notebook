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