<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="808080">
			
		<tr><td height="100%" valign="top">
		               
		<table width="98%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
							 			  
			<tr><td height="4"></td></tr>
			  
			<tr>
			<td height="30" valign="top">			  
			<table width="100%" border="0">
			
			    <tr class="line">
				<td>
				  
				<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
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
						<tr class="labelmedium2  fixlengthlist">
					    <td><cf_tl id="Entity">:</td>
					    <td>
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
					  
					<tr class="labelmedium2  fixlengthlist">					
					   					   
						<cfif Function.DocumentNo neq "">
															
								<td><cf_tl id="Recruitment Request">:</td>
							    <td>
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
															
							    <cfoutput>#Doc.Mission# - #Doc.OrganizationUnit#</cfoutput></td>
														
						<cfelse>													
								
								<td><cf_tl id="Recruitment Request">:</td>
								<td>N/A</td>								
						
						</cfif>		
						
						<td><cf_tl id="Class">:</td>
					    <td>#Function.ExerciseClass#</td>				  					   
					   				
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
					
					<tr><td height="3"></td></tr>
											
					</table>
		  	</td></tr>
		  	</table>		  
		  	</td>
			</tr>			
					
			<tr><td height="99%" width="100%" valign="top" id="detail"></td></tr>
			<tr><td height="5"></td></tr>
					   
		</table>
		</td>
	   </tr>
		
	   </table>