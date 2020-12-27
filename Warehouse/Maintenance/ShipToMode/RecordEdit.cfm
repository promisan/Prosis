
<cfparam name="url.idmenu" default="">

<cfquery name="Get" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ShipToMode
	WHERE  Code = '#URL.ID1#'
</cfquery>

<cf_screentop height="100%" 
			  label="Task Mode of Shipment" 
			  option="Task Mode of Shipment [#get.Description#]" 
			  scroll="Yes" 
			  layout="webapp" 
			  banner="yellow"
			  menuAccess="Yes" 
			  jQuery="yes"
			  systemfunctionid="#url.idmenu#">

<cfquery name="CountRec" 
      datasource="AppsMaterials" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT 	ShipToMode
      FROM  	RequestTask
      WHERE 	ShipToMode  = '#URL.ID1#' 	  
</cfquery>

<cfquery name="GetCategories" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT 
				WC.Category,
				R.Description, 
				R.TabOrder
		FROM	WarehouseCategory WC 
				INNER JOIN Warehouse W 
					ON WC.Warehouse = W.Warehouse 
				INNER JOIN Ref_Category R 
					ON WC.Category = R.Category
		WHERE	R.Operational = 1
		ORDER BY R.TabOrder
</cfquery>

<cfoutput>
	
	<script language="JavaScript">
	
	function ask() {
		if (confirm("Do you want to remove this record ?")) {	
		return true 	
		}	
		return false	
	}
	
	function editMission(code,mission) {
		var width = 850;
		var height = 400;
		
		ColdFusion.Window.create('mydialog', 'Entity', '',{x:30,y:30,height:height,width:width,modal:true,center:true});    
		ColdFusion.Window.show('mydialog'); 				
		ColdFusion.navigate("MissionEdit.cfm?idmenu=#url.idmenu#&id1=" + code + "&id2=" + mission + "&ts=" + new Date().getTime(),'mydialog');
	}
	
	function validateFields() {	
		var controlToValidate;	 
		var vReturn = false;
		var vMessage = "";
		
		<cfloop query="GetCategories">		
			if (document.getElementById('ShipmentTemplate_#Category#')) {
				if (document.getElementById('ShipmentTemplate_#Category#').value != "")
				{
					if (document.getElementById('validatePath_#Category#').value == 0) 
					{ 
						vMessage = vMessage + '#Description# [' + document.getElementById('ShipmentTemplate_#Category#').value + '] not validated.\n';
					}
				}
			}
		</cfloop>
		
		if (vMessage != "") {
			alert(vMessage);
			return false;
		}
		else{
			return true;	
		}
	}
	
	</script>

</cfoutput>

<cfajaximport tags="cfform">

<!--- edit form --->

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" name="dialog">

<table width="95%" align="center" class="formpadding">

	<tr><td height="6"></td></tr>
    <cfoutput>
    <TR>
    <TD width="20%" class="labelmedium">Code:</TD>
    <TD class="labelmedium">
	   <cfif CountRec.recordcount eq "0">	
		   	<cfinput type="Text" name="Code" value="#get.Code#" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxl">
	   <cfelse>
	   		#get.Code#
			<input type="hidden" name="Code" id="Code" value="#get.Code#">
	   </cfif>
	   <input type="hidden" name="Codeold" id="Codeold" value="#get.Code#">
    </TD>
	</TR>
	
	 <TR>
    <TD class="labelmedium">Description:</TD>
    <TD>
	   <cfinput type="Text" name="Description" value="#get.Description#" message="Please enter a description" required="Yes" size="30" maxlength="50" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Sort Order:</TD>
    <TD>
  	   <cfinput type="Text" name="listingOrder" value="#get.listingOrder#" message="Please enter a numeric listing order" required="Yes" size="1" validate="integer" maxlength="3" class="regularxl" style="text-align:center;">
    </TD>
	</TR>
	
	<tr><td colspan="2" align="right" class="line" valign="middle"></td></tr>
	
	<tr>
		
	<td align="center" colspan="2" height="40">
		<table>
			<tr>
				<cfif CountRec.recordcount eq "0">
					<td style="padding-right:5px;">
						<cf_button class="button10s" type="submit" style="width:120" name="Delete" id="Delete" value="Delete" onclick="return ask()">
					</td>
				</cfif>
				<td>
					<cf_button class="button10s" type="submit" style="width:120" name="Update" id="Update" value="Update">
				</td>
			</tr>
		</table>
	</td>	
	
	</tr>	
	
	<tr>		
		<td colspan="2">
			<cfdiv id="divMissions" bind="url:MissionListing.cfm?id1=#url.id1#">
		</td>
	</tr>
			
	</cfoutput>
	
</TABLE>

</cfform>

<cf_screenbottom layout="webapp">
	