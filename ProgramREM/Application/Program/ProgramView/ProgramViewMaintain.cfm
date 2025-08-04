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

    <!--- main view for the standard listing --->

	<table width="99%" height="100%" align="center">
		  
	  <tr class="line">
	    <td style="height:51px;padding-left:5px;font-size:29px;font-weight:200" class="labellarge">
		
			<cfoutput>
							
					<cfif url.id1 eq "Tree">
						  #url.mission#
					<cfelse>
										
						<cfif len(Root.OrgUnitName) gt 40>
					     #Left(Root.OrgUnitName, 40)#...
					    <cfelse>
					     #Root.OrgUnitName#
					    </cfif>
						<font size="2">
						(#Root.OrgUnitCode#)
						</font>
						
					</cfif>	
							
			</cfoutput>
		
		</td>
			
		<td align="right" style="padding-right:10px">	
		
			<table cellspacing="0" cellpadding="0">
			  <tr>
			    <td style="padding-right:10px">
				
				<cfoutput query="DisplayPeriod">
					<font face="Calibri" size="3">#Description#
				</cfoutput>
				
				</td>
				
				<td style="padding-right:4px">
				
				<input type="hidden" name="page" id="page" value="1">
				
				<cfoutput>
				 
				 <select id="layout" size="1" class="regularxl"
		 			onChange="Prosis.busy('yes');reloadForm(page.value,'#url.view#',this.value,'#URL.Global#')">
					 <option value="Extended" <cfif URL.Lay eq "Extended">selected</cfif>><cf_tl id="Extended">
				     <option value="Listing"   <cfif URL.Lay eq "Listing">selected</cfif>><cf_tl id="Listing">					
			 	 </select>
				 
				</cfoutput>
			
				<!---
						
				  <!--- drop down to select only a number of record per page using a tag in tools --->	
		          <cf_PageCountN count="#counted#">
				  <cfif pages eq "1">
					  <input type="hidden" name="page" value="1">
				  <cfelse>
		    	      <select name="page" size="1" style="background: #ffffff; color: black;"
		        	  onChange="javascript:reloadForm(this.value,view.value,layout.value,<cfoutput>'#URL.Global#'</cfoutput>)">
					   <cfloop index="Item" from="1" to="#pages#" step="1">
		        	     <cfoutput><option value="#Item#"<cfif #URL.page# eq "#Item#">selected</cfif>><cf_tl id="Page"> #Item# <cf_tl id="of"> #pages#</option></cfoutput>
				       </cfloop>	 
		               </SELECT> 
				  </cfif>
				  
				--->
			  
			    </td>
			  </tr>
		  </table>
			
	    </TD>
		
	  </tr>	  
	  
	<cfif url.lay eq "Listing">
	    <cfset cl = "hide">
	<cfelse>
		<cfset cl = "regular">
	</cfif>  
	  
	<cfif url.lay eq "Listing">
	
	<cfelse>  
	
		<tr class="line">  
		  <td colspan="2" valign="top" style="padding:10px;">
		 
			 <script> 
			  
				function search() {
					 			 
					 if (window.event.keyCode == "13")
						{	document.getElementById("findlocate").click() }		
								
				    }
			
			 </script>
		  
			<table height="100%">			
			
			<tr class="<cfoutput>#cl#</cfoutput>" id="menudetails">
			  
			   <td>&nbsp;</td>
			  
			   <td width="130">
			   
					 <table width="100%" style="border: 1px solid Silver;">
					 <tr><td height="29">
					 				 
					    <cfparam name="url.find" default="">
						
						<input type = "text" 
						   name     = "find" 
						   id       = "find"
						   style    = "border:0px"
						   class    = "regularxl" 				   
						   onKeyUp  = "search()"
						   value    = "<cfoutput>#url.find#</cfoutput>">				   
						 </td>
						   
						  <cfoutput>
						
						  <td style="padding-left:1px;padding-right:1px;border-left: 1px solid Silver;" align="center">
						  
						    <img src="#SESSION.root#/Images/search.png" 
							     alt="" 
								 name="findlocate" id="findlocate"							 
								 border="0" 
								 style="cursor:pointer;height:30px;width:31px"
								 align="absmiddle"
								 onclick="Prosis.busy('yes');reloadForm(page.value,'#url.view#',layout.value,'1')">
							
						  </cfoutput>
						
						  </td>
					  </tr>
					  </table>
					
				  </td>				
			 				
				  <td width="30" style="padding-left:3px">
				  
			      <cfoutput>
				  	
				  <cfif getAdministrator('*') eq "1" AND (ManagerAccess is "EDIT" OR ManagerAccess is "ALL")>
				  
			   	    <cf_tl id="Add" var="1">
							
				    <cfif Parameter.EnableGlobalProgram neq "1">		
					      
				     	  <input type="button" value="#lt_text# #Parameter.TextLevel0#" style="font-size:12px;width:120;height:32" class="button10g" onClick="AddProgram('#URL.Mission#','#URL.Period#','#Org.OrgUnit#','','','add')"> 
			            
					 <cfelse>
					 
				    	  <input type="button" value="#lt_text ##Parameter.TextLevel0#" style="font-size:12px;width:130;height:32" class="button10g" onClick="AddProgram('#URL.Mission#','#URL.Period#','#Org.OrgUnit#','','','add')"> 
						  
					 </cfif>	  
					 
				  </cfif>	
				    
				  </td>
			  
			  <td style="padding-left:3px">	
			  <!--- added read as it does not really harm much to enable this --->		  		  
	
			    <CFIF ProgramAccess EQ "ALL" or ProgramAccess eq "EDIT" or ProgramAccess eq "READ">
			  
			  	<cfif url.id1 neq "Tree">
					 <button type="button" class="button10g" style="font-size:12px;height:32;width:120" 
					 onClick="CarryProgram('#URL.Period#','#Org.OrgUnit#','Component')"> 
					 &nbsp;<img src="#SESSION.root#/Images/transfer2.gif" alt="" border="0" align="absmiddle">&nbsp;<cf_tl id="Carry-over">
								
				</cfif>
				
				<input type="button" name="refresh" id="refresh" value="Refresh" class="hide" onClick="Prosis.busy('yes');history.go()">
			  
			  </CFIF>  
			  
			  </cfoutput>
		
			  </td>
			  
			  <td align="right">
			  
			  <table>
			  <tr>
			  
			  <input type="hidden" name="global" value="1"> 
			 	  
			  <cfif url.id1 neq "tree"> 	
			   	  
				  <td style="padding-left:5px;padding-right:4px;cursor:pointer" onClick="Prosis.busy('yes');reloadForm(page.value,'Only',layout.value,<cfoutput>'#URL.Global#'</cfoutput>)">
				  <input type="radio" class="radiol" style="width:16px;height:16px" name="view" value="Only" <cfif URL.View eq "Only">checked</cfif>>
				  </td>
				  <td style="padding-right:4px;cursor:pointer" class="labelmedium" onClick="Prosis.busy('yes');reloadForm(page.value,'Only',layout.value,<cfoutput>'#URL.Global#'</cfoutput>)"><cfif URL.View eq "Only"><u></cfif><cf_tl id="Selected unit"></td>			  
				  <td style="padding-left:4px;padding-right:4px;cursor:pointer" class="cellcontent" onClick="Prosis.busy('yes');reloadForm(page.value,'Prg',layout.value,<cfoutput>'#URL.Global#'</cfoutput>)">
				  <input type="radio" class="radiol" style="width:16px;height:16px" name="view" value="Prg"  <cfif URL.View eq "Prg">checked</cfif>>
				  </td>
				  <td style="padding-right:4px;cursor:pointer" class="labelmedium" onClick="Prosis.busy('yes');reloadForm(page.value,'Prg',layout.value,<cfoutput>'#URL.Global#'</cfoutput>)"><cfif URL.View eq "Prg"><u></cfif><cf_tl id="Entity Scope"></td>			  
				  
			  </cfif>		
			  
			  </tr>
				
			 </table>
				
			 </td>
			   
			 </tr>
			  
			</table>
		  
		 </td>
		
		</tr>
	
	</cfif>
	
	<tr>
	 
	<td colspan="2" height="100%" valign="top">
						
		   <cfif url.lay eq "Listing">			
		   
			    <cfinclude template="ProgramViewListing.cfm">	
				
			<cfelse>		
				
				<cf_divscroll style="padding-right:10px">				
				<cfinclude template="ProgramViewList.cfm">					
				</cf_divscroll>	
				
			</cfif>	
						
	 </td></tr>
	  
	</table>
		
	