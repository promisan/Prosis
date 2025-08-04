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

<cfquery name="Detail" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    R.*
	FROM      Ref_EntityDocument R INNER JOIN
	          Ref_EntityClassActionDocument A ON R.DocumentId = A.DocumentId 
			  	AND A.EntityCode      = '#URL.EntityCode#' 
				AND A.EntityClass     = '#URL.EntityClass#' 
				AND A.ActionCode      = '#GetAction.ActionCode#'
	WHERE     R.DocumentType in ('function','dialog','field')
	AND       R.EntityCode = '#url.entityCode#'
	ORDER BY  R.DocumentType, R.DocumentOrder 
</cfquery>

	
<cfif detail.recordcount eq "0">
<!---	<table width="97%" align="center" cellspacing="0" cellpadding="0">
		<tr><td height="10"></td></tr>	
		<tr><td height="20" align="center">
				- There are no custom fields configured for this action -
		</td></tr>
	</table>	 --->
<cfelse>

    <table width="97%" align="center" border="0" bordercolor="silver" cellspacing="0" cellpadding="0" rules="rows">
	    		
	    <TR>
		   <td width="15%"><b>Code</td>
		   <td width="50%"><b>Description</td>
		   <td width="6%"><b>Ord.</td>
		   <td width="10%" align="center"><b>Type</td>
		   <td width="7%"></td>
	    </TR>	
		
		<cfoutput>
		<cfset DT = "">
		<cfLoop query="Detail">
		
			<cfif DT neq DocumentType>
				<tr><td height="5"></td></tr>
				<cfif DocumentType eq "Field">
				<tr><td colspan="5"><font color="0080FF">Customised Fields</td></tr>
				<cfelseif DocumentType eq "dialog">
				<tr><td colspan="5"><font color="0080FF">Custom Dialogs</td></tr>
				<cfelse>		
				<tr><td colspan="5"><font color="0080FF">System Dialogs</td></tr>
				</cfif>
				<cfset DT = DocumentType>
				<tr class="linedotted"><td colspan="5"></td></tr>
			</cfif>	
			
			<cfset cd  = Detail.DocumentCode>
			<cfset ord = Detail.DocumentOrder>
															
				<TR>
				   <td>#cd#</td>
				   <td>
				       #Detail.DocumentDescription#
				   </td>
				   <td>
					 #ord#
				   </td>
				   <td align="center">
					  #Detail.FieldType#
				   </td>
				   <td align="right">
				   </td>
			    </TR>	
				
		</cfLoop>
		<tr><td height="5"></td></tr>		
		</cfoutput>	
							
	</table>	
</cfif>		

