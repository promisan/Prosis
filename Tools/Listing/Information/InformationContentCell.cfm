	
<cfoutput>

<cfquery name="Cells" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     xl#Client.LanguageId#_Ref_ModuleControlSectionCell R
	WHERE    SystemFunctionId = '#attributes.SystemFunctionId#'	
	AND      FunctionSection = '#FunctionSection#'
	ORDER BY CellCode
</cfquery>





<table width="100%" height="100%" cellspacing="0" cellpadding="0" class="formpadding">
	
	   <cfloop query="Cells">
			<cfset qry = CellValueQuery>
			
			<cfset qryCond = CellValueConditionQuery>

			<cfif qry neq "">
						
			<cfset qry = replaceNoCase("#qry#", "@mission", "#attributes.mission#" , "ALL")>
			<cfset qry = replaceNoCase("#qry#", "@id", "#attributes.id#" , "ALL")>
			<cfset qry = replaceNoCase("#qry#", "@user", "#SESSION.acc#" , "ALL")>			

			<cfset isValid = true>
			<cfif qryCond neq "">
				<cfset qryCond = replaceNoCase("#qryCond#", "@mission", "#attributes.mission#" , "ALL")>
				<cfset qryCond = replaceNoCase("#qryCond#", "@id", "#attributes.id#" , "ALL")>
				<cfset qryCond = replaceNoCase("#qryCond#", "@user", "#SESSION.acc#" , "ALL")>			

				<cftry>
			
					<cfquery name="GetCondition" 
					datasource="#CellValueDatasource#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						#preservesinglequotes(qryCond)#								
					</cfquery>
					
					<cfset valCondition = evaluate("getCondition.#CellValueField#")>
											
					<cfif valCondition eq 0>
						<cfset isValid = false>
					</cfif>
					
					
				<cfcatch>
				
				</cfcatch>
				</cftry>	
				


			</cfif>

			<!--- execute the parsed query --->
			<cftry>
			
			<cfquery name="GetValue" 
			datasource="#CellValueDatasource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				#preservesinglequotes(qry)#								
			</cfquery>
			
			<cfif isValid>
			<cfif Cells.CellArray eq "1">
				<tr>
				<td colspan = "2">
				<table width = "100%">
				<cfloop query = "GetValue">
					<cfset desc = evaluate("getValue.#Cells.CellDescriptionField#")>
					<cfset val = evaluate("getValue.#Cells.CellValueField#")>

					<cfif Cells.CellCodeField neq "">
						<cfset cde = evaluate("getValue.#Cells.CellCodeField#")>					
					<cfelse>
						<cfset cde = "">											
					</cfif>					
					<tr>
						<td style="cursor:pointer"><cf_UIToolTip  tooltip="#Cells.CellTooltip#">#Cells.CellLabel# #desc#</cf_UIToolTip></td>
						<td align="right">
							<a href="javascript:informationdetail('#Cells.SystemFunctionId#','#Cells.FunctionSection#','#Cells.CellCode#','#Cells.detailtemplate#','#attributes.mission#','#attributes.id#','#cde#')">
							<cfinclude template = "InformationContentCellValue.cfm">
							</a>
						</td>		
					</tr>
				</cfloop>	
				</table>
				</td>
				</tr>
			<cfelse>	
				<tr>
				<td style="cursor:pointer"><cf_UIToolTip  tooltip="#CellTooltip#">#CellLabel#</cf_UIToolTip></td>

				<td align="right" 
			    style="padding-right:4px">
				
					<a href="javascript:informationdetail('#Cells.SystemFunctionId#','#Cells.FunctionSection#','#Cells.CellCode#','#detailtemplate#','#attributes.mission#','#attributes.id#','')">
					<!--- get the needed value --->
						<cfset val = evaluate("getValue.#CellValueField#")>
						<!--- display the value in the needed format --->										
						<cfinclude template = "InformationContentCellValue.cfm">
					</a>
				</td>
				</tr>													
			</cfif>		
			</cfif>
			<cfcatch>
				Err!
			</cfcatch>
		
			</cftry>

		</cfif>			
		

		

	
	</cfloop>
</table>

</cfoutput>