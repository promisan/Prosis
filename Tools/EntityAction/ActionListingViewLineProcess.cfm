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
<cfparam name="ActionProcess" default="Do it">

<cfset proctext = "#ActionProcess#">
<cfif proctext eq "">
	<cfset proctext = "Do it">
</cfif>

<cfoutput>  

 
 <cfif EnableQuickProcess eq "1">
 
 
 	<cfif ActionStatus eq "0" and (EntityAccess eq "EDIT" or EntityAccess eq "ALL") and Action eq "1">		
				 
		<td id="quick#ActionId#" name="quick#ActionId#" class="fixlength">						
		<cfif attributes.hideprocess eq "0" and actionTrigger eq "" and object_op is 1>		
			<input type="checkbox" class="radiol" name="confirmwf" id="confirmwf" style="display:none;" value="#ActionId#" checked onclick="toggleaction('#ActionId#')">		
		    <a class="Procets" id="d#ActionId#" href="javascript:submitwfquick('#ActionId#','#attributes.ajaxid#')">#proctext#</a>  			
		 </cfif>		
		
	 	</td>		
		
	</cfif>
	
 <cfelse>
 
  				
	 <cfif object_op is 1 and Action eq "1" and (EntityAccess eq "EDIT" or EntityAccess eq "READ")>	 			
	 	 
		 <td align="center" class="fixlength">			 		
			<cfif attributes.hideprocess eq "0" and actionTrigger eq "" and showaction is 1>		
			    <cfif Dialog.DocumentMode eq "Popup" and DisableStandardDialog eq "1" >				
				   <cfif EntityAccess eq "EDIT">
					  <a class="Procets" href="javascript:#Dialog.DocumentTemplate#('#ActionCode#','#ActionId#')">#proctext#</a>
					</cfif>   															
				<cfelse>				
					<cfif Attributes.Subflow eq "No">
						<a class="Procets" href="javascript:process('#ActionId#','#attributes.preventProcess#','#Attributes.ajaxid#','#ProcessMode#')">#proctext#</a>
					<cfelse>														   						
						<a class="Procets" href="javascript:process('#ObjectId#','#attributes.preventProcess#','#Attributes.ajaxid#','#ProcessMode#')">#proctext#</a>							   
					</cfif>	   								 										
				</cfif>	
			</cfif>
		 </td>	                       
	  </cfif>

  </cfif> 
	  
</cfoutput>