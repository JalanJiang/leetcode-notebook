## 179. 最大数

[原题链接](https://leetcode-cn.com/problems/largest-number/)

### 思路

需要自定义排序算法，我这里用的是冒泡的思想，核心思路就是比较两个数 `a + b` 和 `b + a` 的排列哪个更大。

例如在 `[a, b]` 的情况下，如果 `b + a` 的组合产生的数字大于 `a + b` 组合，则交换 `a` `b` 的位置，即把能产生更大结果的 `b` 字符"**冒**"到上面来，变为 `[b, a]`。

```python
class Solution(object):
    def largestNumber(self, nums):
        """
        :type nums: List[int]
        :rtype: str
        """
        length = len(nums)
        
        # 冒泡排序思想
        i = length
        while i > 0:
            for j in range(i - 1):
                # 自定义的排序算法：比较 a+b 和 b+a 哪个更大 
                a = nums[j]
                b = nums[j + 1]
                ab = int(str(a) + str(b))
                ba = int(str(b) + str(a))
                if ba > ab:
                    nums[j], nums[j + 1] = nums[j + 1], nums[j]
            i -= 1
        
        # 结果字符串拼接
        res = ""
        for n in nums:
            # 这里防止 [0, 0, 0] 的情况下 res 返回多个 0
            if res == "" and n == 0:
                continue
            res += str(n)
        
        if res == "":
            return "0"
        else:
            return res
```