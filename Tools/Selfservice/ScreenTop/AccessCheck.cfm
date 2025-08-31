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
<span id="sessionvalid" style="width: 0px; height: 0px; line-height: 0px; font: 0px;display:none;"></span>
		
<!--- box to keep on checking if maybe the session is reestablished to then hide the password screen --->			
<span id="sessionvalidcheck" style="width:0px; height:0px; line-height:0px; font:0px;display:none"></span>

<!--- -------------------------------------------------------- --->	
<!--- validate of the access for the screen is correct-------- --->
<!--- -------------------------------------------------------- --->	

<cfif Attributes.MenuAccess eq "Yes">	
     
	<!--- -access is granted by on access to the function--------- --->			
	<!--- -this is possible for maintenance, inquiry screens and
	       some applications once correctly defined      --------- --->
	<!--- -------------------------------------------------------- --->	   

	<cfinvoke component="Service.Access"  
		    method="function"  
			SystemFunctionId="#attributes.SystemFunctionId#" 
			returnvariable="access">	
						
			
	<cfif access eq "DENIED">	
			
	   <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		 <tr><td align="center" height="40" style="height:40px" class="labelit">
			   <font color="FF0000">
			    <cf_tl id="Detected a problem with your role based authorization for this module"  class="Message">!
			   </font>
			</td>
		 </tr>
	   </table>	
	 				
	</cfif>		
				
<cfelseif Attributes.MenuAccess eq "Context">	

        <!--- record this template/URL but ONLY if the token is valid which is defined 
		by the time this screen loaded as we have a window of timing for it to be valid ---> 
		
		<!--- Dev 2/11/2015 as we moved this to application.cfc it is likely not needed here anymore as its scope
		is now much wider
		
		<cfif url.mid neq "">
				
	
			<cfinvoke component   = "Service.Process.System.UserController"  
				method            = "RecordSessionTemplate"  
				SessionNo         = "#client.SessionNo#" 
				ActionTemplate    = "#CGI.SCRIPT_NAME#"
				Hash              = "#URL.mid#"
				ActionQueryString = "#CGI.QUERY_STRING#"
				AccessValidate    = "Yes">	
				
								  
			
		</cfif>	
		
		--->
	
</cfif>	

