{ ... }: {
  system.defaults.CustomUserPreferences = {
    "com.apple.assistant.support" = {
      "Dictation Enabled" = true;
    };
    "com.apple.speech.recognition.AppleSpeechRecognition.prefs" = {
      DictationIMHasHandledEnablingDictation = true;
      DictationShortcuts = [ "Press Either Command Key Twice" ];
      DictationIMUseOnlyOfflineDictation = true;
      CACPersistentSleepState = false;
    };
    "com.apple.symbolichotkeys" = {
      AppleSymbolicHotKeys = {
        "63" = {
          enabled = true;
          value = {
            parameters = [ 65535 63 1048576 ]; # Any Command Key
            type = "standard";
          };
        };
        "164" = {
          enabled = true;
          value = {
            parameters = [ 65535 63 1048576 ]; # Any Command Key
            type = "standard";
          };
        };
      };
    };
  };
}
