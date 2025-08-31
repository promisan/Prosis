<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfoutput>
<cfset vLogo       = "<img src='#SESSION.root#/Images/UN_LOGO_BLUE.gif' alt='' width='64' height='57' border='0'>">
<cfset vTitleLine1 = "Organizations">
<cfset vTitleLine2 = "Nations Unies" >
<cfset vTitleLine3 = "INTEROFFICE MEMORANDUM">
<cfset vTitleLine4 = "MEMORANDUM INTERIEUR">
<cfset vDate = dateformat(Now()," dd MMMM yyyy")>

<cfset td05 = "border-top:1px solid b0b0b0">


	<cfquery name="GetInvoices" 
		datasource="NovaLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">

		SELECT	SI.Description as ServiceDescription, 
				CU.CustomerName, 
				CU.Memo as CustomerNameLong, 
				H.AccountPeriod,
				Year(JournalBatchDate) as JournalBatchYear,
				R.Description as DebitAccount,	
				AC1.Description as CreditAccount,
				ROUND(SUM(L.AmountDebit), 2) AS AmountDebit, 
				ROUND(SUM(L.AmountCredit), 2) * (-1) AS AmountCredit,
				ROUND(SUM(L.TransactionAmount), 2) AS TransactionAmount
		  
		FROM         Organization.dbo.Organization RIGHT OUTER JOIN
		                      Organization.dbo.Organization AS O ON Organization.dbo.Organization.OrgUnitCode = O.ParentOrgUnit AND 
		                      Organization.dbo.Organization.Mission = O.Mission AND Organization.dbo.Organization.MandateNo = O.MandateNo RIGHT OUTER JOIN
		                      Ref_AccountGroup AS G INNER JOIN
		                      Ref_Account AS R ON G.AccountGroup = R.AccountGroup INNER JOIN
		                      TransactionHeader AS H INNER JOIN
		                      TransactionLine AS L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo ON R.GLAccount = L.GLAccount ON 
		                      O.OrgUnit = H.ReferenceOrgUnit
							INNER JOIN Workorder.dbo.Workorder AS W ON  H.ReferenceId = W.WorkOrderId 
							INNER JOIN WorkOrder.dbo.ServiceItem AS SI ON W.ServiceItem = SI.Code
							INNER JOIN WorkOrder.dbo.Customer CU ON W.CustomerId = CU.CustomerId
							LEFT OUTER JOIN dbo.Ref_Account AC1 ON W.GLAccountPayment = AC1.GLAccount
							  
		WHERE     H.Journal = 'IT60001'
			AND (G.AccountClass = 'Result') 
			AND H.Mission in ('#URL.Mission#')
			AND H.JournalBatchDate    >= #sel#		
			AND H.JournalBatchDate    <= #selend#
			
<!---			AND convert(varchar,isnull(H.JournalBatchDate,H.DocumentDate),103) in ('30/04/2012')--->
		
			AND H.ReferenceId IN (SELECT WorkOrderId 
									FROM WorkOrder.dbo.WorkOrder 
									WHERE ServiceItem IN ('#ProcessService#'))
		

		
		GROUP BY SI.Description , 
				CU.CustomerName, 
				CU.Memo, 
				H.AccountPeriod,				
				Year(JournalBatchDate) ,
				R.Description ,	
				AC1.Description
	</cfquery>		
		
		
	<cfsavecontent variable="vSignatureLine2">
		<table width="100%">
		<tr>
			<td height="400px"></td>
		</tr>				
		<tr>
			<td  align="left" style="#td05#"></td>
		</tr>									
		
		<tr valign="Top">
		    <td align="left">
				<table>
					<tr>
						<td width="15%" align="left">cc:</td>
						<td >
							R. Bhatia
						</td>
					</tr>
					<tr>
						<td width="15%" align="left"></td>										
						<td >
							C. Tang
						</td>
					</tr>					
					<tr>
						<td width="15%" align="left"></td>										
						<td >
							M. Casiano
						</td>
					</tr>					
					
					<tr>
					<td width="15%" align="left"></td>					
					<td >
						Y. Callender
					</td>
					</tr>
					<tr>
					<td width="15%" align="left"></td>					
					<td >
						R. O. Suarez
					</td>
					</tr>					
					<tr>
					<td align="right">					
						<p style="page-break-before:always">
					</td>
					</tr>
					
				</table>					
			</td>
		</tr>
		</table>				
	</cfsavecontent>

	<cfloop query="GetInvoices">
	
		<cf_LayoutDocument
			Class		    = "Memo"
			LanguageCode    = "ENG"
			DocumentDate	= "#vDate#"
			Reference	    = ""
			To			    = "Mr. user, position<br>text/dev<br><br>"
			From		    = "user, position<br>text<br><br>"
			Subject		    = " Services: #ServiceDescription# - #CustomerNameLong# (#CustomerName#)"
			Logo            = "#vLogo#"
			TitleLine1      = "#vTitleLine1#"
			TitleLine2      = "#vTitleLine2#"
			TitleLine3      = "#vTitleLine3#"
			TitleLine4      = "#vTitleLine4#"
			TitleLine5      = ""
			SignatureTitle  = ""
			SignatureLine1  = ""
			SignatureLine2  = "#vSignatureLine2#"
			SignatureLine3  = ""
			SignatureLine4  = ""
			SignatureLabel  = ""
			SectionLine     = ""
			Closing         = ""								
			SignedBy        = "">								 		
		  
				 <table width="90%" border="0" align="center">
				 	<tr >
						<td align="right" width="5%" valign="top">1.</td>
						<td  style="font-size:11pt" align="justify">
							Please find attached the details of the charges to be recovered for <strong>#ServiceDescription#</strong> provided by the Office (O) to the
							<strong>#CustomerNameLong# (#CustomerName#)</strong> for <strong>#JournalBatchYear#</strong>, as described in the attached document and in compliance with the service request document signed by the aforementioned office.
							<br><br>						
						</td>
					</tr>
				 	<tr >
						<td colspan="2" height="5"></td>
					</tr>					
				 	<tr >
						<td align="right" width="5%" valign="top">2.</td>
						<td align="justify" style="font-size:11pt" >
							In this connection, please debit account <strong>#AccountPeriod#,#DebitAccount#</strong> and credit the amount of <strong>US$ #numberformat(TransactionAmount,"__,__.__")#</strong> to account <strong>#AccountPeriod#,#CreditAccount#</strong>. Kindly forward a copy of the 
							transaction document to my attention.
							<br><br>						
						</td>
					</tr>	
				 	<tr >
						<td colspan="2" height="5"></td>
					</tr>					
									
				 	<tr >
						<td align="right" width="5%" valign="top">3.</td>
						<td align="justify" style="font-size:11pt" >
							Your usual kind cooperation is highly appreciated.
							<br><br>						
						</td>
					</tr>					
					
				 </table>
			 						   
		</cf_LayoutDocument>
	
	
	</cfloop>

</cfoutput>

