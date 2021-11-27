
<!--- Create Criteria string for query from data entered thru search form --->

<cftry>

<CFSET Criteria = ''>
<CF_Search_AppendCriteria
    FieldName="#Form.Crit1_FieldName#"
    FieldType="#Form.Crit1_FieldType#"
    Operator="#Form.Crit1_Operator#"
    Value="#Form.Crit1_Value#">
<CF_Search_AppendCriteria
    FieldName="#Form.Crit2_FieldName#"
    FieldType="#Form.Crit2_FieldType#"
    Operator="#Form.Crit2_Operator#"
    Value="#Form.Crit2_Value#">
<CF_Search_AppendCriteria
    FieldName="#Form.Crit3_FieldName#"
    FieldType="#Form.Crit3_FieldType#"
    Operator="#Form.Crit3_Operator#"
    Value="#Form.Crit3_Value#">	
<CF_Search_AppendCriteria
    FieldName="#Form.Crit4_FieldName#"
    FieldType="#Form.Crit4_FieldType#"
    Operator="#Form.Crit4_Operator#"
    Value="#Form.Crit4_Value#">		
		
	<cfcatch>
	
		<table align="center">
		<tr><td height="30" align="center">
				<font face="Verdana" color="0080FF">An error occurred processing this request.</font>
		</td></tr>
		</table>		
		
		<cfabort>
	
	</cfcatch>	

</cftry>

<cfparam name="Form.Nationality" default="">	

<cfif Form.Nationality IS NOT "">
     <cfif Criteria is ''>
	 <CFSET Criteria = "Nationality IN (#PreserveSingleQuotes(Form.Nationality)# )">
	 <cfelse>
	 <CFSET Criteria = #Criteria#&" AND Nationality IN ( #PreserveSingleQuotes(Form.Nationality)# )" >
     </cfif>
</cfif> 	

<cfparam name="form.Contract" default="0">

<cfoutput>

<cfsavecontent variable="qry">


	FROM  Person P
	<cfif PreserveSingleQuotes(Criteria) neq "">
	WHERE #PreserveSingleQuotes(Criteria)# 
	<cfelse>
	WHERE P.PersonNo is not NULL
	</cfif>
	AND   Operational = 1
	
	<cfif Form.Contract eq "1">
	
	AND PersonNo IN (SELECT PersonNo
	                 FROM   PersonContract 
					 WHERE  PersonNo = P.PersonNo
					 AND    ActionStatus != '9')
					 
	</cfif>
    	
	<cfif Form.OnBoard eq "1">
		
	AND PersonNo IN (SELECT PersonNo 
	                 FROM   PersonAssignment 
					 WHERE  DateExpiration > getDate()
					 AND    PersonNo = P.PersonNo
					 AND    AssignmentStatus IN ('0','1'))
	
	<cfelseif Form.OnBoard eq "0">
	
	AND PersonNo NOT IN (SELECT PersonNo 
	                     FROM   PersonAssignment 
					     WHERE  DateExpiration > getDate()
					     AND    PersonNo = P.PersonNo
					     AND    AssignmentStatus IN ('0','1')) 
	
	</cfif>
	
	<cfif url.filter1value neq "">
	
		<cfif url.filter1 eq "OrgUnit">
			
			<cfif isNumeric(url.filter1value)>
				<cfset vFilterValue = url.filter1value>
			<cfelse>
				<cfset vFilterValue = -1>
			</cfif>
			
			AND PersonNo IN (
					SELECT 	PersonNo
					FROM	PersonAssignment
					WHERE	OrgUnit = '#vFilterValue#'
					AND 	AssignmentStatus IN ('0','1')
				)
		</cfif>
		
		<cfif url.filter1 eq "OrgUnitTree">
				
			<cfif url.filter2value eq 1>
				AND PersonNo IN	(
						SELECT 	PersonNo
						FROM	PersonAssignment
						WHERE	OrgUnit IN (
									SELECT	OrgUnit
									FROM	WorkOrder.dbo.WorkOrderImplementer
									WHERE 	WorkOrderId = '#url.filter1value#')
						AND 	AssignmentStatus IN ('0','1')
						AND     Incumbency > 0
						AND     AssignmentType = 'Actual'
					)
			</cfif>
				
		</cfif>
		
		<cfif url.filter1 eq "WorkSchedule">		
				
				AND PersonNo IN
				(
					SELECT 	PersonNo
					FROM	PersonAssignment
					WHERE	AssignmentStatus IN ('0','1')
					AND     Incumbency > 0
					AND     AssignmentType = 'Actual'
					
					<!--- person is working on that date --->
					AND		DateEffective  <= CAST('#url.filter2value#' as datetime)
					AND		DateExpiration >= CAST('#url.filter2value#' as datetime)
					
					<!--- valid position for the workSchedule settings --->															
					AND 	PositionNo IN 
										(
											SELECT 	P.PositionNo 
											FROM 	WorkSchedulePosition WSP INNER JOIN Position P ON WSP.PositionNo = P.PositionNo 
											WHERE 	WSP.WorkSchedule = '#url.filter1value#'
											<!--- enabled position for the selection date --->
											AND		WSP.CalendarDate  = CAST('#url.filter2value#' as datetime)
											<!--- AND is still valid position for the selection date --->
											AND		P.DateEffective  <= CAST('#url.filter2value#' as datetime)
											AND		P.DateExpiration >= CAST('#url.filter2value#' as datetime)		
											AND     P.OrgUnitOperational IN	
																			(
																				SELECT	OrgUnit
																				FROM	WorkOrder.dbo.WorkOrderImplementer
																				WHERE 	WorkOrderId = '#url.filter3value#'
																			)																											
										 )
										  
										  
				)
				
		</cfif>
	
	</cfif>
		
</cfsavecontent>
</cfoutput>

<cfquery name="Total" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT count(*) as Total 
    #preserveSingleQuotes(qry)#	
</cfquery>

<cfset show = int((url.height-390)/25)>

<cf_pagecountN show="#show#" 
               count="#Total.Total#">
			   
<cfset counted  = total.total>		

<cfquery name="SearchShow" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TOP #last# *, 
	        (SELECT TOP (1) PO.Mission
		    FROM   PersonAssignment AS PA INNER JOIN
                   Position AS PO ON PA.PositionNo = PO.PositionNo
			WHERE  PA.PersonNo = P.PersonNo 
			AND    PA.DateExpiration > GETDATE() 
			AND    PA.AssignmentStatus IN ('0', '1')
			ORDER BY PA.DateEffective ) as Mission,
			
			(SELECT TOP (1) PO.FunctionDescription
		    FROM   PersonAssignment AS PA INNER JOIN
                   Position AS PO ON PA.PositionNo = PO.PositionNo
			WHERE  PA.PersonNo = P.PersonNo 
			AND    PA.DateExpiration > GETDATE() 
			AND    PA.AssignmentStatus IN ('0', '1')
			ORDER BY PA.DateEffective ) as FunctionTitle
		
    #preserveSingleQuotes(qry)#	
	ORDER BY LastName, FirstName, MiddleName 
</cfquery>

<!--- check access --->
				
<cfinvoke component = "Service.Access"  
   method           = "staffing" 		  
   returnvariable   = "accessStaffing">	  

<table width="98%" border="0" height="100%" id="t_result"> 
  
  <tr><td colspan="2" valign="top" height="100%">
  
		<table width="100%" height="100%" class="navigation_table">
		
			<cfset link    = replace(url.link,"||","&","ALL")>
			<cfset currrow = 0>	
			
			<!--- example for contributioj to allow quick adding --->
			
			<cfif findNoCase("insert=yes",url.link)>
			
			<tr>
			   <td height="28" class="labelmedium" colspan="7" style="padding-left:8px">
				   <table width="100%">
					   <tr>
						  
						  <cfoutput>
						   <td class="labelmedium" >
						      <a href="javascript:lookuppersonadd('#url.box#','#link#')"><u><cf_tl id="Register a new individual"></a>
						   </td>
						  </cfoutput> 
						   
					   </tr>
				   </table>
			   </td>
			   <td align="right"></td>
			</tr> 	
			
			</cfif>
		
			<cfif searchshow.recordcount eq "0">
			
				<tr><td height="14" align="center" colspan="7" class="labelmedium">
					<cf_tl id="There are no records to show in this view">
				</td></tr>
				
			<cfelse>
			
				<tr><td colspan="8">
					 <cfinclude template="EmployeeNavigation.cfm">
				</td></tr>
				
				<tr><td valign="top" colspan="8" height="100%">
				
				<cf_divscroll>
				
				<table width="100%">
								
				<TR class="labelmedium line fixrow fixlengthlist">
				    <td height="20"></td>		   
					<TD><cf_tl id="Name"></TD>
					<TD><cf_tl id="Function"></TD>
					<!---
				    <TD><cf_tl id="Nat."></TD>
					--->
					<TD style="min-width:30px"><cf_tl id="S"></TD>
					<TD><cf_tl id="Index No"></TD>	
					<cfif accessstaffing neq "NONE">								
					<TD style="min-width:70px"><cf_tl id="Id"></TD>
					</cfif>
					<!---
					<TD><cf_tl id="DOB"></TD>
					<TD><cf_tl id="Org. start"></TD>
					--->
					
				</TR>
							
				<CFOUTPUT query="SearchShow">
				
				<cfset currrow = currrow + 1>
				 
				<cfif currrow lte last and currrow gte first>		
							
					<TR class="navigation_row labelmedium fixlengthlist" style="height:22px">
						
						<TD width="30" align="center" style="padding-top:3px"
						  class="navigation_action"
						  onclick="ptoken.navigate('#link#&action=insert&#url.des1#=#personno#','#url.box#','','','POST','');<cfif url.close eq 'Yes'>ProsisUI.closeWindow('dialog#url.box#')</cfif>">			
							<cf_img icon="select">				  
						</TD>						
						<TD>#LastName#, #FirstName# #MiddleName#</TD>
						<TD>#FunctionTitle#</TD>				
						<TD>#Gender#</TD>			
						<cfif accessstaffing neq "NONE">
							<TD>#IndexNo#</TD>			
							<td onclick="EditPerson('#PersonNo#','#IndexNo#')">#PersonNo#</td>				
						<cfelse>
							<TD>#IndexNo#</TD>						
						</cfif>
						
					</TR>
					
					<cfif OrganizationName neq "">
						<tr class="navigation_row_child">
							<td></td>
							<cfif accessstaffing neq "NONE">
								<td colspan="7" class="labelit">#OrganizationName#</td>
							<cfelse>
								<td colspan="4" class="labelit">#OrganizationName#</td>
							</cfif>
						</tr>	
					</cfif>
					
					<tr><td colspan="11" class="line"></td></tr>
					
				</cfif>
				
				</CFOUTPUT>			
				
				</table>
				
				</cf_divscroll>
				
			</td>
			</tr>	
	
			<cfif searchshow.recordcount neq "0">	
			<tr><td height="24" colspan="8">
			     <cfinclude template="EmployeeNavigation.cfm">
			</td></tr>	
			</cfif>
	
		</TABLE>
		
		</cfif>

	</td></tr>

</table>

<cfif searchshow.recordcount gt 0>
	<cfset AjaxOnLoad("doHighlight")>
</cfif>

