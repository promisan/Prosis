
<cfparam name="url.mission" default="">

<cfquery name="Warehouse" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      Warehouse
		WHERE     Mission = '#url.mission#'
		AND       Operational = 1	
		ORDER BY  WarehouseName
</cfquery>	

<table width="90%">

<tr class="labelmedium line">
	<td><cf_tl id="Warehouse"></td>
	<td><cf_tl id="Enable"></td>
    <td align="right"><cf_tl id="Min"></td>
	<td align="right"><cf_tl id="Max"></td>
	<td align="right"><cf_tl id="Tax"></td>
	<td align="right"><cf_tl id="Mode"></td>	
</tr>

<cfquery name="TaxList"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   Ref_Tax		
</cfquery>	

<cfoutput query="warehouse">

<cfset row = trim(warehouse)>

<tr class="line labelmedium" style="height:20px">

  <td>#WarehouseName#</td>
  
  <td>
  
		<input type="checkbox" 
			name="Warehouse"
			class="radiol"
			value="'#warehouse#'" checked>  
  
  </td>
  <td align="right">
  
  		<input type="Text" 
			name="MinimumStock_#row#" 
			message="Please enter a numeric value"
			value="0"
			class="regularxl"				
			required="Yes"
			style="padding-right:3px;text-align:right;width:50;border-top:0px;border-bottom:0px"				
			visible="Yes" 
			enabled="Yes">  
  
  </td>
  
   <td align="right">
  
  		<input type="Text" 
			name="MaximumStock_#row#" 
			message="Please enter a numeric value"
			value="1"
			class="regularxl"				
			required="Yes"
			style="padding-right:3px;text-align:right;width:50;border-top:0px;border-bottom:0px"				
			visible="Yes" 
			enabled="Yes">  
  
  </td>
  
  <td align="right">
  
	  <select name="TaxCode_#row#"						          
          visible="Yes"
          enabled="Yes"
          required="Yes"
          type="Text"		
		  style="text-align:right;width:50;border-top:0px;border-bottom:0px"					  
          class="regularxl">						
		  <cfloop query="taxlist">
		  <option value="#TaxCode#">#Description#</option>		  
		  </cfloop>
  
  </td>
  
  <td align="right">
  
     <table>
	 <tr class="labelmedium">
		 <td><input type="radio" class="radiol" name="Restocking_#row#" id="Restocking_#row#" value="Procurement" checked></td>
		 <td style="padding-left:4px"><cf_tl id="Procurement"></td>
		 <td style="padding-left:14px"><input type="radio" class="radiol" name="Restocking_#row#" id="Restocking_#row#" value="Warehouse"></td>
		 <td style="padding-left:4px"><cf_tl id="Main Warehouse"></td>
	 </tr>
	 </table>
		
  </td>		
  
  <td></td>	
  
</tr>

</cfoutput>

</table>

<cfif url.itemclass eq "service">
    <script>
	 document.getElementById('warehouseenable').className = "hide"
	</script>
<cfelse>
	<script>
	 document.getElementById('warehouseenable').className = "regular"
	</script>
</cfif>