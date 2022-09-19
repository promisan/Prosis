			
<cfform action="CandidateEditSubmit.cfm" 
   method="POST" style="min-width:1000px" name="candidateedit">
   
    <input type="hidden" name="AreaSelect" value="#URL.IDArea#">

	<table width="95%" align="center" class="formpadding">
	
	  <tr class="hide"><td id="result"></td></tr>
	  
	  <cfoutput>
	  
	  <tr class="line">
	    <td style="height:43px;font-size:27px;font-weight:200" align="left" class="labellarge">
		    <a href="javascript:showdocument('#URL.ID#','')">#Doc.Mission#</a> / #Doc.PostGrade#</b>
		</td>
		<td align="right" class="labelmedium" style="height;30px;padding-top:3px">
		
			<cfif GetCandidateStatus.Status eq "2s">
			    <cfif AccessHeader eq "EDIT" or AccessHeader eq "ALL">
			      <input class="button10g" type="button" name="Revoke" value="Withdraw Candidate" id="Revoke" style="width:212;height:30;font-size:16px" onClick="withdraw()">
				</cfif>  
			</cfif>		
				
	    </td>
				
	  </tr> 
	    
	  </cfoutput>
	  
	  <tr>
	    <td style="height:30;padding-left:2px;font-weight:200" 
		     colspan="1" align="left" class="labellarge">
			
		<cfif Doc.Status eq "9">
		
			<b><font color="FF0000"><cf_tl id="Document cancelled"></font></b>	
		
		<cfelse>
			   		
			<cfif GetCandidateStatus.Status eq "2s">			
		
			    <table cellspacing="0" cellpadding="0">
			   
			     <tr>
								
				<cfif AccessHeader eq "EDIT" or AccessHeader eq "ALL">
				
					<cfif GetCandidateStatus.Status eq "2s">
					
						<td>
					  
			        	<button name="RevokeTrack"
					        id="RevokeTrack"
					        value="Reset Candidate track"
					        type="button"
							class="button10g" style="width:40px"				       
					        onClick="revoke()">	
						
						<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/position_obsolete.gif" 
						 alt="Revoke track: <cfoutput>#GetClass.EntityClassName#</cfoutput>" 
						 width="16" height="16" align="absmiddle" border="0">
						 
						 </button>
						 
						</td> 
						
					</cfif>	
				
				</cfif>
										
				</td>
				
				<td style="padding-left:10px;font-size:17px" class="labelmedium">					
				<cfoutput>#GetClass.EntityClassName#</cfoutput>				
				</td>
				
				</tr>
				</table>	
				
			<cfelseif GetCandidateStatus.Status eq "3">		
				<cf_tl id="Completed"> : <cfoutput><b>#GetClass.EntityClassName#</cfoutput>			
			<cfelseif GetCandidateStatus.Status eq "6">					
				<cf_tl id="On hold">			
			<cfelseif GetCandidateStatus.Status eq "9">					
				<b><font color="FF0000"><cf_tl id="Candidate withdrawn"></font></b>		   						
			<cfelse>		
				<cf_tl id="In process">			
			</cfif> 
						
		</cfif>	
			
		</td>
				
		<td align="right" style="padding-right:20px">
		
		<cfif GetCandidateStatus.TsInterviewStart neq "">
		
			<cfquery name="Check" 
			datasource="appsVacancy" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT TOP 1 *
			    FROM   DocumentCandidateInterview
				WHERE  DocumentNo = '#URL.ID#'
				AND    PersonNo = '#URL.ID1#'
				ORDER  By Created DESC
			</cfquery>
		
		     <cfoutput>
					    
				<a href="javascript:note()"><cf_tl id="See Interview and evaluation record"></a>
				 
			 </cfoutput>				 
						
		<cfelse>
			
		</cfif>
						
		</td>
	
	  </tr> 	 
	   
	  <tr><td colspan="2">
	  	    
	  <table width="100%" align="center">
	     
	  <tr>
	  
	    <td width="100%" colspan="2">
			
	    <table width="100%">
		
		    <tr style="border-top:1px solid silver;background-color:f1f1f1" class="line labelmedium">
		
			<cfoutput>					
				<input type="hidden" name="mission"    value="#Doc.Mission#">
				<input type="hidden" name="documentno" value="#Doc.DocumentNo#">
				<input type="hidden" name="postgrade"  value="#Doc.PostGrade#">		
	     	</cfoutput>
			
	        <!--- Field: Unit --->
				
			<td height="15" style="min-width:80px;padding-left:4px;border-right:1px solid silver"><cf_tl id="Name">:</b></td>
			<td style="padding-left:4px;min-width:120px;border-right:1px solid silver">
		    	<cfoutput>
		    	<A HREF ="javascript:ShowCandidate('#getCandidate.PersonNo#')">#getCandidate.FirstName# #getCandidate.LastName#</a>		
		    	    <input type="hidden" name="PersonNo" value="#getCandidate.PersonNo#" size="8" maxlength="8" readonly class="disabled">	
				 </cfoutput>
			</td>
			
		    <td height="15" style="min-width:100;padding-left:4px;border-right:0px solid silver"><cf_tl id="Nationality">:</td>
			<td style="padding-left:3px;border-right:1px solid silver">
			  	<cfoutput>
		    	  #getCandidate.Nationality#
				 </cfoutput>
			</td>
				
		    <td height="15" style="min-width:60;padding-left:4px;;border-right:0px solid silver"><cf_tl id="DOB">:</td>
			<td style="padding-left:3px;border-right:1px solid silver">
			      <cfoutput>#DateFormat(getCandidate.DOB,CLIENT.DateFormatShow)#</cfoutput>
			</td>
			
			<td height="15" style="padding-left:4px;;border-right:0px solid silver"><cf_tl id="Post">:</td>
			<td style="padding-left:3px;border-right:1px solid silver">
				
			   	<cfif GetPost.recordcount eq "1">
				
				 <cfoutput>
					 <cfif GetPost.SourcePostNumber eq ""><cf_tl id="Internal"><cfelse>#GetPost.SourcePostNumber#</cfif>
					 <input type="hidden" name="postnumber" value="#GetPost.SourcePostNumber#">
		     	 </cfoutput>
				 	
				<cfelse>
						
			 	    <select name="PostNumber">				
					    <cfoutput query="GetPost">							
				    		<option value="#SourcePostNumber#" <cfif getCandidateStatus.PostNumber is SourcePostNumber>selected</cfif>>
				    		<cfif SourcePostNumber eq "">Internal<cfelse>#SourcePostNumber#</cfif>
							</option>					
						</cfoutput>
				    </select>			
				
				</cfif>
						
			</td>
			 				
			<td height="15" style="min-width:50;color:gray;padding-left:4px;border-right:0px solid silver"><cf_tl id="TA">:</td>
		    <td style="padding-left:3px;border-right:1px solid silver">
			
			    <cfif GetTravel.TANumber eq "">
				   Not determined
				<cfelse>
				  <cfoutput>#GetTravel.TANumber#</cfoutput>
				</cfif>
				
			</td>
		
		</tr>	 
		
		<cfquery name="GetEmployee" 
	    datasource="AppsEmployee" 
	    username="#SESSION.login#" 
		maxrows=1 
	    password="#SESSION.dbpw#">
		    SELECT  *
		    FROM    Person
			WHERE   PersonNo = '#getCandidate.EmployeeNo#'
	    </cfquery>
			
		<cfif GetEmployee.recordcount eq "0">
		
			<cfquery name="GetEmployee" 
		    datasource="AppsEmployee" 
		    username="#SESSION.login#" 
			maxrows=1 
		    password="#SESSION.dbpw#">
		    SELECT  *
		    FROM    Person
			WHERE   PersonNo = '#getCandidate.EmployeeNo#'
		    </cfquery>
		
		<cfelse>
		
			<cfquery name="qUpdate_Employee" 
		    datasource="AppsSelection" 
		    username="#SESSION.login#"
		    password="#SESSION.dbpw#">
			    UPDATE Applicant
				SET    IndexNo = '#getEmployee.IndexNo#'
				WHERE  PersonNo = '#URL.ID1#'
		    </cfquery>
			
		</cfif>
		
		<!--- mapped record --->
			
		<cfif GetEmployee.recordcount eq "1" and GetEmployee.IndexNo neq "">
								
			<tr style="border-top:1px solid gray;background-color:f1f1f1" class="line labelmedium">
						
		    <td style="width:10%;padding-left:4px;border-right:1px solid silver"><cfoutput>#client.IndexNoName#:</cfoutput></td>
			
			<td style="padding-left:4px;border-right:1px solid silver">				
			    <cfoutput><a href="javascript:EditPerson('#GetEmployee.IndexNo#')">#GetEmployee.IndexNo#</a></cfoutput>
			</td>
					
				<cfoutput>
					<input type="hidden"  name="indexno" value="#GetEmployee.IndexNo#" size="10" maxlength="20" readonly>
				</cfoutput>
			
				 <cfquery name="Level" 
		          datasource="AppsEmployee" 
		          maxrows=1 
		          username="#SESSION.login#" 
		          password="#SESSION.dbpw#">
			          SELECT *
			      	  FROM  PersonContract
			   	      WHERE PersonNo = '#getEmployee.PersonNo#' 
					  ORDER BY DateEffective DESC
				  </cfquery>
			
			<td style="padding-left:4px;border-right:0px solid silver"><cf_tl id="Grade">:</b></td>
			<td style="padding-left:4px;border-right:1px solid silver">
			      <cfoutput>#Level.ContractLevel#<cfif Level.ContractStep neq "">/#Level.ContractStep#</cfif></cfoutput>
			</td>
			
			<cfif getRelease.ParentOffice neq "">
			
		    <td style="padding-left:4px;border-right:0px solid silver"><cf_tl id="Parent Office">:</td>
		    <td style="padding-left:3px;border-right:1px solid silver">
			      <cfoutput>#getRelease.ParentOffice# #getRelease.ParentLocation#</cfoutput>
		    </td>
		
		<cfelse>
		
		 <td style="padding-left:4px;;border-right:0px solid silver"><cf_tl id="Status">:</td>
		 
			<cfquery name="Assess" 
				datasource="appsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM  ApplicantAssessment
					WHERE PersonNo = '#URL.ID1#' 
					AND   Owner    = '#Doc.Owner#'
			</cfquery>
					  			   
		   <cfquery name="Status" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			    FROM     Ref_PersonStatus
			    WHERE    Code = '#Assess.PersonStatus#' 
			</cfquery>
			
		   <cfoutput>
		   <td style="color:gray;padding-left:4px;padding-left:3px;border-right:1px solid silver" align="center" bgcolor="#Status.InterfaceColor#">
		   	<cfif Status.InterfaceColor neq "Transparent"><font color="FFFFFF"></cfif>#Status.Description#
		   </td>
		   </cfoutput>
		
		</cfif>
		
		<cfif GetReassignment.Mission neq "">
		
			<td style="color:gray;padding-left:4px;background-color:f1f1f1;;border-right:1px solid silver"><cf_tl id="Reassigned">:</td>
			<td style="padding-left:3px">
			
			<cfif GetReassignment.Mission neq "">
			
				<cfif Doc.Status eq "9" or GetCandidateStatus.Status eq "9">
					<cfoutput>#GetReassignment.Mission#</cfoutput>
				<cfelse>		    
				    <cfoutput>#GetReassignment.Mission#</cfoutput>					
				</cfif>	
				
			<cfelse>
			
				<cf_tl id="N/A">
				
			</cfif>	
			
			</td>
		  
			<td style="color:gray;padding-left:4px;background-color:f1f1f1;;border-right:1px solid silver"><cf_tl id="Through">:</td>
			
	    	<TD style="padding-left:3px">
			
				<cfif GetReassignment.RequestThrough neq "">		
					<cfoutput>#GetReassignment.RequestThrough#</cfoutput>		
				<cfelse>
					<cfoutput>#GetRelease.RequestThrough#</cfoutput>
				</cfif>
			
			</TD>
			
		<cfelse>
		
			<td style="padding-left:4px" colspan="3"><cf_tl id="Expected Arrival"></td>
			
			<td style="color:gray;padding-left:4px;border-left:0px solid silver;border-right:1px solid silver">
			  
			
			    <cfif Doc.Status eq "9" or GetCandidateStatus.Status eq "9">				
						
				  #dateformat(GetCandidateStatus.DateArrivalExpected,client.dateformatshow)#"					
				
				<cfelse>
				
				<table><tr><td align="center">
								  
				<cf_intelliCalendarDate9
					FieldName="DateArrivalExpected" 
					Manual="True"		
					class="regularxl"	
					style="border:0px;border-left:1px solid silver;border-right:1px solid silver;text-align:center;background-color:fafafa"													
					Default="#dateformat(GetCandidateStatus.DateArrivalExpected,client.dateformatshow)#"
					AllowBlank="False">		
					
					</td>
					
					<td><input type="button" name="Save"class="button10g" style="border:0px;border-right:1px solid silver;border-left:1px solid silver;height:25px;width:40px" 
					   onclick="ptoken.navigate('CandidateEditSubmit.cfm','result','','','POST','candidateedit')" value="Save"></td>
					</tr></table>				
					
				</cfif>		
				
			</td>				
			
		</cfif>	
		</tr>
			
		<!--- ----------------- --->
		<!--- not mapped record --->
		<!--- ----------------- --->
		
		<cfelse>
										
			<tr class="line labelmedium">
			
			<td style="color:gray;padding-left:4px;border-right:1px solid silver"><cfoutput>#client.IndexNoName#:</cfoutput></b></td>
			<td colspan="5" style="padding-left:3px">
			
			<cfif Doc.Status eq "9" or GetCandidateStatus.Status eq "9">
			   
				<cfoutput>#GetCandidateStatus.IndexNo#</cfoutput>
				
			<cfelse>
			
				<cfoutput>
			
				<script>	
					
					function LocatePerson(last,dob,nat,pers) {												
						ProsisUI.createWindow('myperson', 'Pick Staff profile record', '',{x:100,y:100,height:document.body.clientHeight-90,width:800,modal:true,resizable:false,center:true})    
						ptoken.navigate('#session.root#/Vactrack/Application/Candidate/getIndexNo.cfm?mission=#doc.mission#&personno='+pers+'&ID2=' + last + '&ID3=' + dob + '&ID4=' + nat,'myperson') 		
					 
					}
					
					function applyperson(ind,emp,pers) {
						document.getElementById("indexno").value = ind
						ptoken.navigate('setCandidateEmployee.cfm?indexNo='+ind+'&employeeno='+emp+'&PersonNo='+pers,'result')		
						ProsisUI.closeWindow('myperson',true) 		
					}
		
				</script>
				
				</cfoutput>	
							
				<!--- Query returning search results --->
				<cfquery name="Parameter" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT * 
				    FROM   Ref_ParameterMission
					WHERE  Mission = '#doc.mission#'	
				</cfquery>
			
			 	<cfoutput> 
		        
					<table style="border:0px solid silver">
					<tr>
					<td>
	
						<input type="text" 
							id="indexno" 
							name="indexno" 
							style="border:0px;text-align:center" 
							class="labelmedium" 
							value="#GetCandidate.IndexNo#" 
							size="9" 
							class="regular3" 
							maxlength="10" readonly>
						
		      	    </td>				
					<cfset nme = replace(GetCandidate.LastName,"'","|")>
				    <td align="right" 
					  style="cursor:pointer;padding-right:3px" 
					  onClick="LocatePerson('#nme#','#Dateformat(GetCandidate.DOB, CLIENT.DateFormatShow)#','#GetCandidate.Nationality#','#GetCandidate.PersonNo#')">				  
						<img src="#SESSION.root#/Images/search.png" alt="Associate employee record" height="22" width="24" border="0">													
					</td>
					</tr>
					</table>
		      	
				</cfoutput>
		
			</cfif>		
		
		    </td>
		
			<td style="color:gray;padding-left:4px;border-right:1px solid silver"><cf_tl id="Reassigned from">:</td>
			<td style="padding-left:3px">
			
			<cfoutput>
			
			<cfif GetReassignment.Mission neq "">
			
				<cfif Doc.Status eq "9" or GetCandidateStatus.Status eq "9">
					#GetReassignment.Mission# 
				<cfelse>
				    #GetReassignment.Mission# 
					<!---
					<input type="text" name="ReassignmentFrom" value="#GetCandidateStatus.ReassignmentFrom#" size="15" maxlength="20" class="regular">
					--->
				</cfif>
			
			<cfelse>
			
				<cf_tl id="N/A">
				
			</cfif>
			
			</cfoutput>
				
			</td>
			
				<td style="color:gray;padding-left:4px;;border-right:1px solid silver"><cf_tl id="Through">:</b></td>
		    	<TD style="padding-left:3px">
				
				<cfif GetReassignment.RequestThrough neq "">				
				<cfoutput>#GetReassignment.RequestThrough#</cfoutput>				
				<cfelse>				
				<cfoutput>#GetRelease.RequestThrough#</cfoutput>						
				</cfif>			
				
				</TD>
				
			</tr>
		
			
		</cfif>
					
		<cfset PersonNo = URL.ID1>
		
		<tr class="labelmedium" style="border-bottom:1px solid silver">
		<td colspan="12">
		
		<cf_DocumentCandidateReview PersonNo="#URL.ID1#" Owner="#Doc.Owner#" DocumentNo="#Doc.DocumentNo#"></td></tr>
		
		<cfif GetTravel.ArrivalDateTime neq "">
		
		    <tr><td height="3" colspan="12"></td></tr>
		    <tr><td colspan="12" bgcolor="f1f1f1"></td></tr>	
			<tr><td height="2" colspan="12"></td></tr>
			<tr><td colspan="12">
				<cfinclude template="../Travel/DocumentView.cfm">
			</td></tr>	
			<tr><td height="3" colspan="12"></td></tr>
		    <tr><td colspan="12" bgcolor="f1f1f1"></td></tr>	
			<tr><td height="2" colspan="12"></td></tr>
				
		</cfif>
	   	
		<tr>
		<td valign="top" class="labelit" style="padding-top:3px;padding-left:4px"><cf_tl id="Group">:</td>
		<td colspan="3" valign="top" class="labelmedium" style="padding-top:3px">
		
		<cfquery name="Group" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
			SELECT F.*
			FROM   ApplicantGroup S, 
			       Ref_Group F
			WHERE  S.PersonNo  = '#URL.ID1#'
			 AND   S.GroupCode = F.GroupCode
			 AND   F.GroupDomain = 'Candidate'
		</cfquery>
		
		<cfif group.recordcount eq "0">
		
		n/a 
		
		<cfelse>
		
		<table>
		    <cfoutput query="Group"><tr><td>#Description#</td></tr></cfoutput>
		</table>
		
		</cfif>
			
		</td>
		<td height="15" valign="top" style="padding-top:4px;padding-right:4px" class="labelit"><cf_tl id="Memo">:</b></td>
	    <TD colspan="7" style="padding-bottom:4px;padding-top:4px;padding-right:0px">
		
		<cfif Doc.Status eq "9" or GetCandidateStatus.Status eq "9">
		
		    <cfoutput>
				#GetCandidateStatus.Remarks# 
				<input type="hidden" name="Remarks" value="#GetCandidateStatus.Remarks#">
			</cfoutput>
			
		<cfelse>		
			
			<cfif AccessHeader eq "EDIT" or AccessHeader eq "ALL">
				<textarea 			 
				 rows="3" 
				 name="Remarks" 
				 style="width:100%;padding:5px;background-color:f1f1f1;border:0px;font-size:14px;height:40px"
				 class="regular" 
				 onchange="ptoken.navigate('CandidateEditSubmit.cfm','result','','','POST','candidateedit')"><cfoutput>#GetCandidateStatus.Remarks#</cfoutput></textarea>
			<cfelse>
			
			    <cfoutput>
				#GetCandidateStatus.Remarks# 
				<input type="hidden" name="Remarks" value="#GetCandidateStatus.Remarks#">
				</cfoutput>
			</cfif>	
			
		</cfif>	
		</td>
		</tr>

        <cfoutput>
					 
		<tr>
		<td id="workflowlinkprocess_#getCandidateStatus.CandidateId#" colspan="12"  
		   onclick="ptoken.navigate('#session.root#/Vactrack/Application/Candidate/CandidateIncumbency.cfm?id=#url.id#&id1=#url.id1#','incumbox')">
		
		<cf_securediv style="height:100%" 
			 bind="url:#session.root#/Vactrack/Application/Candidate/CandidateIncumbency.cfm?id=#url.id#&id1=#url.id1#" 
			 id="incumbox">	
		
		</td></tr>
		
		</cfoutput>
						
		<cf_actionListingScript>
		<cf_FileLibraryScript>
			
		<cfoutput>
			
				<input type="hidden" 
					   name="workflowlink_#getCandidateStatus.CandidateId#" 
					   id="workflowlink_#getCandidateStatus.CandidateId#" 			   
					   value="CandidateWorkflow.cfm">	
		
				<input type="hidden" 
					   name="workflowcondition_<cfoutput>mybox#getcandidate.Personno#</cfoutput>" 
					   value="?id=#url.id#&id1=#url.id1#&ajaxid=#getCandidateStatus.CandidateId#">	
						  
					   				  	   	
				<tr><td colspan="12" align="center" id="#getCandidateStatus.CandidateId#">
							
				    <cfset url.ajaxid = "#getCandidateStatus.CandidateId#">
					<cfinclude template="CandidateWorkflow.cfm">
							
				</td></tr>
			
			</cfoutput>		
		
		</table>
	
	</td>
	</tr>
	
	</table>
	
	</td>
	</tr>
	
	</table>

</CFFORM>
	