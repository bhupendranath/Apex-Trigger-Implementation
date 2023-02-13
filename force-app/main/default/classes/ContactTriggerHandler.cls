public class ContactTriggerHandler {
    
    public static void afterInsertHandler(List<Contact> newContacts){
        Set<Id> accountIds = new Set<Id>();
            for(Contact con : newContacts){
                if(String.isNotBlank(con.AccountId)){
                    //write automation here
                    accountIds.add(con.AccountId);
                }
            }
            AccountContactService.updateActiveContacts(accountIds);
    }
    
    public static void afterUpdateHandler(List<Contact> newContactsList, Map<Id, Contact> oldConMap){
        Set<Id> accountIds = new Set<Id>();
            for(Contact con : newContactsList){
                if(String.isNotBlank(con.AccountId) && oldConMap.get(con.Id).Active__c != con.Active__c){
                    //write automation here
                    accountIds.add(con.AccountId);
                }
                if(oldConMap.get(con.Id).AccountId != con.AccountId){
                    accountIds.add(con.AccountId);
                    accountIds.add(oldConMap.get(con.Id).AccountId);
                }
            }
          AccountContactService.updateActiveContacts(accountIds);  
    }
    
    public static void afterDeleteHandler(List<Contact> oldContacts){
        Set<Id> accountIds = new Set<Id>();
            for(Contact con : oldContacts){
                if(String.isNotBlank(con.AccountId)){
                    //write automation here
                    accountIds.add(con.AccountId);
                }
            }
            AccountContactService.updateActiveContacts(accountIds);
    }
    
    public static void afterUndeleteHandler(List<Contact> newContacts){
        Set<Id> accountIds = new Set<Id>();
            // newContacts : this new contacts are recoverd from recycle bin
            for(Contact con : newContacts){
                if(String.isNotBlank(con.AccountId)){
                    //write automation here
                    accountIds.add(con.AccountId);
                }
            }
            AccountContactService.updateActiveContacts(accountIds);
    }
}