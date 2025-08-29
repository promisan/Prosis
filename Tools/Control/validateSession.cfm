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
<cftry>
		
	<!--- added by hanno to proactive end the session if this was done on the level of the data
	base like expirate or multiple session --->
	
	<cfparam name="SESSION.acc"       default="">
	<cfparam name="SESSION.SessionId" default="">		

	<cfif session.acc neq "Anonymous">
	
		<cftransaction isolation="READ_UNCOMMITTED">
				    
			<cf_getHost host="#cgi.http_host#">
						
			<cfquery name="Logon" 
			datasource="AppsSystem">
				SELECT *
				FROM   UserStatus S
				WHERE  Account          = '#SESSION.acc#'  
				AND    HostName         = '#host#'   
				AND    HostSessionId    = '#SESSION.SessionId#' 
				AND    ActionExpiration = '0'
			</cfquery>
					
		</cftransaction>
			
		<cfif Logon.recordcount eq "0">
								
			<!--- end the session --->
			<cfset SESSION.authent= "0">	
				
		</cfif>
	
	</cfif>
	
	<cfparam name="url.passacc"          default="#SESSION.acc#">
	<cfparam name="url.refer"               default="">
	<cfparam name="url.doctypemode"         default="quirks">
	<cfparam name="attributes.scope"        default="ajax">
	
	<!--- --------declare these again to ensure--- --->
	
	<cfparam name="SESSION.root"            default="">
	
	<cfparam name="client.browser"          default="">
	<cfparam name="client.width"            default="">
	<cfparam name="client.dateformatshow"   default="">
	<cfparam name="client.eMail"            default="">
	<cfparam name="client.LanguageId"       default="ENG">
	<cfparam name="client.lanprefix"        default="">
	
	<cfif client.LanguageId eq "">
		<cfset client.languageid = "ENG">
	</cfif>	
	
	<!--- ---------------------------------------- --->
	<cfparam name="SESSION.login"           default="">
	<cfparam name="SESSION.dbpw"            default="">
	
	<cfquery name="Parameter" 
		datasource="AppsInit">
			SELECT *
			FROM   Parameter
			WHERE  Hostname = '#CGI.HTTP_HOST#' 
	</cfquery>		
	
	<cfif SESSION.login eq "">		
	
	    <cfset session.Authent = "0">	
			
		<cfif Len(Trim(Parameter.DefaultPassword)) gt 20> 
		      <!--- encrypt password --->
		      <cf_decrypt text = "#Parameter.DefaultPassword#">
			  <cfset password = Decrypted>
		      <!--- end encryption --->
		<cfelse>	  
		      <cfset password = Parameter.DefaultPassword>
		</cfif>	  
		
		<cfset SESSION.dbpw                 = "#password#">
		<cfset SESSION.login                = "#Parameter.DefaultLogin#">
		
	</cfif>	
	
	<cfparam name="SESSION.acc"             default="">
	<cfparam name="SESSION.login"           default="">
	<cfparam name="SESSION.ProtectionMode"  default="1">
	<cfparam name="SESSION.authent"         default="0">
	<cfparam name="SESSION.isRelogon"       default="No">
	
	<!--- This is an idea to prevent opening the relogon screen if it is already shown on another screen, to prevent double reload
	another options is to run a separete script in a loop to determine if the SESSION.authent has changed into (1), which then restarts the
	checking resulting in  the logon page to disappear again --->	
			
	<cfif Parameter.Operational eq "0">
	
		<!--- 15/2/2015 Skipping --->
	
	<cfelse>
							 		
		<cfif SESSION.authent eq "0"     or 	     
			  SESSION.root eq ""         or 					   		  
			  CLIENT.browser eq ""       or 
			  CLIENT.width eq ""         or 			  
			  CLIENT.dateformatshow eq "">		
						  	
			<!--- if the scope is not ajax it is just a matter of waiting for the ajax to pick it up --->
			
			<cfif attributes.scope eq "ajax">
			
				<cfset SESSION.isRelogon = "Yes">
			
				<script language="JavaScript">						
				    // we stop session validation						
					// sessionvalidatestop()	
					tmp_error = 1;			
					// start checking on ultra level that will validate if the validation to be restarted again
					sessioninitvalidatestart()					
					try { document.getElementById("div_container_screen").style.overflow = 'hidden';
						} catch(e){};		
					try { document.getElementById("sessionvalid").style.display = 'block'
						} catch(e){};											
				</script>	
				
				<!--- we ensure the session is lost and the script will stop reloading --->
				
				<cfset SESSION.authent = "0">		
				
				<cfoutput>
				<script>
				 ProsisUI.createWindow('relogonbox', 'Authentication Manager', '',{x:100,y:100,height:280,width:480,closable:false,modal:true,center:true,resizable:false})    	   									 
	  		     ColdFusion.navigate('#session.root#/Portal/reLogon.cfm','relogonbox')
				</script>	
				</cfoutput>
				
				<cfset Session.relogon = "Yes">			
												
				<cfset SESSION.sessionTimeout = createTimeSpan( 0, 0, 0, 1 ) />
				
				<!--- Revised logout routine by dev on 7/30/2014 --->
				<cflock scope="Session" type="Readonly" timeout="20">
				    <cfset variables.sessionItems = "#StructKeyList(Session)#">
				</cflock>
				
				<cfloop index="ListElement" list="#variables.sessionItems#">
				    <cfif listFindNoCase("CFID,CFToken,URLToken,SessionID,SessionTimeOut", "#ListElement#") is 0 >
					    <cflock scope="Session" type="Exclusive" timeout="20">
				    		<cfset StructDelete(Session, "#ListElement#")>
					    </cflock>
				    </cfif>
				</cfloop>			
								
			<cfelse>
					
				<cfif url.refer neq "workflow" and url.refer neq "Hyperlink">	
																				
					<table width="200" height="100%" align="center">
						<tr><td align="center" class="labellarge" style="font-size: 20px; font-family: 'Calibri Light';"><cf_tl id="Your session has expired"></td></tr>
					</table>
										
					<cfset SESSION.sessionTimeout = createTimeSpan( 0, 0, 0, 1 ) />
					
					<!--- Revised logout routine by dev on 7/30/2014 --->
					<cflock scope="Session" type="Readonly" timeout="20">
					    <cfset variables.sessionItems = "#StructKeyList(Session)#">
					</cflock>
					
					<cfloop index="ListElement" list="#variables.sessionItems#">
					    <cfif listFindNoCase("CFID,CFToken,URLToken,SessionID,SessionTimeOut", "#ListElement#") is 0 >
						    <cflock scope="Session" type="Exclusive" timeout="20">
					    		<cfset StructDelete(Session, "#ListElement#")>
						    </cflock>
					    </cfif>
					</cfloop>					
														
				<cfelse>	
							
					<cfquery name="System" 
					datasource="AppsSystem">
						SELECT *  
						FROM   Parameter
					</cfquery>
															
					<cfif CGI.HTTPS eq "off">
						<cfset tpe = "http">
					<cfelse>	
						<cfset tpe = "https">
					</cfif>
					
					<cfset session.refer = "#tpe#://#CGI.HTTP_HOST##CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">	
										
					 <!--- workflow or report redirect --->	
					 		   
					 <script language="JavaScript">
					 	parent.parent.window.location = "<cfoutput>#tpe#://#CGI.HTTP_HOST#/#System.VirtualDirectory#/Default.cfm?ID=main&refer=workflow</cfoutput>"
					 </script>
					  
				</cfif>	  
					
				<!--- we do not show anything here, as the ajax will then pickup and show a logon screen --->		
						
				<cfabort>	
			
			</cfif>
					
					
		<cfelseif SESSION.authent eq "1" 
		    	 and SESSION.acc neq url.passacc 
				 and SESSION.ProtectionMode eq "1">		
								
				<!--- we will close this window as another user logged on under this session --->
				
				<script language="JavaScript">
				     
					 tmp_error = 0;
				     alert("Your session <cfoutput>[#url.passacc#]</cfoutput> was overruled and your application will now close.")
					 
					 if ( document.getElementById('applicationclosebutton')) {				  
					      document.getElementById('applicationclosebutton').click()					  
					 } else {				 			 
						 if  (parent.document.getElementById('applicationclosebutton')) {				  
						      parent.document.getElementById('applicationclosebutton').click()					 
						 } else {
							 parent.parent.window.close()
						 }
					 }
				</script>	
			
		<cfelseif SESSION.Authent eq "1">	
						
				<cfset SESSION.isRelogon = "No">
				
				<!--- we close the divscroll and we reinit the event handlers to listen and check --->
			
				<script language="JavaScript">		
				   tmp_error = 0;		
				   try {		     
					 // sessionvalidatestart()	this is done by the callback handler to start the validation 	
					 ProsisUI.closeWindow('relogonbox')    			 					
					 } catch(e) {}		   		   
				   try { sessioninitvalidatestop()  } catch(e) {}			 
				</script>	
						
		</cfif>		
		
	</cfif>	

	<cfcatch></cfcatch>

</cftry>


