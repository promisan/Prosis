<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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

