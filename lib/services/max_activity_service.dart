import 'dart:math';

import '../models/max_activity.dart';

class MaxActivityService {

  static final Random _random = Random();

  static String message(
    MaxActivity activity,
  ) {

    switch (activity) {

      case MaxActivity.idle:
        return "";

      case MaxActivity.listening:
        return "Listening...";

      case MaxActivity.thinking:

        return [

          "Thinking...",

          "Connecting the dots...",

          "Working it out...",

          "Almost there...",

        ][_random.nextInt(4)];

      case MaxActivity.searching:

        return [

          "Searching the web...",

          "Looking for the best answer...",

          "Checking reliable sources...",

        ][_random.nextInt(3)];

      case MaxActivity.reasoning:

        return [

          "Breaking it down...",

          "Putting everything together...",

          "Looking at every angle...",

        ][_random.nextInt(3)];

      case MaxActivity.coding:

        return [

          "Writing code...",

          "Building your solution...",

          "Checking everything twice...",

        ][_random.nextInt(3)];

      case MaxActivity.generatingImage:

        return [

          "Painting your image...",

          "Creating your image...",

          "Adding the final touches...",

        ][_random.nextInt(3)];

      case MaxActivity.editingImage:

        return [

          "Editing your image...",

          "Making those changes...",

        ][_random.nextInt(2)];

      case MaxActivity.analyzingImage:

        return [

          "Looking at the image...",

          "Inspecting every detail...",

        ][_random.nextInt(2)];

      case MaxActivity.analyzingDocument:

        return [

          "Reading your document...",

          "Finding the important parts...",

        ][_random.nextInt(2)];

      case MaxActivity.summarizing:

        return [

          "Reading everything...",

          "Creating a summary...",

        ][_random.nextInt(2)];

      case MaxActivity.translating:

        return "Translating...";

      case MaxActivity.writing:

        return [

          "Writing...",

          "Finding the right words...",

        ][_random.nextInt(2)];

      case MaxActivity.remembering:

        return "Checking your memories...";

      case MaxActivity.savingMemory:

        return "Remembering this for later...";

      case MaxActivity.music:

        return [

          "Finding something you'll enjoy...",

          "Looking through your music...",

        ][_random.nextInt(2)];

      case MaxActivity.downloading:

        return "Downloading...";

      case MaxActivity.uploading:

        return "Uploading...";

      case MaxActivity.speaking:

        return "Speaking...";

    }

  }

}