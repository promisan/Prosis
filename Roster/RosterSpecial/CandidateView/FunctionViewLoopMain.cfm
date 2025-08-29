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
<table width="100%" height="100%" border="0" align="center">
			
		<tr><td valign="top" height="100%">
		               
		<table width="98%" height="100%" border="0" align="center">					
			  
			<tr style="height:40px">
			<td valign="top">	
					  
			<table width="100%" border="0">
			
			    <tr class="line">
				<td>
				  
				<table width="100%" border="0" align="center">
				
					<cfoutput>	
					
					<tr class="labelmedium2 fixlengthlist"><td><cf_tl id="Edition">:</td>
					    <td>#Function.EditionDescription#</td>
						<td><cf_tl id="Status">:</td>
					    <td><cfif Function.SubmissionStatus eq "3">Locked<cfelse>In Process</cfif></td>						
					</tr>						
					<tr class="labelmedium2 fixlengthlist">	
						<td><cf_tl id="Reference">:</td>
					    <td>#Function.ReferenceNo#</td>								
						<td><cf_tl id="Period">:</td>
					    <td>#dateformat(Function.DateEffective,client.dateformatshow)# - #dateFormat(Function.DateExpiration, client.dateformatshow)#						
						</td>		
					</tr>										
					<cfif function.mission neq "">
						<tr class="labelmedium2 fixlengthlist">
					    <td><cf_tl id="Entity">:</td>
					    <td style="padding-left:0px">
							<table>
								<tr class="labelmedium2">
								
								  <td>#Function.Mission#</td>
								  
								  <cfif function.LocationCode neq "">
								  
								  	<cfquery name="Location" 
										datasource="AppsEmployee" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										SELECT *
										FROM  Location D
										WHERE Mission  = '#Function.Mission#'
										AND   LocationCode = '#Function.LocationCode#'
									</cfquery>
									
									<td style="padding-left:4px">#Location.LocationName#</td>
								  								  
								  </cfif>
								
								</tr>
							</table>
						</td>
						</tr>						
					</cfif>									
					<tr class="labelmedium2 fixlengthlist">					
						<td><cf_tl id="Job Title">:</td>
						<td>
						
							#Function.GradeDeployment# 
							<cfif Function.AnnouncementTitle neq "">#Function.AnnouncementTitle#<cfelse>#Function.FunctionDescription#</cfif> 
							
							<cfif AccessRoster eq "EDIT" or AccessRoster eq "ALL">
												
							     <cfif Check.count lt "1" and Function.PointerUpload neq "1"> <!--- loaded buckets can not be removed !!! --->
							     &nbsp;<a href="javascript:purge()" title="Remove this bucket"><font color="FF0000">(Remove)</font></a>						    
							     </cfif> 
							
							</cfif>
							
							<cfif Function.FunctionRoster eq "0" and Function.ReferenceNo neq "Direct">
								<img src="#SESSION.root#/Images/caution.gif" alt="" border="0">
								<font size="1" color="FF0000"><br>
								level/title not set as a roster function.
							</cfif>					
						
						</td>			
						<td><cf_tl id="Owner">:</td>
					    <td>#Function.OwnerDescription#</td>						
					   
					</tr>							
					  
					<tr class="labelmedium2">			
					   					   
						<cfif Function.DocumentNo neq "">
															
								<td class="fixlengthlist" style="padding-left:2px"><cf_tl id="Recruitment Request">:</td>
								
							    <td colspan="3">
								
								<table style="width:100%">
								
								<tr><td class="fixlengthlist">
								<cfoutput>
									<a href="javascript:showdocument('#Function.DocumentNo#')">#Function.DocumentNo#</a>
								</cfoutput>  		
																								
								<cfquery name="Doc" 
								datasource="AppsVacancy" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								SELECT *
								FROM  Document D
								WHERE DocumentNo = '#Function.DocumentNo#'
								</cfquery>
															
							    <cfoutput>#Doc.Mission# - #Doc.OrganizationUnit#</cfoutput>
								
								</td></tr>
																	
								
								<!--- Query returning search results --->
								<cfquery name="Person"
								datasource="AppsVacancy" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								    SELECT *, FirstName+' '+LastName as Name
									FROM   DocumentCandidate
									WHERE  DocumentNo IN (SELECT DocumentNo FROM Document WHERE FunctionId = '#Function.FunctionId#')
									AND    Status IN ('3','2','2s')
									ORDER BY Status DESC
							    </cfquery>
							
								<cfif Person.name neq "">
								
								
																	
								<TR class="navigation_row_child">
									<td>
									
									<table width="99%" align="center">
										   
										<tr><td>
										
											<table class="formspacing">
											
											<cfset c = 0>
											<cfset cnt = 1>
																	
												<cfloop query="Person">
													<cfif c eq "6">
													    <cfset c = 0>
														<tr class="fixlengthlist">
													</cfif>
												    <cfif Name eq ""><td width="25%"><font color="gray">[<cf_tl id="no candidates">]</td>
													
													<cfelse>
													
													     <cfif status eq "2s">
															<td bgcolor="ffffaf" onclick="javascript:showdocumentcandidate('#DocumentNo#','#PersonNo#','0')" class="fixlength" 
															    style="cursor:pointer;height:20px;padding-left:12px;padding-right:12px;border-radius:10px;border:1px solid gray">	
																#cnt#. #Name#		 																																																
													    <cfelseif status eq "2">
															<td bgcolor="ffffef" class="fixlength" 
															    style="height:20px;padding-left:12px;padding-right:12px;border-radius:10px;border:1px solid gray">	
																#cnt#. #Name#										 												
														<cfelseif status eq "3">
															<td bgcolor="80FF80" onclick="javascript:showdocumentcandidate('#DocumentNo#','#PersonNo#','0')" class="fixlength" 
															  style="height:20px;padding-left:12px;padding-right:12px;border-radius:10px;border:1px solid gray">	
																#cnt#. #Name#	
														<cfelseif status eq "9">	
														    <td bgcolor="FF8080" class="fixlength" style="height:20px;padding-left:12px;padding-right:12px;border-radius:10px;border:1px solid gray;text-decoration: line-through;color: white;border-radius:10px">#cnt#. #Name#"</TD>		
														<cfelse>
															<td bgcolor="f4f4f4" class="fixlength" style="height:20px;padding-left:12px;padding-right:12px;border-radius:10px;border:1px solid gray">																																										   
																#cnt#. #Name#												
															</TD>	
														</cfif>								
													 	</td>
														
																								
													</cfif>
													<cfset c =  c + 1>
													<cfset cnt = cnt + 1>
											    </cfloop>
												
												</tr>
																
											</table>
											
										</td></tr>
										</table>
									</td>
								</tr>
																
								
								</cfif>							
															
								</table>
								
								</td>
																						
						<cfelse>													
								
								<td><cf_tl id="Recruitment Request">:</td>
								<td>N/A</td>								
						
						</cfif>			
							  					   
					   				
					</tr>		
					
									   					   
					<cfif Function.Memo neq "">
						
						<tr class="labelmedium2  fixlengthlist">																	
							<td><cf_tl id="Memo">:</td>
						    <td colspan="3">#Function.Memo#</td>				 					   					   				
						</tr>																				
						
					</cfif>	
					
					
					</cfoutput>
					
					<cfif Function.PointerUpload neq "1">
					
						<cfif Function.FunctionRoster eq "0" 
							AND Function.ReferenceNo neq "Direct"
							AND (accessRoster eq "EDIT" OR accessRoster eq "ALL")>
							
							    <cfquery name="FunctionNew" 
								 datasource="AppsSelection" 
								 username="#SESSION.login#" 
								 password="#SESSION.dbpw#">
								 SELECT   *
								 FROM     FunctionTitle F, FunctionTitleGrade G
								 WHERE    OccupationalGroup = '#Function.OccupationalGroup#'
								 AND      F.FunctionRoster = 1
								 AND      F.FunctionNo = G.FunctionNo
								 AND      G.GradeDeployment = '#Function.GradeDeployment#'
								 AND      G.Operational = 1
								 ORDER BY FunctionDescription
								</cfquery>
								
								<cfif functionnew.recordcount gte "1"> 
																				
									<tr class="labelmedium2 fixlengthlist">
									<td><cf_tl id="Reassign To">:</td>
								    <td colspan="3" valign="middle">
									
									<form action="FunctionViewLoopSubmit.cfm" method="post" onSubmit="return ask()">
									<input type="hidden" name="FunctionId" value="<cfoutput>#Function.FunctionId#</cfoutput>">
									
									<table><tr><td>
																
									<select name="FunctionNew" id="FunctionNew" class="regularxl">
									<cfoutput query="FunctionNew">
									  <option value="#FunctionNo# #FunctionDescription#">#FunctionDescription#</option>
									</cfoutput>
									</select>
									</td>
									<td style="padding-left:4px">							
									<input type="submit" class="button10g" style="height:25px;width:70px" name="Save" value="Apply">							
									</td></tr></table>
									</form>		
									</td>
									</tr>	
								
								</cfif>					
																
						</cfif>
						
					</cfif>	
																
					</table>
					
		  	</td></tr>
		  	</table>
				  
		  	</td>
			</tr>		
			
			<tr><td style="height:100%;padding:0px;padding-right:12px" width="100%" id="xdetail" valign="top"><cf_divscroll id="detail"/></td></tr>	
			
		</table>
		</td>
	   </tr>
		
   </table>