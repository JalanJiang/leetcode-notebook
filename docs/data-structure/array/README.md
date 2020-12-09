## 11. 盛最多水的容器

[原题链接](https://leetcode-cn.com/problems/container-with-most-water/)

### 解一

暴力破解。逐一计算所有两条垂直线的组合所能构成的最大面积。

但是很不幸，超时了。

```python
class Solution(object):
    def maxArea(self, height):
        """
        :type height: List[int]
        :rtype: int
        """
        line_count = len(height)
        area = 0
        for i in range(line_count):
            for j in range(i + 1, line_count):
                area = max(area, min(height[i], height[j]) * (j - i))
                
        return area
```

- 时间复杂度：`O(n^2)`
- 空间复杂度：`O(1)`

### 解二

矩阵的面积与两个因素有关：

1. 矩阵的长度：两条垂直线的距离
2. 矩阵的宽度：两条垂直线其中较短一条的长度

因此，要矩阵面积最大化，**两条垂直线的距离越远越好，两条垂直线的最短长度也要越长越好**。

我们设置两个指针 `left` 和 `right`，分别指向数组的最左端和最右端。此时，两条垂直线的距离是最远的，若要下一个矩阵面积比当前面积来得大，必须要把 `height[left]` 和 `height[right]` 中较短的垂直线往中间移动，看看是否可以找到更长的垂直线。

```python
class Solution(object):
    def maxArea(self, height):
        """
        :type height: List[int]
        :rtype: int
        """
        left = 0
        right = len(height) - 1
        area = 0
        
        while left < right:
            cur = min(height[left], height[right]) * (right - left)
            area = max(area, cur)
            # 较短的垂直线往中间移动
            if height[left] < height[right]:
                left += 1
            else:
                right -= 1
            
        return area     
```

- 时间复杂度 `O(n)`
- 空间复杂度 `O(1)`


## 15. 三数之和

[原题链接](https://leetcode-cn.com/problems/3sum/description/)

### 解一

先对数组进行排序。对于 nums[i]，寻找其之后的 nums[j] 和 nums[k] 使得 `-nums[i] == nums[j] + nums[k]`。

无奈复杂度太高，`O(n^3)` 直接超时。

```python
#
# @lc app=leetcode.cn id=15 lang=python
#
# [15] 三数之和
#
class Solution(object):
    def threeSum(self, nums):
        """
        :type nums: List[int]
        :rtype: List[List[int]]
        """
        nums.sort()
        
        res = list()
        
        nums_length = len(nums)
        for i in range(nums_length):
            a = nums[i]
            
            for j in range(i + 1, nums_length):
                for k in range(j + 1, nums_length):
                    b = nums[j]
                    c = nums[k]
                    if b + c == -a:
                        tmp = [a, b, c]
                        if tmp not in res:
                            res.append(tmp)
        
        return res
```

### 解二

对解一进行优化。

改为双指针寻找值。对数组进行排序，先选定中间数字 `a`，指针 `left` 指向最左端，指针 `right` 指向最右端。

- 如果 `nums[left] + nums[right] + a > 0`：指针 `right--`
- 如果 `nums[left] + nums[right] + a < 0`：指针 `left++`
- `nums[left] + nums[right] + a == 0` 时记录结果

结果在 311 用例处依旧超时。。。

```python
#
# @lc app=leetcode.cn id=15 lang=python
#
# [15] 三数之和
#
class Solution(object):
    def threeSum(self, nums):
        """
        :type nums: List[int]
        :rtype: List[List[int]]
        """
        nums.sort()
        
        res = list()

        nums_length = len(nums)
        
        for i in range(1, nums_length - 1):
            a = nums[i]
            
            left  = 0
            right = nums_length - 1

            while left < right and left < i and right > i:

                b = nums[left]
                c = nums[right]

                s = a + b + c
                if s > 0:
                    right -= 1
                elif s < 0:
                    left += 1
                else:
                    tmp = [b, a, c]
                    if tmp not in res:
                        res.append(tmp)
                    left += 1
                    right -= 1
        
        return res
```

原因在于我判断结果是否重复时用了 `if tmo not in res` 的写法导致的。

### 解三

由于判重的问题，将上面的思路做修改，改为固定最左端的值 `a`，然后在其右侧找两个数 `b` 和 `c`。

如果出现多个重复的 `a` 值，那么只取最左端的 `a` 即可，杜绝了重复数据的产生。

```python
#
# @lc app=leetcode.cn id=15 lang=python
#
# [15] 三数之和
#
class Solution(object):
    def threeSum(self, nums):
        """
        :type nums: List[int]
        :rtype: List[List[int]]
        """
        nums.sort()
        
        res = list()

        nums_length = len(nums)
        
        for i in range(nums_length):
            if i > 0 and nums[i] == nums[i - 1]:
                continue

            left = i + 1
            right = nums_length - 1

            while left < right:

                a = nums[i]
                b = nums[left]
                c = nums[right]

                s = a + b + c
                
                if s > 0:
                    right -= 1
                elif s < 0:
                    left += 1
                else:
                    res.append([b, a, c])
                    while left < right and nums[left] == nums[left + 1]:
                        left += 1
                    while left < right and nums[right] == nums[right - 1]:
                        right -= 1
                    left += 1
                    right -= 1
        
        return res

```

## 26. 删除排序数组中的重复项

[原题链接](https://leetcode-cn.com/problems/remove-duplicates-from-sorted-array/description/)

### 思路

双指针 i, j

- 初始：`i = 0`, `j = 1`
- 当 `nums[i] == nums[j]`，j 后移
- 当 `nums[i] != nums[j]`：
    - 赋值：`nums[i + 1] = nums[j]`
    - i 后移
- 返回 `(i + 1 > length) ? length : i + 1`

### Python 实现

```python
class Solution:
    def removeDuplicates(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        i = 0
        j = 1
        length = len(nums)
        while j < length:
            if nums[i] == nums[j]:
                j = j + 1
            else:
                nums[i + 1] = nums[j]
                i = i + 1
        if i + 1 > length:
            return length
        else:
            return i + 1
```

优化

```python
class Solution:
    def removeDuplicates(self, nums: List[int]) -> int:
        i = 0
        for j in range(1, len(nums)):
            # 两者不想等时
            if nums[i] != nums[j]:
                i += 1
                nums[i] = nums[j]
        return i + 1
```

## 27. 移除元素

[原题链接](https://leetcode-cn.com/problems/remove-element/description/)

### 题意解读

划一下题目的重点：

- 原地移除
- 不要使用额外的数组空间
- 不需要考虑数组中超出新长度后面的元素

题目要求我们原地删除所有等于 `val` 的元素，不能使用额外空间，且**不用考虑删除后超出新数组长度后面的元素**。

也就是说，如果原数组 `nums` 长度为 `x`，要删除的 `val` 元素个数为 `y`，那么我们只要**把这 `n` 个要删除的元素所在位置用其他有效元素覆盖掉**，然后返回最终的数组长度 `x - y`。

**题目并非让我们真的删除数组的元素，而是要改写相关元素的值。**

### 思路阐述

那么要如何进行元素的改写呢？

既然要让 `val` 元素都堆在数组尾部，那么我们就派出一个开拓者探路，**只要遇到非 `val` 元素，就把它覆盖到前面来**。

因此，我们可以定义两个指针：

- 快指针 `j`：用于寻找非 `val` 元素
- 慢指针 `i`：当 `j` 找到非 `val` 元素时，就被非 `val` 元素覆盖

### 图解思路

以题中的 `nums = [3,2,2,3], val = 3` 为例。

开始时 `i` 和 `j` 都指向下标 0 位置：

![初始化时，i = 0, j = 0](https://user-gold-cdn.xitu.io/2019/11/21/16e8e78d6bf1eaee?w=425&h=179&f=png&s=8968)

此时 `j` 指向的元素为 `val`，所以把 `j` 右移动 1 位：

![把快指针 j 右移一位](https://user-gold-cdn.xitu.io/2019/11/21/16e8e79c1dd17340?w=425&h=179&f=png&s=8969)

此时，开拓者 `j` 找到了一个非 `val` 元素，那么就赋值给 `i` 吧：

![赋值得到新序列](https://user-gold-cdn.xitu.io/2019/11/21/16e8e95a2b497021?w=425&h=251&f=png&s=12570)

赋值以后，我们得到了一个新的序列 `[2, 2, 2, 3]`，我们可以得知：

- `j` 指向的元素一定不是 `val`
- `i` 指向的元素也一定不是 `val`，因为它是从 `j` 指向的元素赋值得来的，`j` 指向非 `val` 元素才会进行赋值

这样一来，`i` 和 `j` 都完成了本轮使命，继续前进！

因此每次交换以后，我们都同步增长双指针，令 `i = i + 1`，`j = j + 1`：

![同步增长双指针](https://user-gold-cdn.xitu.io/2019/11/21/16e8e97cf4ef1990?w=425&h=225&f=png&s=9812)

此时 `j` 又指向了一个非 `val` 元素，继续赋值：

![再一次赋值得到新序列](https://user-gold-cdn.xitu.io/2019/11/21/16e8e989fd262a29?w=425&h=246&f=png&s=12623)

因为本次 `i` 与 `j` 指向元素相同，所以赋值后序列没有改变。赋值操作后，我们继续同步增长双指针：

![同步增长双指针](https://user-gold-cdn.xitu.io/2019/11/21/16e8e9a17c6ecae5?w=425&h=227&f=png&s=9909)

此时 `j` 指向了一个 `val` 元素，无法进行赋值操作，继续增长 `j`，令 `j = j + 1`：

![j 超出数组范围](https://user-gold-cdn.xitu.io/2019/11/21/16e8e9b72d7141a7?w=489&h=226&f=png&s=10105)

此时我们发现 `j` 超出数组范围了，循环结束。`[2, 2, 2, 3]` 即为我们最终所求结果，而红色部分即为新数组长度，长度为 `len(nums) - (j - i)`。

### 总结一下

设置双指针 `i` 和 `j`，其中，`j` 用于寻找非 `val` 元素，来覆盖 `i` 所指向的元素。 

- 初始时：设 `i = 0, j = 0`
- 遍历数组：
    - 若 `nums[j] != val`：
        - 把 `j` 的值赋给 `i`：`nums[i] = nums[j]`
        - 同步增长双指针：`i = i + 1, j = j + 1`
    - 若 `nums[j] == val`：
        - `j` 变为快指针：`j = j + 1`，寻找下一个非 `val` 元素

  
<!-- tabs: start -->

#### **Python**

```python
# python3

class Solution:
    def removeElement(self, nums, val):
        """
        :type nums: List[int]
        :type val: int
        :rtype: int
        """
        length = len(nums)
        i = 0
        j = 0
        while j < length:
            if nums[j] != val:
                nums[i] = nums[j]
                i = i + 1
                j = j + 1
            else:
                j = j + 1
        res = length - (j - i)
        return res
```

优化：

```python
class Solution:
    def removeElement(self, nums: List[int], val: int) -> int:
        i = 0
        for j in range(len(nums)):
            if nums[j] == val:
                continue
            nums[i], nums[j] = nums[j], nums[i]
            i += 1
        return i
```

#### **Go**

```go
func removeElement(nums []int, val int) int {
    length := len(nums)
    if length == 0 {
        return 0
    }

    i := 0
    j := 0
    for j < length {
        if nums[j] == val {
            // 去找一个不是 val 的值
            j++
        } else {
            // 赋值
            nums[i] = nums[j]
            i++ 
            j++
        }
    }

    return length - (j - i)
}
```

<!-- tabs: end -->

### 复杂度

- 时间复杂度：`O(n)`
- 空间复杂度：`O(1)`，没有使用到额外空间。


## 33. 搜索旋转排序数组

[原题链接](https://leetcode-cn.com/problems/search-in-rotated-sorted-array/submissions/)

### 思路

题目要求 `O(logn)`，采用二分法来查找。

将数组一分为二，其中一边一定是有序的，一边是无序的。

- 有序：使用二分查找
- 无序：继续划分

<!-- tabs:start -->

#### **Python**

```python
class Solution(object):
    def search(self, nums, target):
        """
        :type nums: List[int]
        :type target: int
        :rtype: int
        """
        left = 0
        right = len(nums) - 1
        
        while left <= right:
            
            mid = (left + right) // 2
            if nums[mid] == target:
                return mid
            
            if nums[mid] <= nums[right]:
                if nums[mid] <= target and nums[right] >= target:
                    left = mid + 1
                else:
                    right = mid -1
            else:
                if nums[left] <= target and nums[mid] >= target:
                    right = mid - 1
                else:
                    left = mid + 1 
        return -1
```

#### **Go**

```go
func search(nums []int, target int) int {
    length := len(nums)
    left := 0
    right := length - 1
    for left <= right {
        mid := (left + right) / 2
        // fmt.Println(left, right, mid)
        if nums[mid] == target {
            return mid
        }
        if nums[mid] <= nums[right] {
            // 右边是顺序数组
            if nums[mid] <= target && target <= nums[right] {
                // 判断是否在右边
                left = mid + 1
            } else {
                right = mid - 1
            }
        } else {
            // 左边是顺序数组
            if nums[left] <= target && target <= nums[mid] {
                // 判断是否在左边
                right = mid - 1
            } else {
                left = mid + 1
            }
        }
    }

    return -1
}
```

<!-- tabs:end -->

----

2020.04.27 复盘：

想复杂了：

```python
class Solution:
    def search(self, nums: List[int], target: int) -> int:
        length = len(nums)
        left = 0
        right = length - 1
        while left <= right:
            mid = (left + right) // 2
            # print(left, right, mid)
            if nums[mid] == target:
                return mid
            if nums[left] <= nums[right]:
                # 顺序数组
                if nums[mid] > target:
                    right = mid - 1
                else:
                    left = mid + 1
            else:
                # 非顺序数组：左侧的值比右边的大，说明旋转点在中间
                if target < nums[left] and target > nums[right]:
                    # 这种情况找不到
                    return -1
                if nums[mid] >= nums[left]:
                    # 旋转点在右边
                    if target <= nums[right] or target > nums[mid]:
                        # 寻找的点比中间值大或比右侧点小
                        left = mid + 1
                    else:
                        right = mid - 1
                else:
                    # 旋转点在左边
                    if target < nums[mid] or target >= nums[left]:
                        right = mid - 1
                    else:
                        left = mid + 1
        return -1
```


## 36. 有效的数独

[原题链接](https://leetcode-cn.com/problems/valid-sudoku/)

### 思路

把行、列和小正方形区域出现的数字以字典的形式分别记录下来，在遍历过程中只要判断数字是否在这三个范围出现过就行了，如果出现过就返回 `False`。

```python
class Solution(object):
    def isValidSudoku(self, board):
        """
        :type board: List[List[str]]
        :rtype: bool
        """
        row = [{} for _ in range(9)]
        col = [{} for _ in range(9)]
        area = [{} for _ in range(9)]
        
        area_index_dict = {
            0: {0: 0, 1: 1, 2: 2},
            1: {0: 3, 1: 4, 2: 5},
            2: {0: 6, 1: 7, 2: 8}
        }
        
        for i in range(9):
            for j in range(9):
                num = board[i][j]

                if num == '.':
                    continue
                
                # 行判断
                if num in row[i]:
                    print 'row=', num
                    return False
                else:
                    row[i][num] = 1
                
                # 列判断
                if num in col[j]:
                    print 'col=', num
                    return False
                else:
                    col[j][num] = 1
                    
                # 小正方形的区域判断
                area_index = area_index_dict[i//3][j//3]
                if num in area[area_index]:
                    print 'area_index=', area_index
                    print 'area=', num
                    return False
                else:
                    area[area_index][num] = 1
                    
        return True
```

### 复杂度

- 时间复杂度 `O(9*9)`。因为用了字典，查找数字是否出现过都是 `O(1)`，是一种以空间换时间的思想
- 空间复杂度：因为这题输入数据的数量不会变，所以是常量级的


## 42. 接雨水

[原题链接](https://leetcode-cn.com/problems/trapping-rain-water/)

### 思路

1. 找出最高点
2. 分别从两边往最高点遍历：如果下一个数比当前数小，说明可以接到水

```python
class Solution(object):
    def trap(self, height):
        """
        :type height: List[int]
        :rtype: int
        """
        
        if len(height) <= 1:
            return 0
        
        max_height = 0
        max_height_index = 0
        
        # 找到最高点
        for i in range(len(height)):
            h = height[i]
            if h > max_height:
                max_height = h
                max_height_index = i
        
        area = 0
        
        # 从左边往最高点遍历
        tmp = height[0]
        for i in range(max_height_index):
            if height[i] > tmp:
                tmp = height[i]
            else:
                area = area + (tmp - height[i])
        
        # 从右边往最高点遍历
        tmp = height[-1]
        for i in reversed(range(max_height_index + 1, len(height))):
            if height[i] > tmp:
                tmp = height[i]
            else:
                area = area + (tmp - height[i])
        
        return area
```

### 解二：单调栈

维护一个单调栈：即从栈底到栈顶元素逐渐减小。

在遍历墙的过程中：

1. 墙的高度小于或等于栈顶元素：入栈，此时不会产生积水
2. 墙的高度大于栈顶元素：栈顶元素出栈，此时栈顶元素处会产生积水，产生积水的面积为：（该位置左右墙体的最小高度 - 栈顶元素高度）* 左右墙体距离差

```python
class Solution:
    def trap(self, height: List[int]) -> int:
        length = len(height)
        if length == 0:
            return 0
        
        stack = []
        # 第一个元素入栈
        stack.append(0)
        ans = 0
        for i in range(1, length):
            # 栈顶元素
            top = stack[-1]
            h = height[i]
            # 循环 pop
            while len(stack) != 0 and height[stack[-1]] < h:
                # 弹出栈顶元素
                tmp = stack.pop()
                # 存在墙才计算积水
                if len(stack) == 0:
                    break
                # 计算左右两侧高度 min
                diff = min(height[stack[-1]], h)
                distance = i - stack[-1] - 1
                ans += distance * (diff - height[tmp])

            stack.append(i)

        return ans
```

- 时间复杂度：$O(n)$
- 空间复杂度：$O(n)$


## 48. 旋转图像

[原题链接](https://leetcode-cn.com/problems/rotate-image/submissions/)

### 思路

1. 翻转矩阵
2. 按对角线交换两边的数字

举个例子：

```
[                    [                  [
  [1,2,3],             [7,8,9],            [7,4,1],
  [4,5,6],    ---->    [4,5,6], ----->     [8,5,2],
  [7,8,9]              [1,2,3]             [9,6,3] 
]                    ]                  ]
```

```python
class Solution(object):
    def rotate(self, matrix):
        """
        :type matrix: List[List[int]]
        :rtype: None Do not return anything, modify matrix in-place instead.
        """
        n = len(matrix) 
        for i in range(n//2):
            for j in range(i, n - i - 1):
                matrix[i][j],matrix[j][n-i-1],matrix[n-i-1][n-j-1],matrix[n-j-1][i] = matrix[n-j-1][i], matrix[i][j],matrix[j][n-i-1],matrix[n-i-1][n-j-1]
```


## 49. 字母异位词分组

[原题链接](https://leetcode-cn.com/problems/group-anagrams/)

### 解法一：超时了

```python
class Solution(object):
    def groupAnagrams(self, strs):
        """
        :type strs: List[str]
        :rtype: List[List[str]]
        """
        res = []
        while len(strs) != 0:
            tmp_string = strs[0]
            tmp_string = self.sortString(tmp_string)

            tmp_list = []
            tmp_strs = []
            tmp_list.append(strs[0])
            
            for i in range(1, len(strs)):
                if self.sortString(strs[i]) == tmp_string:
                    tmp_list.append(strs[i])
                else:
                    tmp_strs.append(strs[i])
            res.append(tmp_list)
            strs = tmp_strs
        return res
    
    def sortString(self, str):
        string_list = list(str)
        string_list.sort()
        return "".join(string_list)
```

### 解法二

详解见：https://leetcode-cn.com/problems/group-anagrams/solution/

循环太耗时了，改为哈希存储。

- 维护一个映射 `ans : {String -> List}`，其中每个键 `K` 是一个排序字符串，每个值是初始输入的字符串列表，排序后等于 `K`
- 将键存储为散列化元组，例如 `('c', 'o', 'd', 'e')`

```python
class Solution(object):
    def groupAnagrams(self, strs):
        """
        :type strs: List[str]
        :rtype: List[List[str]]
        """
        ans = collections.defaultdict(list)
        for s in strs:
            ans[tuple(sorted(s))].append(s)
        return ans.values()
```

普通写法，序列化为字符串：

```python
class Solution:
    def groupAnagrams(self, strs: List[str]) -> List[List[str]]:
        table = dict()
        for string in strs:
            sort_string = "".join(sorted(string))
            if sort_string not in table:
                table[sort_string] = []
            table[sort_string].append(string)
        ans = [x for x in table.values()]
        return ans
```

- 时间复杂度：O(n*klogk)（`n` 是 `strs` 长度，`k` 是 `strs` 中字符串的最大长度）
- 空间复杂度：O(n*k)，存储在 `ans` 中的所有信息内容

### 参考资料

- [Python中collections.defaultdict()使用](https://www.jianshu.com/p/26df28b3bfc8)

## 54. 螺旋矩阵

[原题链接](https://leetcode-cn.com/problems/spiral-matrix/)

### 思路

面探探的时候被问过这题，《剑指 Offer》里面好像也有。

先定好矩阵的上下左右边界，然后用四个单独的循环分别走四个边。当上界限小于下界线或左界线大于右界线时跳出循环。

```python
class Solution:
    def spiralOrder(self, matrix: List[List[int]]) -> List[int]:
        res = list()
        m = len(matrix)
        if m == 0:
            return res
        n = len(matrix[0])
        left = 0
        right = n - 1
        top = 0
        bottom = m - 1
        
        while left <= right and top <= bottom:
            i = top
            # 上边：从左到右
            for j in range(left, right + 1):
                res.append(matrix[i][j])
            top += 1
            if top > bottom:
                break
            
            # 右边：从上到下
            for i in range(top, bottom + 1):
                res.append(matrix[i][j])
            right -= 1
            if left > right:
                break
            
            i = bottom
            # 下边：从右到左
            for j in range(right, left - 1, -1):
                res.append(matrix[i][j])
            bottom -= 1
            if top > bottom:
                break
            
            # 左边：从下到上
            for i in range(bottom, top - 1, -1):
                res.append(matrix[i][j])
                #print(i, j)
            left += 1
            if left > right:
                break
                
        return res
```

### 复杂度

- 时间复杂度：要把每个元素放置到数组中，所以为 O(n)
- 空间复杂度：O(n)

## 56. 合并区间

[原题链接](https://leetcode-cn.com/problems/merge-intervals/)

### 思路

按照列表每一个子列表的第一个元素对列表的所有元素进行排序。然后对相邻两个子元素进行两两比较。

假设两个相邻的子元素分别为 `[x1, y1]` 和 `[x2, y2]`，如果该区间可合并必须满足条件 `y1 >= x2`。

若该区间可合并，合并结果可能有两种：

1. 当 `y1 < y2` 时，合并结果为 `[x1, y2]`
2. 当 `y1 >= y2` 时，合并结果为 `[x1, y1]`

```python
class Solution(object):
    def merge(self, intervals):
        """
        :type intervals: List[List[int]]
        :rtype: List[List[int]]
        """
        length = len(intervals)
        
        if length <= 1:
            return intervals
        
        intervals.sort()
        res = list()
        
        for i in range(length - 1):
            left = intervals[i]
            right = intervals[i + 1]
            
            if left[1] >= right[0]:
                # 区间可合并
                if left[1] < right[1]:
                    new_list = [left[0], right[1]]
                else:
                    new_list = [left[0], left[1]]
                intervals[i + 1] = new_list
            else:
                res.append(left)
                
        res.append(intervals[-1])
        return res
```

复杂度：

- 时间复杂度：$O(nlogn)$
- 空间复杂度：$O(n)$

## 66. 加一

[原题链接](https://leetcode-cn.com/problems/plus-one/)

### 思路

从低位往高位取数，最低位数字 `+1` 判断下一位是否需要进位。如果需要进位，下一个高位的数字继续 `+1`。

```python
class Solution(object):
    def plusOne(self, digits):
        """
        :type digits: List[int]
        :rtype: List[int]
        """
        res = list()
        add = 1
        
        for n in reversed(digits):
            tmp = n + add
            if tmp == 10:
                add = 1
                res.append(0)
            else:
                add = 0
                res.append(tmp)
        if add != 0:
            res.append(1)
        res.reverse()
        return res
```


## 73. 矩阵置零

[原题链接](https://leetcode-cn.com/problems/set-matrix-zeroes/comments/)

### 思路

用了额外空间记录哪些行和哪些列需要置 0，最后再遍历一遍数组。

```python
class Solution(object):
    def setZeroes(self, matrix):
        """
        :type matrix: List[List[int]]
        :rtype: None Do not return anything, modify matrix in-place instead.
        """
        m = len(matrix)
        n = len(matrix[0])
        
        mark_col = set()
        mark_row = set()
        
        for i in range(m):
            for j in range(n):
                if matrix[i][j] == 0:
                    mark_row.add(i)
                    mark_col.add(j)
                    
        for i in range(m):
            for j in range(n):
                if i in mark_row or j in mark_col:
                    matrix[i][j] = 0
```


## 80. 删除排序数组中的重复项 II

[原题链接](https://leetcode-cn.com/problems/remove-duplicates-from-sorted-array-ii/submissions/)

### 思路

题目要求使用 O(1) 空间复杂度，即不能使用额外空间，思路就是双指针+替换了。

- 指针 i 指向数组头部，题目要求最多只能出现两个重复数字，且数组有序，因此 `nums[i] == nums[i + 2]` 非法
- 此时要删除 `nums[i + 2]` 就要向后找到一个 `nums[j]`（满足 `nums[j] != nums[i]`）替换 `nums[i + 2]`

```python
# 这个好理解一些
class Solution:
    def removeDuplicates(self, nums: List[int]) -> int:
        i = 0
        for j in range(2, len(nums)):
            if nums[i] != nums[j]:
                nums[i + 2] = nums[j]
                i += 1
        # i 指向最后一个被交换的元素
        return i + 2
```

补充解法：

```python
class Solution:
    def removeDuplicates(self, nums: List[int]) -> int:
        i, count = 1, 1
        for j in range(1, len(nums)):
            if nums[j] == nums[j - 1]:
                count += 1
            else:
                count = 1

            if count <= 2:
                # 相同的数 <= 2，跳过 i
                nums[i] = nums[j]
                i += 1

        return i
```


## 88. 合并两个有序数组

[原题链接](https://leetcode-cn.com/problems/merge-sorted-array/submissions/)

### 思路

归并排序的最后一并。

从尾部开始遍历，否则会覆盖 nums1 的值。

```python
class Solution(object):
    def merge(self, nums1, m, nums2, n):
        """
        :type nums1: List[int]
        :type m: int
        :type nums2: List[int]
        :type n: int
        :rtype: void Do not return anything, modify nums1 in-place instead.
        """
        index1 = m - 1
        index2 = n - 1
        
        merge_index = m + n - 1
        
        while index1 >= 0 or index2 >= 0:
            if index1 < 0:
                nums1[merge_index] = nums2[index2]
                index2 = index2 - 1    
            elif index2 < 0:
                nums1[merge_index] = nums1[index1]
                index1 = index1 - 1
            elif nums1[index1] > nums2[index2]:
                nums1[merge_index] = nums1[index1]
                index1 = index1 - 1
            else:
                nums1[merge_index] = nums2[index2]
                index2 = index2 - 1
                
            merge_index = merge_index - 1
```


## 118. 杨辉三角

[原题链接](https://leetcode-cn.com/problems/pascals-triangle/)

### 思路

根据前一行推倒后一行的数据。

```python
class Solution(object):
    def generate(self, numRows):
        """
        :type numRows: int
        :rtype: List[List[int]]
        """
        res = list()
        for i in range(numRows):
            tmp = list()
            
            if i == 0:
                tmp.append(1)
            elif i == 1:
                tmp.append(1)
                tmp.append(1)
            else:
                pre = res[-1]
                tmp.append(1)
                for j in range(len(pre) - 1):
                    num = pre[j] + pre[j + 1]
                    tmp.append(num)
                tmp.append(1)
                
            res.append(tmp)
        return res
```

优化：

#### **Python**

```python
class Solution:
    def generate(self, numRows: int) -> List[List[int]]:
        ans = []
        for i in range(numRows):
            tmp = [1 for _ in range(i + 1)]
            for j in range(1, i):
                tmp[j] = ans[i - 1][j - 1] + ans[i - 1][j]
            ans.append(tmp)

        return ans
```

#### **Go**

```go
func generate(numRows int) [][]int {
    var res [][]int = make([][]int, numRows)

    for i := 0; i < numRows; i++ {
        res[i] = make([]int, i + 1)
        for j := 0; j < i + 1; j++ {
            if j == 0 || j == i {
                res[i][j] = 1
            } else {
                res[i][j] = res[i - 1][j - 1] + res[i - 1][j]
            }
        }
    }

    return res
}
```


## 119. 杨辉三角 II

[原题链接](https://leetcode-cn.com/problems/pascals-triangle-ii/submissions/)

### 解法一

笨蛋解法，根据前一行推倒后一行的数据。

```python
class Solution(object):
    def getRow(self, rowIndex):
        """
        :type rowIndex: int
        :rtype: List[int]
        """
        
        pre = list()
        
        for i in range(rowIndex + 1):
            cur = list()
            if i == 0:
                cur.append(1)
            elif i == 1:
                cur.append(1)
                cur.append(1)
            else:
                cur.append(1)
                for j in range(len(pre) - 1):
                    num = pre[j] + pre[j + 1]
                    cur.append(num)
                cur.append(1)
            pre = cur
            
        return cur
```

### 解二：递归

```python
class Solution:
    def generate(self, numRows: int) -> List[List[int]]:
        ans = []
        # 递归：输入上一行，返回下一行
        def helper(pre):
            length = len(pre)
            if length == numRows:
                return
            if length == 0:
                nxt = [1]
            elif length == 1:
                nxt = [1, 1]
            else:
                nxt = [1]
                for i in range(length - 1):
                    nxt.append(pre[i] + pre[i + 1])
                nxt.append(1)
            ans.append(nxt)
            helper(nxt)
        
        helper([])
        return ans
```

## 121. 买卖股票的最佳时机

[原题链接](https://leetcode-cn.com/problems/best-time-to-buy-and-sell-stock/description/)

### 思路

- 循环不断找寻：
    - 可买入的最小值
    - 可抛出的最大值

### Python

```python
class Solution:
    def maxProfit(self, prices):
        """
        :type prices: List[int]
        :rtype: int
        """
        day = 0
        res = 0
        for p in prices:
            if day == 0:
                pre = p
            else:
                if p > pre:
                    res = max(res, p - pre)
                else:
                    pre = p
            day = day + 1
        return res
```

### 复盘

2019.01.05 复盘打卡

<!-- tabs:start -->

#### **Python**

```python
class Solution(object):
    def maxProfit(self, prices):
        """
        :type prices: List[int]
        :rtype: int
        """
        if len(prices) == 0:
            return 0
        
        pre = prices[0]
        max_val = 0
        
        for price in prices:
            
            if price >= pre:
                max_val = max(max_val, price - pre)
            else:
                pre = price
        
        return max_val
```

#### **Go**

```go
func maxProfit(prices []int) int {
    dayCount := len(prices)
    if dayCount == 0 {
        return 0
    }
    res := 0
    min := prices[0]
    for i := 1; i < dayCount; i++ {
        get := prices[i] - min
        if get > res {
            res = get
        }
        if prices[i] < min {
            min = prices[i]
        }       
    }
    return res
}
```

<!-- tabs:end -->


## 167. 两数之和 II - 输入有序数组

[原题链接](https://leetcode-cn.com/problems/two-sum-ii-input-array-is-sorted/comments/)

### 解一：双指针

- 指针 i 指向最左端，从左到右依次循环
- 指针 j 指向最右端，从右到左依次循环
- total = numers[i] + numbers[j]
    - total == sum：得到结果
    - total > sum: j = j - 1，使 total 值减小
    - total < sum: i = i + 1, 使得 total 值增大

```python
class Solution(object):
    def twoSum(self, numbers, target):
        """
        :type numbers: List[int]
        :type target: int
        :rtype: List[int]
        """
        i = 0
        j = len(numbers) - 1
        while i != j:
            left = numbers[i]
            right = numbers[j]
            total = left + right
            
            if total > target:
                j = j - 1
            elif total < target:
                i = i + 1
            else:
                break
            
        return [i + 1, j + 1]     
```

- 时间复杂度 `O(n)`
- 空间复杂度 `O(1)`

### 解二：二分查找

```python
class Solution:
    def twoSum(self, numbers: List[int], target: int) -> List[int]:
        length = len(numbers)
        i = 0
        while i < length:
            j = i + 1
            target_j = target - numbers[i]
            left = j
            right = length - 1
            while left <= right:
                mid = (left + right) // 2
                if numbers[mid] == target_j:
                    return [i + 1, mid + 1]
                elif numbers[mid] < target_j:
                    left = mid + 1
                else:
                    right = mid - 1
            i += 1
```

- 时间复杂度 `O(nlogn)`
- 空间复杂度：`O(1)`

## 169. 多数元素

[原题链接](https://leetcode-cn.com/problems/majority-element/)

### 解法一：哈希表

计算每个数出现的个数，使用了额外空间。

空间复杂度 O(n)，时间复杂度 O(n)。

```python
class Solution(object):
    def majorityElement(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        mark_dict = dict()
        length = len(nums)
        
        for n in nums:
            if n in mark_dict:
                mark_dict[n] = mark_dict[n] + 1
            else:
                mark_dict[n] = 1
            if mark_dict[n] > length/2:
                return n
```

### 解法二：摩尔投票法

摩尔投票法，相互抵消。

时间复杂度 O(n)，空间复杂度 O(1)。

```python
class Solution(object):
    def majorityElement(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        major = 0
        count = 0
        
        for n in nums:
            if count == 0:
                major = n
                
            if n == major:
                count = count + 1
            else:
                count = count - 1
        
        return major
```

### 解法三：分治

@TODO

### 解法四：排序

@TODO


## 189. 旋转数组
   
[原题链接](https://leetcode-cn.com/problems/rotate-array/comments/)

### 解法一

- 双重循环
- 每次内循环都把所有数字往右移动一位
- 复杂度
    - 空间复杂度：`O(1)`
    - 时间复杂度：`O(k*n)`

写法超时：

```python
class Solution(object):
    def rotate(self, nums, k):
        """
        :type nums: List[int]
        :type k: int
        :rtype: None Do not return anything, modify nums in-place instead.
        """
        length = len(nums)
        k = k % length
        
        for i in range(k):
            tmp = nums[length - 1]
            for j in reversed(range(1, length)):
                nums[j] = nums[j - 1]
            nums[0] = tmp
```

### 解法二

翻转法，经过三次翻转：

1. 翻转 `0 ~ n-1`
2. 翻转 `0 ~ k-1`
3. 翻转 `k ~ n-1`

空间复杂度 `O(1)`，时间复杂度 `O(n)`。

```python
class Solution(object):
    def rotate(self, nums, k):
        """
        :type nums: List[int]
        :type k: int
        :rtype: None Do not return anything, modify nums in-place instead.
        """
        n = len(nums)
        k = k % n
        self.rever(nums, 0, n - 1)
        self.rever(nums, 0, k - 1)
        self.rever(nums, k, n - 1)
        
        
    def rever(self, nums, start, end):
        while start < end:
            tmp = nums[start]
            nums[start] = nums[end]
            nums[end] = tmp
            start = start + 1
            end = end - 1
```


## 215. 数组中的第K个最大元素

[原题链接](https://leetcode-cn.com/problems/kth-largest-element-in-an-array/comments/)

```python
class Solution:
    def partition(self, nums, l, r):
        v = nums[l]
        j = l

        for i in range(l + 1, r + 1):
            if nums[i] > v:
                j += 1
                nums[i], nums[j] = nums[j], nums[i]
        nums[l], nums[j] = nums[j], nums[l]

        # print(nums)
        # print(j)
        return j


    def findKthLargest(self, nums, k):
        """
        思路：利用快速排序算法每排一次都能找到一个正确位置的特点
        :type nums: List[int]
        :type k: int
        :rtype: int
        """
        l = 0
        r = len(nums) - 1
        j = self.partition(nums, l, r)
        while j != k - 1:
            if k - 1 > j:
                j = self.partition(nums, j+1,r)
            if k - 1 < j:
                j = self.partition(nums, l, j-1)
        # print(nums[j])
        return nums[j]
```

## 238. 除自身以外数组的乘积

[原题链接](https://leetcode-cn.com/problems/product-of-array-except-self/)

### 解法一

- `left[i]` 表示从左边开始到下标 `i` 的所有数的乘积
- `right[i]` 表示从右边开始到下标 `i` 的所有数的乘积
- 可得：所求 `output[i] = left[i - 1] * right[i + 1]`

```python
class Solution(object):
    def productExceptSelf(self, nums):
        """
        :type nums: List[int]
        :rtype: List[int]
        """
        left = dict()
        right = dict()
        length = len(nums)
        
        left[-1] = 1
        for i in range(length):
            left[i] = left[i - 1] * nums[i]
        
        right[length] = 1
        for j in reversed(range(length)):
            right[j] = right[j + 1] * nums[j]
        
        output = list()
        for i in range(length):
            tmp = left[i - 1] * right[i + 1]
            output.append(tmp)
            
        return output
```

### 解法二

除法，但题目说 `请不要使用除法`。。。。

1. 计算列表所有数的乘积 `total`
2. `output[i] = total / nums[i]`，需要特殊处理 nums 中出现 0 的情况

```python
class Solution(object):
    def productExceptSelf(self, nums):
        """
        :type nums: List[int]
        :rtype: List[int]
        """
        total = 1
        zero_count = 0
        for i in range(len(nums)):
            if nums[i] == 0:
                if zero_count == 0:
                    pass
                else:
                    total = 0
                zero_count += 1
            else:
                total = total * nums[i]
            
        output = list()
        for n in nums:
            if zero_count == 0:
                output.append(total / n)
            elif zero_count == 1:
                if n == 0:
                    output.append(total)
                else:
                    output.append(0)
                pass
            elif zero_count > 1:
                output.append(0)
        
        return output
```


## 240. 搜索二维矩阵

[原题链接](https://leetcode-cn.com/problems/search-a-2d-matrix-ii/description/)

### 思路

#### 分治

- 左下角的元素是这一行中最小的元素，同时又是这一列中最大的元素。比较左下角元素和目标： 
    - 若左下角元素等于目标，则找到
    - 若左下角元素大于目标，则目标不可能存在于当前矩阵的最后一行，问题规模可以减小为在去掉最后一行的子矩阵中寻找目标
    - 若左下角元素小于目标，则目标不可能存在于当前矩阵的第一列，问题规模可以减小为在去掉第一列的子矩阵中寻找目标
- 若最后矩阵减小为空，则说明不存在

```python
class Solution:
    def searchMatrix(self, matrix, target):
        """
        :type matrix: List[List[int]]
        :type target: int
        :rtype: bool
        """
        m = len(matrix)
        if m == 0:
            return False
        n = len(matrix[0])
        if n == 0:
            return False

        i = m - 1
        j = 0
        while i > 0 and j < n:
            if matrix[i][j] == target:
                return True
            elif matrix[i][j] < target:
                j = j + 1
            else:
                i = i - 1
        return False
```

#### 二分查找

- 遍历每一行，对每一行进行二分查找
- 初始化：left = 第一个元素下标, right = 最后一个元素下标，middle = (left + right) // 2
    - 如果 matrix[i][middle] = target，则找到
    - 如果 matrix[i][middle] < target，说明 target 不可能存在于数组的左半边，left = middle + 1
    - 如果 matrix[i][middle] > target，说明 target 不可能存在于数组的右半边，right = middle - 1

```python
class Solution:
    def searchMatrix(self, matrix, target):
        """
        :type matrix: List[List[int]]
        :type target: int
        :rtype: bool
        """
        m = len(matrix)
        if m == 0:
            return False
        n = len(matrix[0])
        if n == 0:
            return False

        i = 0
        while i < m:
            left = 0
            right = n - 1
            while left <= right:
                middle = (left + right) // 2
                if matrix[i][middle] == target:
                    return True
                elif matrix[i][middle] < target:
                    left = middle + 1
                else:
                    right = middle - 1
            i = i + 1
        return False
```




## 268. 缺失数字

[原题链接](https://leetcode-cn.com/problems/missing-number/submissions/)

### 思路

用 `O(1)` 空间与 `O(n)` 时间复杂度。

- 求 0-n 的和
- 减去现数组和，得到缺失的数

```python
class Solution(object):
    def missingNumber(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        nums_length = len(nums)
        nums_sum = (1 + nums_length) * nums_length / 2
        
        res = 0
        for n in nums:
            res += n
        
        return nums_sum - res
```


## 283. 移动零

[原题链接](https://leetcode-cn.com/problems/move-zeroes/description/)

### 思路

双指针 i, j。

- 初始化：i = 0, j = 1
- 当 i == 0 时
    - j == 0：j = j + 1
    - j !== 0：交换，交换后 i = i + 1, j = j + 1
- 当 i !== 0 时：i = i + 1, j = j + 1

### Python

```python
class Solution:
    def moveZeroes(self, nums):
        """
        :type nums: List[int]
        :rtype: void Do not return anything, modify nums in-place instead.
        """
        length = len(nums)
        i = 0
        j = 1
        while j < length:
            if nums[i] == 0:
                if nums[j] == 0:
                    j = j + 1
                else:
                    tmp = nums[i]
                    nums[i] = nums[j]
                    nums[j] = tmp
                    i = i + 1
                    j = j + 1
            else:
                i = i + 1
                j = j + 1
```

优化：让 `j` 跳过 0。

```python
class Solution:
    def moveZeroes(self, nums: List[int]) -> None:
        """
        Do not return anything, modify nums in-place instead.
        """
        i = 0
        for j in range(len(nums)):
            if nums[j] == 0:
                continue
            else:
                nums[i], nums[j] = nums[j], nums[i]
                i += 1

        return nums
```


## 287. 寻找重复数

[原题链接](https://leetcode-cn.com/problems/find-the-duplicate-number/)

### 解一

智障解法，但不太对，用了额外的空间。

```python
class Solution:
    def findDuplicate(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        list = [0 for i in range(len(nums))]
        for num in nums:
            if list[num] == 1:
                return num
            else:
                list[num] = list[num] + 1
```

### 解二

二分查找

- 取中间数 mid
- 判断寻找的数在左边还是右边

```python
class Solution:
    def findDuplicate(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        l = 1
        h = len(nums) - 1
        while l <= h:
            mid = (l + h) // 2
            cnt = 0
            for i in range(len(nums)):
                if nums[i] <= mid:
                    cnt = cnt + 1
            if cnt > mid:
                h = mid - 1
            else:
                l = mid + 1
        return l
```

### 解三

使用快慢指针。

将数组看成链表，val 是结点值也是下个节点的地址。因此这个问题就可以转换成判断链表有环，且找出入口节点。

1. 如果有环：快慢指针在某一点相遇
2. 此时再把其中一个指针移到起点，另一个指针移到相遇点（开始绕环跑），那么两个指针必然会在入口相遇

```python
class Solution(object):
    def findDuplicate(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        
        slow = 0
        fast = 0
        
        while True:
            fast = nums[nums[fast]]
            slow = nums[slow]
            
            if slow == fast: #相遇：说明存在环
                fast = 0 #一个从相遇点开始跑，一个从原点开始跑
                while nums[slow] != nums[fast]: #再次相遇：找到环的入口点
                    fast = nums[fast]
                    slow = nums[slow]
                return nums[slow]
```



## 334. 递增的三元子序列

[原题链接](https://leetcode-cn.com/problems/increasing-triplet-subsequence/)

### 思路

循环遍历数组，不断更新数组内出现的最小值与最大值，如果出现的一个大于最大值的数，则表示存在长度为 3 的递增子序列。

```python
class Solution(object):
    def increasingTriplet(self, nums):
        """
        :type nums: List[int]
        :rtype: bool
        """
        length = len(nums)
        if length < 3:
            return False
        
        min_num = float('inf')
        max_num = float('inf')
        
        for n in nums:
            if n < min_num:
                min_num = n
            elif min_num < n and n <= max_num:
                max_num = n
            elif n > max_num:
                return True
        
        return False
```


## 378. 有序矩阵中第K小的元素

[原题链接](https://leetcode-cn.com/problems/kth-smallest-element-in-a-sorted-matrix/description/)

### 解一

暴力解决。

- 对整个数组进行排序
- 返回第 k 小的数字（下标 k-1）

下面使用快速排序

```python
class Solution:
    def kthSmallest(self, matrix, k):
        """
        :type matrix: List[List[int]]
        :type k: int
        :rtype: int
        """
        m = len(matrix)
        n = len(matrix[0])

        i = 0
        j = 0
        l = []
        while i < m:
            while j < n:
                l.append(matrix[i][j])
                j = j + 1
            i = i + 1
            j = 0

        self.quickSort(l, 0, len(l) - 1)
        return l[k - 1]


    def quickSort(self, list, left, right):
        if left > right:
            return
        i = left
        j = right
        tmp = list[i]
        while i != j:
            while list[j] >= tmp and j > i:
                j = j - 1
            while list[i] <= tmp and i < j:
                i = i + 1
            if i < j:
                t = list[i]
                list[i] = list[j]
                list[j] = t
        list[left] = list[i]
        list[i] = tmp
        self.quickSort(list, left, i - 1)
        self.quickSort(list, i + 1, right)
```

### 解二

- 二分法设定 mid 值，判断 mid 是否为第 k 小元素
- 初始：mid = (min + max) / 2
- 统计每一行（所有行）小于 mid 值的个数之和 count
    - count < k：l = mid + 1
    - count > 8: h = mid
- 直到 l >= h 时，返回 l

没想到，附解题思路：https://leetcode.com/problems/kth-smallest-element-in-a-sorted-matrix/discuss/85173

```python
class Solution:
    def kthSmallest(self, matrix, k):
        """
        :type matrix: List[List[int]]
        :type k: int
        :rtype: int
        """
        l, h = matrix[0][0], matrix[-1][-1]
        while l < h:
            mid = (l + h) // 2
            count = 0
            for i in range(len(matrix)):
                for j in range(len(matrix[0])):
                    if matrix[i][j] > mid:
                        break
                    count = count + 1
            if count < k:
                l = mid + 1
            else:
                h = mid
        return l
```

## 463. 岛屿的周长

[原题链接](https://leetcode-cn.com/problems/island-perimeter/description/)

### 解法一：暴力法

遍历数组中的每一个点，如果遇到岛屿，即 `grid[i][j] == 1` 时，判断该岛屿的上侧和左侧是否存在岛屿。

- 上侧存在且左侧存在：不加边数
- 上侧面或左侧只有一侧存在：边数 +2
- 上侧和左侧都不存在：边数 +4

```python
class Solution:
    def islandPerimeter(self, grid: List[List[int]]) -> int:
        m = len(grid)
        if m == 0:
            return 0
        n = len(grid[0])
        res = 0
        
        for i in range(m):
            for j in range(n):
                if grid[i][j] == 1:
                    if i == 0 and j == 0:
                        res += 4
                        continue
                    if i - 1 >= 0 and j - 1 >= 0:
                        if grid[i - 1][j] == 0 and grid[i][j - 1] == 0:
                            res += 4
                        elif grid[i - 1][j] ^ grid[i][j - 1] == 1:
                            res += 2
                    elif i - 1 < 0:
                        if grid[i][j - 1] == 1:
                            res += 2
                        else:
                            res += 4
                    elif j - 1 < 0:
                        if grid[i - 1][j] == 1:
                            res += 2
                        else:
                            res += 4
        
        return res
```

### 解法二：算周长

因为岛屿内部没有湖，所以本质上就是求一个矩形的周长。所以只要求出岛屿的上侧（或下侧）与左侧（或右侧）的长度和即可，再将该长度乘以 2。

<!-- tabs:start -->

#### **Python**

```python
class Solution:
    def islandPerimeter(self, grid: List[List[int]]) -> int:
        m = len(grid)
        if m == 0:
            return 0
        n = len(grid[0])
        res = 0
        
        for i in range(m):
            for j in range(n):
                if grid[i][j] == 1:
                    if i == 0 or grid[i - 1][j] == 0:
                        res += 1
                    if j == 0 or grid[i][j - 1] == 0:
                        res += 1
                        
        return res*2
```

#### **Go**

```go
func islandPerimeter(grid [][]int) int {
    var res = 0
    for i := 0; i < len(grid); i++ {
        for j := 0; j < len(grid[0]); j++ {
            if grid[i][j] == 1 {
                if i == 0 || grid[i - 1][j] == 0 {
                    res += 1
                }
                if j == 0 || grid[i][j - 1] == 0 {
                    res += 1
                }
            }
        }
    }
    return res * 2
}
```

#### **Java**

```java
class Solution {
    public int islandPerimeter(int[][] grid) {
        if (grid == null || grid.length <= 0 || grid[0] == null || grid[0].length <= 0) return 0;
        int height = grid.length;
        int width = grid[0].length;

        int result = 0;

        for (int i = 0; i < height; i++) {
            for (int j = 0; j < width; j++) {
                if (grid[i][j] == 1) {
                    if (i == 0 || grid[i - 1][j] == 0) result++;
                    if (j == 0 || grid[i][j - 1] == 0) result++;
                }
            }
        }

        return result * 2;
    }
}
```

<!-- tabs:end -->

## 485. 最大连续1的个数

[原题链接](https://leetcode-cn.com/problems/max-consecutive-ones/description/)

### 思路

- 计算所有连续的数
- 取最大

### Python

```python
class Solution:
    def findMaxConsecutiveOnes(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        m = 0
        tmp = 0
        for num in nums:
            if num == 1:
                tmp = tmp + 1
            else:
                tmp = 0
            m = max(m, tmp)
        return m
```

## 498. 对角线遍历

[原题链接](https://leetcode-cn.com/problems/diagonal-traverse/)

### 解一

模拟整个过程。下一条对角线上的元素可以通过当前对角线推出 —— 向右走一格或向下走一格。

建立了几个变量用来记录中间值：

- `forward_flag`：判断此时对角线是从下往上走还是从上往下走
- `mark`：二维数组，用来标记某个位置是否已经处理过
- `stack`：用来装已经处理过的元素，便于推断出下一条对角线上的元素

代码写的非常不优雅……

```python
class Solution(object):
    def findDiagonalOrder(self, matrix):
        """
        :type matrix: List[List[int]]
        :rtype: List[int]
        """
        m = len(matrix)
        if m == 0:
            return []
        n = len(matrix[0])
        
        mark = [[0 for _ in range(n)] for _ in range(m)]
        
        stack = list()
        stack.append((0, 0))
        forward_flag = -1 #从上往下
        res = []
        res.append(matrix[0][0])
        while len(stack) > 0:
            new_stack = list()
            # print stack
            for x in range(len(stack) - 1, -1, -1):
                i, j = stack[x][0], stack[x][1]
                if forward_flag == -1:
                    if j + 1 < n and mark[i][j+1] == 0:
                        mark[i][j+1] = 1
                        new_stack.append((i, j + 1))
                        res.append(matrix[i][j+1])
                        
                    if i + 1 < m and mark[i+1][j] == 0:
                        mark[i+1][j] = 1
                        new_stack.append((i + 1, j))
                        res.append(matrix[i+1][j])
                elif forward_flag == 1:
                    
                    if i + 1 < m and mark[i+1][j] == 0:
                        mark[i+1][j] = 1
                        new_stack.append((i + 1, j))
                        res.append(matrix[i+1][j])
                        
                    if j + 1 < n and mark[i][j+1] == 0:
                        mark[i][j+1] = 1
                        new_stack.append((i, j + 1))
                        res.append(matrix[i][j+1])
            stack = new_stack
            forward_flag = -1 * forward_flag
            
        return res
```

### 解二

通过坐标元素 (x, y) 的和 `x + y` 来判断对角线的走向：

- 奇数：向下走
- 偶数：向上走

```
class Solution(object):
    def findDiagonalOrder(self, matrix):
        """
        :type matrix: List[List[int]]
        :rtype: List[int]
        """
        if not matrix:
            return []
        # m 行
        m = len(matrix)
        # n 列
        n = len(matrix[0])
        r = 0
        c = 0
        res = []
        
        for i in range(m * n):
            # print r, c
            res.append(matrix[r][c])
            if (r + c) % 2 == 0:
                # 偶数，向上走
                if c == n - 1: 
                    # 注意判断条件的顺序：先判断上边界
                    # 因为出现右上角 (0, 2) 时需要向下走一格 
                    r += 1
                elif r == 0:
                    c += 1
                else:
                    r -= 1
                    c += 1
            else:
                # 奇数，向下走
                if r == m - 1:
                    c += 1
                elif c == 0:
                    r += 1
                else:
                    r += 1
                    c -= 1
        return res
                
```
  
## 547. 朋友圈

[原题链接](https://leetcode-cn.com/problems/friend-circles/comments/)

### 思路

并查集~

- 初始时每个个体的根朋友为自己本身
- 若 M[i][j] == 1，说明 i 和 j是朋友
    - 找到 i 的根朋友 i_parent 和 j 的根朋友 j_parent
    - 若两者根朋友一样说明是一个朋友圈，不做操作
    - 若两者根朋友不一样，说明是不同的朋友圈，则执行合并朋友圈的操作：将j的根朋友 j_parent 的根朋友设置为 i 的根朋友 i_parent，总数减一

```python
class Solution(object):
    def findCircleNum(self, M):
        """
        :type M: List[List[int]]
        :rtype: int
        """
        n = len(M)
        self.data = [i for i in range(n)]
        for i in range(n):
            for j in range(n):
                if M[i][j]==1:
                    self.union(i,j)
        ret = set()
        for i in range(n):
            ret.add(self.find(i))
        return len(ret)
    def find(self,i):
        if self.data[i]!=i:
            self.data[i] = self.find(self.data[i])
        return self.data[i]
    def union(self,i,j):
        if i!=j:
            n = self.find(i)
            if n!=self.find(j):
                self.data[n]= self.data[j]  
```

## 561. 数组拆分 I

[原题链接](https://leetcode-cn.com/problems/array-partition-i/)

### 思路

对题目概括一下就是：把长度为 2n 的数组分为 n 份，每份两个元素，希望得到每份中**较小元素**相加和最大。

所以我们希望这个**较小元素**是每个组合中的较小元素，确是整个数组中的较大元素。

所以：

1. 对数组进行排序
2. 间隔取奇数位数，然后相加

```python
class Solution(object):
    def arrayPairSum(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        nums = sorted(nums)
        return sum(nums[::2])
```

## 565. 数组嵌套

[原题链接](https://leetcode-cn.com/problems/array-nesting/description/)

### 令人超时的操作

每个数都算一遍环，算着算着就超时了。

```python
class Solution:
    def arrayNesting(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        max_length = 0
        for i in range(len(nums)):
            cur_length = self.getLength(nums[i], nums)
            if cur_length > max_length:
                max_length = cur_length
        return max_length

    def getLength(self, begin_num, nums):
        tmp_list = []
        num = begin_num
        count = 0
        while num not in tmp_list:
            count = count + 1
            tmp_list.append(num)
            num = nums[num]
        return count
```

### 优化一下

- 开辟一个新的数组存储数字的环数
- 环内数字的环数是一样的，可以统一记录 
- 把用于存储的 list 换成了 set（不然还有两个测试用例过不了，擦汗。。。

```python
class Solution:
    def arrayNesting(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        max_length = 0
        self.nums = nums
        self.length_list = [0 for _ in range(len(nums))]
        for i in range(len(nums)):
            cur_length = self.getLength(nums[i])
            if cur_length > max_length:
                max_length = cur_length
        return max_length

    def getLength(self, num):
        if self.length_list[num]:
            return self.length_list[num]
        tmp_list = set()
        tmp_list.add(num)
        num = self.nums[num]
        while num not in tmp_list:
            tmp_list.add(num)
            num = self.nums[num]
        count = len(tmp_list)
        for i in tmp_list:
            self.length_list[i] = count
        return count
```


## 566. 重塑矩阵

[原题链接](https://leetcode-cn.com/problems/reshape-the-matrix/description/)

### Python

#### 解一

无脑暴力。。。

```python
class Solution:
    def matrixReshape(self, nums, r, c):
        """
        :type nums: List[List[int]]
        :type r: int
        :type c: int
        :rtype: List[List[int]]
        """
        nums_r = len(nums[0])
        nums_c = len(nums)
        if nums_r * nums_c != r * c:
            return nums

        all_nums = []
        for list in nums:
            for el in list:
                all_nums.append(el)

        index = 0
        result = []
        for i in range(0, r):
            tmp_list = []
            for j in range(0, c):
                tmp_list.append(all_nums[index])
                index = index + 1
            result.append(tmp_list)

        return result
```

#### 解二

- 直接根据下标进行行列转换：`result[i][j] = nums[index // nums_r][index % nums_r]`
- Python 二维数组申明方式：`[[0 for col in range(c)] for row in range(r)]`

```python
class Solution:
    def matrixReshape(self, nums, r, c):
        """
        :type nums: List[List[int]]
        :type r: int
        :type c: int
        :rtype: List[List[int]]
        """
        nums_r = len(nums[0])
        nums_c = len(nums)
        if nums_r * nums_c != r * c:
            return nums

        index = 0
        result = [[0 for col in range(c)] for row in range(r)]
        for i in range(0, r):
            for j in range(0, c):
                result[i][j] = nums[index // nums_r][index % nums_r]
                index = index + 1
        return result
```

### 复盘情况

- 2019-01-05 复盘 1，标星星


## 645. 错误的集合

[原题链接](https://leetcode-cn.com/problems/set-mismatch/description/)

### 解一

- 存储每个数字出现的次数
- 出现 0 次：被代替，出现 2 次：重复了

```python
class Solution:
    def findErrorNums(self, nums):
        """
        :type nums: List[int]
        :rtype: List[int]
        """
        list = [0 for i in range(len(nums))]
        for num in nums:
            list[num - 1] = list[num - 1] + 1
        result = []
        for i in range(len(list)):
            if list[i] == 0:
                lost = i + 1
            if list[i] == 2:
                twice = i + 1
        result.append(twice)
        result.append(lost)
        return result
```

### 解二

- 交换元素，使元素出现在正确的位置上 
- 再循环数组一遍，看看各位置元素的情况

```python
class Solution:
    def findErrorNums(self, nums):
        """
        :type nums: List[int]
        :rtype: List[int]
        """
        for i in range(len(nums)):
            while nums[i] != i + 1 and nums[nums[i] - 1] != nums[i]:
                self.swap(nums, i, nums[i] - 1)

        result = []
        for i in range(len(nums)):
            if nums[i] != i + 1:
                result.append(nums[i])
                result.append(i + 1)
        return result

    def swap(self, nums, i, j):
        tmp = nums[i]
        nums[i] = nums[j]
        nums[j] = tmp
```


## 667. 优美的排列 II

[原题链接](https://leetcode-cn.com/problems/beautiful-arrangement-ii/description/)

### 思路

一题找规律题。。。

```
n=100,k=24时

[1,25,2,24,3,23,4,22,5,21,6,20,7,19,8,18,9,17,10,16,11,15,12,14,13,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100]

n=100,k=25时

[1,26,2,25,3,24,4,23,5,22,6,21,7,20,8,19,9,18,10,17,11,16,12,15,13,14,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100] 
```

### python

```python
class Solution:
    def constructArray(self, n, k):
        """
        :type n: int
        :type k: int
        :rtype: List[int]
        """
        list = []
        tmp = k
        start = 1
        for i in range(k + 1):
            if i % 2 == 0:
                list.append(start)
                start = start + 1
            else:
                list.append(tmp + 1)
                tmp = tmp - 1

        j = k + 1
        while j < n:
            list.append(j + 1)
            j = j + 1
        return list
```


## 695. 岛屿的最大面积

[原题链接](https://leetcode-cn.com/problems/max-area-of-island/)

### 思路

dfs 方法：按照选优条件向前搜索，已达到目标。当达到某一步时，发现原先选择达不到目标，就退回一步重新选择。

```python
class Solution(object):
     def maxAreaOfIsland(self, grid):
        """
        :type grid: List[List[int]]
        :rtype: int
        """
        big = 0
        m = len(grid)  # m为行数
        n = len(grid[0]) # n为列数
        for i in range(0,m):
            for j in range(0,n):
                if grid[i][j] == 1:
                    big = max(big, self.dfs(grid,i,j))
        return big
       
     def dfs(self, grid, i ,j):
         cnt = 1
         m = len(grid)  # m为行数
         n = len(grid[0]) # n为列数
         grid[i][j] = -1
         out = [[-1,0],[1,0],[0,-1],[0,1]]
         for k in range(4):
             p = i + out[k][0]
             q = j + out[k][1]
             if(p>=0 and p<m and q>=0 and q<n and grid[p][q]==1):
                 cnt += self.dfs(grid,p,q)
         return cnt
```

## 697. 数组的度

[原题链接](https://leetcode-cn.com/problems/degree-of-an-array/description/)

### 思路

这题土办法很多，最怕的是超时，所以要在最小的循环次数中给出解答。

- freq_dict 字典放数的出现频率
- pos_dict 字段放数的出现位置
- 在一次循环中，不断计算频率的最大值与长度的最小值

### Python

```python
class Solution:
    def findShortestSubArray(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        freq_dict = {}
        pos_dict = {}
        min_length = 5000
        max_freq = 0

        for i in range(len(nums)):
            print freq_dict
            print pos_dict
            if nums[i] in pos_dict:

                if nums[i] not in freq_dict:
                    freq_dict[nums[i]] = 1
                else:
                    freq_dict[nums[i]] = freq_dict[nums[i]] + 1

                cur_length = i - pos_dict[nums[i]] + 1
                if freq_dict[nums[i]] > max_freq:
                    max_freq = freq_dict[nums[i]]
                    print max_freq
                    min_length = cur_length
                elif freq_dict[nums[i]] == max_freq:
                    if cur_length < min_length:
                        min_length = cur_length
            else:
                pos_dict[nums[i]] = i

        if max_freq == 0:
            return 1
        return min_length
```


## 766. 托普利茨矩阵

[原题链接](https://leetcode-cn.com/problems/toeplitz-matrix/description/)

### 解一

循环判断就好。

```python
class Solution:
    def isToeplitzMatrix(self, matrix):
        """
        :type matrix: List[List[int]]
        :rtype: bool
        """
        m = len(matrix)
        n = len(matrix[0])
        for i in range(1, m):
            for j in range(1, n):
                if matrix[i][j] != matrix[i - 1][j - 1]:
                    return False
        return True
```

### 解二：想复杂的超时辣鸡解法

辣鸡递归，想的太复杂了。

```python
class Solution:
    def isToeplitzMatrix(self, matrix):
        """
        :type matrix: List[List[int]]
        :rtype: bool
        """
        m = len(matrix)
        n = len(matrix[0])
        i = 0
        j = 0
        result = self.isTpl(i, j, m, n, matrix)
        return result


    def isTpl(self, i, j, m, n, matrix):
        if i+1 >= m or j+1 >= n:
            return True
        print matrix[i][j], matrix[i+1][j+1]
        if matrix[i][j] == matrix[i+1][j+1]:
            return self.isTpl(i+1, j, m, n, matrix) and self.isTpl(i, j+1, m, n, matrix)
        else:
            return False
```

## 724. 寻找数组的中心索引

[原题链接](https://leetcode-cn.com/problems/find-pivot-index/)

### 思路

1. 遍历一次 `nums`，将索引 `i` 左侧所有数字和赋值给 `left_sum[i]`，并计算所有数字总和 `s`；
2. 第二次遍历数组，由于 1 过程记录了左侧所有数字和，因此遍历到任何位置 `i` 时都可以得到：
    - 其左侧数字和 `left_sum[i]`
    - 其右侧数字和 `s - left_sum[i] - nums[i]`（即右侧数字和 = 所有数字总和 - 左侧数字和 - 当前元素）

对左右两侧数字和进行比较，如果相等就返回下标 `i`，若找不到则返回 `-1`。

```python
class Solution(object):
    def pivotIndex(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        left_sum = list()
        s = 0
        for n in nums:
            s += n
            left_sum.append(s - n)
            
        for i in range(len(nums)):
            left = left_sum[i]
            right = s - left - nums[i]
            if left == right:
                return i
        return -1
```

### 复杂度

- 时间复杂度 `O(n)`
- 空间复杂度 `O(n)`


## 769. 最多能完成排序的块

[原题链接](https://leetcode-cn.com/problems/max-chunks-to-make-sorted/description/)

### Python

- 要找到比**最大数**（一直在变）小的所有数，才能开始新的一段序列

```python
class Solution:
    def maxChunksToSorted(self, arr):
        """
        :type arr: List[int]
        :rtype: int
        """
        num = 0
        min_count = 0
        pre = 0
        pre_max = -1
        count = 0
        for i in range(len(arr)):
            if min_count == 0:
                min_count = arr[i] - pre_max - 1
                num = num + 1
                pre_max = arr[i]
            else:
                if arr[i] < pre_max:
                    min_count = min_count - 1
                else:
                    min_count = arr[i] - count
                if arr[i] > pre_max:
                    pre_max = arr[i]
            count = count + 1
        return num
```

## 807. 保持城市天际线

[原题链接](https://leetcode-cn.com/problems/max-increase-to-keep-city-skyline/)

### 思路

找出每一行、每一列的天际线，每个位置建筑的最大高度不能超过它所在行列的天际线。

<!-- tabs:start -->

#### **Python**

```python
class Solution:
    def maxIncreaseKeepingSkyline(self, grid: List[List[int]]) -> int:
        res = 0
        m = len(grid)
        n = len(grid[0])

        top = [0 for _ in range(n)]
        left = [0 for _ in range(m)]

        for i in range(m):
            for j in range(n):
                g = grid[i][j]
                left[i] = max(left[i], g)
                top[j] = max(top[j], g)

        for i in range(m):
            for j in range(n):
                g = grid[i][j]
                res += min(left[i], top[j]) - g
        
        return res
```

#### **Go**

```go
func maxIncreaseKeepingSkyline(grid [][]int) int {
    res := 0
    m := len(grid)
    n := len(grid[0])

    left := make([]int, m)
    top := make([]int, n)

    for i := 0; i < m; i++ {
        for j := 0; j < n; j++ {
            g := grid[i][j]
            left[i] = getMax(g, left[i])
            top[j] = getMax(g, top[j])
        }
    }

    for i := 0; i < m; i++ {
        for j := 0; j < n; j++ {
            g := grid[i][j]
            res += getMin(left[i], top[j]) - g
        }
    }

    return res
}

func getMax(a int, b int) int {
    if a > b {
        return a
    } else {
        return b
    }
}

func getMin(a int, b int) int {
    if a < b {
        return a
    } else {
        return b
    }
}
```

## 914. 卡牌分组

[原题链接](https://leetcode-cn.com/problems/x-of-a-kind-in-a-deck-of-cards/)

### 解一：暴力枚举

```python
class Solution:
    def hasGroupsSizeX(self, deck: List[int]) -> bool:
        if len(deck) == 0:
            return False
        min_num = 10000
        max_num = 0
        num_map = dict()
        for d in deck:
            if d not in num_map:
                num_map[d] = 0
            num_map[d] += 1
        
        for num_count in num_map.values():
            min_num = min(min_num, num_count)
            max_num = max(max_num, num_count)

        if min_num < 2:
            return False

        for i in range(2, max_num + 1):
            mark = True
            for num_count in num_map.values():
                if num_count < i or num_count % i != 0:
                    mark = False
                    break
            if mark:
                return True
        return False
```

- 时间复杂度：$O(n^2)$
- 空间复杂度：$O(n)$

### 解二：求最大公约数

要求的 x 必须是所有卡牌数量的约数。

@TODO

## 945. 使数组唯一的最小增量

[原题链接](https://leetcode-cn.com/problems/minimum-increment-to-make-array-unique/)

### 解一：计数

一开始暴力破解超时了，优化一下采用以下写法：

1. 先把重复出现的数字存储起来
2. 遍历 0~80000 的数字（最坏情况出现 40000 个 40000，最多可以叠加到 80000）
    - 如果发现数字是重复出现过的：
      - 将记录重复出现数字的 `repeat` 变量 + 1
      - 在结果 `res` 提前减去 `重复个数 * 重复数字`
    - 如果发现是空的位置：
      - 用空的位置处理一个重复出现的数字：`repeat -= 1`
      - 在 `res` 加上空位的数字  

```python
class Solution:
    def minIncrementForUnique(self, A: List[int]) -> int:
        count = [0 for _ in range(80000)]
        for x in A:
            count[x] += 1
        
        # 总数
        res = 0
        # 重复数量
        repeat = 0

        for i in range(80000):
            if count[i] > 1:
                # 出现重复
                repeat += count[i] - 1
                # 减去多余的数
                res -= i * (count[i] - 1)
            # 没有出现过的数
            if count[i] == 0 and repeat > 0:
                repeat -= 1 # 处理一个重复的数
                res += i
            
        return res
```

## 999. 车的可用捕获量

[原题链接](https://leetcode-cn.com/problems/available-captures-for-rook/)

### 思路

找车的四个方向是否能直接碰到卒。

```python
class Solution:
    def numRookCaptures(self, board: List[List[str]]) -> int:
        # 找到车的位置（R）
        m = len(board)
        if m == 0:
            return 0
        n = len(board[0])
        r_x, r_y = -1, -1
        for i in range(m):
            for j in range(n):
                if board[i][j] == 'R':
                    r_x, r_y = i, j
                    break
        res = 0
        # 找左侧
        for j in range(r_y - 1, -1, -1):
            if board[r_x][j] == 'B':
                break
            if board[r_x][j] == 'p':
                res += 1
                break
        # 找右侧
        for j in range(r_y + 1, n):
            if board[r_x][j] == 'B':
                break
            if board[r_x][j] == 'p':
                res += 1
                break
        # 找上侧
        for i in range(r_x - 1, -1, -1):
            if board[i][r_y] == 'B':
                break
            if board[i][r_y] == 'p':
                res += 1
                break
        # 找下侧
        for i in range(r_x + 1, m):
            if board[i][r_y] == 'B':
                break
            if board[i][r_y] == 'p':
                res += 1
                break
        
        return res
```

<!-- tabs:end -->

## 1002. 查找常用字符

[原题链接](https://leetcode-cn.com/problems/find-common-characters/)

### 思路

1. 将 `A[0]` 作为初始对比参照，赋值为 `tmp_string`
2. 查找下一个单词的每一个字母是否在 `tmp_string` 中出现：
    - 若出现：将该字母从 `tmp_string` 中删除，并将该字母存入临时列表 `tmp_list` 中
    - 未出现：继续循环
3. 完成一个单词的查找后，将 `tmp_list` 赋值给 `tmp_string`，重复步骤 2 

```python
class Solution(object):
    def commonChars(self, A):
        """
        :type A: List[str]
        :rtype: List[str]
        """
        length = len(A)
        if length == 0:
            return []
        
        tmp_string = list(A[0])
        for i in range(1, length):
            string = A[i]
            tmp_list = list()
            for s in string:
                if s in tmp_string:
                    s_index = tmp_string.index(s)
                    del tmp_string[s_index]
                    tmp_list.append(s)
            tmp_string = tmp_list
        
        return tmp_string
```

## 1013. 将数组分成和相等的三个部分

[原题链接](https://leetcode-cn.com/problems/partition-array-into-three-parts-with-equal-sum/)

### 思路

1. 数组求和，看是否可以整除三，不能整除则直接返回 `false`
2. 双指针指向数组前后，前后都分别开始找累加和等于目标值的部分，如果前后都能找到，则中间的自动就找到了

注意问题：

1. 存在 `[1,-1,1,-1]` 这样的用例，需要判断双指针最终位置，相距是否大于 1，即中间是否还有位置
2. 目标值可以为 0，所以左右区间的数据应当初始化为 `A[0]` 与 `A[length - 1]`

```python
class Solution:
    def canThreePartsEqualSum(self, A: List[int]) -> bool:
        # 求总和
        s = sum(A)
        if s % 3 != 0:
            return False
        part = s // 3

        # 双指针
        i = 0
        j = len(A) - 1
        # 计算左右区间和
        left_part = A[i]
        right_part = A[j]
        res = False
        while i < j:
            if left_part != part:
                i += 1
                left_part += A[i]
                
            if right_part != part:
                j -= 1
                right_part += A[j]
                
            if left_part == part and right_part == part:
                res = True
                break
        # print(i, j)
        # 处理特殊情况：[1,-1,1,-1]
        return res and j - i > 1
```

## 1071. 字符串的最大公因子

[原题链接](https://leetcode-cn.com/problems/greatest-common-divisor-of-strings/)

### 暴力枚举

最大公因子必定是 `str1` 或 `str2` 的前缀，因此枚举前缀的长度并截取前缀进行匹配即可。

```python
class Solution:
    def gcdOfStrings(self, str1: str, str2: str) -> str:
        length1 = len(str1)
        length2 = len(str2)
        for i in range(min(length1, length2), 0, -1):
            # 枚举
            if length1 % i == 0 and length2 % i == 0:
                # 是否可构成前缀
                if str1[:i] * (length1 // i) == str1 and str1[:i] * (length2 // i) == str2:
                    return str1[:i]
        return ''
```

- 时间复杂度：
- 空间复杂度：

### 数学法

若存在 `X`，那么有 `str1 + str2 = str2 + str1`。