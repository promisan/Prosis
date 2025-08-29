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
<cfparam name="URL.mde"            default="">
<cfparam name="URL.target"         default="">
<cfparam name="CLIENT.init"        default="No">
<cfparam name="SESSION.authent"    default="">
<cfparam name="SESSION.logon"      default="">
<cfparam name="CLIENT.TargetURL"   default="">
<cfparam name="SESSION.refer"      default="">
<cfparam name="url.mid"            default="">
<cfparam name="form.account"       default="">

<cf_validateBrowser>
<cfajaximport tags="cfdiv">
	
<cfif clientbrowser.name eq "Explorer" and clientbrowser.release lt "10">
		
	<cfset stylePath = "BackOffice/Standard">
	<cfset backOfficeStyle = "Standard">
	
<cfelse>
	
	<cfset stylePath = "BackOffice/HTML5">
	<cfset backOfficeStyle = "HTML5">	
	
</cfif>

<!--- 15/10/2015 important to keep this to prevent users to press reload --->
<cfif backOfficeStyle eq "HTML5"> <!--- 30/10/2015 cf_preventcache makes the old menu break --->
			
	<cf_preventcache>
		
</cfif>



			
<!--- addded 10/2/2015 to make it difficult to run the MainMenuView template also --->
			   
<cfif (SESSION.authent eq "0" and CLIENT.init eq "No")>
					
		<!--- we now immediately move to the login screen as people might just click refresh here --->			
		
		<script language="JavaScript">		   		   
		 	window.location = "../default.cfm"
		</script>
					
<cfelseif SESSION.refer neq "">		

	<cfif url.mde eq "">
		
		<cfinclude template="AuthentProcess.cfm">		
		
		<cfset CLIENT.acc  = SESSION.acc>		
		
	</cfif>	
	
	<cfset CLIENT.init = "No">	  
			
	<cfoutput>
					
		<!--- we now move immediately to the referred template --->			
		<script language="JavaScript">
		 	window.location = "#session.refer#"
		</script>
		
		<cfset SESSION.refer = "">
		
	</cfoutput>

<cfelse>
	
	<cfif url.mde eq "">
			
	    <!--- we validate the account/password and set the client vars ---> 
		<cfinclude template="Authent.cfm">
								
		<!--- just a precaution for backward compatibility --->
		<cfset CLIENT.acc = SESSION.acc>
		
	</cfif>		
		
	<!--- now we are read to open the template --->		
		
	<cfinclude template="MainMenuView.cfm">		
		
</cfif>
		
