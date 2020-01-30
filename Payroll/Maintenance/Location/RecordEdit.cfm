
<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  title="Payroll Location" 
			  user="yes" 
			  jquery="yes"
			  label="Edit Payroll Location" 
			  banner="yellow">

<cfquery name="Nat" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	Ref_Nation
</cfquery>

<cfquery name="Get" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	Ref_PayrollLocation
	WHERE 	LocationCode = '#URL.ID1#'
</cfquery>

<cf_calendarScript>

<cfajaximport tags= "cfform, cfwindow, cfinput-datefield">

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this location ?")) {	
	return true 	
	}
	return false	
}

function editDesignation(code,designation,effective) {
	try { ColdFusion.Window.destroy('mydialog',true) } catch(e) {}
    ColdFusion.Window.create('mydialog', 'Payroll Location', '',{x:100,y:100,height:300,width:500,modal:false,resizable:false,center:true})       				
    ColdFusion.navigate("DesignationEdit.cfm?id1=" + code + "&designation=" + designation + "&effective=" + effective + "&ts=" + new Date().getTime(),'mydialog')
}

function deleteDesignation(code,designation,effective) {
	if (confirm("Do you want to remove this designation ?")) {	
		ColdFusion.navigate("DesignationDelete.cfm?id1=" + code + "&designation=" + designation + "&effective=" + effective + "&mode=inline","divDesignationsList");
	}
}

function askD(code,designation,effective) {
	if (confirm("Do you want to remove this designation ?")) {	
		ColdFusion.navigate('DesignationDelete.cfm?id1=' + code + '&designation=' + designation + '&effective=' + effective,'processDesignation');
	}	
}

</script>

<cfform action="RecordSubmit.cfm?mission=#url.mission#&id1=#url.id1#" method="POST" name="frmLocationEdit" target="processLocation">

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

    <tr><td></td></tr>
    <TR class="labelmedium">
    <TD>Code:</TD>
    <TD>
  	   <cfinput type="text" name="LocationCode" value="#Get.LocationCode#" message="Please enter a code" required="Yes" size="2" maxlength="2" class="regularxl">
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Country:</TD>
    <TD>
	<select name="LocationCountry" class="regularxl">
	<cfoutput query="Nat">
	   <option value="#Code#" <cfif get.locationcountry eq code>selected</cfif>>#Name#</option>
	</cfoutput>
	</select>
	</TD>
	</TR>
	
	<cfquery name="Mission" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	*, 
			CASE 
				WHEN (SELECT Mission FROM Ref_PayrollLocationMission WHERE LocationCode = '#URL.ID1#' AND Mission = M.Mission) is null THEN 'Not Selected'
				ELSE 'Selected'
			END as gSelected,
			(SELECT Mission FROM Ref_PayrollLocationMission WHERE LocationCode = '#URL.ID1#' AND Mission = M.Mission) as MissionSelected
	FROM 	Ref_ParameterMission M
	ORDER BY MissionSelected DESC, Mission DESC
	</cfquery>
	
	<TR class="labelmedium">
    <TD valign="top">Entity:</TD>
    <TD>
		<cfset missionsList = quotedValueList(Mission.MissionSelected)>
		<cfset missionsList = replace(missionsList,"'","","ALL")>
		<cfselect name="mission" size="13" multiple="Yes" query="Mission" value="Mission" display="Mission" group="gSelected" selected="#missionsList#" class="regularxl" style="height:75px;"> 
		</cfselect>
	</td>
	</tr>
	
	<TR class="labelmedium">
    <TD>Description:</TD>
    <TD>
  	   <cfinput type="text" name="Description" value="#Get.Description#" message="Please enter a description" required="Yes" size="30" maxlength="40" class="regularxl">
    </TD>
	</TR>
	
	<cfoutput>

			
	<TR class="labelmedium">
    <TD>Effective:</TD>
    <TD>
			
	  <cf_intelliCalendarDate9
		FieldName="DateEffective" 
		Default="#dateformat(get.DateEffective, CLIENT.DateFormatShow)#"
		class="regularxl"
		AllowBlank="False">	
			
	</td>
	</tr>
	
	<TR class="labelmedium">
    <TD>Expiration:</TD>
    <TD>
			
	  <cf_intelliCalendarDate9
		FieldName="DateExpiration" 
		Default="#dateformat(get.DateExpiration, CLIENT.DateFormatShow)#"
		class="regularxl"
		AllowBlank="True">	
			
	</td>
	</tr>
	
	<TR class="labelmedium">
    <TD colspan="2">
		<cfdiv id="divDesignationsList" bind="url: DesignationListing.cfm?id1=#URL.ID1#">
	</td>
	</tr>
	
	</cfoutput>
	
	<tr><td height="5"></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td colspan="2" align="center" height="35">
	
	<cfquery name="CountRec" 
      datasource="AppsPayroll" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT DISTINCT ServiceLocation
      FROM   SalaryScale
      WHERE  ServiceLocation  = '#get.LocationCode#' 
    </cfquery>

    <cfif CountRec.recordCount eq 0>
		<input class="button10g" style="width:140;height:29" type="submit" name="Delete" value="Delete" onclick="return ask()">
	</cfif>
	
	<input class="button10g" style="width:140;height:29" type="Submit" name="Update" value="Save">
	</td></tr>
	
</table>

</cfform>

<table><tr class="hide"><td><iframe name="processLocation" id="processLocation" frameborder="0"></iframe></td></tr></table>