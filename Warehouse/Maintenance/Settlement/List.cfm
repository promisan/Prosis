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
<cfparam name="url.code"    default="">
<cfparam name="url.mission" default="">
<cfparam name="url.action"  default="">

<cfquery name="List" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *, 
	       (SELECT Description 
		    FROM   Accounting.dbo.Ref_Account 
			WHERE  GLAccount = D.GLAccount) as Description
	FROM   Ref_SettlementMission D
	WHERE  Code = '#url.Code#'
</cfquery>

<cfquery name="getMission" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ParameterMission
	WHERE  Mission NOT IN
		( 
		  SELECT Mission
		  FROM   Ref_SettlementMission
	      WHERE  Code = '#url.Code#'
		)
</cfquery>

<cfform  method="POST" name="settlement_#code#" id="settlement_#code#" onsubmit="return false">
	
<table width="80%" class="navigation_table">					
		
		<tr><td colspan="6" height="10"></td></tr>
		
		<cfoutput>
		
		 <TR height="18" class="line labelmedium">
			   <td><cf_tl id="Mission"></td>
			   <td width="40%" class="labelit"><cf_tl id="GLAccount"></td>
			   <td><cf_tl id="Order"></td>		
   			   <td><cf_tl id="Officer"></td>		
   			   <td><cf_tl id="Created"></td>		
			   <td align="right" style="padding-right:4px">
			   		<cfoutput>
						<cfif url.action neq 'new'>
							<a title="Link new mission" href="javascript:_cf_loadingtexthtml='';addMission('#url.code#')"><cf_tl id="Add"></a>
						</cfif>
					</cfoutput>
			   </td>  
		  </TR>
				
		
		<cfif url.action eq "new">
												
			<input type="hidden" name="action" value="new">
			<input type="hidden" name="code"   value="#Code#">
			
				<TR>
				   <td height="35px">
				   	   <select name="Mission" class="regularxl">
					   	   <cfloop query="getMission">
						   		<option value="#Mission#">#Mission#</option>
						   </cfloop>
					   </select>
		           </td>
				   <td>
				   
				   		<cfinput type="Text" 
							name="GLAccount" 
							message="Please enter GLAccount" 
							required="No" 							 
							maxlength="20" 
							class="regularxl" 
							style="width:60px;">
							
				   </td>				  
				   <td>
					    <cf_tl id="You must enter a listing order" var ="1" class="Message">
						<cfinput type="Text" 
						   	value="" 
							name="ListingOrder" 
							message="#lt_text#" 
							required="Yes" 							 
							maxlength="2" 
							class="regularxl" style="text-align:center;width:25px;">
				   </td>		
				   <td colspan="3" align="right">
   					    <cf_tl id="Save" var ="1">
					   <input type="button" 
					        value="#lt_text#" 
							class="button10g" 
							onclick="saveMission('#Code#')"
							style="width:80px;height:25px">
				   </td>
			    </TR>					
				
		</cfif>
		
		<cfloop query="List">					
																								
			<cfif url.code eq List.Code and url.mission eq List.Mission>		
								
				<input type="hidden" name="action" value="update">
				<input type="hidden" name="code"   value="#Code#">			
				<input type="hidden" name="missionOld" value="#Mission#">
						
				<TR>
				   <td height="35px">
				   	  <select name="Mission" class="regularxl">
					  	   <option value="#List.Mission#" selected>#List.Mission#</option>
					   	   <cfloop query="getMission">
						   		<option value="#Mission#">#Mission#</option>
						   </cfloop>
					   </select>
		           </td>
				   <td>
				   		<cfinput type="Text" 
							name="GLAccount" 
							value="#GLAccount#"
							message="Please enter GLAccount" 
							required="No" 							 
							maxlength="20" 
							class="regularxl" 
							style="width:60px;">
				   </td>				  
				   <td>
					    <cf_tl id="You must enter a listing order" var ="1" class="Message">						
						<cfinput type="Text" 
						   	value="#ListingOrder#" 
							name="ListingOrder" 
							message="#lt_text#" 
							required="Yes" 							 
							maxlength="2" 
							class="regularxl" style="width:25px;text-align:center">
				   </td>
				   <td colspan="3" align="right">
   					   <cf_tl id="Save" var ="1">
					   <input type="button" 
					        value="#lt_text#" 
							class="button10g" 
							onclick="saveMission('#Code#');"
							style="width:80px;height:25px">
				   </td>
			    </TR>							
				
				<tr><td colspan="6" class="line"></td></tr>
													
			<cfelse>								
						
				<TR class="navigation_row line labelmedium" bgcolor="ffffff">
				   <td style="padding-left:4px">&nbsp;#Mission#</td>
				   <td height="20"><cfif GLAccount eq ""><font color="808080">[Accounts Receivable]</font><cfelse>#GLAccount# #Description#</cfif></td>
   				   <td height="20">#ListingOrder#</td>
				   <td>#OfficerFirstName# #OfficerLastName#</td>
				   <td>#dateFormat(Created,"dd/mm/yyyy")#</td>
				   <td align="right" style="padding-right:4px">
					  <cf_img icon="edit" navigation="Yes" onclick="_cf_loadingtexthtml='';ptoken.navigate('List.cfm?code=#URL.code#&mission=#mission#','#url.code#_list')">
				   </td>					
				 </TR>					 
										
			</cfif>
						
		</cfloop>
		</cfoutput>
		
		<tr><td colspan="6" height="10"></td></tr>
																
</table>	

</cfform>

<cfset ajaxonload("doHighlight")>

