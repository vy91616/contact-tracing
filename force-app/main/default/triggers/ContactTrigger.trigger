trigger ContactTrigger on Contact (after insert, after update, after delete, after undelete) {
    switch on Trigger.OperationType{
        when AFTER_INSERT{
            Set<Id> uniqueAccounts = new Set<Id>();
            for(Contact con: Trigger.new){
                if(String.isNotBlank(con.AccountId)){
                    uniqueAccounts.add(con.AccountId);          
                    
                }
                List<AggregateResult> result = [select AccountId, Count(Id) totalcontact from Contact where Active__c = true AND AccountId IN :uniqueAccounts group by AccountId];
                List<Account> accountstoupate = new List<Account>();
                for(AggregateResult results : result){
                    String accountId = String.valueOf(results.get('AccountId'));
                    Integer totalcontact = Integer.valueOf(results.get('totalcontact'));

                    Account acc = new Account(Id = accountId, Active_Contacts__c = totalcontact);
                    accountstoupate.add(acc);
                }
                update accountstoupate;
            }
        }

        when AFTER_UPDATE{
            Set<Id> uniqueAccounts = new Set<Id>();
            for(Contact con: Trigger.new){
                if(String.isNotBlank(con.AccountId) && Trigger.oldMap.get(con.Id).Active__c != con.Active__c){
                    uniqueAccounts.add(con.AccountId);          
                    
                }else if(Trigger.oldMap.get(con.Id).AccountId != con.AccountId){
                    uniqueAccounts.add(con.AccountId);  
                    uniqueAccounts.add(Trigger.oldMap.get(con.Id).AccountId);  
                }
                List<AggregateResult> result = [select AccountId, Count(Id) totalcontact from Contact where Active__c = true AND AccountId IN :uniqueAccounts group by AccountId];
                List<Account> accountstoupate = new List<Account>();
                for(AggregateResult results : result){
                    String accountId = String.valueOf(results.get('AccountId'));
                    Integer totalcontact = Integer.valueOf(results.get('totalcontact'));

                    Account acc = new Account(Id = accountId, Active_Contacts__c = totalcontact);
                    accountstoupate.add(acc);
                }
                update accountstoupate;
            }

        }
    }
        

}