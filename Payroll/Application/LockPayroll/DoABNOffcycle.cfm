<!--
    Copyright © 2025 Promisan

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
<cfparam name="Object.ObjectKeyValue4"        	default="">


<cfquery name="Object"
   datasource="AppsPayroll" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">      
      SELECT  *
	   FROM   Organization.dbo.OrganizationObject
	   WHERE  ObjectKeyValue4 = '#url.settlementId#'   	
</cfquery> 

<cfquery name="getOb1"
   datasource="AppsPayroll" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">  
	   SELECT  DISTINCT ES.SettlementId
	   FROM    EmployeeSettlement AS ES 
	           INNER JOIN EmployeeSettlementLine AS ESL 
			   ON ESL.PersonNo = ES.PersonNo AND ESL.SalarySchedule = ES.SalarySchedule AND ESL.Mission = ES.Mission AND ESL.PaymentDate = ES.PaymentDate 
		WHERE  ES.PaymentStatus = '1'	
		AND    ES.PaymentDAte >=(SELECT PaymentDate FROM Payroll.dbo.EmployeeSettlement WHERE SEttlementID = '#Object.ObjectKeyValue4#')
		AND    ES.PersonNo = '#Object.PersonNo#'
</cfquery>

<cfif getOb1.recordcount lte 0 >
    <table align="center"><tr class="labelmedium"><td>
	no records found for this event, re-calculate entitlements or possible in-cycle event	
	</td></tr></table>
	
<cfelse>
	
<cfquery name="get"
   datasource="AppsEmployee" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
      SELECT     *
      FROM       Payroll.dbo.EmployeeSettlement ES
	  WHERE      SettlementId = '#getOb1.SettlementId#'	           
</cfquery> 

<cfif get.recordcount lte 0>

  <cfoutput>

  <table align="center"><tr class="labelmedium"><td>
	Your selection didn't find more details, operation aborted
	</td></tr>
 </table>	
		
</cfoutput>

</cfif>

<cfscript>
/**
 * Replaces accented characters with their non accented closest equivalents.
 * 
 * @return Returns a string. 
 * @author Rachel Lehman (raelehman@gmail.com) 
 * @version 1, November 15, 2010 
 */
function deAccent(str){
    var newstr = "";
    var list1 = "á,é,í,ó,ú,ý,à,è,ì,ò,ù,â,ê,î,ô,û,ã,ñ,õ,ä,ë,ï,ö,ü,ÿ,À,È,Ì,Ò,Ù,Á,É,Í,Ó,Ú,Ý,Â,Ê,Î,Ô,Û,Ã,Ñ,Õ,Ä,Ë,Ï,Ö,Ü,x";
    var list2 = "a,e,i,o,y,u,a,e,i,o,u,a,e,i,o,u,a,n,o,a,e,i,o,u,y,A,E,I,O,U,A,E,I,O,U,Y,A,E,I,O,U,A,N,O,A,E,I,O,U,Y";

    newstr = ReplaceList(str,list1,list2);
    return newstr;
}
</cfscript>

	<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#XML_FinalPayment_#get.personNo#_Initial">	      
	<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#XML_FinalPayment_#get.personNo#">	      
	<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#XML_FinalPayment_#get.personNo#_Destination">	      

	<cfif get.recordcount neq 0>
			<cfquery name="qPreparation" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
				SELECT     ESD.SalaryScheduleGLAccount, 
							           ESD.PayThroughGLAccount, 
									   ESD.PayThroughBankName, 
									   ESD.PaymentCurrency as Currency, 
									   ESD.PersonNo,
									   ESET.PaymentDate as DateDue,
									   ESET.Created as DatePRepared,
									   ROUND(ESD.PaymentExchangeRate, 6) as ExchRate,
									   ROUND(SUM(ESD.PaymentAmount), 2) AS PaymentAmount
							INTO 	   userQuery.dbo.#SESSION.acc#XML_FinalPayment_#get.personNo#_Initial
							FROM       Payroll.dbo.EmployeeSettlementDistribution AS ESD
									   INNER JOIN 	Payroll.dbo.EmployeeSettlement as ESET
										ON 	ESD.PersonNo 			= ESET.PersonNo
										AND ESD.SalarySchedule 		= ESET.SalarySchedule
										AND ESD.Mission 			= ESET.Mission
										AND ESD.PaymentDate 		= ESET.PaymentDate
										AND ESET.ActionStatus 	 	IN ('3')
										AND ESD.PersonNo 			= '#get.PersonNo#'
							WHERE      ESD.Mission         = '#get.Mission#' 					
							AND        ESD.SalarySchedule  = '#get.SalarySchedule#'
							AND        ESD.PaymentDate     = '#get.PaymentDate#' 	
							AND        ESD.SettlementPhase = 'Final'									
							GROUP BY   ESD.SalaryScheduleGLAccount, 
							           ESD.PayThroughGLAccount, 
									   ESD.PayThroughBankName, 
									   ESD.PaymentCurrency,
									   ESD.PersonNo,
									   ESET.PaymentDate,
									   ESET.Created,
									   ROUND(ESD.PaymentExchangeRate, 6)  
				
				
			</cfquery>
	
			<cfquery name="qPreparation" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT        
									'FinalPay' Journal, 
									'0001'   JournalSerialNo, 
									'#get.PersonNo#' ReferencePersonNo,
									CASE WHEN (SELECT GLAccount FROM Employee.dbo.PersonGLedger WHERE PersonNo = '#get.PersonNo#' AND Area = 'Payroll') IS NOT NULL 
									THEN 
										(SELECT GLAccount FROM Employee.dbo.PersonGLedger WHERE PersonNo = '#get.PersonNo#' AND Area = 'Payroll') 
									ELSE 
										'599999999' END AS GLAccount, 
									'#get.PaymentDate#' AS DateDue, 
									getDate() AS DatePrepared, 
									'Payment' Reference, 
					                '#Object.ObjectReference2#' ReferenceName, 
									'' AS Program, 
									'' AS Fund, 
									'' AS ProgramPeriod, 
									'' AS ProgramCode, 
									'' AS ObjectCode, 
									Currency, 
									CASE WHEN PaymentAmount >= 0 THEN
									ROUND(PaymentAmount, 2)
									ELSE 0 END  AS Debit, 
									CASE WHEN PaymentAmount < 0 THEN
									ROUND(PaymentAmount, 2)
									ELSE 0 END  AS Credit
					INTO Userquery.dbo.#SESSION.acc#XML_FinalPayment_#get.personNo#
					FROM            userQuery.dbo.#SESSION.acc#XML_FinalPayment_#get.personNo#_Initial
					ORDER BY GLAccount, Program, Debit
		
			</cfquery>
	
	
			<cfquery name="qCheck" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM Userquery.dbo.#SESSION.acc#XML_FinalPayment_#get.personNo# 
				WHERE GlAccount = '599999999'  
			</cfquery>	
	
			
			<cfif qCheck.recordcount eq 0>
	
			
					<cfif NOT DirectoryExists("#SESSION.rootDocumentPath#\FinalPayXML\")>
							<cfset DirectoryCreate("#SESSION.rootDocumentPath#\FinalPayXML\")>
					</cfif>
					
					<cfif NOT DirectoryExists("#SESSION.rootDocumentPath#\FinalPayABN\#get.PersonNo#\")>
							<cfset DirectoryCreate("#SESSION.rootDocumentPath#\FinalPayABN\#get.PersonNo#\")>
					</cfif>
					
					
					
	
					<cfquery name="qDistribution" 
						datasource="AppsPayroll" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT 
							S.ReferencePersonNo,
							S.DateDue,
							S.DatePrepared,
							D.PayThroughGLAccount, 
							D.PayThroughBankName, 
							<!--- This is part of the name of the file--->
							BA.BankName		as OriginBankName,
							
							BA.BankAddress  as OriginBankAddress,
							BA.AccountNo 	as OriginAccountNo,
							BA.AccountName 	as OriginAccountName,
							BA.AccountABA 	as OriginAccountABA,
					        D.PaymentCurrency,
	      					D.PaymentAmount,						
						 	PA.AccountNo,
							PA.BankName,
							PA.BankAddress, 
							PA.IBAN,
							PA.AccountABA,
							PA.SwiftCode
						INTO Userquery.dbo.#SESSION.acc#XML_FinalPayment_#get.personNo#_Destination														
						FROM Userquery.dbo.#SESSION.acc#XML_FinalPayment_#get.personNo# S
							INNER JOIN Payroll.dbo.EmployeeSettlementDistribution D ON D.PersonNo = S.ReferencePersonNo
								AND D.PaymentDate = S.DateDue
							INNER JOIN 	Payroll.dbo.PersonAccount PA ON PA.AccountId = D.AccountId
							INNER JOIN Accounting.dbo.Ref_Account A ON A.GlAccount = D.PayThroughGLAccount
							INNER JOIN Accounting.dbo.Ref_BankAccount BA ON BA.Bankid = A.BankId
						WHERE D.PaymentMode = 'Transfer'	
					</cfquery>					
					
					
					<cfquery name="qSources" 
						datasource="AppsPayroll" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT DISTINCT PayThroughGLAccount
						FROM Userquery.dbo.#SESSION.acc#XML_FinalPayment_#get.personNo#_Destination 
					</cfquery>
	
					<cfloop query="#qSources#">
	
						<cfquery name="qPackage" 
						datasource="AppsPayroll" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT D.*, P.FullName, P.IndexNo
							FROM Userquery.dbo.#SESSION.acc#XML_FinalPayment_#get.PersonNo#_Destination D 
							INNER JOIN Employee.dbo.Person P ON P.PersonNo = D.ReferencePersonNo 
							WHERE D.PayThroughGLAccount = '#qSources.PayThroughGLAccount#' 
						</cfquery>
	
						<cfset vBankName 				= qPackage.OriginBankName>
					
						<cfinvoke component 		= "Service.Process.EDI.SUN.XML"  
					   		method           		= "genXMLFile" 
	   						thisMission        		= "#get.Mission#" 
	   						ForPersonNo       		= "#get.PersonNo#"
	   						FinalPay          		= "yes"
	   						TransferDate            = "#get.PaymentDate#"
	   						definedPayThroughGLAccount = "#qSources.PayThroughGLAccount#"
	   						SettlementId            = "#get.SettlementId#">	
						
					</cfloop>				
			<cfelse>
					<cfoutput>
					<table width="100%">
						<tr>
							<td align="center" colspan="6" style="color:red">
								<img src="#client.root#/images/warning.png">
								<br>
								The following transactions are not linked to an account.
								<br>
								File was NOT generated
							</td>
						</tr>
						<tr height="20px">
							<td colspan="6">	
								&nbsp;&nbsp;  
							</td>
						</tr>
	
						<tr style="font-weight:bold">
							<td width="10%">
								Journal-SerialNo
							</td>			
							<td width="10%">
								Reference
							</td>	
							<td width="10%">
								Reference Name
							</td>	
							<td width="10%">
								Currency
							</td>	
							<td width="10%" align="right">
								Debit
							</td>	
							<td width="10%" align="right">
								Credit
							</td>															
						</tr>
					
						<cfloop query="qCheck">
							<tr>
								<td width="10%">
									#qCheck.Journal#-#qCheck.JournalSerialNo#
								</td>			
								<td width="10%">
									#qCheck.Reference#
								</td>	
								<td width="10%">
									#qCheck.ReferenceName#
								</td>	
								<td width="10%">
									#qCheck.Currency#
								</td>	
								<td width="10%" align="right">
									#NumberFormat(qCheck.Debit,",.__")#
								</td>	
								<td width="10%" align="right">
									#NumberFormat(qCheck.Credit,",.__")#
								</td>															
							</tr>
						</cfloop>
						
					</table>
					</cfoutput>
			</cfif>	
	</cfif>


</cfif> 


