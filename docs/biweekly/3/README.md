## 5022. 长度为 K 的无重复字符子串

[原题链接](https://leetcode-cn.com/contest/biweekly-contest-3/problems/find-k-length-substrings-with-no-repeated-characters/)

### 思路

维护一个长度为 `K` 的滑动窗口。

我是这样考虑的。先初始化一些用来辅助的数据结构：

- `s_map` 用于存储字符出现的次数
- `repeats` 用于标记字符是否为重复字符
- `res` 记录结果

然后：

1. 先判断 `S` 的长度是否大于等于 `K`，否则直接返回 0；
2. 先处理前 `K` 个元素：记录元素出现的次数、是否有重复元素，并计算 `res` 的值；
3. 维护一个长度为 `K` 的滑动窗口，遍历 `S`：
   1. 处理要移除的元素 `first`；
   2. 处理要加入的元素 `cur`；
   3. 判断新产生的字符串是否有重复元素。

附上代码：

```python
class Solution(object):
    def numKLenSubstrNoRepeats(self, S, K):
        """
        :type S: str
        :type K: int
        :rtype: int
        """
        s_length = len(S)
        if K > s_length:
            return 0
        
        s_map = dict()
        repeats = dict()
        res = 0
        
        is_repeat = False
        # 先处理前 K 个元素
        for i in range(K):
            c = S[i]
            if c in s_map:
                if s_map[c] > 0:
                    is_repeat = True
                    repeats[c] = True
                s_map[c] += 1
            else:
                s_map[c] = 1
                        
        if not is_repeat:
            res += 1
        
        for i in range(K, s_length):
            # 取出要排除掉的第一个元素
            first = S[i - K]
            # 将该元素的出现次数减 1
            s_map[first] -= 1
            # 如果该元素的出现次数已经等于 1 或 0，判断该元素是否为重复的元素，如果是则把该元素从重复元素中移除
            if s_map[first] <= 1 and first in repeats:
                repeats.pop(first)
            
            # 取出当前要加入字符串的元素
            cur = S[i]
            # 该元素出现次数加 1
            s_map[cur] = s_map.get(cur, 0) + 1
            # 如果出现次数大于 1，则加入重复出现元素的字典中
            if s_map[cur] > 1:
                repeats[cur] = True
            # 判断是否有重复元素，如果没有则把结果加 1
            if len(repeats) == 0:
                res += 1
            
        return res
```

### 复杂度

- 时间 `O(n)`
- 空间 `O(n)`