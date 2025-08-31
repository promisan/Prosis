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
<cf_param name="URL.ID"      default=""		     type="string">
<cf_param name="URL.ID1"     default=""          type="string">
<cf_param name="URL.Subject" default="#URL.ID1#" type="string">
<cf_param name="URL.Content" default=""          type="string">
<cf_param name="URL.ID2"     default=""          type="string">
<cf_param name="URL.ID3"     default=""          type="string">
<cf_param name="URL.Mode"    default="dialog"    type="string">

<cfparam name="att"         default="">

<cfif url.mode eq "Dialog">
	<cf_screentop height="100%" jquery="Yes" scroll="no" html="Yes" banner="gray" band="No" layout="webapp" label="New Message">	
<cfelse>
	<cf_screentop height="100%" jquery="Yes" scroll="no" html="No" ValidateSession="Yes">	
</cfif>

<cf_textareascript>

<script language="JavaScript">

	function address() {
	to  = document.getElementById("sendTO")
	cc  = document.getElementById("sendCC")
	bcc = document.getElementById("sendBCC")
	
	ProsisUI.createWindow('addressdialog', 'Address book', '',{x:100,y:100,height:document.body.clientHeight-80,width:document.body.clientWidth-80,modal:true,center:true})    				
	ptoken.navigate('AddressBook.cfm?to='+to.value+'&cc='+cc.value+'&bcc='+bcc.value,'addressdialog') 	
	
	}

</script>

<cfquery name="User" 
   datasource="AppsSystem" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	  SELECT *
	  FROM  UserNames
	  WHERE Account = '#SESSION.acc#'
</cfquery>

<cfif URL.Mode eq "Dialog" or URL.Mode eq "cfwindow">
	<cfset colorheader = "">
    <cfset colorbg = "f9f9f9">
	<cfset colorfont = "white">
	<cfset button = "Button10g">
<cfelse>
   <!--- check maybe reporting framework ? --->
   <cfif URL.GUI eq "HTML">
	    <cfset colorheader = "f0f0f0">
		<!--- <cfset colorbg = "E0E0E0"> --->
		<cfset colorbg = "ffffff">
		<cfset button = "Button10g">
		<cfset colorfont = "black">
   <cfelse>
	    <cfset colorheader = "DEE9EB">
		<cfset colorbg = "f4f4f4">
		<cfset button = "Button10g">
		<cfset colorfont = "black">
   </cfif>	
</cfif>

<!--- define if mail should be stored --->
<cfparam name="URL.Source"     default="Manual">
<cfparam name="URL.SourceId"   default="">
<cfparam name="CLIENT.Filter"  default="">

<cfswitch expression="#URL.Source#">

	<cfcase value="Applicant">
	
		<cfquery name="To" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT FirstName+' '+LastName as Name, 
		         Nationality
		  FROM   Applicant
		  WHERE  PersonNo = '#URL.SourceId#'
		</cfquery>

	</cfcase>

	<cfcase value="User">
	
		<cfquery name="To" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT FirstName+' '+LastName as Name, '' as Nationality
		  FROM   UserNames
		  WHERE  Account = '#URL.SourceId#'
		</cfquery>

	</cfcase>
	
	<cfcase value="Person">
	
		<cfquery name="To" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT FirstName+' '+LastName as Name, 
		         Nationality
		  FROM   Person
		  WHERE  PersonNo = '#URL.SourceId#'
		</cfquery>

	</cfcase>
	
	<cfcase value="Action">
		
	</cfcase>

</cfswitch>

<cfoutput> 

<table width="100%" style="height:98.5%">

<tr><td>

	<cfform action="MailVerify.cfm?id1=#url.id1#&Mode=#URL.Mode#" 
	        method="post" 
			style="height:98.5%"
			name="mail" 
			target="mailsubmit">	
				 
	<table width="99%" align="center" height="100%">
		
	<tr class="hide"><td colspan="2"><iframe name="mailsubmit" id="mailsubmit"></iframe></td></tr>
	
	<tr class="line">
	
	   <td height="40" style="padding-left:4px;padding-top:8px">
	     
	    <button type="submit" style="font-size:15px;height:30px;width:100px;padding:2px;" class="button10g"><cf_tl id="Send"></button>
			
		<cfif URL.Mode eq "Dialog">
		    <!---
		    <input type="button" name="close" id="close" class="#button#" value="Cancel" onClick="window.close()">
			--->
		<cfelseif url.mode eq "cfwindow">	
			 <input type="button" name="close" id="close" style="font-size:15px;height:30px;width:100px;padding:2px;" class="button10g" value="Close" onClick="parent.ProsisUI.closeWindow('maildialog')">	
		    <!--- disabled the full view dialog back
			<input type="button" name="Back" class="#button#" value="Back" onclick="history.back(-1)">
			--->
		</cfif>
			
		<input type="hidden" name="source"   id="source"   value="#URL.Source#">
		<input type="hidden" name="sourceId" id="sourceId" value="#URL.SourceId#"> 
		
		<cfif url.source eq "Listing">
		
				<cfquery name="Reply" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">				
					SELECT   C.NotificationEMail
					FROM     UserReport U INNER JOIN
			                 Ref_ReportControlLayout L ON U.LayoutId = L.LayoutId INNER JOIN
			                 Ref_ReportControl C ON L.ControlId = C.ControlId
					WHERE    U.ReportId = '#URL.SourceId#'					
				</cfquery>
		
				<input type="hidden" name="reply" id="reply" value="#Reply.NotificationEMail#">
				<cfset reply = Reply.NotificationEMail>
				
		<cfelse>	
		
				<input type="hidden" name="reply" id="reply" value="">
				<cfset reply = "">	
		
		</cfif>
			
		<cfif URL.ID3 is not "">
	  		 <input type="hidden" name="filter" id="filter" value="#URL.ID3#" size="50" class="regular">
		<cfelse>
		     <input type="hidden" name="filter" id="filter" value="#CLIENT.Filter#" size="50" class="regular">
		</cfif>	
		
	   </td>
	   
	   <td align="right"><!--- &nbsp;&nbsp;Message #URL.Source#&nbsp;&nbsp; ---></td>
	   
	   </tr>
	  
	   <tr><td colspan="2" height="7"></td></tr>
		<tr>
		<td width="31%" valign="top">
			<table width="100%">
			<tr><td height="4" colspan="2"></td></tr>
			
			 <!--- Field: SentFROM --->
		    <tr>
		    <td class="labelmedium" valign="top" style="min-width:60px;padding-left:20px"><b><cf_tl id="From">:</TD>
			<td style="width:80%" valign="top">
			
				<table><tr><td class="labelmedium" style="cursor:pointer" title="#Client.eMail#">
				
				<cfquery name="Parameter" 
				   datasource="AppsSystem" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
					  SELECT *	
					  FROM   Parameter
				</cfquery>
				
				<cfif SESSION.acc eq Parameter.AnonymousUserid>
				 
					 <cfinput type = "Text"
				       name        = "SentFROM_Name"
				       value       = ""
				       message     = ""
					   class       = "regularxl"
				       required    = "Yes"
				       visible     = "Yes"
				       enabled     = "Yes"
				       size        = "50"
				       maxlength   = "50">
					   
				<cfelse>
				 
				       <cfoutput>
					        #SESSION.first# #SESSION.last#				
					        <input type="hidden" name="SentFROM_Name" id="SentFROM_Name" value="#SESSION.first# #SESSION.last#">							
					   </cfoutput>
					   
				</cfif>	  
				
				<td><tr>
				
				<tr><td class="labelmedium">
				
				   <cfif SESSION.acc eq Parameter.AnonymousUserid>
				   
					   <cfoutput>
					   <input type="Hidden" name="SentFROM" id="SentFROM" value="">
					   </cfoutput>
				
				   <cfelseif CLIENT.eMail eq "">
				   
					 <cfinput type="Text"
				       name="SentFROM"
				       value="#CLIENT.eMail#"
				       message="Please enter a valid From address"
				       validate="email"
				       required="Yes"
					   class="regularxl"
				       visible="Yes"
				       enabled="Yes"
				       size="30"
				       maxlength="50">
					   
				   <cfelse>
				   
				       <cfoutput>
					       <input type="hidden" name="SentFROM" id="SentFROM" value="#CLIENT.eMail#">
					   </cfoutput>
						
					</cfif>	  
					
					   <br>
					   <cfif reply neq "">						
						<font color="808080"><cf_tl id="reply to">:</font>#reply#
					   </cfif>
								   
			    </TD>
				</TR>	
				</table>
		    </td></tr>
			</table>
		</td>
		
		<td align="right" valign="top">
			<table width="100%">
		  	   <!--- Field: SendTO --->
			<TR>
		    <td class="labelmedium" width="100" height="22"><a href="javascript:address()"><cf_tl id="To">:</a></td>
			<TD width="85%" class="labelmedium" >
			   <cfoutput>
			   		   		   
				<cfif URL.Source eq "Manual" or 
					URL.Source eq "Report" or 
					URL.Source eq "ReportConfig">
										
					  <cfinput type="Text"
					       name="sendTO"
					       value="#URL.ID#"
					       message="Please enter a correct to: address"		      
					       required="Yes"
					       visible="Yes"
					       enabled="Yes"
						   style="width:97%"
						   class="regularxl"
					       size="80"
					       maxlength="50">
				 
			 		   
		        <cfelse>
			        								  
					<cfif URL.Source eq "Applicant" or URL.Source eq "User" or url.Source eq "Person">
	
					   <input type="hidden" name="sendTO" id="sendTO" value="#URL.ID#">
					   <cfoutput>#To.Name# - #To.Nationality# (#URL.ID#)</cfoutput>
					   
				   <cfelse>				  
				  				   
					   <cfinput type="Text"
					       name="sendTO"
						   id="sendTO"
					       value="#URL.ID#"
					       message="Please enter a correct to: address"			      
					       required="Yes"
					       visible="Yes"
					       enabled="Yes"
						   style="width:97%"
						   class="regularxl"
					       size="80"
					       maxlength="50">
				   		   			   			   
				   </cfif>
				   
					
		        </cfif>	
			   </cfoutput>
			</TD>
			</TR>
				
		   <tr><td height="4" colspan="2"></td></tr>
			
		   <!--- Field: SendCC --->
		    <TR>
		    <TD height="22" class="labelmedium"><a href="javascript:address()">Cc:</a></TD>
			<TD>
				<cfinput type="Text"
			       name="sendCC"
				   id="sendCC"
			       message="Please enter a correct cc: address"		     
			       required="No"
			       visible="Yes"
				   style="width:97%"
				   class="regularxl"
			       size="80"
			       maxlength="50">
			   
		  	</TD>
			</TR>	
			
			<tr><td height="4" colspan="2"></td></tr>
			
			<cfif User.Pref_BCC eq "1">
				<cfset bcc = CLIENT.eMail>
			<cfelse>
			    <cfset bcc = "">
			</cfif>
			
		   <!--- Field: SendCC --->
		    <TR>
		    <TD height="22" class="labelmedium" ><a href="javascript:address()"><cf_tl id="Bcc">:</a></TD>
			<TD>
				<cfinput type="Text"
			       name="sendBCC"
				   id="sendBCC"
				   value="#bcc#"
			       message="Please enter a correct bcc: address"
			       validate="email"
			       required="No"
				   class="regularxl"
			       visible="Yes"
				   style="width:97%"
			       size="80"
			       maxlength="50">
			  
		  	</TD>
			</TR>	
				
			<tr><td height="4" colspan="2"></td></tr>
			
		    <!--- Field: Subject --->
		    <TR>
		    <TD height="22" class="labelmedium"><cf_tl id="Subject">:</TD>
			<TD>
			   <cfif URL.ID1 is not "">
			   
				      <cfinput type="Text"
			       name="Subject"
			       value="#URL.Subject#"
			       message="Please enter a subject"
			       required="Yes"
				   style="width:97%"
				   class="regularxl"
			       size="80"
			       maxlength="100">
			   
		       <cfelse>
			   
			          <cfinput type="Text"
			       name="Subject"
			       value=""
			       message="Please enter a subject"
			       required="Yes"
				   style="width:97%"
				   class="regularxl"
			       size="80"
			       maxlength="100">
			   
		       </cfif>	
			  
			</TD>
			</TR>	
			
			<tr><td height="5"></td></tr>
			
			</table>
		</td>
		</tr>
				
		<cfif URL.ID2 neq "">
			
			<cfoutput>
							
				<script LANGUAGE = "JavaScript">
					function openreport(att) {					
					      ptoken.open("#SESSION.root#/CFRStage/getFile.cfm?file="+att, "Attachment")
					}
				</script>
				
				<tr><td height="4" colspan="2"></td></tr>
				<tr><td height="1" colspan="2" class="line"></td></tr>
			   
			    <TR class="labelmedium2">
			    <TD class="labelmedium" style="height:30px;padding-left:16px"><cf_tl id="Associated Report">:</TD>
					<TD>
					    <table>
						<tr class="labelmedium2">
						<cfset row = "0">
						<cfloop index="att" list="#URL.ID2#" delimiters=","> 
						    <cfset row = row+1>
						    <cfif row neq "1">
							<td style="padding-left:4px">|</td>
							</cfif>
						    <td>
							   <input type="checkbox" class="radiol" name="Attachment" id="Attachment" value="#Att#" checked>
							</td>
							<td style="padding-left:6px" class="labelmedium2">
							<a href="javascript:openreport('#att#')">#att#</a>
							</td>
							
						</cfloop>
						</tr>
						</table>
					</TD>
				</TR>	
				
				<TR class="labelmedium2">
			    <TD height="25" valign="top" style="padding-top:4px;padding-left:16px"><cf_tl id="Attachments">:</TD>
				<TD height="40" valign="top">
																								
					<cf_filelibraryN
						DocumentPath  = "Mail"
						SubDirectory  = "#SESSION.acc#" 
						Filter        = "#filter#"
						LoadScript    = "Yes"						
						AttachDialog  = "Yes"				
						Width         = "100%"
						Box           = "a1"
						List          = "mail"
						Insert        = "yes"
						Remove        = "yes">	
												
				</TD>
				</TR>	
				
				
			</cfoutput>
		
		<cfelse>
					
			<cf_assignId>
					
			<!--- determine the root --->
			
			<cfparam name="url.contextmode" default="">		
			<cfparam name="url.host" default="">
			
			<cfset host = replace(url.host,"|","\","ALL")> 	
	
			<!--- determine the root --->
					
			<cfif url.contextmode eq "Report">
				<cfset rt = "">	
			<cfelse>
				<cfset rt = "#host#">
			</cfif>		
			
			<cfparam name="url.dir" default="">	
			<!--- correct the passing of the path --->
			<cfset dir = replaceNoCase(url.dir,"|","\","ALL")> 		
			
			<cftry>		  				  		
				<cfdirectory action="CREATE" 
				             directory="#SESSION.rootDocumentPath#\mail\#SESSION.acc#">
			<cfcatch></cfcatch>
			</cftry>
			
														
			<cfif dir neq "">
								
				<cfdirectory action="LIST" 
				directory="#SESSION.rootDocumentPath#\mail\#SESSION.acc#" 
				name="OldFiles" 
				sort="DateLastModified DESC">
				
				<cfloop query="OldFiles">
								
					<cftry>
					<cffile action="DELETE" file="#rt#\mail\#SESSION.acc#\#name#">
					<cfcatch></cfcatch>
					</cftry>
					
				</cfloop>
				
				<!---- PLEASE CONSIDER HERE INVOKING DOCUMENT SERVER REMOTE COPYING ROUTINE 
				dev dev dev
				----------------->
																			
				<cfdirectory action="LIST" 
				directory="#rt##dir#\#url.sub#" 
				name="GetFiles" 
				sort="DateLastModified DESC" 
				filter="#url.fil#*.*">
								
				<cfloop query="GetFiles">

					<cftry>
						
						<cfset vname=replace(name," ","","all")>
						<cfset vname=replace(vname,"+","","all")>
						
						<cffile action="COPY" 
						source="#rt##dir#\#url.sub#\#name#" 
						destination="#SESSION.rootDocumentPath#\mail\#SESSION.acc#\#vname#">
						<cfcatch>
						</cfcatch>
					</cftry>								
					
				</cfloop>
			
			</cfif>						
				
			<tr><td colspan="2" style="height:47px">
			<table width="99%" cellspacing="0" cellpadding="0" align="center">
				<tr>
					<td>				
									
					<cfif url.id1 neq "Mail">				 
										
						<cfset filter = "select">
						
						 <!--- clean --->					 
						 <cfdirectory action="LIST" 
							directory="#SESSION.rootDocumentPath#\Mail\#SESSION.acc#" 
							name="GetFiles" filter="*.*">
							
						<cfloop query="getfiles">
						
						 	<cffile action = "delete" 
							   file = "#SESSION.rootDocumentPath#\Mail\#SESSION.acc#\#name#">  
						
						</cfloop>				
						
					<cfelse>
					
						<cfset filter = "">	
									 
					</cfif>																
											
					<cf_filelibraryN
							DocumentPath  = "Mail"
							SubDirectory  = "#SESSION.acc#" 
							Filter        = "#filter#"
							LoadScript    = "Yes"
							AttachDialog  = "Yes"				
							Width         = "100%"
							Box           = "a1"
							List          = "thumbnail"
							Insert        = "yes"
							Remove        = "yes">	
																				
					</td>
				</tr>
			</table>		
					
			</td></tr>		
		
			<input type="hidden" name="Attachment" id="Attachment" value="">
		
		</cfif>
			
		<tr><td height="6" colspan="2"></td></tr>
		
		<!--- mail body, check for default text to be included --->
		
		<cfinclude template="MailBody.cfm">
			  
	    <TR><td colspan="2" align="center" style="height:100%" valign="top">
		<table width="100%" style="height:100%" align="center">
		
		<tr><td valign="top" align="center" style="padding-top:4px;height:100%;padding-left:4px;padding-right:4px;">
				
		<cfif url.mode eq "Dialog">
			
		<cf_textarea name="SentBody"			
			 toolbar="Mini"			
			 color="ffffff"			 
			 init="Yes" 	
			 resize="false"		    
			 height="90%"><cfoutput>#mailbody#</cfoutput></cf_textarea>
			
		<cfelse>	
							  	  				
			<textarea name="SentBody"
			 style="border:0px solid silver;width:99%;background-color:f1f1f1;font-size:15px;padding:4px;height:100%"><cfoutput>#mailbody#</cfoutput></textarea>
					 
		</cfif>	
			
					
		</td>
		</TR>
				
		</table>
		</td>		
		</tr>
			
		<tr class="hide"><td>
		<iframe name="result"
	         id="result"
	         width="1"
	         height="1"
	         scrolling="0"
	         frameborder="0"></iframe>
		</td>
		</tr>
	
	</table>
	
	</CFFORM>

</td></tr>
</table>

</cfoutput>	

<cfset AjaxOnload("initTextArea")>	

<cfif url.mode eq "Dialog">

	<cf_screenbottom layout="webapp">

</cfif>


