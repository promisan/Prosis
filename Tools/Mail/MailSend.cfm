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
 <cfquery name="Mail" 
  datasource="AppsSystem"
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
 	SELECT  *
	FROM    Parameter
 </cfquery>	
  	

<cfparam name="Attributes.Class"         default="">
<cfparam name="Attributes.ClassId"       default="">
<cfparam name="Attributes.ReferenceId"   default="">
<cfparam name="Attributes.BatchId"       default="">
<cfparam name="Attributes.ToClass"       default="">
<cfparam name="Attributes.To"            default="">
<cfparam name="Attributes.cc"            default="">
<cfparam name="Attributes.bcc"           default="">
<cfparam name="Attributes.From"          default="">
<cfparam name="Attributes.failto"        default="#Mail.DefaultEMail#">
<cfparam name="Attributes.Subject"       default="">
<cfparam name="Attributes.BodyContent"   default="">
<cfparam name="Attributes.Attachment"    default="">
<cfparam name="Attributes.SaveMail"      default="0"> <!--- save the mail and run this as a template --->
<cfparam name="Attributes.MailStatus"    default="1">
<cfparam name="Attributes.MailSend"      default="Yes">

<cf_assignid>

<!--- TO --->

<cfif attributes.ToClass eq "User" and not isValid("email",attributes.To)>

	 <cfquery name="getUser" 
	       datasource="AppsMaterials" 
	       username="#SESSION.login#" 
	       password="#SESSION.dbpw#">	    
		   SELECT *
		   FROM   System.dbo.UserNames	
		   WHERE  Account = '#attributes.To#'		
	</cfquery>
	
	<cfset attributes.to = "">
			
	<cfif getUser.recordcount eq "1">
									
		<cfif isValid("eMail",getUser.eMailAddress)>					
			<cfset attributes.to = getUser.eMailAddress>				
		<cfelseif isValid("email",getUser.eMailAddressExternal)>				
			<cfset attributes.to = getUser.eMailAddressExternal>				
		</cfif>
		
	</cfif>	

</cfif>


<!--- FROM --->

<cfif attributes.From eq "">
	
	<cfif isValid("eMail",client.eMail)>
	
	    <cfset attributes.from = "#session.first# #session.last# <#client.eMail#>">
	
	<cfelseif isValid("eMail",client.eMailExt)>
	
		<cfset attributes.from = "#session.first# #session.last# <#client.eMailExt#>">
	
	<cfelse>
	
		<cfset attributes.from = "#Mail.DefaultEMail#">
	
	</cfif>

</cfif>

<!--- Disabling the mailreply address if the system parameter is 0---->
<cfif Mail.ReplyTo eq "0">
	 <cfset mailreply="">
<cfelse>
	 <cfset mailreply="#Attributes.failto#">
</cfif>

<cfset body       = attributes.bodycontent>

<cfif attributes.Attachment neq "">
	<cfset attachment = "#attributes.Attachment#">
<cfelse>
	<cfset attachment = "">	
</cfif>

<cfset mailstatus = attributes.mailstatus>

<cfif attributes.mailsend eq "No" or Attributes.To eq "">
	<cfset mailstatus = "9">
</cfif>
	

<cfif attributes.MailSend eq "Yes" and Attributes.To neq "">
	
	 <cfdirectory action="LIST"
	    directory="#SESSION.rootDocumentPath#\Mail\#SESSION.acc#"
	    name="add"
	    filter="*.*"
	    sort="DateLastModified DESC"
	    type="all"
	    listinfo="name">			
						
     <cfif Attributes.Savemail eq "1">	 
	 	 
		  <cftry>
			   <cffile action = "delete" 
			           file = "#SESSION.rootpath#\CFRStage\User\#SESSION.acc#\#SESSION.acc#readme.cfm">  
			   <cfcatch></cfcatch>
		  </cftry>				 

		  <!--- generate the mail and save it as a cfm --->			  		  	
	      <cffile action = "append"
		 	      file = "#SESSION.rootpath#\CFRStage\User\#SESSION.acc#\#SESSION.acc#readme.cfm"
			      output = "<cfoutput>#Attributes.BodyContent#</cfoutput>"
			      addNewLine = "Yes"> 		
		     	
		  <cftry> 			  
		    
			<cfmail TO     = "#Attributes.To#"
			   CC          = "#attributes.cc#"
			   BCC         = "#attributes.bcc#"
		       FROM        = "#Attributes.From#"
			   Priority    = "1"
			   SUBJECT     = "#Attributes.Subject#"
			   failTo      = "#Attributes.Failto#" 
			   replyto     = "#mailreply#"
			   mailerID    = "#SESSION.welcome#"
			   TYPE        = "html"
			   spoolEnable = "Yes">
			   		
				<!--- run the template used for evaluation --->		
		  		<cfinclude template="../../CFRStage/User/#SESSION.acc#/#SESSION.acc#readme.cfm">
				
				<cfloop index="att" list="#attachment#" delimiters=","> 
				     <cfmailparam file = "#SESSION.root#/CFRStage/User/#SESSION.acc#/#Att#">
				</cfloop>   
				
				<cfloop query="add">
				     <cfmailparam remove = "yes" 
					              file   = "#SESSION.rootDocumentPath#\Mail\#SESSION.acc#\#name#">
				</cfloop>
				
				<!--- add the disclaimer --->
				<cf_maildisclaimer context="template" id="#rowguid#">
						
			  </cfmail>						
			  				  				   
			   <cftry>			
			   <cffile action = "delete" file = "#SESSION.rootpath#\CFRStage\User\#SESSION.acc#\#SESSION.acc#readme.cfm">  
			   <cfcatch></cfcatch>
			   </cftry>
			   					   
			   <cfcatch>
			   				 
					 <cfmail TO         = "#Attributes.To#"
						   cc           = "#attributes.cc#"
						   bcc          = "#attributes.bcc#"
					       FROM         = "#Attributes.From#"
						   SUBJECT      = "#Attributes.Subject#"
						   FailTo       = "#Attributes.Failto#" 
						   replyto      = "#mailreply#"
						   mailerID     = "#SESSION.welcome#"
						   TYPE         = "html"
						   spoolEnable  = "Yes">
					  
					   <cfoutput>#Attributes.BodyContent#</cfoutput>						   			   
								   
					    <!--- disclaimer --->
						<cf_maildisclaimer context="direct" id="#rowguid#">
						
					 </cfmail>						 			
					 						 
					 <cffile action = "delete" file = "#SESSION.rootpath#\CFRStage\User\#SESSION.acc#\#SESSION.acc#readme.cfm">  
								 
				</cfcatch>  
				
		    </cftry>  			
			
			<cfset body = Attributes.BodyContent>	
		
	<cfelse>  <!--- direct sending from application --->
			   										
			 <cfmail to="#Attributes.To#"
			    cc         = "#attributes.cc#"
				bcc        = "#attributes.bcc#"
		        from       = "#Attributes.From#"
				FailTo     = "#Attributes.Failto#" 
				replyto    = "#mailreply#"
		        subject    = "#Attributes.Subject#"		       
		        type       = "HTML"
		        mailerID   = "#SESSION.welcome#"
		        spoolEnable= "Yes">
												
				<cfoutput>#Attributes.BodyContent#</cfoutput>
				
				<!--- disclaimer --->
				<cf_maildisclaimer context="#attributes.class#" id="#rowguid#">	 
								
				<cfif attachment neq "" or attributes.class neq "">																
					<cfinclude template="MailAttachment.cfm">
				</cfif>
											
				<cfloop query="add">				
				     <cfmailparam remove="yes" file = "#SESSION.rootDocumentPath#\Mail\#SESSION.acc#\#name#">
				</cfloop>				
											
			</cfmail>
										
			<cfset body = Attributes.BodyContent>			
			
	 </cfif>		
			
</cfif>	

<!-- register a mail record --->

<cfif Attributes.class neq "">

	<cfswitch expression="#Attributes.class#">
	
		<cfcase value="Applicant">
					  		
			   <cfif Attributes.ReferenceId neq "">
					  <cfset action = "#Attributes.ReferenceId#">
			   <cfelse>
					  <cf_RosterActionNo ActionRemarks="eMail" ActionCode="MAIL"> 
					  <cfset action = rosterActionNo> 
			   </cfif>
			
			   <cfquery name="Insert" 
				   datasource="AppsSelection" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
					INSERT INTO ApplicantMail
						  (  MailId,
						     PersonNo,
							<cfif Attributes.ReferenceId neq "">
							 ApplicantNo,
							 FunctionId,
							</cfif> 
							 <cfif Attributes.BatchId neq "">
							 MailBatchId,
							 </cfif>
							 RosterActionNo, 					 
							 MailAddress, 
							 MailAddressFrom, 
							 MailSubject, 
							 MailBody, 
							 MailStatus)
					VALUES ('#rowguid#',
					        '#Attributes.ClassId#', 
						   <cfif Attributes.ReferenceId neq "">	
					       '#Attributes.ApplicantNo#',
						   '#Attributes.FunctionId#',
						   </cfif>
						    <cfif Attributes.BatchId neq "">
					 		'#Attributes.BatchId#',
					 		</cfif>
						   '#Action#', 
						   '#attributes.to#',
						   '#Attributes.FROM#',
						   '#Attributes.Subject#', 
						   '#body#',
						   '#Attributes.mailstatus#')
				</cfquery>
				
		</cfcase>	
		
		<cfdefaultcase>	
		
		  		<cftry>		
					
					<cfquery name="Insert" 
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						INSERT INTO UserMail
								(MailId,
								 Account,
								 Source, 
								 SourceId, 
								 Reference, 
								 MailAddress, 
								 MailAddressFrom, 
								 MailSubject, 
								 MailBody, 
								 MailStatus)
						VALUES ('#rowguid#',
						        '#SESSION.acc#',
						        '#Attributes.Class#',
							    <cfif len(Attributes.ClassId) lte "20">NULL<cfelse>'#Attributes.ClassId#'</cfif>, 
						        '#Attributes.ReferenceId#', 
							    '#Attributes.TO#',
							    '#Attributes.FROM#',
							    '#Attributes.Subject#', 
							    '#body#',
							    '#Attributes.mailstatus#')
					</cfquery>
				
					<cfcatch></cfcatch>
				
				</cftry>	    
					
		</cfdefaultcase>	
		
	</cfswitch>
	

</cfif>

<cftry>

		<cffile action = "delete" 
		   file = "#SESSION.rootpath#\Tools\EntityAction\Temp\#SESSION.acc#readme.cfm">  
		   <cfcatch></cfcatch>
		   
</cftry>	   
		

