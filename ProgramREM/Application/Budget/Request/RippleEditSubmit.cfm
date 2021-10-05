
<!--- we log the old value and submit the amended 
                             ripple and we show the value --->
							 
<cfset rate        = replace("#Form.amount#",",","","ALL")>		

<cfif not LSIsNumeric(rate)>
	
		<script>
		    alert('Incorrect amount')
		</script>	 		
		<cfabort>
	
	</cfif>					 
		
<cfquery name="setRipple" 
	  datasource="AppsProgram" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		UPDATE    ProgramAllotmentRequest
		SET       RequestPrice      = '#rate#',		          
		          OfficerUserId     = '#session.acc#', 
				  OfficerLastName   = '#session.last#', 
				  OfficerFirstName  = '#session.first#', 
				  Created           = getDate()													
		WHERE     RequirementId     = '#url.id#'			
</cfquery>		

<cfquery name="get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   ProgramAllotmentRequest
	WHERE  RequirementId = '#url.id#'	
</cfquery>

<cfif get.AmountBaseAllotment neq get.RequestAmountBase>

	<cfquery name="set" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		  UPDATE ProgramAllotmentRequest
		  SET    AmountBaseAllotment = '#get.RequestAmountBase#'
		  WHERE  RequirementId = '#url.id#'	
	</cfquery>						
					
</cfif>			

<!--- log the new record --->					 

<cfinvoke component = "Service.Process.Program.ProgramAllotment"  
	  method           = "LogRequirement" 
	  RequirementId    = "#url.id#">	
	  
<!--- update the allotment --->		  
	  
<cfinvoke component = "Service.Process.Program.Program"  
		   method        = "SyncProgramBudget" 
		   ProgramCode   = "#get.ProgramCode#" 
		   Period        = "#get.Period#"
		   EditionId     = "#get.EditionId#">		  

<cfoutput>
	#numberformat(get.RequestAmountBase,',')#
</cfoutput>

<script>
	ProsisUI.closeWindow('myripple')
</script>

