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
			// 互换
			nums[i], nums[j] = nums[j], nums[i]
			// i 在前进的过程中走的是 j 走过的路，一定不会再碰到 val
			i++
			j++
		}
	}

	return length - (j - i)
}