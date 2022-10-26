public with sharing class CTLocationController {
    public static List<Location__c> getRecentStatusChanges(){
        return [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c FROM Location__c ORDER BY Status_Update_Date__c NULLS LAST LIMIT 100];
    }

    public static List<Location__c> searchLocation(String searchTerm){
        searchTerm = searchTerm + '%';
        return [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c FROM Location__c where Name LIKE :searchTerm OR Pincode__c LIKE :searchTerm OR Address__c LIKE :searchTerm ORDER BY Status_Update_Date__c DESC NULLS LAST];
    }

    public static Location__c getLocationById(String locationId){
        List<Location__c> location = [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c FROM Location__c where Id = :locationId];
        if(location != null && location.size() >0){
            return location[0];
        }
        return null;
    }

    public static Map<String,Integer> getStatusCount(){
        Map<String,Integer> helthcountmap = new Map<String,Integer>();
        for(AggregateResult ar: [select Status__c, Count(Id) total from Location__c group by Status__c]){
            helthcountmap.put(String.valueOf(ar.get('Status__c')) , Integer.valueOf(ar.get('total')));
        }
        return helthcountmap;
    }
}
