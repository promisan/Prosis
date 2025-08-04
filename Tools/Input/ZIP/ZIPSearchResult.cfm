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

<!--- Query returning search results --->
<cfquery name="SearchResult" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM  PostalCode C
    WHERE PostalCode  LIKE '%#Form.PostalCode#%' 
	<cfif Form.Location neq "">
	AND   Location LIKE '%#Form.Location#%'
	</cfif>
	<!---
	<cfif FORM.PCountry neq "">
	AND   C.Country = '#Form.PCountry#'
	</cfif>
	--->
	ORDER BY PostalCode
</cfquery>
	    
<table width="98%" class="navigation_table">   
							
	<TR class="labelmedium2 line fixrow fixlengthlist">
	    <td height="17"></td>					    
	    <TD><cf_tl id="Code"></TD>
		<TD><cf_tl id="Location"></TD>
		<td align="right"><cf_tl id="Country"></td>
	</TR>
	
	<CFOUTPUT query="SearchResult">
			
		<cfset des = Replace(Location,'"','','ALL')>
														
		<TR class="labelmedium2 line navigation_row fixlengthlist" style="height:20px" onClick="<cfif searchresult.recordcount lte '10'>zipselected('#PostalCode#','#Location#','#Country#')</cfif>" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('ffffaf'))#">
			<td  height="20" align="center" style="padding-top:1px">		
				<cf_img icon="select" class="navigation_action" onClick="zipselected('#PostalCode#','#Location#','#Country#')">				   
			</td>
			<TD>#PostalCode#</TD>
			<TD>#Location#</TD>
			<TD align="right">#Country#</TD>			
		</TR>
					
	</CFOUTPUT>
	
</table>
	
<cfset ajaxonload("doHighlight")>
		
