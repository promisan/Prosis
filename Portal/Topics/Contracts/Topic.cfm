
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#ContractCost">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#TransactionTotals">

<cfquery name="Statement"
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DISTINCT PR.ProgramCode AS ProjectCode, PR.ProgramName as Project, I.AmountMatched * R.Percentage AS Debit
	INTO UserQuery.dbo.#SESSION.acc#ContractCost 
	FROM InvoicePurchase I INNER JOIN PurchaseLine P ON I.PurchaseNo = P.PurchaseNo 
	INNER JOIN RequisitionLineFunding R ON P.RequisitionNo = R.RequisitionNo INNER JOIN Program.dbo.Program PR ON R.ProgramCode = PR.ProgramCode
	WHERE     EXISTS
                          (SELECT     'X' AS Expr1
                            FROM          RequisitionLine
                            WHERE      (I.RequisitionNo = RequisitionNo) AND (Mission = 'CMP'))
</cfquery>

<cfquery name="PTotals"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	Project,
			Round(SUM(Debit)/1000,0) as Amounts			
	FROM   dbo.#SESSION.acc#ContractCost
	GROUP BY Project 
	Order by Project 
</cfquery>
	
<cfif PTotals.recordcount is 0>
	<table width="100%" align="center"><tr><td align="center">No records found</td></tr></table>
	<cfexit method="EXITTEMPLATE">
</cfif>
	
<cfquery name="Max" 
dbtype="query">
	Select MAX(Amounts) as MaxAmount
	from PTotals
</cfquery>

<cfquery name="GrandTotal" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	SUM(Debit) as Total			
	FROM   dbo.#SESSION.acc#ContractCost
</cfquery>

<cfif GrandTotal.Total eq "">
	  <cfset grt = 0>
<cfelse>
	  <cfset grt = GrandTotal.Total>  
</cfif>

<cfquery name="Transaction"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT SUM(T.AmountBaseDebit) AS Debit
	FROM   TransactionLine T INNER JOIN Journal J 
				ON T.Journal = J.Journal AND J.Mission = 'CMP' 
			INNER JOIN Ref_Account G 
				ON G.GLAccount = T.GLAccount
	WHERE  G.AccountType = 'Debit'
	AND    G.AccountClass = 'Result' 
	AND J.Journal IN
	       (SELECT Journal
	         FROM  Journal
	         WHERE SystemJournal != 'Opening' OR SystemJournal IS NULL) 
	AND T.Reference IN ('receipt', 'payment', 'purchase')												   
</cfquery>

<cfif Transaction.Debit eq "">
	  <cfset deb = 0>
<cfelse>
	  <cfset deb = Transaction.Debit>  
</cfif>
	
<cfset NONClassified = deb-grt>	

<table width="70%" border="0" align="center">
  <tr>
  
  <td align="center">
<table width="100%" border="0" align="center">
  <tr>
  
  <td colspan="2" align="center">  
  <font size="3"><b>Disbursements by Contract</b></font>
  </td>
  </tr>
  <tr>
  <td colspan="2" align="center">
 <font size="2">(USD$1000)</font>
 </td>
  </tr>
 
  <tr>
  <td align="left"><cfloop index="i" from="1" to="11">&nbsp</cfloop>
  <font size="1">TOTAL: <cfoutput>#NumberFormat(Round(GrandTotal.Total/1000),"_,_")#</cfoutput></font></td>	
  <td align="right">
 <A HREF ="javascript:drill('/Gledger/Inquiry/Statement/StatementSelect.cfm')"><font size="1">Click here for Details</font></A>&nbsp&nbsp
 </td>
  </tr>
    
  <tr>  
  
    <td colspan="2">
  
	<cfoutput>	
	
	<table width="100%" align="center" border="0" cellpadding="0" cellspacing="0" >
	
	<tr>
	
      <td align="center">	
  
		<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
<cfchart style = "#chartStyleFile#" format="png" 
	         chartheight="200" 
			 chartwidth="600" 
			 scalefrom="0"
			 scaleto="#Max.MaxAmount+1000#" 
			 showxgridlines="yes" 
			 showygridlines="yes"
			 gridlines="6" 
			 showborder="no" 
			 fontsize="8" 
			 fontbold="yes" 
			 fontitalic="no" 
			 xaxistitle="" 
			 yaxistitle="" 
			 show3d="no" 
			 rotated="no" 
			 sortxaxis="no" 
			 showlegend="no" 
			 tipbgcolor="##FFFFCC" 
			 showmarkers="yes" 
			 markersize="30" 
			 backgroundcolor="##ffffff">
			 
		<cfchartseries type="bar" 
	         query="PTotals" 
			 itemcolumn="Project" 
			 valuecolumn="Amounts" 
			 seriescolor="##CCCC66" 
			 paintstyle="shade" 
			 markerstyle="snow" 
			 colorlist="##CCCC66,##3399FF,##66CC66,##999999,##FFFF99,##9966FF,##FF7777,##CCCA6A,##339AFA,##66AC6A,##999A9A,##FFFA9A,##996AFA">
		 </cfchartseries>
		</cfchart>
		</td>
		</tr>
	</table>
	
	
	
	</cfoutput>
	</td>
	</tr>
	
	<!---
	<tr>
	<td><font size="1">* Non-classified expenditures: 
	<cfoutput>#NumberFormat(ROUND(NONClassified/1000),"_,_")#
	&nbsp&nbspTotal: #NumberFormat(ROUND(Transaction.Debit/1000),"_,_")#</cfoutput>
	</font></td>
	
	--->
	
	</tr>
</table>
	</td>
	</tr>
</table>

