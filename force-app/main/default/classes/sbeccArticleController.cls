public with sharing class sbeccArticleController {
  @AuraEnabled(cacheable=true)
  public static sObject getArticle(Id recordId, String objectName, List<String> objectFields) {
      for (String field : objectFields) {
          field = String.escapeSingleQuotes(field);
      }
      sObject article = Database.query('SELECT ' + String.join(objectFields, ', ') + ' FROM ' + objectName + ' WHERE Id = :recordId');
      return article;
  }

}