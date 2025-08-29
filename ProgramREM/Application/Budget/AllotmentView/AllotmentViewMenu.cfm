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
<cfparam name="url.portal" default="0">
 
<cfquery name="Edition" 
    datasource="AppsProgram" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_AllotmentEdition
	WHERE  EditionId = '#URL.Edition#' 	
</cfquery>

<table width="100%" cellspacing="0" cellpadding="0">

<tr>
  
  <td colspan="2">
 
	  <table width="99%" border="0" cellspacing="0" cellpadding="0">
	 	   
	   <tr style="height:40px">
	   	  
	   <td width="100" style="padding-left:5px">
	   
	   	   <table cellspacing="0" cellpadding="0" border="0">
		    
			 <tr>
			
			    <td style="padding-left:7px;padding-right:2px">
			 
			    <cfparam name="url.find" default="">
				
				<input type = "text" 
				   name     = "find" 
				   id       = "find" 
				   style    = "width:120;height:25px;font-size:13px;"
				   class    = "regularxl" 				   
				   value    = "<cfoutput>#url.find#</cfoutput>">
				   
				   <!---
				   onKeyUp  = "reloadBudget(document.getElementById('page').value)"
				   --->
				   
				   </td>
				   <td  width="23" align="center" style="padding-left:0px;padding-right:2px">
				   
					<cfoutput>
						<cf_tl id="Find" var="vFind">
					    <input type="button" id="findlocate" name="findlocate" value="#vFind#" 
						style="height:25;width:48px"  class="button10g" onclick="reloadBudget(document.getElementById('page').value)">	
						 
					</cfoutput>
				
				</td>
							
				<td height="20" colspan="2" style="padding-left:10px">
			  
			  		<table cellspacing="0" cellpadding="0">
					<tr>
			  
				  	<cfoutput>
					  	
						<!--- allow for mark-down only if 
						    - edition has detailed information			
						    - the view is a view by unit to limit the units and programs to be marked down
							- the edition is open 
							- mode is requestion lines 				
						--->		
						
						<cfif url.mode neq "STA">
						
							<cfinvoke component="Service.Access"  
								Method         = "budget"		
								Mission        = "#edition.mission#"
								Period         = "#URL.Period#"	
								EditionId      = "#URL.edition#"  
								Role           = "'BudgetManager'"
								ReturnVariable = "BudgetAccess">							
								
							<CFIF (BudgetAccess is "ALL" or BudgetAccess is "EDIT") and url.portal eq ""> 	
							
								<!--- and Edition.AllocationEntryMode eq "2" --->
							
								<td style="padding-left:5px">
								<cf_tl id="Fund allocation" var="1">					
						    	<input type="button" value="#lt_text#" class="button10g" style="width:140px;height:25" onClick="Allocation(document.getElementById('editionselect').value,'#URL.Period#')"> 
								</td>
								 
							</cfif> 
																						
							<cfif Edition.BudgetEntryMode eq "1" and Edition.Status eq "1">
														
								<td style="padding-left:5px">
								<cf_tl id="Trim Requirements" var="1">					
						    	<input type="button" value="#lt_text#" class="button10g" style="width:140px;height:25" onClick="WhatIf(document.getElementById('editionselect').value,'#URL.Period#')"> 
								</td>
								 
							</cfif> 											
						
						</cfif>
						
						<!--- allow for transfer of amounts between programs only if the edition is locked --->
						
						<cfparam name="BudgetAccess" default="None">
						
						<!--- removed this limitation, as transfer can take place anytime during the cycle
						<cfif Edition.Status eq "3" or Edition.Status eq "9">
						--->
										
							<CFIF BudgetAccess is "ALL"> 	
								
								<cf_tl id="Transfer Allotments" var="1">
								
								 <td style="padding-left:5px">	
								
							    	 <input type="button" 
									  value="#lt_text#"
									  class="button10g" 
									  style="width:140px;height:25" 
									  onClick="budgettransfer('#url.mission#','#URL.Period#',document.getElementById('editionselect').value,'')"> 
								  
								  </td>				 
								 
							</cfif>  
						
						<!---
						</cfif>					
						--->
						
						<td>&nbsp;</td>
						
						<td align="center">
						
							<cf_tl id="Refresh" var="1">
							<cfset vRefresh=lt_text> 			
							<img src="#SESSION.root#/images/refresh.gif" style="cursor:pointer" align="absmiddle" alt="Refresh screen" border="0" onClick="reloadBudget('1')">
									
						</td>
						
				   	</cfoutput>
					
					</table>
				
				</td>
				
				</tr>
		
			</table>
			
	  </td>
	  
	  <td align="right" style="height:35">
	  
	  	   <cfparam name="url.mode" default="PRG">	
		   <cfparam name="url.lay" default="Components">	
		   
		   <cfif url.id1 eq "Tree">
			   <cfset url.view = "All">
			   <cfset url.lay  = "Components">
		   <cfelse>
		   	   <cfparam name="url.view" default="All">	
		   </cfif>
		   
		   <cfoutput>
		   		   	  	  	   
	   	   <cfif url.mode eq "PRG" and url.id1 neq "Tree">
	
			   <select name="view" id="view" size="1" class="regularxl"  onChange="reloadBudget(page.value)">
			       <OPTION value="All" <cfif URL.View eq "All">selected</cfif>>
				 	<cf_tl id="All Programs/Project and Units">
				  <OPTION value="Prg"  <cfif URL.View eq "Prg">selected</cfif>><cf_tl id="Hide OrgUnits">	 
			      <OPTION value="Only" <cfif URL.View eq "Only">selected</cfif>>
				 	<cfif url.mode eq "PRG"><cf_tl id="Selected Unit only"><cfelse><cf_tl id="Only Alloted Programs"></cfif>
				 
			   </select>
			   
			   <input type="hidden" name="layout" id="layout" value="#URL.Lay#">
			   
			   <!--- disabled this feature as we control it more through the version
			
			    <select name="layout" id="layout" size="1" class="regularxl" onChange="reloadBudget(page.value)">
				     <option value="Program"    <cfif URL.Lay eq "Program">selected</cfif>>	    <cf_tl id="Program">
					 <option value="Components" <cfif URL.Lay eq "Components">selected</cfif>>	<cf_tl id="All">
					 <option value="HideNull"   <cfif URL.Lay eq "HideNull">selected</cfif>>	<cf_tl id="Hide 0 amounts">
			 	</select>
			
				--->	
			
		   <cfelse>
		   		   
		   		<input type="hidden" name="view"   id="view"   value="#URL.View#">	
				<input type="hidden" name="layout" id="layout" value="#URL.Lay#">
				
		   </cfif>	
		   
		   </cfoutput>
				
	    </td>
	    
	  </tr>
		
	  </table>
		
  </td>
  
</tr>
  
<tr><td class="line" colspan="2"></td></tr>
  
</table>