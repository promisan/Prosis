<cfparam name="url.datasource" 			default="martStaffing">
<cfparam name="url.queryTable"    		default="Gender">
<cfparam name="url.queryCondition"  	default="#vCondition#">
<cfparam name="url.countoption"   	    default="1">

<cfparam name="url.division"    		default="">
<cfparam name="url.source"    			default="Gender">

<cfparam name="url.columnLabel"   		default="">
<cfparam name="url.columnField"     	default="">
<cfparam name="url.columnDescription"   default="">
<cfparam name="url.columnOrder"     	default="">

<cfparam name="url.rowLabel" 			default="">
<cfparam name="url.rowField"    		default="">
<cfparam name="url.rowDescription" 		default="">
<cfparam name="url.rowOrder"    		default="">

<cfquery name="qGetBaseData" 
	datasource="#url.datasource#">
		SELECT 	*
		FROM 	#url.queryTable#
		#preserveSingleQuotes(url.queryCondition)#  
</cfquery>

<cfquery name="qGetColumns" dbtype="query">
	SELECT 	DISTINCT #url.columnField# as Field, #url.columnDescription# as FieldDescription, #url.columnOrder# as FieldOrder
	FROM	qGetBaseData 
	ORDER BY 3
</cfquery>

<cfquery name="qGetRows" dbtype="query">
	SELECT 	DISTINCT #url.rowField# as Field, #url.rowDescription# as FieldDescription, #url.rowOrder# as FieldOrder
	FROM	qGetBaseData 
	ORDER BY 3
</cfquery>

<table class="table table-striped table-bordered table-hover table-responsive">
	<thead>
		<tr style="background-color:#E8E8E8;">
			<th><cfoutput>#url.rowLabel# / #url.columnLabel#</cfoutput></th>
			<cfoutput query="qGetColumns">
				
				<cfset vClickElement = "">
				<cfset vClickElementStyle = "">
					<cfif url.showDetail eq "1">
					<cfset vClickElement = "clickElement('#FieldDescription#','#url.columnField#','#url.division#','#url.source#');">
					<cfset vClickElementStyle = "color:##358FDE;cursor:pointer;">
				</cfif>
			
				<th style="text-align:center; #vClickElementStyle#" onclick="#vClickElement#">
					<cf_tl id="#FieldDescription#">
					<cfif url.columnField neq "Gender">
						<br> <span style="font-size:60%;">F | M</span>
					</cfif>
				</th>
			</cfoutput>
			<th style="text-align:center;">
				<cf_tl id="Total">
				<cfif url.columnField neq "Gender">
					<br> <span style="font-size:60%;">F | M</span>
				</cfif>
			</th>
		</tr>
	</thead>
	<tbody>
		<cfoutput query="qGetRows">
			<tr>
			
				<cfset vClickElement = "">
				<cfset vClickElementStyle = "">
				<cfif url.showDetail eq "1">
					<cfset vClickElement = "clickElement('#FieldDescription#','#url.rowField#','#url.division#','#url.source#');">
					<cfset vClickElementStyle = "color:##358FDE;cursor:pointer;">
				</cfif>
			
				<td style="#vClickElementStyle#;" onclick="#vClickElement#">#FieldDescription#</td>
				<cfloop query="qGetColumns">
					<cfquery name="qCell" dbtype="query">
						SELECT 	COUNT(#url.countoption#) AS Total
						FROM 	qGetBaseData
						WHERE 	#url.columnField# = '#Field#'
						AND 	#url.rowField# = '#qGetRows.Field#'
					</cfquery>
					<cfif qCell.Total eq "">
						<td style="background-color:##F5F5F5;">&nbsp;</td>
					<cfelse>
						<td style="text-align:center;">
							<cfif url.columnField neq "Gender">
								<cfquery name="qCellFemale" dbtype="query">
									SELECT 	COUNT(#url.countoption#) AS Total
									FROM 	qGetBaseData
									WHERE 	#url.columnField# = '#Field#'
									AND 	#url.rowField# = '#qGetRows.Field#'
									AND 	Gender = 'F'
								</cfquery>
								<cfset vFemale = 0>
								<cfif qCellFemale.recordCount gt 0 AND qCellFemale.Total neq "">
									<cfset vFemale = qCellFemale.Total>
								</cfif>
								#vFemale# | #qCell.Total - vFemale#
							<cfelse>
								#qCell.Total#
							</cfif>
						</td>
					</cfif>
				</cfloop>
				<cfquery name="qCellRowTotal" dbtype="query">
					SELECT 	COUNT(#url.countoption#) AS Total
					FROM 	qGetBaseData
					WHERE 	#url.rowField# = '#qGetRows.Field#'
				</cfquery>
				<td style="text-align:center;">
					<cfif qCellRowTotal.Total eq "">
						0
					<cfelse>
						<cfif url.columnField neq "Gender">
							<cfquery name="qCellFemale" dbtype="query">
								SELECT 	COUNT(#url.countoption#) AS Total
								FROM 	qGetBaseData
								WHERE 	#url.rowField# = '#qGetRows.Field#'
								AND 	Gender = 'F'
							</cfquery>
							<cfset vFemale = 0>
							<cfif qCellFemale.recordCount gt 0 AND qCellFemale.Total neq "">
								<cfset vFemale = qCellFemale.Total>
							</cfif>
							#qCellRowTotal.Total#
							<br> <span style="font-size:60%;">#vFemale# | #qCellRowTotal.Total - vFemale#</span>
						<cfelse>
							#qCellRowTotal.Total#
						</cfif>
					</cfif>
				</td>
			</tr>
		</cfoutput>
	</tbody>
	<tfoot>
		<tr style="background-color:#E8E8E8;">
			<td><cf_tl id="Total"></td>
			<cfoutput query="qGetColumns">
				<cfquery name="qCellColumnTotal" dbtype="query">
					SELECT 	COUNT(#url.countoption#) AS Total
					FROM 	qGetBaseData
					WHERE 	#url.columnField# = '#Field#'
				</cfquery>
				<td style="text-align:center;">
					<cfif qCellColumnTotal.Total eq "">
						0
					<cfelse>
						<cfif url.columnField neq "Gender">
							<cfquery name="qCellFemale" dbtype="query">
								SELECT 	COUNT(#url.countoption#) AS Total
								FROM 	qGetBaseData
								WHERE 	#url.columnField# = '#Field#'
								AND 	Gender = 'F'
							</cfquery>
							<cfset vFemale = 0>
							<cfif qCellFemale.recordCount gt 0 AND qCellFemale.Total neq "">
								<cfset vFemale = qCellFemale.Total>
							</cfif>
							#qCellColumnTotal.Total#
							<br> <span style="font-size:60%;">#vFemale# | #qCellColumnTotal.Total - vFemale#</span>
						<cfelse>
							#qCellColumnTotal.Total#
						</cfif>
					</cfif>
				</td>
			</cfoutput>
			<cfquery name="qCellTotal" dbtype="query">
				SELECT 	COUNT(#url.countoption#) AS Total
				FROM 	qGetBaseData
			</cfquery>
			<td style="text-align:center; font-weight:bold;">
				<cfif qCellTotal.Total eq "">
					0
				<cfelse>
					<cfif url.columnField neq "Gender">
						<cfquery name="qCellFemale" dbtype="query">
							SELECT 	COUNT(#url.countoption#) AS Total
							FROM 	qGetBaseData
							WHERE 	Gender = 'F'
						</cfquery>
						<cfset vFemale = 0>
						<cfif qCellFemale.recordCount gt 0 AND qCellFemale.Total neq "">
							<cfset vFemale = qCellFemale.Total>
						</cfif>
						<cfoutput>
							#qCellTotal.Total#
							<br> <span style="font-size:60%;">#vFemale# | #qCellTotal.Total - vFemale#</span>
						</cfoutput>
					<cfelse>
						<cfoutput>#qCellTotal.Total#</cfoutput>
					</cfif>
				</cfif>
			</td>
		</tr>
	</tfoot>
</table>

