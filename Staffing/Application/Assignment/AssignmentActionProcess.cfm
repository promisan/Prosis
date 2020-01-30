
<cfif URL.src eq "Assignment">

	<cfif url.act eq "1">  <!--- approve --->
		 
	 <cf_PAAssignmentAction action="confirm" actiondocumentno="#URL.doc#">	
			 
	 <!--- set action record --->
	  
	 <cfquery name="RegisterAction" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 	INSERT INTO EmployeeActionFlow
	         (ActionDocumentNo,		
			 ActionType,
			 ActionDescription,
			 ActionClass,		
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName,
			 ActionDate)
	    VALUES (
	          '#URL.doc#',		  
			  'MANUAL',
			  'Transaction confirmation',
			  'Approval',		 
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#',
			  getDate())
		 </cfquery>	   
		 
	</cfif>   

	<cfif url.act eq "8">  <!--- reject --->
			
		<!--- set status in source table --->
		
		<cf_PAAssignmentAction action="revert" actiondocumentno="#URL.doc#">	
					 
		<!--- set action record in the old way --->
		  
		<cfquery name="RegisterAction" 
		 datasource="AppsEmployee" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 INSERT INTO EmployeeActionFlow
			         (ActionDocumentNo,		
					 ActionType,
					 ActionDescription,
					 ActionClass,			
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName,
					 ActionDate)
		      VALUES ('#URL.doc#',		 
					  'MANUAL',
					  'Transaction rejection',
					  'Reject',			  
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#',
					  getDate())
		 </cfquery>
		
	</cfif>   

</cfif>

<cfoutput>

	<script language="JavaScript">
	  window.location = "AssignmentActionView.cfm?action=1&actionreference=#URL.doc#"
	</script>

</cfoutput>



