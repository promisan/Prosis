
<!---

<script language="JavaScript"> 

	function PrintThisPage() { 
		document.ifWorkspace.focus(); 
		document.ifWorkspace.print(); 
} 

</script> 

--->


<cfparam name="url.ser" default="">
<cfparam name="url.id"  default="">

<cfif url.id eq "">
	<cfset m = Message()>
</cfif>

<cfquery name="Att" 
	 datasource="AppsSystem"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	     SELECT    TOP 1 *
		 FROM      Attachment
		 WHERE     AttachmentId = '#url.id#'		
</cfquery>

<!---- Modification on cfcontent by Armin on Feb 18th 2012 --->

<cfquery name="Parameter"
	 datasource="AppsSystem"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT  *
		FROM    Ref_Attachment 	
		WHERE   DocumentPathName = '#Att.DocumentPathName#' 
</cfquery>



<cfset o = Render()>	

<!---


<cfif Parameter.AttachModeOpen eq 0>

	<cfif find(".doc","#Att.FileName#")>

		<cfif not FileExists("#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#att.fileName#")>
	
			<table width="100%" height="100%" cellspacing="0" cellpadding="0">
			<tr>
			<td>
			   <cf_message message="Detected unauthorised access. Event has been logged." return="Close">
			</td>
			</tr>	
			</table>
		
		<cfelse>	
		
			 <!--- condition made for Marano to load the word document in the full screen allowing to print it --->
			 
			 <cfoutput>		
				 <script> 									
					window.open("#SESSION.root#/CFRStage/User/#SESSION.acc#/#att.fileName#")
				 </script>
			 </cfoutput>
		 </cfif>

	<cfelse>
		
		<cfset o = Render()>
		
	</cfif>	
	
<cfelse>
	
		<cfset o = Render()>													
		
</cfif>

--->


<!--- function to render the file --->

<cffunction name="Render">

	<cf_screentop label="Attachment" height="100%" scroll="No" layout="webapp" banner="gray">
				
	<cfoutput>
	
		<table width="100%" align="center" height="100%" cellspacing="0" cellpadding="0">
		
		<cfif url.ser eq "">
		
			<tr bgcolor="fafafa">
			<td class="labelit" style="padding-left:6px">
				<cfif find(".dat", "#att.fileName#")> 
					<cfheader name="Content-Disposition" value="attachment;filename=#att.fileName#">
					<cfcontent type="text/plain" file="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#att.fileName#">
				</cfif>	
								
			</td>
			
			<td class="labelmedium"  height="25" style="padding-right:6px" align="right">&nbsp;&nbsp;Recorded by: <b>#Att.OfficerFirstName# #Att.OfficerLastName#</b> on <b>#dateformat(Att.Created,CLIENT.DateFormatShow)# - #timeformat(Att.Created,"HH:MM:SS")#</b>&nbsp;</td></tr>
		
		<cfelse>
			
			<cfquery name="Log" 
				 datasource="AppsSystem"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				     SELECT    TOP 1 *
					 FROM      AttachmentLog
					 WHERE     AttachmentId = '#url.id#'		
					 AND       SerialNo     = '#url.ser#'
			</cfquery>
			
			<tr bgcolor="f4f4f4">
			
			<td style="padding-left:6px">
				<cfif not find(".pdf", "#att.fileName#")> 			
					<a href="javascript:PrintThisPage();"><font size="2" color="0080C0">Print this File</a>
				</cfif>
			</td>
			<td height="21" align="right" style="padding-right:6px" bgcolor="f4f4f4">Log file: <b>#Log.OfficerFirstName# #Log.OfficerLastName#</b> on <b>#dateformat(Att.Created,CLIENT.DateFormatShow)# - #timeformat(Log.Created,"HH:MM:SS")#</b>&nbsp;</td>
			</tr>
			
		</cfif>
					
		<cfif Parameter.AttachModeOpen eq "0">
		  
		  
		    <!--- secure copy --->
				
			<cfif not FileExists("#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#att.fileName#")>

				<tr>
				<td><cf_message message="Detected unauthorised access. Event has been logged." return="Close"></td>
				</tr>	
			
			<cfelse>
			
					<cfif FindNoCase(".flv", "#att.filename#")>
							       
							<cfset bgColorTheme       = "ffffff"> 
							<cfset titleColorTheme    = "626262"> 
							<cfset controlsColorTheme = titleColorTheme> 
							<cfset progressColorTheme = "efb400"> 
							<cfset progressbgColorTheme = "8a6800"> 
							
							<cfmediaplayer 
								name="#att.fileName#" 
								width="850" 
								height="610"
								hideborder="false" 
								hideTitle="true" 
								controlbar="true" 
								style="bgcolor:#bgColorTheme#;titletextcolor:#titleColorTheme#;titlebgcolor:#bgColorTheme#;controlbarbgcolor:#bgColorTheme#;
							        controlscolor:#controlsColorTheme#;
							        progressbgcolor:#progressbgColorTheme#;
							        progresscolor:#progressColorTheme#;
							        borderleft:2;borderright:2;bordertop:1;borderbottom:1"  
								source="#SESSION.root#/CFRStage/User/#SESSION.acc#/#att.fileName#"
								quality="high"
								wmode="transparent">	
								
						<cfelse>	
						
							
						   	
							<!--- 
							These lines are removed on Feb 20 2012
							Copying to avoid permission issues at iframe level we copy this file within the context
							of the root of the IIS 
							
							<cffile action="COPY" 
							source="#SESSION.rootDocumentPath#\_readfile\#SESSION.acc#\#att.fileName#" 
							destination="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#att.fileName#">	
							
							open within the context of the application --->
							
							<cfset CLIENT.sd = "#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\">
							<cfset CLIENT.sf = "#att.fileName#">
							
							<cfif LCase(ListLast(att.fileName, ".")) eq "pdf" or LCase(ListLast(att.fileName, ".")) eq "png">
							
								<tr><td style="height:100%;width:100%" colspan="2">	
																																							
								<iframe src ="FileRender.cfm?mid=#url.mid#"
										name="ifWorkspace"
								        id="ifWorkspace"
								        width="100%"
								        height="100%"
								        marginwidth="0"
								        marginheight="0"
							    	    frameborder="0">
								</iframe>	
								
								</td>
								</tr>
							
							<cfelse>
							
							<tr>
							<td align="center" colspan="2" valign="middle" class="labelmedium" style="height:100%;font-size:25px">Please find below the file you requested</td>
							</tr>
																					
							<tr><td style="height:80px">	
																																						
								<iframe src ="FileRender.cfm?mid=#url.mid#"
										name="ifWorkspace"
								        id="ifWorkspace"
								        width="100%"
								        height="100%"
								        marginwidth="0"
								        marginheight="0"
							    	    frameborder="0">
								</iframe>	
							
							</td>
							</tr>
							
							</cfif>
							
													
						</cfif>	
				
			
			</cfif>
			
		<cfelse>
		
		
		     <!--- attachmodeopen = 1 this was driven by the excel issue --->
		
			<tr><td colspan="2" height="100%" valign="middle" align="center" style="padding:2px">	
			   						
				<cfset CLIENT.sd = "#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\">
				<cfset CLIENT.sf = "#att.fileName#">
			
				<iframe src ="FileRender.cfm?mid=#url.mid#"
						name="ifWorkspace"
				        id="ifWorkspace"
				        width="100%"
				        height="100%"
				        marginwidth="0"
				        marginheight="0"
			    	    frameborder="0">
				</iframe>	
									
				
			</td></tr>							
		</cfif>
		
		</table>
		</cfoutput>
		
	<cf_screenbottom layout="webapp">

</cffunction>

<cffunction name="Message">

   <table width="100%" height="100%" align="center">
	 <tr><td align="center" height="40">
	   <font face="Verdana" color="FF0000">
		   <cf_tl id="Detected a Problem with your function authorization"  class="Message">
	   </font>
		</td>
	 </tr>
   </table>	
   <cfabort>	
		   
</cffunction>