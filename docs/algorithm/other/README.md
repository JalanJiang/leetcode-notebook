## 384. 打乱数组

[原题链接](https://leetcode-cn.com/problems/shuffle-an-array/)

### 思路

使用 [FisherYates 洗牌算法](https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle)，伪代码如下：

```
-- To shuffle an array a of n elements (indices 0..n-1):
for i from n−1 downto 1 do
     j ← random integer such that 0 ≤ j ≤ i
     exchange a[j] and a[i]
```

```python
import random

class Solution(object):

    def __init__(self, nums):
        """
        :type nums: List[int]
        """
        self.init = list(nums)
        self.nums = nums
        self.length = len(nums)
        
        

    def reset(self):
        """
        Resets the array to its original configuration and return it.
        :rtype: List[int]
        """
        self.nums = list(self.init)
        return self.nums
        

    def shuffle(self):
        """
        Returns a random shuffling of the array.
        :rtype: List[int]
        """
        for i in reversed(range(self.length)):
            index = random.randint(0, i)
            self.nums[i], self.nums[index] = self.nums[index], self.nums[i]
        return self.nums

    
# Your Solution object will be instantiated and called as such:
# obj = Solution(nums)
# param_1 = obj.reset()
# param_2 = obj.shuffle()
```

当然啦，直接用 `shuffle` 方法也可以。

### 参考

- [Python shuffle() 函数](https://www.runoob.com/python/func-number-shuffle.html)