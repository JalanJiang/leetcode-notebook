## 1103. 二叉树寻路

[原题链接](https://leetcode-cn.com/problems/path-in-zigzag-labelled-binary-tree/)

### 思路

根据二叉树的特性和给定的 `label` 可以求出 `label` 值所在的层数 `layer`：

```python
layer = int(math.sqrt(label)) + 1
```

知道层数后可以知道该层元素的构成。因为二叉树是按「之」字型打印的，所以偶数行是反序列表，奇数行是正序列表。因此元素构成为：

```python
begin = 2**(layer - 1)
end = 2**layer - 1

if layer % 2 == 1:
    elements = range(begin, end)
else:
    elments = range(begin - 1, end - 1, -1)
```

知道元素构成后可以得知 `label` 的下标 `cur_index`：

```python
if layer % 2 == 0:
    # 偶数行，反序
    cur_index = end - label
else:
    # 奇数行
    cur_index = label - begin
```

既而算出父节点下标：

```python
parent_index = cur // index
```

循环此过程。

总结一下：

1. 算出当前 `label` 所在层，可得知该层元素构成与 `label` 下标；
2. 根据此信息继续推出其父节点所在层、该层元素构成与父节点下标，因此可以知道父节点的值；
3. 重复该过程。

```python
import math

class Solution(object):
    def pathInZigZagTree(self, label):
        """
        :type label: int
        :rtype: List[int]
        """
        layer = int(math.log(label, 2)) + 1
        # print layer
        res = []
        begin = 2**(layer - 1)
        end = 2**layer - 1
        if layer % 2 == 0:
            # 偶数行，反序
            cur_index = end - label
        else:
            # 奇数行
            cur_index = label - begin
            
        while layer > 0:
            
            begin = 2**(layer - 1)
            end = 2**layer
            # print begin, end, layer, cur_index
            if layer % 2 == 1: 
                cur_label = range(begin, end)[cur_index]
            else:
                # print range(end - 1, begin - 1, -1)
                cur_label = range(end - 1, begin - 1, -1)[cur_index]
            res.append(cur_label)
            
            layer -= 1
            cur_index = cur_index // 2
            
        return res[::-1]
```