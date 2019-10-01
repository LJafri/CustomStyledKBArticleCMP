@IsTest(SeeAllData = true)
public class sbeccTestArticleController {
    //Set Up Basic Use
    static testMethod void CreateArticle() {
        User testUser = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        System.runAs(testUser) {
            // Create & Intert Test Article
            Knowledge__kav testArticle = new Knowledge__kav(
                Title = 'test article',
                UrlName = 'testarticleurl'
            );
            insert testArticle;
            // Select Test Article
            Knowledge__kav k = [ 
                SELECT KnowledgeArticleId, Title, UrlName
                FROM Knowledge__kav
                WHERE Id =: testArticle.Id
                LIMIT 1
            ];
            String articleId = k.KnowledgeArticleId;
            // Publish Article
            KbManagement.PublishingService.publishArticle(articleId, true);
            // Prepare For testing....
            // Set Fields/Objects/Ids
            List<String> fields = new list<String> {'Title', 'UrlName'};
            String objectName = 'Knowledge__kav';
            k = [
                SELECT KnowledgeArticleId, Title, UrlName
                FROM Knowledge__kav
                WHERE Id =: testArticle.Id
            ];
            // BLAST OFF
            test.startTest();
            sbeccArticleController.getArticle(k.Id, objectName, fields);
            test.stopTest();
        }
    } 
}