import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/features/users/view_models/avatar_view_model.dart';

/// 프로필 이미지
class Avatar extends ConsumerWidget {
  final String name;
  final String uid;
  final bool hasAvatar;
  const Avatar({
    super.key,
    required this.name,
    required this.uid,
    required this.hasAvatar,
  });

  Future<void> _onAvatarTap(WidgetRef ref) async {
    final xfile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 40, // 이미지 옹량 40%
      maxHeight: 150, // 이미지 사이즈
      maxWidth: 150,
    );

    // 이미지 고르지 않고 취소했따면
    if (xfile != null) {
      final file = File(xfile.path);
      ref.read(avatarProvider.notifier).uploadAvatar(file);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(avatarProvider).isLoading;
    return GestureDetector(
      onTap: isLoading ? null : () => _onAvatarTap(ref),
      child: isLoading
          ? Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: const CircularProgressIndicator.adaptive(),
            )
          : CircleAvatar(
              radius: 50,
              foregroundImage: hasAvatar
                  ? NetworkImage(
                      'https://firebasestorage.googleapis.com/v0/b/judy-tiktok-clone.appspot.com/o/avatars%2F$uid?alt=media&token=029a2805-8f99-445e-ae0d-c93c02ad9ab5&v=${DateTime.now().toString()}',
                    )
                  : null,
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(name),
            ),
    );
  }
}
