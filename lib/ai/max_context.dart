import 'memory_manager.dart';



class MaxMemoryContext {


  static String build(){


    final memory =

        MemoryManager.instance.memory;



    if(memory.isEmpty){

      return "No saved memory.";

    }



    return memory.entries

        .map(

          (item) =>

              "${item.key}: ${item.value}",

        )

        .join("\n");


  }

}