{ config, lib, ... }:
let
  cfg = config.my.lmStudio;
  user = config.system.primaryUser;
  homeDir = "/Users/${user}";

  # Only durable, user-intent settings. Ephemeral state (dismissedModals,
  # migration flags, window bounds) is intentionally omitted so LM Studio
  # manages it freely between rebuilds.
  settings = {
    language = "en";
    downloadsFolder = cfg.downloadsFolder;
    enableLocalService = cfg.enableLocalService;
    autoLoadBundledLLM = true;
    useHFProxy = true;
    hfSearchToken = "";
    hfDownloadToken = "";
    userInterfaceComplexityLevel = 2;
    sidebar = {
      showButtonNames = false;
    };
    configs = {
      expandConfigsOnClick = true;
    };
    chat = {
      showSuggestionsOnNewChat = true;
      alwaysShowPromptTemplate = false;
      useShiftEnterToSendMessage = false;
      useKeychordToRegenerate = true;
      unloadPreviousModelOnSelect = true;
      highlightChatMessageOnHover = true;
      doubleClickMessageToEdit = true;
      aiNamingMode = "auto";
      autoExpandReasoningBlocks = false;
      reasoningBlocksVignette = true;
      messageGenInfoMode = "lastMessage";
      visualizeSpeculativeDecoding = false;
      chatFullWidth = false;
      neverAskForToolConfirmation = false;
      skipToolConfirmationPatterns = [];
      showChatUtilityMenuLabels = true;
      pinnedPlugins = [];
      showRoleAndInsertButtons = false;
      scrollLastMessageToTop = "scrollToTopNoLatch";
      showTokenCountInChatListings = false;
    };
    developer = {
      showExperimentalFeatures = false;
      experimentalLoadPresets = false;
      showDebugInfoBlocksInChat = false;
      showModelDownloadOptionData = false;
      backendDownloadChannel = "stable";
      appUpdateChannel = "stable";
      allowDevelopmentPlugins = true;
      unloadPreviousJITModelOnLoad = true;
      jitModelTTL = {
        enabled = true;
        ttlSeconds = 3600;
      };
      autoUpdateExtensionPacks = true;
      autoDeleteExtensionPacks = true;
      separateReasoningContent = true;
      experimentFlags = [];
    };
    ui = {
      missionControlFullscreen = false;
      showModelFileNameInMyModels = false;
      configureLoadParamsBeforeLoad = false;
    };
    configPresetInclusiveness = {
      speculativeDecoding = false;
    };
    modelLoadingGuardrails = {
      mode = "high";
      customThresholdBytes = 4294967296;
    };
  };
in {
  options.my.lmStudio = {
    enable = lib.mkEnableOption "LM Studio local LLM runner";

    downloadsFolder = lib.mkOption {
      type = lib.types.str;
      default = "${homeDir}/.lmstudio/models";
      description = "Absolute path where LM Studio downloads and stores models.";
    };

    enableLocalService = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable the LM Studio local inference server (OpenAI-compatible API).";
    };
  };

  config = lib.mkIf cfg.enable {
    homebrew.casks = [ "lm-studio" ];

    # Note: LM Studio (Electron) uses atomic writes, which replace symlinks.
    # This file will be restored to the nix-declared state on each rebuild.
    # Close LM Studio before running darwin-rebuild to avoid write races.
    home-manager.users.${user} = { ... }: {
      home.file."Library/Application Support/LM Studio/settings.json" = {
        force = true;
        text = builtins.toJSON settings;
      };
    };
  };
}
