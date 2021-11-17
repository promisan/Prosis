
<cf_dialogREMProgram>
<cf_dialogStaffing>

<cf_verifyOperational module="Staffing" Warning="Yes">
<cfif Operational eq "0">
  <cfabort>
</cfif>

<cfoutput>
	
	<script>
	
	 function edit(no) {
		 ptoken.location("EmployeeEdit.cfm?No="+no+"&ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Layout=#URL.Layout#")
	 }
	 
	 function reload(mde) {
	     Prosis.busy('yes')
	     ptoken.location("EmployeeView.cfm?Staffmode="+mde+"&ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Layout=#URL.Layout#") 
	 }
	
	</script>

</cfoutput>

<cfajaximport tags="cfdiv">
<cf_dialogPosition>

<cf_screenTop jquery="Yes" height="100%" html="No" scroll="yes" flush="Yes">

<cfparam name="URL.Layout"    default="Program">
<cfparam name="URL.staffmode" default="current">

<cfform action="EmployeeEntry.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Layout=#URL.Layout#" method="POST" name="employeeentry">
	
	<table width="100%" border="0" bordercolor="silver"><tr><td style="padding:10px">
		<cfset url.attach = "0">
		<cfinclude template="../Header/ViewHeader.cfm">	
	</td></tr>
	
	<tr><td style="padding:10px">
	
		<cfquery name="Program" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Program
		    WHERE  ProgramCode = '#URL.ProgramCode#'	  
		</cfquery>
		
		<cfparam name="url.staffmode" default="">
			
		<table width="99%" align="center" class="navigation_table">
		
		  <tr>
		  	<td colspan="8" height="30" valign="middle">
			
				<table width="100%">
				<tr>
				<td style="height:50;font-size:25px;font-weight:200" class="labellarge"><font color="0080C0"><cf_tl id="Workforce Assignments"></td>
				<td align="right" style="padding-right:10px">
				
				
					<table>
					<tr>
						<td><input onclick="reload('current')" type="radio" name="mode" value="current" class="radiol" <cfif url.staffmode eq "current" or url.staffmode eq "">checked</cfif>></td>
						<td style="padding-left:5px" class="labelmedium"><cfoutput>#dateformat(now(),client.dateformatshow)#</cfoutput></td>
						<td style="padding-left:15px"><input onclick="reload('all')" type="radio" name="mode" value="all" class="radiol" <cfif url.staffmode eq "all">checked</cfif>></td>
						<td style="padding-left:5px" class="labelmedium"><cf_tl id="Current and Past assignments"></td>
						<td></td>
					</tr>
					</table>
								
				</td>
				</tr>
				</table>
						
			</td>			
		  </tr>
		 		  		  
		  <cfquery name="Staff" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		  
		  
			SELECT   DISTINCT 
			         PPF.DateEffective, 
					 PPF.DateExpiration, 
					 O.OrgUnitName, 
					 PPF.Fund, 
					 Pers.PersonNo,
					 Pers.IndexNo, 
					 Pers.LastName, 
					 Pers.FirstName,
					 Pers.Gender, 
					 Pers.Nationality, 
					 Pers.BirthDate, 
			         PA.DateEffective AS AssignmentStart, 
					 PA.DateExpiration AS AssignmentEnd, 
					 PA.Incumbency, 
					 P.PositionNo,
					 P.PostGrade,
					 R.PostOrder,
					 P.FunctionDescription,
					 P.SourcePostNumber,
					 P.PositionParentId
			FROM     PositionParentFunding AS PPF INNER JOIN
			         PositionParent AS PP ON PPF.PositionParentId = PP.PositionParentId INNER JOIN
			         Position AS P ON PP.PositionParentId = P.PositionParentId INNER JOIN
					 Ref_PostGrade AS R ON P.PostGrade = R.PostGrade INNER JOIN
			         PersonAssignment AS PA ON P.PositionNo = PA.PositionNo INNER JOIN
			         Person AS Pers ON PA.PersonNo = Pers.PersonNo INNER JOIN
			         Organization.dbo.Organization AS O ON P.OrgUnitOperational = O.OrgUnit
			WHERE    PP.Mission      = '#Program.Mission#' 
			AND      PPF.ProgramCode = '#URL.ProgramCode#' 
			AND      PA.AssignmentStatus IN ('0','1') 
			
			<cfif url.staffmode eq "current">
			
			AND      PPF.DateEffective <= GETDATE() 
			AND      (PPF.DateExpiration IS NULL OR PPF.DateExpiration > GETDATE()) 
			
			AND      PA.DateEffective   <= GETDATE() 
			AND      PA.DateExpiration  >= GETDATE()
									
			<cfelse>
						
			AND      (PA.DateEffective   <= PPF.DateExpiration or PPF.DateExpiration IS NULL)
			AND      PA.DateExpiration  >= PPF.DateEffective
						
			</cfif>
			
			ORDER BY PostOrder
							  
		 </cfquery>				  
					  
		  <TR class="line labelmedium2 fixlengthlist">
			
			       <td style="width:3%"></td>
				   <td height="15"><cf_tl id="Grade"> </td>
			       <td height="15"><cf_tl id="IndexNo"> </td>				   
				   <TD height="15"><cf_tl id="Name"></TD>
				   <TD height="15"><cf_tl id="G"></TD>
				   <TD height="15"><cf_tl id="Period"></TD>
				   <td height="15"><cf_tl id="Position"></td>
				   <td height="15"><cf_tl id="Title"></td>
			     
		  </TR>
		  
		  <cfif staff.recordcount eq "0">
		  
		  <tr>
		  <td colspan="8" class="labelmedium2" style="height:30" align="center"><font color="808080">There are NO staff assignments recorded for this Program/Project</td>
		  </tr>
		  
		  </cfif>
		  
		  <cfoutput query="Staff">
		 
		   <tr class="navigation_row line labelmedium2 fixlengthlist">
		      <td height="20">	
			    <cfif ProgramAccess eq "EDIT" or ProgramAccess eq "ALL">  
			    <cf_img icon="edit" navigation="Yes" onclick="EditPerson('#PersonNo#')">      	
				<cfelse>
					<!--- nada --->
				</cfif>
		      </td>
			  <td>#PostGrade#</td>
		      <td>#IndexNo#</td>
			  <td>#FirstName# #LastName#</td>
			  <td>#Gender#</td>
			  <td>#DateFormat(AssignmentStart,CLIENT.DateFormatShow)# - #DateFormat(AssignmentEnd,CLIENT.DateFormatShow)#</td>
			  <td colspan="1"><a href="javascript:EditPost('#positionno#')"><font color="6688aa"><cfif SourcePostNumber neq "">#SourcePostNumber#<cfelse>#PositionParentId#</cfif></a></td>	 
			  <td colspan="1">#FunctionDescription#</td>	
		   </tr> 	  
		   	  
		   </cfoutput>  
		  		 
		   <cfquery name="Employee" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT DISTINCT F.*, E.LastName, E.FirstName, E.Gender, E.IndexNo
				FROM   ProgramPeriodOfficer F, Employee.dbo.Person E
			    WHERE  F.PersonNo      =  E.PersonNo
				AND    F.ProgramCode   = '#URL.ProgramCode#'
			    AND    F.Period        = '#URL.Period#'
				AND    F.RecordStatus  = '1'
		  </cfquery>
		
		  <tr><td height="10"></td></tr>	
		  
		  <tr>
		  	<td colspan="8" height="30" valign="middle">
			
				<table width="100%"><tr><td style="height:50;font-size:25px;font-weight:200" class="labellarge"><font color="0080C0"><cf_tl id="Other Project staff">
				</td>				
				
				<cfif ProgramAccess eq "EDIT" or ProgramAccess eq "ALL">
				<td align="right" style="padding-right:30px">
				    <cf_tl id="Add Staff" var="1">
					<INPUT class="button10g" style="height:25px;width:120px" type="submit" value="<cfoutput>#lt_text#</cfoutput>">	
				</td>
				</cfif>
				</tr>
				</table>
				
			</td>			
		  </tr>
		  		  
		  <TR class="line fixlengthlist labelmedium2">			
		       <td></td>
			   <td></td>
		       <td><cf_tl id="IndexNo"> </td>
			   <TD><cf_tl id="Name"></TD>
			   <TD><cf_tl id="G"></TD>
			   <TD><cf_tl id="Period"></TD>
			   <td><cf_tl id="Role"></td>				  	     
		  </TR>
		  	
		  <cfoutput query="Employee">
		 
			   <tr class="navigation_row labelmedium2 linedotted fixlengthlist">
			      <td colspan="2" height="20">	  
				    <cf_img icon="edit" navigation="Yes" onclick="edit('#ProgramOfficerNo#')">      	
			      </td>
			      <td><a href="javascript:EditPerson('#PersonNo#')">#IndexNo#</a></td>
				  <td>#FirstName# #LastName#</td>
				  <td>#Gender#</td>
				  <td>#DateFormat(DateEffective,CLIENT.DateFormatShow)# - #DateFormat(DateExpiration,CLIENT.DateFormatShow)#</td>
				  <td colspan="2">#Remarks#</td>	 
			   </tr> 	  
			   
			   <cfif ProgramDuty neq "">		   
				   <tr class="navigation_row_child linedotted labelmedium2"><td>
				   <td></td>
				   <td colspan="6">#ProgramDuty#</td>
				   </tr>		   
			   </cfif>
		  
		  </cfoutput>  
		   
		</td>
		</tr>
		</table>
	 
	</td>
	</tr>
	</table>
	 
</cfform>

<script>
 Prosis.busy('no')
</script>