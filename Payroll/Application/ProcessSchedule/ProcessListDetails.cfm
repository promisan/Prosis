<cfparam name="URL.SalarySchedule" default="">
<cfparam name="URL.Mission" 	default="">
<cfparam name="URL.PayrollEnd" 	default="">

<CF_DateConvert Value="#url.PayrollEnd#">
<cfset DTE = dateValue>

<cfif URL.salarySchedule neq "" AND URL.Mission neq "" AND URL.PayrollEnd neq ""> 

	<cfquery name="qFinal"
         datasource="AppsEmployee" 
         username="#SESSION.login#" 
         password="#SESSION.dbpw#">
	      SELECT     *
	      FROM       Payroll.dbo.EmployeeSettlement ES INNER JOIN 
	      			 Person P ON ES.PersonNo = P.PersonNo
	      WHERE      ES.PaymentFinal = '1'
	      AND        ES.SalarySchedule = '#URL.SalarySchedule#'    
	      AND        ES.Mission        = '#URL.mission#'
	      AND        ES.PaymentDate    = #DTE#      
		  ORDER BY ES.Source, P.IndexNo             
	</cfquery> 
					
	<table width="100%" height="100%" align="center" class="navigation_table">
		
	<cfoutput>
			
			<cfloop query="qFinal">
				<TR style="height:19px;" class="<cfif currentrow neq recordcount>line</cfif> labelmedium navigation_row">
				
				    <td style="padding-left:8px;padding-top:3px"><cf_img icon="select" onclick="openfinal('#settlementid#','#url.systemfunctionid#')"></td>
					<td style="width:100%"><a href="javascript:EditPerson('#personNo#','','')">#FullName#</a></td>
					<td style="min-width:60">#Contractlevel#</td>
					<td style="min-width:40">#Gender#</td>
					<td style="min-width:40">#Nationality#</td>
					<td style="min-width:80">#Source#</td>
					<td style="min-width:340">
					
						<cfquery name="Unit"
				         datasource="AppsEmployee" 
				         username="#SESSION.login#" 
				         password="#SESSION.dbpw#">
							SELECT   TOP 1 O.OrgUnitName
							FROM     PersonAssignment PA INNER JOIN
				                     Position P ON PA.PositionNo = P.PositionNo INNER JOIN
				                     Organization.dbo.Organization O ON P.OrgUnitOperational = O.OrgUnit
							WHERE    PA.PersonNo = '#personno#' 
							AND      PA.AssignmentStatus in ('0','1') 
							AND      PA.Incumbency > 0
							AND      P.Mission = '#url.mission#'
							AND      PA.DateEffective <= #DTE#
							ORDER BY PA.DateEffective DESC
						</cfquery>
						
						#Unit.OrgUnitName#					
					
					</td>
					<td style="min-width:90">
					
					<cf_wfActive entitycode="FinalPayment" objectkeyvalue4="#settlementid#">	
					
					<cfif wfexist eq "0">															
					<font color="FF0000"><cf_tl id="Pending"></font>
					<cfelseif wfstatus neq "open"><font color="008000"><cf_tl id="Completed"></font>
					<cfelseif actionStatus eq "0"><font color="FF0000"><cf_tl id="In process"></font>
					<cfelseif actionStatus eq "1"><font color="gray"><cf_tl id="Released"></font>
					</cfif>
					
					</td>
				</TR>	
								
			</cfloop>
	
	</cfoutput>	
	
	</table>

</cfif>

<cfset ajaxonload("doHighlight")>