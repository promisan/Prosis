<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  label="Add Occupational Group" 
			  layout="webapp" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Parent" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    #client.LanPrefix#OccGroup
		WHERE   ParentGroup is null
	</cfquery>
	 
<cfform action="RecordSubmit.cfm" method="post" enablecab="yes" name="dialog">

<!--- Entry form --->

<table width="90%" cellspacing="0" cellpadding="0" align="center" class="formpadding">


	<tr><td></td></tr>
	
    <TR>
    <TD class="labelit">Code:</TD>
    <TD>
		<cfinput type="Text" name="OccupationalGroup" id="OccupationalGroup" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxl">
	</TD>
	</TR>
	
	  <TR>
    <TD class="labelit">Acronym:</TD>
    <TD>
		<cfinput type="Text" name="Acronym" id="Acronym" value="" message="Please enter a code" required="Yes" size="5" maxlength="5" class="regularxl">
	</TD>
	</TR>
	
	   <!--- Field: Description --->
    <TR>
    <TD class="labelit">Description:</TD>
    <TD>
	<cf_LanguageInput
			TableCode       = "OccGroup" 
			Mode            = "Edit"
			Name            = "Description"
			Type            = "Input"
			Required        = "Yes"
			Message         = "Please enter a description"
			MaxLength       = "50"
			Size            = "30"
			Class           = "regularxl">
	</TD>
	</TR>
	
	   <!--- Field: Description --->
    <TR>
    <TD class="labelit" >Full:</TD>
    <TD>
	
		<cf_LanguageInput
			TableCode       = "OccGroup" 
			Mode            = "Edit"
			Name            = "DescriptionFull"
			Type            = "Input"
			Required        = "Yes"
			Message         = "Please enter a description"
			MaxLength       = "80"
			Size            = "40"
			Class           = "regularxl">
	
	</TD>
	</TR>
	
	<tr>
	   <td class="labelit">Parent:</td>
	   <td>	
		<cfselect name="ParentGroup" id="ParentGroup" class="regularxl">
		<option value="">None</option>
		<cfoutput query="Parent">
		<option value="#OccupationalGroup#">#OccupationalGroup# #DescriptionFull#</option>
		</cfoutput>
		</cfselect>
	   </td>
	</tr>
	
    <TR>
    <TD class="labelit">Order:</TD>
    <TD>
		<cfinput type="Text" name="ListingOrder" id="ListingOrder" message="Please enter correct No" validate="integer" required="Yes" size="4" maxlength="4" class="regularxl">
	</TD>
	</TR>

	   <!--- Field: Description --->
    <TR>
    <TD class="labelit">Active:</TD>
    <TD class="labelmedium">
	     <input type="radio" class="radiol" name="Status" id="Status" value="1" checked>Yes
		 <input type="radio" class="radiol" name="Status" id="Status" value="0">No
	
	</TD>
	</TR>
   
   <tr><td colspan="2" height="1" class="linedotted"></td></tr>

   <tr>
	
	<td align="center" colspan="2">
	<input class="button10g" type="button" name="Cancel" value="Cancel" onClick="window.close()">
	<input class="button10g" type="submit" name="Insert" value="Submit">
	</td>
	
   </tr>
	
</table>

</cfform>
