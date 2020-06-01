
<cfparam name="url.idmenu" default="">
  
<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Edit Roster Class" 
			  menuAccess="Yes" 
			  banner="gray"
			  line="No"
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ExerciseClass
	WHERE  ExcerciseClass = '#URL.ID1#'
</cfquery>

<script language="JavaScript">
	
	function ask() {
		if (confirm("Do you want to remove this Excercise Class?")) {	
		return true 	
		}	
		return false	
	}	

</script>

<!--- edit form --->
<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

	<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">
	
		<tr><td height="7"></td></tr>
	    <cfoutput>
	    <TR>
	    <TD class="labelmedium">Code:</TD>
	    <TD class="labelmedium">
	  	   <input type="text"   name="ExcerciseClass" id="ExcerciseClass"   value="#get.ExcerciseClass#" size="15" maxlength="15"  class="regularxl">
		   <input type="hidden" name="ExcerciseClassOld" id="ExcerciseClassOld" value="#get.ExcerciseClass#" size="15" maxlength="15" readonly>
	    </TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium">Description:</TD>
	    <TD class="labelmedium">
	  	   <cfinput type="Text" name="Description" id="Description" value="#get.description#" message="Please enter a description" required="Yes" size="30" maxlength="30"class="regularxl">
	    </TD>
		</TR>	
		
		<TR>
	    <TD class="labelmedium">Operational:</TD>
	    <TD class="labelmedium">
		    <INPUT type="radio" name="Operational" id="Operational" value="0" <cfif "0" eq "#get.Operational#">checked</cfif>> No
			<INPUT type="radio" name="Operational" id="Operational" value="1" <cfif "1" eq "#get.Operational#">checked</cfif>> Yes
		</TD>
		</TR>
				
		<TR>
	    <TD class="labelmedium">Roster search:</TD>
	    <TD class="labelmedium">
		    <INPUT type="radio" name="Roster" id="Roster" value="0" <cfif "0" eq "#get.Roster#">checked</cfif>> Disabled
			<INPUT type="radio" name="Roster" id="Roster" value="1" <cfif "1" eq "#get.Roster#">checked</cfif>> Enabled
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
			
			<cfselect name="TreePublish" id="TreePublish" class="regularxl">
				<option value="">n/a</option>
				<cfloop query="Entity">
					<option value="#Mission#" <cfif get.TreePublish eq Mission>selected</cfif>>#Mission#</option>
				</cfloop>
			</cfselect>
		
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
				<cfloop query="Source">
					<option value="#Source#" <cfif get.Source eq Source>selected</cfif>>#Description#</option>
				</cfloop>
			</select>
		
		</TD>
		</TR>
	
		<tr>
			<td class="labelmedium"> Unit Class: </td>
			<td class="labelmedium">
			
				<cf_securediv bind="url:getOrgUnitClass.cfm?mission={TreePublish}&selected=#Get.OrgUnitClass#" id="div_OrgUnitClass"/>
			
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
				<cfloop query="Workflow">
					<option value="#EntityClass#" <cfif EntityClass eq get.EntityClass> selected </cfif>>#EntityClassName#</option>
				</cfloop>
			</select>
		
		</td>
		</tr>
		
		</cfoutput>
		
		<tr><td colspan="2" class="linedotted"></td></tr>
		<tr><td colspan="2" align="center" height="30">
		
		<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
	    <input class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()">
	    <input class="button10g" type="submit" name="Update" value=" Update ">
		</td>	
		
		</tr>
		
	</TABLE>

</CFFORM>


