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
<cfquery name="get" 
	 datasource="appsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT    *
		FROM      OrganizationObject INNER JOIN
		          Vacancy.dbo.[Document] ON OrganizationObject.ObjectKeyValue1 = Vacancy.dbo.[Document].DocumentNo INNER JOIN
		          Applicant.dbo.FunctionOrganization ON Vacancy.dbo.[Document].DocumentNo = Applicant.dbo.FunctionOrganization.DocumentNo
		WHERE     OrganizationObject.ObjectId = '#Object.ObjectId#'		
</cfquery>


<cfif get.recordcount eq "1"> 
	
  <table style="width:100%">
	
	<tr><td style="height:4px"></td></tr>			
	<tr><td colspan="3" align="center" style="height:40px;font-size:30px">Terms or Reference</td></tr>		
	<tr><td style="height:10px;border-bottom:1px solid silver" colspan="3"></td></tr>	
	<tr><td style="height:10px"></td></tr>
	
	<cfoutput>
	
	<tr>
	<td style="font-size:20px">Function:</td>
	<td colspan="2" style="font-size:20px">#get.FunctionalTitle# #get.PostGrade#</td>
	</tr>
	<tr>
	<td style="font-size:20px">Unit:</td>
	<td colspan="2" style="font-size:20px">#get.Mission# / #get.OrganizationUnit#</td>
	</tr>
	
	</cfoutput>
		
	<tr><td style="height:10px;border-bottom:1px solid silver" colspan="3"></td></tr>
	
	<tr><td style="height:10px"></td></tr>	  

	<!--- we initially populate the questionaire if it has already a value for the questionId --->
	
	<cfquery name="getCurrent" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		  SELECT  *
		  FROM    OrganizationObjectQuestion 
		  WHERE   ObjectId   = '#Object.ObjectId#'	 		  	
	</cfquery>
		
	<cfset selactioncode = getCurrent.actionCode>
	
	<cfquery name="Questionaire" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    SELECT     D.DocumentId, 
		           D.DocumentCode, 
				   D.DocumentDescription,
				   A.ActionCode
	    FROM       Ref_EntityActionDocument A INNER JOIN
	               Ref_EntityDocument D ON A.DocumentId = D.DocumentId
	    WHERE      A.ActionCode = '#selactioncode#' AND D.DocumentType = 'Question'
		<!--- enabled for this workflow --->
		AND        D.DocumentId IN (SELECT DocumentId
		                           FROM   Ref_EntityActionPublishDocument 
								   WHERE  ActionPublishNo = '#Object.ActionPublishNo#' 
								   AND    ActionCode = '#selactioncode#'
								   AND    Operational = 1)
	    ORDER BY   D.DocumentOrder 
	</cfquery>	

	<cfoutput query="Questionaire">		
	
		<cfquery name="Content" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    	SELECT     *,
			
			          (SELECT QuestionScore 
					   FROM   OrganizationObjectQuestion 
					   WHERE  ObjectId   = '#Object.ObjectId#'
					   AND    ActionCode = '#selactionCode#' 
					   AND    QuestionId = P.QuestionId) as Score,
					   
					  (SELECT QuestionMemo 
					   FROM   OrganizationObjectQuestion 
					   WHERE  ObjectId   = '#Object.ObjectId#'
					   AND    ActionCode = '#selactionCode#' 
					   AND    QuestionId = P.QuestionId) as Memo
					
		    FROM       Ref_EntityDocumentQuestion P
		    WHERE      DocumentId = '#documentid#'	
		    ORDER BY   ListingOrder
	    </cfquery>	
		
		<cfif content.recordcount gte "1">
			
			<tr><td height="4"></td></tr>
			<tr class="line">
			<td colspan="3" style="padding:3px;font-weight:bold;font-size:24px;height:44px" class="labelmedium">
			#DocumentDescription#</td>
			</tr>		
				
		</cfif>
				    						
			<cfloop query="content">				
					
			        <tr>       
				    <td class="labelmedium" style="padding-top:2px;height:35px;font-size: 15px">#currentrow#.</td>
					<td class="labelmedium" style="cursor:pointer;font-size:17px;">#QuestionLabel#</td>											
						
					<td align="right" valign="top" style="padding-top:5px;height:35px;font-size: 18px;" class="labelmedium">
					
						<table>
						<tr><td style="height:30px">
					
								<table>
								<tr>	
							
								<cfif InputMode eq "YesNo">						
															
										<cfswitch expression="#score#">
										
											<td align="right" style="padding-left:3px;font-size: 14px" class="labelmedium">
											<cfcase value="9">No</cfcase>
											<cfcase value="1">Yes</cfcase>
											</td>
										
										</cfswitch>									
															
								<cfelseif InputMode eq "YesNoNA">
														
										<cfswitch expression="#score#">
										
											<td align="right" style="padding-left:3px;font-size: 14px;" class="labelmedium">
											 <cfcase value="9"><cf_tl id="No"></cfcase>
											 <cfcase value="1"><cf_tl id="Yes"></cfcase>
											 <cfcase value="0"><cf_tl id="N/A"></cfcase>
											</td>
										
										</cfswitch>
															
								<cfelseif InputMode eq "YesNoPA">
																				
										<cfswitch expression="#score#">
										
											<td align="right" style="padding-left:3px;font-size:14px;" class="labelmedium">
											<cfcase value="9"><cf_tl id="No"></cfcase>
											<cfcase value="1"><cf_tl id="Yes"></cfcase>
											<cfcase value="5"><cf_tl id="Partly"></cfcase>
											</td>
										
										</cfswitch>							
											
												
								<cfelse>
								
									<cfset arr = listToArray(inputmodestringlist)>	
																									
										<cfloop index="itm" from="1" to="#inputmode#">					    
												
											<td align="right" style="padding-left:3px;font-size:14px" class="labelmedium">
											<cfif score eq itm><cfif arr[itm] neq "">#arr[itm]#<cfelse>#itm#</cfif></cfif>																							
											</td>
															
										
										</cfloop>
																						
								</cfif>
										
								</tr>
								
								</table>
								
							</td>
							</tr>	
							
							</table>
					
					</td>								
					</tr>
								
					<cfif EnableInputMemo gte "1">
					
						<tr>
						    <td></td>
			                <td class="labelmedium" colspan="2" style="padding-right:10px;padding-top:2px;padding-bottom:2px">#Memo#</td>
						</tr>
					
					</cfif>
					
					<cfif find("Qualification",QuestionLabel)>
					
					   <cfquery name="Document" 
						 datasource="appsSelection" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
								SELECT *
								FROM FunctionOrganizationNotes N, Ref_TextArea R
								WHERE FunctionId = '#get.FunctionId#'
								AND N.TextAreaCode = R.Code
								ORDER BY ListingOrder			
					  </cfquery>
					  
					   <cfloop query="document">		
				 
						 <tr><td></td><td class="labelmedium" colspan="2" style="font-size:16px"><b>#Description#</td></tr>
						 <tr><td></td><td class="labelmedium" colspan="2" style="padding-bottom:10px">#ProfileNotes#</td></tr>	
						  	 					
						</cfloop>						
					
					</cfif> 				
							
					<cfif currentrow neq recordcount>	
					   		
				        <tr class="line"><td colspan="3" height="1"></td></tr>	
						 <tr><td style="height:4px"></td></tr>				
					</cfif>
				
			</cfloop>	
			
					
		</cfoutput>	
		
	
  </table>	
	 
</cfif>	 

	