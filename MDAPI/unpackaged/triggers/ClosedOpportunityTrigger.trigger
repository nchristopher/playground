trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {
    List <Task> tasksToBeCreated = new List<Task>();
    for(Opportunity opportunity : trigger.new){
        if(opportunity.Stagename.equalsIgnoreCase('Closed Won')){
            tasksToBeCreated.add(new Task(subject = 'Follow Up Test Task',whatId = opportunity.Id));
        }
    }
    insert tasksToBeCreated;
}