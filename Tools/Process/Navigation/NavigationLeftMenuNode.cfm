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

<cfparam name="showDescription" default="">

<cf_param name="URL.process" default="0" type="String">
<cf_param name="URL.section" default="" type="String">

<cfif url.process eq "1">
			
	<cfquery name="Section" 
	datasource="#alias#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   #CLIENT.LanPrefix#Ref_#url.object#Section R, 
		       #url.Object#Section C
		WHERE  TriggerGroup                 = '#url.Group#'
		AND    R.Code                       = C.#url.object#Section
		AND    C.#url.Object##url.objectId# = '#url.Id#'
		AND    R.Code                       = '#URL.section#'
		AND    R.Operational                = 1  
		AND    C.Operational                = 1
	</cfquery>
		
	<cfset cl   = "select">
	<cfset code = "#URL.section#">

	<cfset processstatus       = "">
	<cfset description         = "">
	<cfset showDescription     = "">
	<cfset descriptiontooltip  = "">
	<cfset ProgressCheckBox    = "">
	<cfset ProgressIconDone    = "">
	<cfset ProgressIconPending = "">
	
	<cfif isDefined("section")>
		    
		<cfset processstatus       = section.processStatus>
		<cfset description         = section.description>
		<cfif structKeyExists(section,"showDescription")>
			<cfset showDescription     = section.showDescription>
		</cfif>
		<cfset descriptiontooltip  = section.descriptionTooltip>
		<cfset ProgressCheckBox    = section.ProgressCheckBox>
		<cfset ProgressIconDone    = section.ProgressIconDone>
		<cfset ProgressIconPending = section.ProgressIconPending>
	</cfif>
	<cfset OfficerUserId       = "x">
	
</cfif>

<cfparam name="iconWidth"  default="40">
<cfparam name="iconHeight" default="40">

<cfif iconwidth lt 48>
	<cfset iconWidth  = "48">
	<cfset iconHeight = "48">
</cfif>

 <cfoutput>
  
 	<table width="100%" border="0"    
	   height      = "62"
	   style       = "cursor:pointer"
	   id          = "menu#code#"
	   name        = "menu#code#"	   
	   bgcolor     = "transparent"
	   class       = "#cl#"	  
	   style       = "cursor: pointer; width:100px; border-collapse:separate;"	     
	   onClick     = "<cfif ProcessStatus eq '1'>loadform('#code#'); selected('menu#code#');</cfif>"
	   onMouseOver = "<cfif ProcessStatus eq '1'>hl(this,true,'#Description#')</cfif>"
	   onMouseOut  = "<cfif ProcessStatus eq '1'>hl(this,false,'')</cfif>">
		  
	   <tr> 
	     	   	    			  				    
		<cfif ProcessStatus eq "1" or ProgressCheckBox eq "0">
			 		 
	        <cfif DescriptionTooltip neq "">
			    <cfset tool = DescriptionTooltip>
			<cfelse>
			   <cfset tool = description>
			</cfif>	
										
		  	<cfif ProgressCheckBox eq "1">
			  <td height="23" align="center" style="padding-top:5px;">			 						   
			      	<img src="#SESSION.root#/Images/#ProgressIconDone#" 
				       id="#code#" 
					   name="#code#" 
					   title="#tool#" 
					   style="cursor:pointer;"
					   border="0" 			   
					   <cfif iconWidth neq "">
				   	   width = "#iconWidth#"
					   </cfif>					   
					   <cfif iconHeight neq "">
					   height = "#iconHeight#"
					   </cfif>					   
					   align="absmiddle">
			   </td>
						
		  	</cfif>					
			
		    </td>
			 
		<cfelse>
		
			<td height="23" align="center" style="padding-top:5px;">	
										   					   				   
			   <cfif ProgressIconPending neq "">
			   			   
					    <img src="#SESSION.root#/Images/#ProgressIconPending#" 
					       id="#code#"
						   name="#code#"
					       title="#description#" 
						   style="cursor:pointer;"
						   border="0" 						   
						   <cfif iconWidth neq "">
					   			width = "#iconWidth#"
					   		</cfif>					   
					   		<cfif iconHeight neq "">
					   			height = "#iconHeight#"
					   		</cfif>						   
						   align="absmiddle">
						  						   
				</cfif>		   
						      
			</td>
					
		</cfif>	  
	  </tr>
	  
	  <cfif showDescription eq 1>
	  	<tr>
			<td class="labelmedium2" align="center" style="font-size:16px; line-height: 19px; padding-bottom:4px;">			
				#description#                
			</td>
		</tr>
	  </cfif>
	  		  		  
	</table>
	
</cfoutput>		

<cfif cl eq "select">
	<!--- Scroll to selected element --->
	<cfset AjaxOnLoad("function() { scrollToItem('###code#'); }")>
</cfif>