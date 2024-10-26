abstract class AIService {
  
  Future<String> getLangValues(Map<String,Map<String,String>> langAndKeysAndValues);
  Future<void> getKeyValues(Map<String,String> keysAndValues);

}