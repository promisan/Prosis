
<input type="hidden" id="fileno" name="fileno" value="<cfoutput>#fileNo#</cfoutput>">

<cftry>
	
	<!--- horizontal cols --->
	<cfquery name="check"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   TOP 1 * 
		FROM     #SESSION.acc#Fund#FileNo#	
	</cfquery>
		
<cfcatch>

	<cfabort>

	<cfinclude template="FundQuery.cfm">

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
		FROM      #SESSION.acc#Fund#FileNo#	
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
		FROM      #SESSION.acc#Fund#fileno#	
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

<cfquery name="Check"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT       TOP 100 PERCENT Line.Journal, 
	             Line.JournalSerialNo, 
				 ROUND(SUM(Line.AmountBaseDebit), 2) AS Debit, 
				 ROUND(SUM(Line.AmountBaseCredit), 2) AS Credit, 
	             HDR.Mission, HDR.Description, HDR.TransactionSource, HDR.Reference, HDR.ReferenceName, HDR.AccountPeriod, HDR.TransactionDate, HDR.JournalBatchDate, 
	             HDR.DocumentDate, HDR.ReferenceNo, HDR.ReferenceId, HDR.Created, HDR.DocumentCurrency, HDR.DocumentAmount
				 
	FROM         TransactionLine Line INNER JOIN
	             TransactionHeader HDR ON Line.Journal = HDR.Journal AND Line.JournalSerialNo = HDR.JournalSerialNo
	WHERE        HDR.Mission       = '#url.mission#'
	AND          HDR.AccountPeriod = '#url.period#'
			   
	GROUP BY     Line.Journal, 
	             Line.JournalSerialNo, 
			     HDR.Mission, 
			     HDR.Description, 
				 HDR.AccountPeriod, 
				 HDR.JournalBatchDate, 
				 HDR.DocumentDate, 
				 HDR.ReferenceNo, 
		         HDR.ReferenceId, 
				 HDR.Created, 
				 HDR.TransactionDate, 
				 HDR.TransactionSource, 
				 HDR.Reference, 
				 HDR.ReferenceName, 
				 HDR.DocumentCurrency, 
		         HDR.DocumentAmount
				 
	HAVING       (ABS(ROUND(SUM(Line.AmountBaseDebit) - SUM(Line.AmountBaseCredit), 2)) > 0.5)
	
	ORDER BY HDR.TransactionDate DESC, HDR.Created DESC
</cfquery>

<table width="96%" align="center" border="0" cellspacing="0" cellpadding="0" class="formspacing">


<tr class="line"> 
	<td>
		<cfoutput>
			<table width="100%">
			<tr>
				<td style="padding-left:20px;font-size:27px;height:58px" id="alertme">
				<b>#url.mission#</b> <cf_tl id="Cash flow Statement">
				</td>
				<td align="right" class="clsNoPrint" style="padding-top:5px">
					<cf_tl id="Cash flow Statement" var="1">
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
						height		= "40px"
						width		= "45px"
						printTitle	= "##printTitle"
						printContent = "##mainbox">
				</td>

				<cf_tl id="Export to Excel" var="1">
				<td style="padding-left:10px;" class="clsNoPrint">
					<img src="#session.root#/images/Excel.png" style="cursor:pointer; margin-top:7px;" width="32" height="32" onclick="Prosis.exportToExcel('plTable');" title="#lt_text#">
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
	<tr><td class="labelmedium" style="padding:10px"><font size="6"><b>Attention:</b></font> PL Transactions that were NOT recorded in <b>#form.currency#</b> are presented using the #Application.BaseCurrency# value defined at the moment of posting and expressed in #form.currency# using exchange rate of <b>#getExchange.ExchangeRate#</b>.</td></tr>
	</cfoutput>

</cfif>

<cfif check.recordcount gte "3">
	<tr>
	  <td colspan="3" style="height:30px" class="labelmedium" align="center">
	  <font color="red">	 
	  <cfif check.recordcount eq "1">
	  <cf_tl id="There is #check.recordcount# ledger posting which is not in balance. Contact your administrator">	
	  <cfelse>
	  <cf_tl id="There are #check.recordcount# ledger postings that are not in balance. Contact your administrator">	 
	  </cfif>
	  </font>
	</tr>
</cfif>

<tr><td colspan="3" style="padding-left:20px;padding-top:2px;padding-right:20px">

	<table id="plTable" width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formspacing navigation_table">
	
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
	 
	  <tr>
	  
	    <td width="50%" valign="top" style="padding-left:12px">
						
		    <table cellpadding="0" cellspacing="0" width="100%" class="navigation_table">
			
				<cfif Period.recordcount gt "1">	
								
				<tr>
				  
				  <td class="labellarge"><cf_space spaces="15"></td>
				  <td class="labellarge" style="width:100%"><cf_space spaces="65"></td>
				  
				  <cfif showperiod eq "1">
					  <cfoutput query="Period">
					  <td style="border-radius:4px;border:1px solid silver" class="labellarge" width="80" align="center"><cf_space spaces="10">#Period#</td>
					  </cfoutput>
				  </cfif>
				  <td style="border-radius:4px;border:1px solid silver" class="labellarge" align="center"><cf_space spaces="15"><cf_tl id="Total"></td>					   
				 
				</tr>
				</cfif>			
												
				<cf_FundViewData panel="credit" 
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
				
		<!---						
		<tr><td width="50%" style="padding-top:20px;padding-bottom:10px;height:50px;padding-left:3px;font-size:26px" class="labellarge linedotted" height="28">
		    <cf_tl id="Operating costs"></td>
		</tr>
		---> 
					
		<tr>
			
		</cfif>
		
	    <td width="50%" valign="top" style="padding-left:12px">
		
	      <table border="0" cellpadding="0" cellspacing="0" width="100%" class="formpadding navigation_table">
		  			  
			  <cfif Period.recordcount gt "1">	
				
				<tr>				 
				  <td class="labellarge"><cf_space spaces="15"></td>
				  <td class="labellarge"><cf_space spaces="65"></td>				  
				  <cfif showperiod eq "1">
					  <cfoutput query="Period">
					     <td width="80" style="border-radius:4px;border:1px solid silver" class="labellarge" align="center"><cf_space spaces="10">#Period#</td>
					  </cfoutput>
				  </cfif>				  
				  <td style="border-radius:4px;border:1px solid silver" class="labellarge" align="center"><cf_tl id="Total"><cf_space spaces="20"></td>					   				 
				</tr>
				
			  </cfif>		
								
			  <cf_FundViewData panel="debit" 
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
				FROM    #SESSION.acc#Fund#FileNo#				
		  </cfquery>		
		  
		  <cfif data.debittotal gt data.credittotal>
		  	<cfset tot = data.debitTotal>
		  <cfelse>
		  	<cfset tot = data.creditTotal>
		  </cfif>			  	  
	  	  	  	  	  
	  <cfif form.layout eq "horizontal">
	  
	  	<cfoutput>
	  
		  <tr>
		   
		    <td width="50%" align="right" valign="bottom" class="labellarge" style="border-top:1px solid silver;height:30px;padding-right:5px">				
				#NumberFormat(tot,',____')#				
			</td>
			
			<td width="50%" align="right" valign="bottom" style="border-top:1px solid silver;height:30px;padding-right:5px" class="labellarge">		
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

