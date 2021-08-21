

<script language="JavaScript">

	function errorshow() {
    
	 se = document.getElementById("errordetail")
	 if (se.className == "hide") {
	     se.className = "regular" 
	 } else {
	     se.className = "hide" 
	 } 	
	
    }
		
	// Reporting framework reset the buttons on top 
		
   	{ 
	try {
					
	se  = parent.option.document.getElementById("preview");
	if (se)	{se.className = "button10g"}
	
	se  = parent.option.document.getElementById("buttons");
	if (se) {se.className = "regular"}
	
	se  = parent.option.document.getElementById("buttons2");
	if (se)	{se.className = "regular"}
	
	se  = parent.option.document.getElementById("stop");
	if (se) {se.className = "hide"}
	
	se  = parent.option.document.getElementById("stopping");
	if (se)	{se.className = "hide"}
	
	se  = document.getElementById("requestabort");
	if (se)	{se.className = "hide"}
	
	} catch(e) {}
	
	}
	
	// Reporting framework stop the progress bar 
	se = parent.document.getElementById("pBar")			
	if (se) {	
	      parent.ColdFusion.ProgressBar.hide("pBar")
	      parent.ColdFusion.ProgressBar.stop("pBar", "true")			   					 
	}
									
</script> 


<cfparam name="error.diagnostics" 		default="">
<cfparam name="URL.controlid"           default="">

<!--- errorId --->
<cf_assignId>	

<cfoutput>

	<cfset vTemplate = "">

	<cfsavecontent variable="error_templates">

		<cfset len = arrayLen(Error.TagContext)>
		<cfloop from="1" to="#len#" index="i">
			<cfloop from="1" to="#i#" index="j">
				&nbsp;
			</cfloop>
			<cfif i eq 1>
				<cfset vTemplate = Error.TagContext[i].Template>
			</cfif>
			<b>#Error.TagContext[i].Line#</b>: #Error.TagContext[i].Template#<br>
		</cfloop>
	
	</cfsavecontent>	
	
</cfoutput>


<cfset diag = replace(error.diagnostics,"'","^","ALL")>

<cfset mail = 0>


<cfif findNoCase("undefined in SESSION",error.diagnostics)>

    <!--- -------------------------------------------------------------- --->
	<!--- newly added to separate session expiration from regular errors --->
	<!--- ------ we trigger the session validation to popup a logon ---- --->

	<cf_validateSession scope="regular">

	<cf_ErrorInsert
		ErrorTemplate    = "#vTemplate#"
		ErrorString      = "#error.QueryString#"
		ErrorReferer     = "#error.HTTPReferer#"
		ErrorNodeIP      = "#error.remoteAddress#"
		ErrorBrowser     = "#error.browser#"
		ErrorDateTime    = "#error.dateTime#"
		ErrorDiagnostics = "#diag#"
		ControlId        = "#URL.ControlId#"
		Id               = "#URL.Id#"
		ErrorId          = "#rowguid#"
		Email            = "#mail#"
		Templates        = "#error_templates#">	
					
<cfelse>

<cfparam name="SESSION.isAdministrator" default="No">								  
<cfparam name="SESSION.welcome"         default="Prosis">
<cfparam name="CLIENT.style"            default="Portal/Logon/Bluegreen/Index.cfm">
<cfparam name="SESSION.overwrite"        default="0">
<cfparam name="CLIENT.eMail"            default="">
<cfparam name="SESSION.acc"             default="administrator">

<cfparam name="SESSION.last"            default="">
<cfparam name="SESSION.first"           default="">
<cfparam name="SESSION.root"            default="">
<cfparam name="CLIENT.DateFormatShow"   default="DD/MM/YY">
<cfparam name="URL.id"                  default="">
	
<cfset ts = timeformat(error.dateTime,"HH:mm:ss")>
<cfset dt = dateformat(error.dateTime,"mm/dd/yy")>

<script>
	try {
	Prosis.busy('no'); } catch(e) {}
</script>



<cf_waitEnd>

<html><head>
	<title><cfoutput>Application Agent</cfoutput></title>
</head>
	
<!--- reportinM framework addition --->

 <cfquery name="List" 
     datasource="AppsSystem">		
		 DELETE FROM stReportStatus 		 
		 WHERE  OfficerUserId = '#SESSION.acc#'
</cfquery>



<cfquery name="Parameter" 
	datasource="AppsInit">
	SELECT * 
	FROM   Parameter
	WHERE  HostName = '#CGI.HTTP_HOST#'
</cfquery>

<cfif SESSION.acc eq "">

	<cfset SESSION.acc = "unknown">
	
</cfif>

<cfquery name="Log" 
	datasource="AppsSystem">
	SELECT * FROM UserError
	WHERE HostName      = '#CGI.HTTP_HOST#' 
	AND   Account       = '#SESSION.acc#'
	AND   ErrorTemplate = '#vTemplate#'
	AND   ErrorString   = '#error.QueryString#' 
	AND   ErrorTimeStamp > getDate()-1  
</cfquery>
   
<!--- log the error and notify --->

<cftry>

	<!----
	<cfif Parameter.ErrorMailToOwner eq "9">
	    <!--- no mail is sent --->
		<cfset mail = "0">
	<cfelse>
	    <cfset mail = "0">  <!--- adjusted by hanno to 0 as mail is sent below --->
	</cfif>						
	--->
	
	<cfif findNoCase("The error occurred on line -1",error.diagnostics)>
	
		<!--- -------------------------------------------------------------- --->
		<!--- prevent logging of the NULL NULL errors----------------------- --->
		<!--- ------ we trigger the session validation to popup a logon ---- --->   
			
	<cfelse>		
			  					 
		<cf_ErrorInsert
			ErrorTemplate    = "#vTemplate#"
			ErrorString      = "#error.QueryString#"
			ErrorReferer     = "#error.HTTPReferer#"
			ErrorNodeIP      = "#error.remoteAddress#"
			ErrorBrowser     = "#error.browser#"
			ErrorDateTime    = "#error.dateTime#"
			ErrorDiagnostics = "#diag#"
			ControlId        = "#URL.ControlId#"
			Id               = "#URL.Id#"
			ErrorId          = "#rowguid#"
			Email            = "#mail#"
			Templates        = "#error_templates#">	
				
	</cfif>			
										
	<cfcatch>

	    <!--- disabled by Hanno 11/11/2012 as it triggered double records --->
		 
	</cfcatch>	

</cftry>

<!--- 1. process the error to determine its process status --->

<cfinvoke component = "Service.Process.System.SystemError"  
	method			= "TagSystemError"
	ExecutionScope	= "Yesterday"
	UserScope       = "#SESSION.acc#">	

<!--- get the log file and only trigger an eMail to the user for this error 
    if it is a processible error --->

<cfquery name="Log" 
		datasource="AppsSystem">
		SELECT * 
		FROM   UserError
		WHERE  ErrorId       = '#rowguid#'							
</cfquery>


<!--- notify the user --->
<cfif Log.EnableProcess eq "0">
	<cf_mailUserError errorid="#rowguid#">
</cfif>
			
<body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0">

<cfoutput>
<link rel="stylesheet" type="text/css" href="#SESSION.root#/#client.style#">
<link rel="stylesheet" type="text/css" href="#SESSION.root#/print.css" media="print">
</cfoutput>

<cf_wait flush="yes" controlid="#URL.ControlId#" last="1">

<cf_waitend>

<cfquery name="Parameter" 
	datasource="AppsInit">
	SELECT * 
	FROM   Parameter
	WHERE  HostName = '#CGI.HTTP_HOST#'
</cfquery>

<cfparam name="SESSION.acc" default="undefined">

<cftransaction isolation="read_uncommitted">
	<cfquery name="User" 
		datasource="AppsSystem">
		SELECT * 
		FROM   UserNames
		WHERE  Account = '#SESSION.acc#'
	</cfquery>
</cftransaction>

<!--- Added in order to prevent non existing users to see detailed error messages --->
<cfif User.recordcount eq 1>
	<cfset DisableFriendlyError = User.DisableFriendlyError>
<cfelse>
	<cfset DisableFriendlyError = "0">
</cfif>

<cfif DisableFriendlyError eq "">
	<cfset DisableFriendlyError = "0">
</cfif>


<cfif Parameter.enableError eq "2" and 
      SESSION.isAdministrator eq "No" and 
	  DisableFriendlyError eq "0"  and 
	  SESSION.overwrite eq "0">
	  
	<!--- friendly message --->
		
	<cfoutput>
			
	<table width="97%" align="center">	
		
	<tr><td valign="middle" align="center" style="padding-top:10px">
	
		<div style="width:60%;padding:9px;color:FFFFFF; font-size:30px; font-family:Verdana; background-color:E08283; border-radius:10px;">
			
		<table bgcolor="white" align="center" border="0" bgcolor="transparent">	 
		
		 <tr>
		 <td bgcolor="white" height="100%" rowspan="5" valign="top" style="border-radius:8px;padding:10px">
		 
		 <table>
		 <tr><td bgcolor="FFFFFF" style="border-radius:8px;padding:6px">
		 <img src="#SESSION.root#/Images/error_3.png" alt="System is not available" width="34" height="34" border="0" align="absmiddle">
		 </td>
		 </table>
		 
		 </td>
		 
		 <td align="left" valign="top" style="padding:10px" class="labelmedium">
							 
				 <cfif Log.EnableProcess eq "0">
				 
					We have detected a recurrent problem in the application.
			     				  
				 <cfelse>
				 
					We have detected an unexpected problem in the application and has been recorded under Case No. <b>#Log.ErrorNo#</b>					 						   
					  
				 </cfif>
				 
		 </td>
		 </tr>
		 
		 <!---
		 <cfif Log.EnableProcess eq "0">
			<tr><td colspan="2" style="padding-left:10px;padding-right:10px" class="labelit"><font face="Calibri" size="2"><cfif SESSION.first neq "">#SESSION.first#,</cfif>we have determined that you experienced the same problem also earlier.</td></tr>
		 <cfelse>
		 	<tr><td colspan="2" style="padding-left:10px;padding-right:10px" class="labelit"><font face="Calibri" size="2"><cfif SESSION.first neq "">#SESSION.first#,</cfif>we sent a confirmation eMail to your eMail address.</td></tr>		
		 </cfif>	 --->
		 			   
		<cfif Parameter.ErrorMailToOwner eq "9">
		      <cfset cl = "button10g">			  
			  <!--- manually send mail --->
	  		   <button class="#cl#" type="button"									  
				  style   = "height:20px"
				  name    = "mailbutton"
				  id      = "mailbutton"
				  onclick = "window.open('#SESSION.root#/ErrorDetail.cfm?id=#rowguid#&ts=-#dt#-,-#ts#-','myerrormailbox');document.getElementById('mailbutton').className='hide'">														 										
				  <font color="0080FF">Press Here</font> to Notify: <b>#Parameter.SystemContact#</b>
			  </button>		
		   <cfelse>
		      <!--- auto send mail see line 391 --->
		      <cfset cl = "hide">

		   </cfif>		   		  	
						  				   
		 </td></tr>
		 
		 <cfif Parameter.ErrorMailToOwner neq "9">		
		 
		 	<tr>
			   <td colspan="2" style="padding-left:10px" class="labelit"><font face="Calibri" size="2" color="white">#SESSION.welcome# Team has been notified of your problem.</td>
		    </tr>
		 
		 </cfif>
		 
		 <tr class="hide">
		 
		 	<td>
		 
		 	<iframe name="myerrormailbox" 
			   id="myerrormailbox" 
			   scrolling="no" 
			   frameborder="0"></iframe>
			   
			</td>
			   
	      </tr>	  
		 
		 </table>
		 
		 </div>
	 	 	 
	 </td></tr>
	 
	 			<cfif Parameter.ErrorMailToOwner lt "9">						
				
					<script>
						document.getElementById("mailbutton").click()								
					</script>	
											
				</cfif>	
	 
	 		  <!--- get the recorded error in the log file of cf 	
	
				Note:  April 10, 2015. by Nery.
				As discussed with Hanno, I'm taking this out because: (a) We are already storing error diagnostics and error content in the database therefore no 
				need for exception.log file to be populated (b) Even though this is "display:none", it is a security vulnerability to output detailed error information to clients.
	
			 <tr><td class="hide" colspan="1" id="errordetail">     
		   		 <table width="100%" cellspacing="1" cellpadding="1">
					<tr><td height="1" bgcolor="silver">	
					</td></tr>
					<style>
						XMP {
							display:none;
						}
					</style>		
					<tr><td height="1" bgcolor="silver"></td></tr>			
					<tr>								
					<td>								
					<!--- the usual error comes below --->							
					<XMP>				 										
				    <!--- below actually generates the loginfo in the log file on cf7/8 			  	
				      #error.generateContent#	   					 
					--->
					</td>
					</tr>		
				</table>				
			</td></tr>			
	 		--->
	 
	 </table>
		 	 	 
	 </cfoutput>	 

<cfelse>
	
	<!--- Oct 1, 2016 by Nery: Somehow, som errors still make it to be displayed fully detailed, so below condition makes sures that only Admin or Session overwrite =1 can see that--->
	
	<cfif SESSION.isAdministrator eq "Yes" or Session.Overwrite eq "1">
	 	 
	<cfset headercolor = "ffffff">
		
		<cfoutput>
			
		<cfset lbl = "#SESSION.welcome# Application Agent">		
		
		<table width="90%" align="center" cellspacing="2" cellpadding="2">
		
			<tr><td height="8"></td></tr>
							
			<tr>
			
			<td width="100%"> 
				
				  <table width="97%" align="center" cellspacing="1" cellpadding="0" bgcolor="#headercolor#">
				  			  
				    <tr><td height="26"
				            colspan="2"	   
							class="labelmedium"        
							bgcolor="c1c1c1"><font color="FFFFFF">&nbsp;#SESSION.welcome# Application Agent</td></tr>
							
					<tr><td colspan="2" bgcolor="gray"></td></tr>		
				    <tr><td colspan="2">
													
					<table width="99%" align="center" cellspacing="1" cellpadding="1" bgcolor="FFFFFF">
													 
						 <cfquery name="Log" 
							datasource="AppsSystem">
								SELECT * 
								FROM   UserError
								WHERE  ErrorId       = '#rowguid#'														
						  </cfquery>
						  
						  <cfif log.recordcount neq "0">   <!--- this was 0 --->
						 									 	 
							 <tr><td align="center" style="padding-top:10px">
							 <table width="100%">
								 <tr>
									 <td align="center" width="100" class="labelmedium">
									 <img src="#SESSION.root#/Images/error_3.png" alt="An error has occurred" onclick="parent.window.close()" border="0" align="absmiddle">
									 <br>
									 <a href="javascript:parent.window.close()"><font color="0080C0">Close</a>
									 </td>
									 
									 <td>								
																	 
										 <table>
										 
											 <tr><td>
											 <font size="3" face="Calibri">
											 <b>#SESSION.welcome# has detected an unexpected problem.</b></font>																			 					 
											 </td>
											 </tr>
												
											 <tr><td id="errormail" height="40">
												
													<img src="#SESSION.root#/Images/finger.gif" border="0" align="absmiddle">
													
													 <cfif Log.EnableProcess eq "0">												
													     <cfset cl = "hide"> 
													  	 <font face="Calibri" size="3" color="0080FF">A <a href="#SESSION.root#/Portal/Selfservice/Default.cfm?ID=support" target="support"><font face="Calibri" size="3" color="0080FF">RECURRENT</font></a> problem with your request which has been logged.</font>
													 <cfelseif Parameter.ErrorMailToOwner neq "9">
													 
											     		 <cfset cl = "hide">
														  <font face="Calibri" size="3" color="0080FF">A ticket was created under <b><a href="#SESSION.root#/Portal/Selfservice/Default.cfm?ID=support" target="support">EXC/#Log.ErrorNo#</a></b> and notification was sent to #Log.ErrorEMail# </font>
													 <cfelse>												 
													      <cfset cl = "button10g">
													 </cfif>
													 												 																		
													 <button class="#cl#" 									  
														style="height:20px"
														name="mailme"
														id="mailme"
														onclick="window.open('#SESSION.root#/ErrorDetail.cfm?id=#rowguid#&ts=-#dt#-,-#ts#-','myerrormailbox', 'left=40, top=40, width=300, height=100, status=no, scrollbars=no, resizable=no');document.getElementById('mailme').className='hide';">														 										
														  <font color="0080FF">Press Here</font> to direcly notify: <b>#Parameter.SystemContact#</b>
													  </button>									
													  																	 
											 </td>
											 </tr>								 
										 								 
										 </table>
										 
									 </td>	
									 
								 </tr>
							 </table>
						 </tr>
										 
						<tr class="hide">
								 <td><iframe name="myerrormailbox" id="myerrormailbox" scrolling="no" frameborder="0"></iframe></td>
						</tr>
															
						<tr>
						 <td style="padding:0px; border: 1px dotted silver;" width="97%" align="center">
						 					
						 <table width="100%" align="center" border="0" cellspacing="1" cellpadding="3" >
						 										    
						 <tr>						     
								 <td height="20" valign="top" bgcolor="EBF7FE" style="padding:4px;border-color: d1d1d1; border-right: 1px dotted silver;">
									 <table width="100%"
									       height="100%"      
									       cellspacing="0"
									       cellpadding="2"
									       align="right">
										 <tr>
										    <td width="300" valign="top" class="labelit" colspan="2" height="23"><b>Posted by</td>
										 </tr>									
										 <tr><td class="labelit">Case&nbsp;No:&nbsp;&nbsp;</b></td><td class="labelit">#Log.HostName#/<b>#Log.ErrorNo#</b></td></tr>				 
										 <tr><td class="labelit">UserId:</b></td><td class="labelit">#SESSION.acc#</td></tr>
										 <tr><td class="labelit">Name</b>:</td><td class="labelit">#SESSION.first# #SESSION.last#</td></tr>
										 <tr> 
							         	<td class="labelit">Browser:</B></td>
										<td class="labelit">			
										
										<cfinvoke component = "Service.Process.System.Client"  
										   method           = "getBrowser"
										   browserstring    = "#CGI.HTTP_USER_AGENT#"	  
										   returnvariable   = "thisbrowser">	   
										 									  
										  #thisbrowser.name# #thisbrowser.release#
										 																		
										</td>
									 </tr>
										 <tr><td class="labelit">eMail:</b></td><td class="labelit">#client.eMail#</td></tr>
										 <tr><td class="labelit">IP</b>:</td><td class="labelit">#error.remoteAddress#</td></tr>
										 <tr><td class="labelit">Source</b>:</td><td class="labelit">#Log.Source#</td></tr>
									 </table>
								 </td>
								 
								 <td valign="top" style="padding-left:20px; border: 0px dotted silver;">
								 
								 <table width="100%" align="left" cellspacing="0" cellpadding="2" align="center">
								 
									 <tr bgcolor="#headercolor#">
									    <td valign="top" class="labelit" colspan="2" height="23"><b>Error Details</td>
									 </tr>
																					     
									 <tr>
							         	<td class="labelit">Date and Time:</td>
										<td class="labelit">#dateformat(error.dateTime,CLIENT.DateFormatShow)# at #timeformat(error.dateTime,"HH:MM:SS")#</td>
									</tr>
									<tr>
								    	<td class="labelit">ADOBE&nbsp;ColdFusion&nbsp;Server:&nbsp;&nbsp;</td>
										<td class="labelit">#CGI.HTTP_HOST# (#Server.Coldfusion.ProductVersion#/#Server.ColdFusion.ProductLevel#)</td>
									</tr>
									<tr>
								    	<td class="labelit">Operating&nbsp;System:&nbsp;&nbsp;&nbsp;&nbsp;</td>
										<td class="labelit">#Server.OS.Name# #Server.OS.Version#</td>
									</tr>
									
									<tr>
								    	<td class="labelit">Referrer:</td>
										<td class="labelit" style="word-wrap: break-word; word-break: break-all;"><cfif error.HTTPReferer eq "">N/A<cfelse>#error.HTTPReferer#</cfif></td>
									</tr>				
									
									<cfif url.controlid neq "">
			
										<cfquery name="Report" 
											datasource="AppsSystem">
											SELECT * FROM Ref_ReportControl
											WHERE ControlId = '#url.controlId#'			
										</cfquery>		
										
										<cfif report.recordcount eq "1">
										
											<tr>
									    	<td class="labelit">Report:</td>
											<td class="labelit"><font style="text-decoration: underline;">#Report.FunctionName#</font></td>
											</tr>
											
											<tr>
									    	<td class="labelit">Directory:</td>
											<td class="labelit"><font style="text-decoration: underline;">#Report.ReportPath#</font></td>
											</tr>
											
										<cfelse>
										
											<tr>
									    	<td class="labelit">Template:</td>
											<td class="labelit" style="word-wrap: break-word; word-break: break-all;">#error_templates#</td>
										    </tr>	
																	
										</cfif>
										
									<cfelseif url.id neq "">
									
										<cfparam name="URL.controlid" default="">
										
										<cftry>
										
											<cfquery name="Workflow" 
													datasource="AppsOrganization">							
													SELECT     O.EntityCode, O.EntityClass, R.ActionDescription, Dialog.DocumentTemplate
													FROM       OrganizationObjectAction OA INNER JOIN
													           OrganizationObject O ON OA.ObjectId = O.ObjectId INNER JOIN
													           Ref_EntityAction R ON OA.ActionCode = R.ActionCode INNER JOIN
													           Ref_EntityActionPublish P ON R.ActionCode = P.ActionCode AND OA.ActionPublishNo = P.ActionPublishNo LEFT OUTER JOIN
													           Ref_EntityDocument Dialog ON R.EntityCode = Dialog.EntityCode AND P.ActionDialog = Dialog.DocumentCode
													WHERE      OA.ActionId = '#URL.ID#'
											</cfquery>	
																									
											<cfif workflow.recordcount eq "1">
													
												<tr>
											    	<td class="labelit">Workflow:</td>
													<td class="labelit"><font style="text-decoration: underline;">#Workflow.EntityCode# / #Workflow.EntityClass#</font></td>
												</tr>																			
												<tr>
											    	<td class="labelit">Action:</td>
													<td class="labelit"><font style="text-decoration: underline;">#Workflow.ActionDescription#</font></td>
												</tr>											
												<tr>
											    	<td class="labelit">Embedded Template:</td>
													<td class="labelit"><font style="text-decoration: underline;">#Workflow.DocumentTemplate#</font></td>
												</tr>	
												
											<cfelse>
											
												<tr>
											    	<td class="labelit">Template:</td>
													<td class="labelit" style="word-wrap: break-word; word-break: break-all;"><u>#error_templates#</td>
												</tr>	
												
											</cfif>	
										
										<cfcatch>
										
											<tr>
										    	<td class="labelit">Template:</td>
												<td class="labelit" style="word-wrap: break-word; word-break: break-all;"><u>											
												#error_templates#
												</td>
											</tr>								
										
										</cfcatch>									
										
										</cftry>
										
									<cfelse>
															
										<tr>
										   	<td class="labelit">Template:</td>
											<td class="labelit" style="word-wrap: break-word; word-break: break-all;">#error_templates#</td>
										</tr>	
																	
									</cfif>	
									
									<tr>
								    	<td class="labelit">String:</td>
										<td class="labelit" style="width:70%;word-wrap: break-word; word-break: break-all;">#error.queryString#</td>
									</tr>
										
								</table>
							</td>	
							</tr>
						</table>
						</td>
					</tr>						
																		
					<tr>		        	 
						 <td colspan="2" align="center" style="padding:0px; border: 1px dotted silver;">
						 <table width="100%" bgcolor="ffffcf" align="center" cellspacing="3"><tr><td align="center">
						 <font color="gray"><b>
						 <cfset diag = replace(error.diagnostics,". ",".<br>","ALL")>
						 #diag#</b>
						 </td></tr></table>
						 </td>
					</tr>
					
					<cfparam name="SESSION.overwrite" default="0">
													
					<cfif Parameter.EnableDetailError eq "1" or 
					      DisableFriendlyError eq "1" or 
						  SESSION.isAdministrator eq "Yes" or 
						  SESSION.overwrite eq "1">		
	
							<cfset cl = "regular">
		
					<cfelse>
					
							<cfset cl = "hide">
							
					</cfif>
													
					<script>
						try { Prosis.busy("no") } catch(e) {}
						try { parent.Prosis.busy('no') } catch(e) {}										
					</script>
									
					<tr>
					<td colspan="2" class="#cl#" style="padding:4px; border: 0px dotted silver;">
									
					<table width="99%" bgcolor="ffffff" align="center" border="0" cellspacing="3" cellpadding="3">
					<tr><td align="center">
					
						<tr><td align="left" height="24">			
						    
						   <table cellspacing="1" cellpadding="1">
							
							<tr><td  id="errordrill">
							
						    <input type="button" 
							       class="button10g" 
								   style="height:26px;width:180px" 
								   value="View More Details" 
								   name="Details" 
								   onclick="document.getElementById('errordetail').className='regular';document.getElementById('errordrill').className='hide';">												
	
							</td>				
							
							</tr>
							
							</table>
							
						</td>
						</tr>	
											
															
						<tr><td class="hide" colspan="1" id="errordetail">
	
							    <table width="100%" cellspacing="1" cellpadding="1">
								
									<tr><td height="1" bgcolor="silver"> 
											
									</td></tr>
												
									<style>
									XMP {
											display:none;
										}
									</style>
									
									<tr><td height="1" bgcolor="silver"></td></tr>
									
									<tr>
														
									<td>  													
									<!--- the usual error comes below --->	
									
									<cfif Parameter.ErrorMailToOwner neq "9">
																
										<script>
											document.getElementById("mailme").click()
										</script>								
									
									</cfif>
																							
									<XMP>																		      												 
	
									  <!--- below actually generates the loginfo in the log file on cf7/8/9 --->
										#error.generateContent#	
										
										<!---
										<cfsavecontent variable="var">			
									      #error.generateContent#	
										</cfsavecontent>  	
										--->									
									
									</td>
									</tr>	
								
								</table>
								
						</td></tr>				
								
					    </table>	
	    				 </td></tr>	
						 
					<cfelse>
					
						<tr><td align="center">Error was not logged</td></tr>	 
						 
					</cfif>					
						 
			</td></tr>
			
			</table>	
			
			</td></tr>
		
		</table>	
		
		</cfoutput>
	
	</cfif>
	
</cfif>	

</cfif>

<script>
	try { Prosis.busy("no") } catch(e) {}
	try { parent.Prosis.busy('no') } catch(e) {}	
</script>

