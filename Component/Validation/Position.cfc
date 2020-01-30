
<!--- validations for Candidates --->

<cfcomponent>
	
	<cffunction name    = "ValidateName" 
		    access      = "remote" 
		    returntype  = "any" 
		    displayname = "initially set the connection object data reference table for checking" 
		    output      = "true">	
									 
			 <cf_assignid>
			 <cfparam name="ScopeId"            type="string"  default="#rowguid#">	
			 <cfparam name="Object"             type="string"  default="Attachment">	
			 <cfparam name="ControllerNo"       type="string"  default="1">		    
			 <cfparam name="ObjectContent"      type="query"   default="">		
			 <cfparam name="ObjectIdField"      type="string"  default="">	
			 <cfparam name="delay"              type="string"  default="5">	
			
						 				
	</cffunction>	 	
	
	
					
		
</cfcomponent>	
