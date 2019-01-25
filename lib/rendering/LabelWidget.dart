import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/rendering.dart';

class LabelWidget extends StatefulWidget {
  @override
  _LabelWidgetState createState() => _LabelWidgetState();
}

class _LabelWidgetState extends State<LabelWidget> {
  static const String childId = 'LABEL';
  final List<Widget> items = <Widget>[];
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _buildItems();
  }

  /// 构造 10 个子控件
  void _buildItems() {
    for (int i = 0; i < 10; i++) {
      items.add(_buildChild(i));
    }
  }

  /// 构造子控件
  Widget _buildChild(int index) {
    return LayoutId(
        id: '$childId$index',
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
              color: Colors.orange,
            ),
            child: Material(
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
              shadowColor: Colors.blueAccent,
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
                splashColor: Colors.transparent,
                highlightColor: Colors.red,
                onTap: () {
                  final snackBar = SnackBar(
                    content: Text('Label$index'),
                    duration: Duration(milliseconds: 600),
                  );
                  _scaffoldKey.currentState.showSnackBar(snackBar);
                },
                child: Container(
                  width: 80.0 + Random().nextInt(40),
                  height: 40,
                  child: Center(
                    child: Text(
                      'Label$index',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('LabelWidget'),
        ),
        body: Container(
          child: CustomMultiChildLayout(
            delegate: _LabelDelegate(itemCount: items.length, childId: childId),
            children: items,
          ),
        ),
      ),
    );
  }
}

class _LabelDelegate extends MultiChildLayoutDelegate {
  final int itemCount;
  final String childId;

  // x 方向上的偏移量
  double dx = 0.0;

  // y 方向上的偏移量
  double dy = 0.0;

  _LabelDelegate({@required this.itemCount, @required this.childId});

  @override
  void performLayout(Size size) {
    // 获取父控件的 width
    double parentWidth = size.width;

    for (int i = 0; i < itemCount; i++) {
      // 获取子控件的 id
      String id = '${this.childId}$i';
      // 验证该 childId 是否对应一个 非空的 child
      if (hasChild(id)) {
        // layout child 并获取该 child 的 size
        Size childSize = layoutChild(id, BoxConstraints.loose(size));

        // 换行条件判断
        if (parentWidth - dx < childSize.width) {
          dx = 0;
          dy += childSize.height;
        }
        // 根据 Offset 来放置 child
        positionChild(id, Offset(dx, dy));
        dx += childSize.width;
      }
    }
  }

  /// 该方法用来判断重新 layout 的条件，
  @override
  bool shouldRelayout(_LabelDelegate oldDelegate) {
    return oldDelegate.itemCount != this.itemCount;
  }
}
