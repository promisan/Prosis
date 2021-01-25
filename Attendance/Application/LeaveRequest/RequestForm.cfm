<!--ADDED BY JORGE MAZARIEGOS  ON 27 JAN 2010---->


<cf_calendarScript>

  <cfquery name="Param" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Parameter 		
 </cfquery>

<cfquery name="getAssignment" 
	 datasource="AppsEmployee"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT   O.*, R.PostOrder
		 FROM     PersonAssignment PA, 
		          Organization.dbo.Organization O,
				  Position P, 
				  Ref_PostGrade R
		 WHERE    P.PositionNo = PA.PositionNo
		 AND      R.PostGrade  = P.PostGrade
		 AND      PA.PersonNo          = '#Get.PersonNo#'
		 AND      Pa.OrgUnit           = O.OrgUnit
		 AND      PA.DateEffective     < getdate()
		 AND      PA.DateExpiration    > getDate()
		 AND      PA.AssignmentStatus IN ('0','1')
		 AND      PA.AssignmentClass   = 'Regular'
		 AND      PA.AssignmentType    = 'Actual'
		 AND      PA.Incumbency        = '100' 
</cfquery>	

<cfquery name="Valid" 
	 datasource="AppsEmployee"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT   MIN(PA.DateEffective) First, MAX(PA.DateExpiration) Last
		 FROM     PersonAssignment PA, Organization.dbo.Organization O
		 WHERE    PersonNo = '#Get.PersonNo#'
		 AND      Pa.OrgUnit    = O.OrgUnit		
		 AND      PA.AssignmentStatus IN ('0','1')
		 -- AND      PA.AssignmentClass  = 'Regular'
		 AND      PA.AssignmentType   = 'Actual'
		 AND      PA.Incumbency       = '100' 
</cfquery>	

<table width="97%" height="100%" class="formpadding" align="center">
		 		  				 		  
		  <cfif URL.Src eq "Manual">
		  			  		
			  <cfinvoke component="Service.Access"
			     method="contract"
			     returnvariable="access" personno="#get.PersonNo#">
		  
			  <cfquery name="Type" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   *
					FROM     Ref_LeaveType 
					WHERE    EntityClass IN (SELECT EntityClass FROM   Organization.dbo.Ref_EntityClass WHERE  EntityCode = 'EntLve')
					<cfif quotedvalueList(getAssignment.Mission) neq "">						
					AND      LeaveType   IN (SELECT LeaveType 
					                         FROM   Ref_LeaveTypeMission 
										     WHERE  Mission IN (#quotedvalueList(getAssignment.Mission)#))
					</cfif>		
										
					<cfif access neq "EDIT" and access neq "ALL" and Get.PersonNo neq client.PersonNo>
					AND     LeaveParent IN ('SickLeave','AnnualLeave','CTO')
					</cfif>			
					
					<!---
					AND    LeaveType IN (SELECT R.LeaveType 
							             FROM   PersonContract PC INNER JOIN Ref_LeaveTypeClassAppointment R ON R.AppointmentStatus = PC.AppointmentStatus	
										 WHERE  Personno = '#Get.PersonNo#'												 
										 AND    ActionStatus IN ('0','1')
										 AND    DateEffective  <= getdate()
										 AND    DateExpiration >= getdate()						 
										)	 							
										
					--->					
											
					ORDER BY ListingOrder, 
					         Description
							 
			   </cfquery>			   
			   
			   <cfif Type.recordcount eq "0">
			   
				   <cfquery name="Type" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   *
						FROM     Ref_LeaveType 
						WHERE    EntityClass IN (SELECT EntityClass FROM   Organization.dbo.Ref_EntityClass WHERE  EntityCode = 'EntLve')
						<cfif quotedvalueList(getAssignment.Mission) neq "">						
						AND      LeaveType   IN (SELECT LeaveType 
						                         FROM   Ref_LeaveTypeMission 
											     WHERE  Mission IN (#quotedvalueList(getAssignment.Mission)#))
						</cfif>		
											
						<cfif access neq "EDIT" and access neq "ALL" and Get.PersonNo neq client.PersonNo>
						AND     LeaveParent IN ('SickLeave','AnnualLeave','Official')
						</cfif>			
						
						ORDER BY ListingOrder, 
						         Description
								 
				   </cfquery>
			  		   
			   </cfif>
			   
			  <tr><td height="3"></td></tr> 	 
			  <tr class="labelmedium2">
			    <td valign="top" style="padding-top:4px" width="25%" ><cf_tl id="Requester">:</td>
			    <td  style="font-size:22px;padding-left:1px"><cfoutput>#Get.FirstName# #Get.LastName# (#Get.IndexNo#)<br><font size="3">#getAssignment.OrgUnitName#</cfoutput></td>
				<td align="right" style="min-width:220px;padding-right:3px;" rowspan="7" valign="top" id="balance">
				<!--- notifier --->
				</td>
			  </tr>		
			  
			    <tr><td height="2"></td></tr>
			   
			    <tr>
			    <td>
					<table cellspacing="0" cellpadding="0">
						<tr><td height="3"></td></tr>
						<tr class="labelmedium2"><td><cf_tl id="Type of Leave">:<font color="FF0000">*</font></td></tr>			
					</table>
				</td>
			    <td width="70%">
				
					<table style="border:1px solid silver">
					
					<tr>
					
					<td>
			 	 						  			
					<cfoutput>
																				
					 <select id="leavetype" name="leavetype" style="border:0px"
					   class="regularxxl"
					   onchange="getinformation('#url.id#');ptoken.navigate('#session.root#/attendance/application/leaveRequest/RequestTypeClass.cfm?source=#url.src#&id=#url.id#&leavetype='+this.value,'typeclass')">

					     <cfloop query = "Type">
						     <option value="#LeaveType#">&nbsp;#Description#&nbsp;&nbsp;</option> <cfif type.currentRow eq 1>selected</cfif>>
					     </cfloop>
					 
					 </select>
					 
					</cfoutput>
					
					</td>
					
					<td id="rowaction" style="padding-left:4px">			
			
					<cfdiv id="typeclass">
						<cfset url.leavetype = type.leavetype>
						<cfinclude template="RequestTypeClass.cfm">
					</cfdiv>
					
					</td>
					
					</tr>
				 	
					</table>
			    </td>
			 
			  </tr>
			  		    
		  <cfelse>
		  
		  	  <!--- Hanno comment in STL 01/10/2018 we best check also here if the leavetype has 
			      been set for any of the appointment types, then then we show the type
				  the same for the classes, so we can control interns and temp contracts --->
		  			
			  <tr>
			    <td class="labelmedium2"><cf_tl id="Requester">:</td>
			    <td class="labellarge"><cfoutput>#Get.FirstName# #Get.LastName# / #getAssignment.OrgUnitName#</cfoutput></td>
				<td align="right" style="padding:1px;min-width:220" rowspan="7" valign="top" id="balance"></td>
			  </tr>		
		  
			  <tr>
			    <td>
					<table cellspacing="0" cellpadding="0">
						<tr><td height="3"></td></tr>
						<tr class="labelmedium2"><td><cf_tl id="Type of Leave">:<font color="FF0000">*</font></td></tr>			
					</table>
				</td>
			    <td width="70%">
				
					<table style="border:1px solid silver">
					
						<tr>
						
						<td style="padding-right:3px">										
					
					     <cfquery name="Type" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT   *
							FROM     Ref_LeaveType 
							WHERE   UserEntry = '1'
							<!--- enforce workflow enabling --->
							AND      EntityClass IN (SELECT EntityClass 
							                         FROM   Organization.dbo.Ref_EntityClass 
												     WHERE  EntityCode = 'EntLve')
													 
							<cfif quotedvalueList(getAssignment.Mission) neq "">						
							AND      LeaveType   IN (SELECT LeaveType 
							                         FROM   Ref_LeaveTypeMission 
												     WHERE  Mission IN (#quotedvalueList(getAssignment.Mission)#))
							</cfif>								 
							
							AND    LeaveType IN (SELECT R.LeaveType 
							                     FROM   PersonContract PC INNER JOIN Ref_LeaveTypeClassAppointment R ON R.AppointmentStatus = PC.AppointmentStatus	
												 WHERE  Personno = '#url.id#'												 
												 AND    ActionStatus IN ('0','1')
												 AND    DateEffective  <= getdate()
												 AND    DateExpiration >= getdate())						 
													 													 
													 
							ORDER BY ListingOrder												
						 </cfquery>					 
						
						 <cfif type.recordcount eq "0">
						 
							 <cfquery name="Type" 
								datasource="AppsEmployee" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								SELECT   *
								FROM     Ref_LeaveType 
								WHERE   UserEntry = '1'
								<!--- enforce workflow enabling --->
								AND      EntityClass IN (SELECT EntityClass 
								                         FROM   Organization.dbo.Ref_EntityClass 
													     WHERE  EntityCode = 'EntLve')
														 
								<cfif quotedvalueList(getAssignment.Mission) neq "">						
								AND      LeaveType   IN (SELECT LeaveType 
								                         FROM   Ref_LeaveTypeMission 
													     WHERE  Mission IN (#quotedvalueList(getAssignment.Mission)#))
								</cfif>								 
																			 
								ORDER BY ListingOrder												
							 </cfquery>						 
						 
						 </cfif>
					
						 <cfoutput>
																					
						  <select id="leavetype" name="leavetype" 
						   class="regularxxl" style="border:0px"
						   onchange="_cf_loadingtexthtml='';ptoken.navigate('#session.root#/attendance/application/leaveRequest/RequestTypeClass.cfm?source=#url.src#&id=#url.id#&leavetype='+this.value,'typeclass');">
	
						     <cfloop query = "Type">
							     <option value="#LeaveType#">&nbsp;#Description#&nbsp;&nbsp;</option> <cfif type.currentRow eq 1>selected</cfif>>
						     </cfloop>
						 
						  </select>
						 
						 </cfoutput>
						
						</td>
						
						<td id="rowaction" style="padding-left:2px;padding-right:0px">			
				
						<cfdiv id="typeclass">
							<cfset url.leavetype = type.leavetype>
							<cfinclude template="RequestTypeClass.cfm">
						</cfdiv>
						
						</td>
						
						</tr>
				 	
					</table>
			    </td>
			  </tr>
		  
		  </cfif>			  
		  		 		  		  
		  <tr class="labelmedium">
		    <td><cf_tl id="First Day">:<font color="FF0000">*</font></td>
		    <td colspan="2">
				<table cellspacing="0" cellpadding="0">
				<tr><td style="z-index:2; position:relative;padding-right:15px">
											
					<cf_intelliCalendarDate9
						FieldName="dateeffective" 
						Default="#Dateformat(now()+3, CLIENT.DateFormatShow)#"
						DateValidStart="#Dateformat(valid.first, 'YYYYMMDD')#"
						DateValidEnd="#Dateformat(valid.last, 'YYYYMMDD')#"		
						scriptdate="geteffectivedate"		
						class="regularxxl enterastab"										
						AllowBlank="No">	
					
					<!---	disable by Hanno 10/5		
					<cfajaxproxy bind="javascript:setmydate('dateexpiration',{dateeffective})"> 													
					--->
					
					
				</td>
				
				<td class="labelmedium hide" name="_EffectivePortion" id="_EffectivePortion">
				   <table>
				   <tr class="labelmedium" name="portion">
				   	   <td><input type="radio" class="radiol" name="DateEffectiveHour" id="dateeffectivehour" onclick="document.getElementById('dateeffectivefull').value='1';getinformation('<cfoutput>#url.id#</cfoutput>')" checked value="0"></td>
					   <td style="padding-left:5px"><cf_tl id="Full day"></td>				   
					   <td style="padding-left:10px"><input type="radio" class="radiol" name="DateEffectiveHour" id="dateeffectivehour" onclick="document.getElementById('dateeffectivefull').value='0';getinformation('<cfoutput>#url.id#</cfoutput>')" value="6"></td>
					   <td style="padding-left:5px"><cf_tl id="AM">/<cf_tl id="First part of the shift"></td>
					   <td style="padding-left:10px"><input type="radio" class="radiol" name="DateEffectiveHour" id="dateeffectivehour" onclick="document.getElementById('dateeffectivefull').value='0';getinformation('<cfoutput>#url.id#</cfoutput>')" value="12"></td>
					   <td style="padding-left:5px"><cf_tl id="PM">/<cf_tl id="Second part of the shift"></td>				 
				   </tr>
				   </table>
				</td>
				
				<input type="hidden" name="dateeffectivefull" id="dateeffectivefull" value="1">
								
				<td class="labelmedium clsDateAdditionalInfo" name="_EffectiveRange" id="_EffectiveRange">
				   <table>
					<tr class="labelmedium" name="portion">
					   <td><input type="radio" class="radiol" name="xDateEffectiveFull" onclick="document.getElementById('dateeffectivefull').value='1';getinformation('<cfoutput>#url.id#</cfoutput>')" value="1" checked></td>
					   <td style="padding-left:5px"><cf_tl id="Full Day"></td>
					   <td style="padding-left:10px"><input type="radio" class="radiol" name="xDateEffectiveFull" onclick="document.getElementById('dateeffectivefull').value='0';getinformation('<cfoutput>#url.id#</cfoutput>')" value="0"></td>
					   <td style="padding-left:5px"><cf_tl id="Half Day">/<cf_tl id="Second part of the shift"></td>
				    </tr>
				   </table>
				</td>
				
				</tr>	
				</table>	
		    </td>
		  </tr>
		 
		  <tr id="_Expiration" name="_Expiration" class="labelmedium">
		    <td><cf_tl id="Last Day">:<font color="FF0000">*</font></td>
		    <td colspan="2">
			<table cellspacing="0" cellpadding="0">
			<tr><td style="z-index:1; position:relative;padding-right:15px">
			
				<cf_intelliCalendarDate9
					FieldName="dateexpiration" 
					Default=""
					DateValidStart="#Dateformat(valid.first, 'YYYYMMDD')#"		
					class="regularxxl enterastab expiry"	
					scriptdate="getexpirationdate"	
					AllowBlank="No">	
					
					<!---
					<cfajaxproxy bind="javascript:setexpirationdate('dateexpiration',{dateexpiration},'0')">
					--->
										
			</td>
									
			<td class="labelmedium clsDateAdditionalInfo">
			    <table><tr class="labelmedium" name="portion">				
			       <td><input type="radio" class="radiol" name="DateExpirationFull" id="dateexpirationfull" value="1" onclick="document.getElementById('dateexpirationfull').value='1';getinformation('<cfoutput>#url.id#</cfoutput>')" checked></td>
				   <td style="padding-left:5px"><cf_tl id="Full Day"></td>
				   <td style="padding-left:10px"><input type="radio" class="radiol" name="DateExpirationFull" id="dateexpirationfull" onclick="document.getElementById('dateexpirationfull').value='0';getinformation('<cfoutput>#url.id#</cfoutput>')" value="0"></td>
				   <td style="padding-left:5px"><cf_tl id="Half Day">/<cf_tl id="First part of the shift"></td>
				   </tr>
				</table>				
			</td>
												
			</tr>	
			</table>	
		    </td>
		  </tr>	 
		  
		  <cfif Param.LeaveFieldsEnforce eq "1">
		  	<cfset enf = "Yes">
			<cfset cl  = "regular">
		  <cfelse>
		    <cfset enf = "No">
			<cfset cl  = "hide">
		  </cfif>		  
				  
	      <tr id="backup" name="backup">
		    <td valign="top" height="23" style="padding-top:5px;padding-right:15px" class="labelmedium"><cf_tl id="Backup">:<cfif enf eq "Yes"><font color="FF0000">*</font></cfif>
			<cf_space spaces="45">
			</td>
		    <td width="70%" colspan="2">
			
				<table cellspacing="0" cellpadding="0" class="formpadding">
				<tr>
						
					<cfset link = "#session.root#/attendance/application/leaveRequest/getPerson.cfm?PersonNo=#URL.ID#&leaveid=&field=HandoverUserId">						
															
					<td width="50%" style="padding-left:1px">					
						<cfdiv bind="url:#link#&Account=" id="backupselect"/>						
					</td>
					
					<td style="padding-right:1px">
						
					   <cf_selectlookup
						    box        = "backupselect"
							link       = "#link#"
							button     = "Yes"
							close      = "Yes"						
							icon       = "search.png"
							iconheight = "26"
							iconwidth  = "25"
							class      = "user"
							des1       = "Account">
							
					</td>		
					
				    <td width="49%"></td>			
								
				</tr>
				</table>	
						
			</td>
		  </tr>
		  		  		  	 
		  <tr id="reviewerselect"><td valign="top" style="min-width:200px;padding-top:6px" class="labelmedium"><cf_tl id="Authorization by">:<font color="FF0000">*</font></td></tr>
		 		 			  
		  <tr class="labelmedium" id="reviewerselect1">
		      <td style="min-width:150px;padding-right:14px" align="right"><cf_tl id="FirstLeaveReviewer">:</td>
			  <td style="padding-right:8px">				  
			   <cfdiv bind="url:#session.root#/attendance/application/leaveRequest/getReviewer.cfm?LeaveType={leavetype}&FieldName=FirstReviewerUserId&PersonNo=#URL.ID#&OrgUnit=#getAssignment.OrgUnit#&HierarchyRootUnit=#getAssignment.HierarchyRootUnit#&Mission=#getAssignment.Mission#&MandateNo=#getAssignment.MandateNo#&PostOrder=#getAssignment.PostOrder#" id="FirstReviewerUserIdBox"/>				 
			  </td>
		  </tr>
				  
		  <tr class="labelmedium" id="reviewerselect2">
			  <td style="padding-right:14px" align="right"><cf_tl id="SecondLeaveReviewer">:</td>
			  <td>				   
			   <cfdiv bind="url:#session.root#/attendance/application/leaveRequest/getReviewer.cfm?LeaveType={leavetype}&FieldName=SecondReviewerUserId&PersonNo=#URL.ID#&OrgUnit=#getAssignment.OrgUnit#&HierarchyRootUnit=#getAssignment.HierarchyRootUnit#&Mission=#getAssignment.Mission#&MandateNo=#getAssignment.MandateNo#&PostOrder=#getAssignment.PostOrder#" id="SecondReviewerUserIdBox"/>									  
			  </td>
		  </tr>
	 
		  <tr class="<cfoutput>#cl#</cfoutput>">
		    <td valign="top" style="padding-top:5px" class="labelmedium"><cf_tl id="Contact Location">:<cfif enf eq "Yes"><font color="FF0000">*</font></cfif></td>
		    <td width="80%" colspan="2">		
			
			<cfinput type="Text" name="contactlocation" class="enterastab regularxl" required="#enf#" message="Enter a contact address" visible="Yes" maxlength="100" style="width:350">
			
			</td>
		  </tr>
		  
		  <tr class="<cfoutput>#cl#</cfoutput>">
		    <td valign="top" style="padding-top:5px" class="labelmedium"><cf_tl id="Phone No">:<cfif enf eq "Yes"><font color="FF0000">*</font></cfif></td>
		    <td width="80%" colspan="2">
			<cfinput type="Text" name="contactcallsign" class="enterastab regularxl" required="#enf#" message="Enter a contact number" visible="Yes" maxlength="20" style="width:200">
			</td>
		  </tr>
		  
		  <tr id="backup1" name="backup">
		    <td width="100" valign="top" style="padding-top:4px" class="labelmedium"><cf_tl id="Handover Notes">:</td>
		    <td width="80%" colspan="2">
			
			     <textarea type="text"
				   class="regular" 
				   name="HandoverNote" 
				   value="" 
				   totlength="400"
				   style="padding:3px;width:100%;height:50;font-size:14px;"
				   onkeyup="return ismaxlength(this)"></textarea>
				   
			</td>
		  </tr>	  		  		  
						  
		  <!---	  		  
		  </cfif>		  
		  --->		  	 
		  
		  <cfif URL.Src eq "Manual">
		  
		  <tr height="100%" class="labelmedium">
		    <td width="100" valign="top" style="padding-top:5px"><cf_tl id="Other Remarks">:</td>
		    <td width="70%" colspan="2">
			<textarea type="text" class="regular" name="Memo" totlength="1000" value="" onkeyup="return ismaxlength(this)" style="padding:3px;font-size:14px;width:98%;height:90"></textarea>
			</td>
		  </tr>
		  		  
		  <cfelse>
		  
		  <tr class="labelmedium">
		    <td width="100" valign="top" style="padding-top:4px"><cf_tl id="Remarks">:</td>
		    <td width="70%" colspan="2">
			<textarea type="text" class="regular" name="Memo" totlength="1000" value="" onkeyup="return ismaxlength(this)" style="padding:3px;font-size:14px;width:100%;height:70"></textarea>
			</td>
		  </tr>		  
		  
		  </cfif>
		  
		  <tr><td height="5"></td></tr>
		  		  
		  <cf_tl id="Save Request" var="1">
		  
		  <tr>
		   
		    <td height="30" colspan="3" align="center">
			    <cfoutput>				
			         <input type="button" name="Submit" id="Submit" 
					     style="font-size:15px;height:30px;width:199px" 
						 onsubmit="return false"
						 onclick="formvalidate()"						 
						 value="#lt_text#" 
						 class="button10g">
				</cfoutput>
		     </td>
		  </tr>
		  
		  <tr><td height="4"></td></tr>
		  
</table>

<cfoutput>

<script>
	getinformation('#url.id#')
</script>
</cfoutput>
	