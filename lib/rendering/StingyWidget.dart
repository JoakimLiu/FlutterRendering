import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class StingyWidget extends StatefulWidget {
  @override
  _StingyWidgetState createState() => _StingyWidgetState();
}

class _StingyWidgetState extends State<StingyWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          constraints: BoxConstraints(
              maxWidth: double.infinity,
              minWidth: 100.0,
              maxHeight: 300.0,
              minHeight: 100.0),
          color: Colors.greenAccent,
          child: _Stingy(
            child: Container(
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}

class _Stingy extends SingleChildRenderObjectWidget {
  _Stingy({Widget child}) : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderStingy();
  }
}

class _RenderStingy extends RenderShiftedBox {
  _RenderStingy() : super(null);

  // 绘制方法
  @override
  void paint(PaintingContext context, Offset offset) {
    // TODO: implement paint
    super.paint(context, offset);
  }

  // 布局方法
  @override
  void performLayout() {
    // constraints: 表示父部件的约束
    // 布局 child 确定 child 的 size
    child.layout(
        BoxConstraints(
            minHeight: 0.0,
            maxHeight: constraints.minHeight,
            minWidth: 0.0,
            maxWidth: constraints.minWidth),
        parentUsesSize: true);

    print('constraints: $constraints');

    final BoxParentData childParentData = child.parentData;
    // child 的 偏移量 child.size.width 的到的值是在 layout(...) 方法里面的 BoxConstraints 中的 maxHeight 及 maxWidth 的值
    childParentData.offset = Offset(
        this.constraints.maxWidth - child.size.width,
        this.constraints.maxHeight - child.size.height);

    print('childParentData: $childParentData');

    // 确定自己（Stingy）的大小 类似于 Android View 的 setMeasuredDimension(...)
    size = Size(this.constraints.maxWidth, constraints.maxHeight);

    print('size: $size');
  }
}
