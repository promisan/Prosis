
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="Form.Operational" default="0">

<cftransaction action="BEGIN">

<cfif #Form.Group# neq "">

<cfif #URL.ID1# eq "">

	<cfquery name="Insert" 
	     datasource="AppsSystem" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO Ref_ModuleControlUserGroup
	         (SystemFunctionId,
			 Account,
			 Operational,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName,	
			 Created)
	      VALUES ('#URL.ID#',
	      	  '#Form.Group#',
			  '#Form.Operational#',
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#',
			  getDate())
	</cfquery>
	
<cfelse>
	
   <cfquery name="Update" 
     datasource="AppsSystem" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     UPDATE Ref_ModuleControlUserGroup
	  SET Operational = '#Form.Operational#'
	 WHERE SystemFunctionId = '#URL.ID#'
	 AND Account = '#Form.Group#'
   	</cfquery>
	
</cfif>

</cfif>

</cftransaction>

<cfoutput>
	<script>
		 #ajaxLink('#SESSION.root#/System/Modules/Functions/Group.cfm?ID=#URL.ID#')#
	</script>	
</cfoutput> 
   
