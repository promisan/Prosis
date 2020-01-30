 				   				  		
<cfinvoke component = "Service.Access"  
	method         =   "AccessEntity" 
	objectid       =   "#url.ObjectId#"
	actioncode     =   "#url.ActionCode#" 
	mission        =   "#url.mission#"
	orgunit        =   "#url.OrgUnit#" 
	entitygroup    =   "#url.EntityGroup#" 
	returnvariable =   "dialogaccess">	
	
   <cfset ActionCodeEmbed = url.ActionCode>		
	 					
   <cfinclude template="../../#url.passtru#">
   
   
	   
