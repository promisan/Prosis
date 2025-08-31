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

<cf_screentop label="Add Event" 
   height="100%" 
   layout="webapp" 
   scroll="yes" 
   menuAccess="Yes" 
   systemfunctionid="#url.idmenu#">

<!--- Entry form --->

<cf_divscroll>
	
<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td height="7"></td></tr>
    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD class="labelmedium">
  	   <cfinput type="text" name="Code" value="" message="Please enter a code" required="Yes" size="2" maxlength="2" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD class="labelmedium">
  	   <cfinput type="text" name="Description" value="" message="Please enter a description" required="Yes" size="40" maxlength="40" class="regularxl">
    </TD>
	</TR>
			
	<TR>
    <TD class="labelmedium">Order:</TD>
    <TD class="labelmedium">
  	   <cfinput type="Text" name="ListingOrder" value="0" message="Please enter a valid number" validate="integer" required="Yes" size="1" maxlength="2" style="text-align:center;" class="regularxl">
    </TD>
	</TR>
	
	<tr>
	<td class="labelmedium">Enabled to:</td>
	<td>
			
			
		<cfquery name="Mission"
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT DISTINCT Mission
			FROM Program
		</cfquery>
		
		<cfset cnt = 0>
		<table width="100%" cellspacing="0" cellpadding="0">
		<cfoutput query="Mission">
			<cfset cnt = cnt+1>
			<cfif cnt eq "1"><tr></cfif>
			<td width="23"><input type="checkbox" name="Mission" value="#Mission#"></td>
			<td class="labelit">#Mission#</td>
			<cfif cnt eq "3"></tr><cfset cnt=0></cfif>		
		</cfoutput>
		</table>
	
	</td>
	
	</tr>
	
	<tr>
	<td class="labelmedium" valign="top">Categories enabled:</td>
		<td>
							
			<cfquery name="Category"
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT	C.*
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
				<input type="checkbox" name="ProgramCategory" value="#Code#">
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
	
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" value=" Submit ">
	
	</td>	
	
	</tr>
		
</TABLE>
	
</CFFORM>

</cf_divscroll>

<cf_screenbottom layout="innerbox">