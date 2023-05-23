
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="No" 
			  layout="webapp" 
			  banner="gray" 
			  label="Add" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->
<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<table width="92%" align="center" class="formpadding formspacing">

	<tr><td height="9"></td></tr>
	
    <TR>
    <TD style="width:200px" class="labelmedium2">Code:</TD>
    <TD class="labelmedium2">
	   <table>
	   <tr>
	       <td>
		   
	  	     <cfinput type = "Text" 
			     name      = "LocationCode" 
				 value     = "" 
				 message   = "Please enter a code" 
				 required  = "Yes" 
				 size      = "10" 
				 maxlength = "10" 
				 onchange  = "ptoken.navigate('RecordCheck.cfm?code='+this.value,'check')"
				 class     = "regularxxl">
				 
		   </td>
		   <td style="padding-left:3px" id="check"></td>
		</tr>
		</table>
    </TD>
	</TR>	
	
	<TR>
    <TD class="labelmedium2"><cf_tl id="Name">:</TD>
    <TD>
  	   <cfinput type="Text" name="LocationName" value="" message="Please enter a description" required="Yes" size="34" maxlength="50" class="regularxxl">
    </TD>
	</TR>
		
	<TR><TD class="labelmedium2"><cf_tl id="Country">:</TD>
	
	<cfquery name="Nation" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_Nation
	</cfquery>
	
		<td>
	
	  	<select name="country" style="width:190px" class="enterastab regularxxl" required="No">		
			<option value="">--select--</option>	
			    <cfoutput query="Nation"><option value="#Code#">#Name#</option></cfoutput>
	   	</select>		
	
    </TD>
	</TR>
	
	<cf_calendarscript>
	
	<tr>
	<td class="labelmedium2"><cf_tl id="Effective">:</td>
	<td style="z-index:25; position:relative; padding-top:3px;">			
		<cf_intelliCalendarDate9
		FieldName="DateEffective"
		Message="Select a valid Effective Date"
		Default=""
		class="regularxxl"
		AllowBlank="True">
	</td>
	</tr>
		
	<tr>
	<td class="labelmedium2"><cf_tl id="Expiration">:</td>
	<td style="z-index:20; position:relative; padding-top:3px;">
	
		<cf_intelliCalendarDate9
			FieldName="DateExpiration"
			Message="Select a valid Expiration Date"
			Default=""
			class="regularxxl"
			AllowBlank="True">
			
	</td>
	</tr>
	
	<TR>
    <TD class="labelmedium2"><cf_tl id="Listing order">:</TD>
    <TD>
  	   <cfinput type="Text" style="text-align:center" name="ListingOrder" value="1" message="Please enter a valid integer" validate="integer" required="Yes" visible="Yes" size="1" maxlength="3" class="regularxxl">
    </TD>
	</TR>
	
	<cfquery name="MissionList"
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	R.Mission, M.MissionOwner
		FROM 	Ref_ParameterMission R, Organization.dbo.Ref_Mission M
		WHERE   R.Mission = M.Mission
		<cfif getAdministrator("*") eq "0">
		AND     R.Mission IN (SELECT Mission 
		                      FROM   Organization.dbo.OrganizationAuthorization 
							  WHERE  AccessLevel > '0' AND UserAccount = '#session.acc#'
							  AND   Role IN ('HRPosition','OrgUnitManager'))
		</cfif>
		AND M.Operational = '1'
		<!--- WHERE	Mission in (SELECT Mission FROM Payroll.dbo.Ref_PayrollLocationMission) --->
		ORDER BY M.MissionOwner
	</cfquery>
	
	<TR>
    <TD class="labelmedium2">Used for entity:</TD>
    <TD>
	
		<cfselect name     = "Mission" 
		          group    = "missionowner" 
				  query    = "missionlist" 
				  value    = "mission" 
				  display  = "mission" 
				  style    = "width:180px"				  
		          visible  = "Yes" 
				  enabled  = "Yes" 
				  class    = "regularxxl"
				  queryposition = "below" 
				  onchange = "ptoken.navigate('ServiceLocation.cfm?mission='+this.value+'&serviceLocation=','divServiceLocation');">
				
		 </cfselect>	
	   
	   </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium2"><cf_tl id="Payroll Location">:</TD>
    <TD>
		<cf_securediv id="divServiceLocation" bind="url:ServiceLocation.cfm?mission=#missionList.mission#&serviceLocation=">
    </TD>
	</TR>
		
	<tr><td colspan="2">
		<cf_dialogBottom option="add">
	</td></tr>
			
</table>
</cfform>

<cf_screenbottom layout="innerbox">
