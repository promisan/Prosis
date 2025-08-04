<!--
    Copyright © 2025 Promisan

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

<cfquery name="Position" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT O.*,
		       P.OrgUnitAdministrative,
			   P.PostType,
			   P.SourcePostNumber,
			   P.PostGrade,
			   P.Positionno,
			   P.FunctionNo,
			   P.FunctionDescription
	    FROM   Position P, 
		       Organization.dbo.Organization O
		WHERE  P.PositionNo         = '#url.id1#' 
		AND    P.OrgUnitOperational = O.OrgUnit 
</cfquery>

<cfquery name="Mission" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT *
	  FROM   Ref_Mission M
	  WHERE  M.Mission = '#Position.Mission#'	 		
</cfquery>

<cfinvoke component      = "Service.Process.Vactrack.Vactrack"  
   method                = "verifyAccess" 
   positionno            = "#Position.PositionNo#" 
   orgunitadministrative = "#Position.OrgUnitAdministrative#" 
   orgunit               = "#Position.OrgUnit#" 
   posttype              = "#Position.PostType#"
   documenttype          = "#url.documenttype#"   
   returnvariable        = "accessTrack">	  
 
	<cfset list = accesstrack.tracks>
				 		
	<table>		
		<cfset row = "0">
	    <cfoutput query="list">		
		<cfset row = row+1>
		<cfif row eq "1"><tr style="height:16px"></cfif>
		<td>
		<input type="radio" name="EntityClass" class="radiol" value="#EntityClass#" <cfif currentRow eq "1">checked</cfif>>
		</td><td class="labelmedium2" style="padding-left:5px;font-size:16px;height:15px;padding-right:12px">#EntityClassName#</td>
		<cfif row eq "4">
		</tr>
		<cfset row = "0">
		</cfif>
		</cfoutput>
	</table>
	