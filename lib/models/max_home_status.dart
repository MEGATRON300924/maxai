class MaxHomeStatus {
  final bool isInstalled;
  final bool isLinked;
  final int onlineDevices;
  final int offlineDevices;

  const MaxHomeStatus({
    this.isInstalled = false,
    this.isLinked = false,
    this.onlineDevices = 0,
    this.offlineDevices = 0,
  });

  const MaxHomeStatus.empty() : this();

  MaxHomeStatus copyWith({
    bool? isInstalled,
    bool? isLinked,
    int? onlineDevices,
    int? offlineDevices,
  }) => MaxHomeStatus(
        isInstalled: isInstalled ?? this.isInstalled,
        isLinked: isLinked ?? this.isLinked,
        onlineDevices: onlineDevices ?? this.onlineDevices,
        offlineDevices: offlineDevices ?? this.offlineDevices,
      );
}
