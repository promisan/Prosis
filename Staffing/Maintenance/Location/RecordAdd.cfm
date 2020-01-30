
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="No" 
			  layout="webapp" 
			  banner="gray" 
			  label="Add" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->
<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<table width="92%" align="center" cellspacing="0" cellpadding="0" class="formpadding formspacing">

	<tr><td height="9"></td></tr>
	
    <TR>
    <TD class="labelit">Code:</TD>
    <TD class="labelit">
	   <table cellspacing="0" cellpadding="0">
	   <tr>
	       <td>
	  	     <cfinput type="Text" 
			     name="LocationCode" 
				 value="" 
				 message="Please enter a code" 
				 required="Yes" 
				 size="10" 
				 maxlength="10" 
				 onchange="ColdFusion.navigate('RecordCheck.cfm?code='+this.value,'check')"
				 class="regularxl">
		   </td>
		   <td style="padding-left:3px" id="check"></td>
		</tr>
		</table>
    </TD>
	</TR>	
	
	<TR>
    <TD class="labelit">Name:</TD>
    <TD>
  	   <cfinput type="Text" name="LocationName" value="" message="Please enter a description" required="Yes" size="34" maxlength="50" class="regularxl">
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
			    <cfoutput query="Nation">
					<option value="#Code#">#Name#</option>
				</cfoutput>
	   	</select>		
	
    </TD>
	</TR>
	
	<cf_calendarscript>
	
	<tr>
	<td class="labelit">Effective:</td>
	<td style="z-index:25; position:relative; padding-top:3px;">			
		<cf_intelliCalendarDate9
		FieldName="DateEffective"
		Message="Select a valid Effective Date"
		Default=""
		class="regularxl"
		AllowBlank="True">
	</td>
	</tr>
		
	<tr>
	<td class="labelit">Expiration:</td>
	<td style="z-index:20; position:relative; padding-top:3px;">
	
		<cf_intelliCalendarDate9
			FieldName="DateExpiration"
			Message="Select a valid Expiration Date"
			Default=""
			class="regularxl"
			AllowBlank="True">
			
	</td>
	</tr>
	
	<TR>
    <TD class="labelit">Listing order:</TD>
    <TD>
  	   <cfinput type="Text" style="text-align:center" name="ListingOrder" value="1" message="Please enter a valid integer" validate="integer" required="Yes" visible="Yes" enabled="Yes" size="1" maxlength="3" class="regularxl">
    </TD>
	</TR>
	
	<cfquery name="MissionList"
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	R.Mission, M.MissionOwner
		FROM 	Ref_ParameterMission R, Organization.dbo.Ref_Mission M
		WHERE   R.Mission = M.Mission
		<cfif getAdministrator("*") eq "1">
		AND     R.Mission IN (SELECT Mission 
		                      FROM   Organization.dbo.OrganizationAuthorization 
							  WHERE  AccessLevel > '0' AND UserAccount = '#session.acc#'
							  AND   Role IN ('HRPosition','OrgUnitManager'))
		</cfif>
		<!--- WHERE	Mission in (SELECT Mission FROM Payroll.dbo.Ref_PayrollLocationMission) --->
		ORDER BY M.MissionOwner
	</cfquery>
	
	<TR>
    <TD class="labelit">Entity:</TD>
    <TD>
	
		<cfselect name     = "Mission" 
		          group    = "missionowner" 
				  query    = "missionlist" 
				  value    = "mission" 
				  display  = "mission" 
				  style    = "width:120px"				  
		          visible  = "Yes" 
				  enabled  = "Yes" 
				  class="regularxl"
				  queryposition="below" 
				  onchange = "ColdFusion.navigate('ServiceLocation.cfm?mission='+this.value+'&serviceLocation=','divServiceLocation');">
				
		 </cfselect>	
	   
	   </TD>
	</TR>
		
	<TR>
    <TD class="labelit">Payroll Location:</TD>
    <TD>
		<cfdiv id="divServiceLocation" bind="url:ServiceLocation.cfm?mission=#missionList.mission#&serviceLocation=">
    </TD>
	</TR>
		
	<tr><td colspan="2">
		<cf_dialogBottom option="add">
	</td></tr>
			
</table>
</cfform>

<cf_screenbottom layout="innerbox">
