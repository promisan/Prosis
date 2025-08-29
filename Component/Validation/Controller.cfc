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
