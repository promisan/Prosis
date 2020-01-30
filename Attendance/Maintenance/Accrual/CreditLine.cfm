<cfparam name="url.currentrow" 			default="1">
<cfparam name="url.ContractDuration" 	default="0">
<cfparam name="url.Credit" 				default="0">
<cfparam name="url.style" 				default="">

<cfoutput>
	<table width="230" cellspacing="0" cellpadding="0" class="formpadding">
		<tr class="clsCreditRows" id="CreditRow_#url.currentRow#" style="#url.style#" data-val="#url.currentRow#">
			<td align="center" width="10%">
				<cf_img icon="delete" onclick="removeCreditLine('#url.currentRow#');">
			</td>
			<td width="45%" style="border:1px solid silver;border-bottom:0px">
				<cf_tl id="Please enter a valid integer duration" var="1">
				<input 
					type="Text" 
					class="regularh enterastab" 
					name="ContractDuration_#url.currentRow#" 
					id="ContractDuration_#url.currentRow#" 
					value="#url.ContractDuration#" 
					validate="integer" 
					required="Yes" 
					message="#lt_text#"
					style="width:100%;text-align:center;;border:0px">
			</td>
			<td width="45%" style="border:1px solid silver;border-bottom:0px">
				<cf_tl id="Please enter a valid integer credit" var="1">
				<input 
					type="Text" 
					class="regularh enterastab" 
					name="Credit_#url.currentRow#" 
					id="Credit_#url.currentRow#" 
					value="#url.Credit#" 
					validate="numeric" 
					required="Yes"
					message="#lt_text#"
					style="width:100%;text-align:center;border:0px">
			</td>
		</tr>
	</table>
</cfoutput>