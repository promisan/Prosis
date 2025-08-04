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
<cfcomponent>
<cfproperty name="name" type="string">
    <cfset this.name = "Payroll XML File generation">

    	<cffunction name="Accents"
             access="public"
             returntype="string"
             displayname="Accents">

             <cfargument name="thisString"    		type="string" required="true">
             <cfset list1 = "á,é,í,ó,ú,ý,à,è,ì,ò,ù,â,ê,î,ô,û,ã,ñ,õ,ä,ë,ï,ö,ü,ÿ,À,È,Ì,Ò,Ù,Á,É,Í,Ó,Ú,Ý,Â,Ê,Î,Ô,Û,Ã,Ñ,Õ,Ä,Ë,Ï,Ö,Ü,x">
             <cfset list2 = "a,e,i,o,y,u,a,e,i,o,u,a,e,i,o,u,a,n,o,a,e,i,o,u,y,A,E,I,O,U,A,E,I,O,U,Y,A,E,I,O,U,A,N,O,A,E,I,O,U,Y">
             <cfset newString = ReplaceList(thisString,list1,list2)>

             <cfreturn newString>

         </cffunction>


   		<cffunction name="genXMLFile"
             access="public"
             returntype="void"
             displayname="genXMLFile">

            <cfargument name="thisMission"    		type="string" required="true">	
			<cfargument name="ForPersonNo"       	type="string" required="true">
			<cfargument name="FinalPay"       		type="string" required="false">
			<cfargument name="TransferDate"       	type="string" required="true">
			<cfargument name="SettlementId"       	type="string" required="true">
			<cfargument name="definedPayThroughGLAccount"       	type="string" required="true">

			<cfquery name="qPackage" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT D.*, P.FullName, P.IndexNo
				FROM Userquery.dbo.#SESSION.acc#XML_FinalPayment_#ForPersonNo#_Destination D 
				INNER JOIN Employee.dbo.Person P ON P.PersonNo = D.ReferencePersonNo 
				WHERE D.PayThroughGLAccount = '#definedPayThroughGLAccount#' 
			</cfquery>

			<cfquery name="get"
   			datasource="AppsEmployee" 
   			username="#SESSION.login#" 
   			password="#SESSION.dbpw#">
      			SELECT     *
      			FROM       Payroll.dbo.EmployeeSettlement ES
	  			WHERE      SettlementId = '#SettlementId#'	           
			</cfquery> 
			<!----ORIGIN OF FUNDS---->

			<cfset vBankName 				= qPackage.OriginBankName>
			<cfset vTransactionDate 		= TransferDate>
			<cfset vTransferDate 			= qPackage.DatePrepared> 
			<cfset vOriginBankName          = qPackage.OriginAccountName>
			<cfset vOriginBankNameShort     = Left(qPackage.OriginAccountName,2)>
			<cfset vBankAccountABA          = qPackage.OriginAccountABA>
			<cfset vBankAccount             = qPackage.OriginAccountNo>

			<cfset vBankStreet = "">
			<cfset vBankCity = "">
			<cfset vBankZip = "">
			<cfset vBankCountry = "">
			<cfset vBankCountryCode = "">
			
			<cfset i = 0>
			<cfloop list="#qPackage.OriginBankAddress#" index="vAddress" delimiters="|">
				<cfset i = i + 1>
				<cfswitch expression="#i#">
					<cfcase value="1"><cfset vBankStreet = rtrim(ltrim(vAddress))></cfcase>
					<cfcase value="2"><cfset vBankCity = rtrim(ltrim(vAddress))></cfcase>
					<cfcase value="3"><cfset vBankZip = rtrim(ltrim(vAddress))></cfcase>
					<cfcase value="4"><cfset vBankCountry = rtrim(ltrim(vAddress))></cfcase>
					<cfcase value="5"><cfset vBankCountryCode = rtrim(ltrim(vAddress))></cfcase>														
				</cfswitch>
			</cfloop>
			
	
			<cfquery dbtype="query" name="qCounter">
				SELECT COUNT(1) as counter
				FROM qPackage
			</cfquery>							

			<cfquery dbtype="query" name="qSum">
				SELECT PaymentCurrency,SUM(PaymentAmount) as PaymentAmount
				FROM qPackage
				GROUP BY PaymentCurrency
			</cfquery>	
			
			<cf_assignid>	
			<cfset AttachmentId = rowguid>


			<cfset vTransferDate = TransferDate>
			<cfset vTransactionDate = TransferDate>

			<cfset vMission     = "#thisMission#"> 
			<cfset vMissionName = "Special Tribunal for Lebanon">
			<cfparam name = "isFinalPay"   default="No">

			<cfif FinalPay neq "">
				<cfset isFinalPay ="#FinalPay#">
			</cfif>
			

			<cfset vUnknown1 = "2180">
			<cfset vUnknown3 = "1">


			<cfset strTransferDate  = DateFormat(vTransferDate,"YYYYMMDD")>
			<cfset bankDate = DateFormat(vTransferDate,"YYYY-MM-DD")>

			<cfset strDate = DateFormat(vTransactionDate,"YYYYMMDD")>
			<cfset payrollDate = DateFormat(vTransactionDate,"YYYY-MM-DD")>

			<cfset vId = "#vMission##vUnknown1#-#strTransferDate##TimeFormat(vTransferDate,'HHnnss')#">

			<cfoutput>
			<cfxml variable="XMLBank"> 
			<Document xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="urn:iso:std:iso:20022:tech:xsd:pain.001.001.03">

			<CstmrCdtTrfInitn>

			<GrpHdr>
			<MsgId>#vId#</MsgId>
			 
			<CreDtTm>#bankDate#T#TimeFormat(vTransferDate,'HH:nn:ss')#</CreDtTm>
			 
			 
			<cfset vTotalAmount  = 0> 
			<cfset vRows = 0>

			<cfloop query = "qPackage">
					<cfset vRows = vRows + 1>
					<cfset vTotalAmount = vTotalAmount + PaymentAmount>
			</cfloop>	

			<NbOfTxs>#vRows#</NbOfTxs>
			 
			<CtrlSum>#vTotalAmount#</CtrlSum>
			 
			<InitgPty><Nm>#vMissionName#</Nm></InitgPty>
			</GrpHdr>

			<PmtInf>
			<PmtInfId>#vId#</PmtInfId>
			<PmtMtd>TRF</PmtMtd>

			<PmtTpInf>
			<InstrPrty>NORM</InstrPrty>
			<SvcLvl>
			<Cd><cfif vBankAccountABA eq "NL74ABNA0420412360">BTL91<cfelse>SEPA</cfif></Cd>
			</SvcLvl>
			</PmtTpInf>
			 
			<ReqdExctnDt>#PayrollDate#</ReqdExctnDt>

			<!----BEGIN ORIGIN OF FUNDS---->
			<Dbtr>
				<Nm>#vOriginBankName#</Nm>
				<PstlAdr>
					<Ctry>#vBankCountryCode#</Ctry>
					<cfif len(vBankStreet) gt 2>		
						<AdrLine>#vBankStreet#</AdrLine>
					</cfif>	
					<cfif len(vBankZip) gt 2>
						<AdrLine>#vBankZip#</AdrLine>
					</cfif>
					<cfif len(vBankCity) gt 2>
						<AdrLine>#vBankCity#</AdrLine>		
					</cfif>	
					<cfif len(vBankCountry) gt 2>		
						<AdrLine>#vBankCountry#</AdrLine>
					</cfif>	
				</PstlAdr>
			</Dbtr>
			 
			<DbtrAcct>
				<Id>
					<IBAN>#vBankAccountABA#</IBAN>
				</Id>
			</DbtrAcct>

			<DbtrAgt>
				<FinInstnId>
					<BIC>#vBankAccount#</BIC>
				</FinInstnId>
			</DbtrAgt>
			<!---- END ORIGIN OF FUNDS---->

				<cfloop query = "qPackage">
					
						<!----BEGIN DESTINATION OF FUNDS---->
						<cfset vEmployeeAccount 		= "#qPackage.AccountNo#">
						<cfset vEmployeeName    		= "#qPackage.FullName#">
						<cfset vEmployeeAccountABA  	= "#qPackage.AccountABA#"> 
						<cfset vEmployeeAccountSWIFT  	= "#qPackage.SwiftCode#"> 			
						<cfset vEmployeeIndexNo  		= "#qPackage.IndexNo#">
						<cfset vEmployeeAccountCurrency = "#qPackage.PaymentCurrency#"> 
						<cfset vEmployeeAmount  		= "#qPackage.PaymentAmount#"> 
						<cfset vEmployeeAddressCountry  = "NL"> 
						<cfset vEmployeeAddress         = "Den Hague">
					
						<cfif qPackage.IBAN neq "">
										
							<CdtTrfTxInf>
								<PmtId>
									<InstrId>#strDate#-#vUnknown1#-#vEmployeeIndexNo#-#vOriginBankNameShort#-#vUnknown3#</InstrId>
									<EndToEndId>#strDate#-#vUnknown1#-#vEmployeeIndexNo#-#vOriginBankNameShort#-#vUnknown3#</EndToEndId>
								</PmtId>
								 
								<Amt>
									<InstdAmt Ccy="#vEmployeeAccountCurrency#">#vEmployeeAmount#</InstdAmt>
								</Amt>
								 
								<CdtrAgt>
									<FinInstnId>
										<BIC><cfif vEmployeeAccountSWIFT neq "">#vEmployeeAccountSWIFT#<cfelse>#vEmployeeAccountABA#</cfif></BIC>
									</FinInstnId>
								</CdtrAgt>
								 
								<Cdtr>
									<Nm>#Accents(vEmployeeName)#</Nm>
									<PstlAdr>
										<Ctry>#vEmployeeAddressCountry#</Ctry>
										<AdrLine>#vEmployeeAddress#</AdrLine>
									</PstlAdr>
								</Cdtr>
								 
								<CdtrAcct>
									<Id>
										<IBAN>#qPackage.IBAN#</IBAN>
									</Id>
								</CdtrAcct>
								
								<RmtInf>
									<Ustrd>SEPA FMT</Ustrd>
								</RmtInf>
							</CdtTrfTxInf>
						</cfif>
					 	<!----END DESTINATION OF FUNDS---->
				</cfloop>
			</PmtInf>

			</CstmrCdtTrfInitn>

			</Document> 
			</cfxml> 
			</cfoutput>

			<cfset filePath		="">
			<cfset fileName 	="">
			<cfset attachmentRef="">

			<cfif isFinalPay eq "Yes">
					<cffile action="write" file="#SESSION.rootDocumentPath#\FinalPayABN\#ForPersonNo#\001_#vBankName#.xml" output="#XMLBank#">
					
					<cffile action="COPY" 
						source="#SESSION.rootDocumentPath#\FinalPayABN\#ForPersonNo#\001_#vBankName#.xml" 
						destination="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\001_#ForPersonNo#_#vBankName#.xml">
						
						<cfset filePath="FinalPayABN/#ForPersonNo#/">
						<cfset fileName ="001_#ForPersonNo#_#vBankName#.xml">
						
						<cfset attachmentRef ="#get.SettlementId#">
					
				<cfelse>
					<cffile action="write" file="#SESSION.rootDocumentPath#\GLTransaction\#URL.TransactionId#\001_#getHeader.Journal#_#getHeader.JournalSerialNo#_#vBankName#.xml" output="#XMLBank#">
					
					<cffile action="COPY" 
						source="#SESSION.rootDocumentPath#\GLTransaction\#URL.TransactionId#\001_#getHeader.Journal#_#getHeader.JournalSerialNo#_#vBankName#.xml" 
						destination="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\001_#getHeader.Journal#_#getHeader.JournalSerialNo#_#vBankName#.xml">	
						
						<cfset filePath="GLTransaction/#URL.TransactionId#/">
						<cfset fileName ="001_#getHeader.Journal#_#getHeader.JournalSerialNo#_#vBankName#.xml">
						
						<cfset attachmentRef ="#URL.TransactionId#">
			</cfif>

			<cfquery name="qLogAttachment" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO Attachment (AttachmentId, DocumentPathName, Server, ServerPath, FileName, FileStatus, Reference, OfficerUserId, OfficerLastName, OfficerFirstName)
				VALUES (
				'#AttachmentId#',
				'GLTransaction', 
				'#SESSION.rootdocumentpath#',
				'#filePath#',
				'#fileName#',
				1,
				'#attachmentRef#', 
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#')
			</cfquery>		

	</cffunction>

</cfcomponent>