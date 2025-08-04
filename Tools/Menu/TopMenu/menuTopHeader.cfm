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

<cfoutput>

<cf_SubmenuScript>

<cfparam name="attributes.directory" default="TopMenu">
<cfparam name="attributes.template" default="HeaderMenu1">
<cfparam name="attributes.align" default="left">
<cfparam name="Attributes.SystemModule" default="">
<cfparam name="passtru" default="">

<table cellspacing="0" cellpadding="0" >	 												 

<tr>
<td>

<cf_UIMenu name="topmenu">
	
	<cfloop index="itm" from="1" to="#attributes.items#" step="1">
	
	    <!--- find the details for each header --->
	
		<cfparam name="attributes.header#itm#"           default="My header">
		<cfparam name="attributes.functionClassm#itm#"   default="">
		<cfparam name="attributes.menuClass#itm#"        default="">
	
		<cfset header        = evaluate("attributes.header#itm#")>
		<cfset functionClass = evaluate("attributes.functionClass#itm#")>
		<cfset menuClass     = evaluate("attributes.menuClass#itm#")>	
								
		<cf_UIMenuitem
	        display="#Header#"
	        name="m#itm#">				
			  									  
			<cfquery name="SearchResult" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   *
				FROM     xl#Client.LanguageId#_Ref_ModuleControl
				WHERE    SystemModule  in (#PreserveSingleQuotes(Attributes.SystemModule)#) 
				AND      FunctionClass in (#PreserveSingleQuotes(functionClass)#)
				AND      Operational = '1'
				<!--- 	AND      MainmenuItem = 1 --->
				AND      MenuClass in (#PreserveSingleQuotes(menuClass)#) 
			</cfquery>	
												
			<cfset idlist = "">
			
			<cfset s = 0>
						
			<cfloop query="SearchResult">			
							
				<cfif IdMenu neq SystemFunctionId>
							      
					<cfinvoke component="Service.Access"  
			          method="function"  
					  SystemFunctionId="#SystemFunctionId#" 
					  returnvariable="access">
					  					
					 <CFIF access is "GRANTED">  				
										  
					  	<cfset s = s+1>
					  	
						<cfif idlist eq "">
						   <cfset idlist = "#SystemFunctionId#">
						<cfelse>
						   <cfset idlist = "#idlist#,#SystemFunctionId#">						
						</cfif>		
						
						 <cfset condition = FunctionCondition>
			 		 	 <cfif passtru neq "">
						 	<cfset condition = passtru>
						 </cfif>	
						 
						 <cfif FunctionPath neq "">								
			          		 <cfset load = "javascript:loadformI('#FunctionPath#','#condition#','_self','#FunctionDirectory#','#systemFunctionId#','','','default','')">      	 	  
						 <cfelse>	 
		   				     <cfset load = "javascript:#ScriptName#('#scriptConstant#','#systemFunctionId#')">     	 	 	  	  
						 </cfif>
						 
						 <cfset fun[s] = FunctionName>
						 <cfset ref[s] = load>
						 						
					</cfif>
														
				</cfif>
					
			</cfloop>
			
			<cfset cnt = 0>
								 												
			<cfloop index="opt" from="1" to="#s#">

					<cfset cnt=cnt+1>

					<cftry>

					<cf_UIMenuitem
				          display="#fun[opt]#"
				          name="m#itm#_#opt#"
						  href="#ref[opt]#"
						  children="1"
				          image="#SESSION.root#/Images/bullet.gif">
					</cf_UIMenuItem>

					<cfcatch></cfcatch>

					</cftry>

					<cfif cnt eq "3" and opt neq s>
						<cfset cnt = 0>
					</cfif>

			</cfloop>
											
		</cf_UIMenuitem>
		 
	</cfloop>
	
</cf_UIMenu>

</td></tr></table>	

</cfoutput>


