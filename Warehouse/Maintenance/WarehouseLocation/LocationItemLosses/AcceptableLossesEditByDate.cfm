
<cfif url.effectiveDate neq "">

	<cfset vyear          = mid(url.effectivedate, 1, 4)>
	<cfset vmonth         = mid(url.effectivedate, 6, 2)>
	<cfset vday           = mid(url.effectivedate, 9, 2)>	
	<cfset vDateEffective = createDate(vyear, vmonth, vday)>

<cfelse>

	<cfset vDateEffective = now()>
	
</cfif>

<cf_tl id="Acceptable Losses" var = "vLabel">

<cfif url.effectiveDate neq "">
	<cf_screentop height="100%" label="#vLabel#" layout="webapp" banner="gray" scroll="yes" user="No">
<cfelse>
    <cf_tl id="Add acceptable loss" var = "vOption">
	<cf_screentop height="100%" label="#vLabel#" layout="webapp" scroll="yes" user="No">
</cfif>

<table class="hide">
	<tr><td><iframe name="processLossesByDate" id="processLossesByDate" frameborder="0"></iframe></td></tr>
</table>
	
<cfform name="frmLossesByDate"  
    target="processLossesByDate" 
	action="../LocationItemLosses/AcceptableLossesSubmitByDate.cfm?warehouse=#URL.warehouse#&location=#url.location#&itemNo=#url.ItemNo#&uoM=#url.UoM#&effDate=#url.effectiveDate#">	

<table width="90%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">
	<tr><td height="10"></td></tr>
		
	<tr>
		<td width="20%" class="labelmedium"><cf_tl id="Effective">:</td>
		<td>
		
			<cf_intelliCalendarDate9
					FieldName="DateEffective"
					Message="Select a valid Effective Date"
					Default="#dateformat(vDateEffective, CLIENT.DateFormatShow)#"
					class="regularxl"
					AllowBlank="False">
					
			<cfajaxproxy bind="javascript:getDataByDate('DateEffective',{DateEffective},'#URL.warehouse#','#url.location#','#url.ItemNo#','#url.UoM#')"> 
			
		</td>
	</tr>
	<tr><td height="5"></td></tr>
	<tr>
		<td colspan="2">
			<cfdiv id="divDetailList" 
			   bind="url:../LocationItemLosses/AcceptableLossesEditByDateDetail.cfm?warehouse=#URL.warehouse#&location=#url.location#&itemNo=#url.ItemNo#&uoM=#url.UoM#&effDate=#dateformat(vDateEffective, 'yyyy-mm-dd')#">
		</td>
	</tr>
	
	<tr><td></td></tr>	
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>
		<td colspan="2" align="center" style="padding-top:5px">
			<cfoutput>
				<cf_tl id = "Save" var ="1">
				<input 
					type		= "submit"
					mode        = "silver"
					value       = "#lt_text#" 
					id          = "save"
					width       = "150" 					
					color       = "636334"
					fontsize    = "11px"
					class		= "button10g">
			</cfoutput>
		</td>
	</tr>
		
</table>

</cfform>

<cfset ajaxonload("doCalendar")>
