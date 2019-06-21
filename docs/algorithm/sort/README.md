


## 堆排序

- 最大堆
    - 节点的元素都要不小于其孩子
    - 常用与升序排序
- 最小堆：
    - 节点元素都不大于其左右孩子
    - 常用于降序排序
    
### 复杂度

### 资料

- [图解排序算法(三)之堆排序](https://www.cnblogs.com/chengxiao/p/6129630.html)
- [堆排序详解](https://www.cnblogs.com/0zcl/p/6737944.html)





## 快速排序




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


## 315. 计算右侧小于当前元素的个数

[原题链接](https://leetcode-cn.com/problems/count-of-smaller-numbers-after-self/)

### 解法一：暴力破解

暴力破解时间复杂度 `O(n^2)` 过高，导致超时。

```python
class Solution(object):
    def countSmaller(self, nums):
        """
        :type nums: List[int]
        :rtype: List[int]
        """
        length = len(nums)
        res = [0 for _ in range(length)]
        
        for i in range(length):
            t = nums[i]
            count = 0
            for j in range(i, length):
                if nums[j] < t:
                    count += 1
            res[i] = count
        
        return res
```

### 解法二：二叉搜索树

利用二叉搜索树的特性：左边节点的值小于等于当前节点值，右边节点的值大于等于当前节点值。

那么实现算法首先要构建一颗二叉搜索树：

1. 定义树的节点结构 `TreeNode`
2. 实现树的节点插入方法 `insertNode`

其中， `insertNode` 方法需要实现几个功能：

1. 构建二叉树
2. 维护每个节点中其左子树节点数量值 `count`：如果新加入的节点需要加入当前节点的左子树，则当前节点的 `count += 1`
3. 计算出新加入节点 `nums[i]` 的 "右侧小于当前元素的个数"，即题目所求值 `res[i]`

附 Python 代码：


```python
# 定义一个树的节点类
class TreeNode(object):
    def __init__(self, val):
        self.left = None
        self.right = None
        self.val = val  # 节点值
        self.count = 0  # 左子树节点数量

class Solution(object):
    def countSmaller(self, nums):
        """
        :type nums: List[int]
        :rtype: List[int]
        """
        length = len(nums)        
        root = None
        # 结果集
        res = [0 for _ in range(length)]
        # nums 反序加入搜索树
        for i in reversed(range(length)):
            root = self.insertNode(root, nums[i], res, i)
        return res
    
    # 往二叉搜索树中插入新的节点
    def insertNode(self, root, val, res, res_index):
        if root == None:
            root = TreeNode(val)
        elif val <= root.val: # 小于当前节点值则放入左子树
            # root 的左侧节点数量值 +1
            root.count += 1
            root.left = self.insertNode(root.left, val, res, res_index)
        elif val > root.val: # 大于当前节点值则放入右子树
            # 计算题目所求的结果
            res[res_index] += root.count + 1
            root.right = self.insertNode(root.right, val, res, res_index)
            
        return root
```

----

这里再解释几个问题：

一、为什么 `nums` 需要反序加入二叉搜索树？

如果反序加入二叉搜索树，对于节点 `nums[i]` 来说，当它加入二叉搜索树时，它右边的元素都已经在树中了，那么它加入时就可以直接确认 "右侧小于当前元素的个数"，也就是说我们可以在构建二叉搜索树的过程中直接求出 `res[i]`。

二、`res[res_index] += root.count + 1` 是为什么？

这句表达式的解释是：

当 `nums[res_index]` 加入 `root` 的右子树时，小于 `nums[res_index]` 的元素个数为：`root` 左子树的所有节点 + `root` 本身。

那个 `+1` 代表的就是 `root` 自己啦。

----

唠唠叨叨的也不知道有没有讲清楚，就这样吧…… `_(┐「ε:)_`




## 324. 摆动排序 II

[原题链接](https://leetcode-cn.com/problems/wiggle-sort-ii/submissions/)

### 思路

1. 将 nums 排序，分为大数列表与小数列表
2. 对列表进行反转
3. 对列表进行穿插求得结果，穿插规则如下：

```
[小数1，大数1，小数2，大数2 ……]
```

```python
class Solution(object):
    def wiggleSort(self, nums):
        """
        :type nums: List[int]
        :rtype: None Do not return anything, modify nums in-place instead.
        """
        nums.sort()
        half = len(nums[::2])
        
        nums[::2], nums[1::2] = nums[:half][::-1], nums[half:][::-1]
```



