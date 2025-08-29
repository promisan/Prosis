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
<cfoutput>

<cfparam name="url.iconSet"	default="Gray">
<cfset baseImageDirectory = "#session.root#/images/HTML5/#url.IconSet#">
<cfset imageDirectory     = "#baseImageDirectory#/Preferences">	
	
<table width="94%" width="100%" style="border:1px solid silver" class="formpadding" border="0" cellspacing="0" cellpadding="0" align="center">

		<tr>
					
			<td valign="top" style="height:100%; width:200px; padding:2px;">
				<div style="height:95%; width:100%; border:1px solid C0C0C0; -moz-border-radius: 12px; -moz-border-radius: 8px; -khtml-border-radius: 8px; -webkit-border-radius: 8px; padding:5px;">
				
					<table>
				
						<tr>
							<cfset ht = "20">
							<cfset wd = "20">
								
							<cfset itm = 0>
							
							<cfset itm = itm + 1>
							<cf_tl id="Service details" var="1">
							
							<cf_menutab item       = "#itm#" 
							        targetitem = "1"
							        iconsrc    = "#imageDirectory#/Identification.png" 
									iconwidth  = "#wd#" 
									iconheight = "#ht#" 
									class      = "highlight"
									name       = "#lt_text#"
									source     = "javascript:pref('UserIdentification.cfm')">		
						</tr>		
						
						
						<tr>
							<cfset itm = itm + 1>
							<cf_tl id="Signature" var="1">			
							<cf_menutab item       = "#itm#" 
							        targetitem = "1"
							        iconsrc    = "#imageDirectory#/Signature.png" 
									iconwidth  = "#wd#" 
									iconheight = "#ht#" 
									name       = "#lt_text#"
									source     = "javascript:pref('UserSignature.cfm')">	
						</tr>
						
						<tr>
							<cfset itm = itm + 1>			
							<cf_tl id="Benefits" var="1">
							
							<cf_menutab item       = "#itm#" 
							        targetitem = "1"
							        iconsrc    = "#imageDirectory#/Features.png" 
									iconwidth  = "#wd#" 
									iconheight = "#ht#" 
									name       = "#lt_text#"
									source     = "javascript:pref('UserPresentation.cfm')">		
						</tr>	
							
						<tr>
							<cfset itm = itm + 1>			
							<cf_tl id="Pricing" var="1">
									
							<cf_menutab item       = "#itm#" 
							        targetitem = "1"
							        iconsrc    = "#imageDirectory#/Annotation.png" 
									iconwidth  = "#wd#" 
									iconheight = "#ht#" 
									name       = "#lt_text#"
									source     = "javascript:pref('UserAnnotation.cfm')">		
						</tr>
						
						
						<tr>
							<cfset itm = itm + 1>
							<cf_tl id="Common Questions" var="1">
										
							<cf_menutab item       = "#itm#" 
							        targetitem = "1"
							        iconsrc    = "#imageDirectory#/Workflow.png" 
									iconwidth  = "#wd#" 
									iconheight = "#ht#" 
									name       = "#lt_text#"
									source     = "javascript:pref('UserWorkflow.cfm')">		
						</tr>
						
					</table>
					
				</div>
			
			</td>
				
			<td valign="top" height="100%" width="90%" style="padding-left:20px;">  
				<table width="100%" height="100%">	
					<cf_menucontainer item="1" class="regular">
						
					</cf_menucontainer>	
				</table>
			</td>
		
		</tr>
	
	</table>

</cfoutput>