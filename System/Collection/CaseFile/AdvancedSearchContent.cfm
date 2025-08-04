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


<cfquery name = "qClass" 
  datasource= "AppsCaseFile"  
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT   Distinct EL.*  
	FROM     Ref_ElementClass EL INNER JOIN Claim C ON 
		     C.ClaimType = EL.ClaimType
	WHERE    
	<!--- 
		Note: Further enhancement will be to know which elements are associated to which claim types without the dependency of
		the table Ref_ClaimTypeTab
		EL.ClaimType = '#url.casetype#'	
		--->
      C.Mission    = '#url.mission#'
	AND EXISTS
	(
		SELECT 'X'
		FROM ClaimElement CE INNER JOIN Element E ON CE.ElementId = E.ElementId
		WHERE CE.ClaimId = C.ClaimId
		AND E.ElementClass = EL.Code
	)
	ORDER BY EL.ListingOrder
</cfquery>

<cfoutput>

<table width="100%" name="t_title">
   	
	<tr id="critlocate">
	
		<td colspan="2">
		
			<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center">
				<tr>
								
				<td align="center">
				
					<table width="100%" class="t_header" bgcolor="FFFFFF" cellspacing="0" cellpadding="0" border="0" width="100%" align="center">
												 						
						<cfloop query = "qClass">
						
							    <tr><td colspan="3" style="border-top:1px dotted e4e4e4"></td></tr>
					
								<tr>
								
									<td width="50" style="padding:3px;padding-right:15px"">
								
									    <cfif code eq "Person">
										
											<img align="absmiddle" 
										    	src="#SESSION.root#/images/logos/staffing/staffing.png" 
												width="23" height="23">
										
										<cfelse>
										
											<img align="absmiddle" 
											    src="#SESSION.root#/images/logos/insurance/#Code#.png" 
												width="23" height="23">					
										
										</cfif>
										
									</td>
								
									<td align="left" width="10%">
										<font face="verdana" size="2">#Description#</font>
									</td>
										
									<td width="85%" id="dcriteria_#code#">
									
									    <cfdiv id="dcriteria_#code#" 
										  bind="url:CaseFile/AdvancedSearchCriteria.cfm?searchid=#url.searchid#&ds=AppsCaseFile&db=CaseFile&Table=Ref_TopicElementClass&mode=new&where= and elementClass = |#Code#|&layout=1&class=#code#">
									
									</td>
									
								</tr>
													
						</cfloop>	
																				
					</table>
				</td>
			</tr>

		</table>
		
</td>
</tr>
</table>		

</cfoutput>
