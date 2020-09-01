<cf_param name="url.id" 	default="" type="string">
<cf_param name="url.box" 	default="" type="string">
<cf_param name="url.mode" 	default="" type="string">
<cf_param name="url.width" 	default="" type="string">

<cfoutput>

<cfquery name="Att" 
	 datasource="AppsSystem"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	     SELECT    TOP 1 *
		 FROM      Attachment
		 WHERE     AttachmentId = '#url.id#'		
</cfquery>

<cfif mode eq "Report">
    <cfset rt = "">
<cfelseif att.server eq "Document">
    <cfset rt = "#SESSION.rootDocumentPath#\">	
<cfelse>
	<cfset rt = "#att.server#">
</cfif>

<cfset Path = replaceNoCase(att.ServerPath,"|","\","ALL")>

<table width="100%" height="100%" align="center">

<!---
<tr>
<td colspna="2"style="padding-left:15px"><img src="#SESSION.root#/Images/line.gif" alt="" border="0"></td>
</tr>
--->

<tr>

<!---
<td width="20" valign="top" style="padding-left:15px">
    <img src="#SESSION.root#/Images/join.gif" alt="" border="0">
</td>
--->

<cfparam name="client.width" default="800">

<cfparam name="url.width" default="#client.width-80#">
<cfset w = url.width>
<cfif w gt 800>
  <cfset w = 800>
</cfif>

<td>

<table style="border:1px solid silver;width:100%;height:100%">
	
	<tr class="line">		
		<td class="top4n labelmedium" 
		  width="99%" 		  
		  style="cursor: pointer;padding-left:5px;height:26"  
		  onclick="embedfile('#url.mode#','#url.box#','hide','#url.id#')">#att.filename#
		</td>
		  
		<td class="top4n" width="22" style="padding-right:5px" align="right">
		
		<img src="#SESSION.root#/Images/close-off.gif" alt="Close" 
		   onmouseOver="this.src='#SESSION.root#/Images/close-on.gif'"
		   onmouseOut="this.src='#SESSION.root#/Images/close-off.gif'"
		   style="cursor: pointer;" 
		   border="0" 
		   onclick="embedfile('#url.mode#','#url.box#','hide','#url.id#')"
		   align="absmiddle">
		   
		</td>
	</tr>
					
	<tr>
	<td colspan="2" align="center" bgcolor="F4F4F4" style="padding: 8px;">
	
	<cfif att.server eq "documentserver">
				
		<cfset oDocumentServer = CreateObject("component","Service.ServerDocument.Document")/>
		<cfset vAttachmentId=#UCase(att.AttachmentId)#>
		<cfset oLink = oDocumentServer.GetiRSS("#att.ServerPath#","#vAttachmentId#-#att.FileName#")/>		
		<cfdump var="#vAttachmentId#">
					
		<cfif oLink[1][1] neq "">
			<cfset iLink=oLink[1][2]>
			<cfset sResponse = oDocumentServer.GetContent("#iLink#","#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\","#att.fileName#")/>
		</cfif>
		
	<cfelseif att.server eq "document">
	
		<cfset vImageSourceValidation = "#session.rootpath#\Images\imageNotAvailable.png">
		<cfif FileExists("#SESSION.rootdocumentpath#\#att.serverpath#\#att.fileName#")>
			<cfset vImageSourceValidation = "#SESSION.rootdocumentpath#\#att.serverpath#\#att.fileName#">
		</cfif>
	
		<cffile action="COPY" 
			source="#vImageSourceValidation#" 
	        destination="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#att.fileName#">		
		
	<cfelse>
	
		<cfset vImageSourceValidation = "#session.rootpath#\Images\imageNotAvailable.png">
		<cfif FileExists("#att.server#\#att.serverpath#\#att.fileName#")>
			<cfset vImageSourceValidation = "#att.server#\#att.serverpath#\#att.fileName#">
		</cfif>
	
		<cffile action="COPY" 
			source="#vImageSourceValidation#" 
	        destination="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#att.fileName#">
		
	</cfif>	
						
	<cfif FindNoCase(".flv", "#att.fileName#")>
	
				<cfset bgColorTheme = "ffffff"> 
					<cfset titleColorTheme = "626262"> 
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
		
				<cftry>				
				
				<cfif att.server eq "documentserver">
					<cfset vPath="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#att.fileName#">
				<cfelse>
					<cfset vPath="#rt#\#att.serverpath#\#att.filename#">
				</cfif>
												
				<cfimage action="INFO" 
					  source="#vPath#" 
					  structname="imginfo">
					 					  
					<cfinvoke component="Service.Image.CFImageEffects" 
							  method="init" 
							  returnvariable="effects">  
																							
					<cfif imginfo.width gte w or imginfo.width gt 800>
					
							<cfset w = 800>
					
							<cfimage action="RESIZE" 
								  source="#vPath#" 
								  name="imgresize" 
								  width="#w#"
								  height="#w*0.75#">					  				
						
						    <!---
							<cfset roundedImage = effects.applyRoundedCornersEffect(imgresize, "white", 20)>
							--->
			
							<cfimage action="WRITETOBROWSER" source="#imgresize#" format="PNG">
											  
					<cfelse>	
					      
						   <cfimage 
							  action="read" 
							  source="#vPath#" 
							  name="img">				 
			
			               <!---
						   <cfset roundedImage = effects.applyRoundedCornersEffect(img, "white", 20)>
						   --->
			
						   <cfimage action="WRITETOBROWSER" 
						    source="#img#" 
							format="PNG">  
													  
					</cfif>		
				
				<cfcatch>
				
				   --->
				
					<cfset vPath="#SESSION.root#\CFRStage\User\#SESSION.acc#\#att.fileName#">
					
					<!---								
					<img src="#vPath#" alt="" border="0" style="overflow-y: scroll;">
					--->
										
					<!--- to show better scrollbars --->
																	
					<iframe src="#vPath#"
				       width="100%"
					   height="400"
				        frameborder="0">
					</iframe>					
					
					
				<!---	
					
				</cfcatch>
				</cftry>	
				
				--->
				
		</cfif>	
		
		</td>
		</tr>
		
			 
	</table>  
</td>
</tr>
<tr><td height="8"></td></tr>
</table>	


</cfoutput> 
