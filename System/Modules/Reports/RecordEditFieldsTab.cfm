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
<style>
    #menu1,
    #menu2,
    #menu3,
    #menu4,
    #menu5,
    #menu6,
    #menu7{
        padding: 2px 0 10px !important;
        border-top: 1px solid #f5f5f5!important;
        border-right: 1px solid #f3f3f3!important;
        border-bottom: 1px solid #f5f5f5!important;
    }
    #menu1{
        border-left: 1px solid #f3f3f3!important;
    }
    #menu1_text.labelit,
    #menu2_text.labelit,
    #menu3_text.labelit,
    #menu4_text.labelit,
    #menu5_text.labelit,
    #menu6_text.labelit,
    #menu7_text.labelit{
        padding: 0!important;
        
    }
    .highlight{
        background: #f5f5f5!important;
    }
</style>
       
<table width="100%" height="100%" cellspacing="0" cellpadding="0">

<cfoutput>
<tr><td>

		<!--- top menu --->
        
		<table width="100%" align="center" class="formpadding">		  		
						
			<cfset ht = "64">
			<cfset wd = "64">			
			
			<tr>		
			
					<cfset itm = 0>
					
					<cfset itm = itm+1>			
										
					<cf_menutab item       = "#itm#" 
					            iconsrc    = "Logos/System/Maintain.png" 
								targetitem = "1"
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								class      = "highlight1"
								name       = "General Settings">		
								
					
					<cfif Flow.Recordcount gte "1" 
		       		and workflow.recordcount neq "0" 
					   and master eq "1">
					   
					      <cfajaximport tags="cfdiv">
				          <cf_ActionListingScript>
						  
						  <cfset wflnk = "RecordEditFieldsWorkflow.cfm">
				       					   
					      <input  type  = "hidden" 
							name        = "workflowlink_#line.controlid#" 
							id          = "workflowlink_#line.controlid#"
							value       = "#wflnk#"> 	
			   
						<cfset itm = itm+1>
				
					    <cf_menutab item       = "1" 
						            iconsrc    = "Logos/Workflow.png" 
									targetitem = "2"
									iconwidth  = "#wd#" 
									iconheight = "#ht#" 
									name       = "Approval flow">		
								
					</cfif>								
																
					<cfset itm = itm+1>													
					<cf_menutab item       = "#itm#" 
					            iconsrc    = "Logos/System/Selection-Criteria.png" 
								iconwidth  = "#wd#" 
								targetitem = "3"
								iconheight = "#ht#" 
								name       = "Selection Criteria">
								
					<cfset itm = itm+1>											
					<cf_menutab item       = "#itm#" 
					            iconsrc    = "Logos/System/Memo.png" 
								targetitem = "6"
								iconwidth  = "#wd#" 								
								iconheight = "#ht#" 
								name       = "Memo"
								source     = "Recordmemo.cfm?controlid=#line.controlid#">		
								
					<cfset path = replace("#rootpath#\#Line.reportPath#","\","|","ALL")> 	
				    <cfset path = replace(path,"/","|","ALL")> 											
								
					<cfset itm = itm+1>						
					<cf_menutab item       = "#itm#" 
					            iconsrc    = "Logos/System/File-Library.png" 
								targetitem = "4"
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								name       = "File Library">	
								
					<cfset itm = itm+1>						
					<cf_menutab item       = "#itm#" 
					            iconsrc    = "Logos/System/secure.png" 
								targetitem = "5"
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								name       = "Security">					
								
					<cfset itm = itm+1>									
					<cf_menutab item       = "#itm#" 
					            iconsrc    = "Logos/System/log.png" 
								targetitem = "6"								
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								name       = "Output Definition"
								source     = "RecordEditFieldsLayout.cfm?id=#URL.ID#&status=#op#">		
											
					<cfset itm = itm+1>									
					<cf_menutab item       = "#itm#" 
					            iconsrc    = "Logos/System/Statistics.png" 
								targetitem = "6"
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								name       = "Statistics"
								source     = "RecordEditFieldsUsage.cfm?id=#URL.ID#&status=#op#">	
														 		
				</tr>
		</table>

	</td>
 </tr>
 </cfoutput>
 
<tr><td height="1" colspan="1" class="linedotted"></td></tr>

<tr><td height="100%">

	<cf_divscroll>	
	
	<table width="100%" 	     
		  height="100%"
		  align="center">
	 		
			<tr class="hide"><td valign="top" height="100%" id="result" name="result"></td></tr>
			
			<cf_menucontainer item="1" class="regular">					
				<cfinclude template="RecordEditGeneral.cfm">					
			</cf_menucontainer>
			
			<cf_menucontainer item="2" class="regular">
							
					<cfif Flow.Recordcount gte "1" 
			       		and workflow.recordcount neq "0" 
					    and master eq "1">
						
						<cfdiv id="#Line.controlId#" bind="url:RecordEditFieldsWorkflow.cfm?ajaxid=#line.controlid#"/> 		
						
					</cfif>
											
			</cf_menucontainer>						
							
			<cf_menucontainer item="3" class="hide">
				<cfinclude template="RecordEditFieldsCriteria.cfm">				
			</cf_menucontainer>
								
			<cf_menucontainer item="4" class="hide">
			  <cfset url.controlid = url.id>
			  <cfset url.path = path>
			  <cfinclude template="ReportInit/ReportLibrary.cfm">
			</cf_menucontainer>
			
			<cf_menucontainer item="5" class="hide">					
				<cfinclude template="RecordEditFieldsSecurity.cfm">						
			</cf_menucontainer>	
			
			<cf_menucontainer item="6" class="hide">
			xxxxxxxxxxxxxxxxxxxxxxx
			</cf_menucontainer>
															
	</table>
	
	</cf_divscroll>

</td></tr>

</table>
