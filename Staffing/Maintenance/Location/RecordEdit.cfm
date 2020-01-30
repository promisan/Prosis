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
    <TD class="labelit">Code:&nbsp;</TD>
    <TD>
  	   <input style="background-color:f4f4f4" type="text" name="LocationCode" value="#get.LocationCode#" size="10" maxlength="10" class="regularxl" readonly>
	   <input type="hidden" name="LocationCodeOld" value="#get.LocationCode#" size="10" maxlength="10" readonly>
    </TD>
	</TR>
		
	<TR>
    <TD class="labelit">Listing order:</TD>
    <TD>
  	   <cfinput type="Text" name="ListingOrder" value="#Get.ListingOrder#" message="Please enter a valid integer" validate="integer" required="Yes" visible="Yes" enabled="Yes" size="1" maxlength="3" class="regularxl">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelit">Name:</TD>
    <TD>
  	   <cfinput type="Text" name="LocationName" value="#get.LocationName#" message="Please enter a description" required="Yes" size="30" maxlength="50" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Country:</TD>
    <TD>
	
	<cfquery name="Nation" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_Nation
	</cfquery>
	
	  	<select name="country" class="enterastab regularxl" required="No">		
		<option value="">--select--</option>	
			    <cfloop query="Nation">
					<option value="#Code#" <cfif Code eq get.Country>selected</cfif>>#Name#</option>
				</cfloop>
	   	</select>		
	
    </TD>
	</TR>
	
	<cf_calendarscript>
	
	<tr>
	<td class="labelit">Effective:</td>
	<td style="z-index:25; position:relative; padding-top:3px;">			
		<cf_intelliCalendarDate9
			FieldName="DateEffective"
			class="regularxl"
			Message="Select a valid Effective Date"
			Default="#dateformat(get.DateEffective, CLIENT.DateFormatShow)#"
			AllowBlank="True">
	</td>
	</tr>
	
	<tr>
	<td class="labelit">Expiration:</td>
	<td style="z-index:20; position:relative; padding-top:3px;">
		<cf_intelliCalendarDate9
			FieldName="DateExpiration"
			class="regularxl"
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
    <TD class="labelit">Entity:</TD>
    <TD>
	
	 <select name="Mission" class="regularxl" onchange="javascript: ColdFusion.navigate('ServiceLocation.cfm?mission='+this.value+'&serviceLocation=','divServiceLocation');">
	   <cfloop query="Mission">
	   <option value="#Mission.Mission#" <cfif #Mission.Mission# eq "#get.Mission#">selected</cfif>>#Mission.Mission#</option>
	   </cfloop>
	   </select>
	   
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Service Location:</TD>
    <TD>
		<cfdiv id="divServiceLocation" 
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
	