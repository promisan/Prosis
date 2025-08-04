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

<cfparam name="URL.Selection" default="">
<cfparam name="url.modulecontrol" default="">

<cfset Attributes.Heading    = "">
<cfset Attributes.Module     = "'Portal'">
<cfset Attributes.Selection  = "#URL.Selection#">
<cfset Attributes.Class      = "">

<cfset client.modulecontrol = "#url.modulecontrol#">

<cf_licenseCheck module="#Attributes.Selection#" message="No">

<cfif License eq "0" and Attributes.selection neq "'System'">

	<table width="100%" class="formpadding">	
		  								
			<cfoutput>
			<tr>
				<td class="labelit" style="padding-top:53px;padding-left:120px"><font color="FF0000">License Expired</font></td>
			</tr>
			</cfoutput>
				
	</table>

<cfelse>
	
	<cfinclude template="../tools/SubmenuPrepare.cfm">
	
	<cfoutput query="searchresult">
		<cfif currentrow eq RecordCount>
			
			<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
			<cfset mid = oSecurity.gethash()/>   
			
			<script>			
				var ex = "#SESSION.root#/#FunctionDirectory#/#FunctionPath#?description=#FunctionName#&module=#SystemModule#&selection=#SystemModule#&mid=#mid#"
				$("##portalright").attr({src : ex});
			</script>
		</cfif>
	</cfoutput>	
	
	<cfset row = 0>		
		
	<cfoutput query="searchresult">
			 	
		<cfset moduleEnabled = "1">	
	
		<cfif FunctionName eq "Listing">	
			<cf_verifyOperational checkmodule="Reporting" Warning="No">					
		</cfif>
		
		<cfif getAdministrator("*") eq "1">
		
			<cfset showfunction = "SHOW">
				
		<cfelse>
		
			<cfset showfunction = "SHOW">
				
			<cfif functionName eq "Maintenance">
			      <cfset filter = "'Maintain','System'">
				  			  
				  <cfinvoke component="Service.Access"  
			          method="selectionshow"  
					  Module="#FunctionClass#" 
					  FunctionClass="#filter#"
					  returnvariable="showfunction">
				  
			<cfelseif functionName eq "Application" or functionName eq "Applications">
			      <cfset filter = "'Application'">
				  
				  <cfinvoke component="Service.Access"  
			          method="selectionshow"  
					  Module="#FunctionClass#" 
					  FunctionClass="#filter#"
					  returnvariable="showfunction">
				  
			<cfelseif functionName eq "Inquiry">
					
			      <cfset filter = "'Inquiry','Reporting','Search'">	 
				  		
				  <cfinvoke component="Service.Access"  
			          method="selectionshow"  
					  Module="#FunctionClass#" 
					  FunctionClass="#filter#"
					  returnvariable="showfunction">
									  
			  <cfelseif functionName eq "Reports">
			
			      <!--- -------------------------- --->
				  <!--- added to check for reports --->
				  <!--- -------------------------- --->	
					
			      <cfset filter = "Reports">	 
				  		
				  <cfinvoke component="Service.Access"  
			          method="selectionshow"  
					  Module="#FunctionClass#" 
					  FunctionClass="#filter#"
					  returnvariable="showfunction">					  
					   	  
			<cfelseif functionName eq "Manuals">
			      <cfset filter = "'Manuals'">
				  <cfset showfunction = "SHOW">
				 
			<cfelseif functionName eq "System Configuration">
			      <cfset filter = "'Library','Documentation'"> 	 	
				  <cfset showfunction = "SHOW">
				  
			<cfelseif functionName eq "User Administration"> 			      
				   <cfset filter = "'User'"> 	
				  
				   <cfinvoke component="Service.Access"  
			          method="selectionshow"  
					  Module="#FunctionClass#" 
					  FunctionClass="#filter#"
					  returnvariable="showfunction">
					   
			<cfelse>
				
			      <cfset filter = "">	 
				  
				  <cfif enableAnonymous eq 0>
					
						<cfif MenuClass eq "Custom">
					
						   	  <cfinvoke component="Service.Access"  
						          method="function"  
								  SystemFunctionId="#SystemFunctionId#" 
								  returnvariable="SystemIdAccess">					
							  
							  <cfif SystemIdAccess eq "GRANTED">
							  	<cfset showFunction = "SHOW">
							  <cfelse>
							  	<cfset showFunction = "HIDE">
							  </cfif>
						  
						 </cfif>
						  
				  </cfif> 
						  
			</cfif>		
			
		</cfif>	
												
		<cfif showFunction eq "SHOW">
		
		  <cfset row = row+1>
		 
		  <div onClick="loadform('#FunctionDirectory#','#FunctionPath#','#FunctionTarget#','#SystemModule#','#FunctionName#','#SystemModule#','#FunctionCondition#',this); submenuselected(this);"
		  		class="submenuoptions submenuoptionstheme <cfif currentrow eq RecordCount>submenuoptionsselected</cfif>"
				id="#functionclass##row#">#FunctionName#</div>
				  
		</cfif>  
			
	</cfoutput>
	
</cfif>	
