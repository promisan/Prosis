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

<cf_AssignId>

<cfquery name = "Collection"  
  datasource="AppsSystem" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
     SELECT * 
	 FROM   Collection 
	 WHERE  CollectionId = '#url.id#'	
</cfquery>

<cfquery name = "InsertSearch"  
  datasource="AppsSystem" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    INSERT INTO CollectionLog
	           (CollectionId,
			    SearchId,
			    OfficerUserId,
			    OfficerLastName,
			    OfficerFirstName)
    VALUES     ('#url.id#',
	            '#rowguid#',
	            '#SESSION.login#',
			    '#SESSION.last#',
			    '#SESSION.first#')
</cfquery>


  
<cfoutput>

<table width="100%" name="t_title">

    <tr>
	
		<td align="left" height="25" style="padding-left:30px">
		   <a href="javascript:searchmode('')"><font face="Verdana" size="2" color="0080C0"><cf_tl id="Return to Basic search"></a>	
		</td>	
												
		<td align="right" valign="top" style="padding-right:40px">
					
				<img src="#SESSION.root#/images/up6.png" 
				    id="critlocate_col"	
					onclick="showcrit('critlocate')" 
					class="regular"
					style="border: 0px solid Silver;cursor:pointer"
					class="regular">
					
				<img src="#SESSION.root#/images/down6.png" 		    
					id="critlocate_exp"
					onclick="showcrit('critlocate')" 
					class="hide"
					style="border: 0px solid Silver;cursor:pointer"
					class="hide">
																
		</td>				
									
	</tr>	
	
	<tr id="critlocate">
	
		<td colspan="2">
		
			<table width="96%" cellpadding="0" cellspacing="0" border="0" align="center">
				<tr>
								
				<td align="center" style="padding-left:20px">
				
					<table width="100%" class="t_header" bgcolor="FFFFFF" cellspacing="0" cellpadding="0" border="0" width="100%" align="center">
										
					    <tr><td colspan="3" style="border-top:1px dotted d4d4d4"></td></tr>
						  
					    <tr><td style="padding:3px;padding-right:17px" width="50">
						
							<cf_space spaces="10">					
						
							<img align="absmiddle" 
							   	src="#SESSION.root#/images/logos/system/Location.png" 
								width="23" height="23">
						
						</td>
												
						<td width="99%">
						
							<table width="100%">
							
							<tr>
							 <td width="23%" align="left">  <font face="verdana" size="2"> <cf_tl id="Case/CaseFile"> </font>  </td>
							 <td width="17%" align="left">
																					
								<cfquery name = "CaseFileType"  
								  datasource="AppsCaseFile" 
								  username="#SESSION.login#" 
								  password="#SESSION.dbpw#">
								    SELECT   DISTINCT R.Code, R.Description
								    FROM     Claim C INNER JOIN
								             Ref_ClaimType R ON C.ClaimType = R.Code 
								    WHERE    C.Mission = '#Collection.Mission#'
								    ORDER BY R.Code
								</cfquery>	
	
								<select name="CaseType" id="CaseType" 
								   style="width:190;font:12px"
								   onchange="ColdFusion.navigate('CaseFile/AdvancedSearchContent.cfm?searchid=#rowguid#&mission=#collection.mission#&casetype='+this.value,'searchadvanced');ColdFusion.navigate('CaseFile/AdvancedSearchCaseClass.cfm?mission=#collection.mission#&casetype='+this.value,'boxcasetype')">
								    <option value="Any"><cf_tl id="Any"></option>
									<cfloop query="CaseFileType">
									  <option value="#Code#">#Description#</option>
									</cfloop>
								</select>
								
							</td>
							
							<cfset url.mission  = collection.mission>	
							<cfset url.casetype = "Any">	
							
							<td id="boxcasetype" width="60%" align="left">
								<cfinclude template="AdvancedSearchCaseClass.cfm">					
							</td>
							
							</tr>
							
							</table>
						
						</td>
						
						</tr>
						
						<tr><td colspan="3" id="searchadvanced">						
							
							<cfset url.searchid = rowguid> 					
							<cfinclude template="AdvancedSearchContent.cfm">
						
						</td></tr>
											
						
						<tr><td colspan="3" style="border-top:1px dotted d4d4d4"></td></tr>
													
							<tr class="regular">
												
							  <td height="30" align="center" colspan="3">
							  
								  <table cellspacing="0" cellpadding="0" class="formpadding">
																	
									<cfoutput>									   					  					   
										<tr>
											<td>
											<cf_tl id="Search" var="1">
											<input type="button" 
											  name="search" 
											  id="search"
											  value="#lt_text#" 
											  class="button10s" 
											  style="width: 130px; height: 22px; font-size: 12px;" 
											  onclick = "do_search('#rowguid#','','')">						
											</td>						
										</tr>
									</cfoutput>
											
								  </table>
										
							  </td>			
							  
							</tr>  			
														
					</table>
				</td>
			</tr>

		</table>
		
</td>
</tr>
</table>		

</cfoutput>
