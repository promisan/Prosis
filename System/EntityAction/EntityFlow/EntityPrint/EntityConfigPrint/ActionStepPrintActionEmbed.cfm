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
<cfquery name="Detail" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    R.* 
	FROM      Ref_EntityDocument R INNER JOIN
	          Ref_EntityActionDocument A ON R.DocumentId = A.DocumentId 
			  	AND A.ActionCode      = '#GetAction.ActionCode#'
	WHERE     R.DocumentType = 'report' 
	AND       R.EntityCode = '#url.entityCode#'
	ORDER BY  R.DocumentOrder
</cfquery>

<cfif Detail.recordcount eq 0>
<!---	<table width="97%" align="center" cellspacing="0" cellpadding="0">
		<tr><td height="10"></td></tr>
		<tr><td height="20" align="center">
				- There are no documents embedded in this action -
		</td></tr>
	</table>	 --->
<cfelse>
	
    <table width="97%" align="center" border="0" bordercolor="silver" cellspacing="0" cellpadding="0" rules="rows">
		
	    <TR>
		   <td width="15%" height="6">&nbsp;<b>Code</td>
		   <td width="50%"><b>Description</td>
		   <td width="10%" align="center"><b>Type</td>
		   <td width="7%"></td>
	    </TR>	
	
		<cfoutput>
		<cfloop query="Detail">
		
			<tr><td height="1" colspan="6" bgcolor="e4e4e4"></td></tr>
										
			<cfset cd  = Detail.DocumentCode>
															
				<TR>
				   <td height="20">&nbsp;#cd#</td>
				   <td>#Detail.DocumentDescription#</td>
				   <td align="center">#Detail.FieldType#</td>
				   <td align="center">
				   </td>				  			   
			    </TR>	
					
		</cfloop>
		</cfoutput>		
							
	</table>	
</cfif>	
	
