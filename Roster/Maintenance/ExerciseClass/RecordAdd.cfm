
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Add Roster Class" 
			  menuAccess="Yes"
			  banner="gray"
			  jquery="Yes"
			  line="No"
			  systemfunctionid="#url.idmenu#">

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<table width="90%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td height="6"></td></tr>	

    <TR>
    <TD class="labelit">Code:</TD>
    <TD class="labelit">
  	   <cfinput type="Text" name="ExcerciseClass" id="ExcerciseClass" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxl enterastab">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelit">Description:</TD>
    <TD class="labelit">
  	   <cfinput type="Text" name="Description" id="Description" value="" message="Please enter a description" required="Yes" size="30" maxlength="30" class="regularxl enterastab">
    </TD>
	</TR>
			
	<TR>
    <TD class="labelmedium">Roster search:</TD>
    <TD class="labelmedium">
	    <INPUT type="radio" class="enterastab radiol" name="Roster" id="Roster" value="0" checked> Disabled
		<INPUT type="radio" class="enterastab radiol" name="Roster" id="Roster" value="1"> Enabled
	</TD>
	</TR>
	
	
	<TR>
    <TD class="labelmedium">Publish to:</TD>
    <TD class="labelmedium">
	
	<cfquery name="Entity" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_Mission
		WHERE  MissionStatus = '1' and Operational = 1
	</cfquery>

		<select name="TreePublish" id="TreePublish" class="regularxl">
			<option value="">n/a</option>
			<cfoutput query="Entity">
				<option value="#Mission#">#Mission#</option>
			</cfoutput>
		</select>
	
	</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Default source:</TD>
    <TD class="labelmedium">
	
	<cfquery name="Source" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_Source
		WHERE  Operational = 1
	</cfquery>

		<select name="DefaultSource" id="DefaultSource" class="regularxl">
			<cfoutput query="Source">
				<option value="#Source#">#Description#</option>
			</cfoutput>
		</select>
	
	</TD>
	</TR>
	
	
	<tr>
	<td class="labelmedium"> Unit Class: </td>
	<td class="labelmedium">	
		<cf_securediv bind="url:getOrgUnitClass.cfm?mission={TreePublish}" id="div_OrgUnitClass"/>	
	</td>
	</tr>
	
	<tr>
	<td class="labelmedium"> Workflow: </td>
	<td class="labelmedium">
	
		<cfquery name="Workflow" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_EntityClass
			WHERE  EntityCode = 'VacDocument'
		</cfquery>
	
		<select name="EntityClass" id="EntityClass" class="regularxl">
			<cfoutput query="Workflow">
				<option value="#EntityClass#">#EntityClassName#</option>
			</cfoutput>
		</select>
	
	</td>
	</tr>
	
	<tr><td colspan="2" class="linedotted"></td></tr>
	
	<tr><td colspan="2" align="center" height="30">
		
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" value=" Submit ">
	
	</td>	
	
	</tr>
	
</TABLE>

</cfform>
