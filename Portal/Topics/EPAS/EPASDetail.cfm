
<cfinclude template="EPASPreparation.cfm">
	
<cfquery name="getStaffDetail" 
		datasource="AppsEPas" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
			
		
		SELECT ContractId,
		       P.FirstName,
		       P.LastName, 
			   P.Nationality, 
			   P.PersonNo,
			   P.IndexNo,
			   P.Gender, 
			   D.Initiated,
			   D.WithActivities,
			   D.Submit,
			   D.Cleared,
			   <cfloop index="itm" list="midterm,final">
			   D.#itm#,
			   </cfloop>	
			   D.complete,
			   D.ContractOrgUnit,
			   D.ContractOrgUnitName,
			   D.AssignmentOrgUnit,
			   D.AssignmentOrgUnitName,
			   F.PersonNo  as FROPersonNo,
			   F.IndexNo   as FROIndexNo,		   
			   F.FirstName as FROFirstName, 
			   F.LastName  as FROLastName
		
		FROM   (
		
				 #preserveSingleQuotes(BaseQuery)#						
															   
			   ) AS D														   
					
		INNER JOIN      Employee.dbo.Person P ON D.PersonNo = P.PersonNo
		LEFT OUTER JOIN Employee.dbo.Person F ON D.ReportingPersonNo = F.PersonNo 
		ORDER BY P.fullname ASC  
		
</cfquery>		

<cfif url.type eq "Issued">
	<cfquery name="getStaffDetailFiltered" dbtype="query">
		  	SELECT  *
		 	FROM    getStaffDetail		
			WHERE   AssignmentOrgUnit is not NULL				
			AND     Initiated = 0  	
	 </cfquery>	
<cfelseif url.type eq "Initiated">
	<cfquery name="getStaffDetailFiltered" dbtype="query">
		  	SELECT  *
		 	FROM    getStaffDetail	
		 	WHERE 	AssignmentOrgUnit is not NULL 
			AND     Initiated > 0  and 	WithActivities = 0 
	 </cfquery>	
<cfelseif url.type eq "WorkPlan">
	<cfquery name="getStaffDetailFiltered" dbtype="query">
		  	SELECT  *
		 	FROM    getStaffDetail	
		 	WHERE 	AssignmentOrgUnit is not NULL 
			AND     WithActivities > 0  and Submit = 0	
	 </cfquery>	
<cfelseif url.type eq "Submit">
	<cfquery name="getStaffDetailFiltered" dbtype="query">
		  	SELECT  *
		 	FROM    getStaffDetail	
		 	WHERE 	AssignmentOrgUnit is not NULL 
			AND     Submit > 0 and Cleared = 0 	  	
	 </cfquery>	
<cfelseif url.type eq "Cleared">
	<cfquery name="getStaffDetailFiltered" dbtype="query">
		  	SELECT  *
		 	FROM    getStaffDetail	
		 	WHERE 	AssignmentOrgUnit is not NULL 
			AND     Cleared > 0 and Midterm = 0 			  	
	 </cfquery>	
<cfelseif url.type eq "Midterm">
	<cfquery name="getStaffDetailFiltered" dbtype="query">
		  	SELECT  *
		 	FROM    getStaffDetail	
		 	WHERE 	AssignmentOrgUnit is not NULL 
			AND     Midterm > 0  and Final = 0		
	 </cfquery>	
<cfelseif url.type eq "Final">
	<cfquery name="getStaffDetailFiltered" dbtype="query">
		  	SELECT  *
		 	FROM    getStaffDetail	
		 	WHERE 	AssignmentOrgUnit is not NULL 
			AND     Final > 0  and complete = 0	  	
	 </cfquery>	
<cfelseif url.type eq "complete">
	<cfquery name="getStaffDetailFiltered" dbtype="query">
		  	SELECT  *
		 	FROM    getStaffDetail	
		 	WHERE 	AssignmentOrgUnit is not NULL 
			AND     complete > 0  	  	
	 </cfquery>		 
</cfif>

<cfset session.broadcastcontractid = quotedvalueList(getStaffDetailFiltered.ContractId)>

<table width="100%" height="250">
	<tr class="line">
		<td class="labelmedium" style="font-weight:200px">
		
		<table>
			<tr>
			<td class="labelmedium" style="font-weight:200px">		
			<cf_tl id="At stage"><cfoutput>#ucase(url.type)# <span style="font-size:80%">[ #numberFormat(getStaffDetailFiltered.recordCount, ',')# ]</span></cfoutput>		
			</td>
			<td style="padding-left:16px"><a href="javascript:broadcastpas()"><cf_tl id="Send Broadcast message"></a></td>
			</tr>
		</table>
		
		</td>
	</tr>
	<tr class="line">
		<td class="labellarge">
			
			<cfinvoke component = "Service.Presentation.TableFilter"  
			   method           = "tablefilterfield" 
			   filtermode       = "direct"
			   name             = "filtersearch"
			   style            = "font:14px;height:25;width:160px;"
			   rowclass         = "clsFilterRowEPAS"
			   rowfields        = "ccontentEPAS">
		</td>
	</tr>
	<tr>
		<td height="100%" valign="top">
			<cf_divScroll width="100%" height="100%">
				<table width="98%" class="navigation_table">
					<cfoutput query="getStaffDetailFiltered">
						<tr class="navigation_row line labelmedium clsFilterRowEPAS" style="height:18px">
							<td width="2%">#currentrow#.</td>
							<td width="5%" class="navigation_action ccontentEPAS"><a href="javascript:pasdialog('#ContractId#')">#IndexNo#</a></td>
							<td class="ccontentEPAS">#firstname#</td>
							<td class="ccontentEPAS">#lastname#</td>
							<td class="ccontentEPAS">#nationality#</td>		
							<td class="ccontentEPAS">#ContractOrgUnitName#</td>						
							<td width="5%" class="navigation_action ccontentEPAS"><a href="javascript:EditPerson('#FROPersonNo#','','')">#FROIndexNo#</a></td>
							<td class="ccontentEPAS">#frofirstname#</td>
							<td class="ccontentEPAS">#frolastname#</td>							
						</tr>
					</cfoutput>
					<cfif getStaffDetailFiltered.recordCount eq 0>
						<tr>
							<td align="center" style="padding:15px; font-weight:200; font-size:25px;" class="labellarge">
								[ <cf_tl id="No data"> ]
							</td>
						</tr>
					</cfif>
				</table>
			</cf_divScroll>
		</td>
	</tr>
</table>

<cfset ajaxOnLoad("doHighlight")>