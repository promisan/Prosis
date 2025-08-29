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
<!--- this function generate a roster status entry screen and follows the following logic

1.  Determine the current status and owner
2.  Read the next status in the table Ref_StatusCode
3.  Determnie is the next status is a roster action
4.  If roster action, determine people with access to the next next and show all other access they have or in case of roster admin all
5.  if not roster action, determine only roster admin.
--->

<cfparam name="url.CurrentStatus"  default="0">
<cfparam name="url.Owner"          default="SysAdmin">
<cfparam name="url.FunctionId"     default="">
<cfparam name="url.ApplicantNo"    default="">

<cfparam name="Attributes.CurrentStatus"  default="#url.currentstatus#">
<cfparam name="Attributes.Owner"          default="#url.owner#">
<cfparam name="Attributes.FunctionId"     default="#url.functionid#">
<cfparam name="Attributes.ApplicantNo"    default="#url.ApplicantNo#">

<!--- get the status --->

<cfquery name="StatusList" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   * 
		FROM     Ref_StatusCode
		WHERE    Owner = '#Attributes.Owner#' 
		AND      Id    = 'FUN'
</cfquery>


<cfinvoke component   = "Service.Access.Roster"  
	  method          = "RosterStep" 
	  Owner           = "#Attributes.Owner#"
	  FunctionId      = "#Attributes.FunctionId#"
	  Status          = "#Attributes.CurrentStatus#"	     		
	  returnvariable  = "AccessList">	
	  
<cfset accessarray =  ListToArray(AccessList)>
	  
<table height="26" class="formspacing">

<cfset cnt = 1>
<cfset go  = 0>

<cfoutput query="StatusList">
		 
	<CFIF Status is Attributes.CurrentStatus>
						
			<!--- always show the current status --->
			
			<cfif cnt eq "1"><tr></cfif>
							   
				<td id="status_#currentrow#" 						
					style="min-width:195px;height:35px;background-color:ffffaf">
					
					<table class="formpadding">
					<tr><td style="padding-left:6px">
															
					 <cfif findNoCase(Status, AccessList)>
					 
						  <cfset go = "1">
						  
																		
					     <input type="radio" 
						        onclick="st('#Attributes.CurrentStatus#','#Status#','#Attributes.ApplicantNo#','#Attributes.FunctionId#')" 
								name="status" 
								class="radiol"
								id="status"
								value="#Status#" 
						        checked>
							
					  </cfif>		
						
					    </td>
						
						<td style="padding-left:6px;font-size:15px;font-weight:bold" class="labelmedium2"><!---#status#---> #Meaning#<br><font size="1">#StatusMemo#</td>
						
					</tr>
						
					</table>
						
				</td>		
						
			<cfif cnt eq "2"><cfset cnt=0><tr></cfif>  
			
	<cfelseif arrayFind( accessarray, Status)>
			
	      <cfset go = "1">
					 
		  <cfif cnt eq "1"><tr></cfif>
				<td id="status_#currentrow#" align="left"
					style="min-width:195px;height:35px;padding-left:6px;background-color:f1f1f1"  class="regular"> 
					
					<cfset ruleDescription = "">
						
					 <cfquery name="GetRule" 
			 		  datasource="AppsSelection" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
							  
						SELECT R.Code, R.Description
						FROM   Ref_StatusCodeProcess  P
							   INNER JOIN Ref_Rule R ON P.RuleCode = R.Code
						WHERE  P.Owner    = '#Attributes.Owner#'
						AND    P.Status   = '#Attributes.CurrentStatus#'
						AND    P.StatusTo = '#Status#'

					 </cfquery>
						 
					<cfif GetRule.RecordCount gt 0>
					 	<cfset rule = GetRule.Code>
						<cfset ruleDescription = GetRule.Description>
					 </cfif>
					
					<table width="100%" align="left"><tr><td valign="top" style="padding-top:3px" width="15px">
				        <input type="radio" class="radiol" onclick="st('#Attributes.CurrentStatus#','#Status#','#Attributes.ApplicantNo#','#Attributes.FunctionId#')" id="status" name="status" value="#Status#">
					 </td>
					<td style="padding-top:1px;padding-left:3px" align="left">
					    <table class="formpadding">
							<tr class="labelmedium2">						 
							 <td style="font-size:15px;padding-left:3px">#Meaning#<br><font size="1">#StatusMemo#</td>
							 <td style="padding-top:4px;padding-left:4px;padding-top:4px">
							<cfif ruleDescription neq "">
								<img src="#client.root#/images/link.gif" title="Process rule: #ruleDescription#" 
								  style="cursor:pointer; vertical-align:middle">
							</cfif>
							</td>
							</tr>
						</table>
					</td>
					</tr>
					</table>
					
				</td>						
					 
				<cfif cnt eq "2"><cfset cnt=0><tr></cfif>   
		  	  
	</cfif>	 
	
	<cfset cnt = cnt + 1>
	
</cfoutput>

</table>

<cfoutput>
	<script>
		 document.getElementById('statusold').value = '#Attributes.CurrentStatus#'
	</script>
</cfoutput>	

<CFSET Caller.go  = go>
<CFSET Caller.cnt = cnt>