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
 
<cfform action="DocumentEditSubmit.cfm" method="post" name="documentedit" style="padding-left:20px;padding-right:20px">
 
	<table align="center" bgcolor="white" style="width:100%">
		 	  
	  <cfif ((Doc.Status is "0" or Doc.Status is "9") and AccessHeader eq "ALL") or getAdministrator("*") eq "1">
	  
		  	 <tr><td style="height:48px">
			 
				  <table width="100%" align="right" class="formpadding">
				    
				  <tr>
										  
				  <td class="fixlength" style="font-size:30px;padding-left:6px;padding-right:8px">
				  
				  <cfoutput>
				  
				  <cfif Doc.Status is "9"><font style="color: 8B0000;"><cf_tl id="Cancelled/Withdrawn"><br><font size="2">on #dateformat(doc.StatusDate,client.dateformatshow)# #doc.StatusOfficerLastName#</font></font></cfif>
				  <cfif Doc.Status is "1"><font color="green"><cf_tl id="Track closed"><br><font size="2">on #dateformat(doc.StatusDate,client.dateformatshow)# #doc.StatusOfficerLastName#</font></cfif></font>
				  <cfif Doc.Status is "0"><font color="gray"><cf_tl id="Track in Process"></font></cfif>		
				  
				  </cfoutput>	 
				  
				  </td>			
				  
				  <td class="labelmedium" style="padding-top:14px">
				  				  
					  <cfquery name="Placed" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">	
					    SELECT   COUNT(DISTINCT PositionNo) AS Assignments
						FROM     PersonAssignment
						WHERE    Source = 'vac'
						AND      SourceId = '#Doc.DocumentNo#' 
						AND      AssignmentStatus IN ('0', '1') 
						AND      AssignmentType = 'Actual' 
	                  </cfquery>
					  		 					  
					  <cfquery name="Onboard" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">	
					    SELECT   COUNT(DISTINCT PersonNo) AS Assignments
						FROM     PersonAssignment
						WHERE    Source = 'vac'
						AND      SourceId = '#Doc.DocumentNo#' 
						AND      AssignmentStatus IN ('0', '1') 
						AND      DateExpiration >= getdate()
						AND      AssignmentType = 'Actual'
	                  </cfquery>
				  				  
			        <cfoutput>	
					
						<table style="border:1px solid silver;">
							<tr class="fixlengthlist labelit line" style="height:21px">
							   <!--- 
							   <td style="background-color:e1e1e1;"><cfif getPost.recordcount lt Placed.recordcount><font color="FF0000" title="More placements than openings"><cf_tl id="Attention"><font><cfelse><cf_tl id="Summary"></cfif></td>
							   --->
							   <td style="padding-right:7px;background-color:eaeaea;border-left:1px solid silver"><cf_tl id="Job opening"></td>
							   <td style="min-width:20px" align="center">#getPost.recordcount#</td>
							   <td style="padding-right:7px;background-color:eaeaea;border-left:1px solid silver"><cf_tl id="Selected"></td>
							   <td style="min-width:20px" align="center"><cfif getCandidate.recordcount eq "0" and Doc.Status eq "1"><font title="No candidate found" color="FF0000"></cfif>#getCandidate.recordcount#</td>							 
							   <td title="positions filled on the staffing table" style="padding-right:7px;background-color:ffffaf;border-left:1px solid silver"><cf_tl id="Placed"></td>
							   <td style="min-width:20px" align="center"><cfif Placed.recordcount eq "0" and getCandidate.recordcount gte "1">><font title="No candidate placed" color="FF0000"></cfif>#Placed.Assignments#</td>
							   <td title="currently serving placed staff" style="padding-right:7px;background-color:ffffaf;;border-left:1px solid silver"><cf_tl id="Serving"></td>
							   <td style="min-width:20px" align="center">#OnBoard.Assignments#</td>					   
							</tr>
						</table>
					
					</cfoutput>
					
			      </td>
							  
				  <td id="result"></td>
				  	
				  <td align="right" colspan="2">
				  
				         <table class="formspacing"><tr class="labelmedium">
				  						  
				  		<cfif (Doc.Status is "0")>
					
						    <cfif Accessheader eq "ALL">
							
								<cfif GetCandidate.Recordcount gte "0">
							
								<td>
							    <INPUT type    = "button"
								       style   = "width:140;height:42px" 								 
									   value   = "Revoke Track"			
									   class   = "button10g"					  
									   name    = "Status" 
									   onClick = "revoke('9')"> 
									   </td>
								
								</cfif>		 
							  
							</cfif>
						
						<cfelseif Doc.Status is "9">	
											
							<cfif GetCompleted.Recordcount eq "0" and Accessheader eq "ALL">
								<td>
							    <INPUT type="button" style="width:140;height:42" value="Reactivate Track" class="button10g"	name="Status" onClick="revoke('0')"> 
								</td>
								
							</cfif>
						  	   
					   	<cfelse>
						
							<td>
						    <!--- check candidates with status = 3 --->
							<cfif getPost.recordcount eq GetCompleted.recordcount 
							      or getPost.recordcount eq Placed.recordcount>						
							   <font color="808080"><cf_tl id="Fulfilled"></font>
							<cfelse>
							   <font color="green"><cf_tl id="Under recruitment"></font>  
							</cfif>
							</td>
					   	
					   </cfif>
														
					<cfoutput>
					
					<cfif (Doc.Status eq "0" and accessheader eq "ALL") or (getAdministrator(Doc.Mission) eq "1" and getPost.recordcount neq GetCompleted.recordcount)>
					
						<cf_tl id="Associate Position" var="ass">
						
						<td>
						
					   	<input style="width:130px;height:42px" 
							   type="button" 
							   class="button10g"	
							   value="#ass#" 
							   onClick="javascript:asspost('#Doc.documentNo#','#Doc.Mission#','#Doc.PostGrade#')">
							   
							   </td>
							   
				    </cfif>
					
				    </cfoutput>			
					
					</tr></table>
					
					</td>
							
				  </tr>
				   
				  </table>
			</td>
		 </tr>
		 		 				
		</cfif>
	             
	  <tr>
	    <td width="100%">
		
	    <table width="100%" align="center">
		
		<tr class="fixrow">
		 <td colspan="3" style="border:1px solid silver">
		
			<table width="99%" align="center" class="formpadding formspacing">
			
				<cfoutput>
			       	<input type="hidden" name="postnumber" value="#Doc.PostNumber#", size="20" maxlength="20" class="disabled" readonly>
					<input type="hidden" name="mission"    value="#Doc.Mission#" size="30" maxlength="30" class="disabled" readonly>
					<input type="hidden" name="documentno" value="#Doc.DocumentNo#">
		    	</cfoutput>
			
			<!--- Field: Unit --->
		 			
			<tr class="labelmedium2 fixlengthlist line">
		    <td style="width:100px"><cf_tl id="Unit">:</td>
			<td style="padding-left:5px;padding-right:5px">
			
			<cfif Doc.Status is "1" or Doc.Status is "9" or AccessHeader neq "ALL">
				<cfoutput><b>#Doc.OrganizationUnit#
				<input type="hidden" name="organizationunit" value="#Doc.OrganizationUnit#">
				</cfoutput>
			<cfelse>
			   	<cfoutput>
		    	 <input type="text" name="organizationunit" value="#Doc.OrganizationUnit#" style="width:90%" size="50" maxlength="80" class="regularxl">
			    </cfoutput>
			</cfif>	
			</td>
			
			<TD style="width:100px"><cf_tl id="Expected onboarding by">:</td>
		    <td style="padding-left:5px">
			<cfif Doc.Status is "1" or Doc.Status is "9" or AccessHeader neq "ALL">
				<cfoutput><b>#Dateformat(Doc.Duedate, CLIENT.DateFormatShow)#
				<input type="hidden" name="Duedate" value="#Dateformat(Doc.Duedate, CLIENT.DateFormatShow)#">
				</cfoutput>
			<cfelse>
				<cfset end = DateAdd("m",  2,  now())> 			
				<cf_intelliCalendarDate9
					FieldName="DueDate" 
					class="regularxl"
					DateValidEnd="#Dateformat(now()+100, 'YYYYMMDD')#"
					Default="#Dateformat(Doc.Duedate, CLIENT.DateFormatShow)#">	
			</cfif>	
					  	   
			</td>	
			</TR>			
						
			<TR class="labelmedium2 fixlengthlist line">
		    <td><cf_tl id="Functional title">:</td>
		    <TD>
				<cfif Doc.Status is "1" or Doc.Status is "9" or AccessHeader neq "ALL">
					<cfoutput><b>#Doc.FunctionalTitle#
					<input type="hidden" name="functionno"      value="#Doc.FunctionNo#">
					<input type="hidden" name="functionaltitle" value="#Doc.FunctionalTitle#">
					</cfoutput>
				<cfelse>
			       <cfoutput>
				   <table style="width:100%">
				   <tr class="labelmedium2 fixlengthlist">
				   <td> 
				   <input type="text" name="functionaltitle" id="functionaltitle" value="#Doc.FunctionalTitle#" class="regularxl" style="width:100%;background-color:f1f1f1" readonly> 
	               </td>
				   <td style="padding-left:2px">						   			      
				   
				    <button name="btnFunction"
				        type="button"			      
				        style="height:25px;width:25px"
				        onClick="selectfunction('webdialog','functionno','functionaltitle','#Mission.MissionOwner#','','','')"> 
															  
					</button>	
												    
				    <input type="hidden" name="functionno" id="functionno" value="#Doc.FunctionNo#">		
					
					</td></tr>
					</table>
				   </cfoutput>
				</cfif>   
		  	</TD>
		    <td><cf_tl id="Grade">:</td>
			<td>
			<table><tr class="labelmedium2">
			
			<cfif Doc.Status is "1" or Doc.Status is "9" or AccessHeader neq "ALL">
			    <td>
				<cfoutput><b>#Doc.PostGrade# (#Doc.GradeDeployment#)
				<input type="hidden" name="postgrade" value="#Doc.PostGrade#">
				</cfoutput>
				</td>
				
				<cfquery name="DocTpe" 
					datasource="AppsVacancy" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">	
					    SELECT   *
						FROM     Ref_DocumentType
						WHERE Code = '#doc.documenttype#'					
                 </cfquery>		
				 
				<td style="padding-left:13px">Type: <b><cfoutput>#doctpe.description#</cfoutput></td>
				
				<input type="hidden" name="DocumentType" value="#doc.documenttype#">
				
			<cfelse>
			   <td> 
			   <select name="PostGrade" required="Yes" class="regularxl">
				    <cfoutput query="Grade">
						<option value="#PostGrade#" 
							<cfif Doc.PostGrade is PostGrade>selected</cfif>>#Description#
						</option>
					</cfoutput>
			    </select>			
				</td>		
				
				 <cfquery name="DocTpe" 
						datasource="AppsVacancy" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">	
					    SELECT   *
						FROM     Ref_DocumentType
						ORDER BY ListingOrder						
	                  </cfquery>		
				<td style="padding-left:3px">				
				<select name="DocumentType" required="Yes" class="regularxl">
				    <cfoutput query="DocTpe">
						<option value="#Code#" 
							<cfif Doc.DocumentType is Code>selected</cfif>>#Description#
						</option>
					</cfoutput>
			    </select>			
				</td>
			</cfif>	
			</tr></table>
			</td>
			</TR>	
							
			<TR class="labelmedium  fixlengthlist line">
			
		    <td><cf_tl id="Remarks">:</td>
			<TD colspan="3" style="padding-left:5px">
			     <cfif Doc.Status is "1" or Doc.Status is "9" or AccessHeader neq "ALL">
						<cfoutput><b><cfif Doc.Remarks eq "">n/a<cfelse>#Doc.remarks#</cfif>
							<input type="hidden" name="remarks" value="#Doc.Remarks#">					
						</cfoutput>
				<cfelse>
					<textarea style="padding:4px;font-size:14px;width:95%;height:40px" 				          
							  class="regular" 
							  maxlength="250"
							  onkeyup="return ismaxlength(this)"	
							  name="Remarks"><cfoutput>#Doc.Remarks#</cfoutput></textarea>
				</cfif>	
			</TD>
						
			<cfif Doc.FunctionId neq "">
							
				<cfquery name="JO" 
				datasource="appsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   FunctionOrganization
					WHERE  FunctionId = '#Doc.FunctionId#' 
				</cfquery>
				
				<cfif JO.Recordcount eq "1">
										
					 <tr class="labelmedium2 fixlengthlist line">	
				
					 <td style="padding-left:3px"><cf_tl id="Recruitment bucket">:</td>
				     <TD colspan="3"> 
					 <table><tr class="labelmedium2 fixlengthlist">
					 					  			   
							<cfoutput>
							
							<cfif AccessHeader eq "EDIT" or AccessHeader eq "ALL">
							
							<td style="padding-right:2px" title="Recruitment bucket">								
							 <button name="btnFunction"  type="button" style="width:18px;height:18px" onClick="details('#JO.FunctionId#')"> 														
							</td>
							
							</cfif>
							<td style="padding-left:3px;font-size:15px">
								<cfif JO.recordcount neq "0">
									<A href="javascript:va('#JO.FunctionId#');">#JO.ReferenceNo#</a>
								<cfelse>
								   <cf_tl id="undefined">
								</cfif>
							</td>
							<cfif JO.DateEffective gt "01/01/2000">
							<td style="padding-left:4px">
								#dateformat(JO.DateEffective,client.dateformatshow)# - #dateformat(JO.DateExpiration,client.dateformatshow)#
							</td>	
							</cfif>							
							<td style="padding-left:4px">	
							   #JO.OfficerLastName#
							</td>
								
						    </cfoutput>
							 		
							<!--- UN only --->
												 
							<cftry>
							
							<cfquery name="CrossReference" 
							datasource="AppsVacancy" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT TOP 1 *
							    FROM  MergeData.dbo.IMP_ISPVacancy
								WHERE Job_Opening_ID = '#JO.ReferenceNo#'
							</cfquery>
							
							<cfif CrossReference.recordcount eq "1">
							    <td style="border:1px solid silver;padding-left:4px;background-color:yellow">Track connected</td>							
							</cfif>
							
							<cfcatch></cfcatch>
							
							</cftry>
							
					   
					   </td></tr>
					  </table>
				   	  </TD>
					  
				  </cfif>
				  	  
			</cfif> 
			</TR>
			
			<cfif Doc.Status is "1" or Doc.Status is "9" or AccessHeader neq "ALL">
				     <!--- no button --->
			<cfelse>
			   <tr>
			      <td colspan="6" align="center">
			      <input type="button" style="width:170px;height:25px" name="Header" class="button10g"	onclick="ptoken.navigate('DocumentEditSubmit.cfm','result','','','POST','documentedit');" value="Save">
				  </td>
			   </tr>
			</cfif>
									
			</table>
		
		</td>
		
	</tr>					  	
		
	<tr><td colspan="3">
		<cfinclude template="DocumentEditPost.cfm">
	</td></tr>	
	
	<tr><td colspan="3" id="selectedme">
		<cf_securediv bind="url:DocumentCandidateSelect.cfm?id=#url.id#">	
	</td></tr>	
	
	<cf_actionListingScript>
	<cf_FileLibraryScript>
	
	<cfoutput>
		
	<input type="hidden" 
		   name="workflowlink_#Doc.DocumentNo#" 
		   id="workflowlink_#Doc.DocumentNo#" 	   	  
		   value="DocumentWorkflow.cfm">	
		   
	<input id="workflowbutton_#Doc.DocumentNo#" type="hidden" onclick="javascript:ptoken.navigate('DocumentWorkflow.cfm?ajaxid=#Doc.DocumentNo#','#Doc.DocumentNo#')">	   
	
	<input type="hidden" 
		   id="workflowlinkprocess_#Doc.DocumentNo#" 
		   onclick="ptoken.navigate('DocumentCandidateSelect.cfm?id=#url.id#','selectedme')">		   
	   
	</cfoutput>	   
				  	   	
	<tr><td colspan="3" style="padding:2px">
		
		<cf_securediv id="#doc.DocumentNo#" 
		    bind="url:DocumentWorkflow.cfm?ajaxid=#Doc.DocumentNo#">   
				
	</td></tr>
	
	</table>
	
	</td></tr>
	</table>

</CFFORM>
