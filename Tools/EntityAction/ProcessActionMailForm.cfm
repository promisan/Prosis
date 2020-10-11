
<cfoutput>


<cfparam name="sendto"    default="">		

<!--- define if a record already exists --->

<cfquery name="Select" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT TOP 1 * 
	FROM   OrganizationObjectActionMail
	WHERE  ObjectId   = '#Object.ObjectId#'
	AND    ActionCode = '#Action.ActionCode#'
	ORDER BY Created DESC
</cfquery>

<!--- retrieve the last records --->

<cfif select.recordcount eq "1">

   <!--- assign custom subject --->
   
   <cfset mailto = select.Mailto>
   <cfset mailcc = select.MailCc>
  
   <cfparam name="mailbcc"     default="">	
   <cfparam name="mailsubject" default="#select.mailsubject#">				
   <cfparam name="mailtext"    default="#select.mailbody#">	
   
   <cfquery name="att" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   OrganizationObjectActionMailAttach
		WHERE  ThreadId   = '#Select.ThreadId#'
		AND    SerialNo   = '#Select.SerialNo#'	
		ORDER BY Created DESC
	</cfquery>
	
	<cfset mailatt = ArrayNew(2)>
	
	<cfset i = 0>
		
	<cfloop query="att">
		
		<cfset i= i +1>
		<cfset mailatt[i][1]="#attachmentPath#">
		<cfset mailatt[i][2]="#attachmentDisposition#">
		<cfset mailatt[i][3]="#attachmentName#">
	
	</cfloop>
					
<cfelse>		
  	   
   <cfif Mail.DocumentTemplate neq "">																		   
		  <cfinclude template="../../#Mail.DocumentTemplate#">			  								
   </cfif>
     
   <!--- retrieve the addressee --->
   
   <cfswitch expression="#Mail.MailTo#">		
   
  		<cfcase value="Holder">
					
			<cfif Object.PersonEMail neq "">
					
			 	<cfset sendto = "#Object.PersoneMail#">
									 
	 		<cfelseif Object.PersonClass eq "Employee">
	  
		      <cfquery name="Address" 
				datasource="AppsOrganization"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
		  		 SELECT  *
				 FROM    Employee.dbo.Person
				 WHERE   PersonNo = '#Object.PersonNo#' 
			  </cfquery>	
				  
			  <cfset sendto = "#Address.eMailAddress#"> 
		  
			<cfelseif Object.PersonClass eq "Candidate">
	
		 	  <cfquery name="Address" 
				datasource="AppsOrganization"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
		  		 SELECT  *  
				 FROM    Applicant.dbo.Applicant
				 WHERE   PersonNo = '#Object.PersonNo#' 
			  </cfquery>	
				  
			  <cfset sendto = "#Address.eMailAddress#">   
						  
		   <cfelse>
		   		
				<!--- should never occur --->	   
		      	<cfset sendto = "vanpelt@promisan.com">  
		  
		   </cfif> 	
		
		</cfcase>
			
		<cfcase value="List">
			
				<cfquery name="Address" 
					datasource="AppsOrganization"
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
			  		 SELECT  *
					 FROM    Ref_EntityDocumentRecipient
					 WHERE   DocumentId = '#Mail.DocumentId#'
					 <cfif Object.Mission neq ""> 
					 AND     Mission    = '#Object.Mission#' 
					 <cfelse>
					 AND     Mission is NULL
					 </cfif>
					 AND     EntityClass is NULL
					 AND     ActionCode is NULL
					 AND     Operational = 1
					 UNION
					 SELECT  *
					 FROM    Ref_EntityDocumentRecipient
					 WHERE   DocumentId   = '#Mail.DocumentId#' 
					 <cfif Object.Mission neq ""> 
					 AND     Mission      = '#Object.Mission#'
					 <cfelse>
					 AND     Mission is NULL
					 </cfif>
					 AND     EntityClass  = '#Object.EntityClass#'
					 AND     ActionCode   = '#Object.ActionCode#'
					 AND     Operational = 1				 
				  </cfquery>	
				 			  
				  <cfloop query="Address">
				  
				    <cfparam name="sendto" default="">
				  
				  	<cfif isValid("email", "#eMailAddress#")> 
				  
						 <cfif sendto eq "">
						  <cfset sendto = "#emailaddress#">
						 <cfelse>
						  <cfset sendto = "#sendto#,#emailaddress#">
						 </cfif> 		  
						 
					</cfif>	 
				  
				  </cfloop>
				  
				  <cfif sendto eq "">
				  	<!--- should never occur --->	   
			      	<cfset sendto = "vanpelt@promisan.com"> 
				  </cfif>	 
				  				
		</cfcase>
		
		<cfcase value="Custom">
			
				 <cfquery name="CustomTo" 
					datasource="AppsOrganization"
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT   *
					FROM     OrganizationObjectInformation
					WHERE    DocumentId = '#Mail.DocumentId#'
					AND      ObjectId     = '#Object.ObjectId#'	  		
				  </cfquery>	
			
				  <cfif CustomTo.DocumentItemValue neq "">
				  
				  	<cfset sendto = "#CustomTo.DocumentItemValue#">  
				  
				  <cfelse>
				  
				  	<!--- should never occur --->	   
			      	<cfset sendto = "vanpelt@promisan.com">  
				  
				  </cfif>
			
		</cfcase>
   
   	</cfswitch>
	
    <cfparam name="sendto"   default="">  		
		
	<cfparam name="mailto"   default="#sendto#">
	
	<!--- adjusted 15/11/2012 to ensure it has a value --->
	<cfif mailto eq "">
		 <cfset mailto = sendto>
	</cfif>	
		
	<cfparam name="mailcc"   default="">
	<cfparam name="mailbcc"  default="">	
		      
    <!--- assign custom subject --->
   	
   <cfparam name="mailsubject" default="">
  	   
   <cfswitch expression="#Mail.MailSubject#">

		<cfcase value="Object">
		      <cfset mailSubject = Object.ObjectReference>						
		</cfcase>
		
		<cfcase value="Action">
		      <cfset mailSubject = Action.ActionDescription>						
		</cfcase>
		
		<cfcase value="Custom">
		      <cfset mailSubject = Mail.MailSubjectCustom>						
		</cfcase>
		
		<cfcase value="Script">		
													   
		   	  <cfinclude template="../../#Mail.DocumentTemplate#">						   	 						   
			  
		</cfcase>
		
  </cfswitch>	

  <cfparam name="mailtext" default="">
  
  <cfswitch expression="#Mail.MailBody#">
			
		<cfcase value="Custom">
		      			  			  			  
			   <cfinvoke component = "Service.Process.System.Mail"  
				   method           = "MailContentConversion" 
				   objectId         = "#Object.ObjectId#" 	
				   content          = "#Mail.MailBodyCustom#"			  
				   returnvariable   = "mailtext">	  				 
				   			  		  
		</cfcase>
		
		<cfcase value="Script">		
							   
		      <cfinclude template="../../#Mail.DocumentTemplate#">						   	 						   
			  
		</cfcase>
		
  </cfswitch>	
  
</cfif>    				   			   
    
   <tr class="line">
    <td colspan="2"id="mailblock2" style="font-weight:200;font-size:22px;height:46px;padding-top:10px;padding-left:10px" class="labelmedium">	
	<cf_tl id="Mail to be sent upon submission">:
	</td>
   </tr>
	
   <tr class="line">				
	
	<td colspan="2" id="mailblock1" style="padding-bottom:5px;padding-top:5px">
	
		<cfparam name="mailfrom" default="">
	   <input type="hidden" name="ActionMailFrom" value="#mailfrom#">
	   
	   <table width="97%" align="center" class="formspacing">	
	   
	     <tr><td colspan="2"></td></tr>
	     <tr>
		   <td style="color:gray;padding-left:10px" width="90" class="labelmedium"><cf_tl id="Priority">:</b></td>
		   <td colspan="1">		
		     		
				<table>
			    <tr class="labelmedium">	
		   				   
				<cfif Select.priority neq ""> 
			
				    <td><input type="radio" class="radiol" name="ActionMailPriority" id="ActionMailPriority" value="1" <cfif Select.priority eq "1">checked</cfif>></td><td class="labelit" style="padding-left:6px"><font color="red"><cf_tl id="Priority High"></td> 
				    <td style="padding-left:6px"><input type="radio" class="radiol" name="ActionMailPriority" id="ActionMailPriority" value="2" <cfif Select.priority eq "2">checked</cfif>></td><td class="labelit" style="padding-left:6px"><font color="green"><cf_tl id="Normal"></td> 
				    <td style="padding-left:6px"><input type="radio" class="radiol" name="ActionMailPriority" id="ActionMailPriority" value="3" <cfif Select.priority eq "3">checked</cfif>></td><td class="labelit" style="padding-left:6px"><font color="blue"><cf_tl id="Priority Low"></td>    
					<td style="padding-left:6px"><input type="radio" class="radiol" name="ActionMailPriority" id="ActionMailPriority" value="0" <cfif Select.priority eq "0">checked</cfif>></td><td class="labelit" style="padding-left:6px"><font color="gray"><cf_tl id="Do not send"></font></td>     
					 
			    <cfelse>          
				      
				    <td><input type="radio" class="radiol" name="ActionMailPriority" id="ActionMailPriority" value="1" <cfif Mail.mailpriority eq "1">checked</cfif>></td><td class="labelit" style="padding-left:6px"><font color="red"><cf_tl id="Priority High"></td> 
				    <td style="padding-left:6px"><input type="radio" class="radiol" name="ActionMailPriority" id="ActionMailPriority" value="2" <cfif Mail.mailpriority eq "2" or Mail.MailPriority eq "">checked</cfif>></td><td class="labelit" style="padding-left:6px"><font color="green"><cf_tl id="Normal"></td> 
				    <td style="padding-left:6px"><input type="radio" class="radiol" name="ActionMailPriority" id="ActionMailPriority" value="3" <cfif Mail.mailpriority eq "3">checked</cfif>></td><td class="labelit" style="padding-left:6px"><font color="blue"><cf_tl id="Priority Low"></td>   
					<td style="padding-left:6px"><input type="radio" class="radiol" name="ActionMailPriority" id="ActionMailPriority" value="0" <cfif Mail.mailpriority eq "0">checked</cfif>></td><td class="labelit" style="padding-left:6px"><font color="gray"><cf_tl id="Do not send"></font></td>                 
					  
   				</cfif>
				
				</tr>	
			</table>	

		   </td>
	     </tr>
	   
	     <!---
	     <cfif Mail.MailTo eq "Manual">
		 --->
		 
				 <tr>
				   <td style="padding-left:10px" width="90" class="labelmedium"><a title="click to select from address book" href="javascript:address()"><cf_tl id="To">:</a></td>
				   <td colspan="1">						   
				   
				   <cfinput type="Text"
					       name="sendto"
						   id="sendTO"
				    	   value="#mailto#"
					       message="Please enter a correct to: address"	   
					       required="Yes"
				    	   visible="Yes"	
						   maxlength="200"
				    	   class="regularxl enterastab"
					       style="width:99%">
				   
				   </td>
			   </tr>
			   
			   <tr>
				   <td style="padding-left:10px" width="90" class="labelmedium"><a title="click to select from address book" href="javascript:address()"><cf_tl id="Cc">:</a></b></td>
				   <td colspan="1">
				   
				      <cfinput type="Text"
					       name="sendcc"
						   id="sendCC"
				    	   value="#mailcc#"
					       message="Please enter a correct to: address"	   
					       required="Yes"
				    	   visible="Yes"	
						   maxlength="200"
				    	   class="regularxl enterastab"
					       style="width:99%">						   
				   				   
				   </td>
			   </tr>
			   
			    <tr>
				   <td style="padding-left:10px" width="90" class="labelmedium"><a title="click to select from address book" href="javascript:address()"><cf_tl id="Bcc">:</a></b></td>
				   <td colspan="1">
				   
				      <cfinput type="Text"
					       name="sendbcc"
						   id="sendBCC"
				    	   value="#mailbcc#"
					       message="Please enter a correct to: address"	   
					       required="Yes"
				    	   visible="Yes"	
						   maxlength="200"
				    	   class="regularxl enterastab"
					       style="width:99%">		
					   
				   </td>
			   </tr>
		
		<!--- </cfif> --->
	      	     	  
	   <tr>
		   <td style="padding-left:10px" width="90" class="labelmedium"><cf_tl id="Subject">:</b></td>
		   <td colspan="1">
		   
		  	   <input type = "text"
				   name      = "ActionMailSubject"
				   id        = "ActionMailSubject"
				   value     = "#mailsubject#"
				   style     = "width:99%"
				   class     = "regularxl enterastab"
				   maxlength = "120">
			   
		   </td>
	   </tr>
	   
	   <tr>
		 
	       <td height="140" colspan="2" style="padding-left:10px;padding-top:5px;border:0px solid silver;padding-right:4px;padding-left:2px">
		   
		   <cfif findNoCase("cf_nocache",cgi.query_string)> 
		   
		   <!--- toolbar="basic" --->
		   
		   	<cf_textarea height="180"   
					color="ffffff"
					toolbar="basic"	
					resize="false"					
					name="ActionMailBody" 
					style="width:100%">#mailtext#</cf_textarea>
		   
		   <cfelse>
		   		   		   	
				  <cf_textarea height="180"   
					color="ffffff" 
					toolbar="basic"	
					resize="false"		
					init="Yes"				
					name="ActionMailBody" 
					style="width:100%">#mailtext#</cf_textarea>
					
			</cfif>			
				
		  							 
	      </td>
	  </tr>
	  	  
	<cfquery name="Entity" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT TOP 1 * 
		FROM   Ref_Entity
		WHERE  EntityCode = '#Object.EntityCode#'		
	</cfquery>
	  
	  <cfparam name="rw" default="0">
	  
	  <!--- option to attach object related attachment has been turned on --->
	  
	  <cfif Action.PersonMailObjectAttach eq "1" and Entity.DocumentPathName neq "">
	  													
			<cf_fileExist
				DocumentPath  = "#Entity.DocumentPathName#"
				SubDirectory  = "#Object.ObjectId#" 
				Filter        = ""					
				ListInfo      = "all">		
			
			<cfif filelist.recordcount eq "0">
			
				<cf_fileExist
					DocumentPath  = "#Entity.DocumentPathName#"
					SubDirectory  = "#Object.ObjectKeyValue4#" 
					Filter        = ""					
					ListInfo      = "all">		
								
			</cfif>		
							
			<!--- returns a query object filelist --->
			
			<cfloop query="filelist">
			
				<cfquery name="qAttachment" 
				  datasource="AppsSystem" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#"> 
					SELECT * 
					FROM   Attachment
					WHERE  Reference        = '#Object.ObjectId#'
					AND    DocumentPathName = '#Entity.DocumentPathName#'
					AND    FileName         = '#name#'							
				</cfquery>
				   
				   <cfif qAttachment.fileStatus neq "9">
				   				
						<!--- was not deleted so we attach it to the array  --->
						<cfset rw = rw +1>
						<cfset mailatt[rw][1]="#directory#\#name#">	
						<cfset mailatt[rw][2]="normal">	
						<cfset mailatt[rw][3]="#name#">	
					
				   </cfif>
				   
				 	
			
			</cfloop>					
				
	</cfif> 
		   
	<cftry>
		   
		   <cfparam name="mailatt[1][1]" default="none">
		   		   
		   <cfif mailatt[1][1] neq "none">
		   	  			  		   
		   <tr>
			  <td colspan="1"><cf_tl id="Attachment">:</b></td>
			  <td>
		 
			  <!--- show attachment --->
			  <script LANGUAGE = "JavaScript">
				  function view(att) {				 
				  	ptoken.open('#session.root#/tools/document/FileRead.cfm?id='+att, 'Attachment'); 
				  }
			  </script>
			  			  
			  <table>
			  <tr class="labelmedium">	
			  	
			  <cfloop index="att" from="1" to="10" step="1">
			   
				   <cfparam name="mailatt[#Att#][1]" default="none">
				   <cfparam name="mailatt[#Att#][2]" default="normal">
				   <cfparam name="mailatt[#Att#][3]" default="">
				   				   
				   <cftry>
	
					   <cfif mailatt[att][1] neq "none">
					   
					   		<!--- we record the attachment in ref_attachment --->
							
							<cf_assignId>
							
							<!--- populate the attachment table so we can open it --->
							
							<cfset path = replaceNoCase(mailatt[att][1],mailatt[att][3],"")> 
													
							<cfquery name="InsertAtt" 
								datasource="AppsSystem"
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								INSERT INTO Attachment 
								(AttachmentId, DocumentPathName, Server, ServerPath, FileName, FileStatus, OfficerUserId, OfficerLastName, OfficerFirstName)
								VALUES ('#rowguid#','Mail','Custom','#path#','#mailatt[att][3]#','9','#session.acc#','#session.last#','#session.first#')					  		
							</cfquery>							 
											   
					        <td style="padding-right:4px">
							
					        <input type="checkbox" class="radiol"
							    name  = "ActionMailAttachment" 
								id    = "ActionMailAttachment" 
								value = "#att#" checked>							
							</td>	
							<td style="padding-right:10px"><a href="javascript:view('#rowguid#')">#mailatt[att][3]#</a></td>
													
					   <cfelse>
					   
					   </cfif>
				   
				   <cfcatch></cfcatch>
				   
				   </cftry>
				  			   
			  </cfloop>		
			  </tr>
			  </table>
			  									   
		      </td>
		   </tr>
		   
		   </cfif>
		   
		   <cfcatch></cfcatch>
		   
		   </cftry>				 
	   
	   </table>				   
	   </td>			   
   </tr>			   
      
</cfoutput>   

<cfset AjaxOnLoad("initTextArea")>
