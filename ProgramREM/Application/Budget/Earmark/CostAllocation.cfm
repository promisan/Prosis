
<cfparam name="url.ProgramCode" default="">
<cfparam name="url.Period"      default="">
<cfparam name="url.EditionId"   default="0">

<cfquery name="Base" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_AllotmentEdition
	WHERE  EditionId = '#url.editionid#' 	
</cfquery>	

<cfquery name="Program" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Program
	WHERE  ProgramCode = '#url.programCode#' 	
</cfquery>	

<cfquery name="Parameter" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_ParameterMission
	WHERE   Mission = '#Program.mission#' 	
</cfquery>	

<cfquery name="Earmark" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_ParameterMissionCategory
	WHERE   Mission       = '#Program.Mission#'
	AND     BudgetEarmark = 1 	
</cfquery>	

<cfif Earmark.recordcount eq "0">

	<cf_message message="Problem. Earmark classes were not identified for #program.mission#" return="No">
	<cfabort>

</cfif>

<cfparam name="url.area"  default="#Earmark.Category#">

<cfquery name="Edition" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_AllotmentEdition E
	WHERE    ControlEdit = 1		
	AND      Mission     = '#Program.Mission#'   	
	AND      Version     = '#Base.Version#' 
	AND      (Period is NULL 
	              or 
		      Period IN (SELECT   Period 
			               FROM   Ref_Period 
						   WHERE  DateEffective >= (SELECT DateEffective 
						                            FROM   Ref_Period  
													WHERE  Period = '#URL.Period#')
						  )							
			 )
	
	ORDER BY ListingOrder, Period	
</cfquery>

<table width="100%" height="100%" cellspacing="0" cellpadding="0" class="formpadding" border="0">
	
<tr class="hide"><td height="1" id="earmarkprocess"></td></tr>

<cfloop query="Edition">

	<cfset url.editionid = editionid>
			
	<cfquery name="Check" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT sum(Amount) as Total
		FROM   ProgramAllotmentDetail
		WHERE  ProgramCode  = '#url.programCode#'
		AND    EditionId    = '#url.editionid#' 	
	</cfquery>	
	
	<cfif check.total eq "0" or check.total eq "">
		
		<cfoutput>
		<tr><td height="10"></td></tr>
	    <tr><td><font color="FF0000">Problem. A planned budget was not recorded for<b>: #Edition.Description#</b></font></td></tr>	
		</cfoutput>
			
	<cfelse>	
		
		<cfif parameter.budgetEarmarkMode eq "0">
		
			<cfquery name="Resource" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT MIN(S.Code) as Code,
					   SUM(P.Amount) AS Amount
				FROM   ProgramAllotmentDetail P INNER JOIN
				       Ref_Object O ON P.ObjectCode = O.Code INNER JOIN
			           Ref_Resource S ON O.Resource = S.Code
				WHERE  P.ProgramCode = '#url.programCode#' 
				  AND  P.Period      = '#url.period#' 
				  AND  P.EditionId   = '#editionid#' 
				  AND  P.Status IN ('0', '1')			
			</cfquery>	
	
		<cfelse>
			
			<cfquery name="Resource" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT DISTINCT S.Code, 
				       S.Name, 
					   S.Description, 
					   S.ListingOrder, 
					   SUM(P.Amount) AS Amount
				FROM   ProgramAllotmentDetail P INNER JOIN
				       Ref_Object O ON P.ObjectCode = O.Code INNER JOIN
			           Ref_Resource S ON O.Resource = S.Code
				WHERE  P.ProgramCode = '#url.programCode#' 
				  AND  P.Period      = '#url.period#' 
				  AND  P.EditionId   = '#editionid#' 
				  AND  P.Status IN ('0', '1')
				GROUP BY S.Code, S.Name, S.Description, S.ListingOrder
				ORDER BY S.ListingOrder	
			</cfquery>	
		
		</cfif>
		
		
		<tr><td height="100%" valign="top">
		
		<table width="99%" cellspacing="0" cellpadding="0" align="center">
		
		<tr><td colspan="3" class="line"></td></tr>
			
			<cfoutput query="resource">
					
				<!--- initialise --->
		
				<cfquery name="Check" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM   ProgramAllotmentEarmark
				WHERE  ProgramCode     = '#url.programCode#' 
				AND    Period          = '#url.period#' 
				AND    EditionId       = '#url.editionid#'
				<cfif parameter.budgetEarmarkMode eq "1">
				AND    Resource        = '#code#'
				</cfif>
				</cfquery>	
		
				<cfif check.recordcount eq "0">
				
					<cfif code neq "">
		
						<cfquery name="Add" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							INSERT INTO ProgramAllotmentEarmark
								(ProgramCode,
								 Period,
								 EditionId,
								 Resource,
								 ProgramCategory,
								 Percentage,
								 OfficerUserid,
								 OfficerLastName,
								 OfficerFirstName)
							SELECT 	 
								 '#url.programCode#',
								 '#url.period#',
								 '#edition.editionid#',
								 '#code#',
								 Code,
								 EarmarkPercentage,
								 '#SESSION.acc#',
								 '#SESSION.last#',
								 '#SESSION.first#' 
								 FROM Ref_ProgramCategory 
								 WHERE  AreaCode = '#url.area#' 
										AND (Parent is not NULL and Parent != '')
						</cfquery>	
					
					</cfif>
		
				</cfif>
				
				<tr>
				    <td colspan="4" height="5"></td>
				</tr>
				<tr><td height="1" colspan="4" class="line"></td></tr>
				
				<tr bgcolor="f4f4f4" height="20">
				    <td>&nbsp;#Edition.Description#</td> 
					<cfif parameter.budgetEarmarkMode eq "1">	
				    <td height="20"  style="background-image:url('#SESSION.root#/Images/gradient_small.jpg'); background-repeat:no-repeat; background-position:left center; padding-left:10px">#Description# #Name#</td>		   
					<cfelse>
					<td></td>
					</cfif>				
					<td align="right" style="padding-right:3px"><b>#numberformat(Amount,'__,__.__')#</b></td>
				</tr>
				
				<tr>
				    <td colspan="3" height="1" class="line"></td>
				</tr>
				
				<cfquery name="Earmark" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *, 
					         (SELECT Percentage 
						       FROM  ProgramAllotmentEarmark
						      WHERE  ProgramCode     = '#url.programCode#' 
					            AND  Period          = '#url.period#' 								
								AND  Resource        = '#code#'								
							    AND  ProgramCategory = P.Code
					            AND  EditionId       = '#url.editionid#') as Percentage
					FROM   Ref_ProgramCategory P
					WHERE  AreaCode = '#url.area#' 
					AND (P.Parent is not NULL and P.Parent != '')
					ORDER BY ListingOrder
				</cfquery>	
						
				<cfset resource = code>
				<cfset amt      = amount>
				<cfset row      = currentrow>
				
				<cfset perc = 0>
				
				<cfloop query="Earmark">
				
					<cfif percentage neq "">
						<cfset perc = perc+percentage>			
					</cfif>
				
					<tr>
					   <td height="23"><font color="0080C0">#Description#</td>
					   <td style="text-align:right">
					  
						   <input type="text" 
						      name="#code#_#currentrow#_percentage" 
							  value="#percentage#" 
							  class="regular" 
							  onchange="earmark('#url.area#','#url.programcode#','#url.period#','#url.editionid#','#resource#','#code#',this.value,'#row#','#currentrow#')"
							  style="width:20px;background-color: f1f1f1;font:11px;height:17px;text-align:right">
							  <font size="1">%</font>		   						  
					   </td>
					   <td id="#url.editionid#_#row#_#currentrow#" align="right" style="font:11px">
					   
					   <cfif percentage neq "">
					   		   
					   		#numberformat((percentage/100)*amt,"__,__.__")#
					   
					   </cfif>
					   
					   </td>   
					</tr>
					
					<tr><td colspan="3">
					<font size="1" color="black">#PARAGRAPHFORMAT(DescriptionMemo)#</font>					
					</td></tr>
									
				</cfloop>
				
					<tr><td colspan="3" class="line"></td></tr>
				
					<tr>
					 
					   <td></td>
					   <td height="22" id="#url.editionid#_#row#_percentage" style="text-align:right">
					   <cfif perc gt 100>
					   <font size="1" color="FF0000">#numberformat(perc,"__._")#%</font>
					   <cfelse>
					   <font size="1">#numberformat(perc,"__._")#%
					   </cfif>
					   </td>
					   <td></td>   
					</tr>		
			
			</cfoutput>
		
		</table>
		</td>
	
		<cfoutput> 
		<td width="570" id="chart_#url.editionid#" height="100%" valign="top">
			<cfinclude template="CostAllocationChart.cfm">
		</td>
		</cfoutput> 
		
		</tr>
		
		<tr><td colspan="2" class="line"></td></tr>
		
		</cfif>
	
	</cfloop>
	
</table>

