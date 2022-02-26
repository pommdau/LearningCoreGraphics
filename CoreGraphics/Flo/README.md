# [Core Graphics Tutorial: Getting Started](https://www.raywenderlich.com/8003281-core-graphics-tutorial-getting-started)

![image](https://i.imgur.com/wqRDDbo.png)

>If you have oddly sized straight lines, you need to position them at plus or minus 0.5 points to prevent anti-aliasing. 

# [Core Graphics Tutorial: Gradients and Contexts](https://www.raywenderlich.com/10946920-core-graphics-tutorial-gradients-and-contexts)

- 動かしたり頻繁に描画する場合は`CALayer`を使用する

>but if your views move around or need frequent redrawing, you should use Core Animation layers. Core Animation is optimized so that the GPU, not the CPU, handles most of the processing. In contrast, the CPU processes view drawing performed by Core Graphics in draw(_:).
>[How To Make a Custom Control Tutorial: A Reusable Knob
](https://www.raywenderlich.com/5294-how-to-make-a-custom-control-tutorial-a-reusable-knob)