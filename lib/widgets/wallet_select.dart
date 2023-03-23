import 'package:echeckout/widgets/wallet_input.dart';
import 'package:flutter/material.dart';

import '../icons/custom_icons_icons.dart';
import '../theme/app_theme.dart';

class WalletSelect extends StatefulWidget {
  const WalletSelect({
    super.key,
    required this.options,
    required this.focusNode,
    required this.label,
    required this.onSelect,
    required this.controller,
    this.icon,
    this.search = false,
    this.errMsg,
    this.mb = 30,
    this.onTap,
    this.onClose,
  });
  final List options;
  final bool search;
  final FocusNode focusNode;
  final String label;
  final String? errMsg;
  final double mb;
  final Function(Map) onSelect;
  final Function(dynamic)? onTap;
  final VoidCallback? onClose;
  final IconData? icon;
  final TextEditingController controller;

  @override
  State<WalletSelect> createState() => _WalletSelectState();
}

class _WalletSelectState extends State<WalletSelect>
    with TickerProviderStateMixin {
  OverlayEntry? _overlay;
  OverlayState? _ovstate;
  final LayerLink _lnk = LayerLink();
  List _searched = [];
  String _keyword = '';
  String? _selected;
  GlobalKey _inpKey = GlobalKey();

  late AnimationController _scCtrl;
  late Animation<double> _scAnim;
  // final TextEditingController _txtCtrl = TextEditingController();

  @override
  void initState() {
    _scCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _scAnim = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _scCtrl, curve: Curves.ease));
    _scCtrl.addListener(() {
      _ovstate!.setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    if (_overlay != null && _overlay!.mounted) {
      _overlay!.remove();
    }
    super.dispose();
  }

  bool _opened = false;

  _closeOverlay() {
    if (_overlay != null && _overlay!.mounted) {
      _keyword = '';
      _scCtrl.reset();
      _overlay!.remove();
      setState(() {
        _opened = false;
      });
    }
  }

  _createOverlay() {
    BuildContext pctx = _inpKey.currentContext as BuildContext;
    if (_opened) {
      _closeOverlay();
      if (widget.onClose != null) {
        widget.onClose!();
      }
      return;
    }
    _opened = true;
    if (widget.onTap != null) {
      widget.onTap!(_closeOverlay);
    }
    _ovstate = Overlay.of(context);
    _scCtrl.forward();
    RenderBox rb = pctx.findRenderObject() as RenderBox;
    _overlay = OverlayEntry(
      builder: (ctx) => Positioned(
        height: (_keyword.isNotEmpty
                            ? _searched.length
                            : widget.options.length) *
                        45 +
                    (widget.search ? 75 : 0) >
                300
            ? 300
            : (_keyword.isNotEmpty ? _searched.length : widget.options.length) *
                    45 +
                (widget.search ? 75 : 0),
        width: rb.size.width,
        child: CompositedTransformFollower(
          link: _lnk,
          offset: Offset(rb.size.width, rb.size.height),
          child: FractionalTranslation(
            translation: const Offset(-1, 0),
            child: Transform.scale(
              scaleY: _scCtrl.value,
              alignment: Alignment.topCenter,
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xFFE6E8EB),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.08),
                        offset: Offset(0, 5),
                        blurRadius: 15,
                      ),
                    ],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.zero,
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Material(
                    borderRadius: BorderRadius.circular(8),
                    type: MaterialType.transparency,
                    child: Column(
                      children: [
                        if (widget.search)
                          Container(
                            margin: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                            padding: const EdgeInsets.symmetric(horizontal: 26),
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color(0xFFF8F8F8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  CustomIcons.search_1,
                                  color: Color(0xFFAAB0BA),
                                  size: 14,
                                ),
                                const SizedBox(width: 7),
                                Expanded(
                                  child: TextField(
                                    onChanged: (val) {
                                      _ovstate!.setState(() {
                                        _keyword = val;
                                        _searched = widget.options
                                            .where((s) => s['txt']
                                                .toLowerCase()
                                                .contains(
                                                    _keyword.toLowerCase()))
                                            .toList();
                                      });
                                    },
                                    style: const TextStyle(
                                      fontSize: AppTheme.fontSize,
                                      fontFamily: 'SF UI Display',
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Search',
                                      hintStyle: TextStyle(
                                        color: Color(0xFFAAB0BA),
                                        fontFamily: 'SF UI Display',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            itemCount: _keyword.isEmpty
                                ? widget.options.length
                                : _searched.length,
                            itemBuilder: (lctx, i) => GestureDetector(
                              onTap: () {
                                var sel = _keyword.isNotEmpty
                                    ? _searched[i]
                                    : widget.options[i];
                                widget.onSelect(sel);
                                _closeOverlay();
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                child: Text(
                                  _keyword.isNotEmpty
                                      ? _searched[i]['txt']
                                      : widget.options[i]['txt'],
                                  style: TextStyle(
                                    color: Theme.of(ctx).primaryColorDark,
                                    fontSize: AppTheme.fontSize,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
    _ovstate!.insert(_overlay as OverlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _lnk,
      child: Column(
        children: [
          Stack(
            children: [
              WalletInput(
                key: _inpKey,
                focusNode: widget.focusNode,
                label: widget.label,
                icon: widget.icon,
                mb: 0,
                readonly: true,
                controller: widget.controller,
                hasVal: widget.controller.text.isNotEmpty,
                errMsg: widget.errMsg,
                bg: Colors.white,
                onTap: _createOverlay,
              ),
              const Positioned(
                top: 25,
                right: 10,
                child: FractionalTranslation(
                  translation: Offset(0, -.5),
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xFFB3B9C3),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: widget.mb),
        ],
      ),
    );
    ;
  }
}
