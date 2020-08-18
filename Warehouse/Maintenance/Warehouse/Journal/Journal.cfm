
<cfquery name="qWarehouse" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Warehouse
		WHERE 	Warehouse = '#url.id1#'
</cfquery>

<cfif qWarehouse.saleMode eq "2" or qWarehouse.SaleMode eq "3">
	<cfset areaList = "STOCK,COGS,SALE,SETTLE">
<cfelseif qWarehouse.saleMode eq "1" >
    <cfset areaList = "STOCK,COGS,SALE">
<cfelseif qWarehouse.saleMode eq "0">
    <cfset areaList = "STOCK">
</cfif>	

<cfquery name="Currency" 
	datasource="appsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Currency
		WHERE	EnableProcurement = 1
		AND		Operational = 1 
</cfquery>

<cfquery name="qWarehouseJournal" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	* 
		FROM 	WarehouseJournal 
		WHERE 	Warehouse = '#url.id1#'
</cfquery>

<cfquery name="qJournal" 
	datasource="appsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*,
				(Journal + ' - ' + Description) as display
		FROM 	Journal
		WHERE 	Mission = '#qWarehouse.mission#'
</cfquery>

<cf_divscroll>

<cfform action="Journal/JournalSubmit.cfm?id1=#url.id1#" method="POST" name="warehousejournal" id="warehousejournal">

<table width="90%" align="center">
	
	<tr><td height="5"></td></tr>
	
	<cfloop list="#areaList#" index="area">
		<tr class="line">
			<td class="labelmedium" style="height:40px;font-size:26px"><cfoutput>#area#</cfoutput></td>
		</tr>		
		<cfoutput query="Currency">
		
			<cfif area eq "STOCK" and Currency neq Application.BaseCurrency>
			
			<cfelse>
			<tr>
				<td>
					<table width="100%" align="center" class="formspacing">
						<tr>
							<td width="2%"></td>
							<td width="200" class="labelmedium" valign="top"><cf_space spaces="50">#Currency# #Description#:</td>
							<td width="80%" valign="top">
							
								<cfset tCat = "">
								<cfif area eq "STOCK">
									<cfset tCat = "Inventory">
								<cfelseif area eq "COGS">
									<cfset tCat = "Inventory">
								<cfelseif area eq "SALE">
									<cfset tCat = "Receivables">
								<cfelseif area eq "SETTLE">
									<cfset tCat = "Receipt">	
								</cfif>
								
								<cfquery name="qJ" dbtype="query">
									SELECT 	*
									FROM	qJournal
									WHERE	TransactionCategory  = '#tCat#'
									AND 	Currency = '#currency#'
								</cfquery>							
																
								<cfquery name="qWJ" dbtype="query">
									SELECT 	* 
									FROM 	qWarehouseJournal 
									WHERE 	Area = '#area#' 
									AND 	Currency = '#currency#'
								</cfquery>
																
								<cfselect 
									name="Journal_#area#_#currency#" 
									query="qJ" class="regularxl"
									queryposition="below" 
									required="No" 
									style="width:400"
									message="Please, select a valid journal." 
									display="display" 
									value="journal" 
									selected="#qWJ.Journal#" 
									onchange="toggleElementByControl(this,'.clsDetails_#area#_#currency#');">
									<option value="""">--Select Journal--</option>
								</cfselect>
								
							</td>
						</tr>
						<cfif area eq "SETTLE">
						
								<cfif qWJ.Journal neq "">
								
										<tr><td height="6"></td></tr>
										<tr class="clsDetails_#area#_#currency#">
										<td width="2%" style="padding:3px;"></td>
										<td style="height:25px;padding-left:40px" class="labelmedium"><cf_tl id="Invoice No">:</td>
										<td>
											<table>
											<tr>
											   <td class="labelmedium" style="padding-left:3px">Manual</td>
											   <td class="labelmedium" style="padding-left:4px"><input type="radio" class="radiol" value="1" <cfif qWJ.TransactionMode neq "2">checked</cfif> name="Mode_#area#_#currency#" id="Mode_#area#_#currency#"></td>
											   <td class="labelmedium" style="padding-left:8px">Derrived</td>
											   <td class="labelmedium" style="padding-left:4px"><input type="radio" class="radiol" value="2" <cfif qWJ.TransactionMode eq "2">checked</cfif> name="Mode_#area#_#currency#" id="Mode_#area#_#currency#"></td>											
											</tr>
											</table>
										</td>
										</tr>
										
										<tr class="clsDetails_#area#_#currency#">
										<td width="2%" style="padding:3px;"></td>
										<td style="padding-left:40px" class="labelmedium"><cf_tl id="Template Mode 1">:</td>
										<td>
											<table width="100%">
												<tr>
													<td width="95%"  style="padding:3px;" >
														<cfinput type="Text" 
																 name="TemplateMode1_#area#_#currency#" 
																 id="TemplateMode1_#area#_#currency#" 
																 value="#qWJ.TransactionTemplateMode1#" 
																 class="regularxl clsTransactionTemplate" 
																 required="No" 
																 maxlength="80" 
																 style="width:100%;"
																 onblur= "ColdFusion.navigate('Journal/FileValidation.cfm?template='+this.value+'&container=pathValidationDivMode1_#area#_#currency#&resultField=validatePathMode1_#area#_#currency#','pathValidationDivMode1_#area#_#currency#')">
													</td>
													<td width="5%" style="padding-left:3px;">
														<cfdiv id="pathValidationDivMode1_#area#_#currency#" bind="url:Journal/FileValidation.cfm?template=#qWJ.TransactionTemplateMode1#&container=pathValidationDivMode1_#area#_#currency#&resultField=validatePathMode1_#area#_#currency#">
													</td>
												</tr>
											</table>
										</td>
										</tr>
										
										<tr class="clsDetails_#area#_#currency#">
										<td width="2%" style="padding:3px;"></td>
										<td style="padding-left:40px" class="labelmedium"><cf_tl id="Template Mode 2">:</td>
										<td>
											<table width="100%">
												<tr>
													<td width="95%"  style="padding:3px;" >
														<cfinput 
															type="Text" 
															name="TemplateMode2_#area#_#currency#" 
															id="TemplateMode2_#area#_#currency#" 
															value="#qWJ.TransactionTemplateMode2#" 
															class="regularxl clsTransactionTemplate" 
															required="No" 
															maxlength="80" 
															style="width:100%;"
															onblur= "ColdFusion.navigate('Journal/FileValidation.cfm?template='+this.value+'&container=pathValidationDivMode2_#area#_#currency#&resultField=validatePathMode2_#area#_#currency#','pathValidationDivMode2_#area#_#currency#')">
													</td>
													<td width="5%" style="padding-left:3px;">
														<cfdiv id="pathValidationDivMode2_#area#_#currency#" bind="url:Journal/FileValidation.cfm?template=#qWJ.TransactionTemplateMode2#&container=pathValidationDivMode2_#area#_#currency#&resultField=validatePathMode2_#area#_#currency#">
													</td>
												</tr>
											</table>
										</td>
										</tr>
										
										<tr class="clsDetails_#area#_#currency#">
										<td width="2%" style="padding:3px;"></td>
										<td style="height:25px;padding-left:40px" class="labelmedium"><cf_tl id="Mail">:</td>
										<td>
											<table>
												<tr>
												   <td class="labelmedium" style="padding-left:3px"><input type="radio" class="radiol" value="0" <cfif qWJ.TransactionMail eq "0">checked</cfif> name="Mail_#area#_#currency#"></td>											 												 
												   <td class="labelmedium" style="padding-left:4px">Embed (standard format)</td>
												   <td class="labelmedium" style="padding-left:8px"><input type="radio" class="radiol" value="1" <cfif qWJ.TransactionMail eq "1">checked</cfif> name="Mail_#area#_#currency#"></td>
												   <td class="labelmedium" style="padding-left:4px">Embed (Invoice template)</td>
												   <td class="labelmedium" style="padding-left:8px"><input type="radio" class="radiol" value="2" <cfif qWJ.TransactionMail eq "2">checked</cfif> name="Mail_#area#_#currency#"></td>																				   											 
												   <td class="labelmedium" style="padding-left:4px">Attachment (Invoice template/PDF)</td>								   
												   
												</tr>
											</table>
										</td>
										</tr>										
										
										<tr class="clsDetails_#area#_#currency#">
											<td width="2%" style="padding:3px;"></td>
											<td valign="top" style="padding-top:4px;padding-left:40px"  class="labelmedium"><cf_tl id="Disclaimer Text">:</td>
											<td style="padding:3px;" >
													<cf_textarea 
														name="Memo_#area#_#currency#" 
														id="Memo_#area#_#currency#" 
														maxlength="1000" 
														validate="maxlength" 
														message="#area# #currency#: Memo field exceeds 1000 chars."
														style="border-radius:3px; height:100px; width:100%; border:1px solid ##C0C0C0; font-size:12px; padding:3px;"
														class="regular">#qWJ.transactionMemo#</cf_textarea>
											</td>
										</tr>
									
								</cfif>
						</cfif>
							
					</table>
				</td>
			</tr>
			</cfif>
		</cfoutput>
		<tr><td height="2"></td></tr>
	</cfloop>
	<tr><td height="3"></td></tr>
	<tr><td class="line"></td></tr>
	<tr><td height="10"></td></tr>
	<tr>
		<td align="center" style="padding-bottom:10px">
			<cfoutput>
				<cf_tl id = "Save" var = "vSave">
				<input type="Submit" style="width:160px" name="save" id="save" value="  #vSave#  " class="button10g" onclick="return validateJournalTemplates();">
			</cfoutput>
		</td>
	</tr>

</table>

</cfform>

</cf_divscroll>