({
    handleInput  : function(component, event, helper) {
        //debugger;
        var searchString = document.getElementById("searchString").value;
        if(searchString.length > 3){
            helper.getacc(component,searchString);
        }
        //        helper.getlead(component);
    },
    init: function(component, helper) {
        debugger;
        component.set("v.isVisible", false);
        component.set("v.isVisibleFile", false);
    },
    setAcc: function(component, event, helper) {
        component.set("v.acc.Name", event.target.innerText);
        component.set("v.acc.Id", event.target.id);
        component.set("v.accountname", event.target.innerText);
        component.set("v.isVisible", false);
        component.set("v.isVisibleFile", true);
        component.set("v.parentid", event.target.id);
    },
    setSelected: function(component, event, helper) {
        var s = component.get("v.SelectedStuff");
        var x = event.target.id;
        var index = s.indexOf(x);
        if (index > -1) {
            s.splice(index, 1);
        } else {
            s.push(x);
        }
    },
    connectToEvent: function(component, event, helper) {
        var s = component.get("v.SelectedStuff");
        var action = component.get("c.connectToER");
        action.setParams({
            Ids: s
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": component.get("v.acc.Id")
                });
                navEvt.fire();
            }
        });
        $A.enqueueAction(action);
    }
})