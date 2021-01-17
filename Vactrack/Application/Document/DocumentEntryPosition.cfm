
<cfparam name="URL.ID"            default="">
<cfparam name="URL.box"           default="">
<cfparam name="URL.portal"        default="0">
<cfparam name="URL.ID1"           default="">
<cfparam name="URL.Caller"        default="">
<cfparam name="DocumentNoTrigger" default="#URL.ID#">

<cfquery name="Position" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT O.*,
		       P.OrgUnitAdministrative,
			   P.PostType,
			   P.SourcePostNumber,
			   P.PostGrade,
			   P.Positionno,
			   P.FunctionNo,
			   P.FunctionDescription
	    FROM   Position P, 
		       Organization.dbo.Organization O
		WHERE  P.PositionNo         = '#url.id1#' 
		AND    P.OrgUnitOperational = O.OrgUnit 
</cfquery>

<cfquery name="Mission" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT *
	  FROM   Ref_Mission M
	  WHERE  M.Mission = '#Position.Mission#'	 		
</cfquery>

<cfinvoke component      = "Service.Process.Vactrack.Vactrack"  
   method                = "verifyAccess" 
   positionno            = "#Position.PositionNo#" 
   orgunitadministrative = "#Position.OrgUnitAdministrative#" 
   orgunit               = "#Position.OrgUnit#" 
   posttype              = "#Position.PostType#"
   returnvariable        = "accessTrack">	       
   
<cfif accessTrack.status eq "0">

	<cf_message return="no" message="#accessTrack.reason#">

<cfelse>

	<cfform action="#session.root#/Vactrack/Application/Document/DocumentEntrySubmit.cfm?portal=#url.portal#&box=#url.box#&ID=#DocumentNoTrigger#&id1=#URL.ID1#"
	  method="POST" style="height:98%" name="documententry" target="result">
	  
		<table width="93%" height="99%" align="center">
		    
		  <tr class="hide"><td><iframe name="result" id="result"></iframe></td></tr>
		 	    
		  <tr>
		    <td width="100%" height="100%">
				
			<cf_divscroll style="height:98%">
			
			    <table width="100%" class="formpadding formspacing">
				
				<cfquery name="Owner" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					  SELECT *
					  FROM   Ref_AuthorizationRoleOwner M
					  WHERE  Code = '#accessTrack.Owner#'	 		
				</cfquery>				
			
				<TR class="xhide">
			    <TD class="labelmedium" height="23"><cf_tl id="Owner"> :</TD>
			    <TD class="labelmedium">
				    <cfoutput>#Owner.Description# / #Position.PostType# / #Position.Mission#
					<input type="hidden" name="Owner"    value="#accessTrack.Owner#">
					<input type="hidden" name="PostType" value="#Position.PostType#">
					<input type="hidden" name="Mission" value="<cfoutput>#Position.Mission#</cfoutput>"
				    </cfoutput>
				</td>
				</TR>		
						
				
				<cfif Position.SourcePostNumber eq "">	
				
					<TR>
				    <TD class="labelmedium"><cf_tl id="PositionNo">:</TD>
				    <TD>
						<input class="regularxl" style="background-color:f1f1f1" type="text" name="positionno" value="<cfoutput>#Position.PositionNo#</cfoutput>" size="8" maxlength="8" readonly style="text-align: center;">								
					    <input type="hidden" name="SourcePostnumber" value="<cfoutput>#Position.SourcePostNumber#</cfoutput>">								
		
					</td>
					</TR>	
				
				<cfelse>
			
					<TR>
				    <TD style="min-width:120px" class="labelmedium"><cf_tl id="Position">:</TD>
				    <TD>	
					    <input class="regularxl" style="background-color:f1f1f1" type="text" name="SourcePostnumber" size="20" maxlength="20" value="<cfoutput>#Position.SourcePostNumber#</cfoutput>" readonly>								
						<input type="hidden" name="positionno" value="<cfoutput>#Position.PositionNo#</cfoutput>">	
					</td>
					</TR>	
				
				</cfif>		
								
				<TR>
			    <TD class="labelmedium"><cf_tl id="Post grade">:</TD>
			    <TD><input type="text" class="regularxl" style="background-color:f1f1f1" value="<cfoutput>#Position.PostGrade#</cfoutput>" name="postgrade" size="10" maxlength="10" readonly>
				</TD>
				</TR>	
						
			    <TR>
			    <TD class="labelmedium"><cf_tl id="Functional title">:</TD>
			    <TD>
				
					<table style="border:1px solid silver">
					<tr><td style="height:15px;padding:0px">
				
					 <cfoutput>
					 
					  <input type="text" 
					         name="FunctionDescription" 
							 id="FunctionDescription"
							 size="50" 
							 style="border:0px;width:98%"
							 class="regularxl" 
							 maxlength="60" 
							 value="#Position.FunctionDescription#" readonly> 
					  
					  	</td>
						<td width="23" align="center">
					     		  
					    <button  type="button" name="btnFunction" class="button3" onClick="selectfunction('webdialog','functionno','functionaltitle','#mission.missionowner#','','')"> 
						  <img src="#SESSION.root#/Images/locate3.gif" alt="Select a function" name="img1" id="img1" width="14" height="14" border="0" align="bottom" style="cursor: pointer;">
						</button>					
				   
					   <input type="hidden" 
					          name="functionno" 
							  id="functionno" 
							  class="disabled" 
							  size="8" 
							  maxlength="6" 
							  value="#Position.FunctionNo#" readonly>	
							  
						</td>	  
							  
					   <input type="hidden" name="documentnotrigger" class="disabled" size="6" maxlength="6" readonly>	
					   
					   </tr></table>
				   
				   </cfoutput>		
			   	  
				</TD>
				</TR>	
					
			    <!--- Field: Unit --->
			    <TR>
			    
			    <td class="labelmedium"><cf_tl id="Unit">:</td>
				<td><input type="text" name="OrgUnit" style="background-color:f1f1f1" value="<cfoutput>#Position.OrgUnitName#</cfoutput>" readonly size="60" maxlength="80" class="regularxl">		
				</td>
				</TR>		
							   			
				<TR bgcolor="ffffff">
			    <TD colspan="2" style="padding-right:15px">			
				    <cf_tlhelp SystemModule = "Vacancy" Class = "General" HelpId = "recint" LabelId = "Instructions">			 			
				</TD>	
				
				<!--- hidden by Hanno 24/11/2020 --->
				
				<tr class="hide"> 		
				
				<TD class="labelmedium"><cf_uitooltip tooltip="Due date on a recruitment request refers to the deadline that a department has to fullfill this vacancy"><cf_tl id="Due date">:</cf_uitooltip></td>
			    
				<td>
					
				  <cfset end = DateAdd("m",  2,  now())> 
				
				  <cf_intelliCalendarDate9
						FieldName="DueDate"
						ToolTip="Due Date" 	
						Manual="False"		
						Class="regularxl"	
						Default="#Dateformat(end, CLIENT.DateFormatShow)#"
						DateValidStart="#Dateformat(now(), 'YYYYMMDD')#"									
						AllowBlank="False">	  
					 	 
				</td>
				</TR>	
					
				<cfquery name="Deployment" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT * 
					FROM   Ref_GradeDeployment
					WHERE  GradeDeployment IN (	
								SELECT 	 DISTINCT FO.GradeDeployment
								FROM     Employee.dbo.Position AS P INNER JOIN
								         FunctionTitle AS FT ON P.FunctionNo = FT.FunctionNo INNER JOIN
								         FunctionOrganization AS FO ON FT.FunctionNo = FO.FunctionNo INNER JOIN
								         Ref_SubmissionEdition AS Se ON FO.SubmissionEdition = Se.SubmissionEdition
								WHERE    Se.Owner = '#accesstrack.owner#' 
								AND      P.PositionNo = '#URL.ID1#'	
							)
					ORDER BY ListingOrder
				</cfquery>
				
				<cfif Deployment.recordcount eq "0">
					
					<cfquery name="Deployment" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT * FROM Ref_GradeDeployment
					WHERE  PostGradeBudget IN (										
							SELECT   DISTINCT PG.PostGradeBudget
							FROM     Employee.dbo.Position AS P INNER JOIN
							                      Employee.dbo.Ref_PostGrade PG ON P.PostGrade = PG.PostGrade
							WHERE    P.PositionNo = '#URL.ID1#'							
							)							
					ORDER BY ListingOrder
					</cfquery>
					
				</cfif>	
				
				<cfif url.portal eq "0">
					
			    <!--- Field: DeploymentLevel --->
			    <TR>
			    <td class="labelmedium"><cf_tl id="Roster Level">:</td>
					
				<td><cfselect name="GradeDeployment" class="regularxl">
				    <option value="">n/a</option>
				    <cfoutput query="Deployment">
						<option value="#GradeDeployment#">#Description#</option>
					</cfoutput>
				    </cfselect>			
				</td>				
				</TR>
				
				<cfelse>
				
				<cfparam name="Form.GradeDeployment" default="">
				
				</cfif>			
			    
			    <TR>
			    <TD class="labelmedium" valign="top" style="padding-top:5px"><cf_tl id="Recruitment modality">:</TD>
			    <TD>   
				
					<cfset list = accesstrack.tracks>
				 		
					<table>		
						<cfset row = "0">
					    <cfoutput query="list">		
						<cfset row = row+1>
						<cfif row eq "1"><tr></cfif>
						<td>
						<input type="radio" name="EntityClass" class="radiol" value="#EntityClass#" <cfif currentRow eq "1">checked</cfif>>
						</td><td class="labelmedium" style="padding-left:5px">#EntityClassName#</td>
						<cfif row eq "1">
						</tr>
						<cfset row = "0">
						</cfif>
						</cfoutput>
					</table>
										
				</TD>
				</TR>	
				
				<!--- hidden as we have enough text in the workflow these days --->
				   
				<TR class="hide">
					<td class="labelmedium" valign="top" style="padding-top:4px"><cf_tl id="Remarks">:</td>
					 <TD>
					 <textarea style="width:95%;padding:3px;font-size:14px" rows="2" name="Remarks" class="regular" maxlength="200"  onkeyup="return ismaxlength(this)"></textarea>
					</TD>
				</TR>
				
				<tr><td height="1" colspan="2" class="line"></td></tr>
						
				<TR>
					<td height="30" colspan="2" align="center" class="labelmedium">		
					
					<cfquery name="PostGradeValidation" 
						datasource="AppsSelection" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT   PostGradeBudget
						FROM     Applicant.dbo.Ref_GradeDeployment
						WHERE   (PostGradeBudget = '#Position.PostGrade#' OR GradeDeployment = '#Position.PostGrade#')
					</cfquery>			
					
					<cfif PostGradeValidation.recordcount neq 0>
						<cf_tl id="Create" var="1">
						<input class="button10g" onclick="document.getElementById('submit').className='hide'" id="submit" style="height:28px;font-size:15px;width:200px" type="submit" name="Submit" value="<cfoutput>#lt_text#</cfoutput>">
					<cfelse>				
						Alert: you may not raise a recruitment track for grade <cfoutput>#Position.PostGrade#</cfoutput>.<br>Check with your assigned focal point.				
					</cfif>		
					
					</td>
				</TR>
			
			</TABLE>
		
		   </cf_divscroll>
		
		</td></tr>
		
		</TABLE>
	
	</CFFORM>
		
</cfif>		

<cfset ajaxonload("doCalendar")>
