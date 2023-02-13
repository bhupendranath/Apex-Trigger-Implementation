public class LeadTriggerHandler {
    
    //to remove recurstion from trigger
    public static boolean alreadyExecuted = false;
    
    public static void beforeInsertHandler(List<Lead> newRecord){
        for(Lead lead:newRecord){
               //if LeadSource is blank then make it other
                if(String.isBlank(lead.LeadSource)){
                    lead.LeadSource = 'Other';
                } 
                //Validation rule on industry field
                if(String.isBlank(lead.Industry)){
                    lead.addError('Industry can not be blank');
                }
            }
    }
    
     public static void afterInsertHandler(List<Lead> newRecord){
        List<Task> newleads = new List<Task>();
            for(Lead lead: newRecord){
                //create a task 
                Task newLeadTask = new Task(Subject='newLeadTask follow up', WhoId=lead.Id);
                newleads.add(newLeadTask);
                //insert newLeadTask;
            }
            insert newleads;
            
            // recursion
            // this line will create same lead trigger again and then task will also created in this way
            // it will keep creating and we will endup in a deadlock
            
         if(LeadTriggerHandler.alreadyExecuted == false){
             LeadTriggerHandler.alreadyExecuted = true;
             Lead anotherLead = new Lead(LastName =' New test Lead',Company = 'Comp3', Status ='Open - Not Contacted',Industry ='Other' );
             insert anotherLead;
         }
            
    }
    
    public static void beforeUpdatehandler(List<Lead> newRecord, Map<Id, Lead> oldRecordMap){
        for(Lead lead: newRecord){
               //if LeadSource is blank then make it other
                if(String.isBlank(lead.LeadSource)){
                    lead.LeadSource = 'Other';
                } 
                //to get old value of record :[Trigger.OldMap.get(lead.Id)]
                if((lead.Status == 'Closed - Converted' ||lead.Status == 'Closed - Not Converted') 
                   && oldRecordMap.get(lead.Id).Status == 'Open - Not Contacted'){
           
                       //Throwing error at field
                       lead.Status.addError('Status can not be Closed when it\'s "Open - Not Contacted"');
                   }
            }
    }
    
}