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
<table width="100%" cellspacing="0" cellpadding="0" bgcolor="FFFFFF" style="padding:4px">

<cfquery name="Document" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    CE.ElementId, E.Source, E.Reference, E.ElementMemo
	FROM      ClaimElement CE INNER JOIN
	          Element E ON CE.ElementId = E.ElementId INNER JOIN
	          Ref_ElementClass R ON E.ElementClass = R.Code
					  
	WHERE     (R.AssociationSource = 1) 
	AND       CE.ClaimId IN (SELECT ClaimId FROM ClaimElement WHERE ElementId = '#elementid#')
	
	<!--- removed (CE.ClaimId = '#url.claimid#') AND --->
	
</cfquery>

<cfif Document.recordcount eq "0">
	<tr><td align="center" height="50" class="labelmedium"><cf_tl id="No source documents found"></td></tr>
</cfif>

<tr><td height="5"></td></tr>

<cfoutput query="Document">

	<tr>
	<td style="padding-left:7px" colspan="1" width="40">
	<input type="radio" name="RelationElementId" value="#ElementId#"></td>
	<td width="90%" class="labelit">#ElementMemo#</td>
	</tr>

	<tr>
	
	<td colspan="2" align="right">
	
			<cf_filelibraryN
				DocumentPath="CaseFileElement"
				SubDirectory="#elementid#" 			
				filter=""										
				showsize="0"	
				Insert="no"
				Remove="no"							
				box="b#elementid#"
				width="90%"			
				border="1">	
	
	</td></tr>
	
	<tr><td colspan="2" class="linedotted"></td></tr>
	
</cfoutput>	


</table>