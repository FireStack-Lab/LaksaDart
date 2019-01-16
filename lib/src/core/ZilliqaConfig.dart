class ConfigItem {
  int CHAIN_ID;
  String Network_ID;
  String nodeProviderUrl;
  ConfigItem({int CHAIN_ID, String Network_ID, String nodeProviderUrl}) {
    this.CHAIN_ID = CHAIN_ID;
    this.Network_ID = Network_ID;
    this.nodeProviderUrl = nodeProviderUrl;
  }
}

class ZilliqaConfig {
  ConfigItem Default;
  ConfigItem Staging;
  ConfigItem TestNet;
  ConfigItem MainNet;
  ZilliqaConfig(Map<String, ConfigItem> config) {
    this.Default = config['Default'];
    this.Staging = config['Staging'];
    this.TestNet = config['TestNet'];
    this.MainNet = config['MainNet'];
  }
  void setDefault(ConfigItem config) {
    this.Default = config;
  }

  void setStaging(ConfigItem config) {
    this.Staging = config;
  }

  void setTestNet(ConfigItem config) {
    this.TestNet = config;
  }

  void setMainNet(ConfigItem config) {
    this.MainNet = config;
  }
}
