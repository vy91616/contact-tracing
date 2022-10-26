public with sharing class CTPersonController {
    public static String getToken(String mobileNo) {
        Blob targetblob = Blob.valueOf(mobileNo);
        Blob hashblob = Crypto.generateDigest('md5', targetblob);
        return EncodingUtil.base64Encode(hashblob);
    }

    public static List<Person__c> getRecentHealthChanges(){
        return [select Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c from Person__c ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100];

    }

    public static List<Person__c> searchPeople(String searchTerm) {
        searchTerm = searchTerm + '%';
        return  [select Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c from Person__c WHERE Name LIKE :searchTerm OR Mobile__c LIKE :searchTerm OR Token__c LIKE :searchTerm ORDER BY Status_Update_Date__c DESC NULLS LAST];
    }

    public static Person__c getPersonById(String personId) {
        List<Person__c> person = [select Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c from Person__c where Id = :personId];
        if(person != null && person.size() >0){
            return person[0];
        }
        return null;
    }

    public static Map<String,Integer> getHealthStatusCount(){
        Map<String,Integer> healthcountmap = new Map<String,Integer>();
        for(AggregateResult ar : [SELECT COUNT(Id) total , Health_Status__c FROM Person__c GROUP BY Health_Status__c]){
            String key = String.valueOf(ar.get('Health_Status__c'));
            Integer value = Integer.valueOf(ar.get('total'));
            healthcountmap.put(key, value);
        }
        return healthcountmap;
    }
}

