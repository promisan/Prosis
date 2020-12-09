
<cfcomponent> 

	<cfproperty name="BrowserTools" type="string">
	<cfset this.name = "BrowserRoutine">	
	
	<cffunction name="setDocumentMode" 
			access="remote" 
			returntype="string">
		
		<cfargument name="documentMode" type="numeric" required="true"/>		
		<cfset CLIENT.documentMode = documentMode>		
		<cfreturn CLIENT.documentMode>
		
	</cffunction>

	<cffunction name="getBrowser"
            access="public"
            returntype="any"
            displayname="Browsercheck">
			
		<cfargument name="browserstring" 	type="string" required="true"  	default="#CGI.HTTP_USER_AGENT#">
		<cfargument name="minIE"         	type="string" required="true"  	default="8">	 
		<cfargument name="minDocumentmode"  type="string" required="true"  	default="#minIE#">
		<cfargument name="minFF"         	type="string" required="true"  	default="20">
		<cfargument name="minChrome"     	type="string" required="true"  	default="30">
		<cfargument name="minEdge"      	type="string" required="true"  	default="12">
		<cfargument name="minSafari"     	type="string" required="true"  	default="4">
		<cfargument name="minOpera"      	type="string" required="true"  	default="3">
		<cfargument name="setDocumentMode" 	type="string" required="true"  	default="0">
		
		<!--- ----------------------------------- --->
		<!--- ajax proxy to set the document mode --->
		<!--- ----------------------------------- --->
		
		<cfif setDocumentMode eq 1>		
		
			<cfajaxproxy cfc="Service.Process.System.Client" jsclassname="ClientProxy">
		
			<script>
			
				function __proxySetDocumentMode() {
					var docModeProxy = new ClientProxy(); 
					docModeProxy.setCallbackHandler(__docModeSuccess);
					docModeProxy.setErrorHandler(__docModeError);
					
					if (document.documentMode) {
						docModeProxy.setDocumentMode(document.documentMode);
					}else {
						docModeProxy.setDocumentMode(-1);
					}
				}
				
				function __docModeSuccess(result) {
					//alert(result);
				}
				
				function __docModeError() {
					alert('error on communication while document mode!');
				}
				
				if (typeof ColdFusion !== 'undefined') {
					__proxySetDocumentMode();
				}
				
			</script>
		
		</cfif>
							
		<!--- ----------------------------------- --->
		<!---   set the browser name and version  --->
		<!--- ----------------------------------- --->
		
		<cfif find("CFSCHEDULE", browserstring)>
		
			<cfset clientbrowser.name    = "CF Scheduler">
			<cfset clientbrowser.release = "">
		
		<cfelseif find("MSIE 7", browserstring)>
		
			<cfset clientbrowser.name    = "Explorer">
			<cfset clientbrowser.release = "7">
			
		<cfelseif find("MSIE 8",browserstring)>
		
			<cfset clientbrowser.name    = "Explorer">
			<cfset clientbrowser.release = "8">
				
		<cfelseif find("MSIE 9",browserstring)>
			
			<cfset clientbrowser.name    = "Explorer">
			<cfset clientbrowser.release = "9">
			
		<cfelseif find("MSIE 10",browserstring)>
			
			<cfset clientbrowser.name    = "Explorer">
			<cfset clientbrowser.release = "10">
			
		<cfelseif find("Mozilla/5.0",browserstring) 
				and find("Trident",browserstring) 
				and find("rv:11",browserstring) 
				and find("like Gecko",browserstring)>
				
			<cfset clientbrowser.name    = "Explorer">
			<cfset clientbrowser.release = "11">	
			
		<cfelseif find("Firefox",browserstring)>
		
			<cfset clientbrowser.name    = "Firefox">
			
			<cfset vVersion = mid(browserstring, find("Firefox/",browserstring), find(".",browserstring))>
			<cfset vVersion = replace(vVersion, "Firefox/", "", "ALL")>
			<cfset vVersion = replace(vVersion, ".", "", "ALL")>
			
			<cfset clientbrowser.release = vVersion>
			
		<!--- adjustment --->	
			
		<cfelseif find("Edg",browserstring)>
					
			<cfset clientbrowser.name    = "Edge">
			
			<cftry>
				<cfset vVersion = mid(browserstring, find("Edg/",browserstring), find(".",browserstring))>
				<cfset vVersion = mid(vVersion, find("Edg/",vVersion), find(".",vVersion))>
				<cfset vVersion = replace(vVersion, "Edg/", "", "ALL")>
				<cfset vVersion = replace(vVersion, ".", "", "ALL")>
			<cfcatch>
				<cfset vVersion = "86--">
			</cfcatch>
			</cftry>
			
			<cfset clientbrowser.release = vVersion>	
			
		<cfelseif find("Chrome",browserstring)>
					
			<cfset clientbrowser.name    = "Chrome">
			
			<cftry>
			<cfset vVersion = mid(browserstring, find("Chrome/",browserstring), find(".",browserstring))>
			<cfset vVersion = replace(vVersion, "Chrome/", "", "ALL")>
			<cfset vVersion = replace(vVersion, ".", "", "ALL")>
			
			<cfset clientbrowser.release = vVersion>
			<cfcatch>
			
			    <cfset vVersion = "0">
			
				<cfset clientbrowser.release = "">
			</cfcatch>
			
			</cftry>
			
			<cfset clientbrowser.release = vVersion>
			 	 
		<cfelseif find("Opera",browserstring)>
		
			<cfset clientbrowser.name    = "Opera">
			
			<cfset vVersion = mid(browserstring, find("Version/",browserstring), find(".",browserstring))>
			<cfset vVersion = replace(vVersion, "Version/", "", "ALL")>
			<cfset vVersion = replace(vVersion, ".", "", "ALL")>
			
			<cfset clientbrowser.release = vVersion>
			
		<cfelseif find("Safari",browserstring)>
		
			<cfset clientbrowser.name    = "Safari">
			
			<cfif find("Version/",browserstring) neq 0>
				<cfset vVersion = mid(browserstring, find("Version/",browserstring), find(".",browserstring))>
				<cfset vVersion = replace(vVersion, "Version/", "", "ALL")>
				<cfset vVersion = replace(vVersion, ".", "", "ALL")>
			<cfelse>
				<cfset vVersion = "Undetermined">
			</cfif>
			
			<cfset clientbrowser.release = vVersion>
			
		<cfelseif find("Android",browserstring)>
		
			<cfset clientbrowser.name    = "Android">
			
			<cfset vVersion = mid(browserstring, find("Android ",browserstring)+8, 5)>
			
			<cfset clientbrowser.release = vVersion>

		<cfelseif find("iPhone",browserstring)>
		
			<cfset clientbrowser.name    = "iPhone">
			
			<cfset vVersion = mid(browserstring, find("iPhone OS ",browserstring)+7, 5)>
			
			<cfset clientbrowser.release = vVersion>
			 
		<cfelse>	
		
			<cfset clientbrowser.name    = "undefined">
			<cfset clientbrowser.release = "0">
			
		</cfif>
		
		<!--- ----------------------- --->
		<!---  set the document mode  --->
		<!--- ----------------------- --->
		<cfif not isDefined("CLIENT.documentMode")>
			<cfset CLIENT.documentMode = -1>
		</cfif>
		<cfset clientbrowser.documentmode = CLIENT.documentMode>
		
		<!--- ----------------------- --->
		<!--- checking if this passes --->
		<!--- ----------------------- --->
		
		<cfset clientbrowser.pass = "0">
		
		<cfif clientbrowser.name eq "Explorer">
						
			<cfif clientbrowser.release gte minIE>
			
									
				<cfset clientbrowser.pass = "1">
				
				<!--- ---------------------------- --->
				<!---  validate the document mode  --->
				<!--- ---------------------------- --->
				
				<cfif setDocumentMode eq 1>		
				
					<cfif CLIENT.documentMode neq "-1">
								
						<cfif CLIENT.documentMode gte minDocumentmode>					
							<cfset clientbrowser.pass = "1">							
						<cfelse>					
							<cfset clientbrowser.pass = "0">							
						</cfif>
				
					</cfif>
					
				</cfif>	
												
			</cfif>
			
					
		<cfelseif clientbrowser.name eq "Firefox">
		
			<cfif clientbrowser.release gte minFF>
				<cfset clientbrowser.pass = "1">
			</cfif>
			
		<cfelseif clientbrowser.name eq "Edge">
		
			<cfif clientbrowser.release gte minEdge>
				<cfset clientbrowser.pass = "1">
			</cfif>	
		
		<cfelseif clientbrowser.name eq "Chrome">
		
			<cfif clientbrowser.release gte minChrome>
				<cfset clientbrowser.pass = "1">
			</cfif>
		
		<cfelseif clientbrowser.name eq "Safari">
		
			<cfif clientbrowser.release gte minSafari>
				<cfset clientbrowser.pass = "1">
			</cfif>
			
		<cfelseif clientbrowser.name eq "Opera">
		
			<cfif clientbrowser.release gte minOpera>
				<cfset clientbrowser.pass = "1">
			</cfif>
		
		</cfif>
				
		<cfreturn clientbrowser>
	
	</cffunction>	

</cfcomponent>
