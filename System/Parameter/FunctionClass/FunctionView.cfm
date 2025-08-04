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

<cfparam name="URL.mission" default="UN">

<cfoutput>

<cf_tl id="Function Documenter" var="1">

<cf_screenTop height="100%" title="#lt_text#" jQuery="Yes" html="No" menuaccess="Yes" systemfunctionid="#url.idmenu#">

<cfinclude template="FunctionScript.cfm">
<cf_layoutscript>	 
	 
<cfset attrib = {type="Border",name="container",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">
						   
  	<cf_layoutarea 
         position  = "top"
         name      = "controltop"
         minsize   = "60"
         maxsize   = "60"  
	     size      = "60" splitter="true" overflow="hidden">	
	  			  
		<cf_ViewTopMenu label="#lt_text#">	  
	  		  			  
	</cf_layoutarea>		 
	  
        <cf_layoutarea 
	          position="left"
	          name="controltree"
	          source="FunctionViewTree.cfm?ID2=#url.mission#"			          	          
			  size="240"
			  minsize="240"
			  maxsize="240"
	          overflow="auto"
	          collapsible="true"
	          splitter="true"/>
		
	   <cf_layoutarea  
		    position="center" 
			name="controllist"/>
	
		 <cf_layoutarea
	          position="bottom"
	          name="controldetail" 
			  title="UseCase"        
	          size="400"			  
	          source="FunctionDetail.cfm?id2=#url.mission#"
	          overflow="auto"
	          collapsible="true"
	          initcollapsed="true"
	          inithide="false"
	          splitter="true"/> 
				  			
</cf_layout>
			
</cfoutput>
