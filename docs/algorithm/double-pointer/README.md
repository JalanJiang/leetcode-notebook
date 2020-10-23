## 16. 最接近的三数之和

[原题链接](https://leetcode-cn.com/problems/3sum-closest/)

### 思路

排序 + 双指针。

<!-- tabs:start -->

#### ** Python **

```python
class Solution:
    def threeSumClosest(self, nums: List[int], target: int) -> int:
        length = len(nums)
        if length < 3:
            return 0
        # 排序
        nums.sort()
        ans = nums[0] + nums[1] + nums[2]
        for i in range(length):
            num = nums[i]
            start = i + 1
            end = length - 1
            while start < end:
                s = num + nums[start] + nums[end]
                # 如果计算出的和 s 更接近 target，则更新 ans
                if abs(s - target) < abs(ans - target):
                    ans = s
                if s < target:
                    start += 1
                elif s > target:
                    end -= 1
                else:
                    return ans
        return ans
```

#### ** PHP **

```php
class Solution {

    /**
     * @param Integer[] $nums
     * @param Integer $target
     * @return Integer
     */
    function threeSumClosest($nums, $target) {
        $length = count($nums);
        if ($length < 3) {
            return 0;
        }
        sort($nums);
        $ans = $nums[0] + $nums[1] + $nums[2];
        $sum = 0;
        for ($i = 0; $i < $length; $i++) {
            $num = $nums[$i];
            $start = $i + 1;
            $end = $length - 1;
            while($start < $end) {
                $sum = $num + $nums[$start] + $nums[$end];
                if(abs($sum - $target) < abs($ans - $target)) {
                    $ans = $sum;
                }
                if ($sum < $target) {
                    $start++;
                } elseif ($sum > $target) {
                    $end--;
                } else {
                    return $ans;
                }
            }
        }
        return $ans;
    }
}
```

<!-- tabs:end -->

## 18. 四数之和

[原题链接](https://leetcode-cn.com/problems/4sum/)

### 思路

和三数之和思路差不多，只不过改为固定两个位置，然后再加上双指针。

注意一些枝剪条件，可以让算法更快。

```python
class Solution:
    def fourSum(self, nums: List[int], target: int) -> List[List[int]]:
        length = len(nums)
        if length < 4:
            return []
        nums.sort()
        res = []
        # 双重循环固定两个数
        # 外层循环，固定第一个数
        for i in range(length - 3):
            
            # 枝剪 1：第一个数字遇到重复值时跳出循环，防止出现重复结果
            if i > 0 and nums[i] == nums[i - 1]:
                continue
            # 枝剪 2: 最小的和大于 target 跳出循环
            if nums[i] + nums[i + 1] + nums[i + 2] + nums[i + 3] > target:
                break
            # 枝剪 3: 当前 i 还太小，寻找下一个
            if nums[i] + nums[length - 1] + nums[length - 2] + nums[length - 3] < target:
                continue
                
            a = nums[i]
            # 内层循环，固定第二个数
            for j in range(i + 1, length - 2):
                
                # 枝剪 1
                if j - i > 1 and nums[j] == nums[j - 1]:
                    continue
                # 枝剪 2
                if nums[i] + nums[j] + nums[j + 1] + nums[j + 2] > target:
                    break
                # 枝剪 3
                if nums[i] + nums[j] + nums[length - 1] + nums[length - 2] < target:
                    continue
                
                b = nums[j]
                # 双指针
                left = j + 1
                right = length - 1
                
                while left < right:
                    s = a + b + nums[left] + nums[right]
                    # 结果等于目标值
                    if s == target:
                        res.append([a, b, nums[left], nums[right]])
                        # 继续缩小两指针范围，寻找下一个目标
                        while left < right and nums[left] == nums[left + 1]:
                            left += 1
                        while left < right and nums[right] == nums[right - 1]:
                            right -= 1
                        left += 1
                        right -= 1
                    elif s > target:
                        right -= 1
                    else:
                        left += 1
                        
        return res
```

## 392. 判断子序列

[原题链接](https://leetcode-cn.com/problems/is-subsequence/)

### 思路

双指针。

指针 `i` 指向 `s` 第一个字符，指针 `j` 指向 `t` 第一个字符。逐一判断 `i` 所指向的字符是否在 `t` 中存在。

- 如果 `s[i] != t[j]`：`j = j + 1`，继续比对下一个字符
- 如果 `s[i] == t[j]`：`i = i + 1`，`j = j + 1`，继续进行下一个 `s[i]` 的查找

<!-- tabs:start -->

#### ** Python **

```python
class Solution(object):
    def isSubsequence(self, s, t):
        """
        :type s: str
        :type t: str
        :rtype: bool
        """
        s_length = len(s)
        t_length = len(t)
        
        i = 0
        j = 0
        
        while i < s_length and j < t_length:
            if s[i] == t[j]:
                i += 1
            j += 1
            
        return i == s_length
```

#### ** Swift **

```swift
class Solution {
    func isSubsequence(_ s: String, _ t: String) -> Bool {
        var sLength = s.count
        var tLength = t.count
        
        var i = 0
        var j = 0
        
        var sArray = Array(s)
        var tArray = Array(t)
        
        while i < sLength && j < tLength {
            var sc = sArray[i]
            var tc = tArray[j]
            
            if sc == tc {
                i += 1
            }
            j += 1
        }
        
        return i == sLength
    }
}
```

## 763. 划分字母区间

[原题链接](https://leetcode-cn.com/problems/partition-labels/)

### 思路

- 哈希
- 双指针

```python
class Solution:
    def partitionLabels(self, S: str) -> List[int]:
        # 字母最后出现的位置
        letter_ends = dict()
        for i in range(len(S)):
            s = S[i]
            letter_ends[s] = i
        
        ans = list()
        start = 0

        while start < len(S):
            begin = start
            # 字母最后出现的位置
            end = letter_ends[S[start]]
            while start < end:
                letter = S[start]
                letter_end = letter_ends[letter]
                # 如果字母最后出现位置大于 end，对 end 进行更新
                if letter_end > end:
                    end = letter_end
                start += 1
            ans.append(end - begin + 1)
            start = end + 1

        return ans
```

### 复杂度

- 时间复杂度：`O(n)`
- 空间复杂度：`O(26)`

<!-- tabs:end -->

## 面试题 10.01. 合并排序的数组

[原题链接](https://leetcode-cn.com/problems/sorted-merge-lcci/)

### 逆向双指针

- 定义两个指针 `cur_a` 与 `cur_b`，分别指向 A 数组与 B 数组的尾部，再定义一个指针 `cur` 指向 A 数组当前可以赋值的元素位置
- 比较 `cur_a` 与 `cur_b` 指向的两个元素，把较大的元素赋值给 `cur` 所在位置

<!-- tabs:start -->

#### **Python**

```python
class Solution:
    def merge(self, A: List[int], m: int, B: List[int], n: int) -> None:
        """
        Do not return anything, modify A in-place instead.
        """
        # 双指针：指向两个比较的数
        cur_a = m - 1
        cur_b = n - 1
        # 指向要赋值的位置
        cur = len(A) - 1

        while cur_a >= 0 and cur_b >= 0:
            a = A[cur_a]
            b = B[cur_b]
            # 取较大的放在后面
            if a >= b:
                A[cur] = a
                cur_a -= 1
            else:
                A[cur] = b
                cur_b -= 1
            cur -= 1
        
        while cur_b >= 0:
            A[cur] = B[cur_b]
            cur_b -= 1
            cur -= 1
```

#### **Go**

```go
func merge(A []int, m int, B []int, n int)  {
    curA := m - 1
    curB := n - 1
    cur := len(A) - 1

    for curA >= 0 && curB >= 0 {
        a := A[curA]
        b := B[curB]
        if a >= b {
            A[cur] = a
            curA -= 1
        } else {
            A[cur] = b
            curB -= 1
        }
        cur -= 1
    }

    for curB >= 0 {
        A[cur] = B[curB]
        curB -= 1
        cur -= 1
    }
}
```

<!-- tabs:end -->