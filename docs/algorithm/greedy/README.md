## 122. 买卖股票的最佳时机 II

[原题链接](https://leetcode-cn.com/problems/best-time-to-buy-and-sell-stock-ii/)

### 思路

经典贪心算法，总结一下就是：

- 如果发现明天会跌那就明天买
- 如果发现明天会涨那就马上卖掉

```python
class Solution(object):
    def maxProfit(self, prices):
        """
        :type prices: List[int]
        :rtype: int
        """
        max_prices = 0
        for i in range(len(prices) - 1):
            tmp = prices[i + 1] - prices[i]
            if tmp > 0:
                max_prices += tmp
        return max_prices
```