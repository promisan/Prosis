
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cftransaction action="BEGIN">

<cfif #URL.ID1# eq "">

	<cfquery name="Insert" 
	     datasource="AppsSystem" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO Ref_ModuleControlDeny 
	         (SystemFunctionId,
			 Mission,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName,	
			 Created)
	      VALUES ('#URL.ID#',
	      	  '#Form.Mission#',
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#',
			  getDate())
	</cfquery>
		
</cfif>

</cftransaction>
  	
<script>
	 <cfoutput>
	 #ajaxLink('#session.root#/System/Modules/Functions/TreeDeny.cfm?ID=#URL.ID#')#
	 </cfoutput> 
</script>	
   
