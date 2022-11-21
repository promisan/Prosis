
<cfparam name="url.showToday" default="0">
<CF_DateConvert Value="#url.pdate#">
<cfset dateSelOb = dateValue>
<cfset dateob = createDate(year(dateSelOb), 1, 1)>

<cfoutput>


	<table align="left">	
		<tr class="labelmedium" style="height:16px;border-top:0px solid silver">
			<cfset lastMonthLastYear = dateAdd('m', -1, dateOb)>
			<cf_tl id="Previous Year" var="1">
			<td align="center" width="25px" style="cursor:pointer;padding-right:3px;" onclick="calendarmonth('#dateFormat(lastMonthLastYear,client.dateFormatShow)#','jump','standard','seldate');" title="#lt_text#" class="clsNoPrint">
				<img src="#session.root#/images/Scroll-Left.png" width="32" height="32">
			</td>
			<cfloop from="0" to="11" index="mm">
				<cfset curDate = dateAdd('m',mm,dateob)>
				<cfset monthStyle = "cursor:pointer;font-size:80%">
				<cfset printClass = "clsNoPrint">
				<cfif year(curDate) eq year(dateSelOb) and month(curDate) eq month(dateSelOb)>
					<cfset monthStyle = "cursor:pointer;font-size:80%;color:gray; background-color:e1e1e1;">
					<cfset printClass = "clsMonthSelected">
				</cfif>
				
				<td align="center" class="#printClass#" width="#url.CellWidth#" 
				style="border:1px solid silver;#monthStyle#;font-size:14px;min-width:40px;cursor:pointer" 
				onclick="calendarmonth('#dateFormat(curDate,client.dateFormatShow)#','jump','standard','seldate');">				
				    <cfif url.cellwidth lte 50>					    
					    <cf_tl id="#Month(curdate)#">
					<cfelse> 
					    <cf_tl id="#left(MonthAsString(Month(curdate)),3)#">
					</cfif>		
									
						
				</td>
			</cfloop>
			<cfset firstMonthNextYear = dateAdd('yyyy', 1, dateOb)>
			<cf_tl id="Next Year" var="1">
			<td align="center" width="25px" style="cursor:pointer;padding-left:3px" onclick="calendarmonth('#dateFormat(firstMonthNextYear,client.dateFormatShow)#','jump','standard','seldate');" title="#lt_text#" class="clsNoPrint">
				<img src="#session.root#/images/Scroll-Right.png" width="32" height="32">
			</td>
			
			<cfif url.showRefresh eq 1>
			<cf_tl id="Reload" var="1">
			<td class="labelmedium clsNoPrint" align="center" style="cursor:pointer; padding-left:5px; padding-right:5px" title="#lt_text#">
				<a style="font-size:15px;" id="calendarreload" href="javascript:calendarmonth(document.getElementById('fselected').value,'jump','standard','seldate');"><font color="E64A00">#lt_text#</font></a>
			</td>
			</cfif>
			<cfif url.ShowPrint eq 1>
			<td class="clsNoPrint">|</td>
			<cf_tl id="Print" var="lblPrint">
			<td class="labelmedium clsNoPrint" align="center" style="cursor:pointer; padding-left:5px; color:##3CA9DD;" title="#lblPrint#">
				<cf_tl id="#MonthAsString(Month(dateSelOb))#" var="lblSelectedMonth">
				<cf_button2 
					mode		= "icon"
					type		= "Print"
					title       = "#lblPrint#" 
					id          = "Print"	
					imageHeight = "20px"				
					height		= "30px"
					width		= "35px"
					printTitle	= ".clsPCalendarTitle"
					printContent = ".clsPCalendarView"
					printCallback = "$('.clsMonthSelected').html('#lblSelectedMonth# #year(dateSelOb)#'); $('.clsPCalendarViewTable').css('height','80%').css('margin-top', '-25px');">
			</td>
			</cfif>

		</tr>		
		
	</table>
		
</cfoutput>
