import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/max_memory_service.dart';

class MemoryScreen extends StatefulWidget {
  const MemoryScreen({super.key});

  @override
  State<MemoryScreen> createState() => _MemoryScreenState();
}

class _MemoryScreenState extends State<MemoryScreen> {

  List memories = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final service = context.read<MaxMemoryService>();

    memories = await service.getMemories(
      userId: "local_user",
    );

    loading = false;

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("MAX Memory"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          await context.read<MaxMemoryService>().clearAll(
            userId: "local_user",
          );

          await load();

        },
        child: const Icon(Icons.delete_outline),
      ),

      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : memories.isEmpty
              ? const Center(
                  child: Text(
                    "MAX hasn't remembered anything yet.",
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: memories.length,
                  itemBuilder: (context, index) {

                    final memory = memories[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 14),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.psychology),
                        ),
                        title: Text(memory.key),
                        subtitle: Text(memory.value),
                        trailing: Text(
                          memory.type,
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}