
<input type="hidden" id="fileno" name="fileno" value="<cfoutput>#fileNo#</cfoutput>">

<cftry>
	
	<!--- horizontal cols --->
	<cfquery name="check"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   TOP 1 * 
		FROM     #SESSION.acc#PL#FileNo#	
	</cfquery>
		
<cfcatch>

	<cfabort>

	<cfinclude template="PLQuery.cfm">

</cfcatch>

</cftry>


<!--- horizontal cols --->
<cfquery name="Category"
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Accounting.dbo.Ref_GLCategory
	ORDER BY ListingOrder
</cfquery>

<cfparam name="Form.History"           default="TransactionPeriod">
<cfparam name="Form.TransactionPeriod" default="">
<cfparam name="Form.OrgUnitOwner"      default="">
<cfparam name="Form.ShowCenter"        default="No">
<cfparam name="Form.Currency"          default="#Application.BaseCurrency#">

<cfset client.statementper = url.period>
<cfset client.statementrep = "pl">

<cfif form.layout eq "vertical">
	  <cfset showperiod = "1">
<cfelse>
      <cfset showperiod = "0">
 </cfif>
 
<cfquery name="Parameter"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_ParameterMission
	WHERE Mission = '#URL.Mission#' 
</cfquery>

<cfif Form.History eq "accountperiod">

	<cfquery name="Period"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    DISTINCT AccountPeriod as Period
		FROM      #SESSION.acc#PL#FileNo#	
		ORDER BY  AccountPeriod
	</cfquery>
	
	<cfif period.recordcount eq "1">
		<cfset showperiod = "0">
	</cfif>
	
<cfelse>
	
	<cfquery name="Period"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    DISTINCT TransactionPeriod as Period
		FROM      #SESSION.acc#PL#fileno#	
		ORDER BY  TransactionPeriod
	</cfquery>
		
</cfif>
	
<cfset ct = "">
<cfloop query="Period">
    <cfif ct eq "">
	    <cfset ct = "#Period#">
	<cfelse>
		<cfset ct = "#ct#,#Period#">
	</cfif>
</cfloop>

<table width="96%" align="center" class="formspacing">

<tr class="line"> 
	<td>
		<cfoutput>
			<table width="100%">
			<tr>
				<td style="padding-left:20px;font-size:27px;height:58px" id="alertme">
				<b>#url.mission#</b> <cf_tl id="Income Statement">
				</td>
				<td align="right" class="clsNoPrint">
					<cf_tl id="Financial Statement" var="1">
					<cfset vTP = trim(replace(replace(form.transactionPeriod,",",", ","ALL"),"'","","ALL"))>
					<cfif vTP neq "">
						<cfset vTP = trim(mid(vTP,1,len(vTP)))>
					</cfif>
					<span id="printTitle" style="display:none;">#UCASE("#lt_text# #url.mission# - #url.period# - #vTP# - #Application.BaseCurrency#")#</span>
					<cf_tl id="Print" var="1">
					<cf_button2 
						mode		= "icon"
						type		= "Print"
						title       = "#lt_text#" 
						id          = "Print"					
						height		= "32px"
						width		= "32px"
						printTitle	= "##printTitle"
						printContent = "##mainbox">
				</td>

				<cf_tl id="Export to Excel" var="1">
				<td style="padding-left:10px;" class="clsNoPrint">
					<img src="#session.root#/images/Excel.png" style="cursor:pointer;" width="32" height="32" onclick="Prosis.exportToExcel('plTable');" title="#lt_text#">
				</td>
			</tr>
			</table>
		</cfoutput>
	</td>
</tr>

<cfset cur = form.Currency>

<cfquery name="getExchange"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">							 
	SELECT   *
	FROM      Currency
	WHERE     Currency = '#cur#'								
</cfquery>	

<cfif form.currency neq application.basecurrency>
	
	<cfoutput>
	<tr><td class="labelmedium2" style="padding:10px"><font size="6"><b>Attention:</b></font> PL Transactions that were NOT recorded in <b>#form.currency#</b> are presented using the #Application.BaseCurrency# value defined at the moment of posting and expressed in #form.currency# using exchange rate of <b>#getExchange.ExchangeRate#</b>.</td></tr>
	</cfoutput>

</cfif>

<tr><td colspan="3" class="labelmedium2" style="padding-left:10px;height:20px">
<cfdiv bind="url:StatementCheck.cfm?mission=#url.mission#&period=#url.period#">
</td></tr>

<tr><td colspan="3" style="padding-left:20px;padding-top:2px;padding-right:20px">

	<table id="plTable" width="100%" align="center" class="formspacing navigation_table">
	
	  <!---
	  <cfif form.layout eq "horizontal">
	   	 			  	
	  <tr>
	    <td width="50%" class="labellarge" style="height:40px;padding-bottom:8px;padding-top:5px;font-size:26px">
		   <cf_tl id="Gross Margin"> 
		</td>		
	    <td width="50%" height="20" class="labellarge" style="font-size:26px"><cf_tl id="Operating costs"></td>
	  </tr>	 
	  
	  </cfif>
	  --->
	 
	  <tr class="fixlengthlist">
	  
	    <td width="50%" valign="top">
						
		    <table width="100%" class="navigation_table">
			
				<cfif Period.recordcount gte "1">	
								
				<tr class="fixlengthlist labelmedium2">
				  				  
				  <td colspan="2" style="width:100%"></td>
				  
				  <cfif showperiod eq "1">
					  <cfoutput query="Period">
					  <td style="font-size:13px;border-radius:4px;border:1px solid silver;min-width:70px;width:75px" align="center">#Period#</td>
					  </cfoutput>
				  </cfif>
				  <td style="min-width:90px;width:100px;max-width:100px;border:1px solid silver" align="center"><cf_tl id="Total"></td>					   
				 
				</tr>
				</cfif>			
												
				<cf_PLViewData panel="credit" 
					    history="#form.history#" 
					    aggregation="#form.aggregation#" 
						showcenter="#form.showcenter#"
						fileno="#fileno#" 
						showperiod="#showperiod#"  
						periodlist="#ct#">
				
		    </table>
				
	    </td>
		
		<cfif form.layout eq "vertical">
		
		</tr>
						
		<tr class="fixlengthlist">
			
		</cfif>
		
	    <td width="50%" valign="top">
		
	      <table width="100%" class="formpadding navigation_table">
		  			  
			  <cfif Period.recordcount gte "1">	
				
				<tr class="fixlengthlist labelmedium2">				 
				  <td colspan="2" style="width:100%"></td>		  
				  <cfif showperiod eq "1">
					  <cfoutput query="Period">
					     <td style="font-size:13px;border-radius:4px;border:1px solid silver;min-width:70px;width:75px" align="center">#Period#</td>
					  </cfoutput>
				  </cfif>				  
				  <td style="min-width:90px;width:100px;max-width:100px;border:1px solid silver" align="center"><cf_tl id="Total"></td>					   				 
				</tr>
				
			  </cfif>	
			  	  
								
			  <cf_PLViewData panel="debit" 
		            history="#form.history#" 
					aggregation="#form.aggregation#" 
					showcenter="#form.showcenter#"
					fileno="#fileno#" 
					showperiod="#showperiod#" 
					periodlist="#ct#"> 					  
							  					    
	      </table>
	    </td>
	  </tr>
	  	  
	    <cfquery name="Data"
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  SUM(Debit) as DebitTotal, 
				        SUM(Credit) as CreditTotal
				FROM    #SESSION.acc#PL#FileNo#				
		  </cfquery>		
		  
		  <cfif data.debittotal gt data.credittotal>
		  	<cfset tot = data.debitTotal>
		  <cfelse>
		  	<cfset tot = data.creditTotal>
		  </cfif>			  	  
	  	  	  	  	  
	  <cfif form.layout eq "horizontal">
	  
	  	<cfoutput>
	  
		  <tr class="fixlengthlist">
		   
		    <td width="50%" align="right" valign="bottom" class="labellarge" style="border-top:1px solid silver;height:30px">				
			#NumberFormat(tot,',____')#				
			</td>
			
			<td width="50%" align="right" valign="bottom" style="border-top:1px solid silver;height:30px" class="labellarge">		
			#NumberFormat(tot,',____')#				
			</td>		
		  </tr>  
		  
		 </cfoutput> 
	  	  
	  </cfif>
	  	   
	</table>

</td> </tr>

</table>

<cfset AjaxOnLoad("doHighlight")>

<script>
	Prosis.busy('no')
</script>	

