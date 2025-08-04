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
<!--- mail --->

<cfif not DirectoryExists("#SESSION.rootPath#\CFRStage\user\#SESSION.acc#\")>
   <cfdirectory 
     action="CREATE" 
      directory="#SESSION.rootPath#\CFRStage\user\#SESSION.acc#\">

</cfif>

<cfquery name="Line" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT * 
	 FROM   RequisitionLine
	 WHERE  RequisitionNo = '#req#'
</cfquery>

<cfquery name="Parameter" 
	datasource="AppsPurchase"
	username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ParameterMission
	WHERE  Mission = '#Line.Mission#' 
</cfquery>

<cfquery name="User" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     	 SELECT * 
		 FROM   System.dbo.UserNames
		 WHERE  Account = '#Line.OfficerUserId#' OR Account IN (SELECT ActorUserId 
	                                                            FROM   RequisitionLineActor 
															    WHERE  RequisitionNo = '#req#'
															    AND    Role = 'ProcReqEntry' )
</cfquery>

<cfquery name="Language" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT * 
	 FROM   System.dbo.Ref_SystemLanguage
	 WHERE  SystemDefault = '1' 
</cfquery>

<cfsavecontent variable="printreq">
	<cfinclude template="ReqDeny.cfm">
</cfsavecontent>

<cffile action="WRITE" 
  file="#SESSION.rootpath#\CFRStage\user\#SESSION.acc#\req#Line.RequisitionNo#.htm" 
  output="#printreq#" 
  addnewline="Yes" 
  fixnewline="No">
  
<cfoutput query="User"> 
	
	<cfset to = "">
	
	<cfif eMailAddress eq "">
	   <cfset to = Parameter.DefaultEMailAddress>
	<cfelse>
	   <cfset to = eMailAddress>
	</cfif>
	
	<cfif client.email eq "" and client.emailext eq "">
	   <cfset from = Parameter.DefaultEMailAddress>
	<cfelseif client.eMail neq "">
	   <cfset from = client.email>
	<cfelse> 
	   <cfset from = CLIENT.eMailExt>   
	</cfif>	
	
	<cfif to neq "">
		
		<cfmail to       = "#to#"		        
		        from     = "#from#"
		        subject  = "#Line.RequestDescription#"
		        priority = "1"
		        mailerid = "#req#" 
		        type     = "HTML">
				
				
											
			<cfif CLIENT.LanPrefix eq "ESP" or (CLIENT.LanPrefix eq "" and Language.Code eq "ESP")> 
			
				<table align="center">
					<tr><td>La #Line.Reference# ha sido rechazada.</td></tr>
					<tr><td>Revise el archivo adjunto con informaci&oacute;n del rechazo para el seguimiento correspondiente.</td></tr>
				</table>	
			
			<cfelse>
			
								
				<table align="center">
				<tr><td>Your Procurement Requisition under No. #Line.RequisitionNo# has been reviewed and requires further clarification or was not approved.</td></tr>
				<tr><td>Please find attached the reasons for this action.</td></tr>
				</table> 

									
			</cfif>	
			
			<cfmailparam name="Disposition-Notification-To" 
			             value="#client.eMail#">	
			<cfmailparam file="#SESSION.rootpath#\CFRStage\user\#SESSION.acc#\req#Line.RequisitionNo#.htm" 
			             remove="yes">
						 
		 </cfmail>	
		 
		 <!--- log mail --->
				
		 <cfquery name="Insert" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
					
			    INSERT INTO System.dbo.UserMail
					(Account,
					 Source,
					 Reference,
					 MailAddress,
					 MailSubject,
					 MailDateSent,
					 MailStatus)
				VALUES
					('#Account#',
					 'Requisition',
					 '#line.reference#',
					 '#to#',
					 '#line.mission# #line.reference# Send Back',
					 getDate(),
					 '1')				
		  </cfquery>		
	
	</cfif>
				 
</cfoutput> 
