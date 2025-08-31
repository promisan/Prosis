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
<cfparam name="url.idmenu" default="">

<cf_screentop label="Maintain Financial Metric" 
              height="100%" 
			  layout="webapp"
			  banner="yellow"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	Ref_ProgramFinancial
	WHERE 	Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this financial metric ?")) {
		return true 
	}	
	return false	
}	

</script>

<!--- edit form --->

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<table width="96%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

    <tr><td height="6"></td></tr>
	
    <cfoutput>
    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD class="labelmedium">
  	   <input type="text" name="Code" value="#get.Code#" size="2" maxlength="2"class="regularxl">
	   <input type="hidden" name="CodeOld" value="#get.Code#">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD class="labelmedium">
  	   <cfinput type="text" name="Description" value="#get.Description#" message="please enter a description" required=  "yes" size="40" 
	   maxlenght = "40" class= "regularxl">
    </TD>
	</TR>
	
	
	<TR>
    <TD class="labelmedium">Order:</TD>
    <TD class="labelmedium">
  	   <cfinput type="text" 
	   			name="ListingOrder" 
				value="#get.ListingOrder#" 
				message="please enter a valid number" 
				validate="integer" 
				style="text-align: center;" 
				required="yes" 
				size="1" 
				maxlength="2" 
				class="regularxl">
    </TD>
	</TR>
		
	</cfoutput>
	
	<tr>
	<td class="labelmedium">Categories enabled:</td>
	</tr>
	<tr>
		<td colspan="2" style="padding-left:5px">
							
			<cfquery name="Category"
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT	C.*,
							(SELECT Code FROM Ref_ProgramFinancialCategory WHERE Code = '#get.code#' AND ProgramCategory = C.Code) as Selected
					FROM   	Ref_ProgramCategory C
					WHERE  	C.Code = AreaCode
					OR 		C.Parent is null
					OR		ltrim(rtrim(C.Parent)) = ''
					ORDER BY C.ListingOrder
			</cfquery>
			
			<cfset cnt = 0>
			<table width="100%" cellspacing="0" cellpadding="0">
			<cfoutput query="Category">
				
				<cfset cnt = cnt+1>
				<cfif cnt eq "1"><tr></cfif>
				<td width="33%">
				<table cellspacing="0" cellpadding="0"><tr><td>
				<input class="radiol" type="checkbox" name="ProgramCategory" value="#Code#" <cfif Selected neq "">checked</cfif>> 
				</td>
				<td style="padding-left:3px" class="labelmedium">#Description#</td>
				</tr>
				</table>
				<cfif cnt eq "3"></tr><cfset cnt=0></cfif>		
			</cfoutput>
			</table>
		
		</td>
	</tr>
	
	<tr><td height="3"></td></tr>
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td height="3"></td></tr>
	<tr><td colspan="2" align="center">
		
	<input class="button10g" type="button" style="width:80" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" style="width:80" name="Delete" value=" Delete " onclick="return ask()">
    <input class="button10g" type="submit" style="width:80" name="Update" value=" Update ">
	</td>	
	
	</CFFORM>
	
</TABLE>
	
<cf_screenbottom layout="innerbox">