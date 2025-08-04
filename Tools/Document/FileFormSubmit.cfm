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

<cfparam name="SESSION.authent"   default="">	

<cfif SESSION.authent eq 1>
	
<cfparam name="URL.mid"             default="">	
<cfparam name="URL.DocumentServer"  default="">
<cfparam name="URL.dialog"          default="1">
<cfparam name="Form.KeepOriginal"   default="0">
<cfparam name="Form.DocumentServer" default="#URL.DocumentServer#">

<cfif Form.DocumentServer eq "0">
	<cfparam name="Form.DocumentServerPath" default="">
<cfelse>
	<!--- kherrera(2014-12-05): #CLIENT.DocumentServerPath# was removed as the default to make it work without the dialgo in Chrome --->
	<cfparam name="Form.DocumentServerPath" default="">
</cfif>	

	<cfoutput>
		
		<!--- parameters --->
		<CFSET IsOverwriteEnabled = "NO">
		
		<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
		
		<!--- upload file with unique name --->
		
		<cfset host = replaceNoCase(url.host,"|","\","ALL")> 
		
		<CFSET dir = replace(url.dir,"/","\",'ALL')>
		<CFSET dir = replace(dir,"\\","\",'ALL')>
		<CFSET dir = replace(dir,"|","\",'ALL')>
		
		<cfif mode eq "Report">
		    <cfset rt = "">
		<cfelse>
			<cfset rt = host>
		</cfif>	
			
		<!--- ---------------------------------------------------------------------- --->	
		<!--- ---------------------------------------------------------------------- --->
		<!--- ---------------------------------------------------------------------- --->	
			
		<cfif DirectoryExists("#rt#\#Dir#\#URL.ID#")>
				
	        <!--- skip--->
						
		<cfelse>  	
								  
		      <cfdirectory action   = "CREATE" directory= "#rt#\#Dir#\#URL.ID#">
						  
		</cfif>		
			
		<!--- get the array for files to be saved --->	
			
		<cfif url.mode neq "attachmentmultiple">
			
			
		    <cfset suf = "">	
		    <cfloop index="itm" list="#url.id#" delimiters=".">
				<cfset suf = itm>
			</cfloop>	
									
			<CFFILE	action="UPLOAD"
				fileField="UploadedFile"
				destination="#rt##Dir#\#URL.ID#"
				nameConflict="MAKEUNIQUE"
				result="resultload">	
				
				<cfset ar[1] = resultload>
							
		<cfelse>
		
			<!--- added 10/2/2011 for multiple attachment --->
			
			<CFFILE	action="UPLOADALL"		
				destination="#rt##Dir#\#URL.ID#"
				nameConflict="OVERWRITE"
				result="ar">	
				
		</cfif>							
							
		<cfloop array="#ar#" index="filename">
		
			<cfquery name="Att" 
			  datasource="AppsSystem" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">	  
		      SELECT * FROM Ref_Attachment
			  WHERE   DocumentPathName = '#Dir#' 		   
	    	</cfquery>		
				
			<cfset suf = "">	
		    <cfloop index="itm" list="#filename.ClientFile#" delimiters=".">
				<cfset suf = itm>
			</cfloop>			
			<cfset suf = ".#suf#">				
			
			<cfif 	(not findNoCase(suf,att.AttachExtensionFilter)
			      		and att.AttachExtensionFilter neq "NONE"
				  		and len(att.AttachExtensionFilter) gte 3)>
						
						
						<!--- the below was removed instead we control it through the original issue
												
     					or
						(not IsImageFile("#rt##Dir#\#URL.ID#\#filename.ClientFile#")
						 and
						 not IsPdfFile("#rt##Dir#\#URL.ID#\#filename.ClientFile#")
				         and
				         findNoCase(".zip",filename.ClientFile) eq 0
						)
						
						--->

						<cffile action="DELETE"
								 file="#rt##Dir#\#URL.ID#\#filename.ClientFile#">

						<script>alert('Attachment denied')</script>

			<cfelse>	
							
			<cfparam name="Form.ServerFile" default="#filename.ClientFile#">
			 
			<!--- new name of the uploaded file --->
			<CFIF Form.ServerFile is "">
				<CFSET NewServerFile = Replace(URL.ID1,' ','','ALL')&"_"&filename.ClientFile>
			<CFELSE>
				<CFSET NewServerFile = Replace(URL.ID1,' ','','ALL')&"_"&Form.ServerFile&"."&Form.ServerSuffix>
			</CFIF>
						
			
			<CFSET NewServerFile = Replace(NewServerFile,'""','','ALL')>
			<CFSET NewServerFile = Replace(NewServerFile,"'",'','ALL')>
			<CFSET NewServerFile = Replace(NewServerFile,"##",'_','ALL')>
			<CFSET NewServerFile = Replace(NewServerFile,"\",'','ALL')>
			<CFSET NewServerFile = Replace(NewServerFile,"/",'','ALL')>
			<CFSET NewServerFile = Replace(NewServerFile,"`",'','ALL')>
			<CFSET NewServerFile = Replace(NewServerFile,"^",'','ALL')>
			<CFSET NewServerFile = Replace(NewServerFile,"*",'','ALL')>
			
			<!--- KRW: 13/04/07 replace all dashes with underlines --->
			<CFSET NewServerFile = Replace(NewServerFile,"-",'_','ALL')>
			
			<!--- KRW: 23/03/07 replace all accented characters with their unaccented equivilant --->
			<cfset Accent = Chr(193) & "," & Chr(194) & "," & Chr(195) & "," & Chr(196) & "," & Chr(197) & "," & Chr(224) & "," & Chr(225) & "," & Chr(226) & "," & Chr(227) & "," & Chr(228) & "," & Chr(229) & "," & Chr(200) & "," & Chr(201) & "," & Chr(202) & "," & Chr(203) & "," & Chr(232) & "," & Chr(233) & "," & Chr(234) & "," & Chr(235) & "," & Chr(204) & "," & Chr(205) & "," & Chr(206) & "," & Chr(207) & "," & Chr(236) & "," & Chr(237) & "," & Chr(238) & "," & Chr(239) & "," & Chr(210) & "," & Chr(211) & "," & Chr(212) & "," & Chr(213) & "," & Chr(214) & "," & Chr(242) & "," & Chr(243) & "," & Chr(244) & "," & Chr(245) & "," & Chr(246) & "," & Chr(217) & "," & Chr(218) & "," & Chr(219) & "," & Chr(220) & "," & Chr(249) & "," & Chr(250) & "," & Chr(251) & "," & Chr(252) & "," & Chr(209) & "," & Chr(241) & "," & Chr(199) & "," & Chr(231) & "," & Chr(221) & "," & Chr(253)>  
			<cfset SansAccent = Chr(97) & "," & Chr(97) & "," & Chr(97) & "," & Chr(97) & "," & Chr(97) & "," & Chr(97) & "," & Chr(97) & "," & Chr(97) & "," & Chr(97) & "," & Chr(97) & "," & Chr(97) & "," & Chr(101) & "," & Chr(101) & "," & Chr(101) & "," & Chr(101) & "," & Chr(101) & "," & Chr(101) & "," & Chr(101) & "," & Chr(101) & "," & Chr(105) & "," & Chr(105) & "," & Chr(105) & "," & Chr(105) & "," & Chr(105) & "," & Chr(105) & "," & Chr(105) & "," & Chr(105) & "," & Chr(111) & "," & Chr(111) & "," & Chr(111) & "," & Chr(111) & "," & Chr(111) & "," & Chr(111) & "," & Chr(111) & "," & Chr(111) & "," & Chr(111) & "," & Chr(111) & "," & Chr(117) & "," & Chr(117) & "," & Chr(117) & "," & Chr(117) & "," & Chr(117) & "," & Chr(117) & "," & Chr(117) & "," & Chr(117) & "," & Chr(110) & "," & Chr(110) & "," & Chr(99) & "," & Chr(99) & "," & Chr(121) & "," & Chr(121)>
			
			<CFSET NewServerFile = Replacelist(NewServerFile,Accent,SansAccent)>
			
			<!--- KRW: 23/07/07 Removes extra '.' (dots) from file names.  Leaves only last one if there is any --->
			<cfset Dot = Find(".", "#NewServerFile#")>
			<cfif Dot>
			   <!--- this has a suffix --->
				<CFSET NextDot = Find(".", "#NewServerFile#","#Dot#"+1)>
			
				<cfloop Condition="NextDot">
					<CFSET NewServerFile = Replace(NewServerFile,".",'_')>
					<CFSET Dot = Find(".", "#NewServerFile#")>
					<CFSET NextDot = Find(".", "#NewServerFile#","#Dot#"+1)>
				</cfloop>
			
			<cfelse>
			
			   <cfloop index="item" list="#filename.ClientFile#" delimiters=".">   
				   <cfif Len(item) eq "3">   
				      <CFSET NewServerFile = "#NewServerFile#.#item#">   
				   </cfif>   
			   </cfloop>
			
			</cfif> 
			
			<!--- check whether the new file name already exists in the directory --->
			
			<CFDIRECTORY name="CheckFile"
				action="LIST"
				directory="#rt#\#Dir#\#URL.ID#"
				filter="#NewServerFile#">
				
			<CFIF CheckFile.RecordCount is 0 or FileName.ClientFile is FileName.ServerFile>
				<CFSET FileAlreadyExists = "NO">
			<CFELSE>
				<CFSET FileAlreadyExists = "YES">
			</CFIF>
			
			<!--- if file name already exists and overwrite is not allowed delete file and throw an error --->
			
				<CFIF FileAlreadyExists and not IsOverwriteEnabled>
				
					<!--- delete file --->
					<CFSET TempFilePath = "#rt##Dir#\#URL.ID#\#FileName.ServerFile#">
					<CFFILE	action="DELETE"
						file="#TempFilePath#">
				
					<FONT size="+2" color="ff0000"><B>File Already Exists</B></FONT>
					<P>
					
					<input type="text" class="buttonFlat" name="Back" id="Back" value="Back" onClick="history.back()">
				
				<CFELSE>			
						
					<!--- rename file --->
					<CFSET SourceName = "#rt##Dir#\#URL.ID#\#FileName.ServerFile#">
									
					<cffile action="RENAME" source="#SourceName#" destination="#NewServerFile#"> 
						
					<cfif url.dialog eq "1">
					
						<script language="JavaScript">																
														
						try {										    
								parent.parent.document.getElementById("att_#URL.Box#_refresh").click()			
								parent.parent.ProsisUI.closeWindow('attachdialog')						
								} catch(e) {}				
								
						try {										    
								parent.document.getElementById("att_#URL.Box#_refresh").click()			
								parent.ProsisUI.closeWindow('attachdialog')						
								} catch(e) {}			
								
						// cfdivscroll 
								
						try {													    							
							parent.parent.document.getElementById('#url.box#_holdercontent_close').click()														
						} catch(e) {}		
						
							
						</script>
					
					<cfelse>
									
						<script language="JavaScript">		
							
							try {								    
								se = parent.document.getElementById("att_#URL.Box#_refresh")
								se.click() } catch(e) {			
								}		
						
						</script>	
					
					</cfif>
									
					<cfif newserverfile eq "Thumbs.db">
					
						<!--- nada --->
					
					<cfelse>
							   
				       <!--- logging --->
				
					   <cfparam name="CLIENT.logAttachment" default="0">
					   <cfparam name="Form.attachmentMemo" default="">
											
					   <!--- check if entry already exists ---> 
												
								<cfquery name="Reference" 
									datasource="AppsSystem" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT * 
									FROM   Ref_Attachment					
									WHERE  DocumentPathName = '#dir#'											
								</cfquery>		
								
								<!--- check if file exists --->
								
								<cfquery name="Check" 
									datasource="AppsSystem" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT TOP 1 * 
									FROM   Attachment					
									WHERE  ServerPath = '#Dir#/#URL.ID#/'
									AND    FileName   = '#NewServerFile#'							
								</cfquery>
												
								<cfif Check.recordcount eq "0">									
										
									<cf_assignId>
									
									<cfset rep = "#Dir#/#URL.ID#">
									<CFSET rep = replace(rep,"\","|",'ALL')>
									<CFSET rep = replace(rep,"/","|",'ALL')>
									<CFSET rep = replace(rep,"||","|",'ALL')>
								
									<cfquery name="LogAction" 
										datasource="AppsSystem" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										
										INSERT INTO Attachment
										(AttachmentId,
										 <cfif Reference.recordcount eq "1">
										 DocumentPathName,
										 </cfif>						 
										 Server, 
										 ServerPath, 
										 FileName, 
										 Reference,
										 AttachmentMemo,
										 OfficerUserid, 
										 OfficerLastName, 
										 OfficerFirstName)
										VALUES
										('#rowguid#',						
										 <cfif Reference.recordcount eq "1">
										 '#dir#',
										 </cfif>						 
										 <cfif FORM.DocumentServer neq "No">			
										 	'documentserver',
										 <cfelseif host eq "#SESSION.rootDocumentPath#\">
										    'document',
										 <cfelse>
										 	'#host#',
										 </cfif>
										 
										 <cfif FORM.DocumentServer neq "No">			
										 	'#FORM.DocumentServerPath#',
										 <cfelse>
										 
										  <cfif mode eq "Report">
										    '#rep#',
										  <cfelse>
										 	'#Dir#/#URL.ID#/',
										  </cfif>	
										  
										  </cfif>		
										  						  				 
										 '#NewServerFile#', 
										 '#URL.ID#',
										 '#Form.attachmentMemo#',
										 '#SESSION.acc#',
										 '#SESSION.last#',
										 '#SESSION.first#') 
									</cfquery>					
									
									<cfset aid = rowguid>
									<cfset ser = 1>
									<cfset act = "insert">
									
								<cfelse>					
								
									<!---- Check Document Server and update the existing location ------>
															
									<cfif FORM.DocumentServerPath neq "">
									
										<cfquery name="Log" 
											datasource="AppsSystem" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
												UPDATE Attachment
												SET    ServerPath   = '#FORM.DocumentServerPath#'
												       ActionStatus = '1'
												WHERE  AttachmentId = '#check.attachmentid#'
										</cfquery>
										
									</cfif>		
																
									<cfquery name="Log" 
									datasource="AppsSystem" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT max(SerialNo) as No
										FROM   AttachmentLog
										WHERE  AttachmentId = '#check.attachmentid#' 
									</cfquery>	
									
									<cfset aid = check.attachmentid>
									
									<cfif Log.recordcount eq "0">
										<cfset ser = 1>
									<cfelse>
										<cfset ser = log.No+1>
									</cfif>	
									<cfset act = "update">
									
									<cfif Check.FileStatus eq "9">
										<!--- If the file is deleted, then reinstate it --->
											<cfquery name = "UpdateAttachment" 
											datasource    = "AppsSystem" 
											username      = "#SESSION.login#" 
											password      = "#SESSION.dbpw#">
												UPDATE Attachment
												SET    FileStatus   = '1'
												WHERE  AttachmentId = '#Check.Attachmentid#'
											</cfquery>
									</cfif>
								</cfif>	
												
								<cfparam name="Form.attachmentMemo" default="">
								
								<cfif Len(Form.attachmentMemo) gt 80>
									<cfset memo = left(Form.attachmentMemo,80)>
								<cfelse>
									<cfset memo = form.attachmentmemo>	
								</cfif>
								
								<cfif CGI.HTTPS eq "off">
							      <cfset protocol = "http">
								<cfelse> 
								  <cfset protocol = "https">
								</cfif>
									
								<cfquery name="LogAction" 
									datasource="AppsSystem" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									INSERT INTO AttachmentLog
											(AttachmentId,
											 SerialNo, 
											 FileAction, 	
											 FileActionMemo,	
											 FileActionServer,	
											 OfficerUserid, 
											 OfficerLastName, 
											 OfficerFirstName)
									VALUES  ('#aid#',
											 '#ser#',
											 '#act#',		
											 '#memo#',	
											 '#protocol#://#CGI.HTTP_HOST#/',
											 '#SESSION.acc#',
											 '#SESSION.last#',
											 '#SESSION.first#') 
								</cfquery>										
																						
								<cfif client.logattachment eq "1">
														
									<cftry>		  				  		
								  		<cfdirectory action="CREATE" 
								               directory="#rt##Dir#\#URL.ID#\logging\#aid#">
									    <cfcatch></cfcatch>
									</cftry>
													
								    <!--- copy the file to the logging directory --->
									
								    <cffile action="COPY"
								        source="#rt##Dir#\#URL.ID#\#NewServerFile#" 
										destination="#rt##Dir#\#URL.ID#\logging\#aid#">										
										  
									<cffile action="RENAME" 
										source="#rt##Dir#\#URL.ID#\logging\#aid#\#NewServerFile#" 
										destination="[#ser#]_#NewServerFile#">	  					
													
								</cfif>			
															
								<cfif FORM.DocumentServerPath neq "">
								
										<cfset oDocumentServer = CreateObject("component","Service.ServerDocument.Document")/>
										<cfset aResponse = oDocumentServer
									   	    .SetMode("#Form.DocumentServer#")
											.Upload("#rt##Dir#\#URL.ID#","#NewServerFile#","#Form.DocumentServerPath#","#aid#")/>	
																
											<!---1 = Sucessfully uploaded
											<cfoutput>
											<cf_logpoint>	
												#aResponse#
											</cf_logpoint>
											</cfoutput>		
											
											0 = Error 
											DELETE THE FILE FROM THE SOURCE.
											------->
											
								</cfif>		
																				
								<cfparam name="url.pdfconvert" default="false">
								
								<!--- -------------------- --->
								<!--- check for conversion --->
								<!--- -------------------- --->
												
								<cfif url.pdfconvert eq "true">
								
								    <!--- passed from the template, now check if it is enabled --->
									
									<cfif Reference.AttachMultipleConvertPDF eq "1">					
										<cfparam name="Form.PDFConvert"     default="Yes">
										<cfparam name="Form.KeepOriginal"   default="No">
									<cfelse>
										<cfparam name="Form.PDFConvert"     default="No">
										<cfparam name="Form.KeepOriginal"   default="No">					
									</cfif>	
									
								<cfelse>
									<cfparam name="Form.PDFConvert"     default="No">
									<cfparam name="Form.KeepOriginal"   default="Yes">
								</cfif>
													
								<!--- PDF and original was not PDF --->
								<cfif Form.PDFConvert eq "Yes">
								 
								 	<cfif UCase(Right(FileName.ClientFile,4)) eq ".XLS"
									or UCase(Right(FileName.ClientFile,4)) eq ".DOC"
									or UCase(Right(FileName.ClientFile,5)) eq ".DOCX"
									or UCase(Right(FileName.ClientFile,4)) eq ".HTM"
									or UCase(Right(FileName.ClientFile,5)) eq ".HTML"
									or UCase(Right(FileName.ClientFile,4)) eq ".TXT"
									or UCase(Right(FileName.ClientFile,4)) eq ".RTF"
									or UCase(Right(FileName.ClientFile,4)) eq ".PPT">
																		
										<cf_FileToPDF
										     attachmentid="#aid#"
											 host="#host#"
											 documentpathname="#dir#"
										 	 path="#rt#\#Dir#\#URL.ID#"
											 pathurl="#Dir#\#URL.ID#"
											 keepfile="#Form.KeepOriginal#"
											 file="#NewServerFile#"
											 id="#url.id#"
											 memo="#Form.attachmentmemo#">		
														 
									</cfif>	
									
								</cfif>
										
					</cfif>	
						
				</CFIF>	
				
			</cfif>	
					
		</cfloop>
			
	</cfoutput>

</cfif>

