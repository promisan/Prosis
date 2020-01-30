<cf_tl id = "Warehouse" var = "vWarehouse">
<cf_tl id = "Add stock point settings" var = "vTitle">
 
<cf_screentop height="100%" 
             scroll="Yes" 
			 html="Yes" 
			 layout="webapp" 
			 label="#vWarehouse#" 
			 banner="gray" 
			 option="#vTitle#">

<cfoutput>

<cfif client.googleMAP eq "1">	 
	<cfajaximport tags="cfmap" params="#{googlemapkey='#client.googlemapid#'}#"> 
	<cfset maplink = "mapaddress()">
<cfelse>
	<cfset maplink = "">	
</cfif>

<script>

function supply() {

	mis = document.getElementById("mission").value
	url = "WarehouseSupply.cfm?ts="+new Date().getTime()+"&mission="+mis;
	ColdFusion.navigate(url,'supply')
}

function applyunit(orgunit) {
			ColdFusion.navigate('setUnit.cfm?orgunit='+orgunit,'processunit')
		}

</script>

</cfoutput>

<cf_dialogOrganization>

<cfquery name="Nation" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_Nation
</cfquery>

<cfquery name="MissionSelect" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_ParameterMission 
</cfquery>
 
<cfquery name="Supply" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *  FROM Warehouse 
</cfquery>
 
<script>
	function resetting() {
		document.getElementById("orgunitname1").value = ""
		document.getElementById("orgunit1").value = ""
	}
</script>

<!--- Entry form --->

<cfform action="RecordSubmit.cfm?idmenu=#idmenu#" method="POST" enablecab="Yes" name="warehouse" id="warehouse">
	
<table width="100%" cellspacing="0">

<tr class="hide"><td id="processunit"></td></tr>

<tr><td style="padding:20px"valign="top" align="center">

	<table width="100%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
						
	    <TR>
	    <TD class="labelmedium"><cf_tl id ="Mission">:</TD>
	    <TD>	
		<select name="mission" id="mission" class="regularxl" onchange="resetting();supply()">
		<cfoutput query="MissionSelect">
		<option value="#Mission#">#Mission#</option>
		</cfoutput>
		</select>
			
		</TD>
		</TR>	
		
			  
	    <TR>
	    <td width="80" class="labelmedium"><cf_tl id="Code">:</td>
	    <TD>
			<cfinput class="regularxl" 
					type="Text" 
					name="Warehouse" 
                    id="Warehouse"
					message="Please enter a valid code.\n\n** Must start with a letter and may contain numbers and letters." 
					required="Yes" 
					size="20" 
					maxlength="20" 
					validate="regex" 
					pattern="^[a-zA-Z][a-zA-Z0-9]*$">
		</TD>
		</TR>
		
	    <TR>
	    <TD class="labelmedium"><cf_tl id="Name">:</TD>
	    <TD>
			<cfinput class="regularxl" type="Text" name="WarehouseName" message="Please enter a Name" required="Yes" size="40" maxlength="100">
		</TD>
		</TR>
		
		<tr>
			<TD class="labelmedium"><cf_tl id="Unit">:</TD>
			<TD>
			<cfoutput>
					
		  <img src="#SESSION.root#/Images/contract.gif" alt="Select authorised unit" name="img0" 
						  onMouseOver="document.img0.src='#SESSION.root#/Images/button.jpg'" 
						  onMouseOut="document.img0.src='#SESSION.root#/Images/contract.gif'"
						  style="cursor: pointer;" alt="" width="16" height="18" border="0" align="absmiddle" 
						  onClick="selectorgmis('webdialog','orgunit1','orgunitcode1','mission1','orgunitname1','orgunitclass1',mission.value,'','')">
				
			<input type="text" name="orgunitname1" id="orgunitname1" class="regularxl" value="" size="40" maxlength="50" readonly>
			<cfinput type="hidden" name="mission1" size="20" maxlength="20" readonly>
		   	<input type="hidden" name="orgunit1" id="orgunit1" value="">			
			</cfoutput>
			</TD>
		</tr>	
		
		<cfquery name="GetClass" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   Ref_WarehouseClass 		
		</cfquery>		
		
		<cfif getClass.Recordcount eq "0">
		
			<cfoutput>
				<input class="hide" type="Text" name="WarehouseClass" value="" size="20" maxlength="20">
			</cfoutput>
			
		<cfelse>	
				
		    <TR>
		    <TD class="labelmedium"><cf_tl id="Facility Class">:</TD>
		    <TD>	
			    	 
				<cfselect name="WarehouseClass" class="regularxl"
				   query="getClass" 
				   value="Code" 
				   display="Description">	
				</cfselect>
					
			</TD>
			</TR>	
		
		</cfif>
		
	    <TR>
	    <TD class="labelmedium"><cf_tl id="Default Receipt storage">:
		<cf_space spaces="50">
		</TD>
	    <TD>
		    <cfoutput>
				<cfinput class="regularxl" type="Text" name="LocationReceipt"  message="Please enter a Receiving Location code" required="Yes" size="20" maxlength="20">
			</cfoutput>
		</TD>
		</TR>		
		
		<!--- Field: Stock Location --->
	    <TR>
	    <TD class="labelmedium"><cf_tl id="Price Location">:</TD>
	    <TD>
		
		   <cfdiv bind="url:setLocation.cfm?mission={mission}" id="loc">
						
		</TD>
		</TR>		
		
		<tr><td class="labelmedium"><b>Address</td></tr>
	
					
		<TR>
	    <TD style="padding-left:10px" class="labelmedium"><cf_tl id="Country">:</TD>
	    <TD>
		   	<select name="country" id="country" onchange="<cfoutput>#maplink#</cfoutput>" required="No" class="regularxl">
			    <cfoutput query="Nation">
					<option value="#Code#">#Name#</option>
				</cfoutput>
		   	</select>		
		</TD>
		</TR>	
		
		<TR>
	    <TD  style="padding-left:10px" class="labelmedium"><cf_tl id="Region">: <font color="FF0000">*</font></TD>
	    <TD>
		   <cfdiv bind="url:setRegion.cfm?mission={mission}" id="region">
		</TD>
		</TR>
							
		<TR>
	    <TD  style="padding-left:10px" class="labelmedium"><cf_tl id="Address">: <font color="FF0000">*</font></TD>
	    <TD>
		   	<cfinput class="regularxl" onchange="#maplink#" type="Text" name="address" message="Please enter an address" required="Yes" size="40" maxlength="100">
		</TD>
		</TR>	   		
	  
		<tr>
		<td  style="padding-left:10px" class="labelmedium"><cf_tl id="Latitude">:</td>
		<td>
		<cfinput class="regularxl" validate="float" type="Text" name="cLatitude" size="18" maxlength="20">	
		</td>
		</tr>
		<tr>
		<td  style="padding-left:10px" class="labelmedium"><cf_tl id="Longitude">:</td>		
		<td>
		<cfinput class="regularxl" validate="float" type="Text" name="cLongitude" size="18" maxlength="20">	
		</td>
		</TR>	
		
	    <TR>
	    <TD  style="padding-left:10px" class="labelmedium"><cf_tl id="Phone">:</TD>
	    <TD>
			<input class="regularxl" type="Text" name="Telephone" id="Telephone" size="25" maxlength="25">
		</TD>
		</TR>		
	  
	    <TR>
	    <TD  style="padding-left:10px" class="labelmedium"><cf_tl id="Fax">:</TD>
	    <TD>
			<input class="regularxl" type="Text" name="Fax" id="Fax" size="15" maxlength="15">
		</TD>
		</TR>		
		
		<tr><td height="10"></td></tr>
		
	    <TR>
	    <TD class="labelmedium"><cf_tl id="Supplied by">:</TD>
	    <TD id="supply">
		
		<cfoutput>
			<script>supply()</script>
		</cfoutput>
					
		</TD>
		</TR>	
									  
		<tr>
		<td class="labelmedium" height="20"><cf_UIToolTip tooltip="This storage location can be used in a request direction process"><cf_tl id="Request Receiver">:</cf_UIToolTip></td>
		<td>   
		   <input type="checkbox" name="Distribution" ID="Distribution" value="1">					
		</td>
		</tr>	
		
		<tr>
		<td class="labelmedium" height="20"><cf_UIToolTip tooltip="Taskorder Sourcing"><cf_tl id="Tasking Mode"></cf_UIToolTip>:</td>
		<td>   
		   <table cellspacing="0" cellpadding="0">
		   <tr><td>
		   <input type="radio" name="TaskingMode" value="0" checked>		
		   </td><td class="labelmedium" style="padding-left:3px;padding-right:4px">Internal</td>
		   </tr>
		   <tr>
		   <td>
		   <input type="radio" name="TaskingMode" value="1">	
		   </td><td class="labelmedium" style="padding-left:3px;padding-right:4px">External and Internal</td>	  
		   </tr></table>		
		</td>
		</tr>				
				
		<tr>
		<td height="20" class="labelmedium"><cf_UIToolTip tooltip="Mode under which items to be transferred are transferred are accepted in this warehouse"><cf_tl id="Receipt Mode"></cf_UIToolTip>:</td>
		<td>   
		   <table cellspacing="0" cellpadding="0">
		   <tr><td>
		   <input type="radio" name="ModeSetItem" id="ModeSetItem" value="Always" checked>		
		   </td><td class="labelmedium" style="padding-left:3px;padding-right:4px">Always</td>
		   </tr>
		   <tr>
		   <td>
		   <input type="radio" name="ModeSetItem" id="ModeSetItem" value="Category" >	
		   </td><td class="labelmedium" style="padding-left:3px;padding-right:4px">Under defined categories</td>
		   </tr>
		   <tr>
		   <td>
		   <input type="radio" name="ModeSetItem" id="ModeSetItem" value="Location">		
		   </td><td class="labelmedium" style="padding-left:3px;padding-right:4px">Only if exists in storage location</td>
		   </tr></table>		
		</td>
		</tr>	
		
		<TR>
	    <TD class="labelmedium"><cf_UIToolTip tooltip="Default Sale Currency"><cf_tl id="Sale Mode">:</cf_UIToolTip></TD>
	    <TD>
		
			<table cellspacing="0" cellpadding="0">
			<tr>
			
			<td>
			
			<select name="SaleMode" id="SaleMode"  class="regularxl">
								
				   <option value="0" checked>Disabled</option>
				   <option value="1">Standard Receivable</option>
				   <option value="2">Cash and Carry</option>
				   <option value="3">Cash and Carry with Receivable</option> 
				
			</select>
			
			</td>
			
			<td>
		
			<cfquery name="currencylist" 
				  datasource="AppsLedger" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					    SELECT *
						FROM   Currency
						WHERE  EnableProcurement = 1	   							   
				</cfquery>	
		
			<select name="SaleCurrency" id="SaleCurrency"  class="regularxl">
				
				<cfoutput query="currencylist">
				   <option value="#Currency#" <cfif application.BaseCurrency eq Currency>selected</cfif>>#Currency#</option>
				</cfoutput>
			</select>
			
			</td></tr>
			
			</table>
		
		</TD>
	</TR>
	
	<TR>
	    <TD class="labelmedium" style="padding-left:8px"><cf_tl id="POS background">:</TD>
	    <TD>
			<cfinput class="regularxl" style="padding-left:3px" type="Text" name="SaleBackground" id="SaleBackground" size="40" maxlength="80">
			
		</TD>
	</TR>
	
	    <TR>
	    <TD class="labelmedium"><cf_tl id="Entity default facility">:</TD>
	    <TD><input type="checkbox" name="WarehouseDefault" id="WarehouseDefault" value="1">
		</TD>
		</TR>		
	   
		
	</table>	

</td>

<cfif client.googleMAP eq "1">	

	<td valign="top" align="right" style="padding-top:20px;padding-right:20px">
		<cf_mapshow scope="embed" mode="edit" width="360" height="360">		
	</td>

</cfif>

</tr>

<tr><td colspan="2" class="line"></td></tr>

<tr><td height="6"></td></tr>

<tr><td colspan="2" align="center" id="submitbox">
	<cfoutput>
		<cf_tl id = "Cancel" var="vCancel">
		<cf_tl id = "Submit" var="vSubmit">		
		<input class="button10g" type="button" name="Cancel" id="Cancel" value=" #vCancel# " onClick="window.close()">
		<input class="button10g" type="submit" name="Insert" id="Insert" value=" #vSubmit# ">
	</cfoutput>	 
			
</td></tr>
			
</table>

</CFFORM>
		
