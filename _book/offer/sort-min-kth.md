## 最小的 K 个数

[原题链接](https://www.nowcoder.com/practice/6a296eb82cf844ca8539b57c23e6e9bf?tpId=13&tqId=11182&tPage=2&rp=1&ru=%2Fta%2Fcoding-interviews&qru=%2Fta%2Fcoding-interviews%2Fquestion-ranking)

## 思路

### 堆排

步骤：

1. 构建最小堆
2. 取出前 k 个数，并调整堆

算法复杂度为 `O(logk)`

```python
# -*- coding:utf-8 -*-
class Solution:
    def GetLeastNumbers_Solution(self, tinput, k):
        # write code here
        length = len(tinput)
        if k > length or k == 0:
            return []
        
        for i in range(length // 2):
            self.adjustHeap(tinput, i, length)
            
        res = []
        count = 0
        for i in reversed(range(0, length)):
            count += 1
            res.append(tinput[0])
            if count >= k:
                break
            self.swap(tinput, 0, length - 1)
            length -= 1
            self.adjustHeap(tinput, 0, length)
        return res
        
        
    
    def adjustHeap(self, nums, k, length):
        while True:
            i = k * 2 + 1
            if i >= length:
                return
            if i + 1 < length and nums[i+1] < nums[i]:
                i = i + 1
            if nums[i] < nums[k]:
                self.swap(nums, i, k)
                k = i
            else:
                return
    
    def swap(self, nums, a, b):
        t = nums[a]
        nums[a] = nums[b]
        nums[b] = t
            
```