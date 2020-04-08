 
<cfform action="DocumentEditSubmit.cfm" method="post" name="documentedit" style="padding-left:20px;padding-right:20px">
 
	<table align="center" bgcolor="white" style="min-width:1100px;width:100%" >
	
	  <tr><td height="10"></td></tr>
	  
	  <cfif ((Doc.Status is "0" or Doc.Status is "9") and AccessHeader eq "ALL") or getAdministrator("*") eq "1">
	  
		  	 <tr><td style="height:48">
			 
				  <table width="100%" border="0" cellspacing="0" align="right" class="formpadding">
				    
				  <tr>
										  
				  <td style="font-size:31px;padding-left:6px;font-weight:bold">
				  
				  <cfoutput>
				  
				  <cfif Doc.Status is "9"><font color="FF8080">Cancelled/Withdrawn </b></cfif></font>
				  <cfif Doc.Status is "1"><font color="green">Track Closed on <b>#dateformat(doc.StatusDate,client.dateformatshow)#</b> by <b>#doc.StatusOfficerLastName#</b></cfif></font>
				  <cfif Doc.Status is "0"><font color="gray">Track in Process</b></cfif></font>		
				  
				  </cfoutput>	 
				  
				  </td>			
				  
				  <td class="labellarge">
				  
			        <cfoutput>	
				      <cfif getPost.recordcount lt getCandidate.recordcount><font color="FF0000">PROBLEM:&nbsp;<font></font></cfif>	
					  <cf_tl id="Positions">: <b>#getPost.recordcount#</b> | <cf_tl id="Selected candidates">: <b><cfif getCandidate.recordcount eq "0"><font color="FF0000"></cfif>#getCandidate.recordcount#</b>				 
					</cfoutput>
					
			      </td>
							  
				  <td id="result"></td>
				  	
				  <td align="right" colspan="2" style="border:0px solid silver">
				  
				         <table class="formspacing"><tr>
				  						  
				  		<cfif (Doc.Status is "0")>
					
						    <cfif Accessheader eq "ALL">
							
								<cfif GetCandidate.Recordcount eq "0">
							
								<td>
							    <INPUT type    = "button"
								       style   = "width:140;height:26" 								 
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
							    <INPUT type="button" style="width:140;height:26" value="Reactivate Track" class="button10g"	name="Status" onClick="revoke('0')"> 
								</td>
								
							</cfif>
						  	   
					   	<cfelse>
						
						    <!--- check candidates with status = 3 --->
							<cfif getPost.recordcount eq GetCompleted.recordcount>						
							   <b><font size="2" color="808080">Closed</b>&nbsp;
							<cfelse>
							   <b><font color="green">Under recruitment</b>  
							</cfif>
					   	
					   </cfif>
					
					   <cfif Doc.Status is "1" or Doc.Status is "9" or AccessHeader neq "ALL">
					     <!--- no button --->
					   <cfelse>
					       <td>
						   <input type="button" style="width:140;height:26" name="Header" class="button10g"	onclick="ColdFusion.navigate('DocumentEditSubmit.cfm','result','','','POST','documentedit');" value="Update">
						   </td>
						</cfif>
									
					<cfoutput>
					
					<cfif (Doc.Status eq "0" and accessheader eq "ALL") or (getAdministrator(Doc.Mission) eq "1" and getPost.recordcount neq GetCompleted.recordcount)>
					
						<cf_tl id="Associate Position" var="ass">
						
						<td>
						
					   	<input style="width:150;height:26" 
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
		 
		 <tr><td class="line"></td></tr>
		 				
		</cfif>
	             
	  <tr>
	    <td width="100%">
		
	    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		
		<tr><td colspan="3">
		
			<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
			
				<cfoutput>
			       	<input type="hidden" name="postnumber" value="#Doc.PostNumber#", size="20" maxlength="20" class="disabled" readonly>
					<input type="hidden" name="mission"    value="#Doc.Mission#" size="30" maxlength="30" class="disabled" readonly>
					<input type="hidden" name="documentno" value="#Doc.DocumentNo#">
		    	</cfoutput>
			
			<!--- Field: Unit --->
		 
			<tr><td height="1" colspan="4"></td></tr>
			<tr class="labelmedium">
		    <td><cf_tl id="Unit">:</td>
			<td>
			
			<cfif Doc.Status is "1" or Doc.Status is "9" or AccessHeader neq "ALL">
				<cfoutput><b>#Doc.OrganizationUnit#
				<input type="hidden" name="organizationunit" value="#Doc.OrganizationUnit#">
				</cfoutput>
			<cfelse>
			   	<cfoutput>
		    	 <input type="text" name="organizationunit" value="#Doc.OrganizationUnit#" size="50" maxlength="80" class="regularxl">
			    </cfoutput>
			</cfif>	
			</td>
			
			<TD><cf_tl id="Due date">:</td>
		    <td>
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
						
			<TR class="labelmedium">
		    <td><cf_tl id="Functional title">:</td>
		    <TD>
				<cfif Doc.Status is "1" or Doc.Status is "9" or AccessHeader neq "ALL">
					<cfoutput><b>#Doc.FunctionalTitle#
					<input type="hidden" name="functionno"      value="#Doc.FunctionNo#">
					<input type="hidden" name="functionaltitle" value="#Doc.FunctionalTitle#">
					</cfoutput>
				<cfelse>
			       <cfoutput>
				   <table cellspacing="0" cellpadding="0">
				   <tr class="labelmedium">
				   <td> 
				   <input type="text" name="functionaltitle" id="functionaltitle" value="#Doc.FunctionalTitle#" class="regularxl" size="50" maxlength="60" readonly> 
	               </td>
				   <td style="padding-left:2px">						   			      
				   
				    <button name="btnFunction"
				        type="button"			      
				        style="height:23;width:20"
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
			<cfif Doc.Status is "1" or Doc.Status is "9" or AccessHeader neq "ALL">
				<cfoutput><b>#Doc.PostGrade# (#Doc.GradeDeployment#)
				<input type="hidden" name="postgrade" value="#Doc.PostGrade#">
				</cfoutput>
			<cfelse>
			   <select name="PostGrade" required="Yes" class="regularxl">
				    <cfoutput query="Grade">
						<option value="#PostGrade#" 
							<cfif Doc.PostGrade is PostGrade>selected</cfif>>#Description#
						</option>
					</cfoutput>
			    </select>			
			</cfif>	
			</td>
			</TR>	
							
			<TR class="labelmedium">
			
		    <td valign="top" style="padding-top:5px"><cf_tl id="Remarks">:</td>
			<TD colspan="3">
			     <cfif Doc.Status is "1" or Doc.Status is "9" or AccessHeader neq "ALL">
						<cfoutput><b><cfif Doc.Remarks eq "">n/a<cfelse>#Doc.remarks#</cfif>
							<input type="hidden" name="remarks" value="#Doc.Remarks#">					
						</cfoutput>
				<cfelse>
					<textarea style="padding:4px;font-size:13px;width:100%;height:25" 				          
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
				
						<!--- to be replace with new VA document --->
						<cfquery name="VAtext" 
						datasource="AppsVacancy" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT TOP 1 *
						    FROM   stAnnouncement
							WHERE  VacancyNo = '#JO.ReferenceNo#'
						</cfquery>
						
					 <tr>	
				
					 <td class="labelmedium"><cf_tl id="Associated Bucket">:</td>
				     <TD> 
					 <table cellspacing="0" cellpadding="0"><tr><td width="200" align="center" style="border: 1px solid silver;" class="labelmedium">
					 				 
					  <cfif Doc.Status is "1" or Doc.Status is "9" or AccessHeader neq "ALL">
			
						<cfif VAtext.VacancyNo neq "">
							<cfoutput><b><A href="javascript:va('#JO.FunctionId#');">#JO.ReferenceNo#</font></a></cfoutput>
						</cfif>
						
					  <cfelse>
					  			   
							<cfoutput>
							
								<cfif JO.recordcount neq "0">
									<A href="javascript:va('#JO.FunctionId#');">#JO.ReferenceNo#</font></a>
								<cfelse>
								   Undefined
								</cfif>
								</td>
								<td style="padding-left:2px">
								
							 <button name="btnFunction"  type="button" style="width:30px;height:26" onClick="details('#JO.FunctionId#')"> 						
								
							  </td>
						    </cfoutput>
							 					 
							<!--- to be replace with new VA document --->
							<cfquery name="VAtext" 
							datasource="AppsVacancy" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT TOP 1 *
							    FROM stAnnouncement
								WHERE VacancyNo = '#JO.ReferenceNo#'
							</cfquery>
										     											
					   </cfif>	
					   
					   </td></tr>
					  </table>
				   	  </TD>
					  
				  </cfif>
				  	  
			</cfif> 
			</TR>
			
			<tr><td height="4"></td></tr>
			<tr><td colspan="4" class="line"></td></tr>
			<tr><td height="1"></td></tr>
			
			</table>
		
		</td>
		
	</tr>					  	
		
	<tr><td colspan="3">
		<cfinclude template="DocumentEditPost.cfm">
	</td></tr>	
	
	<tr><td colspan="3" id="selectedme">
		<cfdiv bind="url:DocumentCandidateSelect.cfm?id=#url.id#">	
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
			  	   	
	<tr><td colspan="3" style="padding:8px">
		
		<cfdiv id="#doc.DocumentNo#" 
		    bind="url:DocumentWorkflow.cfm?ajaxid=#Doc.DocumentNo#"/>   
				
	</td></tr>
	
	</table>
	
	</td></tr>
	</table>

</CFFORM>
