
<cfquery name="Line" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  * 
	FROM    RequisitionLine 
	WHERE   RequisitionNo = '#URL.ID#'
</cfquery>	

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_ParameterMission
	WHERE  Mission = '#Line.Mission#' 
</cfquery>

<cfoutput>

<cfparam name="url.id">
<cfparam name="url.quantity">
<cfparam name="url.price">
<cfparam name="url.currency">

<cfset price    = replace(url.price,",","","ALL")> 
<cfset quantity = replace(url.quantity,",","","ALL")> 

<cfif Parameter.EnableCurrency eq "0">
	
	<cftry>
					
		<cfquery name="Prior" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			   SELECT  * 
			   FROM    RequisitionLine 
			   WHERE   RequisitionNo = '#URL.ID#'
		</cfquery>		
					
		<cfquery name="Update" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			   UPDATE RequisitionLine 
			   SET    RequestCurrency       = '#APPLICATION.BaseCurrency#',
					  RequestCurrencyPrice  = '#Price#',				   
			   		  RequestQuantity       = '#quantity#', 
				      RequestCostprice      = '#Price#',
				      RequestAmountBase     = '#quantity*Price#'	
			   WHERE  RequisitionNo         = '#URL.ID#'
		</cfquery>	
		
		<cfquery name="Line" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			   SELECT * FROM RequisitionLine 
			   WHERE  RequisitionNo = '#URL.ID#'
		</cfquery>	
								   
		<font size="3">#numberFormat(Line.RequestAmountBase,"_,__.__")#</font>
				
		<cfif Prior.RequestAmountBase neq Line.RequestAmountBase>
		
			<!--- capture the change --->		
			
			<cf_assignId>
					
			<cfsavecontent variable="content">
			    <cfinclude template="RequisitionEditLog.cfm">							
			</cfsavecontent>
				
			<cfquery name="InsertAction" 
				     datasource="AppsPurchase" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     INSERT  INTO RequisitionLineAction 
						 (RequisitionNo, 
						  ActionId,
						  ActionStatus, 
						  ActionDate, 
						  ActionMemo,
						  ActionContent,
						  OfficerUserId, 
						  OfficerLastName, 
						  OfficerFirstName) 
				     VALUES
					     ('#URL.ID#', 
					      '#rowguid#',						 
						  '#Line.ActionStatus#',						
						   getdate(), 
						   'Update Amount to #numberFormat(Line.RequestAmountBase,"_,__.__")#',
						   '#Content#',
						   '#SESSION.acc#', 
						   '#SESSION.last#', 
						   '#SESSION.first#')
			</cfquery>
		
		</cfif>
		
		<input type="hidden" name="requestcostprice" id="requestcostprice" value="#Line.RequestCostPrice#"> 
		<input type="hidden" name="requesttotal"     id="requesttotal"     value="#Line.RequestAmountBase#"> 
		
		<script>			   
		  tagging('#Line.RequestAmountBase#')
		</script>
									
		<cfcatch>				
			<font color="FF0000"><cf_tl id="Incorrect">&nbsp;price&nbsp;(#price#)&nbsp;or&nbsp;<cf_tl id="quantity">&nbsp;(#quantity#)</font> 
		</cfcatch>
			
	</cftry>		

<cfelse>
	
	<cftry>
	
		<cfquery name="Prior" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			   SELECT  * 
			   FROM    RequisitionLine 
			   WHERE   RequisitionNo = '#URL.ID#'
		</cfquery>		
	
		<cfquery name="Exc"
		    datasource="AppsLedger" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    SELECT   TOP 1 * FROM CurrencyExchange
		    WHERE    Currency = '#url.currency#'
			AND      EffectiveDate <= getDate()
			ORDER BY EffectiveDate DESC
		</cfquery>	 
				
		<cfif Exc.recordcount eq "0">
			<cfset pricebase = numberformat(price,".___")>			
		<cfelse>
			<cfset pricebase = round((price/Exc.ExchangeRate)*10000)/10000>			
		</cfif>		
				
		<cfquery name="Update" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			   UPDATE RequisitionLine 
			   SET    RequestQuantity       = '#quantity#', 
			   		  RequestCurrency       = '#url.currency#',
					  RequestCurrencyPrice  = '#Price#',	
				      RequestCostprice      = '#pricebase#',
				      RequestAmountBase     = '#quantity*pricebase#'	
			   WHERE  RequisitionNo         = '#URL.ID#'
		</cfquery>	
		
		<cfquery name="Line" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			   SELECT  * 
			   FROM    RequisitionLine 
			   WHERE   RequisitionNo = '#URL.ID#'
		</cfquery>	
		
		<input type="hidden" name="requestcostprice" id="requestcostprice" value="#Line.RequestCurrencyPrice#"> 
		<input type="hidden" name="requesttotal"     id="requesttotal"     value="#Line.RequestAmountBase#"> 
		
		<script>
		  tagging('#Line.RequestAmountBase#')
		  funding()
		</script>
		
		<table cellspacing="0" cellpadding="0">
		  
		    <tr>
			
				<td align="right" class="labellarge" bgcolor="ffffaf" style="padding-left:25px;padding-right:5px;border:1px solid silver;">														   
				#numberFormat(Line.RequestAmountBase,",.__")#</font> 				
				</td>		
				<cfif Line.RequestCurrency neq APPLICATION.BaseCurrency> 	
					<td align="right" class="labellarge" bgcolor="f4f4f4" style="padding-left:15px;padding-right:5px;border:1px solid silver;">
					<font size="1">#url.currency#</font> #numberformat(Price*quantity,"_,__.__")#		
					</td>	
				</cfif>		
					 
	 		</tr>
		 
		</table>		
		
				
		<cfif Prior.RequestAmountBase neq Line.RequestAmountBase>
				
			<!--- capture the change --->		
						
			<cf_assignId>
					
			<cfsavecontent variable="content">
			    <cfinclude template="RequisitionEditLog.cfm">							
			</cfsavecontent>
				
			<cfquery name="InsertAction" 
				     datasource="AppsPurchase" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     INSERT  INTO RequisitionLineAction 
						 (RequisitionNo, 
						  ActionId,
						  ActionStatus, 
						  ActionDate, 
						  ActionMemo,
						  ActionContent,
						  OfficerUserId, 
						  OfficerLastName, 
						  OfficerFirstName) 
				     VALUES
					     ('#URL.ID#', 
					      '#rowguid#',						 
						  '#Line.ActionStatus#',						
						   getdate(), 
						   'Update Amount to #numberFormat(Line.RequestAmountBase,"_,__.__")#',
						   '#Content#',
						   '#SESSION.acc#', 
						   '#SESSION.last#', 
						   '#SESSION.first#')
			</cfquery>
		
		</cfif>
					
		<cfcatch>
								
		  <table>
		  <tr><td class="labelit">							
		   <font color="FF0000"><cf_tl id="Incorrect price"> (#price#) <cf_tl id="or"> <cf_tl id="quantity"> (#quantity#)</font>
		     </td>
		  </tr>
		  </table>
		
		</cfcatch>
			
	</cftry>		

</cfif>

<cfif Prior.RequestAmountBase lte Line.RequestAmountBase>

	<input type="hidden" name="AmountHasChanged" id="AmountHasChanged" value="1"> 
	
<cfelse>

	<input type="hidden" name="AmountHasChanged" id="AmountHasChanged" value="0"> 	

</cfif>

</cfoutput>
