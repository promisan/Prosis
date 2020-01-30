
<cfparam name="url.requirementid" default="">

	<cfquery name="Param" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_ParameterMission
			WHERE  Mission = (SELECT Mission FROM Program WHERE ProgramCode = '#url.programcode#')
	</cfquery>		
	
	<!--- show requisitions --->
	
	<cfquery name="RequisitionList" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    L.RequisitionNo,
			          L.Reference,
			          L.RequestDate, 
					  L.RequestDescription, 
					  (SELECT Description FROM ItemMaster WHERE Code = L.ItemMaster) as ItemMaster,
					  LF.Fund, LF.ProgramPeriod, LF.ProgramCode, LF.ObjectCode, LF.Percentage,
					  L.ItemMaster, L.ActionStatus, 
					  L.RequestCurrency, 
                      L.RequestQuantity, L.RequestCurrency AS RequestCurrency, L.RequestCurrencyPrice, L.RequestCostPrice, L.RequestAmountBase, 					   
					  L.OfficerUserId, L.OfficerLastName, L.OfficerFirstName, L.Created
			FROM      RequisitionLine L INNER JOIN
                      RequisitionLineFunding LF ON L.RequisitionNo = LF.RequisitionNo
			WHERE     1=1		  
			<cfif url.fund neq "Total" and url.fund neq "">		  
			AND       LF.Fund          = '#url.fund#'    			
			</cfif>
						
			<!--- object,parent,resource --->	
			<cfif url.resource eq "resource">		
				AND   LF.ObjectCode IN (SELECT Code FROM Program.dbo.Ref_Object WHERE Resource = '#res#')			
			<cfelseif url.isParent eq "1">			
				AND    (
			          LF.ObjectCode = '#url.object#' OR 
		              LF.ObjectCode IN (SELECT Code 
		                               FROM   Program.dbo.Ref_Object 
							           WHERE  ParentCode = '#url.object#')
		        	  ) 		
			<cfelse>		
				AND   LF.ObjectCode  = '#url.object#'		
			</cfif>
			
			<!--- program --->	
			<cfif url.programhierarchy eq "" or url.programhierarchy eq "undefined">			
			AND      LF.ProgramCode = '#URL.ProgramCode#'		
			<cfelse>		
			AND      LF.ProgramCode IN (SELECT ProgramCode 
					                   FROM   Program.dbo.ProgramPeriod  
									   WHERE  Period       = '#url.period#'
									   AND    PeriodHierarchy LIKE '#url.programhierarchy#%')		
			</cfif>
															
			<!--- execution period --->
			AND       LF.ProgramPeriod IN (SELECT Period 
			                               FROM   Program.dbo.Ref_AllotmentEdition 
										   WHERE  EditionId = '#url.Edition#')								
					
			<!--- requisitions in process, not 0 or 0z --->
			AND       (ActionStatus >= '1' AND ActionStatus <= '3')
			
	</cfquery>	
		
	<table width="100%" border="0" align="center" class="navigation_table">
	
	<cfif RequisitionList.recordcount gte "1">
	
	<tr class="labelmedium line">
	 <td colspan="9" style="padding-left:0px;font-size:20px;height:40px;font-weight:200"><cf_tl id="Pre-encumbered amounts"></td>
	</tr>
	
	</cfif>
	
	<cfoutput query="RequisitionList">
	
		<tr class="labelmedium line navigation_row" style="height:15px" id="req_#requisitionno#">		    	
			<td align="center" style="padding-left:4px;min-width:30;padding-top:3px"><cf_img icon="edit" navigation="Yes" onclick="ProcReqEdit('#requisitionno#','budget','#url.box#')"></td>			
			<td style="min-width:90">#Reference# (#RequisitionNo#)</td>
			<td align="center" style="min-width:90">#dateformat(RequestDate,client.dateformatshow)#</td>
			<td style="padding-left:8px;width:100%">#itemmaster# #RequestDescription#</td>	
			<td style="min-width:10"></td>
			
			
				<cfquery name="status" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT * 
					FROM Status 
					WHERE StatusClass = 'Requisition' 
					AND   Status      = '#ActionStatus#'
				</cfquery>		
				
			
			<td style="min-width:120" style="padding-left:2px">#OfficerLastName#</td>				
			<td style="min-width:150;">#actionstatus# #status.Description# </td>	
			<td style="min-width:120;padding-right:3px" align="right">
			
			<!--- we show in the currency of the budget allotment --->
			
			<cfif RequestCurrency eq Param.BudgetCurrency>		
				
				#numberformat(RequestCurrencyPrice*RequestQuantity,",")#
				
			<cfelse>
			
				<cf_exchangeRate CurrencyFrom="#application.BaseCurrency#" CurrencyTo = "#Param.BudgetCurrency#">
			
				<cfif exc neq "0">
				<cfoutput>#numberFormat(RequestAmountBase/exc,",")#</cfoutput>
				</cfif>
			
			</cfif>
			
			</td>	
					
		</tr>
	
	</cfoutput>
	
	</table>
	
	<cfset ajaxonload("doHighlight")>