
<cfparam name="url.systemfunctionid" default="">
<cfparam name="url.warehouse"        default="">
<cfparam name="url.mission"          default="">

<cfquery name="get"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Warehouse
	WHERE   Warehouse= '#url.warehouse#'			
</cfquery>

<cfif url.mission eq "">
	<cfset mis = get.mission>	
<cfelse>
	<cfset mis = url.mission>		
</cfif>

<!--- define access --->
	
<cfif url.systemfunctionid eq "">
		
	<cfset access = "GRANTED">
	
<cfelse>
	
	<cfinvoke component   = "Service.Access"  
		   method         = "RoleAccess" 
		   Role           = "'WhsPick'"
		   Parameter      = "#url.systemfunctionid#"
		   Mission        = "#get.mission#"  	 
		   Warehouse      = "#url.Warehouse#"  
		   AccessLevel    = "'2'"
		   returnvariable = "Access">	
		  		
</cfif>	

<table width="100%" border="0" cellspacing="0" cellpadding="0">

<tr>
	 
	 <td style="padding-left:5px">
	 
	 	<cfquery name="currency"
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">							 
			SELECT    Currency, ExchangeRate, ExchangeRateModified
			FROM      Currency
			WHERE     Currency IN
	                        (SELECT DISTINCT DocumentCurrency
	          				            FROM       TransactionHeader AS H
	                          WHERE      TransactionSourceId IN
	                                                 (SELECT    BatchId
	                                                   FROM     Materials.dbo.WarehouseBatch
													   <cfif url.warehouse neq "">
	                                                   WHERE    Warehouse = '#url.warehouse#' 
													   <cfelse>
													   WHERE    Mission = '#url.mission#' 
													   </cfif>
									 AND      BatchId   = H.TransactionSourceId
									)
								 )
			 AND Currency <> '#application.basecurrency#'		 
		</cfquery>					
		
		<cfset linksave = "#session.root#/Tools/Listing/Pane/setSelection.cfm?systemfunctionid=#url.systemfunctionid#&mission=#mis#&passtru=../../../Warehouse/Application/SalesOrder/POS/Inquiry/DayTotalBaseContent.cfm">
		
		<cftry>
		<cfquery name="Insert" 
			    datasource="AppsSystem" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
			    INSERT INTO UserModule
				 (SystemFunctionId,
				  Account)
				VALUES
				('#url.systemfunctionid#', '#SESSION.acc#')
			  </cfquery>
		<cfcatch></cfcatch>	  
		</cftry>
				
				
		<cfif url.warehouse neq "">
			
			<cfset linksave = "#linksave#&conditionfield=warehouse&conditionvalue=#url.warehouse#">			
			<cfset field      = "warehouse">	
			<cfset condition = url.warehouse> 	
			
			<cftry>	
					  		   
			  <cfquery name="Insert" 
			    datasource="AppsSystem" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
			    INSERT INTO UserModuleCondition
				 (SystemFunctionId,
				  Account,
				  ConditionField, 
				  ConditionValue,
				  ConditionValueAttribute1,
				  ConditionValueAttribute2,
				  ConditionValueAttribute3)
				VALUES
				('#url.systemfunctionid#', '#SESSION.acc#','warehouse', '#url.warehouse#','#application.basecurrency#','current','sale')
			  </cfquery>
		 
		  	  <cfcatch></cfcatch>
		  
		    </cftry>		
									
		<cfelse>
		
			 <cftry>
		  		   
			  <cfquery name="Insert" 
			    datasource="AppsSystem" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
			    INSERT INTO UserModuleCondition
				 (SystemFunctionId,
				  Account,
				  ConditionField, 
				  ConditionValue,
				  ConditionValueAttribute1,
				  ConditionValueAttribute2,
				  ConditionValueAttribute3)
				VALUES
				('#url.systemfunctionid#', '#SESSION.acc#','mission', '#url.mission#','#application.basecurrency#','current','sale')
			  </cfquery>
		 
		  	  <cfcatch></cfcatch>
		  
		    </cftry>	
		
			<cfset linksave = "#linksave#&conditionfield=mission&conditionvalue=#url.mission#">
			<cfset field      = "mission">	
			<cfset condition = url.mission> 
							 
		</cfif>
		
						
		<cfquery name="getCondition" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  *
				FROM    UserModuleCondition C
				WHERE   C.Account        = '#SESSION.acc#'
				AND     C.SystemFunctionId = '#url.SystemFunctionId#'  	
				AND     C.ConditionField = '#field#' 
				AND     ConditionValue   = '#condition#'
		</cfquery>		
		
		<cfif currency.recordcount gte "1">		
 
			<table cellspacing="0" cellpadding="0">
				<tr class="labelmedium">
				<cfoutput>
					<td style="padding-left:0px"><input type="radio" onclick="ptoken.navigate('#linksave#&conditionvalueattribute1=#application.basecurrency#&conditionvalueattribute2='+$('input[name=mode_#condition#]:checked').val()+'&conditionvalueattribute3='+$('input[name=date_#condition#]:checked').val(),'salecontent_#condition#')" class="radiol" name="currency_#condition#" id="currency_#condition#" value="#application.basecurrency#" <cfif getCondition.ConditionValueAttribute1 eq application.basecurrency>checked</cfif>></td>
					<td class="labelmedium" style="padding-left:7px">#application.basecurrency#</td>		
				</cfoutput>
				<cfoutput query="Currency">
					<td style="padding-left:9px"><input type="radio" onclick="ptoken.navigate('#linksave#&conditionvalueattribute1=#currency#&conditionvalueattribute2='+$('input[name=mode_#condition#]:checked').val()+'&conditionvalueattribute3='+$('input[name=date_#condition#]:checked').val(),'salecontent_#condition#')" class="radiol" name="currency_#condition#"  id="currency_#condition#" value="#currency#" <cfif getCondition.ConditionValueAttribute1 eq currency>checked</cfif>></td>
					<td class="labelmedium" style="padding-left:7px">#currency# [#exchangerate#]</td>																
				</cfoutput>
				</tr>
			</table> 	
		
		</cfif>						 			 
	 
	 </td>
	 
	 <td>
	 
	       <table cellspacing="0" cellpadding="0">
				<tr class="labelmedium">
				<cfoutput>
					<td style="padding-left:0px">
					<input type="radio" onclick="ptoken.navigate('#linksave#&conditionvalueattribute1='+$('input[name=currency_#condition#]:checked').val()+'&conditionvalueattribute2='+$('input[name=mode_#condition#]:checked').val()+'&conditionvalueattribute3=sale','salecontent_#condition#')" class="radiol" name="date_#condition#" id="date_#condition#" value="Sale" <cfif getCondition.ConditionValueAttribute3 eq "Sale">checked</cfif>></td>
					<td class="labelmedium" style="padding-left:7px"><cf_tl id="Transaction date"></td>		
				</cfoutput>
				<cfoutput>
					<td style="padding-left:0px">
					<input type="radio" onclick="ptoken.navigate('#linksave#&conditionvalueattribute1='+$('input[name=currency_#condition#]:checked').val()+'&conditionvalueattribute2='+$('input[name=mode_#condition#]:checked').val()+'&conditionvalueattribute3=recorded','salecontent_#condition#')" class="radiol" name="date_#condition#" id="date_#condition#" value="Recorded" <cfif getCondition.ConditionValueAttribute3 eq "Recorded">checked</cfif>></td>
					<td class="labelmedium" style="padding-left:7px"><cf_tl id="Document date"></td>		
				</cfoutput>
				
				</tr>
			</table> 	
	 
	 </td>
	 
	 <cfoutput>
	 
	 <td align="right">
	 
      	 <table cellspacing="0" cellpadding="0">
      	 	     	 	
				<tr>
				
					<cfif access eq "GRANTED">
				
					<td><input type="radio" onclick="ptoken.navigate('#linksave#&conditionvalueattribute1='+$('input[name=currency_#condition#]:checked').val()+'&conditionvalueattribute2=closing&conditionvalueattribute3='+$('input[name=date_#condition#]:checked').val(),'salecontent_#condition#');" class="radiol" name="mode_#condition#" id="mode_#condition#" value="Closing" <cfif getCondition.ConditionValueAttribute2 eq "closing">checked</cfif>></td>
					<td class="labelmedium" style="padding-left:4px;padding-right:10px"><cf_tl id="Closing"></td>	
					
					<td><input type="radio" onclick="ptoken.navigate('#linksave#&conditionvalueattribute1='+$('input[name=currency_#condition#]:checked').val()+'&conditionvalueattribute2=current&conditionvalueattribute3='+$('input[name=date_#condition#]:checked').val(),'salecontent_#condition#');" class="radiol" name="mode_#condition#" id="mode_#condition#" value="Current" <cfif getCondition.ConditionValueAttribute2 eq "current" or getCondition.ConditionValueAttribute2 eq "">checked</cfif>></td>
					<td class="labelmedium" style="padding-left:4px;padding-right:10px"><cf_tl id="This month"></td>							
				
					<td><input type="radio" onclick="ptoken.navigate('#linksave#&conditionvalueattribute1='+$('input[name=currency_#condition#]:checked').val()+'&conditionvalueattribute2=historic&conditionvalueattribute3='+$('input[name=date_#condition#]:checked').val(),'salecontent_#condition#');" class="radiol" name="mode_#condition#" id="mode_#condition#" value="Historic" <cfif getCondition.ConditionValueAttribute2 eq "historic">checked</cfif>></td>
					<td class="labelmedium" style="padding-left:4px;padding-right:4"><cf_tl id="Last 2 years"></td>	
					
					<cfelse>									
										
					<cfquery name="setCondition" 
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							UPDATE   UserModuleCondition 
							SET      ConditionValueAttribute2 = 'closing' 
							WHERE    Account   = '#SESSION.acc#'
							AND      SystemFunctionId = '#url.SystemFunctionId#'  	
							
							<cfif url.warehouse neq "">		
							AND      ConditionField = 'warehouse' 
							AND      ConditionValue = '#url.warehouse#'
							<cfelse>
							AND      ConditionField = 'mission' 
							AND      ConditionValue = '#url.mission#'
							</cfif>
					</cfquery>		
																			
					<td style="padding-left:0px"><input type="radio" onclick="ptoken.navigate('#linksave#&conditionvalueattribute1='+$('input[name=currency_#condition#]:checked').val()+'&conditionvalueattribute2=closing&conditionvalueattribute3='+$('input[name=date_#condition#]:checked').val(),'salecontent_#condition#');" class="radiol" name="mode_#condition#" id="mode_#condition#" value="Closing" checked></td>
					<td class="labelmedium" style="padding-left:4px;padding-right:15px"><cf_tl id="Closing view"></td>																
					
					</cfif>
				
				</tr>
			</table> 	
	 	 
	 </td>
	 
	 </cfoutput>
</tr>
			
<tr>
	<td colspan="3" valign="top" height="100%" style="padding:5px">		
	
		<cfoutput>
								
		    <cfset init = "#session.root#/Warehouse/Application/SalesOrder/POS/Inquiry/DayTotalBaseContent.cfm?systemfunctionid=#url.systemfunctionid#&mission=#mis#">
		
			<cfif url.warehouse neq "">			
				<cfdiv bind="url:#init#&conditionfield=warehouse&conditionvalue=#url.warehouse#&ts=1" id="salecontent_#url.warehouse#">							
			<cfelse>						
				<cfdiv bind="url:#init#&conditionfield=mission&conditionvalue=#url.mission#&ts=1" id="salecontent_#url.mission#">										
			</cfif>
				
		</cfoutput>
	
	</td>
</tr>
			
</table>

<cfset ajaxonload("doHighlight")>
