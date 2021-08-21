

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
	  ptoken.location('TransactionViewGeneral.cfm?id=#URL.ID#&id1=#url.id1#&mission=#url.mission#&mandate=#url.mandate#&id3=#url.id3#&id4=#url.id4#&page=#url.page#&sort=#url.sort#&lay=#url.lay#')
	</script>

</cfoutput>



