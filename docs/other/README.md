## 2019 力扣杯全国秋季编程大赛

[点击前往](https://leetcode-cn.com/contest/season/2019-fall/)

### 1. 猜数字

[原题链接](https://leetcode-cn.com/contest/season/2019-fall/problems/guess-numbers/)

#### 思路

```python
class Solution:
    def game(self, guess: List[int], answer: List[int]) -> int:
        res = 0
        for i in range(3):
            if guess[i] == answer[i]:
                res += 1
        return res
```

### 2. 分式化简

[原题链接](https://leetcode-cn.com/contest/season/2019-fall/problems/deep-dark-fraction/)

#### 思路

是一个不断“取反、相加”的循环。

```python
class Solution:
    def fraction(self, cont: List[int]) -> List[int]:
        length = len(cont)
        res = [cont[length - 1], 1]
        for i in range(length - 2, -1, -1):
            # 取反
            cur = cont[i]
            left = cur * res[0]
            res = [res[1] + left, res[0]]
        
        return res
```

### 3. 机器人大冒险

[原题链接](https://leetcode-cn.com/contest/season/2019-fall/problems/programmable-robot/)

#### 思路

先记录一波数据：

1. 把执行一次命令能走到的点都记录下来，记为 `path`
2. 把命令中 `R` 的次数记作 `px`，`U` 的次数记作 `py`

那么拿到一个点 `(x, y)` 时，求出需要循环执行命令的次数：

```
r = min(x // px, y // py)
```

循环 `r` 次命令后剩余的步数为：`(x - r * px, y - r * py)`。若 `(x - r * px, y - r * py)` 在 `path` 中，则说明可以走到点 `(x, y)`。

```python
class Solution:
    def robot(self, command: str, obstacles: List[List[int]], x: int, y: int) -> bool:
        path = set()
        path.add((0, 0))
        
        px = 0
        py = 0
        for c in command:
            if c == "R":
                px += 1
            else:
                py += 1
            path.add((px, py))
            
        def can_arrive(x, y):
            x_round = x // px
            y_round = y // py
            r = min(x_round, y_round)
            lx = x - r * px
            ly = y - r * py
            if (lx, ly) in path:
                return True
            else:
                return False
        
        if not can_arrive(x, y):
            return False
        
        for ob in obstacles:
            if ob[0] > x or ob[1] > y:
                continue
            if can_arrive(ob[0], ob[1]):
                return False
        
        return True
```

### 4. 覆盖

[原题链接](https://leetcode-cn.com/contest/season/2019-fall/problems/broken-board-dominoes/)

状态压缩 + 动态规划完成状态转移。

一个格子无非只有如下几种情况：

1. 放骨牌
   1. 横着放
   2. 竖着放
2. 不放骨牌
   1. 不是坏格子，选择不放
   2. 是坏格子，不可以放

来看一个 `n = 3, m = 3` 的栗子：

<img src="_img/questions/4-dp-state.png">

我们从上往下、从左往右对所有格子进行遍历。此时我们遍历到黄色格子 `0`，判断该格子能否放置骨牌：

1. 如果格子 `0` 是一个坏掉的格子：不能放置骨牌
2. 如果格子 `0` 不是一个坏格子：
   1. 如果上侧的格子 `3` 是一个未被占用的好格子：格子 `0` 可以竖放骨牌
   2. 如果左侧的格子 `1` 是一个未被占用的好格子：格子 `0` 可以横放骨牌
   3. 如果上侧格子 `3` 和左侧格子 `1` 都无法放置骨牌：格子 `0` 无法放置骨牌

由此，我们可以发现，对于一个格子来说，**它的前 `m` 个格子的状态决定了该格子放置骨牌的可能性**。

#### 状态表示

由于需要记录 `m` 个格子的状态，而一个格子又只有 2 种状态（放骨牌或不放骨牌），很自然地想到可以用**`m` 位二进制数**来表示这 `m` 个格子的状态。

- `0` 表示格子不放置骨牌
- `1` 表示格子放置骨牌 

`m` 个格子就有 $2^m$ 种状态。

#### 状态转移

我们从始至终都只需要用到**所遍历到格子的前 `m` 个格子的状态**，因此需要不断更新这 `m` 个格子的状态，即进行**状态转移**。上述栗子中，`(3, 2, 1)` 格子的状态就需要转移为 `(2, 1, 0)` 格子的状态。

这个步骤用位运算实现：

1. 坏格子：`砍掉状态最高位 -> 左移 1 位 -> 最低位置 1`
2. 不放骨牌：`砍掉状态最高位 -> 左移 1 位`
3. 横放骨牌：`砍掉状态最高位 -> 左移 1 位 -> 最低两位置 1`
4. 竖放骨牌：`砍掉状态最高位 -> 左移 1 位 -> 最低位置 1`

#### 动态规划

如果一个格子有多种放置骨牌的方法，又该怎么办？答案是用**动态规划**选择能放置最多骨牌数量的最优解。

我们开辟一个 $2^m$ 大小的数组空间 `dp`。数组的标为状态值，数组的值用于表示该状态下能摆放的最多骨牌数，当值为 `-1` 时表示该状态为非法状态。

#### 步骤总结

1. 从左往右、从上往下遍历格子（意图为计算下一个状态 `next_dp`）
2. 在当前格子中遍历所有 $2^m$ 种状态
3. 若状态非法，继续步骤 2
4. 若状态合法，根据状态转移计算出下一个状态 `next_state` 以及该状态下对应的 `dp`

#### 代码

复杂度为 $O(m * n * 2^m)$。

```python
class Solution:
    def domino(self, n: int, m: int, broken: List[List[int]]) -> int:
        # broken 记录
        broken_map = dict()
        for b in broken:
            if b[0] not in broken_map:
                broken_map[b[0]] = dict()
            broken_map[b[0]][b[1]] = True
            
        """
        是坏格子
        """
        def is_broken(a, b):
            if a in broken_map and b in broken_map[a]:
                return True
            else:
                return False
            
        """
        获取下一个状态
        put: 0-不放，1-横放，2-竖放，3-坏格子
        """
        def next_state(state, put):
            # 去除高位
            state = ~(1 << (m - 1)) & state
            
            if put == 0:
                # 不放牌
                return state << 1
            elif put == 1:
                # 横着放
                return ((state | 1) << 1) | 1
            elif put == 2:
                # 竖着放
                return (state << 1) | 1
            else:
                # 坏格子
                return (state << 1) | 1
            
        # 创建 dp
        dp = [-1] * (1 << m)
        dp[(1 << m) - 1] = 0 # 全 1 的置 0
        
        for i in range(n):
            for j in range(m):
                next_dp = [-1] * (1 << m)
                # 遍历所有状态
                for state in range(1 << m):
                    # 非法状态
                    if dp[state] == -1:
                        continue
                    
                    if is_broken(i, j):
                        # 是坏格子
                        next_dp[next_state(state, 3)] = max(next_dp[next_state(state, 3)], dp[state]) # 是从 dp 转义还是保持现状
                        continue
                       
                    # 不放
                    next_dp[next_state(state, 0)] = max(next_dp[next_state(state, 0)], dp[state])
                    
                    # 可以竖放
                    if i != 0 and (1 << (m - 1)) & state == 0:
                        next_dp[next_state(state, 2)] = max(next_dp[next_state(state, 2)], dp[state] + 1)
                    
                    # 可以横放
                    if j != 0 and 1 & state == 0:
                        next_dp[next_state(state, 1)] = max(next_dp[next_state(state, 1)], dp[state] + 1)
                
                dp = next_dp
                        
        return max(dp)
```

### 5. 发 LeetCoin

[原题链接](https://leetcode-cn.com/contest/season/2019-fall/problems/coin-bonus/)

把题中所有上级下级关系转化为一棵树。如果每次操作和查询都挨个遍历树的所有子节点是不现实的，分分钟超出时间限制。为了节省时间，我们需要对每个节点单独记录几个属性：

1. 节点的父节点（用于向上更新父节点值）`parent`
2. 节点和其子节点的 coin 总数 `coin`
3. 通过操作 2 操作该节点时下发的 coin 数量 `children_coin`
4. 该节点包含的子节点数 `count`

假设我们对节点 `node` 执行以下操作：

#### 操作 1

操作 1 发放 `val` 数量的 LeetCoin：

1. 更新 `node` 节点的 `coin += val`
2. 更新其所有父节点的 `coin += val`

#### 操作 2

操作 2 发放 `val` 数量的 LeetCoin，节点 `node` 共有 `node.count` 个子节点，因此共加上 LeetCoin `all_coin = node.count * val` 个：

1. 更新 `node` 节点的 `coin += all_coin`
2. 更新 `node` 节点的所有父节点 `coin += all_coin`
3. 更新 `node` 节点的 `children_coin += val`

#### 操作 3

`node` 节点与其子节点的所有 LeetCoin 和为：

```
node.coin + (node.parent.children_coin * node.count + node.parent.parnet.children_coin * node.count ......)
```

因为每个节点的 `children_coin` 代表对子节点产生的 LeetCoin 影响，因此计算每个节点与其子节点的 LeetCoin 之和时，需要往前遍历它的所有父节点，并加上 `children_coin * node.count`。

#### 实现

```python
class Node:
    def __init__(self):
        self.parent = None # 父节点
        self.children = [] # 子节点数组
        self.coin = 0 # 子树总coin
        self.children_coin = 0 # 2 操作分配的 coin（影响到所有子树）
        self.count = 1 # 子树节点数

class Solution:
    def bonus(self, n: int, leadership: List[List[int]], operations: List[List[int]]) -> List[int]:
        # 初始化数据
        nodes = dict()
        for i in range(1, n + 1):
            nodes[i] = Node()
        
        # 记录从属关系
        for leader, worker in leadership:
            lnode = nodes[leader]
            wnode = nodes[worker]
            lnode.children.append(wnode)
            wnode.parent = lnode
            
        """
        计算 count
        """
        def cal_count(root):
            for child in root.children:
                cal_count(child)
                root.count += child.count
            return
          
        """ 
        更新父项
        """
        def update_parents(node, coin):
            while node:
                node.coin += coin
                node = node.parent
        
        """
        获取查询结果
        """
        def get_res(node):
            res = node.coin
            node_count = node.count
            parent = node.parent
            while parent:
                res += parent.children_coin * node_count
                parent = parent.parent
            return res
        
        # 计算 count
        cal_count(nodes[1])
        
        res = []
        for op in operations:
            worker = op[1]
            if op[0] == 1:
                # 操作 1：个人发放
                nodes[worker].coin += op[2]
                update_parents(nodes[worker].parent, op[2]) # 更新它的所有父节点
            elif op[0] == 2:
                # 操作 2：团队发放
                all_coin = nodes[worker].count * op[2]
                # 当前节点加上数量
                nodes[worker].children_coin += op[2]
                nodes[worker].coin += all_coin
                # 更新父节点
                update_parents(nodes[worker].parent, all_coin)
            else:
                res.append((get_res(nodes[worker])) % (10**9 + 7))
        return res
```