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
			  scroll="Yes" 
			  layout="webapp" 
			  label="Edit Location" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Location
	WHERE  LocationCode = '#URL.ID1#'
</cfquery>

<script language="JavaScript">
	
	function ask() {
		if (confirm("Do you want to remove this location ?")) {	
			return true 
		}	
		return false	
	}	

</script>

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<!--- edit form --->

<table width="92%" cellpadding="0" align="center" class="formpadding formspacing">

    <tr><td height="8"></td></tr>
    <cfoutput>
    <TR>
    <TD class="labelmedium2">Code:</TD>
    <TD>
  	   <input style="background-color:f4f4f4" type="text" name="LocationCode" value="#get.LocationCode#" size="10" maxlength="10" class="regularxxl" readonly>
	   <input type="hidden" name="LocationCodeOld" value="#get.LocationCode#" size="10" maxlength="10" readonly>
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium2">Listing order:</TD>
    <TD>
  	   <cfinput type="Text" name="ListingOrder" value="#Get.ListingOrder#" message="Please enter a valid integer" validate="integer" required="Yes" visible="Yes" size="1" maxlength="3" class="regularxxl">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium2">Name:</TD>
    <TD>
  	   <cfinput type="Text" name="LocationName" value="#get.LocationName#" message="Please enter a description" required="Yes" size="30" maxlength="50" class="regularxxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2">Country:</TD>
    <TD>
	
	<cfquery name="Nation" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_Nation
	</cfquery>
	
	  	<select name="country" style="width:200px" class="enterastab regularxxl" required="No">		
		<option value="">--select--</option>	
			    <cfloop query="Nation">
					<option value="#Code#" <cfif Code eq get.Country>selected</cfif>>#Name#</option>
				</cfloop>
	   	</select>		
	
    </TD>
	</TR>
	
	<cf_calendarscript>
	
	<tr>
	<td class="labelmedium2">Effective:</td>
	<td style="z-index:25; position:relative; padding-top:3px;">			
		<cf_intelliCalendarDate9
			FieldName="DateEffective"
			class="regularxxl"
			Message="Select a valid Effective Date"
			Default="#dateformat(get.DateEffective, CLIENT.DateFormatShow)#"
			AllowBlank="True">
	</td>
	</tr>
	
	<tr>
	<td class="labelmedium2">Expiration:</td>
	<td style="z-index:20; position:relative; padding-top:3px;">
		<cf_intelliCalendarDate9
			FieldName="DateExpiration"
			class="regularxxl"
			Message="Select a valid Expiration Date"
			Default="#dateformat(get.DateExpiration, CLIENT.DateFormatShow)#"
			AllowBlank="True">
	</td>
	</tr>
		
	<cfquery name="Mission"
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	*
		FROM 	Ref_ParameterMission
		WHERE	Mission in (SELECT Mission FROM Payroll.dbo.Ref_PayrollLocationMission)
		<cfif getAdministrator("*") eq "0">
		AND     Mission IN (SELECT Mission 
		                    FROM   Organization.dbo.OrganizationAuthorization 
						    WHERE  AccessLevel > '0' AND UserAccount = '#session.acc#'
						    AND   Role IN ('HRPosition','OrgUnitManager'))
		</cfif>		
		
	</cfquery>
			
	<TR>
    <TD class="labelmedium2">Entity:</TD>
    <TD>
	
	 <select name="Mission" class="regularxxl" onchange="javascript: ColdFusion.navigate('ServiceLocation.cfm?mission='+this.value+'&serviceLocation=','divServiceLocation');">
	   <cfloop query="Mission">
	   <option value="#Mission.Mission#" <cfif #Mission.Mission# eq "#get.Mission#">selected</cfif>>#Mission.Mission#</option>
	   </cfloop>
	   </select>
	   
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2">Service Location:</TD>
    <TD>
		<cf_securediv id="divServiceLocation" 
		    style="height:100%; min-height:100%;" 
			bind="url:ServiceLocation.cfm?mission=#get.mission#&serviceLocation=#get.ServiceLocation#">
    </TD>
	</TR>
	
	<tr><td colspan="2">
		
		<cf_dialogBottom option="edit">

	</td></tr>
	
	</cfoutput>	
		
</TABLE>

</CFFORM>

<cf_screenbottom layout="innerbox">
	