@IsTest(SeeAllData=true)
public class sbeccTestTopicController {
    //Communities Varaibles
    public static final List<Network> networks = [SELECT id, Name FROM Network];
    public static final Id networkId = networks[0].id;
    public static final String networkName = networks[0].Name;
    //Test Topic Varaibles
    public static final String TopicName = 'Test Topic Name';
    public static final String TopicName2 = 'Test Topic Name 2';
    public static final String TopicName3 = 'Test Topic Name 3';
    public static final String TopicName4 = 'Test Topic Name 4';

    @isTest(SeeAllData=true)
    static void testGetTopics() {
        //Insert Featured Topics
        ConnectApi.ManagedTopic topic = ConnectApi.ManagedTopics.createManagedTopicByName(networkId, TopicName, ConnectApi.ManagedTopicType.Featured);
        ConnectApi.ManagedTopic topicTwo = ConnectApi.ManagedTopics.createManagedTopicByName(networkId, TopicName2, ConnectApi.ManagedTopicType.Featured);
        //Insert Nav Topics
        ConnectApi.ManagedTopic topicThree = ConnectApi.ManagedTopics.createManagedTopicByName(networkId, TopicName3, ConnectApi.ManagedTopicType.Navigational);
        ConnectApi.ManagedTopic topicFour = ConnectApi.ManagedTopics.createManagedTopicByName(networkId, TopicName4, ConnectApi.ManagedTopicType.Navigational);
    
        String topicId = topicFour.iD;
        //Start The Test
        Test.startTest();
            //Test Featured Type
            List <ConnectApi.ManagedTopic> topics = sbeccTopicController.getTopics(networkName, 'Featured', topicId);
            //FAKE TEST
            List <ConnectApi.ManagedTopic> blat = sbeccTopicController.getTopics(networkName, 'Navigational', topicId);
            //Test Navigational Type
            List <ConnectApi.ManagedTopic> derp = sbeccTopicController.getTopics(networkName, 'Test', topicId);
        Test.stopTest(); 
        //End Test
    }

}