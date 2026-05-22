import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../widget/default_scaffold.dart';

// ── 모델 ──────────────────────────────────────────────────────
class Todo {
  final int? id;
  final String title;
  final bool isDone;

  Todo({this.id, required this.title, this.isDone = false});

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'isDone': isDone ? 1 : 0,
      };

  Todo copyWith({int? id, String? title, bool? isDone}) => Todo(
        id: id ?? this.id,
        title: title ?? this.title,
        isDone: isDone ?? this.isDone,
      );
}

// ── DB 헬퍼 ───────────────────────────────────────────────────
class _TodoDatabase {
  static Database? _db;

  static Future<Database> get db async {
    _db ??= await _init();
    return _db!;
  }

  static Future<Database> _init() async {
    final path = p.join(await getDatabasesPath(), 'todos.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, _) => db.execute(
        'CREATE TABLE todos(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, isDone INTEGER)',
      ),
    );
  }

  static Future<int> insert(Todo todo) async =>
      (await db).insert('todos', todo.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);

  static Future<List<Todo>> getAll() async {
    final maps = await (await db).query('todos', orderBy: 'id DESC');
    return maps
        .map((m) => Todo(
              id: m['id'] as int,
              title: m['title'] as String,
              isDone: (m['isDone'] as int) == 1,
            ))
        .toList();
  }

  static Future<void> update(Todo todo) async => (await db).update(
        'todos',
        todo.toMap(),
        where: 'id = ?',
        whereArgs: [todo.id],
      );

  static Future<void> delete(int id) async => (await db).delete(
        'todos',
        where: 'id = ?',
        whereArgs: [id],
      );
}

// ── 화면 ──────────────────────────────────────────────────────
class SqfliteScreen extends StatefulWidget {
  const SqfliteScreen({super.key});

  @override
  State<SqfliteScreen> createState() => _SqfliteScreenState();
}

class _SqfliteScreenState extends State<SqfliteScreen> {
  List<Todo> _todos = [];
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final todos = await _TodoDatabase.getAll();
    setState(() => _todos = todos);
  }

  Future<void> _add() async {
    final title = _textController.text.trim();
    if (title.isEmpty) return;
    await _TodoDatabase.insert(Todo(title: title));
    _textController.clear();
    await _load();
  }

  Future<void> _toggle(Todo todo) async {
    await _TodoDatabase.update(todo.copyWith(isDone: !todo.isDone));
    await _load();
  }

  Future<void> _delete(int id) async {
    await _TodoDatabase.delete(id);
    await _load();
  }

  Future<void> _edit(Todo todo) async {
    final ctrl = TextEditingController(text: todo.title);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('수정'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(hintText: '내용 입력'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, ctrl.text.trim()),
            child: const Text('저장'),
          ),
        ],
      ),
    );
    ctrl.dispose();
    if (result != null && result.isNotEmpty) {
      await _TodoDatabase.update(todo.copyWith(title: result));
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final doneCount = _todos.where((t) => t.isDone).length;

    return DefaultScaffold(
      appBar: AppBar(title: const Text('sqflite (로컬 DB)')),
      body: SafeArea(
        child: Column(
          children: [
            // 입력
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: '할일 입력...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.3),
                      ),
                      onSubmitted: (_) => _add(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _add,
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      minimumSize: const Size(56, 56),
                    ),
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            ),

            // 통계
            if (_todos.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        size: 16, color: theme.colorScheme.primary),
                    const SizedBox(width: 6),
                    Text(
                      '총 ${_todos.length}개 · 완료 $doneCount개',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

            // 목록
            Expanded(
              child: _todos.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox_rounded,
                              size: 64, color: theme.colorScheme.outline),
                          const SizedBox(height: 12),
                          Text(
                            '할일을 추가해보세요',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _todos.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final todo = _todos[index];
                        return _TodoItem(
                          todo: todo,
                          onToggle: () => _toggle(todo),
                          onEdit: () => _edit(todo),
                          onDelete: () => _delete(todo.id!),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TodoItem({
    required this.todo,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: todo.isDone
              ? theme.colorScheme.primary.withValues(alpha: 0.3)
              : theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: ListTile(
        leading: GestureDetector(
          onTap: onToggle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: todo.isDone ? theme.colorScheme.primary : Colors.transparent,
              border: Border.all(
                color: todo.isDone
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline,
                width: 2,
              ),
            ),
            child: todo.isDone
                ? Icon(Icons.check, size: 14, color: theme.colorScheme.onPrimary)
                : null,
          ),
        ),
        title: Text(
          todo.title,
          style: theme.textTheme.bodyLarge?.copyWith(
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
            color: todo.isDone ? theme.colorScheme.onSurfaceVariant : null,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: onEdit,
              color: theme.colorScheme.primary,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              onPressed: onDelete,
              color: theme.colorScheme.error,
            ),
          ],
        ),
      ),
    );
  }
}
