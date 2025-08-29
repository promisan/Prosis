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
			   P.PositionParentId,
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
			
			    <table width="100%" class="formspacing">
				
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
						<input class="regularxl" style="background-color:f1f1f1;text-align: center;" type="text" name="positionno" value="<cfoutput>#Position.PositionNo#</cfoutput>" size="10" maxlength="10" readonly>								
					    <input type="hidden" name="SourcePostnumber" value="<cfoutput>#Position.SourcePostNumber#</cfoutput>">								
		
					</td>
					<TD class="labelmedium"><cf_tl id="Post grade">:</TD>
				    <TD>
					<input type="text" class="regularxl" style="background-color:f1f1f1;text-align: center;" value="<cfoutput>#Position.PostGrade#</cfoutput>" name="postgrade" size="10" maxlength="10" readonly>
					</TD>
					</TR>	
				
				<cfelse>
			
					<TR>
				    <TD style="min-width:120px" class="labelmedium"><cf_tl id="Position">:</TD>
				    <TD>	
					    <input class="regularxl" style="background-color:f1f1f1;text-align: center;" type="text" name="SourcePostnumber" size="10" maxlength="20" value="<cfoutput>#Position.SourcePostNumber#</cfoutput>" readonly>								
						<input type="hidden" name="positionno" value="<cfoutput>#Position.PositionNo#</cfoutput>">	
					</td>
					<TD class="labelmedium"><cf_tl id="Post grade">:</TD>
				    <TD>
					<input type="text" class="regularxl" style="background-color:f1f1f1;text-align: center;" value="<cfoutput>#Position.PostGrade#</cfoutput>" name="postgrade" size="10" maxlength="10" readonly>
					</TD>
					</TR>	
				
				</cfif>	
										
			    <TR>
			    <TD class="labelmedium"><cf_tl id="Functional title">:</TD>
			    <TD colspan="3">
				
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
				<td colspan="3"><input type="text" name="OrgUnit" style="background-color:f1f1f1;text-align: center;" value="<cfoutput>#Position.OrgUnitName#</cfoutput>" readonly size="70" maxlength="80" class="regularxl">		
				</td>
				</TR>		
				
				<tr class="hide"> 		
				
				<TD class="labelmedium" style="cursor:pointer" title="Expected onboarding date refers to the deadline that a department has to fullfill this vacancy"><cf_tl id="Expected onboarding date">:</td>
			    
				<td colspan="3">
					
				  <cfset end = DateAdd("m",  2,  now())> 
				
				  <cf_intelliCalendarDate9
						FieldName="DueDate"							
						Manual="False"		
						Class="regularxl"	
						Default="#Dateformat(end, CLIENT.DateFormatShow)#"
						DateValidStart="#Dateformat(now(), 'YYYYMMDD')#"									
						AllowBlank="False">	  
					 	 
				</td>
				</TR>	
									   			
				<TR bgcolor="ffffff" class="line">
			    <TD colspan="4" style="padding-right:15px;padding-bottom:4px">			
				    <cf_tlhelp SystemModule = "Vacancy" Class = "General" HelpId = "recint" LabelId = "Instructions">			 			
				</TD>	
				
				<!--- hidden by Hanno 24/11/2020 --->
				
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
			    <td colspan="1" class="labelmedium"><cf_tl id="Roster Level">:</td>
					
				<td><cfselect name="GradeDeployment" class="regularxxl">
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
			    <TD class="labelmedium" valign="top" style="padding-top:3px;padding-left:5px;height:48px">
				
								
				<!--- other --->
				
				<cfquery name="opentracks" 
					datasource="AppsVacancy" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT     D.*
					FROM       DocumentPost AS DP INNER JOIN
				               Employee.dbo.Position AS P ON DP.PositionNo = P.PositionNo INNER JOIN
				               [Document] AS D ON DP.DocumentNo = D.DocumentNo
				    WHERE      P.PositionParentId = '#Position.PositionParentid#' 
					AND        D.Status = '0'
				</cfquery>	
				
				<cfset htpe = quotedValueList(opentracks.documenttype)>
				
				 <!--- show only valid options based on the matrix through the entrity class --->
				 
				<cfset list = accesstrack.tracks>
								 
				 <cfset track = quotedvalueList(list.EntityClass)>
								 			    
				 <cfquery name="DocTpe" 
						datasource="AppsVacancy" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">	
					    SELECT   *
						FROM     Ref_DocumentType
						WHERE 1=1
						<cfif track neq "">						
						AND   Code IN (SELECT Code 
						               FROM   Ref_DocumentTypeMatrix 
								       WHERE  EntityClass IN (#preservesingleQuotes(track)#))
						
						</cfif>		
						<cfif htpe neq "">		  
						AND      Code NOT IN (#preservesingleQuotes(htpe)#)				  
						</cfif>
						ORDER BY ListingOrder						
	             </cfquery>		
								
				<select name="DocumentType" required="Yes" class="regularxxl" style="font-weight:bold;background-color:ffffaf;font-size:18px;height:38px" 
				    onchange="ptoken.navigate('<cfoutput>#session.root#/vactrack/application/document/getTrack.cfm?id1=#url.id1#</cfoutput>&documenttype='+this.value,'thisworkflow')">
				    <cfoutput query="DocTpe">
						<option value="#Code#">#Description#</option>
					</cfoutput>
			    </select>			
				</td>
								
			    <TD colspan="3" id="thisworkflow">   
								   
					<cfset url.documenttype = doctpe.code>					
				    <cfinclude template="getTrack.cfm">
																			
				</TD>
				</TR>	
				
				<!--- hidden as we have enough text in the workflow these days --->
				   
				<TR class="hide">
					<td class="labelmedium" valign="top" style="padding-top:4px"><cf_tl id="Remarks">:</td>
					 <TD colspan="3">
					 <textarea style="width:95%;padding:3px;font-size:14px" rows="2" name="Remarks" class="regular" maxlength="200"  onkeyup="return ismaxlength(this)"></textarea>
					</TD>
				</TR>
				
				<tr><td height="1" colspan="4" class="line"></td></tr>
						
				<TR>
					<td height="30" colspan="4" align="center" class="labelmedium">		
					
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
