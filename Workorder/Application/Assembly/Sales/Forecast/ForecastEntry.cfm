<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfif url.customerid neq "">

	<cfset vCellStyle = "border:1px solid ##E6E6E6; background-color:##EAFFEB;">
	
	<table width="98%" align="center">
		<tr><td height="5"></td></tr>
		<tr>
			<td>
				<table width="100%" align="center">
					<tr>
						<td class="labellarge" width="15%"><cf_tl id="Year">:</td>
						<td>
							<cfoutput>
								<select id="fltYear" name="fltYear" class="regularxl" onchange="$('##fltCategory').val(''); $('##fltCategoryItem').val('');">
									<cfset forecastPeriod = 5>
									<cfset yrInit = year(now())>
									<cfset yrEnd = yrInit + forecastPeriod - 1>
									<cfloop from="#yrInit#" to="#yrEnd#" index="yr">
										<option value="#yr#"> #yr#
									</cfloop>
								</select>
							</cfoutput>
						</td>
					</tr>
					<tr><td height="5"></td></tr>
					<tr>
						<td class="labellarge"><cf_tl id="Period">:</td>
						<td>
							<select id="fltPeriod" name="fltPeriod" class="regularxl" onchange="$('#fltCategory').val(''); $('#fltCategoryItem').val('');">
								<option value="w"> <cf_tl id="Week">
								<option value="m" selected> <cf_tl id="Month">
								<option value="q"> <cf_tl id="Quarter">
								<option value="s"> <cf_tl id="Semester">
								<option value="y"> <cf_tl id="Year">
							</select>
						</td>
					</tr>
					<tr><td height="5"></td></tr>
					<tr>
						<td class="labellarge"><cf_tl id="Category">:</td>
						<td>
							<cfquery name="getCategory" 
								datasource="appsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT	*
									FROM	#CLIENT.LanPrefix#Ref_Category
									WHERE	Operational = '1'
									ORDER BY Description ASC
							</cfquery>
							<select id="fltCategory" name="fltCategory" class="regularxl">
								<option value=""> -- <cf_tl id="Select a valid category"> --
								<cfoutput query="getCategory">
									<option value="#Category#"> [#Category#] #Description#
								</cfoutput>
							</select>
						</td>
					</tr>
					<tr><td height="5"></td></tr>
					<tr>
						<td class="labellarge"><cf_tl id="Category Item">:</td>
						<td>
							<cfdiv id="divCategoryItem" bind="url:getCategoryItem.cfm?serviceItem=#url.serviceItem#&customerid=#url.customerid#&category={fltCategory}">
						</td>
					</tr>
				</table>
			</td>
			<cfoutput>
				<td width="200px" style="padding-right:25px;" style="#vCellStyle#">
					<table width="100%" align="center">	
						<tr>
							<td class="labelmedium"><cf_tl id="Keys">:</td>
						</tr>
						<tr><td height="5"></td></tr>
						<tr>
							<td style="padding:2px; #vCellStyle# border-right:0px;">
								<cf_tl id="Forecast" var="1">
								<input 
									type="Text" 
									name="key1" 
									id="key1"
									class="regularxl" 
									style="width:100%; font-size:11px; text-align:center; min-width:25px;" 
									readonly="yes" 
									value="#lt_text#">
							</td>
							<td class="labelit" style="#vCellStyle# border-right:0px; border-left:0px;">&##177;</td>
							<td style="padding:2px; #vCellStyle# border-left:0px;">
								<cf_tl id="Variation" var="1">
								<input 
									type="Text" 
									name="key2" 
									id="key2" 
									class="regularxl" 
									style="width:100%; font-size:11px; text-align:center; min-width:25px;" 
									readonly="yes"
									value="#lt_text#">
							</td>
						</tr>
						<tr>
							<td align="center" colspan="3" class="labelit" style="#vCellStyle#"><cf_tl id="Actual Sale"></td>
						</tr>
					</table>
				</td>
			</cfoutput>
		</tr>
		<tr><td height="5"></td></tr>
		<tr><td class="line" colspan="2"></td></tr>
		<tr><td height="5"></td></tr>
	</table>
	
	<table width="98%" height="100%" align="center">
		<tr>
			<td height="100%">
				<cfdiv 
					id="divFCEntryDetail" 
					style="height:100%;" 
					bind="url:ForecastEntryDetail.cfm?serviceItem=#url.serviceItem#&customerid=#url.customerid#&year={fltYear}&period={fltPeriod}&category={fltCategory}&categoryItem=">
			</td>
		</tr>
		<tr><td height="20"></td></tr>
	</table>

</cfif>