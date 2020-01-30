
<cfquery name="getTask" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM   RequestTask	
		WHERE  RequestId    = '#URL.ID#'
		AND    TaskSerialNo = '#URL.serialNo#'			
	</cfquery>		

<cfoutput>

	#numberformat(getTask.TaskUoMQuantity,'__._')#
		
	 <input type="hidden" name="#url.serialno#_taskquantity" id="#url.serialno#_taskquantity" value="#numberformat(getTask.TaskUoMQuantity,'__._')#"
	     readonly onchange="taskedit('#url.id#','#url.serialno#','taskquantity',this.value)">		
		 		   
</cfoutput>		   