
<input type="hidden" id="fileno" name="fileno" value="<cfoutput>#fileNo#</cfoutput>">

<cfset frm = "_,__">

<!--- horizontal cols --->
<cfquery name="Category"
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT   *
FROM     Accounting.dbo.Ref_GLCategory
ORDER BY ListingOrder
</cfquery>

<cfif Category.recordcount eq "1">
	<cfparam name="URL.report" default="balance">
<cfelse>
	<cfparam name="URL.report" default="pl">
</cfif>

<cfquery name="Parameter"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ParameterMission
	WHERE  Mission = '#URL.Mission#' 
</cfquery>

<cfquery name="PeriodList"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Period
	WHERE  AccountPeriod IN (#preserveSingleQuotes(AccountPeriod)#) 
</cfquery>

<cfparam name="Form.History"           default="TransactionPeriod">
<cfparam name="Form.TransactionPeriod" default="">
<cfparam name="Form.OrgUnitOwner"      default="">
<cfparam name="Form.ShowOwner"         default="0">
<cfparam name="Form.Currency"          default="#application.basecurrency#">


<cfif form.layout eq "period">
	
	<cfif Form.History eq "accountperiod">
		
		<cfquery name="Node"
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   DISTINCT AccountPeriod as myNode
			FROM 	 #SESSION.acc#Balance#FileNo# 
			ORDER BY AccountPeriod
		</cfquery>
		
		<cfif Node.recordcount eq "1">
			<cfset mode = "total">
		</cfif>
		
	<cfelse>
		
		<cfquery name="Node"
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   DISTINCT TransactionPeriod as myNode
			FROM     #SESSION.acc#Balance#FileNo# 
			ORDER BY TransactionPeriod
		</cfquery>
			
	</cfif>
		
	<cfset ct = "">
	
	<cfloop query="Node">
	    <cfif ct eq "">
		    <cfset ct = "#myNode#">
		<cfelse>
			<cfset ct = "#ct#,#myNode#">
		</cfif>
	</cfloop>

	<cfset nodelist = ct>
	
<cfelseif form.layout eq "owner">

	<cfquery name="Node"
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   DISTINCT OrgUnitOwner as Node
			FROM 	 #SESSION.acc#Balance#FileNo# 
			ORDER BY OrgUnitOwner
		</cfquery>
		
	<cfset ct = "">
	<cfloop query="Node">
	    <cfif ct eq "">
		    <cfset ct = "#Node#">
		<cfelse>
			<cfset ct = "#ct#,#Node#">
		</cfif>
	</cfloop>		
	
	<cfset nodelist = ct>

</cfif>	

<cfquery name="DebitPanel"
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     #SESSION.acc#Balance#FileNo# 
	WHERE    Panel = 'Debit'
	ORDER BY AccountParent, AccountGroup, GLAccount
</cfquery>

<cfquery name="DebitTotal"
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  SUM(Debit) as Debit
	FROM    #SESSION.acc#Balance#FileNo# 
	WHERE   Panel = 'Debit'
</cfquery>

<cfquery name="CreditPanel"
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   #SESSION.acc#Balance#FileNo# 
	WHERE  Panel = 'Credit'
	ORDER  BY AccountParent, AccountGroup, GLAccount
</cfquery>

<cfquery name="CreditTotal"
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT SUM(Credit) as Credit
	FROM   #SESSION.acc#Balance#FileNo# 
	WHERE  Panel = 'Credit'
</cfquery>

<cfset dbt = 0>
<cfoutput query = "DebitTotal">
<cfif Debit is not "">
   <cfset dbt = Debit>
</cfif>   
</cfoutput>

<cfset crt = 0>
<cfoutput query = "CreditTotal">
<cfif Credit is not "">
   <cfset crt = Credit>
</cfif>   
</cfoutput>

<table width="98%" border="0" align="center" class="formspacing">

<cfoutput>

<script>
  document.getElementById("screentoplabel").innerHTML = "<font size='5'>Balance Sheet #URL.Mission#"
</script>

</cfoutput>

<tr>
    <td class="labellarge" style="font-size:40px"><cf_tl id="Trial Balance"></td>
	<td colspan="2" align="right" style="padding-right:10px;" class="clsNoPrint">
		<cfoutput>
			<cf_tl id="Balance Sheet" var="1">
			<span id="printTitle" style="display:none;">#UCASE("#lt_text# #url.mission# - #Form.AccountPeriod# - #replace(form.transactionPeriod,"'","","ALL")# - #Application.BaseCurrency#")#</span>
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
		</cfoutput>
	</td>
</tr>

<tr><td colspan="3" style="padding-left:10px;padding-right:10px;">

	 <table width="100%" align="center" class="navigation_table">
	 
	  <tr class="labelmedium">
	    <cfif DebitPanel.recordcount eq "0" and form.layout neq "corporate">
			<!--- show nothing --->	
	    <cfelse>
	    <td width="50%" style="padding-top:10px;height:30px;font-size:30px">
			<cf_tl id="Assets"> <font size="3"><cfoutput>[#application.basecurrency#]</cfoutput></font>
		</td>					
		</cfif>
		
		<cfif form.layout eq "corporate">
		    <td width="50%" style="padding-top:10px;height:30px;font-size:30px">
				<cf_tl id="Liabilities"><font size="3"><cfoutput>[#application.basecurrency#]</cfoutput></font>
			</td>
		</cfif>
				
	  </tr>
	  
	  <cfif form.layout eq "corporate">
		   <tr style="height:1px"><td id="alertme" colspan="2"></td></tr>
	  <cfelse>
	  	   <tr style="height:1px"><td id="alertme"></td></tr>	  
	  </cfif>	   
	  
	  <cfif form.layout eq "corporate">
	  	  <tr><td colspan="2" class="linedotted"></td></tr>
	  <cfelse>
	  	  <tr><td colspan="1" class="linedotted"></td></tr>
	  </cfif>
	  
	  <tr>
	  
	    <td width="50%" valign="top" tyle="padding-left:30px">
						
		   <table width="100%" class="navigation_table">
		   		
			<cfif PeriodList.recordcount gte "1">	
			
			<tr class="fixlengthlist">
			  <td></td>
			  <td></td>
			  <td></td>
			  
			  <cfif form.layout neq "corporate">	
			  
			      <!---					  
				  <cfoutput query="PeriodList">
				  <td class="labellarge" width="80" align="center"><cf_space spaces="10">#AccountPeriod#</td>
				  </cfoutput>
				  --->
			  <cfelse>
			  	  <td align="center"></td>
			  </cfif>
			 
			</tr>
			</cfif>
		
			<cfset source = "DebitPanel">
			<cfset field  = "Debit">
			<cfset fileno = fileNo>
			<cfif DebitPanel.recordcount gt "0">		
				<cfinclude template="BalanceViewData.cfm">
			</cfif>
			
			</table>
			
	    </td>
			
		<cfif form.layout neq "corporate">
		
			</tr>
			
			<tr><td width="50%" height="1" class="linedotted"></td></tr>
			<tr><td width="50%" valign="bottom" class="labellarge" style="font-size:30px;height:20px;padding-top:20px">
				<cf_tl id="Liabilities"><font size="3"><cfoutput>[#application.basecurrency#]</cfoutput></font>
			</td></tr>
			
			<tr>
			
		</cfif>
			
	    <td width="50%" valign="top" style="<cfif form.layout eq 'horizontal'>padding-left:20px</cfif>">		
		
		   <table width="100%" class="navigation_table">
		
			<cfif PeriodList.recordcount gte "1">	
			
			<tr class="fixlengthlist">
			  <td></td>
			  <td align="center"><cf_space spaces="35"></td>
			  <td align="center"></td>
			  
			  <cfif form.layout neq "corporate">
			      <!---
				  <cfoutput query="PeriodList">
				  <td class="labellarge" width="80" align="center"><cf_space spaces="10">#AccountPeriod#</td>
				  </cfoutput>
				  --->
			  <cfelse>			  
			  	<td align="center"></td>				  
			  </cfif>			  				   
			 
			</tr>
			</cfif>
		
			<cfset source = "CreditPanel">
			<cfset field  = "Credit">
			<cfset fileno = fileNo>			
			<cfinclude template="BalanceViewData.cfm">	   
		
		    </table>
			
	    </td>
	  </tr>   
	  
	  <cfif form.layout eq "corporate">
	  
		  <tr><td colspan="2" class="line"></td></tr>
		  
		  <tr>
		   
		    <td width="50%" align="right" valign="bottom" class="labelmedium" style="padding-right:5px">	
			 <cfif dbt lt crt>			
				<b> <cfoutput>#NumberFormat(crt,'#frm#')#</cfoutput>
			 <cfelse>
			 	<b> <cfoutput>#NumberFormat(dbt,'#frm#')#</cfoutput>
			 </cfif>
			</td>
			
			<td width="50%" align="right" valign="bottom" style="padding-right:5px" class="labelmedium">	
				<cfif crt lt dbt>	
					<b><cfoutput>#NumberFormat(dbt,'#frm#')#</cfoutput>
				<cfelse>
					<b><cfoutput>#NumberFormat(crt,'#frm#')#</cfoutput>
				</cfif>
			</td>		
		  </tr>  
	  	  
	  </cfif>
	     
	</table>

</td></tr>

</table>

<cfset AjaxOnLoad("doHighlight")>

<script>
	Prosis.busy('no')
</script>	

