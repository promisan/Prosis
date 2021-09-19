
<cfparam name="visible"                 default="yes">
<cfparam name="boxw"                    default="100%">
<cfparam name="inputsize"               default="300">
<cfparam name="presentation"            default="default">
<CFParam name="Attributes.Label"        default="attach">
<CFParam name="Attributes.ButtonHeight" default="20">
 
<cf_param name="URL.mode"    		default="" type="String">
<cf_param name="URL.DocumentHost"   default="" type="String">
<cf_param name="URL.DocumentPath"   default="" type="String">
<cf_param name="URL.Filter"    		default="" type="String">
<cf_param name="URL.List"    		default="" type="String">
<cf_param name="URL.SubDirectory"   default="" type="String">
<cf_param name="URL.ShowSize"       default="" type="String">
<cf_param name="URL.Insert"	        default="" type="String">
<cf_param name="URL.List"  		    default="" type="String">
<cf_param name="URL.attbox"		    default="" type="String">
<cf_param name="URL.boxw"		    default="" type="String">
<cf_param name="URL.color"		    default="" type="String">
<cf_param name="URL.maxfiles"	    default="" type="String">
<cf_param name="URL.remove"		    default="" type="String">
<cf_param name="URL.rowheader"	    default="" type="String">
<cf_param name="URL.align"		    default="" type="String">
<cf_param name="URL.attachdialog"   default="" type="String">
<cf_param name="URL.border"  		default="" type="String">
<cf_param name="URL.documentserver"	default="" type="String">
<cf_param name="URL.embedgraphic"	default="" type="String">
<cf_param name="URL.inputsize"		default="" type="String">
<cf_param name="URL.pdfscript"		default="" type="String">
<cf_param name="URL.presentation"	default="" type="String">

<cfif url.documenthost neq "">

	<cfset checkHost = "#replace(url.documenthost,'|','\','ALL')#">

	<cfquery name="qCheck" 
	datasource="AppsSystem">
		SELECT *
	  	FROM   Ref_Attachment
		WHERE  DocumentFileServerRoot = '#checkHost#'
	</cfquery>	
	
	<cfquery name="qCheckParameter" 
	datasource="AppsInit">
		SELECT *
	  	FROM   Parameter
		WHERE  DocumentRootPath = '#checkHost#' OR ReportRootPath = '#checkHost#'
	</cfquery>	
	
	<cfif qCheck.recordcount eq 0 AND  qCheckParameter.recordcount eq 0>
	
			<cf_ErrorInsert	 ErrorSource   = "URL"
				 ErrorReferer              = ""
				 ErrorDiagnostics          = "URL parameter Document Host, value #checkHost# is not a valid document host."
				 Email                     = "1">
	
			<cf_message status = "Alert"
				message="<br>Alert : There are reasons to believe that the URL has been compromised. <br><br><b><font color='804040'>Your request can not be executed!</font><br>" return="No">
				
			<cfabort>		
		
	</cfif>

</cfif>

<cfoutput>

	 <cfif DocumentServer neq "No">
	
			<cfquery name="Parameter" 
			datasource="AppsInit">
				SELECT * 
				FROM   Parameter
				WHERE HostName = '#CGI.HTTP_HOST#'
			</cfquery>
		
			<!---- a Document server has been enabled for this IP (e.g. Xythos) 
			CHECK IF THE SERVER IS UP AND IF HE DOES NOT FIND IT, SKIP THE MODE AND MAKE THE DOCUMENTSERVER =1 
			---->	
	
			<cfif Parameter.DocumentServer neq "">
				<cfset DocumentServerIsOp="1">					
			<cfelse>
				<cfset DocumentServerIsOp="0">
			</cfif>
			
	<cfelse>
	
		<cfset DocumentServerIsOp="0">	

	</cfif>	
	
<table width="#boxw#" align="center" cellspacing="0" cellpadding="0">

<tr class="hide"><td class="labelit" id="doclogaction"></td></tr>

<cfset host = "#replace(DocumentHost,'\','|','ALL')#">

<cfif (insert eq "yes" or remove eq "yes") and listing eq "1">

	 <input type="hidden" name="#attbox#_attachsubdir" id="#attbox#_attachsubdir" value="#Subdirectory#">		

	 <!--- used to refresh data which can be called from others --->
		
     <input type="button" 
	     id="att_#attbox#_refresh" name="att_#attbox#_refresh" style="width:30"
		 onclick="attrefresh('#mode#','#DocumentPath#','#host#',document.getElementById('#attbox#_attachsubdir').value,'#Filter#','#list#','#ShowSize#','#Listing#','#Insert#','#remove#','#color#','#attbox#','#rowheader#','#boxw#','#Align#','#Border#','#attachdialog#','#inputsize#','#pdfscript#','#memo#','#embedgraphic#','#documentserver#','#presentation#','#maxfiles#')" 
	     class="hide"> 
	
</cfif>

<!--- convert back to the proper syntax --->

<cfset docHost = replaceNoCase(DocumentHost,"|","\","ALL")> 
<cfset docPath = replaceNoCase(DocumentPath,"|","\","ALL")> 

<cfif mode eq "Report">
    <!--- they are stored in the application directory --->
    <cfset rt = "">
<cfelse>
	<cfset rt = "#docHost#">
</cfif>

<cfif DocumentServerIsOp eq "1">

    <!---	No creation of directories.
			No use of Filter/*.* --->
	
	<cfset oDocumentServer = CreateObject("component","Service.ServerDocument.Document")/>
	<cfset GetFiles = oDocumentServer
				.SetMode("#DocumentServer#")
				.ListSubDirectory("#SubDirectory#","#SESSION.rootDocumentPath#","#Filter#")/>
									
<cfelse>

	<cftry>
							
	  <cfdirectory action="LIST" 
		directory="#rt##DocPath#\#SubDirectory#" 
		name="GetFileSource" 
		sort="DateLastModified DESC" 
		filter="#Filter#*.*">						
		
		<cfif GetFileSource.recordcount eq "0">
		
			<cftry>
		
			<cfdirectory action   = "DELETE" 
				 directory= "#rt##DocPath#\#SubDirectory#">	 
				 
				 <cfcatch></cfcatch>
			
			</cftry>	 
		
		</cfif>
		
		<!--- ---------------------------- --->
		<!--- limit the result to be shown --->
		<!--- ---------------------------- --->

		<cfquery name="GetFiles" dbtype="query">
			SELECT  *  
			FROM    getFileSource
			WHERE   Name <> 'Thumbs.db'
		</cfquery>
		
	<cfcatch>
			<cf_message status = "Alert"
				message="<br>Alert : There are reasons to believe that the URL has been compromised. <br><br><b><font color='804040'>Your request can not be executed!</font><br>" return="No">
				
			<cfabort>			
	</cfcatch>		
	</cftry>
	

</cfif>	

<!--- --------------------------------------------------------------------------- --->
<!--- add provision to complement with files that are tagged as marked as removed --->
<!--- --------------------------------------------------------------------------- --->

<cfset Caller.attNo = GetFiles.recordcount>
	
<!--- ---------------------------------- --->	
<!--- mode in which listing is requested --->
<!--- ---------------------------------- --->	

				
<cfif Listing eq "1" and GetFiles.recordcount gt "0">	

<tr><td colspan="2" style="padding-bottom:1px;border-bottom: 0px solid d4d4d4;">

	<table width="100%" align="#align#"> 
		
		<tr>
						
		<cfif insert eq "yes" and attachdialog  neq "no" and maxfiles gt getFiles.recordcount>
								
			<td valign="top" style="padding:2px 0 5px;border-bottom: 1px dotted silver">								
				<cfinclude template="FileLibraryMenu.cfm">								  
			</td>  
								
		<cfelse>
		
			<td width="0"></td>
							  
		</cfif>		
		
		</tr>	
		
		<tr>
		
		<td width="100%">
				
			<table width="<cfif list eq 'regular'>100%</cfif>" 
			    class="<cfif list eq 'regular'>navigation_table</cfif>" 
				navigationhover="e4e4e4" 
				navigationselected="D3F5F8">
			
			<cfset row = 1>
					
			<cfif GetFiles.recordCount gt 0>
			
			    <cfif rowheader eq "Yes">
					<TR class="line">
					   <td colspan="6" class="cellcontent" align="center" class="top3n" style="padding-left:4px"><cf_tl id="Attachment"></td>				   				  
					</TR>	
									
				</cfif>
				
			</cfif>		
						
			<cfset contextmode = mode>
						  
			<cfset attlist = ""> 			
									
			<cfif list eq "regular" or list eq "thumbnail" or list eq "mail">  
						
			    <!--- this is a horizontal list --->
				
			    <cfif list eq "thumbnail">												
					<tr>	
					<td>
					<table><tr>								
				</cfif>
												
				<cfloop query="GetFiles">
								
					<cfif DocumentServerIsOp eq "0">
					
						<cfset docpath = documentpath>
						<cfif subdirectory eq "">
							<cfset  docpath = docpath>
						<cfelse>
						    <cfset  docpath = "#DocPath#/#Subdirectory#/">	
						</cfif>
						
					<cfelse>
					
						<cfset docpath=Directory>			
						
					</cfif>																		
					
					<cfset docpath = replace(docpath,"//","/","ALL")>
					
					<cfif DocumentServerIsOp eq "1">
					   <cfset srv = "documentserver">  
					   <cfset vAttachmentId = GetFiles.AttachmentId>					
					<cfelse>
					   <cfset srv = "#dochost#">	
					   <cfset vAttachmentid = "">					  							
					</cfif>
				
					<!--- -------------------------------------------- --->																										
					<!--- ----check if file exists in the database---- --->
					<!--- -------------------------------------------- --->
								
					<cfif DocumentServerIsOp eq "0">
					
						<cfinvoke component = "Service.Document.Attachment"  
							   method           = "VerifyDBAttachment" 
							   server           = "#srv#"
							   docpath          = "#docpath#" 
							   filename         = "#name#"
							   reference        = "#subdirectory#"
							   attachmentid     = "#vAttachmentId#"
							   returnvariable   = "Attachment">			
							   
					<cfelse>
					
					   <cfif vAttachmentId eq "">
					   		<cfset vAttachmentId = "00000000-0000-0000-0000-000000000000">
					   </cfif>
					
						<cfquery name="Attachment" 
								 datasource="AppsSystem"
								 username="#SESSION.login#" 
								 password="#SESSION.dbpw#">
								     SELECT   *
									 FROM     Attachment
									 WHERE    AttachmentId = '#vAttachmentId#'
									 ORDER BY Created DESC
						</cfquery>						

					</cfif>
					<!--- ------------------------------------------- --->	   		
					<!--- ------------------------------------------- --->
				
					<cfif list eq "regular">				
						<!--- listing --->										
						<tr class="navigation_row" bgcolor="<cfif attachment.filestatus eq '9'>FF8080</cfif>">										
					</cfif>
									
					<!--- attachment list --->						
						
						<cfif attlist eq "">
							<cfset attlist = "'#attachment.attachmentid#'">
						<cfelse>
							<cfset attlist = "#attlist#,'#attachment.attachmentid#'">
						</cfif>						
							
						<!--- show only files not directories --->
																
						<cfif type is "FILE">
																										
							<CFSET SeparatorPos = Find( '.', Reverse(#Name#) )>
							<cfset x = len(name)>
							<cfset y = find('_', name)>
										
							<cfset nameshow = right(name, x-y)>
							
								<cfif Attachment.delayedAction eq "delete">
								
									<!--- hide and delete records --->
																	
									<cffile action="DELETE"
			       						file="#rt##Attachment.ServerPath#\#Attachment.FileName#">												
										
									<!--- remove the logging as well --->	
															
									<cfif directoryExists("#rt##Attachment.ServerPath#\Logging\#attachment.attachmentid#\")>
										
										<cfdirectory action="DELETE"
							             directory="#rt##Attachment.ServerPath#\Logging\#attachment.attachmentid#\"
							             recurse="Yes">	 
											
									</cfif>	 	
																		  
									<cfquery name="Delete" 
										datasource="AppsSystem" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										DELETE FROM Attachment
										WHERE  AttachmentId = '#attachment.attachmentid#'															
									</cfquery>							
								
								<cfelse>	
																																									
									<cfif attachment.filestatus eq "9">									
										
										<td colspan="2" class="labelheader">#NameShow#</td>						
												
									<cfelseif FindNoCase(".pdf", "#NameShow#") and pdfscript neq "" and pdfscript neq "undefined"> 
									
										<td colspan="2" class="labelheader">	
																			
										<button type="button" class="button10g" onClick="#pdfscript#('#name#')">
											<img src="#SESSION.root#/Images/pdf_small1.gif" alt="Upload file" border="0" align="absmiddle">&nbsp;<font color="gray">#NameShow#
										</button>
										
										</td>
										
									<cfelseif (FindNoCase(".jpg", "#NameShow#") 
									      or FindNoCase(".png", "#NameShow#") or FindNoCase(".flv", "#NameShow#") 
										  or FindNoCase(".gif", "#NameShow#")) and embedgraphic eq "yes">  
									  	
																  
									    <cfif list eq "regular">	
																					
						                    <td width="10%" style="padding-left:1px" valign="top"
											 onclick="showfile('#contextmode#','view','#attachment.attachmentid#')" align="center">		
											  								  		
												<cfif FindNoCase(".flv", "#NameShow#") or DocumentServerIsOp eq "1">						
	
											    	<img src="#SESSION.root#/Images/file_image.jpg" style="cursor:pointer;border:1px solid silver" 
													align="absmiddle" alt="Open Image" height="40" width="60" border="0" align="center">
	
												<cfelse>	
																																																
													<cfset vServerPathDoc = "">
													<cfset vReplaceDashes = 0>
													<cfif attachment.server eq "documentserver" or attachment.server eq "document">
														<cfset vServerPathDoc = session.rootdocument>
													<cfelse>
														<cfset vServerPathDoc = attachment.server>
														<cfset vReplaceDashes = 1>
													</cfif>
													
													<cfif vServerPathDoc neq "">
													
														<cfif attachment.server eq "report">
															<cfset vServerPathDocFull = "#DocPath#/#name#">
															<cfset vServerPathDocFull = replace(vServerPathDocFull,"|","\","ALL")>
										                <cfelse>
							                               <cfset vServerPathDocFull = "#vServerPathDoc#/#DocPath#/#name#">
										                </cfif> 
														
														<cfif vReplaceDashes eq 1>
															<cfset vServerPathDocFull = replace(vServerPathDocFull,"/","\","ALL")>
														</cfif>
														
														<cftry>	
	
														<cfif findNoCase(",",vServerPathDocFull) or findNoCase(" ",vServerPathDocFull)>
																												
														<img src="#SESSION.root#/Images/file_image.jpg" 
															    style="width:35px;height:35px;cursor:pointer;border:0px solid silver;" 
																align="absmiddle" 
																alt="Open Image" border="0" align="center">	
																												
														<cfelse>																									
																												   																																								
															<cffile action="COPY" 
																source="#vServerPathDocFull#" 
											    		    	destination="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\tn_#trim(name)#" 
																nameconflict="OVERWRITE">																																														
																																									
															<img src="#SESSION.root#/CFRStage/User/#SESSION.acc#/tn_#trim(name)#" 
															    style="cursor:pointer;border:1px solid silver;" 
																align="absmiddle" 
																alt="Open Image" height="36" width="60" border="0" align="center">	
																																														
														</cfif>
																														
														<cfcatch></cfcatch>																							
															
														</cftry>	
														
													</cfif>
													
																									
												</cfif>											
																							
											</td>																											  
											
											<td width="50%" style="padding-left:10px;cursor:pointer" 
											   onclick="" class="cellcontent">
											   
											   <table>											   
											   <tr class="labelmedium"><td>
											   <a href="javascript:embedfile('#contextmode#','#attachment.attachmentid#','show','#attachment.attachmentid#')">#Nameshow#</a></td></tr>											   
											   <cfif len(Attachment.attachmentMemo) gte "5" and attachment.attachmentmemo neq "Detected">									 	
													<tr class="labelmedium" style="height:15px">													    
														<td>#Attachment.AttachmentMemo#</td>
													</tr>													
												</cfif>										   
											   </table>											  
										   </td>    	               
										
										<cfelse>
																				
										
											<td height="22" style="padding-left:4px" 
											 onclick="embedfile('#contextmode#','#attachment.attachmentid#','show','#attachment.attachmentid#')">		
											 
											 											  									  		
												<cfif FindNoCase(".flv", "#NameShow#") or DocumentServerIsOp eq "1">						
	
											    	<img src="#SESSION.root#/Images/file_image.jpg" style="cursor:pointer;border:1px solid silver" align="absmiddle" alt="Open Image" height="40" width="60" border="0" align="center">
	
												<cfelse>	
												
												    <!--- needs some correction if the server operate from a different box --->
																																																																										
													<img src="#session.rootdocument#/#DocPath#/#name#" 
													    style="cursor:pointer;border:1px solid gray" 
														align="absmiddle" 
														alt="Open Image" 
														height="40" width="auto" border="0" align="center">																																					
													
												</cfif>											
																							
											</td>											
										
										</cfif>	
									
									<cfelse>	
																		
									    <!--- ---------------------------------------- --->
									    <!--- provision to open files in the edit mode --->
										<!--- ---------------------------------------- --->
									
										<cfif (FindNoCase(".cfm", "#NameShow#") or FindNoCase(".cfc", "#NameShow#") or FindNoCase(".txt", "#NameShow#") or FindNoCase(".htm", "#NameShow#")) and DocumentServerIsOp eq "0">			  						  
						
											  <cfif Remove eq "yes">
												  <cfset openas = "edit"> 
											  <cfelse>
											  	  <cfset openas = "read"> 
											  </cfif>	  		
										
										<cfelse>
										
											<cfset openas = "view">
											
										</cfif>	  
																					
										<td align="center" 
										    width="10%" 
											height="22" 
											onclick="showfile('#contextmode#','#openas#','#attachment.attachmentid#')">
														
										<cf_space spaces="10">														
										
										<CFIF SeparatorPos is 0> 
										     <!--- separator not found --->
										<CFELSE>
											<CFSET FileExt = Right(Name, SeparatorPos - 1)>
										</CFIF>		
																										
										<cfinclude template="FileLibraryShowIcon.cfm">	
																	
										</td>	
																																										
										<cfif DocumentServerIsOp eq "0">			
											<td width="50%" class="cellcontent" style="padding-left:10px" 
											    onclick="showfile('#contextmode#','#openas#','#attachment.attachmentid#')">												
												<a href="##">#Nameshow#</a>												
											</td>
										<cfelse>

										    <cfset theUrl = Attachment.FileName />
										    <cfset theUrl = listRest(theUrl, "?")>
										    <cfset vName = "">
										    <cfloop list="#theUrl#" index="URLPiece" delimiters="&">
										    	<cfif FindNoCase("template_name",URLPiece) neq 0>
											    	<cfset vName = listLast(URLPiece, "=")>
										    	</cfif>
										    </cfloop>

										    <cfif vName eq "">
										    	<cfset vName = NameShow>
										    </cfif>

										    <cfset vName = Replace(vName,"#Filter#_","","all")>
										    <cfset vUrl  = Replace(Attachment.FileName,"#Filter#_","","all")>

											<td width="50%" class="cellcontent" style="padding-left:10px" >
												<a href="#vURl#" target="new">#vName#</a>
											</td>

										</cfif>	
										
									</cfif>
									
									<!--- only for regular listing enabled --->
												
									<cfif list eq "regular" and ShowSize eq "1">
									
								    	<td width="20%" class="cellcontent" nowrap><cfif attachment.AttachmentMemo eq "Detected"><font color="6688aa">#Attachment.OfficerFirstName# #Attachment.OfficerLastName#<cfelse>#Attachment.OfficerFirstName# #Attachment.OfficerLastName#</cfif></font></td>
								    	
								    	<cfif DocumentServerIsOp eq "0">
									    	<TD width="10%" class="cellcontent" nowrap>#DateFormat(DateLastModified, CLIENT.DateFormatShow)#&nbsp;#TimeFormat(DateLastModified, "HH:MM")#&nbsp;</TD>
								    		<TD width="10%" class="cellcontent" style="padding-right:10px" align="right"><cfset kb = (Size/1024)> #numberFormat(kb, "_____._" )#kb</TD>	
								    	</cfif>															
																	
										<td width="20" style="padding-right:7px">
																				
											<img src="#SESSION.root#/Images/Info.png" alt="Log" 
												border="0" 
												height="16" width="16"
												align="absmiddle" 
												style="cursor: pointer;" 
												onClick="logdocfile('#attachment.attachmentid#','#attbox#_#currentrow#')"> 				
														
										</td>
									
									</cfif>
									
									<cfif List eq "regular" and remove eq "yes">
																	
										<td nowrap align="center">
																		
										    <img src="#SESSION.root#/Images/Close.png" alt="Delete" 
												border="0" 
												height="24" width="24"
												align="absmiddle" 
												style="cursor: pointer;"
												tooltip="Remove document" 
											    onClick="delfile('#contextmode#','Remove attachment #Name#','#attachment.attachmentid#','#DocumentPath#','#host#','#Subdirectory#','#Filter#','#Name#','#list#','#ShowSize#','#Listing#','#Insert#','#remove#','#color#','#attbox#','#rowheader#','#boxw#','#Align#','#Border#','#attachdialog#','#inputsize#','#pdfscript#','#memo#','#embedgraphic#','#documentserver#','#presentation#','#maxfiles#')"> 
										
										 </td>
									 
									 </tr>
									 
									<cfelseif List eq "thumbnail" and remove eq "yes">
									 
									 <td align="left" valign="top" style="padding-left:3px;padding-top:6px;padding-right:5px">
																		
										 <img src="#SESSION.root#/Images/Close.png" alt="Delete" 
												border="0" 
												height="24" width="24"
												align="absmiddle" 
												style="cursor: pointer;"
												tooltip="Remove document" 
											    onClick="delfile('#contextmode#','Remove attachment #Name#','#attachment.attachmentid#','#DocumentPath#','#host#','#Subdirectory#','#Filter#','#Name#','#list#','#ShowSize#','#Listing#','#Insert#','#remove#','#color#','#attbox#','#rowheader#','#boxw#','#Align#','#Border#','#attachdialog#','#inputsize#','#pdfscript#','#memo#','#embedgraphic#','#documentserver#','#presentation#','#maxfiles#')"> 
										
									 </td>									 
									 
									</cfif>				
								
								</cfif>																		
								
								<cfif list eq "regular">									 
									 
									 <cfif (FindNoCase(".jpg", "#NameShow#") or FindNoCase(".png", "#NameShow#") or FindNoCase(".flv", "#NameShow#") or FindNoCase(".gif", "#NameShow#")) and EmbedGraphic is "yes">    
								
									    <!--- container to show --->										
										<cfparam name="rowguid" default="99">									
				                    	<tr class="hide" id="b#attachment.attachmentid#"><td colspan="8" id="#attachment.attachmentid#"></td></tr>									
										
				                    </cfif>
									
									<tr class="hide" id="logbox#attbox#_#currentrow#"><td colspan="8" id="logboxcontent#attbox#_#currentrow#"></td></tr>
									
									<cfif currentrow neq recordcount>		
										<tr class="line"><td colspan="8"></td></tr>
									</cfif>
									 
								</cfif>	 							
								
						</cfif>
								
				</cfloop>
				
				<cfif list eq "thumbnail">
				
					</tr>
					</table>	
					</td></tr>
					
					<!--- create containers --->	
											
					<cfset container = replaceNoCase(attlist,"'","","ALL")>				
										
					<cfloop index="itm" list="#container#">
								
						<!--- container to show --->																							
				           <tr class="hide" id="b#itm#"><td style="width:940px" colspan="3" id="#itm#"></td></tr>																
					
					</cfloop>
										
					<!--- now we prepare the containers for showing as a list --->
					
				
				</cfif>
				
				<!--- -------------------------------------------------------------------------------------------------------- --->
				<!--- check if for cleaning if and only if the files are not stored in a External Document Server (e.x Xythos) --->
				<!--- -------------------------------------------------------------------------------------------------------- --->
				
				<cfif DocumentServerIsOp eq "0">				
									
					<cfinvoke component = "Service.Document.Attachment"  
					   method           = "CleanDBAttachment" 					  
					   server           = "#srv#"
					   docpath          = "#docpath#" 
					   filter           = "#filter#"
					   found            = "#attlist#">		
					   			
				</cfif>					
				
				<!--- ------------------------------------------------------ --->
				<!--- ------------NEW SHOW REMOVED FILES-------------------- --->
				<!--- ------------------------------------------------------ --->
				
				<cfif list eq "regular" and Presentation eq "All">
				
					<!--- show removed files --->
					
					<cfquery name="AttachmentDeleted" 
						 datasource="AppsSystem"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						     SELECT   *
							 FROM     Attachment							
							 WHERE    (ServerPath = '#docpath#' or ServerPath = 'document/#docpath#')
							 <cfif filter neq ''>
							 	AND Filename like '#filter#%'
							 </cfif>							 
							 AND      FileStatus = '9'
							 ORDER BY Created DESC
					</cfquery>		
				
					<cfif AttachmentDeleted.recordcount gte "0">
					
						  <cfloop query="AttachmentDeleted">
					
					      <TR class="navigation_row">		
											
							<td height="22"></td>						
																	
							<TD width="2"></TD>
																
							<td width="50%" class="cellcontent"><font color="FF0000"><Strike>#FileName#</strike></font></TD>
																			
							<cfif ShowSize eq "1">
							   	<td width="180" class="cellcontent" nowrap><font color="FF0000"><Strike>#OfficerFirstName# #OfficerLastName#</font></td>
							   	<TD width="120" class="cellcontent" nowrap><font color="FF0000"><Strike>#DateFormat(Created, CLIENT.DateFormatShow)#&nbsp;#TimeFormat(Created, "HH:MM")#&nbsp;</TD>
								<TD width="100" align="right"></TD>						
							</cfif>
										
							<td width="20">
										
								<img src="#SESSION.root#/Images/info2.gif" 
								    alt="Document Action Log" 
									border="0" height="13" width="13"
									align="absmiddle" 
									style="cursor: pointer" 
									onClick="logdocfile('#attachmentid#','del#attbox#_#currentrow#')"> 				
														
							</td>
									
							<td nowrap align="center" width="20"></td>
													
						   </tr>	
																											
						   <tr class="hide" id="logboxdel#attbox#_#currentrow#">
							 <td colspan="9"><cfdiv id="logboxcontentdel#attbox#_#currentrow#"/></td>
						   </tr>
									
						   <cfif currentrow neq recordcount>		
							<tr class="line"><td colspan="9"></td></tr>
						   </cfif>
							
						  </cfloop>
										
					</cfif>
				
				</cfif>
							
						
			<cfelse>
			
				<!---
			
				<!--- -------------------------------------- --->
				<!--- hanno define when this is shown???---- --->
				<!--- -------------------------------------- --->
						
				<tr>
				<td>
				
				<table cellspacing="0" cellpadding="0"><tr>
				
				<cfloop query="GetFiles">
				
					<cfif DocumentServerIsOp eq "0">
						<cfset docpath = documentpath>					
						<cfif subdirectory eq "">
							<cfset  docpath = docpath>
						<cfelse>
						    <cfset  docpath = "#DocPath#/#Subdirectory#/">	
						</cfif>
					<cfelse>
						<cfset docpath = Directory>
					</cfif>		
					
					<cfset docpath = replace(docpath,"//","/","ALL")>
					
					<cfif DocumentServerIsOp eq "1">
					   <cfset srv = "documentserver">  
					   <cfset vAttachmentId=#GetFiles.AttachmentId#>					
					<cfelse>
					   <cfset srv = "#dochost#">	
					   <cfset vAttachmentid = "">					  							
					</cfif>
														
					<!--- check if file exists in the database --->
						<cfinvoke component = "Service.Document.Attachment"  
						   method           = "VerifyDBAttachment" 
						   server           = "#srv#"
						   docpath          = "#docpath#" 
						   filename         = "#name#"
						   reference        = "#subdirectory#"
						   attachmentid     = "#vAttachmentId#"
						   returnvariable   = "Attachment">					
					<!--- ----------------------------------- --->
													
					<td class="cellcontent" style="padding-left:5px;padding-right:5px">
								
					<CFSET SeparatorPos = Find( '.', Reverse(#Name#) )>
					<cfset x = len(#name#)>
					<cfset y = find('_', '#name#')>
								
					<cfset nameshow = right("#name#", '#x-y#')>
							
					<CFIF SeparatorPos is 0> <!--- separator not found --->
					<CFELSE>
						<CFSET FileExt = Right(Name, SeparatorPos - 1)>
					</CFIF>		
					
					<cfinclude template="FileLibraryShowIcon.cfm">											
					<a href="javascript:showfile('#contextmode#','#openas#','#attachment.attachmentid#')">#Nameshow#</a>
					</TD>
										
					<td nowrap align="center" width="20" style="padding-right:5px">					
						
						<cfif Remove eq "yes">
						
							<img src="#SESSION.root#/Images/delete5.gif" alt="Remove document" 
							border="0" 
							height="12" width="12"
							align="absmiddle" 
							style="cursor: pointer;" 
							onClick="delfile('#contextmode#','Remove attachment #Name#','#attachment.attachmentid#','#DocumentPath#','#host#','#Subdirectory#','#Filter#','#Name#','#list#','#ShowSize#','#Listing#','#Insert#','#remove#','#color#','#attbox#','#rowheader#','#boxw#','#Align#','#Border#','#attachdialog#','#inputsize#','#pdfscript#','#embedgraphic#','#documentserver#','#presentation#','#maxfiles#')"> 
														
						</cfif>
						
					</td>
				
				</cfloop>
				
				</tr>
				</table>
				</td>
				</tr>
				
				--->
								
			</cfif>			
			
			</TABLE>
		
	     </td>
		 </tr>
	
	</table>
	
</td></tr>	
				
<cfif attachdialog eq "No" and insert eq "yes" and maxfiles gt getFiles.recordcount>
				
		<tr id="attach" class="regular">		
				<td colspan="2" height="28">	
				
					<iframe src="#SESSION.root#/tools/document/FileFormFrame.cfm?inputsize=#inputsize#&Box=#attbox#&HOST=#host#&DIR=#DocumentPath#&ID=#Subdirectory#&ID1=#filter#&reload=1"
			        width="100%" height="34" style="margin-left:-3px;" scrolling="no" frameborder="0"></iframe>
							
				</td>
		</tr>
		
</cfif>		
	
<!--- -------------------------------------- --->	
<!--- initial mode, just ask for attachment- --->
<!--- -------------------------------------- --->		

<cfelse>

<tr><td colspan="2">



	   <cfif insert eq "yes" and maxfiles gt getFiles.recordcount>

	   	<cfif attachdialog neq "No">
					   
			<table>
			<tr>		
					<style>
							.highlight1{
								border-radius:5px;
							}
							.highlight1:hover{
								background:##dddddd!important;
							}
					</style>
					
					<cfsavecontent variable="selectme">
			        		style="background-color:f1f1f1;height:#attributes.buttonheight#;cursor: pointer;border: 1px solid d4d4d4;border-radius:1px"
							onMouseOver="this.className='highlight1'"
							onMouseOut="this.className='cellcontent'"
					</cfsavecontent>
					
													  			
					<td align="center" width="120" 
					onclick="addfile('#mode#','#host#','#DocumentPath#','#Subdirectory#','#Filter#','#attbox#','1','No','#attachdialog#','#pdfscript#','#memo#')" #selectme#>	
					
					    <table><tr><td>	
							<img src="#SESSION.root#/Images/Attach.png" width="24" height="24" 
							     alt="Attach document" 
								 border="0"
								 align="absmiddle">
								 </td>
								
								 <td style="font-size:14px;"><cf_tl id="#Attributes.Label#"></td>

							 </tr>
						 </table>

				    </td>
					<cfif documentserver neq "No">
						<td width="5%"></td>
						<td align="center" width="120" class="cellcontent"
						onclick="addfile('#mode#','#host#','#DocumentPath#','#Subdirectory#','#Filter#','#attbox#','1','#documentserver#','#attachdialog#','#pdfscript#','#memo#')" #selectme#>		
								<img src="#SESSION.root#/Images/Attach.png" width="24" height="24"
								     alt="Attach document" 
									 border="0" 
									 align="absmiddle">
								
								 <cf_tl id="Document Server">

					    </td>						
					</cfif>
													
			</tr>
			</table>
		 
		<cfelse>
			
			<table width="100%" cellspacing="0" cellpadding="0"><tr><td>
							
			<iframe src="#SESSION.root#/tools/document/FileFormFrame.cfm?inputsize=#inputsize#&Box=#attbox#&host=#host#&DIR=#documentpath#&ID=#Subdirectory#&ID1=#filter#&reload=1"
	        			width="100%" height="34" scrolling="no" frameborder="0" style="margin-left:-4px;"></iframe>
			
			</td></tr></table>
								
				
		</cfif>
						 	
	   </cfif>
        
</cfif>

</cfoutput>

</td></tr>

</table>

<!--- check with armin
	<cfset AjaxOnLoad("doHighlight")>
--->

