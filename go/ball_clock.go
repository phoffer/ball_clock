// Paul Hoffer
// ball_clock.go
// Usage:
// go run clock.go
// go run clock.go 30 
// go run clock.go 30 325

package main

import "fmt"
import "os"
import "strconv"

func SliceEqual(a, b []int) bool {
    if len(a) != len(b) {
        return false
    }
    for i := range a {
        if a[i] != b[i] {
            return false
        }
    }
    return true
}

func Reverse(slice []int) []int {
    length := len(slice)
    reversed := make([]int, length)
    for i := range slice {
        reversed[i] = slice[length - i - 1]
    }
    return reversed
}
func InitQueue(n int) []int {
    queue := make([]int, n)
    for i := 1; i <= n; i++ {
        queue[i - 1] = i
    }
    return queue
}
func EmptyQueue(queue []int) []int {
    return make([]int, 0, len(queue))
}
func EmptyRow(row []int, queue []int) ([]int, []int) {
    return EmptyQueue(row), append(queue, Reverse(row)...)
}

func AddBall(next_ball int, queue []int) []int {
    return append(queue, next_ball)
}

func Tick(clock Clock) Clock {
    next_ball := clock.Queue[0]
    clock.Queue = clock.Queue[1:]

    clock.Current++
    switch {
    case clock.Current % 720 == 0:
        clock.M_queue, clock.Queue = EmptyRow(clock.M_queue, clock.Queue) // move ones
        clock.F_queue, clock.Queue = EmptyRow(clock.F_queue, clock.Queue) // move fives
        clock.H_queue, clock.Queue = EmptyRow(clock.H_queue, clock.Queue) // move hours
        clock.Queue = AddBall(next_ball, clock.Queue)
    case clock.Current % 60 == 0:
        clock.M_queue, clock.Queue = EmptyRow(clock.M_queue, clock.Queue) // move ones
        clock.F_queue, clock.Queue = EmptyRow(clock.F_queue, clock.Queue) // move fives
        clock.H_queue = AddBall(next_ball, clock.H_queue)
    case clock.Current % 5 == 0:
        clock.M_queue, clock.Queue = EmptyRow(clock.M_queue, clock.Queue) // move ones
        clock.F_queue = AddBall(next_ball, clock.F_queue)
    default:
        clock.M_queue = AddBall(next_ball, clock.M_queue)
    }
    return clock
}

type Clock struct {
  Queue []int
  M_queue []int
  F_queue []int
  H_queue []int
  Current int

}


func main() {
    ball_count := 30
    if len(os.Args) > 1 {
        ball_count, _ = strconv.Atoi(os.Args[1])
    }

    queue := InitQueue(ball_count)
    clock := Clock{Queue: queue}

    if len(os.Args) != 3 {
        minutes := 1
        clock = Tick(clock)
        for !SliceEqual(queue, clock.Queue) {
            clock = Tick(clock)
            minutes++
        }
        fmt.Println(minutes / 1440)
    } else {
        minute, _ := strconv.Atoi(os.Args[2])
        for current := 0; current < minute; current++ {
            clock = Tick(clock)
        }
        fmt.Println(clock.M_queue)
        fmt.Println(clock.F_queue)
        fmt.Println(clock.H_queue)
        fmt.Println(clock.Queue)

    }

}