
<!--- validations for Candidates --->

<cfcomponent>
	
	<cffunction name    = "Control" 
		    access      = "remote" 
		    returntype  = "any" 
		    output      = "true">					 
					
			 <cfargument name="Validator"          		type="string"  default="contentvalidation">			
			 <cfargument name="SystemFunctionId"   		type="string"  default="">	
			 <cfargument name="Owner"              		type="string"  default="">	
			 <cfargument name="Mission"            		type="string"  default="">	
			 <cfargument name="Object"             		type="string"  default="Candidate">		 
			 <cfargument name="ObjectKeyValue1"    		type="string"  default="">
			 <cfargument name="ObjectKeyValue2"    		type="string"  default="">
			 <cfargument name="ObjectKeyValue3"    		type="string"  default="">
			 <cfargument name="ObjectKeyValue4"    		type="string"  default="">
			 <cfargument name="Target"    		   		type="string"  default="">
			 <cfargument name="notificationLayout" 		type="string"  default="">
			 <cfargument name="notificationLayoutArea"  type="string"  default="">
			 						 
			<cfset exception = "0">		
			
			<cfoutput>
			<table width="100%" border="0">								
				<cfset link = "#session.root#/component/validation/ValidationListing.cfm?systemfunctionid=#systemfunctionid#&owner=#owner#&mission=#mission#&object=#object#&objectkeyValue1=#ObjectKeyValue1#&objectkeyValue2=#ObjectKeyValue2#&objectkeyValue3=#ObjectKeyValue3#&objectkeyValue4=#ObjectKeyValue4#&Target=#Target#&notificationLayout=#notificationLayout#&notificationLayoutArea=#notificationLayoutArea#">						
				<tr><td align="left" valign="top" style="padding-right:5px">							
					<cfdiv id="#validator#" bind="url:#link#">				 
				</td></tr>
			</table>
			</cfoutput>				
						 				
		</cffunction>						
		
</cfcomponent>	
