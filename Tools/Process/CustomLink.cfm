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
<cfparam name="Attributes.SystemModule"  default="Custom">
<cfparam name="Attributes.FunctionClass" default="Staffing">
<cfparam name="Attributes.FunctionName"  default="stPosition">
<cfparam name="Attributes.Field"         default="">
<cfparam name="Attributes.Key"           default="12345">
<cfparam name="Attributes.Width"         default="400">
<cfparam name="Attributes.Height"        default="420">
<cfparam name="Attributes.Icon"          default="contract.gif">
<cfparam name="Attributes.IconHover"     default="button.jpg">
<cfparam name="Attributes.Scroll"        default="Yes">
<cfparam name="Attributes.Status"        default="no">
<cfparam name="Attributes.ScriptOnly"    default="No">

<cfquery name="Custom" 
	    datasource="AppsSystem" 
    	username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT    *
		FROM      Ref_ModuleControl
		WHERE     SystemModule   = '#Attributes.SystemModule#'
		 AND      FunctionClass  = '#Attributes.FunctionClass#' 
		 AND      FunctionName   = '#Attributes.FunctionName#'
</cfquery> 

<cfif Custom.screenwidth neq "">
	<cfset Attributes.Width = "#Custom.screenwidth#">
</cfif>

<cfif Custom.screenheight neq "">
    <cfset Attributes.Height = "#Custom.screenheight#">
</cfif>

<cfoutput>
		
<cfif Custom.recordcount eq "1">

	<script language="JavaScript">

		function custom(lnk) {			
												
			<cfif #Attributes.Field# neq "">			
			key = document.getElementById(lnk).value;			
			<cfelse>			
			key = lnk;			
			</cfif>		
			// window.showxxModalDialog("#SESSION.root#/#Custom.FunctionPath#?id="+key, window, "unadorned:yes; edge:raised; status:#Attributes.Status#; dialogHeight:#Attributes.Height#px; dialogWidth:#Attributes.Width#px; help:no; scroll:#Attributes.Scroll#; center:yes; resizable:no");																					
			window.open("#SESSION.root#/#Custom.FunctionPath#?id="+key, "_blank")										
			}

	  </script>
		
	  <cfif Attributes.Field neq "">
					
			   <img src="#SESSION.root#/Images/#Attributes.Icon#" 
			    onMouseOver="document.img_#Attributes.Key#.src='#SESSION.root#/Images/#Attributes.IconHover#'"
	    		onMouseOut="document.img_#Attributes.Key#.src='#SESSION.root#/Images/#Attributes.Icon#'"
				id="img_#Attributes.Key#"
				name="img_#Attributes.Key#"
			    alt="Retrieve" 
			    border="0"
				width="16" 
			    height="18"
				onclick="custom('#Attributes.Field#')"
			    align="absmiddle" 
			    style="cursor: pointer;">
				  
		 <cfelse>
		 
		 	<a title="Retrieve source" href="javascript:custom('#Attributes.Key#')">#Attributes.Key#</a>
		 
		 </cfif>
	 	 
<cfelse>

	<script language="JavaScript">
	
	function custom(lnk) {
								
		<cfif #Attributes.Field# neq "">		
		key = document.getElementById(lnk).value;		
		<cfelse>		
		key = lnk;		
		</cfif>		
		window.open("#SESSION.root#/#Custom.FunctionPath#?id="+key, "_blank")							
		// ret = window.showxxModalDialog("#SESSION.root#/#Custom.FunctionPath#?id="+key, window, "unadorned:yes; edge:raised; status:#Attributes.Status#; dialogHeight:#Attributes.Height#px; dialogWidth:#Attributes.Width#px; help:no; scroll:#Attributes.Scroll#; center:yes; resizable:no");									
		}
	
	</script>
	
	#Attributes.Key#	 
	 
</cfif>

</cfoutput>
			
	