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
<cfparam name="client.graph" default= "PostGradeBudget">
<cfparam name="url.item"     default= "#client.graph#">
<cfset client.graph = url.item>

<!--- customise to show additional details in the left box  --->
	
<cfsavecontent variable="fr">
	<cfoutput>
	FROM    #SESSION.acc#_AppStaffingDetail_#url.fileno#
	WHERE   1=1
	</cfoutput>	
</cfsavecontent>

<cfif url.item neq "PostGradeBudget" or url.scope eq "vac">

<cfquery name="Grade" 
   datasource="AppsQuery" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	SELECT DISTINCT PostGradeBudget, PostOrderBudget 
	#preserveSingleQuotes(fr)#	
	ORDER BY PostOrderBudget	
</cfquery>  

<cfelse>

<cfquery name="Nationality" 
   datasource="AppsQuery" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	SELECT DISTINCT Nationality
	#preserveSingleQuotes(fr)#	
	AND Nationality is not NULL
	ORDER BY Nationality	
</cfquery> 

</cfif>

<cfquery name="Gender" 
    datasource="AppsQuery" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT  Gender
	#preservesingleQuotes(fr)#	
	AND     PersonNo > ''
	GROUP BY Gender
</cfquery> 

<cfform name="filterform">

<table width="97%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
<cfif url.item neq "PostGradeBudget" or url.scope eq "vac">
<tr><td class="label">Grade</b></td></tr>
<tr><td>
      <input type="hidden" name="filter1" id="filter1" value="PostGradeBudget">
	  <select name="filtervalue1" size="11"  multiple style="width:100px;height:120px" class="regularxl">
			<cfoutput query="Grade">			
			<option value="'#PostGradeBudget#'" <cfif find(PostGradeBudget,client.programgraphfilter)>selected</cfif>>#PostGradeBudget#</option>
			</cfoutput>				
	  </select>
</td></tr>
<cfelse>
<tr><td class="labelit">Nationality</b></td></tr>
<tr><td colspan="1" class="linedotted"></td></tr>
<tr><td>
      <input type="hidden" name="filter1" id="filter1" value="Nationality">
	  <select name="filtervalue1" id="filtervalue1" size="11" multiple style="width:100px;height:120px" class="regularxl">
			<cfoutput query="Nationality">
			<option value="'#Nationality#'">#Nationality#</option>
			</cfoutput>				
	  </select>
</td></tr>

</cfif>

<cfif url.scope eq "vac">

  <input type="hidden" id="Gender" name="Gender" value="">

<cfelse>
	
	<tr><td class="labelit">Gender</b></td></tr>
	<tr><td colspan="1" class="linedotted"></td></tr>
	<tr><td>
	<table cellspacing="0" cellpadding="0">
		<tr>
			<cfparam name="client.programgraphfilter" default="">
			<td><input type="radio" id="Gender" name="Gender" value=""  <cfif not find("gender=",client.programgraphfilter)>checked</cfif>></td><td style="padding-left:3px" class="labelit">All</td>
			<td style="padding-left:5px"><input type="radio" id="Gender" name="Gender" value="M" <cfif find("gender='M'",client.programgraphfilter)>checked</cfif>></td><td style="padding-left:3px" class="labelit">M</td>
			<td style="padding-left:5px"><input type="radio" id="Gender" name="Gender" value="F" <cfif find("gender='F'",client.programgraphfilter)>checked</cfif>></td><td style="padding-left:3px" class="labelit">F</td>
		</tr>
	</table>
	</td></tr>
	
</cfif>

<cfoutput>
	<tr><td style="padding-top:5px" height="30"><input type="button" onclick="filterapply('#url.item#','no','#url.scope#')" name="Apply" style="width:100px;font-size:12px;height:35px" class="button10g" value="Apply"></td></tr>
</cfoutput>
	
<tr><td id="filterapply"></td></tr>	

</cfform>

</table>

	