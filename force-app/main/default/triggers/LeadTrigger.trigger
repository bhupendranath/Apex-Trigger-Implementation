trigger LeadTrigger on Lead (before insert, after insert, before update, after update) {
    
    /*System.debug('Trigger size:'+ Trigger.size);
    System.debug('Is Trigger:'+ Trigger.isExecuting);
    System.debug('Trigger operation type:'+ Trigger.operationType);*/
    
    Switch on Trigger.operationType{
        when BEFORE_INSERT{
            LeadTriggerHandler.beforeInsertHandler(Trigger.new);
        }
        
        when AFTER_INSERT{
            LeadTriggerHandler.afterInsertHandler(Trigger.new);
        }
        
        when BEFORE_UPDATE{
            LeadTriggerHandler.beforeUpdatehandler(Trigger.new, Trigger.oldMap);
        }
    }
    
    /*for(Lead lead: Trigger.new){
        
        //if LeadSource is blank then make it other
        if(Trigger.isBefore && String.isBlank(lead.LeadSource)){
            lead.LeadSource = 'Other';
        }
        
        //to get old value of record :[Trigger.OldMap.get(lead.Id)]
        if((lead.Status == 'Closed - Converted' ||lead.Status == 'Closed - Not Converted') 
           && Trigger.OldMap.get(lead.Id).Status == 'Open - Not Contacted'){
   
               //Throwing error at field
               lead.Status.addError('Status can not be Closed when it\'s "Open - Not Contacted"');
           }
        //Validation rule on industry field
        if(String.isBlank(lead.Industry) && Trigger.isInsert){
            lead.addError('Industry can not be blank');
        }
    }*/

}