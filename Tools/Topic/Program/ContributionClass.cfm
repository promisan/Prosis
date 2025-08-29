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
<cfparam name="url.checked"     default="">

<cfif url.checked neq "">

	<cfif url.checked eq "true">
	
		<cfquery name="Update" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
	    	INSERT INTO Ref_TopicContributionClass 
				(Code,
				 ContributionClass,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName,
				 Created)
			VALUES(
				'#url.topic#',
				'#url.class#',
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#',
				getdate()
			)
			
		</cfquery>
		
	<cfelse>
	
		<cfquery name="Delete" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    	DELETE  Ref_TopicContributionClass 
			WHERE   Code              = '#url.topic#'
			AND     ContributionClass = '#url.class#'
		</cfquery>
		
	</cfif>
	
</cfif>

<cfquery name="Select" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	
	SELECT C.Code, C.Description, CC.Code as Selected
	FROM   Ref_ContributionClass C
	LEFT   JOIN Ref_TopicContributionClass CC
		   ON C.Code = CC.ContributionClass AND CC.Code = '#url.topic#'

</cfquery>

<cfset columns = 4>
<cfset cont    = 0>

<cfoutput>

<table width="100%">

	<tr>  <td colspan="#columns#" height="15" align="center"> </td> </tr>
		
	<cfloop query="Select">
	
		<cfif cont eq 0> <tr> </cfif>
		<cfset cont = cont + 1>
		
		 <td bgcolor="<cfif selected neq "">ffffbf</cfif>" width="15px">
		 	<input type="checkbox" value="#code#" <cfif Selected neq "">checked="yes"</cfif> onClick="javascript:ColdFusion.navigate('#SESSION.root#/Tools/Topic/Program/ContributionClass.cfm?Topic=#URL.Topic#&class=#code#&checked='+this.checked,'#url.topic#_contributionclass')">
		 </td>
		<td bgcolor="<cfif selected neq "">ffffbf</cfif>" style="padding-left:3px; font-size:8pt;">#Description#
		</td>
		<td width="15px"></td>
		 <cfif cont eq columns> </tr> <tr> <td colspan="3" height="3px"></td></tr> <cfset cont = 0> </cfif>
		 
	 </cfloop>
	 
	 <tr class="hide">
	 	<td colspan="#columns#" height="25" align="center">  <cfif url.checked neq "">  <font color="##0080C0"> Saved! <font/> </cfif>  </td>
	 </tr>
	 
</table>

</cfoutput>
