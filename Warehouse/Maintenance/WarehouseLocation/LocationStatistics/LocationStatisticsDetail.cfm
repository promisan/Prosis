<cfquery name="stats" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	T.*,
				I.ItemPrecision,
				U.UoMDescription,
				TT.Description as TransactionTypeDescription,
				TT.TransactionClass
		FROM	ItemTransaction T
				INNER JOIN Item I
					ON T.ItemNo = I.ItemNo
				INNER JOIN ItemUoM U
					ON T.ItemNo = U.ItemNo
					AND T.TransactionUoM = U.UoM
				INNER JOIN Ref_TransactionType TT
					ON T.TransactionType = TT.TransactionType
		WHERE	T.Warehouse = '#url.warehouse#'
		AND		T.Location = '#url.location#'
</cfquery>

<table width="100%" align="center" class="clsPrintable">
						
	<tr>
		<td width="250" height="30" valign="top" class="labelmedium"><cf_tl id="Last 10 transactions">:</td>
		<td class="stat" style="border-bottom:0px solid #C0C0C0; border-left:0px solid #C0C0C0;">
			<cfquery name="stat" dbtype="query">
				SELECT	 *
				FROM	 stats
				ORDER BY TransactionDate DESC
			</cfquery>
			<table width="100%" cellspacing="0" cellpadding="0" align="center">
				<cfoutput query="stat" maxrows="10">
					<cf_precision number = ItemPrecision> <!--- returns pformat --->
					<tr class="labelmedium">
						<td height="15" width="30%" title="<cf_tl id='date and time'>">#dateFormat(TransactionDate,"#CLIENT.DateFormatShow#")# - #timeFormat(TransactionDate, "hh:mm:ss tt")#</td>
						<td width="15%" title="<cf_tl id='transaction type'>">#TransactionTypeDescription#</td>
						<td title="<cf_tl id='product'>">#ItemDescription#</td>
						<td width="10%" title="<cf_tl id='unit of measure'>">#UoMDescription#</td>
						<td align="right" width="15%" title="<cf_tl id='quantity'>">#lsNumberFormat(transactionQuantity,pformat)#</td>
					</tr>
				</cfoutput>
				<cfif stat.recordCount eq 0>
					<tr><td class="labelmedium" colspan="5" align="center" height="25" style="font-style:italic;">No transactions in the last 10 days</td></tr>
				</cfif>
			</table>
		</td>
	</tr>
	
	<tr>
		<td width="250" height="30" class="labelit" style="border-bottom:1px solid #C0C0C0;"><cf_tl id="Last receipt">:</td>
		<td class="stat" style="border-bottom:1px solid #C0C0C0; border-left:0px solid #C0C0C0;">
			<cfquery name="stat" dbtype="query">
				SELECT	*
				FROM	stats
				WHERE	TransactionClass = 'Receipt'
				ORDER BY TransactionDate DESC
			</cfquery>
			<table width="100%" align="center">
				<cfoutput query="stat" maxrows="1">
					<cf_precision number = ItemPrecision> <!--- returns pformat --->
					<tr class="labelmedium">
						<td height="15" width="30%" title="<cf_tl id='date and time'>">#dateFormat(TransactionDate,"#CLIENT.DateFormatShow#")# - #timeFormat(TransactionDate, "hh:mm:ss tt")#</td>
						<td width="15%" title="<cf_tl id='transaction type'>">#TransactionTypeDescription#</td>
						<td title="<cf_tl id='product'>">#ItemDescription#</td>
						<td width="10%" title="<cf_tl id='unit of measure'>">#UoMDescription#</td>
						<td align="right" width="15%" title="<cf_tl id='quantity'>">#lsNumberFormat(transactionQuantity,pformat)#</td>
					</tr>
				</cfoutput>
				<cfif stat.recordCount eq 0>
					<tr><td class="labelmedium" colspan="5" align="center" height="25">[No receipts recorded]</td></tr>
				</cfif>
			</table>
		</td>
	</tr>
	
	<tr>
		<td width="250" height="30" class="labelmedium" style="border-bottom:0px solid #C0C0C0;"><cf_tl id="Average distribution for the last 10 days">:</td>
		<td class="labelmedium" style="border-bottom:1px solid #C0C0C0; border-left:1px solid #C0C0C0;">
			<cfset TenDaysFromNow = dateAdd('d',-10,now())>
			<cfquery name="stat" dbtype="query">
				SELECT	ItemNo, 
						ItemDescription, 
						TransactionUoM, 
						UoMDescription,
						TransactionType, 
						TransactionTypeDescription, 
						AVG(TransactionQuantity) as AverageDistribution
				FROM	stats
				WHERE	TransactionClass = 'Distribution'
				AND		TransactionDate >= <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#TenDaysFromNow#"> 
				GROUP BY
						ItemNo, 
						ItemDescription, 
						TransactionUoM, 
						UoMDescription,
						TransactionType, 
						TransactionTypeDescription
				ORDER BY 
						TransactionTypeDescription,
						ItemDescription, 
						UoMDescription
			</cfquery>
			<table width="100%" align="center">
				<tr>
					<cfoutput>
						<td class="labelmedium" height="25" colspan="5">From: #dateFormat(TenDaysFromNow,"#CLIENT.DateFormatShow#")# - #timeFormat(TenDaysFromNow, "hh:mm:ss tt")# &nbsp; &nbsp; To: #dateFormat(now(),"#CLIENT.DateFormatShow#")# - #timeFormat(now(), "hh:mm:ss tt")#</td>
					</cfoutput>
				</tr>
				<cfoutput query="stat">
					<cf_precision number = ItemPrecision> <!--- returns pformat --->
					<tr class="labelmedium">
						<td class="labelmedium" height="15" width="30%"></td>
						<td class="labelmedium" width="15%" title="<cf_tl id='transaction type'>">#TransactionTypeDescription#</td>
						<td class="labelmedium" title="<cf_tl id='product'>">#ItemDescription#</td>
						<td class="labelmedium" width="10%" title="<cf_tl id='unit of measure'>">#UoMDescription#</td>
						<td align="right" width="15%" title="<cf_tl id='average distribution'>">#lsNumberFormat(AverageDistribution*-1,pformat)#</td>
					</tr>
				</cfoutput>
				<cfif stat.recordCount eq 0>
					<tr><td colspan="5" align="center" height="25" style="font-style:italic;">[No distributions in the last 10 days]</td></tr>
				</cfif>
			</table>
		</td>
	</tr>
	
	<tr>
		<td width="250" height="30" class="labelmedium" style=""><cf_tl id="Assets that are serviced by this location">:</td>
		<td class="stat" style="border-left:1px solid #C0C0C0;">
			<cfquery name="getLocation" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT	L.*
					FROM	WarehouseLocation WL
							INNER JOIN Location L ON WL.LocationId = L.Location
					WHERE	WL.Warehouse = '#url.warehouse#'
					AND		WL.Location = '#url.location#'
			</cfquery>
			
			<cfquery name="coverage" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT	AI.*,
							I.ItemDescription,
							L.LocationName
					FROM	WarehouseLocation WL
							INNER JOIN Location L
								ON WL.LocationId = L.Location
							INNER JOIN AssetItemCoverage C
								ON L.Location = C.Location
							INNER JOIN AssetItem AI
								ON C.AssetId = AI.AssetId
							INNER JOIN Item I
								ON AI.ItemNo = I.ItemNo
					WHERE	WL.Warehouse = '#url.warehouse#'
					AND		WL.Location = '#url.location#'
			</cfquery>
			
			<table width="100%" align="center">
				<tr>
					<cfoutput>
						<td class="stat" height="25" colspan="5">
							<cfif getLocation.recordCount eq 0>
								<i>No location defined</i>
							<cfelse>
								#getLocation.LocationName#
							</cfif>
						</td>
					</cfoutput>
				</tr>
				<tr>
					<cfoutput query="coverage">
						<tr class="labelmedium">
							<td height="15" width="30%" title="<cf_tl id='serial'>">#SerialNo#</td>
							<td width="15%" title="<cf_tl id='description'>">#ItemDescription#</td>
							<td title="<cf_tl id='make an model'>">#make# - #model#</td>
							<td width="10%" title="<cf_tl id='plate'>">#AssetDecalNo#</td>
							<td align="right" width="15%" title="<cf_tl id='barcode'>">#AssetBarcode#</td>
						</tr>
					</cfoutput>
				</tr>
				<cfif coverage.recordCount eq 0>
					<tr><td class="stat" colspan="5" align="center" height="25" style="font-style:italic;">[No assets serviced by this location]</td></tr>
				</cfif>
			</table>
		</td>
	</tr>

</table>