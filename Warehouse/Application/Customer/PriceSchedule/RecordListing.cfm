<cfquery name="maxDate" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	MAX(DateEffective) AS DateEffective
		FROM	CustomerSchedule
		WHERE	CustomerId = '#url.CustomerId#'
</cfquery>

<cfset vMaxDate = now()>
<cfif maxDate.recordCount gt 0>
	<cfif maxDate.DateEffective neq "">
		<cfset vMaxDate = maxDate.DateEffective>
	</cfif>
</cfif>

<cf_divscroll>

<cfform 
	name="frmPriceSchedule" 
	action="../PriceSchedule/RecordSubmit.cfm?customerId=#url.customerId#&mission=#url.mission#" 
	method="POST">

	<table width="98%" align="center" cellpadding="0" cellspacing="0">
		<tr>
			<td class="labelmedium" width="20%" style="font-weight:bold;">
				<cf_tl id="Reference Date">:
			</td>
			<td>
				<cf_intelliCalendarDate9
					FieldName="DateEffective"
					class="regularxl"
					Message="Select a valid Effective Date"
					Default="#dateformat(vMaxDate, CLIENT.DateFormatShow)#"
					AllowBlank="False">
				
				<cfajaxproxy bind="javascript:getDataByDate('DateEffective',{DateEffective})">
			</td>
		</tr>
		<tr><td height="5"></td></tr>
		<tr><td colspan="2" class="line"></td></tr>
		<tr><td height="10"></td></tr>
		
		<tr>
			<td colspan="2">
				<cfdiv id="divCategories" bind="url:#session.root#/Warehouse/Application/Customer/PriceSchedule/Categories.cfm?customerId=#url.customerId#&mission=#url.mission#&dateeffective=#dateformat(vMaxDate, CLIENT.DateFormatShow)#">
			</td>
		</tr>
		
		<tr><td height="4"></td></tr>
		<tr><td colspan="2" class="line"></td></tr>
		<tr><td height="4"></td></tr>
		
		<tr>
			<td colspan="2" align="center">
				<cf_tl id="Save" var="1">
				<cfoutput>
				<input type="Submit" style="width:150px;height:30px" onclick="Prosis.busy('yes')" id="btnSubmit" name="btnSubmit" class="button10g" value="#lt_text#">
				</cfoutput>
			</td>
		</tr>
		
	</table>

</cfform>

</cf_divscroll>

<cfset ajaxonload("doCalendar")>