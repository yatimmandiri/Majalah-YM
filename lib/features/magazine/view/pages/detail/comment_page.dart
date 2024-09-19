import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:magazine/common/theme/app_text.dart';
import 'package:magazine/common/theme/color.dart';
import 'package:magazine/features/auth/controller/auth_controller.dart';
import 'package:magazine/features/magazine/controller/magazine_controller.dart';
import 'package:magazine/features/magazine/data/model/comment_model.dart';
import 'package:magazine/features/magazine/data/model/magazine_model.dart';
import 'package:magazine/shared/global-widgets/blank_item.dart';
import 'package:magazine/shared/global-widgets/dialog_custom.dart';
import 'package:magazine/shared/global-widgets/inputs.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({super.key});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final cAuth = Get.put(AuthController());
  final cMagazine = Get.put(MagazineController());
  final MagazineItem data = Get.arguments;
  final FocusNode focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  final controllerComment = TextEditingController();
  int? replyingToCommentId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  void sendComment() async {
    if (formKey.currentState!.validate()) {
      await cMagazine.sendComment(data.id!,
          parentId: replyingToCommentId ?? 0, content: controllerComment.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: BackButton(
          onPressed: () {
            cMagazine.getMagazine();
            Get.back();
          },
        ),
        title: Text(
          'Kolom Komentar',
          style: fLg.copyWith(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
                onTap: () => DialogCustom.showConfirmationDialog(
                    'Tindakan',
                    '1. Hapus, Tekan dan tahan area komentar\n2. Balas komentar, Tekan area komentar',
                    () {},
                    true),
                child: const Icon(CupertinoIcons.question_circle)),
          )
        ],
      ),
      body: RefreshIndicator(
        color: BaseColor.primary,
        onRefresh: () => cMagazine.getMagazine(),
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: SizedBox(
                height: size.height,
                child: GetBuilder<MagazineController>(builder: (_) {
                  final magazine = _.getMagazineById(data.id!);

                  if (magazine == null) {
                    return const Center(child: CircularProgressIndicator.adaptive());
                  }

                  if (magazine.comments!.isEmpty) {
                    return const Center(child: BlankItem());
                  }

                  List<CommentItem> sort = magazine.comments!.reversed
                      .where((comment) => comment.parentId == 0)
                      .toList();
                  return ListView.builder(
                    itemCount: sort.length,
                    padding: const EdgeInsets.only(bottom: 40),
                    itemBuilder: (context, index) {
                      final comment = sort[index];
                      _.fetchUser(comment.userId!);
                      return buildCommentItem(comment, magazine.comments!);
                    },
                  );
                }),
              )),
        ),
      ),
      bottomSheet: Material(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Form(
            key: formKey,
            child: Obx(() {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (cMagazine.getMagazineById(data.id!) != null) ...[
                    Expanded(
                        child: InputForm(
                      hintText: 'type...',
                      label: Text(replyingToCommentId != null
                          ? cMagazine.getAuthorName(
                                      replyingToCommentId!,
                                      cMagazine
                                          .getMagazineById(data.id!)!
                                          .comments!) ==
                                  cAuth.dataUser.id
                              ? 'Anda'
                              : 'Balas ${cMagazine.getAuthorName(replyingToCommentId!, cMagazine.getMagazineById(data.id!)!.comments!)}'
                          : ''),
                      radius: 20,
                      focusNode: focusNode,
                      controller: controllerComment,
                    )),
                  ],
                  if (cMagazine.loadButton) ...[
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator.adaptive(
                        backgroundColor: BaseColor.primary,
                      ),
                    )
                  ] else ...[
                    Container(
                      margin: const EdgeInsets.only(left: 3),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: BaseColor.secondary,
                          borderRadius: BorderRadius.circular(35)),
                      child: InkWell(
                        onTap: () {
                          sendComment();
                          controllerComment.clear();
                          setState(() {
                            replyingToCommentId = null;
                          });
                        },
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ]
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget buildCommentItem(CommentItem comment, List<CommentItem> allComments) {
    final children =
        allComments.where((c) => c.parentId == comment.id).toList();
    final user = cMagazine.getUserById(comment.userId!);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onLongPress: () {
            if (cAuth.dataUser.id == user!.id) {
              DialogCustom.showConfirmationDialog(
                  'Konfirmasi', 'Yakin ingin menghapus komentar anda?', () {
                cMagazine.deleteComment(data.id!, comment.id!);
              }, false);
            }
          },
          onTap: () {
            setState(() {
              if (comment.parentId! < 1) {
                if (replyingToCommentId == comment.id) {
                  replyingToCommentId = null;
                } else {
                  replyingToCommentId = comment.id;
                }
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Row(
              children: [
                const Icon(
                  CupertinoIcons.profile_circled,
                  color: Colors.grey,
                  size: 25,
                ),
                const SizedBox(
                  width: 7,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.username!.isNotEmpty
                            ? comment.username != cAuth.dataUser.name
                                ? comment.username.toString()
                                : 'Anda'
                            : '@user',
                        style: fBlackSm.copyWith(fontSize: 12),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        comment.content ?? '',
                        textAlign: TextAlign.justify,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  DateFormat('h:mm, d MMM yyyy').format(
                      DateTime.parse(comment.createdAt ?? '12-12-2000')),
                  textAlign: TextAlign.justify,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Column(
            children: children
                .map((childComment) =>
                    buildCommentItem(childComment, allComments))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget buildSubtitle(
      CommentItem comment, List<CommentItem> allComments, String userName) {
    final parentComment = allComments.firstWhere(
      (c) => c.id == comment.parentId,
      orElse: () => CommentItem(id: 0, content: '', userId: 0),
    );

    if (parentComment.id != 0) {
      return Text(
        userName == cAuth.dataUser.name
            ? 'Balas anda ${parentComment.id}'
            : 'Membalas $userName',
        style: fsecSm.copyWith(fontSize: 12),
      );
    } else {
      return const Text('');
    }
  }
}
