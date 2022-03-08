({
	handleCellClick : function(component, event, helper) {
		var click = component.getEvent("dateCellClick");
        console.log('Datecell controller click' + click);
        var weekend = component.get("v.weekend");
        if(!weekend){
             click.fire();
        }      

	}
})