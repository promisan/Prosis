
<cfparam name="url.systemfunctionid" default="">
<cfparam name="url.missionorgunitid"  default="">
<cfparam name="url.mission"          default="">
<cfparam name="url.warehouse"         default="">


<!--- define access --->

<cfif url.systemfunctionid eq "">
		
	<cfset access = "GRANTED">
	
<cfelse>
	
		<cfinvoke component   = "Service.Access"  
		   method             = "RoleAccess" 
		   Role               = "'WorkOrderProcessor'"
		   Parameter          = "#url.systemfunctionid#"
		   Mission            = "#url.mission#"  	 
		   MissionOrgUnitId   = "#url.missionorgunitid#"  
		   AccessLevel        = "'2'"
		   returnvariable     = "Access">	
		  		
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
	                        ( SELECT DISTINCT DocumentCurrency
	          				  FROM   TransactionHeader AS H
	                          WHERE  TransactionSourceId IN
	                                  (SELECT   WorkOrderLineId
	                                   FROM     WorkOrder.dbo.WorkOrderLine WL, WorkOrder.dbo.WorkOrder W
									   WHERE    WL.WorkOrderId   = W.WorkOrderId									   
									   <cfif url.missionorgunitid neq "">
                                       AND      WL.OrgUnitImplementer IN (SELECT OrgUnit 
												                          FROM   Organization.dbo.Organization 
																		  WHERE  Mission          = '#url.mission#' 
																		  AND    MissionOrgUnitId = '#url.missionorgunitid#') 
									   <cfelse>
									   AND      W.Mission = '#url.mission#' 
									   </cfif>
									   AND      WL.WorkOrderLineId = H.TransactionSourceId
									)
								 )
			 AND Currency <> '#application.basecurrency#'		 
		</cfquery>					
		
		<cfset linksave = "#session.root#/Tools/Listing/Pane/setSelection.cfm?systemfunctionid=#url.systemfunctionid#&passtru=../../../WorkOrder/Application/Settlement/Inquiry/DayTotalBaseContent.cfm">
		
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
				
		<cfif url.missionorgunitid neq "">
			
			<cfset linksave  = "#linksave#&conditionfield=implementer&conditionvalue=#url.missionorgunitid#">			
			<cfset field     = "implementer">	
			<cfset condition = url.missionorgunitid> 	
			
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
				  ConditionValueAttribute2)
				VALUES
				('#url.systemfunctionid#', '#SESSION.acc#','implementer', '#url.missionorgunitid#','#application.basecurrency#','current')
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
				  ConditionValueAttribute2)
				VALUES
				('#url.systemfunctionid#', '#SESSION.acc#','mission', '#url.mission#','#application.basecurrency#','current')
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
					<td style="padding-left:0px"><input type="radio" onclick="ptoken.navigate('#linksave#&conditionvalueattribute1=#application.basecurrency#&conditionvalueattribute2='+$('input[name=mode_#condition#]:checked').val(),'salecontent_#condition#')" class="radiol" name="currency_#condition#" id="currency_#condition#" value="#application.basecurrency#" <cfif getCondition.ConditionValueAttribute1 eq application.basecurrency>checked</cfif>></td>
					<td class="labelmedium" style="padding-left:7px">#application.basecurrency#</td>		
				</cfoutput>
				<cfoutput query="Currency">
					<td style="padding-left:9px"><input type="radio" onclick="ptoken.navigate('#linksave#&conditionvalueattribute1=#currency#&conditionvalueattribute2='+$('input[name=mode_#condition#]:checked').val(),'salecontent_#condition#')" class="radiol" name="currency_#condition#"  id="currency_#condition#" value="#currency#" <cfif getCondition.ConditionValueAttribute1 eq currency>checked</cfif>></td>
					<td class="labelmedium" style="padding-left:7px">#currency# [#exchangerate#]</td>																
				</cfoutput>
				</tr>
			</table> 	
		
		</cfif>						 			 
	 
	 </td>
	 
	 <cfoutput>
	 
	 <td align="right">
	 
      	 <table cellspacing="0" cellpadding="0">
      	 	     	 	
				<tr>
				
					<cfif access eq "GRANTED">
				
					<td><input type="radio" onclick="ptoken.navigate('#linksave#&conditionvalueattribute1='+$('input[name=currency_#condition#]:checked').val()+'&conditionvalueattribute2=closing','salecontent_#condition#');" class="radiol" name="mode_#condition#" id="mode_#condition#" value="Closing" <cfif getCondition.ConditionValueAttribute2 eq "closing">checked</cfif>></td>
					<td class="labelmedium" style="padding-left:4px;padding-right:10px"><cf_tl id="Closing"></td>	
					
					<td><input type="radio" onclick="ptoken.navigate('#linksave#&conditionvalueattribute1='+$('input[name=currency_#condition#]:checked').val()+'&conditionvalueattribute2=current','salecontent_#condition#');" class="radiol" name="mode_#condition#" id="mode_#condition#" value="Current" <cfif getCondition.ConditionValueAttribute2 eq "current" or getCondition.ConditionValueAttribute2 eq "">checked</cfif>></td>
					<td class="labelmedium" style="padding-left:4px;padding-right:10px"><cf_tl id="This month"></td>							
				
					<td><input type="radio" onclick="ptoken.navigate('#linksave#&conditionvalueattribute1='+$('input[name=currency_#condition#]:checked').val()+'&conditionvalueattribute2=historic','salecontent_#condition#');" class="radiol" name="mode_#condition#" id="mode_#condition#" value="Historic" <cfif getCondition.ConditionValueAttribute2 eq "historic">checked</cfif>></td>
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
							AND      ConditionField = 'implementer' 
							AND      ConditionValue = '#url.warehouse#'
							<cfelse>
							AND      ConditionField = 'mission' 
							AND      ConditionValue = '#url.mission#'
							</cfif>
					</cfquery>		
																			
					<td style="padding-left:0px"><input type="radio" onclick="ptoken.navigate('#linksave#&conditionvalueattribute1='+$('input[name=currency_#condition#]:checked').val()+'&conditionvalueattribute2=closing','salecontent_#condition#');" class="radiol" name="mode_#condition#" id="mode_#condition#" value="Closing" checked></td>
					<td class="labelmedium" style="padding-left:4px;padding-right:15px"><cf_tl id="Closing view"></td>																
					
					</cfif>
				
				</tr>
			</table> 	
	 	 
	 </td>
	 
	 </cfoutput>
</tr>
			
<tr>
	<td colspan="2" valign="top" height="100%" style="padding:5px">		
	
		<cfoutput>
		
		    <cfset init = "#session.root#/WorkOrder/Application/Settlement/Inquiry/DayTotalBaseContent.cfm?systemfunctionid=#url.systemfunctionid#">
		
			<cfif url.missionorgunitid neq "">			
				<cfdiv bind="url:#init#&conditionfield=implementer&conditionvalue=#url.missionorgunitid#" id="salecontent_#url.missionorgunitid#">							
			<cfelse>			
				<cfdiv bind="url:#init#&conditionfield=mission&conditionvalue=#url.mission#" id="salecontent_#url.mission#">										
			</cfif>
				
		</cfoutput>
			
	</td>
</tr>
			
</table>

<cfset ajaxonload("doHighlight")>
