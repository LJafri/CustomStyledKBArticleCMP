@IsTest
public class sbeccTestArticleController {
    //Set Up Basic Use
    static testMethod void CreateArticle() {
      String objectName;
        User testUser = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        System.runAs(testUser) {
          for (Schema.SObjectType o : Schema.getGlobalDescribe().values()) {
            Schema.DescribeSObjectResult obj = o.getDescribe();
            if (obj.getKeyPrefix() != null && obj.getName().endsWith('kav')) {
              try {
                List<sObject> sobjList = Database.query('SELECT Id FROM ' + String.escapeSingleQuotes(obj.getName()));
                  /* Insert test article */
                  Sobject knowledge = Schema.getGlobalDescribe().get(obj.getName()).newSobject();
                  objectName = obj.getName();
                  knowledge.put('title', 'Test Article');
                  knowledge.put('URLName', 'TestArticleUrl');
                  database.insert(knowledge);

                  String karticleId = (String)knowledge.get('id');
                  SObject k = Database.query('SELECT KnowledgeArticleId, Title, URLName FROM ' + String.escapeSingleQuotes(objectName) + ' WHERE Id =:karticleId');

                  String articleId = (String)k.get('KnowledgeArticleId');
                  // Publish Article
                  KbManagement.PublishingService.publishArticle(articleId, true);
                  // Prepare For testing....
                  // Set Fields/Objects/Ids
                  List<String> fields = new list<String> {'Title', 'UrlName'};
                  test.startTest();
                  sbeccArticleController.getArticle(k.Id, objectName, fields);
                  test.stopTest();
              } catch (QueryException e) {
                System.debug('Error: ' + e.getMessage());
                }
              }
            }
          }
        }
}