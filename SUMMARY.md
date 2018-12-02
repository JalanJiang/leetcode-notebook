# Summary

* [Introduction](README.md)

## 动态规划

## 数组

* [删除排序数组中的重复项](/array/cn-26.md)
* [删除排序数组中的重复项](/array/cn-27.md)
* [买卖股票的最佳时机](/array/cn-121.md)
* [重塑矩阵](array/566.md)
* [移动零](array/283.md)
* [最大连续1的个数](array/485.md)

## 字符串

* [循环单词](/string/loop_word.md)

## 树

* [对称二叉树](/tree/cn-101.md)
* [最长同值路径](/tree/cn-687.md)

## 栈

* [两个队列实现栈](/stack/cn-225.md)

## 链表

* [两数相加](/link_list/cn-2.md)

## 枚举

* [好多鱼！](/enumeration/many_fish.md)

## 排序

* [堆排](/sort/heap.md)
    * [215](/sort/heap/215.md)
* [快排]()
    * [75](/sort/quick/75.md)

## 搜索

* [深度优先]()
    * [39](/research/dfs/39.md)
    * [40](research/dfs/40.md)

## 动态规划

* [动态规划]()
    * [70](/dynamic/70.md)

```

#include<iostream>
using namespace std;
 
int count(int n, int x) {
    int res = 0, j;
    for (int i = 1; j = n / i; i *= 10) {
        int high = j / 10;
        if (x == 0) {
            if (high)
                high--;
            else
                break;
        }
        res += high * i;
        int tem = j % 10;
        if (tem > x)
            res += i;
        else if (tem == x)
            res += n - j * i + 1;
    }
    return res;
}
 
int main(){
    int n;
    while (cin >> n){
        cout << count(n, 0);
        for (int i = 1; i <= 9; i++)
            cout << " " << count(n, i);
    }
    return 0;
}
```

