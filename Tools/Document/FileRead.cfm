
<!--- fileread.cfm 

	1. copies file over to a save place _readfile
	2. opens the file from secure locate into an iframe
	
--->

<cfquery name="Att" 
	 datasource="AppsSystem"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	     SELECT    TOP 1 *
		 FROM      Attachment
		 WHERE     AttachmentId = '#url.id#'		
</cfquery>

<cfquery name="Parameter"
 datasource="AppsSystem"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT  AttachModeOpen
	FROM    Ref_Attachment 	
	WHERE   DocumentPathName = '#Att.DocumentPathName#'
</cfquery>

<!--- cutt path --->
<cfif left(att.serverpath,9) eq "document/"> 
   <cfset path = mid(att.serverpath,10,len(att.serverpath))>
<cfelse>
  <cfset path = att.serverpath>   
</cfif>

<cfparam name="url.ser" default="">  

<cfset path = replace(path,"/","\","ALL")>

<!--- clean --->
<cfif FileExists("#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#att.fileName#")>

  <cftry>
   	  <cffile action="DELETE" file="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#att.fileName#">		  
      <cfcatch></cfcatch>	
  </cftry>
  
</cfif>

<cfif not directoryExists("#SESSION.rootPath#\CFRStage\User\#SESSION.acc#")>	
	 <cfdirectory action="CREATE" 
	      directory="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#">			 
</cfif>

<table cellspacing="0" cellpadding="0" align="center" class="formpadding"><tr><td class="labelmedium">

<!---
<cftry>
--->
						
	<cfif att.server eq "documentserver">
	
	     <!--- Xythos --->
		<cfset oDocumentServer = CreateObject("component","Service.ServerDocument.Document")/>
		<cfset vAttachmentId= UCase(att.AttachmentId)>
		<cfset oLink = oDocumentServer.GetiRSS("#att.ServerPath#","#vAttachmentId#-#att.FileName#")/>		
		<cfdump var="#vAttachmentId#">
					
		<cfif oLink[1][1] neq "">
			<cfset iLink=oLink[1][2]>
			<cfset sResponse = oDocumentServer.GetContent("#iLink#","#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\","#att.fileName#")/>
		</cfif>
		
	<cfelse>
	
		<!--- go to the file server --->				

		<cfif att.server eq "document">
		   <cfset svr = "#SESSION.rootdocumentpath#">
		<cfelse>
		   <cfset svr = "#att.server#">
		</cfif> 	
		
		<!--- we never read the file straight from the source location, we always work with a copy --->			
			
	    <cfif url.ser eq "">
			
			<cfset vImageSourceValidation = "#session.rootpath#\Images\imageNotAvailable.png">
			<cfif FileExists("#svr#\#path#\#att.fileName#")>
				<cfset vImageSourceValidation = "#svr#\#path#\#att.fileName#">
			</cfif>
			<cffile action="COPY" 
				source="#vImageSourceValidation#" 
		        destination="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#att.fileName#">
				
		<cfelse>		
							
			<!--- locate the logged copy which is requested for viewing as an audit measure --->
			<cfset vImageSourceValidation = "#session.rootpath#\Images\imageNotAvailable.png">
			<cfif FileExists("#svr#\#path#\logging\#att.attachmentid#\[#ser#]_#att.filename#")>
				<cfset vImageSourceValidation = "#svr#\#path#\logging\#att.attachmentid#\[#ser#]_#att.filename#">
			</cfif>
			<cffile action="COPY" 
				source="#vImageSourceValidation#" 
		        destination="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#att.fileName#">					
			
		</cfif>   		
						
		<!--- adjust the image file sizing --->
		

		<cfif LCase(ListLast(att.fileName, ".")) eq "jpg" or  LCase(ListLast(att.fileName, ".")) eq "png"> 
		
		<cfimage action="INFO" 
					  source="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#att.fileName#" 
					  structname="imginfo">
					  
			<cftry>		
					 					  
					<cfinvoke component="Service.Image.CFImageEffects" 
							  method="init" 
							  returnvariable="effects">  
																							
					<cfif imginfo.width gte 1000>
					
							<cfimage action="RESIZE" source="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#att.fileName#" name="img" width="956" height="730">		
							
							<!---			  										
							<cfset roundedImage = effects.applyRoundedCornersEffect(img, "white", 20)>			
							--->
							
							<cfimage action="WRITE" 
							     source="#img#" 
								 destination="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#att.fileName#" 
								 overwrite="Yes">
											  
					<cfelse>	
					      
						   <cfimage action="read" source="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#att.fileName#" name="img">	
						   	
						   <!---			 			
						   <cfset roundedImage = effects.applyRoundedCornersEffect(img, "white", 20)>						   
						   --->
						   
						   <cfimage action="WRITE" 
						            source="#img#" 
									destination="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#att.fileName#" 
									overwrite="Yes">			
						  												  
					</cfif>		
				
				<cfcatch>
								
					<!--- no action --->
					
				</cfcatch>
				
			</cftry>	

		</cfif>

		
	</cfif>			
				
	<!--- now we show the file --->
		
	<cfif Parameter.AttachModeOpen eq "0">	
		
		<!--- open a copy --->		
		<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
		<cfset mid = oSecurity.gethash()/>		
		<cflocation addtoken="No" url="#session.root#/tools/document/FileReadShow.cfm?id=#url.id#&mid=#mid#">	
		
	<cfelse>
	
		<!--- open a secre copy so users can not apply the link to each other --->
		<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
		<cfset mid = oSecurity.gethash()/>		
		<cflocation addtoken="No" url="#session.root#/tools/document/FileReadShow.cfm?id=#url.id#&mid=#mid#">		
		
	</cfif>
	
<!---
	
<cfcatch>

	<br><font color="FF0000">Sorry, document is no longer available.</font>

</cfcatch>

</cftry>

--->


</td></tr></table>


