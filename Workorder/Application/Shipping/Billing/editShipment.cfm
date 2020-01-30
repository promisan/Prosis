
<!--- edit screen for billig stuff --->

			 
<cfquery name="get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      ItemTransactionShipping
	WHERE     TransactionId = '#url.TransactionId#'	
</cfquery>  

<cfquery name="CommodityList" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    CommodityCode,
		          CommodityCode+' '+Description as Name
		FROM      Ref_Commodity R	
		ORDER BY  CommodityCode
</cfquery>	

<cf_screentop layout="webapp" banner="gray" scroll="Yes" label="Edit shipment line" user="no">

<cfoutput>

<cfform method="POST" name="shippingeditform" onsubmit="return false">

<table width="90%" align="center" class="formpadding">
	
	<tr><td height="10"></td></tr>
	
	<tr>
		<td width="20%" class="labelmedium">Commodity:</td>
		<td>
		
		<cfselect name="CommodityCode" 
				class="regularxl"
				query="CommodityList" 
				style="width:90%"
				required="No" 
				value="CommodityCode" 
				message="Please, select a commodity code" 
				display="Name" 
				selected="#get.CommodityCode#"/>
		
		</td>
	</tr>
		
	<tr>
		<td class="labelmedium"><cf_tl id="Sales price">:</td>
		<td>	
		<table cellspacing="0" cellpadding="0">
			<tr>
			<td class="labelmedium">#get.SalesCurrency#</td>
			<td style="padding-left:2px;">
					<cf_tl id="Please, enter a valid numeric price greater than 0." var="1">
					<cfinput type="text" class="regularxl" name="SalesPrice" id="SalesPrice" value="#numberformat(Get.SalesPrice,'_.__')#" required="true" message="#lt_text#" validate="float" range="0.00000000001," style="width:80px; text-align:right; padding-right:2px;">
			</td>				
			</tr>
		</table>		
		</td>
	</tr>
	<tr><td></td></tr>	
	<tr><td colspan="2" class="line"></td></tr>	
	<tr><td colspan="2" align="center">	
		<input type="button" name="Submit" value="Submit" class="button10g" onclick="validate('#url.transactionid#')">	
	</td></tr>	
	<tr><td></td></tr>
	
</table>

</cfform>

</cfoutput>