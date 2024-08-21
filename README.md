# flutter_progress_bar_button

This is a Flutter animation progress button plugin

## Start

## Table of contents

- [circular_progress_button](#circular)
- [rectangle_progress_button](#rectangle)


<img src="https://p3-xtjj-sign.byteimg.com/tos-cn-i-73owjymdk6/f7749ad139774aa1b0e3c26f81df50d8~tplv-73owjymdk6-jj-mark-v1:0:0:0:0:5o6Y6YeR5oqA5pyv56S-5Yy6IEAgN19iaXQ=:q75.awebp?rk3s=f64ab15b&x-expires=1724835129&x-signature=y4swuXFFccOMf4mV6Mjl3o1dQq4%3D" alt="9cf3500ee058a8e3f38aaac5d5d4fd1d.gif" loading="lazy" class="medium-zoom-image"  width = 230 height = 500 >

### Simple Use Circular

<a id="circular"></a>

```dart
int progress=5;
CircularAnimatedProgressBar(
    size: 150,
    progress: (progress.clamp(0, 10) / 10),
    onPressed: () {
        setState(() {
        progress += 2;
        });
    })
```

### Simple Use Circular

<a id="circular"></a>

```dart
int progress=5;
 RectangleAnimatedProgressBar(
            progress: (progress.clamp(0, 10) / 10),
            enumPosition: PositionEnum.right,
            colorsWave: const [
              Color(0x4D2196f3),
              Color(0x662196f3),
              Color(0xCC2196f3),
            ],
            backgroundColor: const Color(0x262192F3),
            
          )
```
