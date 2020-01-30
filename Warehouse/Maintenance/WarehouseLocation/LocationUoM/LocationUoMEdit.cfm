
<cfquery name="get" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">		 		 	  
		 SELECT  	U.*,
		 			IU.UoMDescription
		 FROM      	ItemWarehouseLocationUoM U
		 			INNER JOIN ItemUoM IU
						ON U.ItemNo = IU.ItemNo
						AND U.UoM = IU.UoM
		 WHERE		U.Warehouse  = '#url.warehouse#'
		 AND       	U.Location   = '#url.location#'		
		 AND		U.ItemNo     = '#url.itemNo#'
		 AND		U.UoM        = '#url.UoM#'
		 <cfif url.movement neq "">
		 AND		U.MovementUoM = '#url.movement#'
		 <cfelse>
		 AND		1 = 0
		 </cfif>
		 ORDER BY U.Created DESC
</cfquery>

<cfoutput>
	
	<cf_tl id="Movement UoM" var = "vLabel">
	
	<cfif url.movement neq "">
	    <cf_tl id="Maintain Movement UoM" var = "vOption">
		<cf_screentop height="100%" label="#vLabel#" option="#vOption#" layout="webapp" banner="yellow" scroll="yes" user="no">
	<cfelse>
	    <cf_tl id="Add Movement UoM" var = "vOption">
		<cf_screentop height="100%" label="#vLabel#" option="#vOption#" layout="webapp" banner="gray" scroll="yes" user="no">
	</cfif>
	
	<table class="hide">
		<tr><td><iframe name="processfrmLocationUoM" id="processfrmLocationUoM" frameborder="0"></iframe></td></tr>
	</table>
	
	<cfform name="frmLocationUoM" target="processfrmLocationUoM" action="../LocationUoM/LocationUoMSubmit.cfm?warehouse=#URL.warehouse#&location=#url.location#&itemNo=#url.ItemNo#&uoM=#url.UoM#&movement=#url.movement#">	
	
	<table width="91%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		<tr><td height="5"></td></tr>
			<tr>
				<td width="25%" class="labelmedium"><cf_tl id="UoM">:</td>
				<td>
					<cfif url.movement eq "">
					
						<cfinput type="Text" 
							name="movementUoM" 
							required="Yes" 
							class="regularxl"
							message="Please, enter a valid movement uom." 
							size="30" 
							maxlength="30" 
							value="#get.movementUoM#">
					<cfelse>
						<b>#url.movement#</b>
						<input type="Hidden" name="movementUoM" id="movementUoM" value="#url.movement#">
					</cfif>
				</td>
			</tr>
			<tr>
				<td class="labelmedium"><cf_tl id="Multiplier">:</td>
				<td>
					<cfif url.movement neq "" and url.movement eq get.UoMDescription>
						<b>1</b>
						<input type="Hidden" name="movementMultiplier" id="movementMultiplier" value="1">
					<cfelse>
						<cfinput type="Text" 
							name="movementMultiplier" 
							required="Yes" 
							message="Please, enter a valid numeric multiplier." 
							validate="numeric" 
							size="2"
							maxlength="8"
							class="regularxl"
							value="#get.movementMultiplier#" 
							style="text-align:right; padding-rigth:2px;">
					</cfif>
				</td>
			</tr>
			
			<tr>
				<td class="labelmedium"><cf_tl id="Default">:</td>
				<td class="labelmedium">
					<cfif get.movementDefault eq 1>
						<b>Yes</b>
						<input type="Hidden" name="movementDefault" id="movementDefault" value="1">
					<cfelse>
						<input type="Checkbox" class="radiol" name="movementDefault" id="movementDefault">
					</cfif>
				</td>
			</tr>
			
			<tr><td height="10"></td></tr>
			<tr><td colspan="2" class="line"></td></tr>
			<tr><td height="10"></td></tr>
			<tr>
				<td colspan="2" align="center">
					<cf_tl id = "Save" var="vSave">
					<input type="Submit" class="button10g" name="save" id="save" value="#vSave#">
				</td>
			</tr>
	
	</table>

</cfform>	

</cfoutput>