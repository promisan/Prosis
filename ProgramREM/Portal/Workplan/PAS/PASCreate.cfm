

<!---
<cf_screentop height="100%" layout="webapp" label="Add PAS" user="no" scroll="no">

<cf_dialogPosition>
--->

<cfparam name="URL.Box" default="">
<cfparam name="URL.AssignmentNo" default="">
<cfparam name="URL.Mission" default="">

<cfquery name="PAS" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT   PA.*,
	         O.Mission, 
			 O.MandateNo, 
			 P.PostGrade, 
			 O.OrgUnitName AS OrgUnitName, 
			 O.HierarchyCode, 
			 P.SourcePostNumber,
			 P.PositionParentId
	FROM     PersonAssignment PA INNER JOIN
             Position P ON PA.PositionNo = P.PositionNo INNER JOIN
             Organization.dbo.Organization O ON PA.OrgUnit = O.OrgUnit
    WHERE    PA.AssignmentNo = '#URL.AssignmentNo#'	
</cfquery>	

<cf_divscroll>

<cfform action="#SESSION.root#/ProgramREM/Portal/Workplan/PAS/PASCreateSubmit.cfm?AssignmentNo=#url.assignmentNo#&box=#url.box#" 
   target="result" method="POST" name="documententry">	     
   
<table width="98%"  align="center" class="formpadding">
		 
	<cfquery name="Person" 
	    datasource="AppsEmployee" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT   *
		FROM     Person
    	WHERE    PersonNo = '#PAS.PersonNo#'	
	</cfquery>	
	
	<cfquery name="Nation" 
	    datasource="AppsSystem" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_Nation
	    WHERE    Code  = '#Person.Nationality#'	
	</cfquery>	
	
	<tr><td></td></tr>
	
	<tr>
	    <td width="100%">
	    <table width="100%" class="formpadding formspacing">
	
		<cfoutput query="Person">		
								
			<TR class="LabelMedium">
		    <TD style="padding-left:5px;min-width:180px"><cf_tl id="Employee">:</TD>
		    <TD style="font-size:15px;width:100%">#LastName#, #FirstName# #IndexNo# (#Gender#)</td>
			</TR>	
												
			<TR class="LabelMedium">
		    <TD style="padding-left:5px"><cf_tl id="Nationality">:</TD>
		    <TD style="font-size:15px;width:100%">#Nation.Name#</td>
			</TR>					
			
			<TR class="LabelMedium">
		    <TD style="padding-left:5px"><cf_tl id="DOB">:</TD>
		    <TD style="font-size:15px;width:100%">#dateformat(BirthDate,CLIENT.DateFormatShow)#</td>
			</TR>		
				
		</cfoutput>
		   
		<cfoutput query="PAS">
							
			<TR class="LabelMedium">
		    <TD style="padding-left:5px"><cf_tl id="Position">:</TD>
		    <TD style="font-size:15px;width:100%">#positionparentid# <cfif SourcePostNumber neq "">(#SourcePostNumber#)</cfif></td>
			</TR>	
										
			<TR class="LabelMedium">
		    <TD style="padding-left:5px"><cf_tl id="Unit">:</TD>
		    <TD style="font-size:15px;width:100%">#Mission#/#OrgUnitName#
					
			
			<TR class="LabelMedium">
		    <TD style="padding-left:5px"><cf_tl id="Function">:</TD>
		    <TD style="font-size:15px;width:100%">#FunctionDescription#</td>
			</TR>	
			
			<!---
			<TR class="LabelMedium">
		    <TD style="padding-left:5px"><cf_tl id="Incumbency">:</TD>
		    <TD>#Incumbency#%</td>
			</TR>
			--->	
			
			<cfquery name="Class" 
			datasource="AppsEPAS" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Ref_ContractClass
				WHERE  Operational = 1		
				ORDER BY ListingOrder			
			</cfquery>
			
			<TR class="LabelMedium">
		    <TD style="padding-left:5px"><cf_tl id="Class">:</TD>
		    <TD style="font-size:15px;width:100%">
			
			<select name="ContractClass" class="regularxl">
				<cfloop query="Class">
				   <option value="#Code#">#Description#</option>
				</cfloop>			
			</select>			
			
			</td>
			</TR>	
						
						
			<cfquery name="Cycle" 
			datasource="AppsEPAS" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Ref_ContractPeriod
				WHERE  Mission = '#Pas.Mission#' 
				AND    PASPeriodEnd >= '#Dateformat(DateEffective, CLIENT.DateSQL)#'			
			</cfquery>
			
			<TR class="LabelMedium">
		    <TD style="padding-left:5px"><cf_tl id="Performance Cycle">:</TD>
		    <TD style="font-size:15px;width:100%">
			
			<select name="period" id="period" class="regularxl">
				<cfloop query="Cycle">
				   <option value="#Code#">#Code#</option>
				</cfloop>			
			</select>			
			
			</td>
			</TR>	
			
			<tr style="height:0px">
			    <td></td>
				<td><cfdiv bind="url:#session.root#/programREM/Portal/Workplan/PAS/getPAS.cfm?personNo=#Pas.PersonNo#&period={period}" id="prior"></td>
			</tr>
					
			<TR class="LabelMedium">
		    <TD style="padding-left:5px"><cf_tl id="Period">:</TD>
		    <TD style="font-size:15px;width:100%">
			
					<table cellspacing="0" cellpadding="0">
					<tr>
					<td width="140">
					
							<cf_intelliCalendarDate9
								FieldName="DateEffective" 
								class="regularxl"
								Default="#Dateformat(DateEffective, CLIENT.DateFormatShow)#"
								AllowBlank="False">	
							
					</td>
					<td width="1">-</td>
					<td width="140">
							<cf_intelliCalendarDate9
								FieldName="DateExpiration" 
								Default="#Dateformat(DateExpiration, CLIENT.DateFormatShow)#"
								class="regularxl"
								AllowBlank="False">	
					</td>
					</tr>
					</table>
			
			</td>
			</TR>
			
			<cfloop index="RoleFunction" list="FirstOfficer,SecondOfficer">
							
				<tr class="labelmedium">
				    <td height="24" style="min-width:200px;padding-left:5px"><cf_tl id="#RoleFunction#">:</td>
					<td>
					
					<table>
					<tr class="labelmedium">					
					<td id="member_#RoleFunction#" style="border:1px solid silver;padding-left:5px;background-color:e1e1e1;min-width:300px"></td>					
					<td style="padding-left:4px">				
					
					<cfset link = "#SESSION.root#/ProgramREM/Portal/Workplan/PASEntry/setPerson.cfm?function=#rolefunction#">	
								
					 <cf_selectlookup
					    class      = "Employee"
					    box        = "member_#RoleFunction#"
						button     = "no"
						icon       = "search.png"
						iconwidth  = "22"
						iconheight = "22"
						title      = "#lt_text#"
						link       = "#link#"						
						close      = "Yes"
						des1       = "PersonNo">
																					
					</td>
					
					<cf_tl id="#RoleFunction#" var="1">	
					
					<td class="hide">
						<cfinput type="text" name="#RoleFunction#" value="" message="Please record a #lt_text#" required="Yes" id="#RoleFunction#">						
						</td>		
					
					</tr>
					</table>
					</td>
			    </tr>
				
			</cfloop>	
			
			<tr class="labelmedium"><td style="min-width:200px;padding-left:5px" colspan="2"><cf_tl id="Observations">:</td></tr>
						
				<tr class="labelmedium">			    
			        <td colspan="2" style="padding-left:10px"><textarea style="font-size:13px;padding:3px;border-radius:1px;height:60px;width:96%" class="regular" name="Objective"></textarea></td>
			    </tr>	
					
						
			<TR>
				<td colspan="2" align="center">
					<table class="formspacing">
					<tr>
					<td><cf_tl id="Cancel" var="1">
					<input class="button10g" type="button" name="cancel" value="<cfoutput>#lt_text#</cfoutput>" onClick="try {ProsisUI.closeWindow('mypasdialog');} catch(e) { window.close(); }">						
					</td>
					<td><cf_tl id="Create" var="1">
					<input class="button10g" type="submit" name="Submit" value="<cfoutput>#lt_text#</cfoutput>">
					</td>
					</tr>
					</table>			
				</td>
			</TR>
		
		</TABLE>
		
		</td></tr>
		
		<tr class="hide"><td height="1"><iframe name="result" id="result"></iframe></td></tr>
		
		</cfoutput>	 

</TABLE>

</CFFORM>

</cf_divscroll>

<cf_screenbottom layout="webapp">

<cfset ajaxonload("doCalendar")>