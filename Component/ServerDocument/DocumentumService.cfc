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
<!--- Documentum interconnection
by Jorge Armin Mazariegos
Promisan b.v.
August 18th 2011
Last update on November 4th 2011
----->

<cfcomponent output="false"
	hint="Handles Documentum Document Server Operations">

	<cfset VARIABLES.Instance.Session = ""/>
	<cfset VARIABLES.Instance.vDocumentServer = "">
	<cfset VARIABLES.Instance.vUserName = "">
	<cfset VARIABLES.Instance.vUserPassword = "">
		
	<cffunction name="SetServer"
		access="public"
		output="false"
		returntype="any">
		
		<cfargument name="pServer" type="string" required="true" default=""/>
		<cfset VARIABLES.Instance.vDocumentServer = pServer />
		
		<cfreturn THIS />
	
	</cffunction>

	

	
	<cffunction name="SetUser"
		access="public"
		output="false"
		returntype="any">
		
		<cfargument name="pUser" type="string" required="true" default=""/>
		<cfset VARIABLES.Instance.vUserName = pUser/>
		
		<cfreturn THIS />
	
	</cffunction>
	
	<cffunction name="SetPwd"
		access="public"
		output="false"
		returntype="any">
		
		<cfargument name="pPwd" type="string" required="true" default=""/>
		<cfset VARIABLES.Instance.vUserPassword = pPwd/>
		
		<cfreturn THIS />
	
	</cffunction>		

	<cffunction
		name="Get"
		access="public"
		returntype="Struct"
		output="true"
		hint="Returns file content">
		
		
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
			
			
			<cfset vServerDirectory=#Replace(ServerDirectory," ","%20","ALL")#>
			<cfset vServerDirectory=#Replace(vServerDirectory,"\","/","ALL")#>
			<cfset vServerDirectory=#Replace(vServerDirectory,"&","%26","ALL")#>
			<cfset vServerDirectory=#Replace(vServerDirectory,":","%3A","ALL")#>			
			<cfset vServerFile=#Replace(ServerFile," ","%20","ALL")#>
			<cfset vServerFile=#Replace(vServerFile,"&","%26","ALL")#>		
			
			
			<cfset objHttpSession = CreateObject( 
				"component", 
				"CFHTTPSession" 
				).Init() 
				/>

				<cfset objResponse = objHttpSession
					.NewRequest("#VARIABLES.Instance.vDocumentServer##vServerDirectory#" )
					.Get()
				/>				
			 					
				<cfset objResponse = objHttpSession
					.NewRequest("#VARIABLES.Instance.vDocumentServer##vServerDirectory##vServerFile#" )
					.setCredentials(#VARIABLES.Instance.vUserName#,#VARIABLES.Instance.vUserPassword#)					
					.Get()
				/>				
				
				<cfreturn objResponse>

	</cffunction>
	
	
	<cffunction
		name="Upload"
		access="public"
		returntype="Struct"
		output="true"
		hint="Returns information on the performed upload">
		
		
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
			

		<cfargument 
			name="OriginDirectory" 
			type="string" 
			required="true" 
			hint="ORIGIN Directory"
			/>
			
		<cfargument 
			name="OriginFile" 
			type="string" 
			required="false" 
			default=""
			hint="File to be copied into Documentum"
			/>			
			
			<cfset vServerDirectory=#Replace(ServerDirectory," ","%20","ALL")#>
			<cfset vServerDirectory=#Replace(vServerDirectory,"\","/","ALL")#>
			<cfset vServerDirectory=#Replace(vServerDirectory,"&","%26","ALL")#>
			<cfset vServerDirectory=#Replace(vServerDirectory,":","%3A","ALL")#>			
			<cfset vServerFile=#Replace(ServerFile," ","%20","ALL")#>
			<cfset vServerFile=#Replace(vServerFile,"&","%26","ALL")#>		
			
			
			<cfset objHttpSession = CreateObject( 
				"component", 
				"CFHTTPSession" 
				).Init() 
				/>
			 					
				<cfset objResponse = objHttpSession
					.NewRequest("#VARIABLES.Instance.vDocumentServer##vServerDirectory#" )
					.Get()
				/>

			
				<cfset objResponse = objHttpSession
				.NewRequest("#VARIABLES.Instance.vDocumentServer##vServerDirectory##vServerFile#")
				.AddParam( "header", "Content-Type", "content/type")
				.AddParam("header", "Accept-Encoding","*")
				.AddParam("Header", "TE", "deflate;q=0")
				.AddParam( "file", #OriginFile#,"",#OriginDirectory# & #OriginFile# )
				.setCredentials(#VARIABLES.Instance.vUserName#,#VARIABLES.Instance.vUserPassword#)									
				.Put()
				/>				
	
				
				<cfreturn objResponse>

	</cffunction>
	
	
	
	<cffunction
		name="Delete"
		access="public"
		returntype="Struct"
		output="true">

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
			
			<cfset vServerDirectory=#Replace(ServerDirectory," ","%20","ALL")#>
			<cfset vServerDirectory=#Replace(vServerDirectory,"\","/","ALL")#>
			<cfset vServerDirectory=#Replace(vServerDirectory,"&","%26","ALL")#>
			<cfset vServerDirectory=#Replace(vServerDirectory,":","%3A","ALL")#>			
			<cfset vServerFile=#Replace(ServerFile," ","%20","ALL")#>
			<cfset vServerFile=#Replace(vServerFile,"&","%26","ALL")#>						
			
			<cfset objHttpSession = CreateObject( 
				"component", 
				"CFHTTPSession" 
				).Init() 
				/>

			<cfset objResponse = objHttpSession
				.NewRequest("#VARIABLES.Instance.vDocumentServer##vServerDirectory#" )
				.Get()
			/>
				
			<cfset objContent = objHttpSession
				.NewRequest("#VARIABLES.Instance.vDocumentServer##vServerDirectory##vServerFile#")
				.setCredentials(#VARIABLES.Instance.vUserName#,#VARIABLES.Instance.vUserPassword#)
				.Delete()
			/>			
			
			<cfreturn objContent>

	</cffunction>	
	
	<cffunction
		name="getDirectories"
		access="public"
		returntype="Array"
		output="true">

		<cfargument 
			name="ServerDirectory" 
			type="string" 
			required="true" 
			hint="Server Directory"
			/>
	

		<cfset vServerDirectory=#Replace(ServerDirectory," ","%20","ALL")#>
		<cfset vServerDirectory=#Replace(vServerDirectory,"\","/","ALL")#>
		<cfset vServerDirectory=#Replace(vServerDirectory,"&","%26","ALL")#>
		<cfset vServerDirectory=#Replace(vServerDirectory,":","%3A","ALL")#>				
	
		<cfset httpclient = createObject("java", "org.apache.commons.httpclient.HttpClient").init() />
		<cfset usr = createObject("java", "org.apache.commons.httpclient.UsernamePasswordCredentials").init(#VARIABLES.Instance.vUserName#,#VARIABLES.Instance.vUserPassword#)/>
		<cfset scope = createObject("java", "org.apache.commons.httpclient.auth.AuthScope") />
		<cfset setState = httpclient.getState().setCredentials(Scope.ANY, usr)>
		<cfset getDir  = createObject("java", "org.apache.webdav.lib.methods.PropFindMethod").init("#VARIABLES.Instance.vDocumentServer##vServerDirectory#") />

		<cfset result = httpclient.executeMethod(getDir)>
		<cfset vector = getDir.getAllResponseURLs()>

        <cfset result = ArrayNew(1)> 

		<cfloop condition="#vector.hasMoreElements()#">
		        <cfset s = StructNew()> 
				<cfset current   = vector.nextElement()>
		        <cfset s.value   = Replace(current,"#VARIABLES.Instance.vDocumentServer##vServerDirectory#","")> 
		        <cfset s.full    = "#current#"> 			
				<cfset arrayAppend(result,s)/>	
		</cfloop>		
		
		<cfreturn result>
	
	</cffunction>	




</cfcomponent>