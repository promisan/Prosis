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

<cf_screentop height="100%" 
			  label="Address Zone" 			 
			  scroll="Yes" 
			  layout="webapp"
			  banner="yellow" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfquery name="Get" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	Ref_AddressZone
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

	<tr><td style="height:15px"></td>

	 <cfoutput>
	 <TR>
	 <TD class="labelmedium2">Code:</TD>  
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
	 
	 <!--- Field: Mission --->
    <TR>
    <TD class="labelmedium2">Mission:</TD>
    <TD>
  	  	<cfquery name="getLookup" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM Ref_ParameterMission
		</cfquery>
		<select name="mission" class="regularxxl">
			<cfloop query="getLookup">
			  <option value="#getLookup.mission#" <cfif getLookup.mission eq #get.mission#>selected</cfif>>#getLookup.mission#</option>
		  	</cfloop>
		</select>	
    </TD>
	</TR>
	

	 <!--- Field: Description --->
    <TR>
    <TD class="labelmedium2">Description:&nbsp;</TD>
    <TD>
  	  	<cfinput type="Text" name="description" value="#get.description#" message="Please enter a description" required="Yes" size="30" maxlength="50" class="regularxxl">
				
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
    	
