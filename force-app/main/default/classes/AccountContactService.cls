public class AccountContactService {
    public static void updateActiveContacts(Set<Id> accountIds){
        
        //get aggregate result for all accounts
        List<AggregateResult> results = [SELECT AccountId, COUNT(Id) totalContacts FROM Contact 
                                                     WHERE Active__c = true AND AccountId IN:accountIds GROUP BY AccountId];
            
        //build final list of account to update
            Map<Id, Account> accsToUpdate = new Map<Id, Account>();
            for(AggregateResult result :results){
                        //get Account id and number of active contact
                        String accId = String.valueOf(result.get('AccountId'));
                        Integer totalcons = Integer.valueOf(result.get('totalContacts'));
                        
                        //make sure we use Id field in account to update it
                        Account acc = new Account(Id = accId, Active_Contact__c = totalcons);
                        accsToUpdate.put(accId,acc);
                       
                       //another way
                       //accsToUpdate.add(new Account(Id = accId, Active_Contact__c = totalcons)); 
             }
        
                   //update Account with zero active contact
                       for(Id accId : accountIds){
                           if(!accsToUpdate.containsKey(accId)){
                               accsToUpdate.put(accId,new Account(Id = accId, Active_Contact__c = 0));
                           }
                       }
        
            update accsToUpdate.values();
    }
}