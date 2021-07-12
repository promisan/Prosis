			  
<cfquery name="get" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT  *
        FROM    PromotionElement
		WHERE	PromotionId = '#url.promotionId#'
		<cfif url.serial neq "">
		AND		ElementSerialNo = #url.serial#
		<cfelse>
		AND		1=0
		</cfif>
</cfquery>

<table class="hide">
	<tr><td><iframe name="processElement" id="processElement" frameborder="0"></iframe></td></tr>
</table>

<cfform name="frmElement" 
			method="POST" 
			action="ElementSubmit.cfm?idmenu=#url.idmenu#&promotionid=#url.promotionid#&serial=#url.serial#" 
			target="processElement">
	  
<table width="100%" height="100%" align="center" class="formpadding">
	
	<cfoutput>
	<tr><td height="5"></td></tr>
	
	<tr>
		<td width="35%" class="labelmedium"><cf_tl id="Name">:</td>
		<td>
			<cfinput type="text" 
		       name="ElementName" 
			   value="#get.ElementName#" 
			   message="Please enter a name." 
			   required="yes" 
			   size="40" 
		       maxlength="60" 
			   class="regularxl">
		</td>
	</tr>
	
	<tr>
		<td class="labelmedium"><cf_tl id="Apply Sequence">:</td>
		<td>
			<cfinput type="text" 
		       name="elementOrder" 
			   value="#get.elementOrder#" 
			   message="Please enter an integer order." 
			   validate="integer" 
			   required="yes" 
			   size="1" 
		       maxlength="2" 
			   class="regularxl" 
			   style="text-align:center;">
		</td>
	</tr>
	
	<tr>
		<td class="labelmedium"><cf_tl id="Quantity required for promotion">:</td>
		<td>
			<cfinput type="text" 
		       name="Quantity" 
			   value="#get.Quantity#" 
			   message="Please enter a valid quantity." 
			   validate="integer" 
			   required="yes" 
			   size="2" 
		       maxlength="4" 
			   class="regularxl" 
			   style="text-align:right; padding-right:2px;">
		</td>
	</tr>
	
	<tr>
		<td class="labelmedium"><cf_tl id="Price promotion">:</td>
		<td>
			<table cellspacing="0" cellpadding="0">
				<tr>
					
					
					<td>
						<cfquery name="Dis" 
						datasource="appsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT 	*
							FROM 	Ref_DiscountType
						</cfquery>
						
						<cfset vDiscountType = get.DiscountType>
						<cfif vDiscountType eq "">
							<cfset vDiscountType = "Percentage">
						</cfif>
						
						<cfselect 
							name="DiscountType" 
							query="Dis" 
							value="code" 
							display="description" 
							selected="#vDiscountType#" 
							required="Yes" 
							class="regularxl"
							message="Please, select a valid discount type.">
						</cfselect> 
					</td>
					
					<td style="padding-left:3px" class="labelmedium">
						<cf_securediv id="divDiscount" bind="url:Discount.cfm?idmenu=#url.idmenu#&promotionid=#url.promotionid#&code={DiscountType}&discount=#get.Discount#">
					</td>
					
				</tr>
			</table>
			
		</td>
	</tr>
	
	<tr><td height="5"></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td height="5"></td></tr>
	<tr>
		<td colspan="2" align="center">
		 <cf_tl id="Save" var="vSave">
		 <input type="Submit" name="save" id="save" class="button10g" value="#vSave#" onclick="return validateElementFields();">
		</td>
	</tr>
	</cfoutput>
	
</table>

</cfform>
