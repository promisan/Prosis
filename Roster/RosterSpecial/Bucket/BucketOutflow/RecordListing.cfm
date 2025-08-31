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
<cfinvoke component="Service.Presentation.Presentation" 
       		   method="highlight" 
			   class="highlight1"
			   returnvariable="stylescroll"/>

		
<table width="100%" align="center" class="formpadding">
		
 <tr>
	   <td colspan="3" class="labelmedium" style="font-size:20px">Set the roster outflow rules for this bucket</font></td>
 </tr>
	
 <tr><td height="6"></td></tr> 		
		
	<tr class="hide"><td id="process"></td></tr> 
	<tr>
	
		<td width="40" class="label">Ope.</td>
		<td width="80%" class="label">Rule</td>
		<td class="label">Allow<br>reapply</td>
		<td class="label">Send Mail</td>
		
	</tr>
	<tr><td colspan="4" height="1" class="linedotted"></td></tr>
	 	 
	<cfquery name="Rules" 
	 datasource="AppsSelection" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT *
		 FROM   Ref_Rule
		 WHERE  TriggerGroup = 'Bucket'	
	</cfquery>	
	
	<cfset link = "ColdFusion.navigate('../Bucket/BucketOutflow/RecordListingSubmit.cfm','process','','','POST','outflow')">
	
	<form action="outflow" name="outflow" id="outflow">
	
	<cfoutput>
	<input type="hidden" id="idfunction" name="idfunction" value="#url.idfunction#">
	</cfoutput>
	
	<cfoutput query="rules">
	
	<cfquery name="Check" 
	    datasource="AppsSelection" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	     SELECT *
		 FROM   FunctionOrganizationOutflow
		 WHERE  RuleCode = '#Code#'	
		 AND   FunctionId = '#url.idFunction#'			
	</cfquery>
	
	 <tr class="line">
	 	 <td height="28"><input type="checkbox" class="radiol" name="#Code#_operational" value="1" onclick="#link#" <cfif check.operational eq "1">checked</cfif>></td>
		 <td class="labelit">#Description#  <input type="Text" name="#Code#_days" class="regularxl" onchange="#link#" size="2" style="text-align:center" value="#check.days#" maxlength="3"> days</td>
		 <td><input type="checkbox" class="radiol" name="#Code#_AllowReactivation" value="1" onclick="#link#" <cfif check.AllowReactivation eq "1">checked</cfif>></td>
		 <td><input type="checkbox" class="radiol" name="#Code#_MailNotification" value="1" onclick="#link#" <cfif check.MailNotification eq "1">checked</cfif>></td>
	 </tr>
	 
	</cfoutput>
	
	</form>		

</table>	
				

