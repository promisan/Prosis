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

<cfparam name="url.idmenu" default="">

<cf_screentop label="Maintain Event" 
              height="100%" 
			  layout="webapp" 
			  banner="yellow" 
			  scroll="yes" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_ProgramEvent
	WHERE Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this event ?")) {
		return true 
	}	
	return false	
}	

</script>

<!--- edit form --->

<cf_divscroll>

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<table width="96%" align="center" class="formpadding formspacing">

    <tr><td height="6"></td></tr>
	
    <cfoutput>
    <TR>
    <TD class="labelmedium2">Code:</TD>
    <TD>
  	   <input type="text" name="Code" value="#get.Code#" size="2" maxlength="2" class="regularxxl">
	   <input type="hidden" name="CodeOld" value="#get.Code#">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2">Description:</TD>
    <TD>
  	   <cfinput type="text" name="Description" value="#get.Description#" message="please enter a description" required=  "yes" size="40" 
	   maxlenght = "40" class= "regularxxl">
    </TD>
	</TR>
	
	
	<TR>
    <TD class="labelmedium2">Order:</TD>
    <TD>
  	   <cfinput type="text" 
	   			name="ListingOrder" 
				value="#get.ListingOrder#" 
				message="please enter a valid number" 
				validate="integer" 
				style="text-align: center;" 
				required="yes" 
				size="1" 
				maxlength="2" 
				class="regularxxl">
    </TD>
	</TR>
		
	</cfoutput>
	
	<tr>
		<td valign="top" style="padding-top:4px" class="labelmedium2">Enabled to:</td>
		<td>
							
			<cfquery name="Mission"
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT DISTINCT Mission
				FROM   Program
				WHERE  Mission IN (SELECT Mission FROM Ref_ParameterMission)
			</cfquery>
			
			<cfset cnt = 0>
			<table width="100%">
			<cfoutput query="Mission">
		
				<cfquery name="Check"
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT Mission
						FROM   Ref_ProgramEventMission
						WHERE ProgramEvent = '#get.code#'
						AND   Mission = '#mission#'
				</cfquery>
				
				<cfset cnt = cnt+1>
				<cfif cnt eq "1"><tr></cfif>
				<td width="23">
				<input type="checkbox" name="Mission" value="#Mission#" <cfif check.recordcount eq "1">checked</cfif>>
				</td>
				<td>#Mission#</td>
				<cfif cnt eq "3"></tr><cfset cnt=0></cfif>		
			</cfoutput>
			</table>
		
		</td>
	</tr>
	
	<tr>
	<td class="labelit" valign="top" style="padding-top:4px">Categories enabled:</td>
		<td>
							
			<cfquery name="Category"
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT	C.*,
							(SELECT Code FROM Ref_ProgramEventCategory WHERE ProgramEvent = '#get.code#' AND ProgramCategory = C.Code) as Selected
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
				<td width="23">
				<input type="checkbox" name="ProgramCategory" value="#Code#" <cfif Selected neq "">checked</cfif>>
				</td>
				<td class="labelit">#Description#</td>
				<cfif cnt eq "3"></tr><cfset cnt=0></cfif>		
			</cfoutput>
			</table>
		
		</td>
	</tr>
	
	<tr><td height="3"></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td height="3"></td></tr>
	<tr><td colspan="2" align="center">
		
	<input class="button10g" type="button" name="Cancel" value="Close" onClick="window.close()">
    <input class="button10g" type="submit" name="Delete" value="Delete" onclick="return ask()">
    <input class="button10g" type="submit" name="Update" value="Update">
	</td>	
	
	</CFFORM>
	
</TABLE>

</cf_divscroll>
	
<cf_screenbottom layout="innerbox">