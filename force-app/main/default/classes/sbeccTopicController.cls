public class sbeccTopicController {
    @AuraEnabled(cacheable = true)
    public static List <ConnectApi.ManagedTopic> getTopics(String networkName, String topicType, String topicId) {
        //string commId = [Select Id from Network where Name =: networkName].Id;
        String commId;
        for (Sobject c : Database.query('SELECT Id FROM Network WHERE name=:networkName')) {
          commId = (String)c.get('Id');
        }

        List<string> topicIds = new string[]{topicId};
        List <ConnectApi.ManagedTopic> topicList = new List <ConnectApi.ManagedTopic> ();
        if (topicType == 'Featured') {
            ConnectApi.ManagedTopicCollection mtCollection = ConnectAPI.ManagedTopics.getManagedTopics(commId, ConnectApi.ManagedTopicType.FEATURED, 1);
            for (ConnectApi.ManagedTopic mtopic: mtCollection.managedTopics) {
                topicList.add(mtopic);
            }
        } else if (topicType == 'Navigational') {
            ConnectApi.ManagedTopicCollection mtCollection = ConnectAPI.ManagedTopics.getManagedTopics(commId, ConnectApi.ManagedTopicType.NAVIGATIONAL, 1);
            for (ConnectApi.ManagedTopic mtopic: mtCollection.managedTopics) {
                topicList.add(mtopic);
            }
        } else if (topicType == 'Child') {
            ConnectApi.ManagedTopicCollection mtCollection = ConnectAPI.ManagedTopics.getManagedTopics(commId, ConnectApi.ManagedTopicType.NAVIGATIONAL, topicIds, 3);
            for (ConnectApi.ManagedTopic mtopic: mtCollection.managedTopics) {
                topicList.add(mtopic);
            }
        } else { 
            ConnectApi.ManagedTopicCollection mtCollection = ConnectAPI.ManagedTopics.getManagedTopics(commId, ConnectApi.ManagedTopicType.FEATURED, 3);
            for (ConnectApi.ManagedTopic mtopic: mtCollection.managedTopics) {
                topicList.add(mtopic);
            }  
        }
        return topicList;
    }
}