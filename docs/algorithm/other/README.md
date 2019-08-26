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

## 846. 一手顺子

[原题链接](https://leetcode-cn.com/problems/hand-of-straights/submissions/)

### 思路

题目的要求是判断输入的数组，是否能被分隔成每 W 个数字一组，并且每组的数据都是连续的。

这个算法考虑先计算出每个数字出现的个数，然后从小到大取数字，以组成连续的数组。若，数字不够取，则返回false，否则返回true。

如，示例1：

- 输入： hand = [1,1,2,3,2,3,6,2,3,4,7,8] W = 3
- 输出： true
- 上述数组可以分割为： [1, 2, 3], [2, 3, 4], [6, 7, 8]

首先，根据 W = 3，则，可知每个分割后的子数组长度为 3。

其实，我们可以将上述数组中的数字出现次数做一个统计：

- 1: 2次，2: 3次，3: 3次，4: 1次，5: 1次，6: 1次，7: 1次

那么，我们从小到大遍历我们统计的结果。

1. 从 1 开始，那么以 1 开头的子数组为： 1、2、3。那么，当前我们需要将 1 的次数使用完，所以需要将1，2，3依次 -2。得到：

- 1: 0次，2: 1次，3: 1次，4: 1次，5: 1次，6: 1次，7: 1次

此时，如果 2, 3 出现的次数有小于 2 的，说明存在以 1 开头的连续数组存在长度不为3。

2. 现在 1 的个数为 0，那么现在遍历到 2 。以 1 开头的子数组为： 2、3、4。那么，我们在统计结果上，将此时已经使用过的数组以及使用次数减一，得到：

- 1: 0次，2: 0次，3: 0次，4: 0次，5: 1次，6: 1次，7: 1次

3. 现在 2, 3 和 4 的个数为 0，那么现在遍历到 5 。以 5 开头的子数组为： 5、6、7。那么，我们在统计结果上，将此时已经使用过的数组以及使用次数减一，得到：

- 1: 0次，2: 0次，3: 0次，4: 0次，5: 0次，6: 0次，7: 0次

数组中所有的数字被使用尽，且未发现无法组成连续子数组的情况，那么返回 true。

```java
import random

public class Solution {

    public static void main(String[] args) {
        Solution solution = new Solution();
        boolean result = solution.isNStraightHand(new int[]{1,1,2,2,3,3}, 2);
        System.out.println(result);
    }

    public boolean isNStraightHand(int[] hand, int W) {
        if (hand == null || W < 0 || W > hand.length) return false;

        if (hand.length % W != 0) return false;

        Map<Integer, Integer> hands = new TreeMap<>();
        for (int i : hand) {
            hands.put(i, hands.getOrDefault(i, 0) + 1);
        }

        Integer[] keyset = new Integer[hands.keySet().size()];
        hands.keySet().toArray(keyset);

        for (int i = 0; i < hands.keySet().size(); i++) {
            int num = keyset[i];
            int startTimes = hands.getOrDefault(num, 0);
            if (startTimes <= 0) {
                continue;
            }

            for (int j = 0; j < W; j++) {
                int times = hands.getOrDefault(num + j, 0);
                if (times < startTimes) return false;
                hands.put(num + j, times - startTimes);
            }
        }
        return true;
    }
}
```