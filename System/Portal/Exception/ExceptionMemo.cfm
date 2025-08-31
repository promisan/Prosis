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
<cfif url.mode eq "show">
	
	<cfoutput>
	
	<form name="form_#url.errorid#" id="form_#url.errorid#">
		
		<cfquery name="get" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			  SELECT   *
			  FROM     UserError 
			  WHERE    ErrorId = '#url.errorid#'
		</cfquery> 
		
		<cfquery name="getMemo" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			  SELECT    TOP 1 *
			  FROM      UserErrorAction 
			  WHERE     ErrorNo = '#get.errorNo#'
			  ORDER BY  Created DESC
		</cfquery> 
		
		<cfif get.ActionStatus eq "2">		
			<table width="100%"><tr><td height="30" align="center"><font face="Verdana" size="2" color="0080C0">Forwarded for review</td></tr></table>			
		<cfelseif get.ActionStatus eq "3">				
			<table width="100%"><tr><td height="30" align="center"><font face="Verdana" size="2" color="0080C0">Dismissed on #dateformat(getMemo.Created, CLIENT.DateFormatShow)# on #timeformat(getMemo.Created, "HH:MM")#</td></tr></table>			
		<cfelse>			
			<table width="100%">						
				<tr>
				    <td class="labelit" valign="top" style="padding-top:4px"width="10%">Remarks:</td>
					<td>					
						<textarea style="font-size:13px;border:1px solid d4d4d4;width:100%;height:40" class="regular"  name="memo" id="memo">#GetMemo.ActionMemo#</textarea>						
					</td>
				</tr>	 							
				
				<cfif url.actionstatus eq "2">
				 
				<tr>
				
				<td class="labelit" width="5%" >Send to:</td>		
				<td>		
									
					<cfquery name="actor" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
			    	 SELECT   DISTINCT U.Account,
							  U.FirstName, 
							  U.LastName
				  	 FROM     OrganizationAuthorization OA, System.dbo.UserNames U
					 WHERE    OA.UserAccount = U.Account
					 AND      OA.Role IN ('ErrorManager','Support')
					</cfquery>
					
					  <select name="FirstReviewerUserId" id="FirstReviewerUserId" class="regularxl" style="width:200;background: white;">
			  
					  <cfloop query="Actor">
					 	<option value="#Account#" style="background: white;" <cfif account eq actor.Account>selected</cfif>>#FirstName# #LastName# </option>		  
					  </cfloop>
				  
			          </select>
										
					</td>
				</tr>	
				
				</cfif>
				
				<tr><td height="5"></td></tr>
				<tr><td colspan="2" class="linedotted"></td></tr>
				
				<tr>
				
				<td colspan="2" align="center" style="padding-top:5px;padding-bottom:10px">		
					   		
						<input style = "height:25;width:140" 
							type     = "button" 
							onclick  = "ColdFusion.navigate('#client.root#/System/Portal/Exception/setExceptionStatus.cfm?actionstatus=#url.actionstatus#&errorid=#url.errorid#','tbox_#url.errorid#','','','POST','form_#errorid#')"				
							class    = "button10g" 
							value    = " <cfif url.actionstatus eq "3">Dismiss<cfelse>Send</cfif>">					
					</td>	
				
				</tr>			
			</table>		
		</cfif>
			
	</form>
	
	</cfoutput>
	
<cfelse>

	<cf_compression>	
	
</cfif>	