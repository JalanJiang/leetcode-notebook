## 938. 二叉搜索树的范围和

[原题链接](https://leetcode-cn.com/problems/range-sum-of-bst/)

### 思路

题目本来的意思比较难懂。其实意思是 `L` 和 `R` 之间**中序遍历**的结点值的和。

使用递归解决。

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def rangeSumBST(self, root: TreeNode, L: int, R: int) -> int:
        if root == None:
            return 0
        if root.val > R:
            return self.rangeSumBST(root.left, L, R)
        elif root.val < L:
            return self.rangeSumBST(root.right, L, R)
        else:
            return root.val + self.rangeSumBST(root.left, L, R) + self.rangeSumBST(root.right, L, R)
```

## 698. 划分为k个相等的子集

[原题链接](https://leetcode-cn.com/problems/partition-to-k-equal-sum-subsets/)

### 思路

递归求解。

拆分的子问题为：凑齐一个和为 `avg` 的子集。

因此，我们先求出真个数组划分为 k 个子集后每个子集的和，即 `avg = sum / k`。

在递归函数中：

- 遍历函数 `nums`（已从大到小排序），逐一**凑**出子集
- 进行下一层递归条件：凑齐一个和为 `avg` 的子集
- 递归函数结束条件：已凑齐 `k` 个子集

```python
class Solution:
    def canPartitionKSubsets(self, nums: List[int], k: int) -> bool:
        length = len(nums)
        if length < k:
            return False
        
        s = sum(nums)
        # 求平均值
        avg, mod = divmod(s, k)
        # 不能整除，返回 False
        if mod:
            return False
        
        # 降序排序
        nums.sort(reverse=True)
        # 存储已经使用的下标
        used = set()
        def dfs(start, value, cnt):
            if value == avg:
                return dfs(0, 0, cnt - 1)
            
            if cnt == 0:
                return True
            
            for i in range(start, length):
                if i not in used and value + nums[i] <= avg:
                    used.add(i)
                    if dfs(i + 1, value + nums[i], cnt):
                        return True
                    used.remove(i)
            
            return False
            
        return dfs(0, 0, k)
```