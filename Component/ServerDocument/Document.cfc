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
<!--- Xythos interconnection
by dev dev dev
Promisan b.v.
Last modification on May 24th 2010
----->

<cfcomponent output="false"
	hint="Handles Xythos Document Server Operations">

	<cfset VARIABLES.Instance.STK=""/>
	<cfset VARIABLES.Instance.Session=""/>
	<cfset VARIABLES.Instance.Mode="Anonymous"/>
	<cfset VARIABLES.Instance.vDocumentServer="">
	<cfset VARIABLES.Instance.vUserName="">
	<cfset VARIABLES.Instance.vUserPassword="">
		
	<cffunction name="SetMode"
		access="public"
		output="false"
		returntype="any">
		
		<cfargument name="pMode" type="string" required="true" default="Anonymous"/>

		<!-----
				.SetMode("Generic")
					Parameter.DocumentServerLogin, Parameter.DocumentServerPassword					
					
				.SetMode("Individual") 
					 SESSION.acc and Client.pw are used.
	
		----->
		
		
		<cfset VARIABLES.Instance.Mode=pMode/>
		
		<cfreturn THIS />
	
	</cffunction>
	
	<cffunction access="private" name="GetAnonymous" returntype="string" >
			<cfargument 
			name="ServerPassword" 
			type="string" 
			required="true" 
			hint="Password Anonymous"/>
	
			<cfif Len(ServerPassword) lte 25> 
			   <cf_encrypt text = "#ServerPassword#">
	   		   <cfset pass = "#EncryptedText#">
				<cfquery name="Parameter" 
					datasource="AppsInit">
					UPDATE Parameter
					SET DocumentServerPassword='#pass#'
					WHERE HostName = '#CGI.HTTP_HOST#'
				</cfquery>			   
			<cfelse>	  
			   <cfset pass = "#ServerPassword#">
			</cfif>	 
		
			<!---- We have to decrypt the password before sending it to Xythos ----->
		    <cf_decrypt text = "#pass#">
			<cfset password = "#Decrypted#">
			<cfreturn password>
				
	
	</cffunction>
	
	<cffunction name="GetCredentials"
		output="true"	
		returntype="Void"
		hint      ="Based on authentication mode for Xythos Server, it switches INSTANCE variables between generic or individual approvach">
		
		<cfquery name="Parameter" 
				datasource="AppsInit">
				SELECT * 
				FROM Parameter
				WHERE HostName = '#CGI.HTTP_HOST#'
		</cfquery>
		
		<cfif VARIABLES.Instance.Mode eq "Anonymous">
			<cfset VARIABLES.Instance.vDocumentServer="#Parameter.DocumentServer#">
			<cfset VARIABLES.Instance.vUserName="#Parameter.DocumentServerLogin#">
				
			<cfset VARIABLES.Instance.vUserPassword=GetAnonymous(Parameter.DocumentServerPassword)>
			
		<cfelse>

			<!---- Getting the Lotus Notes account ----->
			<cfquery name="qUser" datasource="AppsSystem">
				SELECT * 
				FROM UserNames
				WHERE Account='#SESSION.acc#'  
			</cfquery>

			<!---- We have to decrypt the password before sending it to Xythos ----->
		    <cf_decrypt text = "#Client.pw#">
			<cfset password = "#Decrypted#">			
		
			<cfif qUser.MailServerAccount neq "">
				<cfset VARIABLES.Instance.vDocumentServer="#Parameter.DocumentServer#">
				<cfset VARIABLES.Instance.vUserName="#qUser.MailServerAccount#">
				<cfset VARIABLES.Instance.vUserPassword="#password#">
			<cfelse>
				<cfset VARIABLES.Instance.vDocumentServer="#Parameter.DocumentServer#">
				<cfset VARIABLES.Instance.vUserName="#Parameter.DocumentServerLogin#">
				<cfset VARIABLES.Instance.vUserPassword=GetAnonymous(Parameter.DocumentServerPassword)>				
			</cfif>		
			
		</cfif>
		<cfreturn />
	</cffunction>
	
	<cffunction
		name="Upload"
		access="public"
		returntype="String"
		output="true"
		hint="Returns information on the performed upload">
		
		<cfargument 
			name="ServerDirectory" 
			type="string" 
			required="true" 
			hint="ORIGIN DIRECTORY"
			/>

		<cfargument 
			name="ServerFile" 
			type="string" 
			required="true" 
			hint="ORIGIN Filename"
			/>
			
		<cfargument 
			name="XythosDirectory" 
			type="string" 
			required="false" 
			default=""
			hint="Xythos Directory"
			/>			
			
		<cfargument 
			name="UID" 
			type="string" 
			required="false" 
			default=""
			hint="This handles the Unique identifier for each file."
			/>				

			<cfset GetCredentials()>
			
			<cfset objHttpSession = CreateObject( 
				"component", 
				"CFHTTPSession" 
				).Init() 
				/>
			 
			<cfset objResponse = objHttpSession
				.NewRequest( "https://bcs.un.org/xythoswfs/webview/login.action" )
				.Get()
				/>
			 
			 <cfif UID neq "">
			 	<cfset DestinationFile="#UCase(UID)#-#ServerFile#">
	  		 <cfelse>
				<cfset DestinationFile="#ServerFile#">
			 </cfif>
			 

			<cftry>

					<cfset objResponse = objHttpSession
						.NewRequest( "#VARIABLES.Instance.vDocumentServer##XythosDirectory##DestinationFile#" )
						.AddParam( "header", "Host", "bcs.un.org:443")		
						.AddParam( "header", "Content-Type","text/plain" )	
						.AddParam( "header", "Connection", "Keep-Alive")
						.AddParam( "file", #ServerFile#,"",#ServerDirectory# & "/" & #ServerFile# )
						.setCredentials(#VARIABLES.Instance.vUserName#,#VARIABLES.Instance.vUserPassword#)
						.Put()
						
					/>

					<!--- I should delete the file from the origin ------>
	
					<cffile action = "Delete"
					   file = "#ServerDirectory#\#ServerFile#">
					
					

					<cfif #objResponse.StatusCode# eq "201 Created">
						<cfreturn "1" />
					<cfelse>
						<cfreturn "2 -#VARIABLES.Instance.vDocumentServer##XythosDirectory##ServerFile#" />
				</cfif>
			<cfcatch>
					<cfreturn "3 - #ServerFile# - #ServerDirectory# : #VARIABLES.Instance.vDocumentServer##XythosDirectory##ServerFile#" />
					
			</cfcatch>
			</cftry>
			
	</cffunction>
	
	<cffunction name="GetXythosSession"
		access="Public"
		returntype="array"
		hint="Returns STK and Session in a array">
		
			<cfset GetCredentials()>
			
			<cfset objHttpSession = CreateObject( 
				"component", 
				"CFHTTPSession" 
				).Init(LogFilePath = "D:\logXythos.txt") 
				/>
			 
			<cfset objSession = objHttpSession
				.NewRequest( "https://bcs.un.org/xythoswfs/webview/login.action" )
				.Get()
				/>

			<cfset objSession = objHttpSession
				.NewRequest( "https://bcs.un.org/xythoswfs/webview/login.action" )
				.AddFormField( "shareLogin", "false" )		
				.AddFormField( "XY_domainName", "Users" )	
				.AddFormField( "stk", "" )
				.AddFormField( "XY_username", #VARIABLES.Instance.vUserName# )
				.AddFormField( "XY_password", #VARIABLES.Instance.vUserPassword# )
				.Post()
			/>
			
			
			<cfset Xythos_Session=#objHttpSession.GetCookies().XythosSessionID1.Value#>
			<cfset Xythos_STK=#objHttpSession.GetSTK()#>
			
			<cfset aResponse = ArrayNew(2)>
			
			<cfset aResponse[1][1]=Xythos_Session>
			<cfset aResponse[1][2]=Xythos_STK>

			<!---- Storing these variable locally for further reference----->
			<cfset VARIABLES.Instance.Session=Xythos_Session/>
			<cfset VARIABLES.Instance.STK=Xythos_STK/>

				
			<cfreturn aResponse/>			
		
	</cffunction>
		
	
	<cffunction name="GoiLink"
		access="Public"
		returntype="array"
		hint="Go to the Intelli Link">

		<cfargument 
			name="iLink" 
			type="string" 
			required="true" 
			hint="Intelli Link"
			/>		
		
			<cfset GetCredentials()>
			
			<cfset objHttpSession = CreateObject( 
				"component", 
				"CFHTTPSession" 
				).Init(LogFilePath = "D:\logXythos.txt") 
				/>
			 
			<cfset objSession = objHttpSession
				.NewRequest( "https://bcs.un.org/xythoswfs/webview/login.action" )
				.Get()
				/>

			<cfset objSession = objHttpSession
				.NewRequest( "https://bcs.un.org/xythoswfs/webview/login.action" )
				.AddFormField( "shareLogin", "false" )		
				.AddFormField( "XY_domainName", "Users" )	
				.AddFormField( "stk", "" )
				.AddFormField( "XY_username", #VARIABLES.Instance.vUserName# )
				.AddFormField( "XY_password", #VARIABLES.Instance.vUserPassword# )
				.AddFormField( "nextAction", "#iLink#.action" )
				.Post()
			/>
			
			
			<cfset Xythos_Session=#objHttpSession.GetCookies().XythosSessionID1.Value#>
			<cfset Xythos_STK=#objHttpSession.GetSTK()#>
			
			<cfset aResponse = ArrayNew(2)>
			
			<cfset aResponse[1][1]=Xythos_Session>
			<cfset aResponse[1][2]=Xythos_STK>

			<!---- Storing these variable locally for further reference----->
			<cfset VARIABLES.Instance.Session=Xythos_Session/>
			<cfset VARIABLES.Instance.STK=Xythos_STK/>

				
			<cfreturn aResponse/>			
		
	</cffunction>	
	
	
	<cffunction
		name="Listing"
		access="public"
		returntype="array"
		output="true"
		hint="Returns a listing of all files and directories in the directory">
		
		<cfargument name="ServerDirectory" type="string" required="true" hint="WEBDAV Directory"/>			
		<cfargument name="DisplayLinks" type="numeric" required="false" default=0 hint="0 = no links, 1= links"/>			

		<cfargument 
			name="ListAll" 
			type="String" 
			required="false"
			default="No" 
			hint="Yes = All files and directories, No= Only directories"/>					
			
			<cfset GetCredentials()>			
			
			<cfset vServerDirectory=#Replace(ServerDirectory," ","%20","ALL")#>
			<cfset vServerDirectory=#Replace(vServerDirectory,"\","/","ALL")#>
			<cfset vServerDirectory=#Replace(vServerDirectory,"&","%26","ALL")#>
			
			<cfset objHttpSession = CreateObject( 
				"component", 
				"CFHTTPSession" 
				).Init() 
				/>			 
			
			<cfset objResponse = objHttpSession
				.NewRequest( "#VARIABLES.Instance.vDocumentServer##vServerDirectory#" )
				.setCredentials(#VARIABLES.Instance.vUserName#,#VARIABLES.Instance.vUserPassword#)
				.Get()/>
			
			<cfset vStart=1>
			<cfset i=1>
			<cfset aDirectoryContent = ArrayNew(1) />
			
			<cfloop condition = "vstart lte Len(objResponse.FileContent)">
				<cfset st = REFind("<A\b[^>]*>(.*?)</A>",objResponse.FileContent,vStart,"TRUE")>
				<cfif st.pos[1] neq 0>
					<cfset token=Mid(objResponse.FileContent,st.pos[1],st.len[1])>
					<cfset tDirectory=ReReplace(token,'<[a|A][^>]*>','','ALL')>
					<cfset tDirectory=ReReplace(tDirectory,'</[a|A]>','','ALL')>
					
					<cfif Find("Launch WFS Web View", tDirectory) eq 0
							and Find("Up to higher level directory", tDirectory) eq 0
							and Find("Open Web View", tDirectory) eq 0>>
						<!---Specific listing from Xythos ---->
						
						
						<cfset sWEBDAV_element= StructNew()/>							
						<cfif Find("/",tDirectory) eq 0>
							<cfif ListAll eq "Yes">
								 <cfset a=StructInsert(sWEBDAV_element, "Type", "File")>
								 <cfset a=StructInsert(sWEBDAV_element, "Name", tDirectory)>
								 <cfif DisplayLinks eq 1>
								 	<cfset aLinks=GetiLink(ServerDirectory,tDirectory)>
								 	<cfset a=StructInsert(sWEBDAV_element, "URL", aLinks[1][1])>							 						 
								 	<cfset a=StructInsert(sWEBDAV_element, "iURL", aLinks[1][2])>
								 <cfelse>
	 								 <cfset a=StructInsert(sWEBDAV_element, "URL", "")>							 						 
									 <cfset a=StructInsert(sWEBDAV_element, "iURL", "")>							 
								 </cfif>
		 						<cfset aDirectoryContent[i]=sWEBDAV_element>							 
								<cfset i=i+1>
							</cfif>
						<cfelse>
								 <cfset a=StructInsert(sWEBDAV_element, "Type", "Directory")>
								 <cfset a=StructInsert(sWEBDAV_element, "Name", tDirectory)>
								 <cfset a=StructInsert(sWEBDAV_element, "URL", "")>							 						 
								 <cfset a=StructInsert(sWEBDAV_element, "iURL", "")>							 
		 						<cfset aDirectoryContent[i]=sWEBDAV_element>
								<cfset i=i+1>
						</cfif>

					</cfif>

					<cfset vStart=st.pos[1]+st.len[1] >					
				    
				<cfelse>
					<!--- Not found other matching anymore---->
					<cfbreak>
				</cfif>
			
			</cfloop>
			
			<cfreturn aDirectoryContent />
			
	</cffunction>

	
	<cffunction
		name="ListSubDirectory"
		access="public"
		returntype="Query"
		output="true"
		hint="Returns a listing of all files and directories in the directory">
			
		<cfargument name="ID" type="string" required="true" hint="OBJECT ID (ex. Invoice Id)"/>			
		<cfargument name="OriginPath" type="string" required="false" hint="e.g. \\OriginServer"/>		
		<cfargument name="Filter" type="string" required="false"/>
						
			<!--- The following query retrieves the list of files related to a particular object ----->
			<cfset aResult=ArrayNew(1)>
			<cfquery name="ListOfFiles" datasource="appsSystem">
				SELECT Server,
						AttachmentId,
				       '' as Attributes, 
				       '1900-01-01' as DateLastModified,
				       ServerPath as Directory,
				       '' as Mode,
				       FileName as Name,
				       0 as Size,
				       'File' as Type
				FROM   Attachment
				WHERE  Reference   = '#ID#'
				AND    FileName like '#Filter#_%'
				AND    FileStatus  = '1'
				AND    (Filename   != '' and FileName is not NULL)
				AND    (ServerPath != '' and ServerPath is not NULL)
			</cfquery>				
			
			<!--- dev dev added a condition to Filename not blank or serverpath not blank
			from South Africa on Dec 10th 2010
			 ----->

			<!--- Creating the query to be returned ----->
			<cfset qResult = QueryNew("AttachmentId,Name,Attributes,DateLastModified,Directory,Mode,Size,Type", "Varchar,Varchar,VarChar, Date,Varchar,Varchar,Double,Varchar")> 
			
			<cfset i=1>
			
			<cfloop query="ListOfFiles">
			
				<!--- Very important translation ----->
				<cfif Server eq "document">
						<cfif left(Directory,9) eq "document/"> 
						   <cfset path = mid(Directory,10,len(Directory))>
						<cfelse>
							 <cfset path = Directory>   
						</cfif>
						<cfset vPos=Find("/",#Path#)>
						<cfset pPath=Mid(path,1,vPos)>
				<cfelse>
						<cfset path   = Directory>   
						<cfset pPath  = Directory>					
				</cfif>

				<cfset path = replace(path,"/","\","ALL")>

				<cfif left(path,1) neq "\">
					<cfset path="\"&path>
				</cfif>
								
				<!----------------------------->
				<cfset vAttachmentId=#UCase(AttachmentId)#>
				<cfset aResponse=GetiRSS(pPath,"#vAttachmentId#-#Name#")>

<!--- Removed in preparation of Unite Docs
				<cfif aResponse[1][1] eq "">
					<!--- 
					If the files do not exist in Document Server I do the upload for the user into Xythos
					I have now to retrieve the information 
					
					------------->

					<cfset aResponse2=Upload("#OriginPath##path#","#Name#","#pPath#","#vAttachmentId#")>
					<cfset aResponse=GetiRSS(pPath,"#vAttachmentId#-#Name#")>


				</cfif>
				
				<cfif aResponse[1][1] neq "">
					<cfquery name="UpdateDocumentServerPath" datasource="appsSystem">		
							UPDATE Attachment
							SET    ServerPath='#pPath#', 
							       Server='documentserver'
							WHERE  AttachmentId='#vAttachmentId#'
					</cfquery>				
				</cfif>

---->				

					<cftry>
						<cfset newRow = QueryAddRow(qResult, 1)> 
						<cfset temp = QuerySetCell(qResult, "AttachmentId", "#vAttachmentId#", i)> 				
						<cfset temp = QuerySetCell(qResult, "Name", #Name#, i)> 				
						<cfset temp = QuerySetCell(qResult, "Attributes", "", i)> 
						<cfset temp = QuerySetCell(qResult, "DateLastModified", "", i)> 
						<cfset temp = QuerySetCell(qResult, "Directory", "#pPath#", i)> 
						<cfset temp = QuerySetCell(qResult, "Mode", "", i)> 												
						<cfset temp = QuerySetCell(qResult, "Size", "", i)> 																
						<cfset temp = QuerySetCell(qResult, "Type", "File", i)> 
						<cfset i=i+1>					
					<cfcatch>	
						<!-----
							<cfoutput>
							#i#  -"#OriginPath##path#","#Name#","#pPath#","#AttachmentId#"-
							</cfoutput><br>
						----->
					</cfcatch>
					</cftry>			

			</cfloop>
			
			<cfreturn qResult />
						
	</cffunction>
	
	<cffunction
		name="GetiLink"
		access="public"
		returntype="array"
		output="true"
		hint="Returns Xythos Intelli-Link">

		<cfargument 
			name="ServerDirectory" 
			type="string" 
			required="true" 
			hint="WEBDAV ServerFile"
			/>
		
		<cfargument 
			name="ServerFile" 
			type="string" 
			required="true" 
			hint="WEBDAV ServerFile"
			/>
		
			<cfset aResponse=ArrayNew(2)>
	
			<cfset GetCredentials()>
			
			<cfset vServerDirectory=#Trim(ServerDirectory)#>

			<cfset vServerDirectory=#Replace(ServerDirectory," ","%20","ALL")#>
			<cfset vServerDirectory=#Replace(vServerDirectory,"\","/","ALL")#>
			<cfset vServerDirectory=#Replace(vServerDirectory,"&","%26","ALL")#>
			
			<cfset vServerFile=#Replace(ServerFile,"\","/","ALL")#>
			
			<cfif len(vServerDirectory) gt 0>
				<cfif mid(vServerDirectory,len(vServerDirectory),1) neq "/">
					<cfset vServerDirectory=vServerDirectory&"/">
				</cfif>			
			</cfif>
			
			
			<cfset objHttpSession = CreateObject( 
				"component", 
				"CFHTTPSession" 
				).Init() 
				/>

			<cfset objRSS = objHttpSession
				.NewRequest( "#VARIABLES.Instance.vDocumentServer##vServerDirectory##vServerFile#" )
				.AddUrl("view", "RSS" )		
				.setCredentials(#VARIABLES.Instance.vUserName#,#VARIABLES.Instance.vUserPassword#)
				.Get()
			/>


		<cfif Len(objRSS.FileContent) neq 0>
					<cfset xmlDoc = xmlParse('#objRSS.FileContent#')>		
					
					<cftry>
						<cfset vfURL="#xmlDoc.rss.channel.XMLChildren[2].XmlText#">
						<cfset viURL="#xmlDoc.rss.channel.XMLChildren[6].XMLChildren[5].XmlAttributes.URL#">
												
						<cfset textstr = REReplace(viURL,'-\d-','_','all')>
						
						<cfset st = REFind("_(\d*?)_",textstr,0,"TRUE")>
						
						<cfset token1="">
						<cfif st.pos[1] neq 0>
								<cfset token1=Mid(textstr,st.pos[1]+1,st.len[1]-1)>
						</cfif>
						
						
						<cfset st = REFind("_\d-",textstr,0,"TRUE")>
						<cfset token2="">
						<cfif st.pos[1] neq 0>
								<cfset token2=Mid(textstr,st.pos[1]+1,1)>
						</cfif>
						
						
						<cfset vResult="_xy-"&token1&token2>
						
						
						<cfset aResponse[1][1]=vfURL>
						<cfset aResponse[1][2]=vResult>
					<cfcatch>
						<cfset aResponse[1][1]="Error">
						<cfset aResponse[1][2]="Error">
					</cfcatch>
					</cftry>
					
					<cfreturn aResponse />
		<cfelse>
			<cfset aResponse[1][1]="Error">
			<cfset aResponse[1][2]="Error">
			<cfreturn aResponse />
		</cfif>	
	</cffunction>

	<cffunction
		name="GetiRSS"
		access="public"
		returntype="array"
		output="true"
		hint="Returns Xythos Intelli-Link">

		<cfargument 
			name="ServerDirectory" 
			type="string" 
			required="true" 
			hint="WEBDAV ServerFile"/>
		
		<cfargument 
			name="ServerFile" 
			type="string" 
			required="true" 
			hint="WEBDAV ServerFile"/>
		
			<cfset aResponse=ArrayNew(2)>
	
			<cfset GetCredentials()>
			
			<cfset vServerDirectory=Trim(ServerDirectory)>

			<cfset vServerDirectory=#Replace(ServerDirectory," ","%20","ALL")#>
			<cfset vServerDirectory=#Replace(vServerDirectory,"\","/","ALL")#>
			<cfset vServerDirectory=#Replace(vServerDirectory,"&","%26","ALL")#>
			
			<cfset vServerFile=#Replace(ServerFile,"\","/","ALL")#>
			
			<cfif len(vServerDirectory) gt 0>
				<cfif mid(vServerDirectory,len(vServerDirectory),1) neq "/">
					<cfset vServerDirectory=vServerDirectory&"/">
				</cfif>			
			</cfif>
			
			<cftry>
						
			<cfset objHttpSession = CreateObject( 
				"component", 
				"CFHTTPSession" 
				).Init()/>
				
			<cfset objRSS = objHttpSession
				.NewRequest( "#VARIABLES.Instance.vDocumentServer##vServerDirectory##vServerFile#" )
				.AddUrl("view", "RSS" )		
				.setCredentials(#VARIABLES.Instance.vUserName#,#VARIABLES.Instance.vUserPassword#)
				.Get()/>
				
				<cfcatch>
				
				<cfparam name="objRss.ResponseHeader.Status_Code" default="0">
				
				</cfcatch>
				
			</cftry>	
		
		<cftry>
		<cfif Left(objRss.ResponseHeader.Status_Code,1) eq "2">
		
			<cfif Len(objRSS.FileContent) neq 0 >
					<cfset xmlDoc = xmlParse('#objRSS.FileContent#')>		

					
					<cftry>
						<cfset vfURL="#xmlDoc.rss.channel.XMLChildren[2].XmlText#">
						<cfset viURL="#xmlDoc.rss.channel.XMLChildren[6].XMLChildren[5].XmlAttributes.URL#">
						<cfset vLength="#xmlDoc.rss.channel.XMLChildren[6].XMLChildren[5].XmlAttributes.Length#">
						<cfset vPubDate="#xmlDoc.rss.channel.XMLChildren[6].XMLChildren[4].XmlText#">
						<cfset vCreator="#xmlDoc.rss.channel.XMLChildren[6].XMLChildren[7].XmlText#">						

						<cfset aResponse[1][1]=vfURL>
						<cfset aResponse[1][2]=viURL>
						<cfset aResponse[1][3]=vLength>
						<cfset aResponse[1][4]=vPubDate>
						<cfset aResponse[1][5]=vCreator>
						
						
						
					<cfcatch>
						<cfset aResponse[1][1]="">
					</cfcatch>
					</cftry>
					
					<cfreturn aResponse />
			<cfelse>
				<cfset aResponse[1][1]="">
				<cfreturn aResponse />
			</cfif>	
			
		<cfelse>
		
			<cfif objRss.ResponseHeader.Status_Code eq "401">	
				#vServerFile#: #objRss.ResponseHeader.Status_Code#-#objRss.ResponseHeader.Explanation#		
				<br>

			</cfif>
			<cfset aResponse[1][1]="">
			<cfreturn aResponse />
			
		</cfif>	
		<cfcatch>
				<cfset aResponse[1][1]="">
				<cfreturn aResponse />				
		</cfcatch>		
		</cftry>	
			
	</cffunction>
	
	
	<cffunction
		name="GetContent"
		access="public"
		returntype="Struct"
		output="true"
		hint="Copy the content from Xythos into a particular directory in NOVA">

		<cfargument 
			name="iURL" 
			type="string" 
			required="true" 
			hint="WEBDAV i Link"
			/>
		<cfargument 
			name="DDirectory" 
			type="string" 
			required="false" 
			default=""
			hint="Destination Directory"
			/>
		<cfargument 
			name="DFile" 
			type="string" 
			required="false"
			default="" 
			hint="Destination File"
			/>			
			
			<cfset GetCredentials()>
			
			<cfset objHttpSession = CreateObject( 
				"component", 
				"CFHTTPSession" 
				).Init() 
				/>

			<cfset objContent = objHttpSession
				.NewRequest( "#iURL#" )
				.setCredentials(#VARIABLES.Instance.vUserName#,#VARIABLES.Instance.vUserPassword#)
				.GetFile(#DDirectory#,#DFile#)
			/>			
			
			<cfreturn objContent>

	</cffunction>	


	<cffunction
		name="Delete"
		access="public"
		returntype="Struct"
		output="true"
		hint="Copy the content from Xythos into a particular directory in NOVA">

		<cfargument 
			name="ServerDirectory" 
			type="string" 
			required="true" 
			hint="Server Directory"
			/>
		<cfargument 
			name="ServerFile" 
			type="string" 
			required="true"
			hint="ServerFile"
			/>			
			
			<cfset GetCredentials()>
			
			<cfset vServerDirectory=#Replace(ServerDirectory," ","%20","ALL")#>
			<cfset vServerDirectory=#Replace(vServerDirectory,"\","/","ALL")#>
			<cfset vServerDirectory=#Replace(vServerDirectory,"&","%26","ALL")#>
			<cfset vServerFile=#Replace(ServerFile," ","%20","ALL")#>
			<cfset vServerFile=#Replace(vServerFile,"&","%26","ALL")#>						
			
			<cfset objHttpSession = CreateObject( 
				"component", 
				"CFHTTPSession" 
				).Init() 
				/>

			<cfset objContent = objHttpSession
				.NewRequest( "#VARIABLES.Instance.vDocumentServer##vServerDirectory##vServerFile#" )
				.setCredentials(#VARIABLES.Instance.vUserName#,#VARIABLES.Instance.vUserPassword#)
				.Delete()
			/>			
			
			<cfreturn objContent>

	</cffunction>	

    <cffunction name="getNodes" returnType="array" output="no" access="remote"> 
        <cfargument name="vmid" required="true" default=""> 
        <cfargument name="vpath" required="true" default=""> 
        <cfargument name="Directory" required="true" default=""> 
        <cfargument name="ListAll" required="false" default="No" hint="Yes = shows files, No= shows only directories"> 		

        <cfset result = ArrayNew(1)> 
		
		<cfif vmid eq "">

			<cfquery name="Parameter" 
			datasource="AppsInit">
				SELECT * 
				FROM Parameter
				WHERE HostName = '#CGI.HTTP_HOST#'
			</cfquery>
					
		
	        <cfset s = StructNew()> 
	        <cfset s.value   = "root"> 
	        <cfset s.parent  = "root"> 			
	        <cfset s.display = "<b>#Parameter.DocumentServer##Directory#</b>">
	        <cfset s.href    = "javascript:Selected('#Directory#/')"> 
			<cfset arrayAppend(result,s)/>	
			<cfset s.expand=true/>	
		<cfelse>
			<cfset i=1>
			<cfif vmid eq "root">
				<cfset LookFor="#Directory#/">
			<cfelse>
				<cfset LookFor=vMid>
			</cfif>
			
			
			<cfset aResponse=Listing(LookFor,0,ListAll)>
			
			<cfloop array="#aResponse#" index="obj">	
	        	<cfset s = StructNew()> 
		        <cfset s.value = "#LookFor##obj.Name#"> 
		        <cfset s.display = "#obj.Name#"> 
				<cfset s.parent  = vmid>


				
				<cfif obj.type eq "File">
					<cfif Len(Lookfor) gt 1>
						<cfset vURL=Mid(LookFor,1,Len(LookFor)-1)>
					<cfelse>
						<cfset vURL=LookFor>
					</cfif>
					<cfset s.href      = "Open.cfm?Directory=#URLEncodedFormat(vURL)#&iURL=&Name=#obj.Name#">
					<cfset s.target    = "new">				
					<cfset s.leafnode=true/>
				<cfelse>
					<cfset s.href = "javascript:Selected('#LookFor##obj.Name#')">
					<cfset aTest  =	Listing('#LookFor##obj.Name#',0,ListAll)>
					<cfif ArrayLen(aTest) eq 0>
						<cfset s.leafnode=true/>
					<cfelse>
						<cfset s.expand=true/>
					</cfif>

				</cfif>
				
				<cfset arrayAppend(result,s)/>				

						
				<cfset i=i+1>
			</cfloop>			
		</cfif>			
        <cfreturn result> 
    </cffunction> 

    <cffunction name="getDirectories" returnType="array" output="no" access="remote"> 
        <cfargument name="vmid" required="true" default=""> 
        <cfargument name="vpath" required="true" default=""> 
        <cfargument name="Directory" required="true" default=""> 
        <cfargument name="ListAll" required="false" default="No" hint="Yes = shows files, No= shows only directories"> 		
		
        <cfset result = ArrayNew(1)> 
		
		<cfif vmid eq "">

			<cfquery name="Parameter" 
			datasource="AppsInit">
				SELECT * 
				FROM Parameter
				WHERE HostName = '#CGI.HTTP_HOST#'
			</cfquery>
	        <cfset s = StructNew()> 
	        <cfset s.value   = "root"> 
	        <cfset s.parent  = "root"> 			
	        <cfset s.display = "<b>#Parameter.DocumentServer##Directory#</b>">
	        <cfset s.href    = "javascript:get_files('#Directory#/')"> 
			<cfset arrayAppend(result,s)/>	
			<cfset s.expand=true/>	
		<cfelse>

			<cfset i=1>
			<cfif vmid eq "root">
				<cfset LookFor="#Directory#/">
			<cfelse>
				<cfset LookFor=vMid>
			</cfif>
			
			<cfset Lookfor = Replace(Lookfor,"//","/")>


			<cfset aResponse=Listing(LookFor,0,ListAll)>
			

			<cfloop array="#aResponse#" index="obj">	
	        	<cfset s = StructNew()> 
		        <cfset s.value = "#LookFor##obj.Name#"> 
		        <cfset s.display = "#obj.Name#"> 
				<cfset s.parent  = vmid>


				
				<cfif obj.type eq "File">
					<cfif Len(Lookfor) gt 1>
						<cfset vURL=Mid(LookFor,1,Len(LookFor)-1)>
					<cfelse>
						<cfset vURL=LookFor>
					</cfif>
					<cfset s.href      = "Open.cfm?Directory=#URLEncodedFormat(vURL)#&iURL=&Name=#obj.Name#">
					<cfset s.target    = "new">				
					<cfset s.leafnode=true/>
				<cfelseif ListAll eq "No">
					<cfset s.href = "javascript:get_files('#LookFor##obj.Name#')">
					<cfset aTest  =	Listing('#LookFor##obj.Name#',0,ListAll)>
					<cfif ArrayLen(aTest) eq 0>
						<cfset s.leafnode=true/>
					<cfelse>
						<cfset s.expand=true/>
					</cfif>

				</cfif>
				
				<cfset arrayAppend(result,s)/>				

						
				<cfset i=i+1>
			</cfloop>			
		</cfif>			
        <cfreturn result> 
    </cffunction> 

	
	
</cfcomponent>
