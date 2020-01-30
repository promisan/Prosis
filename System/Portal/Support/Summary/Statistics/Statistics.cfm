<script>
	globalChartCount = 0;
</script>

<style>
	.clsChartContainer {
		border:							1px solid #C0C0C0;
		-moz-border-radius:				5px;
    	-webkit-border-radius: 			5px;
    	-khtml-border-radius: 			5px;
    	border-radius: 					5px;
		float:							left;
		min-width: 						400px;
		width:							47%;
		margin-left:					1%;
		margin-bottom:					1%;
		-ms-transition:					all 0.5s;
		-webkit-transition: 			all 0.5s;
	    -moz-transition:				all 0.5s;
	    -o-transition: 					all 0.5s;
	    transition: 					all 0.5s;
	}
	
	#mainChartContainer {
		padding:						10px;
	}
	
</style>


		
<table width="98%" align="center" class="formpadding">
	<tr><td height="5"></td></tr>
	<tr>
		<td width="80%">
			<table width="100%" align="center" class="formpadding">
				<tr>
					<td class="labelit" width="10%"><cf_tl id="Type">:</td>
					<td>
						<select name="supportChartType" id="supportChartType" class="regularxl">
							<option value="bar"><cf_tl id="Bar">
							<option value="pie"><cf_tl id="Pie">
							<option value="line"><cf_tl id="Line">
							<option value="area"><cf_tl id="Area">
						</select>
					</td>
				</tr>
				<tr>
					<td class="labelit" width="10%"><cf_tl id="Show By">:</td>
					<td>
						<select name="supportChartBy" id="supportChartBy" class="regularxl">
							<option value="classification"><cf_tl id="Classification">
							<option value="owner"><cf_tl id="Requester Owner">
							<!--- <option value="application"><cf_tl id="Application"> --->
							<option value="status"><cf_tl id="Status">
							<option value="actor"><cf_tl id="Actor">
							<!--- <option value="assigner"><cf_tl id="Assigner"> --->
							<option value="average leading days"><cf_tl id="Average Leading Days">
						</select>
					</td>
				</tr>
				<tr>
					<td class="labelit" width="10%"><cf_tl id="Period">:</td>
					<td>
						<cfform name="frmSupportChartPeriod">
							<table>
								<tr>
									<td>
										<cf_intelliCalendarDate9
											FieldName="supportChartEffective" 
											class="regularxl"
											Default="#dateformat(dateAdd('m',-3,now()) , CLIENT.DateFormatShow)#"
											AllowBlank="false">
									</td>
									<td> - </td>
									<td>
										<cf_intelliCalendarDate9
											FieldName="supportChartExpiration" 
											class="regularxl"
											Default="#dateformat(now(), CLIENT.DateFormatShow)#"
											AllowBlank="false">
									</td>
								</tr>
							</table>
						</cfform>
					</td>
				</tr>
			</table>
		</td>
		<td width="20%">
			<cf_tl id="Back to Tickets" var="1">
			<cf_button2 
				text="#lt_text#"
				width="100%"
				height="38px"
				onclick="summaryPanelApplyFilter()">
				
			<cf_tl id="Add Chart" var="1">
			<cf_button2 
				text="#lt_text#"
				width="100%"
				height="38px"
				onclick="addNewChart('##mainChartContainer');">
		</td>
	</tr>
</table>

<div id="mainChartContainer"></div>

<cfset ajaxOnLoad("doCalendar")>