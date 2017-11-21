({
     getacc: function(component,searchString) {
         var action = component.get("c.getHitsAcc");
         debugger;
         action.setParams({
             srchstring: searchString
         });
         action.setCallback(this, function(response) {
			debugger;
             var state = response.getState();
             if (component.isValid() && state === "SUCCESS") {
                 component.set("v.isVisibleFile", true);
                 component.set("v.Acchits", response.getReturnValue());
             }
         });
         $A.enqueueAction(action);
     },
     getlead: function(component) {
         var action = component.get("c.getHitsLead");
         action.setParams({
             srchstring: "abc"
         });
         action.setCallback(this, function(response) {
             var state = response.getState();
             if (component.isValid() && state === "SUCCESS") {
                 component.set("v.isVisible", true);
                 component.set("v.Leadhits", response.getReturnValue());
             }
         });
         $A.enqueueAction(action);
     }
 })