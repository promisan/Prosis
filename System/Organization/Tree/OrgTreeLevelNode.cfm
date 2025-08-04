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

<!---
<link href=css/OrgTree.css rel="stylesheet" type="text/css" media="all" />
--->

<cfoutput>

<td colspan="#cl#" align="left" valign="top">

	<div class="folder">	
	
	<table width="100%" style="padding:2px;<cfif attributes.panel eq 'left'>background:url(#SESSION.root#/system/organization/tree/images/color#attributes.level#.jpg)</cfif>;" 
	border="0" cellspacing="0" cellpadding="0">
		   	  
	   <cfif attributes.panel eq "left">
	  	  	  
	   		<cfset script = "tree('#attributes.parent#','#attributes.nme#')">
			<cfset style  = "cursor: pointer;">			
           
			<tr>
			<td height="16" align="center" onMouseOver="hlnode(this,'hl')" onMouseOut="hlnode(this,'normal')">
					
				<table width="100%" cellspacing="0" cellpadding="0" id="select" onClick="#script#" class="formpadding">
									
					<tr>
					<cfif attributes.level lte "2">
					  <cfset ht = "27">
					<cfelse>
					  <cfset ht = "14">					  
					</cfif>
															
					<td height="#ht#"  align="center" style="#style#;font-size:12px;">
						<cfif len(attributes.nme) gt "24">
						<a title="#attributes.nme#"><font color="000000">#left(attributes.nme,24)#</a>
						<cfelse>
						#attributes.nme#
						</cfif>											
					</td>
					</tr>				
						
				</table>
			
			</td>		
			</tr>			
		
		<cfelse>
			
			<cfif attributes.unit eq "">
			    <cfset unit = url.orgunit>
			<cfelse>
			    <cfset unit = attributes.Unit>
			</cfif>				
		    
			<cfif attributes.width eq "150">
				<cfset script = "editOrgUnit('#unit#','#URL.OrgUnit#','base')">  
			    <cfset style  = "cursor: pointer;"> 			
			<cfelse>
				<cfset script = "javascript:maintainQuick('#attributes.parent#','#attributes.Unit#',this,'#url.tree#')">  
			    <cfset style  = "cursor: pointer;"> 
			</cfif>	
					
			<tr>
				        <td width="100%" align="center" style="#style#;padding:0px">					
						<table width="100%" cellspacing="0" cellpadding="0">
						
						<tr>							 						
																
						 <td  width="14" style="padding-left:3px;padding-right:3px;" align="right">	
							
								<cfif attributes.mode neq "Print">
																	
									<cfif unit neq "">								
									    <cfif attributes.access eq "EDIT" or attributes.access eq "ALL">	
										    <cf_img icon="edit" onclick="editOrgUnit('#unit#','#URL.OrgUnit#','base')" border="0" align="absmiddle">																				
										</cfif>									
									</cfif>
									
								</cfif>
									
								</td>					
								
								
						 <td width="100%" height="21" class="labelmedium" 									
							        style="padding-left:3px;border: 0px solid black"><font size="2">#attributes.hierarchycode#&nbsp;</font>|&nbsp;#attributes.parent#</td>
									
									<td align="center" 
										style="cursor:pointer;padding-top:0px;padding-left:6px;padding-right:4px;">
										<a style="display:block" onClick="#script#" target="_blank" title="Summary"><div class="grid"></div></a>
								    </td>								
								
				         <td height="21" class="labelmedium" 
							        style="padding-left:4px;padding-right:4px;border: 0px solid black;">
									
									 <cfif unit neq "">	
									 
										<img src="#SESSION.root#/Images/arrow_up2.gif" 
										style="cursor:pointer"
										onClick="tree('#attributes.parent#','#attributes.nme#')"
										title="set as top level" 
										align="absmiddle">	
	
									 </cfif>
									 	
								</td>		
								
							</tr>
						
							<tr><td colspan="4" class="line"><td></tr>
							
							<tr style="background:url(#SESSION.root#/system/organization/tree/images/color#attributes.level#.jpg)" >
							
							<td id="selectnode" onMouseOver="hlnode(this,'hl')"	onMouseOut="hlnode(this,'normal')" 
								height="40" class="titleTree" colspan="4" align="center" onClick="#script#">
								<table><tr><td class="labelmedium" align="center" style="min-width:170px">
								
								
								<cfif len(attributes.nme) gt "20">
								<a title="#attributes.nme#">#left(attributes.nme,20)#..</a>
								<cfelse>
								#attributes.nme# 
								</cfif>	
								</td>
								<td>
								<cfparam name="labelme" default="">
								#labelme#
								</td>
								</tr>
								</table>
																 	
								</td>
							</tr>							
							<tr><td colspan="3"><td></tr>
							
						</table>
						
					</td>
			</tr>
						
			<tr><td style="padding-left:1px;padding-right:1px;padding-bottom:1px;background-color:##ffffff;">										
				<cfparam name="url.mode" default="chart">				
				<cfinclude template="OrgTreeAssignment.cfm">															
			</td></tr>		
					
				
		</cfif>		

	</table>
	</div>
</td>

</cfoutput>