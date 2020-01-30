
<cfif "#URL.BehaviorCode#" eq "" 
	or "#URL.BehaviorDescription#" eq "" 
	or "#URL.PriorityCode#" eq "">
		
	<cfset error = "BehaviorError2">
				
	<cfinclude template="BehaviorRecord.cfm">

	
<cfelse>	

	<cfoutput>
	
	     <cf_interface cde="0">
		 	
		  <cfif #URL.Id2# eq "New">
		  	  
		       <cfif "#URL.BehaviorCode#" neq "" 
			       and "#URL.BehaviorDescription#" neq "" 
				   and "#URL.PriorityCode#" neq "">
		
					<cfquery name="Insert" 
						datasource="appsEPAS" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						INSERT INTO  ContractBehavior
								      (ContractId, 
									   BehaviorCode,
									   BehaviorDescription,
									   PriorityCode,
									   OfficerUserId,
									   OfficerLastName,
									   OfficerFirstName)
						  VALUES ('#URL.ContractId#',
						          '#URL.BehaviorCode#',
								  '#URL.BehaviorDescription#',
								  '#URL.PriorityCode#',
								  '#SESSION.acc#',
								  '#SESSION.last#',
								  '#SESSION.first#')
					 </cfquery>	
				 
				 </cfif>
		 
		 <cfelse>
		 
			 	<cfquery name="Update" 
					datasource="appsePas" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					UPDATE ContractBehavior
					SET    BehaviorCode        = '#URL.BehaviorCode#',
						   BehaviorDescription = '#URL.BehaviorDescription#',
						   PriorityCode        = '#URL.PriorityCode#'
					WHERE  ContractId          = '#URL.ContractId#' 
					  AND  BehaviorCode        = '#URL.BehaviorCodeOld#' 
				 </cfquery>	
		 
		 </cfif>
		 
		 <cfparam name="URL.BehaviorCodeOld" default="">
		 <cfparam name="URL.Training" default="0">
		 
		 <cfif #URL.Training# eq "false">
		 
		 <!---
		 
				 <cfquery name="Delete" 
					datasource="appsePas" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					DELETE FROM ContractTraining
					WHERE  ContractId   = '#URL.ContractId#' 
					  AND  BehaviorCode = '#Form.BehaviorCodeOld#' 
				 </cfquery>	
				 
				 --->
			 
		 <cfelse>	
		 
		     <cftry>
		 
		    	<cfquery name="Insert" 
				  datasource="appsEPAS" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  INSERT INTO  ContractTraining
						      (ContractId, 
							   BehaviorCode,
							   OfficerUserId,
							   OfficerLastName,
							   OfficerFirstName)
				  VALUES ('#URL.ContractId#',
				          '#URL.BehaviorCode#',
						  '#SESSION.acc#',
						  '#SESSION.last#',
						  '#SESSION.first#')
				</cfquery>	
				
				<cfcatch></cfcatch>
			 
			 </cftry>
		
		</cfif>
		
		<cfset URL.ID2 = "new">	
		<cfinclude template="BehaviorRecord.cfm">
					
	</cfoutput>	 
 	
</cfif>
  
