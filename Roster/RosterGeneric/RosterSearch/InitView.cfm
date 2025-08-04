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
<cfparam name="URL.DocNo"      default="">
<cfparam name="URL.mid"        default="">
<cfparam name="url.wparam"     default="ALL">
<cfparam name="URL.FunctionNo" default="0">
<cfparam name="URL.Scope"      default="Embed">

<cfif URL.FunctionNo eq "">
      <cfset URL.FunctionNo =  "0">
</cfif>

<cfquery name="Owner" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_AuthorizationRoleOwner
</cfquery>
	
<cfparam name="URL.Status" default="1">
<cfparam name="URL.Mode"   default="Regular">
<cfparam name="URL.Cat"    default="Regular">
<cfparam name="URL.Owner"  default="#Owner.Code#">

<cfif url.cat eq "Regular">
   <cfset loc = "Search1.cfm?header=0&wparam=#url.wparam#&docno=#URL.DocNo#&functionno=#URL.FunctionNo#&mode=#URL.Mode#&owner=#URL.Owner#&Status=#URL.Status#&mid=#url.mid#">
</cfif>

<cfoutput>

<cfif url.mode eq "ssa">
	
	<cf_screentop label="Candidate search for procurement job: #URL.DocNo#" 
	   height       = "100%" 	  
	   band         = "No" 
	   html         = "No"
	   jQuery       = "Yes" 
	   systemmodule = "Roster"
	   option       = "Perform a search"
	   layout       = "webdialog" 
	   banner       = "yellow"
	   scroll       = "no">

<cfelseif URL.mode eq "Vacancy">
	
	<cfif url.scope eq "Embed">
		<cfset sh = "No">
	<cfelse>
	    <cfset sh = "Yes">
	</cfif>
	<cf_screentop label="Candidate Search for recruitment track: #URL.DocNo#" 
	   height    ="100%" 	   
	   band      = "No" 
	   html      = "#sh#"  <!--- added the hide option here --->	   
	   jQuery    = "Yes" 
	   systemmodule = "Roster"
	   layout    = "webapp" 
	   banner    = "gray"
	   scroll    = "yes">	      
   
<cfelse>
	
	<cf_screentop label="Roster search #URL.Owner#" 
	   height       = "100%" 	  
	   bannerheight = "55"
	   band         = "No" 
	   jQuery       = "Yes" 
	   systemmodule = "Roster"
	   option       = "Searches all enabled editions"
	   layout       = "webapp" 
	   banner       = "gray"
	   scroll       = "yes">

</cfif>   

</cfoutput>

<meta http-equiv="Pragma" content="no-cache"> 
<script language="JavaScript">
   javascript:window.history.forward(1);
</script>

<cfoutput>

<cf_LayoutScript>
		 
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">
	
	<cfif url.mode neq "complete" and url.mode neq "Vacancy">
	
	<cf_layoutarea 
	   	position  = "header"
	   	name      = "rostertop"
	   	minsize	  = "50px"
		maxsize	  = "50px"
		size 	  = "50px">	
		
		<cf_ViewTopMenu label="Select Candidate" background="red">
					 			  
	</cf_layoutarea>	
	
	</cfif>	
	  
	<cf_layoutarea 
	    position      = "left" 
		name          = "treebox" 
		maxsize       = "340" 		
		size          = "340" 
		minsize       = "340"
		collapsible   = "true" 
		initcollapsed = "yes"
		splitter      = "true"
		overflow      = "hidden">
													
			<iframe src="SearchTree.cfm?ID=0&docno=#URL.DocNo#&functionno=#URL.FunctionNo#&mode=#URL.Mode#&owner=#URL.Owner#&Status=#URL.Status#&mid=#url.mid#"
		        name="left"
		        id="left"
		        width="100%"
		        height="99%"
				scrolling="no"
		        frameborder="0"></iframe>		
				
	</cf_layoutarea>
	
	<cf_layoutarea position="center" name="box" overflow = "hidden">										
								
			<iframe src="#loc#"
			        name="main"
			        id="main"
			        width="100%"
			        height="99%"
					scrolling="no"
			        frameborder="0"></iframe>
					
	</cf_layoutarea>			
		
</cf_layout>
	
</cfoutput>


<cf_screenBottom layout="webapp">