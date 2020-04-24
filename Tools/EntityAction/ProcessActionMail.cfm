

<cfoutput>

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

<cfif select.recordcount eq "1">

   <!--- assign custom subject --->
   
   <cfset mailto = select.Mailto>
   <cfset mailcc = select.MailCc>
  
   <cfparam name="mailbcc"     default="">	
   <cfparam name="mailsubject" default="#select.mailsubject#">				
   <cfparam name="mailtext"    default="#select.mailbody#">		
				
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
			  <cfif sendto eq "">
			     <cfset sendto = "#Address.eMailAddress2#">
			  </cfif>
			  
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
  
  
  <!--- to be removed to prior to the text of the body 
  
  <cftry>
		    				
	  <cfloop index="att" from="1" to="10" step="1">
	   
		   <cfparam name="mailatt[#Att#][1]" default="none">
		   <cfparam name="mailatt[#Att#][2]" default="none">
		   <cfparam name="mailatt[#Att#][3]" default="none">
		  		  			   
	  </cfloop>											   
         
	  <cfcatch></cfcatch>
		   
  </cftry>		
  
  --->		

  <cfparam name="mailtext" default="">
  
  <cfswitch expression="#Mail.MailBody#">
			
		<cfcase value="Custom">
		      
			   <!--- 25/4/2012 this we can evaluate to add flyfields like
			   
			   Reference 1/2 @ref1 @ref2
			   workflow Link @link
			   The user triggering the mail @user
			   Action description @action 
			   todays date @today
			   
			  --->			 
			   		   
		      <cfset mailtext = Mail.MailBodyCustom>		
			  
			  <cfset htmllink = "<a href='#SESSION.root#/ActionView.cfm?id=#Object.Objectid#'><font color='0080FF'>Click here to process</font></a>">
			  
			  <cfset mailtext = replaceNoCase( "#mailtext#", "@link",      "#htmllink#",                                "ALL")>				
			  <cfset mailtext = replaceNoCase( "#mailtext#", "@user",      "#SESSION.first# #SESSION.last#",            "ALL")>
			  <cfset mailtext = replaceNoCase( "#mailtext#", "@ref1",      "#Object.ObjectReference#",                  "ALL")>
			  <cfset mailtext = replaceNoCase( "#mailtext#", "@ref2",      "#Object.ObjectReference2#",                 "ALL")>
			  <cfset mailtext = replaceNoCase( "#mailtext#", "@action",    "#Object.ActionDescription#",                "ALL")>
			  <cfset mailtext = replaceNoCase( "#mailtext#", "@mission",   "#Object.Mission#",                          "ALL")>
			  <cfset mailtext = replaceNoCase( "#mailtext#", "@owner",     "#Object.Owner#",                            "ALL")>
			  <cfset mailtext = replaceNoCase( "#mailtext#", "@holder",    "#Object.OfficerFirstName# #Object.OfficerLastName#",       "ALL")>	
			  <cfset mailtext = replaceNoCase( "#mailtext#", "@ipaddress", "#Object.OfficerNodeIP#",                    "ALL")>
			  <cfset mailtext = replaceNoCase( "#mailtext#", "@today",     "#dateformat(now(),CLIENT.DateFormatShow)#", "ALL")>
			  <cfset mailtext = replaceNoCase( "#mailtext#", "@time",      "#timeformat(now(),'HH:MM')#",               "ALL")>
			  <cfset mailtext = replaceNoCase( "#mailtext#", "@entity",    "#Object.EntityDescription#",                "ALL")>
 			  <cfset mailtext = replaceNoCase( "#mailtext#", "@class",     "#Object.EntityClassName#",                  "ALL")>
			  		  
		</cfcase>
		
		<cfcase value="Script">							   
		      <cfinclude template="../../#Mail.DocumentTemplate#">						   	 						   
		</cfcase>
		
  </cfswitch>	
  
</cfif>    				   			   
    
   <tr class="line">
    <td colspan="2" height="18" id="mailblock2" style="font-weight:200;font-size:20px;height;30px;padding-left:10px" class="labelmedium"><cf_tl id="Mail to be sent">:</td>
	</tr>
		
	<tr>				
	
	<td colspan="2" id="mailblock1">
   
	   <table width="97%" align="center" cellspacing="0" cellpadding="0" class="formpadding">	
	   
	     <tr>
		   <td width="90" class="labelmedium"><cf_tl id="Priority">:</td>
		   <td colspan="1">		
		   
		   <table>
		   <tr class="labelmedium">
		   				   
				<cfif Select.priority neq ""> 
			
				    <td><input type="radio" class="radiol" name="ActionMailPriority" id="ActionMailPriority" value="1" <cfif Select.priority eq "1">checked</cfif>></td><td>High</td> 
				    <td><input type="radio" class="radiol" name="ActionMailPriority" id="ActionMailPriority" value="2" <cfif Select.priority eq "2">checked</cfif>></td><td>Normal</td>
				    <td><input type="radio" class="radiol" name="ActionMailPriority" id="ActionMailPriority" value="3" <cfif Select.priority eq "3">checked</cfif>></td><td>Low</td>       
					 
			    <cfelse>          
				      
				    <td><input type="radio" class="radiol" name="ActionMailPriority" id="ActionMailPriority" value="1" <cfif Mail.mailpriority eq "1">checked</cfif>></td><td>High</td>
				    <td><input type="radio" class="radiol" name="ActionMailPriority" id="ActionMailPriority" value="2" <cfif Mail.mailpriority eq "2" or Mail.MailPriority eq "">checked</cfif>></td><td>Normal</td>
				    <td><input type="radio" class="radiol" name="ActionMailPriority" id="ActionMailPriority" value="3" <cfif Mail.mailpriority eq "3">checked</cfif>></td><td>Low</td>                
					  
   				</cfif>
			
			</tr>	
			</table>	

		   </td>
	     </tr>
	   
	     <!---
	     <cfif Mail.MailTo eq "Manual">
		 --->
		 
				 <tr>
				   <td width="90"><a title="click to select from address book" href="javascript:address()"><cf_tl id="To">:</a></td>
				   <td colspan="1">						   
				   
				   <cfinput type="Text"
					       name="sendto"
				    	   value="#mailto#"
					       message="Please enter a correct to: address"	   
					       required="Yes"
				    	   visible="Yes"	
						   maxlength="200"
				    	   class="regularxl enterastab"
					       style="width:100%">
				   
				   </td>
			   </tr>
			   
			   <tr>
				   <td width="90"><a title="click to select from address book" href="javascript:address()"><cf_tl id="Cc">:</a></b></td>
				   <td colspan="1">
				   
				      <cfinput type="Text"
				       name="sendcc"
			    	   value="#mailcc#"
				       message="Please enter a correct to: address"	   
				       required="Yes"
			    	   visible="Yes"	
					   maxlength="200"
			    	   class="regularxl enterastab"
				       style="width:100%">						   
				   				   
				   </td>
			   </tr>
			   
			    <tr>
				   <td width="90"><a title="click to select from address book" href="javascript:address()"><cf_tl id="Bcc">:</a></b></td>
				   <td colspan="1">
				   
				      <cfinput type="Text"
				       name="sendbcc"
			    	   value="#mailbcc#"
				       message="Please enter a correct to: address"	   
				       required="Yes"
			    	   visible="Yes"	
					   maxlength="200"
			    	   class="regularxl enterastab"
				       style="width:100%">		
					   
				   </td>
			   </tr>
		
		<!--- </cfif> --->
	      	     	  
	   <tr>
		   <td width="90"><cf_tl id="Subject">:</b></td>
		   <td colspan="1">
		   
		  	   <input type = "text"
				   name      = "ActionMailSubject"
				   id        = "ActionMailSubject"
				   value     = "#mailsubject#"
				   style     = "width:100%"
				   class     = "regularxl enterastab"
				   maxlength = "120">
		   </td>
	   </tr>
	   
	   <tr>
		 
	       <td height="300" colspan="2" style="padding-right:6px">
		   
		     <cfif findNoCase("cf_nocache",cgi.query_string)> 
		   		    									   
			     <cf_textarea height="300"   					 					
						color="ffffff" 
						toolbar="basic"								
						name="ActionMailBody" 
						resize="ture"
						style="width:100%">#mailtext#</cf_textarea>
					
			 <cfelse>
			 
				   <cf_textarea height="300"   
						init="Yes"      					
						color="ffffff" 
						toolbar="basic"			
						resize="true"					
						name="ActionMailBody" 
						style="width:100%">#mailtext#</cf_textarea>
			 			 
			 </cfif>		
							  							 
	      </td>
	  </tr>
	   
	   <cftry>
		   
		   <cfparam name="mailatt[1][1]" default="none">
		   
		   <cfif mailatt[1][1] neq "none">
	  			  		   
		   <tr>
			  <td colspan="1"><cf_tl id="Attachment">:</b></td>
			  <td>
		 
			  <!--- show attachment --->
			  <script LANGUAGE = "JavaScript">
				  function view(att) {
				  window.open(att, "Attachment", "width=850, height=660, menubar=yes, status=yes, toolbar=no, scrollbars=yes, resizable=yes"); }
			  </script>
						
			  <cfloop index="att" from="1" to="10" step="1">
			   
				   <cfparam name="mailatt[#Att#][1]" default="none">
				   <cfparam name="mailatt[#Att#][2]" default="none">
				   <cfparam name="mailatt[#Att#][3]" default="none">
				   
				   <cftry>
	
				   <cfif mailatt[att][1] neq "none" and mailatt[att][1] neq "inline">
				        <input type="checkbox" name="ActionMailAttachment" id="ActionMailAttachment" value="#mailatt[att][1]#" checked>
						<a href="javascript:view('#mailatt[att][2]#')">#mailatt[att][3]#</a>&nbsp;
				   <!--- <cfelse>
				   	 #mailatt[att][3]# --->
				   </cfif>
				   
				   <cfcatch></cfcatch>
				   
				   </cftry>
				  			   
			  </cfloop>											   
		      </td>
		   </tr>
		   
		   </cfif>
		   
		   <cfcatch></cfcatch>
		   
		</cftry>				 
	   
	   </table>				   
	   </td>			   
   </tr>			   
      
</cfoutput>   

<cfset ajaxOnLoad("doHighlight")>

<cfif findNoCase("cf_nocache",cgi.query_string)>
	<cfset ajaxonload("initTextArea")>
</cfif> 