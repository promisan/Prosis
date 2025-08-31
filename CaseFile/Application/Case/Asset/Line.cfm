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
<cfinvoke component="Service.Presentation.Presentation"
       method="highlight"
    returnvariable="stylescroll"/>
				
<cfparam name="URL.claimid"   default="">	
<cfparam name="URL.page"      default="1">	
<cfparam name="URL.search"    default="">	

<cfquery name="Claim" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Claim
	WHERE   ClaimId = '#URL.ClaimId#'	
</cfquery>
 
<!--- ------------------------------------------------------------------------------ --->
<!--- check if access to the tabs is granted based on the fly access settings in wf- --->
<!--- ------------------------------------------------------------------------------ --->

<cfinvoke component = "Service.Access"  
    method           = "CaseFileManager" 
	mission          = "#Claim.Mission#" 	   
    returnvariable   = "access">		
	
<cfoutput>
	<cfsavecontent variable="qry">		
	    FROM    Materials.dbo.AssetItem A INNER JOIN 
		        ClaimAsset WO ON A.AssetId = WO.AssetId				
	    WHERE   WO.ClaimId = '#url.claimid#'		
	</cfsavecontent>
</cfoutput>

<cfquery name="Total" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT count(*) as Total 
    #preserveSingleQuotes(qry)#	
</cfquery>

<cf_pagecountN show="33" 
               count="#Total.Total#">
			   
<cfset counted  = total.total>		

<cfquery name="Detail" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TOP #last# A.SerialNo, A.Make, A.Description, A.Model, A.DepreciationYearStart, WO.*				
    #preserveSingleQuotes(qry)#		
	ORDER BY WO.Created DESC
</cfquery>

<cfif Detail.recordcount eq "0" and (access eq "EDIT" or access eq "ALL")>
     <cfparam name="URL.ID2" default="new">
<cfelse>
     <cfparam name="URL.ID2" default="">   
</cfif>
	
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	
	<cfset cols = "11">
			      
	<tr>
	
	    <td style="width:99%" colspan="4" align="center">
			
		<cfform action="../Asset/LineSubmit.cfm?Search=#url.search#&ClaimId=#URL.ClaimId#&ID2=#URL.ID2#" 
			  method="POST" name="lineinert">
			  
	    <table width="99%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
				
	    <TR>
		   
		   <td height="20"></td>
		   <td></td>
		   <td width="12%" class="labelit"><cf_tl id="SerialNo"></td>		
		   <td width="30%" class="labelit"><cf_tl id="Description"></td>		
		   <td width="10%" class="labelit"><cf_tl id="Make"></td>			  
		   <td width="10%" class="labelit"><cf_tl id="Model"></td>  		
		   <td width="8%" class="labelit"><cf_tl id="Year"></td>  	    
		   <td width="20%" class="labelit"><cf_tl id="Memo"></td>			   	  		   		  
		   <td width="10%" class="labelit"><cf_tl id="Officer"></td>	     	
		  
		   <td align="right" width="7%" colspan="2" class="labelit">
	         <cfoutput>
			 
			 <cfif URL.ID2 neq "new">
				 <cfif access eq "EDIT" or access eq "ALL">
			     <A href="javascript:#ajaxLink('../Asset/Line.cfm?ClaimId=#URL.Claimid#&search=#url.search#&ID2=new')#"><font color="0080FF"><cf_tl id="[add]"></font></a>
				 </cfif>
			 </cfif>
			
			 </cfoutput>&nbsp;
		   </td>		  
	    </TR>	
				
		<tr><td colspan="11" class="linedotted"></td></tr>		
		
		<cfif counted gt "0">
		<cfoutput>
			<tr><td height="20" colspan="#cols#">		
				 <cfinclude template="LineNavigation.cfm">
			</td></tr>
		</cfoutput>
		</cfif>
								
		<cfif URL.ID2 eq "new">
		
			<cf_assignid>
			<cfoutput>
			<input type="hidden" name="TransactionId" value="#rowguid#">
			</cfoutput>
			
			<tr><td height="4"></td></tr>
								
			<TR>
			
			<td>
			
			   <cfset link = "#SESSION.root#/CaseFile/application/case/asset/getAsset.cfm?">	
			
			   <cf_tl id="Asset Selection" var="1">
			
			   <cf_selectlookup
			    box          = "assetbox"
				link         = "#link#"
				title        = "#lt_text#"
				icon         = "contract.gif"
				button       = "Yes"
				close        = "Yes"
				
				class        = "asset"
				des1         = "assetid">
				
				<!--- 
				filter1      = "Category"
				filter1value = "#Service.AssetCategory#"
				--->
						
			</td>
			
			<td id="assetbox">&nbsp;
			   <input type="hidden" name="AssetId">
			</td>
			
			<td id="serialno"></td>
			<td id="description"></td>
			<td id="make"></td>
			<td id="model"></td>
			<td id="year"></td>
						
			<td>
								 
				 <cfinput type="Text"
				       name="Memo"					  
				       required="No"
				       visible="Yes"
				       enabled="Yes"				     
				       size="1"
				       maxlength="70"
				       class="regularxl"
				       style="text-align:left;width:100%">
			  		
			</td>
								
			<td width="70"></td>
			
			<cf_tl id="Add" var="1">		
			
			<cfoutput>				
											   
			<td colspan="2" align="right"><input type="submit" style="width:50;" value="#lt_text#" class="button10s">&nbsp;</td>
			
			</cfoutput>
			    
			</TR>	
			
			<tr><td height="4"></td></tr>
			
			<tr><td colspan="11" class="line"></td></tr>
			
														
		</cfif>	
		
		<cfoutput>
		
		<cfset currrow = 0>
		
		<cfloop query="Detail">
		
			<cfset currrow = currrow + 1>
		 
		    <cfif currrow lt last and currrow gte first>					
																												
			<cfif URL.ID2 eq assetid>
											   												
				<tr>				  
				   				  
				   <td>
				   
				      <cfset link = "../Asset/getAsset.cfm?">	
					  
					  <cf_tl id="Asset Selection" var="1">
			
					   <cf_selectlookup
					    box          = "assetbox0"
						link         = "#link#"
						title        = "#lt_text#"
						icon         = "contract.gif"
						button       = "Yes"
						close        = "Yes"
						filter1      = ""
						filter1value = ""
						class        = "asset"
						des1         = "AssetId">
						
						<!--- filter1      = "Category"
						filter1value = "#Service.AssetCategory#" --->
						
				   </td>	
				   
				   <td id="assetbox0">
						<input type="hidden" value="#assetid#" name="AssetId">
					</td>
				   		  
				   <td>
					   <table cellspacing="0" cellpadding="0" style="width:98%">
						   <tr><td style="padding:2px;width:98%;border:1px solid silver" class="labelit">#serialno#</td></tr>
					   </table>
				  </td>
				  
				   <td>
				    <table cellspacing="0" cellpadding="0" style="width:98%">
						   <tr><td id="description" style="padding:2px;width:98%;border:1px solid silver" class="labelit"> #description#</td></tr>
				   </table>
				   </td>
				   <td>
				   <table cellspacing="0" cellpadding="0" style="width:98%">
						   <tr><td id="make" style="padding:2px;width:98%;border:1px solid silver" class="labelit"> #make#</td></tr>
				   </table>
				   </td>
				   
				   <td>
				   <table cellspacing="0" cellpadding="0" style="width:98%">
						   <tr><td id="make" style="padding:2px;width:98%;border:1px solid silver" class="labelit"> #model#</td></tr>
				   </table>
				   </td>
				   
				   <td>
				   <table cellspacing="0" cellpadding="0" style="width:98%">
						   <tr><td id="make" style="padding:2px;width:98%;border:1px solid silver" class="labelit"> #depreciationyearstart#</td></tr>
				   </table>
				   </td>
								
					<td>
					
					 <cfinput type="text" 
					         name="Memo" 
							 size="1" 							 								
							 class="regularxl" 
							 style="width:100%" 
							 MaxLength="70"
							 visible="Yes" 
							 VALUE="#Memo#"
							 enabled="Yes">
					
					</td>	   			  
					
					<td></td>
					
					<td colspan="2" align="right"><input type="submit" style="width:50;" value="Save" class="button10s">&nbsp;</td>
				
			    </TR>	
				
				<tr><td height="4"></td></tr>
								
				<tr>	
				    <td></td>
			   		<td></td>
			        <td colspan="#cols-2#">		
			   
				   		<cf_filelibraryN				    	
							DocumentPath="Insurance"
							SubDirectory="#claimid#" 
							Box="box_0"		
							Filter="Asset_#left(Assetid,8)#"							
							Insert="yes"
							Remove="yes"
							reload="true">		
			  
			        </td>
		        </tr>	
				
				<tr><td height="4"></td></tr>
							
						
			<cfelse>
						   									
				<TR id="agreementline#currentrow#">		   
				
					<cfif access eq "EDIT" or access eq "ALL">   
						<cfset link = "#ajaxLink('../Asset/Line.cfm?claimid=#URL.claimid#&ID2=#assetid#&search=#url.search#')#">
					<cfelse>
						<cfset link = "">
					</cfif>
				   
				   <td width="2"></td>
				   <td width="30" height="20" style="font-size: 8px;" onClick="#link#" class="labelit">#currentrow#.&nbsp;</td>		
			       <td class="labelit"><a href="javascript:AssetDialog('#assetid#')">#serialno#</a></td>
				   <td class="labelit"><a href="javascript:AssetDialog('#assetid#')">#description#</a></td>
				   <td onclick="#link#" class="labelit">#make#</td>	  
				   <td onclick="#link#" class="labelit">#model#</td>
				   <td onclick="#link#" class="labelit">#depreciationyearstart#</td>
				   <td onclick="#link#" class="labelit">#Memo#</td>				  				  
				   <td onclick="#link#" class="labelit">#OfficerFirstName# #OfficerLastName#</td>
				 
				   <td align="center">	
				   
				   		<cf_space spaces="4">	
				   				   								
				   		<cfif access eq "EDIT" or access eq "ALL">   
					
						 <img src="#Client.VirtualDir#/images/edit.gif"
						    alt="edit"
						    onclick="#ajaxLink('../Asset/Line.cfm?ClaimId=#URL.claimid#&ID2=#assetid#&search=#url.search#')#"
							height="11" width="11"
							style="cursor:pointer"
						    border="0"
						    align="absmiddle">		
							
						</cfif>				 
									 
				   </td>
				   
				   <td align="center" id="agreementdelete#currentrow#">
				   						
				   		<cfif access eq "ALL"> 
						
						<cf_space spaces="4">	
					
						<img src="#Client.VirtualDir#/images/delete5.gif" 
						  name="img2_#currentrow#"
						  height="11" width="11"
						  style="cursor:pointer"
						  onclick="#ajaxLink('../Asset/LinePurge.cfm?ClaimId=#URL.claimid#&ID2=#assetid#&search=#url.search#')#"
					      onMouseOver="document.img2_#currentrow#.src='#Client.VirtualDir#/Images/delete5.gif'" 
	    			      onMouseOut="document.img2_#currentrow#.src='#Client.VirtualDir#/Images/delete5.gif'"
					      alt="Remove" 
						  align="absmiddle" 
						  border="0">
						  
						 </cfif> 
							 
				  </td>				  
				 				   
			    </TR>	
				
			</cfif>
									
			</cfif>	
			
			<tr id="asset0#currentrow#" class="<cfif client.browser neq 'explorer'>hide</cfif>">
			<td class="line" colspan="#cols#"></td></tr>
								
		</cfloop>		
		
		<tr><td height="24" colspan="#cols#">
			 <cfinclude template="LineNavigation.cfm">
		</td></tr>	
		
		</cfoutput>			
														
		</table>
		
		</cfform>		
		
		</td>
		</tr>		
					
	</table>	