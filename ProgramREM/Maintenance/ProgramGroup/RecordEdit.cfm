<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
 			  scroll="Yes" 
			  layout="webapp" 
			  label="Edit Group"
			  banner="gray"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ProgramGroup
	WHERE  Code = '#URL.ID1#'
</cfquery>

<cfquery name="QPeriod" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Period
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this grouping?")) {	
	return true 	
	}	
	return false
	
}	

</script>

<table width="100%" cellspacing="0" cellpadding="0" align="center">
<tr><td>

<cfform action="RecordSubmit.cfm" method="POST">

<!--- edit form --->

<table width="96%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td height="5"></td></tr>
	
    <cfoutput>
    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD>
  	   <input type="text" name="Code" value="#get.Code#" size="20" maxlength="20"class="regularxl">
	   <input type="hidden" name="Codeold" value="#get.Code#" size="20" maxlength="20"class="regular">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD>
  	   <cfinput type="text" name="Description" value="#get.Description#" message="please enter a description" requerided=  "yes" size="30" 
	   maxlenght = "40" class= "regularxl">
    </TD>
	</TR>
			
	<cfquery name="MissionList" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ParameterMission
	</cfquery>
	
	<TR>
    <TD class="labelmedium">Entity:</TD>
    <TD>
	<cfoutput>
		<select name="Mission" class="regularxl">
        	<option value="0" selected>All entities</option>
     	   <cfloop query="MissionList">
        	<option value="#Mission#" <cfif Get.Mission eq mission>selected</cfif>>#Mission#</option>
         	</cfloop>
	    </select>
	</cfoutput>		
    </TD>
	</TR>		

	<TR>
    <TD class="labelmedium">Period:</TD>
    <TD>
		<select name="Period"  class="regularxl">
        	<option value="0" >All periods</option>
     	   <cfloop query="QPeriod">
        	<option value="#QPeriod.Period#" <cfif #Get.Period# eq "#QPeriod.Period#">selected</cfif>>#QPeriod.Description#
			</option>
         	</cfloop>
	    </select>
    </TD>
	</TR>	
	
	<TR>
    <TD class="labelmedium">Order:</TD>
    <TD>
  	   <cfinput type="text" name="ListingOrder" value="#get.listingOrder#" size="2" maxlength="20" class="regularxl" validate="integer">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Color:</TD>
    <TD>
  	   <input type="text" name="ViewColor" value="#get.ViewColor#" size="20"  maxlenght = "20" class= "regularxl">
    </TD>
	</TR>
	
	</cfoutput>
		
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr>	
		<td colspan="2" align="center">
		<input class="button10g" type="button" style="width:80" name="Cancel" value="Cancel" onClick="window.close()">
	    <input class="button10g" type="submit" style="width:80" name="Delete" value="Delete" onclick="return ask()">
    	<input class="button10g" type="submit" style="width:80" name="Update" value="Update">
		</td>	
	</tr>
	
</TABLE>
	
</CFFORM>

</td></tr></table>
