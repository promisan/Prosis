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
<!--- sendreqmail --->

<cfif attributes.role neq "">

	<cfquery name="Role" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM  Organization.dbo.Ref_AuthorizationRole
			WHERE Role = '#attributes.role#' 
	</cfquery>		
			
	<cfquery name="Line" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT L.*, I.Description as ItemMasterDescription, I.EntryClass
		    FROM   RequisitionLine L, ItemMaster I
			WHERE  L.RequisitionNo = '#attributes.id#' 
			AND    L.ItemMaster = I.Code
	</cfquery>		
	
	<cfquery name="Parameter" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM Ref_ParameterMission
		WHERE Mission = '#Line.Mission#' 
	</cfquery>
	
	<cfquery name="Template" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_ParameterMissionEntryClass
		WHERE  Mission    = '#Line.Mission#' 
		AND    EntryClass = '#Line.EntryClass#' 
	</cfquery>		
		
	<cfif attributes.alertstatus gte "2k">
	
		<!--- buyers --->
		
		<cfquery name="ListingSend" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
			    SELECT   DISTINCT U.*
			    FROM     RequisitionLineActor A, 
				         System.dbo.UserNames U
				WHERE    A.RequisitionNo = '#attributes.id#'	
				AND      A.Role          = 'ProcBuyer'
				AND      A.ActorUserId   = U.Account      			
				ORDER BY Pref_SystemLanguage 
				
		</cfquery>		
	
	<cfelse>
	
	
		<cfquery name="ListingSend" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
						
			    SELECT   DISTINCT U.*
			    FROM     Organization.dbo.OrganizationAuthorization A, 
				         System.dbo.UserNames U
				WHERE    (A.OrgUnit    = '#Line.OrgUnit#' or (A.OrgUnit is NULL and Mission = '#Line.Mission#'))
				AND      A.Role        = '#Attributes.role#'
				AND      A.UserAccount = U.Account
				
				<cfif Role.Parameter eq "EntryClass">
				
				AND      A.ClassParameter IN (SELECT EntryClass 
				                              FROM   ItemMaster 
										      WHERE  Code = '#Line.ItemMaster#')
				
				</cfif>
				
				AND      A.AccessLevel IN ('1','2')
				AND      (U.eMailAddress IS NOT NULL or U.emailAddressExternal IS NOT NULL)
				AND      AccountType = 'Individual'
				AND      U.Account IN (  SELECT Account 
					                     FROM   System.dbo.UserEntitySetting 
										 WHERE  EntityCode = 'ProcReq' 
										 AND    EnableMailNotification = 1)
										 
			    UNION
				
				SELECT   DISTINCT U.*
			    FROM     Purchase.dbo.RequisitionLineAuthorization A, 
						
				         System.dbo.UserNames U
				WHERE    A.RequisitionNo = '#Attributes.Id#'
				AND      A.Role          = '#Attributes.role#'
				AND      A.UserAccount   = U.Account
				
				<cfif Role.Parameter eq "EntryClass">
				
				AND      RequisitionNo IN (  SELECT RequisitionNo 
				                             FROM   RequisitionLine 
										     WHERE  RequisitionNo = A.RequisitionNo 
										     AND    ItemMaster IN (SELECT Code 
											                       FROM   ItemMaster 
																   WHERE  EntryClass = '#Line.EntryClass#')
										   )										  
				
				</cfif>
				
				AND      A.AccessLevel IN ('1','2')
				AND      (U.eMailAddress IS NOT NULL or U.emailAddressExternal IS NOT NULL)
				AND      AccountType = 'Individual'
				AND      U.Account IN (  SELECT Account 
					                     FROM   System.dbo.UserEntitySetting 
										 WHERE  EntityCode = 'ProcReq' 
										 AND    EnableMailNotification = 1)
									 
										 
				ORDER BY Pref_SystemLanguage 
				
		</cfquery>		
		
	</cfif>	
	
	<cfoutput query="ListingSend">
				
			<cfset sendto = "">
			
			<cfset sendToP = eMailAddress>
			<cfset sendToE = emailAddressExternal>
			
			<cfif isvalid("email","#sendToP#")>
				<cfset sendto = sendto & sendToP & ",">
			</cfif>
			
			<cfif isvalid("email","#sendToE#")>
				<cfset sendto = sendto & sendToE & ",">
			</cfif>
			
			<cfif trim(sendto) neq "">
				<cfset sendto = mid(sendto,1,len(sendto)-1)>
			</cfif>
							
			<!--- send mails --->	
			
			<cfif Pref_SystemLanguage eq "ENG" or Pref_SystemLanguage eq "">
				
				<cfquery name="Alert" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT *
					    FROM   Status
						WHERE  StatusClass = 'Requisition' 
						AND    Status      = '#attributes.alertstatus#' 
				</cfquery>	
				
				<cfset des = alert.description>	
			
			<cfelse>
			
				<cfquery name="Alert" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT *
					    FROM   Status_Language
						WHERE  StatusClass  = 'Requisition' 
						AND    Status       = '#attributes.alertstatus#'
						AND    LanguageCode = '#Pref_SystemLanguage#'
				</cfquery>		
				
				<cfset des = alert.description>	
			
			</cfif>
								
			<cfif sendto neq "">
									
				<cfset headercolor = "ffffff">
				
				<cfif FileExists("#SESSION.rootPath#\#Template.DueMailTemplate#") and Template.DueMailTemplate neq "">
				   <cfset custom = 1>
				<cfelse>
				   <cfset custom = 0>
				</cfif>     
				
				<cf_assignid>	
				
				<cfsavecontent variable="body">
											
					<cfif custom eq "1">
					
						<cfinclude template="../../../#Template.DueMailTemplate#">
					
					<cfelse>	
					
						<!--- default mail conformation --->					
						
						  <table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" bordercolor="808080" bgcolor="#headercolor#">
						  
						    <tr><td colspan="2">
							
							<table width="100%" height="50px" style="border-bottom:1px solid silver">								
								<tr>
									<td width="50px">						
										<img src="cid:logo" width="50" height="50" border="0" align="absmiddle" style="display:block">
									</td>
									<td style="padding-left:10px;">
										<font face="calibri" size="5" color="003059"><b>Procurement Request</b></font>
										<br>
										<font size="3" face="calibri" color="black"><cfif attributes.alertstatus eq "2k">Procurement Action<cfelse>Action Required</cfif></b></font>					 
									</td>	
								</tr>
							</table> 
								
							</td></tr>
						    
						    <tr>
							     
								 <td colspan="2" style="padding-top:20px;padding-left:10px" valign="top">
									<table cellspacing="0" cellpadding="0" class="formpadding">											
										<tr><td colspan="2" class="labelit"><font size="3" color="0080C0" >Please be advised that a requisition under No: #line.reference# is awaiting your review in #session.welcome#</td></tr>
										<tr><td height="10"></td></tr>
										<tr><td width="100px"><font size="2" >Requester:</td><td><font size="2" >#Line.OfficerFirstName# #Line.OfficerLastName#</td></tr>
										<tr><td><font size="2" >Subject:</td><td><font size="2" >#Line.RequestDescription#</td></tr>
										<tr><td><font size="2" >Item:</td><td><font size="2" >#Line.ItemMasterDescription#</td></tr>
										<tr><td><font size="2" >Class:</td><td><font size="2" >#Line.RequestType#</td></tr>
										<tr><td><font size="2" >Amount:</td><td><font size="2" ><b>#Line.RequestCurrency# #numberformat(Line.RequestQuantity*Line.RequestCurrencyPrice,"__,__.__")#</b></td></tr>
									</table>	
								</td>
							</tr>
							<tr><td height="20"></td></tr>
														
							<tr><td colspan="2" style="padding-left:10px;">					
										
								<cfquery name="Action" 
									datasource="AppsPurchase" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
								    SELECT    R.ActionId, R.ActionDate, R.OfficerLastName, R.OfficerFirstName, S.StatusDescription, R.ActionMemo
									FROM      RequisitionLineAction R INNER JOIN
								              Status S ON R.ActionStatus = S.Status
									WHERE     S.StatusClass = 'Requisition'
									AND       RequisitionNo = '#attributes.id#'
									ORDER BY  R.Created DESC
								</cfquery>
											
								<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
									
									<tr><td height="20" colspan="4"><font size="3" color="808080"><cf_tl id="Process Log"></b></td></tr>	
									<tr><td height="10"></td></tr>
									
									<tr>
									  <td></td> 
									  <td style="padding-left:5px;"><font size="2" ><cf_tl id="Timestamp"></td>
									  <td style="padding-left:5px;"><font size="2" ><cf_tl id="Name"></td>
									  <td style="padding-left:5px;"><font size="2" ><cf_tl id="Action"></td>
									</tr>	
									
									<tr><td colspan="4" height="1" style="border-bottom:1px solid silver;"></td></tr>
																		
									<cfloop query="Action">
										
										<tr>
										  <td width="1%"><font size="2" >#currentRow#.</td> 
										  <td width="120px" style="padding-left:5px;"><font size="2" >#DateFormat(ActionDate,CLIENT.DateFormatShow)# #TimeFormat(ActionDate,"HH:MM")#</td>
										  <td width="150px" style="padding-left:5px;"><font size="2" >#OfficerFirstName# #OfficerLastName#</td>
										  <td style="padding-left:5px;"><font size="2" ><cfif actionmemo neq "">#ActionMemo#<cfelse>#StatusDescription#</cfif></td>
										</tr>	
									</cfloop>		
										
								</table>											
							
							</td></tr>
							
							<tr><td height="10"></td></tr>
								
						 </table>	
						 
						 <br><br><br>
						 <!--- disclaimer --->
						 <cf_maildisclaimer context="password" id="mailid:#rowguid#">									 		
						
					</cfif>	
						
				</cfsavecontent>		
						
				<cfmail to       = "#sendto#"
				        bcc      = "#parameter.defaultEMailAddress#" 
				        from     = "#client.eMail#"
				        subject  = "#line.mission# #des# #line.reference#"
				        priority = "1"
				        mailerid = "#attributes.id#"
				        type     = "HTML">	
						
						#body#		
						
						 <cfmailparam file="#SESSION.root#/Images/Logos/Procurement/Submit.png" contentid="logo" disposition="inline"/>						
												 
				</cfmail>	
				
				<!--- log mail --->
				
				<cfquery name="Insert" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
					    INSERT INTO UserMail
						(Account,Source,Reference,MailAddress,MailSubject,MailBody,MailDateSent,MailStatus)
						VALUES
						('#Account#','Requisition','#attributes.id#','#sendto#','#line.mission# #des# #line.reference#','#body#',getDate(),'1')
						
				</cfquery>							
					
			</cfif>
					
	</cfoutput>

</cfif>	
	