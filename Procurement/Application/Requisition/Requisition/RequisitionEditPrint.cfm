
<!--- printing --->

<cfquery name="Line" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT L.*
    FROM   RequisitionLine L
	WHERE  RequisitionNo = '#URL.ID#'
</cfquery>

<cfquery name="ItemMaster" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT R.*
    FROM   ItemMaster I, Ref_EntryClass R
	WHERE  I.EntryClass = R.Code
	AND    I.Code = '#Line.ItemMaster#'
</cfquery>

<cfoutput>

<cfif ItemMaster.RequisitionTemplate neq "">

	  <cf_assignId>
			
	  <cfquery name="InsertAction" 
		    datasource="AppsPurchase" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    INSERT INTO RequisitionLineAction 
				   (RequisitionNo, 
				    ActionId, 
					ActionStatus, 
					ActionMemo, 
					ActionDate, 
					OfficerUserId, 
					OfficerLastName, 
					OfficerFirstName) 
			SELECT RequisitionNo, 
				        '#rowguid#', 
						'#Line.actionStatus#', 
						'Print', 
						getDate(), 
						'#SESSION.acc#', 
						'#SESSION.last#', 
						'#SESSION.first#'
				 FROM   RequisitionLine
				 WHERE  RequisitionNo = '#URL.ID#'
		</cfquery>		
		
		<cfset path = replaceNoCase(ItemMaster.RequisitionTemplate,'\','\\','ALL')> 

	<script>	 	 
		 window.open("#SESSION.root#/Tools/Mail/MailPrepareOpen.cfm?id=print&ID1=#url.id#&ID0=#path#","_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
	</script>

<cfelse>

	<script>
	   alert("No print format defined")
	</script>

</cfif>

</cfoutput>