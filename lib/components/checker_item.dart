import 'dart:io';
import 'package:cyfeer_apartment_handover/models/handover/handover_schedule.dart';
import 'package:cyfeer_apartment_handover/view_models/checker_item_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'add_image_button.dart';

class CheckerItemView extends ConsumerWidget {
  final CheckerItem item;
  final ValueChanged<CheckerItem>? onChanged;
  const CheckerItemView({super.key, required this.item, this.onChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = (item: item, onChanged: onChanged);
    final viewModel = ref.watch(checkerItemProvider(params)).item;
    final viewModelController = ref.read(checkerItemProvider(params).notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: IntrinsicHeight(
            child: SizedBox(
              width: 300,
              child: !viewModel.isVerified
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _statusChecklistItem(
                            viewModel.category,
                            viewModel.isVerified,
                            viewModelController.toggleCheck),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller:
                                TextEditingController(text: viewModel.note),
                            onChanged: (value) =>
                                viewModelController.updateNote(value),
                            decoration: InputDecoration(
                              labelText: 'Ghi chú',
                              labelStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide:
                                    BorderSide(color: Color(0xff6A6A6A)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide:
                                    BorderSide(color: Color(0xff97A5B5)),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 13.0,
                                horizontal: 12.0,
                              ),
                            ),
                            maxLines: 1,
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                        AddImageButton(
                          onPressed: () =>
                              viewModelController.addImage(context),
                        ),
                        SizedBox(
                          height: viewModel.imageUrls.isNotEmpty ? 150 : 0,
                          child: viewModel.imageUrls.isNotEmpty
                              ? ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      viewModel.imageUrls.length.clamp(0, 5),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: AspectRatio(
                                          aspectRatio: 165 / 100,
                                          child: Image.file(
                                            File(viewModel.imageUrls[index]),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return SizedBox(width: 10);
                                  },
                                )
                              : null,
                        ),
                      ],
                    )
                  : _statusChecklistItem(viewModel.category,
                      viewModel.isVerified, viewModelController.toggleCheck),
            ),
          ),
        ),
        const Divider(
          color: Color(0xffF1F1F1),
          thickness: 1.0,
        ),
      ],
    );
  }

  Widget _statusChecklistItem(
      String title, bool isChecked, VoidCallback onToggle) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          Row(
            children: [
              _CustomCheckbox(
                value: isChecked,
                onChanged: (_) => onToggle(),
              ),
              const SizedBox(width: 10),
              Text(
                'Đã nghiệm thu',
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const _CustomCheckbox({required this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      child: Container(
        padding: const EdgeInsets.all(2.0),
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          border: Border.all(
              color: value ? const Color(0xffFF8A00) : const Color(0xff3E4C59)),
          borderRadius: BorderRadius.circular(4),
          color: value ? const Color(0xffFF8A00) : Colors.white,
        ),
        child: value
            ? SvgPicture.asset(
                'assets/icons/checked.svg',
                fit: BoxFit.contain,
                width: 12,
                height: 12,
              )
            : null,
      ),
    );
  }
}
