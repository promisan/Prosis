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

<cf_screentop height="100%" 
			  label="Contact Type" 			 
			  scroll="Yes" 
			  layout="webapp" 
			  banner="blue" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfquery name="Get" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	Ref_Contact
	WHERE 	Code = '#URL.ID1#'
</cfquery>

<cfquery name="VerifyDeleteUpdate" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	
    SELECT TOP 1 addressZone
	FROM	vwPersonAddress
	WHERE AddressZone = '#URL.ID1#'

	
 </cfquery>
 
<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this record ?")) {	
	return true 	
	}	
	return false	
}	

</script>

<!--- edit form --->
	
<CFFORM action="RecordSubmit.cfm" method="post" name="dialog">
	
<table width="94%" align="center" class="formpadding formspacing">
	
	 <cfoutput>
	 <TR>
	 <TD class="labelmedium2">Code:&nbsp;</TD>  
	 <TD>
	 	<cfif VerifyDeleteUpdate.recordCount eq 0>
		 	<cfinput type="Text" name="Code" value="#get.Code#" message="Please enter a code" required="Yes" size="20" maxlength="20" class="regularxxl">
		<cfelse>
			#get.Code#
			<input type="hidden" name="Code" value="#get.Code#">
		</cfif>
		<input type="hidden" name="CodeOld" value="#get.Code#">
	 </TD>
	 </TR>
	 
	 <!--- Field: Description --->
    <TR>
    <TD class="labelmedium2">Description:&nbsp;</TD>
    <TD>
  	  	<cfinput type="Text" name="description" value="#get.description#" message="Please enter a description" required="Yes" size="50" maxlength="50" class="regularxxl">
				
    </TD>
	</TR>
	
	 <!--- Field: CallSignMask --->
    <TR>
    <TD class="labelmedium2">Mask:&nbsp;</TD>
    <TD>
  	  	<cfinput type="Text" name="CallSignMask" value="#get.CallSignMask#" message="Please enter a Mask"  size="20" maxlength="20" class="regularxxl">
				
    </TD>
	</TR>	
	
	<TR>
		<TD></TD>
		<TD>
			<TABLE Width = "100%" >
			<tr>
				<td class="labelit">
				<i>Examples : A = [A-Za-z], A9 = [A-Za-z0-9], 9 = [0-9],  ? = Any character</i>
				</td>	
			</tr>
			</TABLE>
		</TD>
	</TR>
	
	 <!--- Field: Self-Service ? --->
    <TR>
    <TD class="labelmedium2">Self Service:&nbsp;</TD>
    <TD>
		<cfif get.SelfService eq "0">
			<cfset vChecked ="Yes">
		<cfelse>
			<cfset vChecked ="No">
		</cfif>	
  	  	<cfinput type="Radio" name="SelfService" value="0" checked = "#vChecked#">No

		<cfif get.SelfService eq "1">
			<cfset vChecked ="Yes">
		<cfelse>
			<cfset vChecked ="No">
		</cfif>	
				
  	  	<cfinput type="Radio" name="SelfService" value="1" checked = "#vChecked#">Yes
				
    </TD>
	</TR>	
	
	 <!--- Field: Listing Order --->
    <TR>
    <TD class="labelmedium2">Order:&nbsp;</TD>
    <TD>
  	  	<cfinput type="Text" name="ListingOrder" value="#get.ListingOrder#" message="Please enter a display order" required="Yes" size="2" maxlength="2" class="regularxxl">		
    </TD>
	</TR>		
	
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td colspan="2" align="center" height="30">
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">	
	<cfif VerifyDeleteUpdate.recordCount eq 0><input class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()"></cfif>
	<input class="button10g" type="submit" name="Update" value=" Update ">	
	</td></tr>
	
</cfoutput>
    	
</TABLE>

</CFFORM>
