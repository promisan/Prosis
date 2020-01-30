
<cf_tl id="Project"   var = "vProject">
<cf_tl id="Add"       var = "vAdd">
<cf_tl id="Maintain"  var = "vMaintain">
<cf_tl id="Yes"       var = "vYes">
<cf_tl id="Cancel"    var = "vCancel">
<cf_tl id="Save"      var = "vSave">
<cf_tl id="Do you want to remove this record ?" var = "msg1">

<cfif url.programcode eq "">
	<cf_screentop height="100%" scroll="Yes" html="Yes" layout="webapp" label="#vProject#" banner="gray" option="#vAdd# #vProject#" user="no">
<cfelse>
	<cf_screentop height="100%" scroll="Yes" html="Yes" layout="webapp" label="#vProject#" banner="gray" option="#vMaintain# #vProject#" user="no">
</cfif>

<cfquery name="Warehouse" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM 	Warehouse
	WHERE 	Warehouse = '#url.warehouse#'
</cfquery>

<cfquery name="Get" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	WP.*,
			W.Mission,
			(SELECT ProgramName FROM Program.dbo.Program WHERE ProgramCode = WP.ProgramCode AND Mission = W.Mission) as ProgramName
	FROM 	WarehouseProgram  WP
			INNER JOIN Warehouse W
				ON W.Warehouse = WP.Warehouse
	WHERE 	WP.Warehouse = '#url.warehouse#'
	AND		WP.ProgramCode  = '#url.programcode#'
</cfquery>

<cfoutput>
<script language="JavaScript">
function ask() {
	if (confirm("#msg1#")) {	
	return true 	
	}	
	return false	
}
</script>
</cfoutput>

<table class="hide">
	<tr><td><iframe name="processWarehouseProgram" id="processWarehouseProgram" frameborder="0"></iframe></td></tr>
</table>

<cfform action="Program/ProgramSubmit.cfm" method="POST" name="warehouseprogram" target="processWarehouseProgram">

<table width="100%" cellspacing="0" class="formpadding">

<tr><td valign="top">

<!--- Entry form --->

	<table width="99%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
		
		<cfoutput>
	   
	    <!--- Field: Id --->
	    <TR>
	    <td width="80" class="labelmedium">#vProject#:</td>
	    <TD class="labelmedium">
		
			<cfif url.programCode eq "">
			
				<cfquery name="getLookup" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT	*,
								(ProgramCode + ' ' + ProgramName) as display
						FROM	Program 
						WHERE	Mission      = '#Warehouse.Mission#'
						AND		ProgramClass != 'Program'
				</cfquery>
				
				<cfselect name="ProgramCode" 
						query="getLookup" 
						display="display" 
						value="programCode" 
						selected="#get.programCode#" 
						required="Yes" 
						message="Please, select a valid project.">
						
				</cfselect>
				
			<cfelse>
			
				<b>[#get.ProgramCode#] #get.ProgramName#</b>
				<input type="hidden" name="ProgramCode" id="ProgramCode" value="<cfoutput>#Get.ProgramCode#</cfoutput>">
			
			</cfif>
					
			<input type="hidden" name="ProgramCodeOld" id="ProgramCodeOld" value="<cfoutput>#Get.ProgramCode#</cfoutput>">
			<input type="hidden" name="Warehouse" id="Warehouse" value="<cfoutput>#url.warehouse#</cfoutput>">
			
		</TD>
		</TR>
		
		   <!--- Field: Operational --->
	    <TR>
	    <TD class="labelmedium"><cf_tl id="Enabled">:</TD>
	    <TD class="labelmedium">		
			<input type="radio" name="Operational" id="Operational" <cfif Get.Operational eq "1" or url.programcode eq "">checked</cfif> value="1">#vYes#
			<input type="radio" name="Operational" id="Operational" <cfif Get.Operational eq "0">checked</cfif> value="0">No		
		</TD>
		</TR>	
		 
		</cfoutput>
		
	</table>	

</td>

</tr>
	
<tr><td colspan="2" align="center" height="2">
<tr><td colspan="2" class="line"></td></tr>
<tr><td colspan="2" align="center" height="2">
	
<tr>
	<td colspan="2" height="25" align="center">
		<cf_button2 type="submit" name="save" id="save" text="  #vSave#  ">
	</td>
</tr>
	
</TABLE>
	
</CFFORM>

