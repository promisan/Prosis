<!--- ------------------ --->
<!--- leave entitlements --->
<!--- ------------------ --->
		
<cfquery name="Ent" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
	    FROM     Ref_LeaveType
		WHERE    LeaveAccrual = '3'
</cfquery>		
				
<cfloop query="Ent">
			
		<cfparam name="Form.#LeaveType#" default="0">
		<cfset val = evaluate("Form.#LeaveType#")>
						  	   
	    <cfquery name="ClearPrior" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 DELETE  PersonLeaveEntitlement 
			 WHERE   ContractId   = '#ctid#'
			 AND     LeaveType    = '#LeaveType#'
	    </cfquery>  
		
		<cfif val neq "0">
										      			  
			<cfquery name="Insert" 
				 datasource="AppsEmployee" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 INSERT INTO PersonLeaveEntitlement 
					 
		             (PersonNo,
					  ContractId,							  
					  DateEffective,
					  LeaveType,
					  DaysEntitlement,							 
					  OfficerUserId,
					  OfficerLastName,
					  OfficerFirstName)
							  
				 VALUES
						  
				  	('#Form.PersonNo#',
					 '#ctid#',
				     #STR#,
					 '#LeaveType#',
					 '#val#',							
					 '#SESSION.acc#',
				     '#SESSION.last#',		  
					 '#SESSION.first#' )
								 
			  </cfquery>	
		  
		  </cfif>							  
						
</cfloop>	