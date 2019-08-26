## 枚举

也称作**穷举**，从问题的所有可能解的集合里一一枚举各元素，用给定的条件判断哪些是**有用**的元素，这些元素即为解。

1. 给出解空间 —— 要枚举哪些元素
2. 减少枚举空间
3. 选择合适的枚举顺序

----

## 递归

> 递推的思维是正常人的思维，总是看着眼前的问题思考对策，解决问题是将来时；递归的思维，逼迫我们倒着思考，看到问题的尽头，把解决问题的过程看做过去时。

递归指：某个函数**直接或间接地调用自身**。这样一来，原问题就被转换为许多性质相同但规模更小的子问题。

### 关注点

- 需要关注：如何把原问题划分成符合条件的子问题
- 不需要关注：这个子问题是如何被解决的
- 技巧：明白一个函数的作用并相信它能完成这个任务，但千万不要试图跳进细节

### 特征

1. 结束条件
2. 自我调用

```
int func(传入数值) {
  if (终止条件) return 最小子问题解;
  // 调用自己去解决规模更小的子问题，直到到达结束条件
  return func(缩小规模);
}
```

### 练习

- 经典问题：归并排序
- [LeetCode 递归练习](https://leetcode-cn.com/tag/recursion/)
- [递归题解](algorithm/recursion/)
- [树：递归题解](data-structure/tree/recursion)

----

## 分治

分治算法的三个步骤：分解 -> 解决 -> 合并。

1. 分解原问题为结构相同的子问题
2. 分解到某个容易求解的边界之后，进行递归求解
3. 将子问题的解合并成原问题的解

### 归并排序

[归并排序](http://jalan.space/interview/algorithm/base/sort/merge-sort.html) 是典型的分治算法。

```
void merge_sort(一个数组) {
  if (可以很容易处理) return;
  merge_sort(左半个数组);
  merge_sort(右半个数组);
  merge(左半个数组, 右半个数组);
}
```

### 练习

- [LeetCode 分治练习](https://leetcode-cn.com/tag/divide-and-conquer/?utm_source=LCUS&utm_medium=banner_redirect&utm_campaign=transfer2china)
- [分治题解](algorithm/divide-and-conquer/)

----

## 贪心

- 模拟「贪心」的人做出的决策
- 每次都按照某种指标选取最优的操作
- **只关注眼前，不考虑以后可能造成的影响**

常见做法有：

1. **离线**：按某顺序排序，并按某顺序处理（例如从大到小）
2. **在线**：每次取范围内最大/最小的东西，并更新范围数据

### 练习

- [LeetCode 贪心练习](https://leetcode-cn.com/tag/greedy/)
- [贪心题解](algorithm/greedy/)