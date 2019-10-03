public with sharing class sbeccArticleController {
  @AuraEnabled(cacheable=true)
  public static sObject getArticle(Id recordId, String objectName, List<String> objectFields) {
    SObject article;
    List<String> accessibleObjectFields = new List<String>();
      DescribeSObjectResult objectResult = Schema.getGlobalDescribe().get(objectName).getDescribe();
      if (objectResult.isAccessible()) {
        for (String field : objectFields) {
          if (objectResult.fields.getMap().get(field) != null) {
            DescribeFieldResult fieldResult = objectResult.fields.getMap().get(field).getDescribe();
            if (fieldResult.isAccessible()) {
              accessibleObjectFields.add(field);
            }
          }     
        }
        for (String field : accessibleObjectFields) {
           field = String.escapeSingleQuotes(field);
        }
        article = Database.query('SELECT ' + String.join(accessibleObjectFields, ', ') + ' FROM ' + objectName + ' WHERE Id = :recordId');
      }
    return article;
  }
}