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

## 783. 二叉搜索树结点最小距离

[原题链接](https://leetcode-cn.com/problems/minimum-distance-between-bst-nodes/)

### 解一

感觉我这个想法可能比较奇怪。

要找「任意两节点的差的最小值」，即需要找每个节点和其他某节点的能达到的最小差值。

又因为这是一个二叉搜索树，所以对于节点 `root` 来说，和它值最接近的某节点 `node` 应该来自于：

1. `root` 左子树的最右子结点
2. `root` 右子树的最左子结点

通过递归来解决这个问题。

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    val = float('inf')
    
    def minDiffInBST(self, root: TreeNode) -> int:
        
        def dfs(root):
            if root is None:
                return
            
            #print(root.val)
            
            # 左子树的最右子节点，右子树的最左子节点
            if root.left is not None:
                tmp = root.left
                while tmp.right is not None:
                    tmp = tmp.right
                left = root.val - tmp.val
                self.val = min(self.val, left)
            
            if root.right is not None:
                tmp = root.right
                while tmp.left is not None:
                    tmp = tmp.left
                right = tmp.val - root.val
                self.val = min(self.val, right)
            
            dfs(root.left)
            dfs(root.right)
                
        dfs(root)
        return self.val
```