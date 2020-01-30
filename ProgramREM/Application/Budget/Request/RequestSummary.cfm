
<cfparam name="url.summarymode" default="parent">
<cfparam name="url.history"     default="yes">
<cfparam name="url.activityid"  default="">

<!--- used for reloading the summary --->
<cfoutput>
<input type="hidden" id="summaryselectmode" value="#url.summarymode#">
</cfoutput>

<cfif url.summarymode eq "parent">

	<cfquery name="Period" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">							  
	  SELECT OrgUnit
	  FROM   Program.dbo.ProgramPeriod
	  WHERE  ProgramCode = '#url.ProgramCode#'		
	  AND    Period      = '#url.period#'										
	</cfquery>
				
	<cfquery name="GetRoot" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">				
		SELECT  Par.OrgUnit, Par.OrgUnitName, Par.OrgUnitNameShort, Par.HierarchyCode
		FROM    Organization AS O INNER JOIN
              		Organization AS Par ON O.HierarchyRootUnit = Par.OrgUnitCode AND O.Mission = Par.Mission AND O.MandateNo = Par.MandateNo
		WHERE   O.OrgUnit = '#period.orgunit#'
		
	</cfquery> 

	<cfquery name="Parent" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">				
		SELECT  *
		FROM    Organization 
		WHERE   OrgUnit = '#getRoot.orgunit#'					
	</cfquery> 

	<cfquery name="Unit" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   ProgramCode
		FROM     ProgramPeriod
		WHERE    Period = '#url.period#'
		AND      RecordStatus != '9'
		
		AND      OrgUnit IN (
		                    SELECT  DISTINCT OrgUnit
							FROM    Organization.dbo.Organization
							WHERE   Mission      = '#parent.mission#'
							AND     MandateNo    = '#parent.mandateno#'
							AND     HierarchyCode LIKE '#parent.hierarchycode#%'
							)
		
		
	</cfquery>
		
	<cfif unit.recordcount gt "0">	
		<cfset programselect = quotedvaluelist(Unit.ProgramCode)>
	<cfelse>
		<cfset programselect = "''">
	</cfif>
 
<cfelseif url.summarymode eq "unit">

	<!--- 19/8/2015 adjusted in order to reflect all programs under the orgunit using the hierarchy --->
		
	<cfquery name="Unit" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   ProgramCode
		FROM     ProgramPeriod
		WHERE    Period = '#url.period#'
		AND      RecordStatus != '9'		
		AND      OrgUnit IN (SELECT   OrgUnit
						 	 FROM     ProgramPeriod
                     		 WHERE    ProgramCode = '#url.programcode#'
                    		 AND      Period      = '#url.period#')
							
	</cfquery>
		
	<cfif unit.recordcount gt "0">	
		<cfset programselect = quotedvaluelist(Unit.ProgramCode)>
	<cfelse>
		<cfset programselect = "''">
	</cfif>
	
<cfelseif url.summarymode eq "activity">

   <cfset programselect = "'#url.programcode#'">

<cfelse>

	<cfset programselect = "'#url.programcode#'">
	
</cfif>

<cf_tl id="Within Scope" var="1">
<cfset vInBudget=lt_text>

<cf_tl id="Outside Scope" var="1">
<cfset vOutBudget=lt_text>

<cf_tl id="Total Overall" var="1">
<cfset vOverAll=lt_text>

<cf_tl id="Available" var="1">
<cfset vAvailable=lt_text>
	
<cfquery name="Edition" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		  SELECT *
		  FROM   Ref_AllotmentEdition
		  WHERE  EditionId    = '#URL.EditionId#'		
</cfquery> 

<cfquery name="Parameter" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_ParameterMission
	WHERE    Mission = '#Edition.Mission#'
</cfquery>

<table width="99%" align="center" cellspacing="0" cellspacing="0" border="1" style="border:1px solid gray">

<tr><td valign="top">
	
<cfif Parameter.BudgetCeiling eq "Resource">	
	
		<!--- celing enabled per program/resource --->
		
		<table width="99%"
	       border="0"
	       cellspacing="0"
	       cellpadding="0">
		   
		 <tr bgcolor="E6E6E6" class="line labelit" style="height:15px">  
				<td style="border-right:1px solid silver;padding-left:10px"><cf_tl id="resource"></td>
				<td align="right" style="border-right:1px solid silver;min-width:60;padding-right:3px"><cf_tl id="ceiling"></td>
				<td align="right" style="min-width:60;padding-right:3px"><cf_tl id="request">
			</tr>		  
		
		<!--- check requested for ceiling sources --->
		
		<cfquery name="InBudget" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		 SELECT   * 
		 FROM     Ref_ParameterMissionResource
		 WHERE    Mission = '#edition.Mission#'				
		 AND      Ceiling = 1		  
		</cfquery>	  
		
		<cfset res =  QuotedValueList(InBudget.Resource)> 
			
		<cfquery name="Resource" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		      SELECT  O.Resource, S.Name, S.Description,
			  	      	(SELECT sum(Amount) 
						  	FROM ProgramAllotmentCeiling  
						   	WHERE  ProgramCode IN (#preservesinglequotes(programselect)#)
							AND    Period       = '#URL.Period#'
						    AND    EditionId    = '#URL.EditionId#' 
							AND Resource = O.Resource) as Ceiling,						
					  SUM(A.RequestAmountBase) as Amount
			  FROM    ProgramAllotmentRequest A INNER JOIN
			  		  ProgramAllotment R ON A.ProgramCode = R.ProgramCode AND A.Period = R.Period AND A.EditionId = R.EditionId INNER JOIN
                      Ref_Object O ON A.ObjectCode = O.Code INNER JOIN
                      Ref_Resource S ON S.Code = O.Resource	
			  WHERE   A.ProgramCode  IN (#preservesinglequotes(programselect)#)
			   <cfif url.summarymode eq "activity">
			    AND   A.ActivityId = '#url.activityid#'
			   </cfif>
				AND   A.Period       = '#URL.Period#'
			    AND   A.EditionId    = '#URL.EditionId#'	
				AND   A.ActionStatus != '9'
				<cfif res neq "">						  
				AND   S.Code IN (#preservesinglequotes(res)#)	
				<cfelse>
				AND 1 =0 				    				
				</cfif>
			 GROUP BY O.Resource, S.Description, S.Name,S.ListingOrder
			 ORDER BY S.ListingOrder					 							  
		</cfquery> 
		
		<cfoutput query="Resource">
		
		    <cfif amount gt ceiling>
			<tr class="labelit line" bgcolor="FFD6C1">	
			<cfelse>
			<tr class="labelit line" bgcolor="ffffef">
			</cfif>		    
			<td style="padding-left:10px">#Name#</td>
			<td align="right" style="min-width:60">#numberformat(Ceiling,"__,__")#</td>
			<td align="right" style="min-width:60;padding-right:6px;">#numberformat(Amount,"__,__")#
		    </tr>		
						   
		</cfoutput>			
		
		<cfquery name="Total" dbtype="query">
			SELECT  SUM(Ceiling) as Ceiling, 					
					SUM(amount) as Amount
			FROM    Resource
		</cfquery> 
		
		<cfoutput query="Total">
			
		    <cfif amount gt ceiling>
			<tr class="labelit line" bgcolor="FFD6C1">	
			<cfelse>
			<tr class="labelit line" bgcolor="ffffef">
			</cfif>		    
			<td height="20" style="padding-left:10px">#vInBudget#</td>
			<td align="right" style="min-width:60">#numberformat(Ceiling,"__,__")#</td>
			<td align="right" style="padding-right:6px;min-width:60;">#numberformat(Amount,"__,__")#</td>
		    </tr>		
											   
		</cfoutput>	
		
		<!--- not ceiling enabled : extra budget --->
	
		<cfquery name="Resource" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		      SELECT  O.Resource, S.Name, S.Description,SUM(A.RequestAmountBase) as Amount
			  FROM    ProgramAllotmentRequest A INNER JOIN
			  		  ProgramAllotment R ON A.ProgramCode = R.ProgramCode AND A.Period = R.Period AND A.EditionId = R.EditionId INNER JOIN
			  		  <!--- removed the outerjoin to show only relevant groups --->
                      Ref_Object O ON A.ObjectCode = O.Code INNER JOIN
                      Ref_Resource S ON S.Code = O.Resource 	
			  WHERE   A.ProgramCode  IN (#preservesinglequotes(programselect)#)
			   <cfif url.summarymode eq "activity">
			    AND   A.ActivityId = '#url.activityid#'
			   </cfif>
				AND   A.Period       = '#URL.Period#'
			    AND   A.EditionId    = '#URL.EditionId#'	
				AND   A.ActionStatus != '9'
				<cfif res neq "">						  
				AND   S.Code NOT IN (#preservesinglequotes(res)#)		
				<cfelse>
				AND 1 = 1 				    				
				</cfif>						
			 GROUP BY O.Resource, S.Description, S.Name,S.ListingOrder
			 ORDER BY S.ListingOrder					 							  
		</cfquery> 
		
		<cfoutput query="Resource">
		    <tr class="cellmedium line" bgcolor="ffffff">	
			<td height="20" style="padding-left:10px"><cfif len(name) gt "20">#Name#..<cfelse>#Description#</cfif></td>
			<td align="right" style="padding-right:3px"></td>
			<td align="right" style="padding-right:3px;">#numberformat(Amount,",__")#
		    </tr>								   
		</cfoutput>	
		
		<cfquery name="Total" dbtype="query">
			SELECT	SUM(amount) as Amount
			FROM    Resource
		</cfquery> 
				
		<cfoutput query="Total">
		
		    <tr class="labelmedium" bgcolor="ffffcf">	
				<td height="20" style="padding-left:3px;min-width:100px">#vOutBudget#</td>
				<td align="right" colspan="2" style="padding-right:3px;">#numberformat(amount,",")#</tr>				
						
		</cfoutput>	

		</table>		

<cfelse>

    <!--- --------------- --->
	<!--- program roll-up --->
	<!--- --------------- --->
								
	<cfquery name="Ceiling" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		  SELECT sum(Amount) as Amount
		  FROM   ProgramAllotmentCeiling
		  WHERE  ProgramCode   IN (#preservesinglequotes(programselect)#)
		  AND    Period       = '#URL.Period#'
		  AND    EditionId    = '#URL.EditionId#'	  
		 
		  AND    Resource     IN (SELECT Resource
								  FROM   Ref_ParameterMissionResource
								  WHERE  Mission = '#edition.Mission#'				
								  AND    Ceiling = 1)  
	</cfquery> 
		
	<!--- check requested for ceiling sources --->
		
	<cfquery name="Requested" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		  SELECT ISNULL(SUM(A.RequestAmountBase),0) as Amount,
		  		 ISNULL(SUM(A.RequestAmountBase*SupportPercentage)/100,0) as Support
		  FROM   ProgramAllotmentRequest A INNER JOIN
			  	 ProgramAllotment R ON A.ProgramCode = R.ProgramCode AND A.Period = R.Period AND A.EditionId = R.EditionId
		  WHERE  A.ProgramCode   IN (#preservesinglequotes(programselect)#)
		  <cfif url.summarymode eq "activity">
		    AND   ActivityId = '#url.activityid#'
		  </cfif>
		  AND    A.Period       = '#URL.Period#'
		  AND    A.EditionId    = '#URL.EditionId#'						  
		  AND    A.ActionStatus != '9'
		  AND    A.ObjectCode IN (SELECT  Code  
		                        FROM    Ref_Object
							    WHERE   Resource IN (SELECT  Resource
								  					  FROM   Ref_ParameterMissionResource
												      WHERE  Mission = '#edition.Mission#'				
													   AND   Ceiling = 1
													 )
							   )  
	</cfquery> 
		
	<cfset required = Requested.amount + Requested.support>
		
	<cfif Ceiling.amount lt required and Ceiling.amount gt "0">
	  <cfset hd = "yellow">
	  <cfset cl = "FFD6C1">
	<cfelse>
	  <cfset hd = "C2F3C6">
	  <cfset cl = "ffffff">
	</cfif>  
	
	<cfoutput>
		
 	<table width="100%" align="center" cellspacing="0" cellpadding="0">
	
		<tr bgcolor="E6E6E6" class="line labelit" style="height:15px">  
				<td style="border-right:1px solid silver;border-top:0px;padding-left:10px"><cf_tl id="resource"></td>				
				<td colspan="2" align="right" style="border-top:0px;min-width:60;padding-right:3px;border-right:1px solid gray;"><cf_tl id="request">
			</tr>		
		
	   <tr class="labelit line" bgcolor="#hd#">
	    <td style="height:20px;padding-left:6px"><cf_tl id="Ceiling">:</td>		
		<td></td>
		<td align="right" style="padding-right:6px" align="right">#numberformat(Ceiling.amount,"__,__")#</b></td>
	   </tr>
	   		 	   
		<!--- check requested for ceiling sources --->
		
		<cfquery name="InBudget" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT   * 
		  FROM     Ref_ParameterMissionResource
		  WHERE    Mission = '#edition.Mission#'				
		  AND      Ceiling = 1		  
		</cfquery>	  
		
		<cfset res =  QuotedValueList(InBudget.Resource)> 
		
		<cfquery name="Resource" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT   O.Resource, 
			         S.Name, 
					 SUM(A.RequestAmountBase)  AS Amount					 
			FROM     ProgramAllotmentRequest A INNER JOIN
			  		 ProgramAllotment R ON A.ProgramCode = R.ProgramCode AND A.Period = R.Period AND A.EditionId = R.EditionId INNER JOIN
                     Ref_Object O ON A.ObjectCode = O.Code INNER JOIN
                     Ref_Resource S ON S.Code = O.Resource
			WHERE    A.ProgramCode IN (#preservesinglequotes(programselect)#)
			 <cfif url.summarymode eq "activity">
			    AND   A.ActivityId = '#url.activityid#'
			   </cfif>
			AND	     A.Period      = '#URL.Period#'
			AND      A.EditionId   = '#URL.EditionId#'							  
			AND      S.Code IN (#preservesinglequotes(res)#)			 			
			AND      A.ActionStatus != '9'
			GROUP BY O.Resource, S.Name, S.ListingOrder
			ORDER BY S.ListingOrder					 							  
		</cfquery> 
					   
		<cfloop query="Resource">
		    <tr class="labelit line" bgcolor="#cl#">	
			<td colspan="2" style="padding-left:10px">#Name#</td>
			<td align="right" style="padding-right:15px">#numberformat(Amount,"__,__")#
		    </tr>					   
		</cfloop>	
		
		  <tr class="labelit line" bgcolor="#cl#">	
			<td colspan="2" height="15" style="padding-left:10px"><cf_tl id="Subtotal"></td>
			<td align="right" style="padding-right:6px">#numberformat(Requested.amount,"__,__")#</td>
		 </tr>	
		  		
		<!--- check requested for ceiling sources --->		
		
		<cfquery name="Resource" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   O.Resource, 
			         S.Name,
			         SUM(A.RequestAmountBase)  AS Amount
			FROM     ProgramAllotmentRequest A INNER JOIN
			  		 ProgramAllotment R ON A.ProgramCode = R.ProgramCode AND A.Period = R.Period AND A.EditionId = R.EditionId INNER JOIN
                     Ref_Object O ON A.ObjectCode = O.Code INNER JOIN
                     Ref_Resource S ON S.Code = O.Resource 
			WHERE    A.ProgramCode IN (#preservesinglequotes(programselect)#)
			 <cfif url.summarymode eq "activity">
			    AND   A.ActivityId = '#url.activityid#'
			   </cfif>
			AND	     A.Period      = '#URL.Period#'
			AND      A.EditionId   = '#URL.EditionId#'							  
			AND      S.Code NOT IN (#preservesinglequotes(res)#)		
			AND      A.ActionStatus != '9'	 		  
			GROUP BY O.Resource, S.Name, S.ListingOrder
			ORDER BY S.ListingOrder					 							  
		</cfquery> 
							   
		<cfloop query="Resource">
		    <tr class="cellcontent line" bgcolor="ffffef">	
			<td colspan="2" style="padding-left:10px">#Name#</td>
			<td align="right" style="padding-right:6px">#numberformat(Amount,"__,__")#
		    </tr>						   
		</cfloop>	
		
		<cfquery name="Total" dbtype="query">
			SELECT  SUM(amount) as Amount
			FROM    Resource
		</cfquery> 
		
		<!---
		<cfif total.amount neq "">
		--->
								
		    <tr class="labelit line" bgcolor="ffffcf">	
				<td colspan="2" style="padding-left:10px">#vOutBudget#</td>
				<td align="right" style="padding-right:6px">#numberformat(Total.amount,",__")#</td>
			</tr>	
					
			<cfquery name="Overall" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				  SELECT ISNULL(SUM(A.RequestAmountBase),0) as Amount,
						 ISNULL(SUM(A.RequestAmountBase*SupportPercentage)/100,0) as Support
				  FROM   ProgramAllotmentRequest A INNER JOIN
			  		     ProgramAllotment R ON A.ProgramCode = R.ProgramCode AND A.Period = R.Period AND A.EditionId = R.EditionId
				  WHERE  A.ProgramCode  IN (#preservesinglequotes(programselect)#)
				  AND    A.Period       = '#URL.Period#'
				  AND    A.EditionId    = '#URL.EditionId#'	
				  AND    A.ActionStatus != '9'
			</cfquery> 		 
			
			<cfif Overall.Support neq "0">	
		
				<tr class="labelit line" bgcolor="e3e3e3">	
				<td colspan="2" height="15" style="padding-left:10px"><cf_tl id="Support"></td>
				<td align="right" style="padding-right:6px">#numberformat(Overall.support,"__,__")#</td>
			   </tr>	
			
			   <tr class="labelit line" bgcolor="#cl#">	
				<td colspan="2" height="15" style="padding-left:10px">#vOverall#</td>
				<td align="right" style="padding-right:6px">#numberformat(Overall.support+Overall.amount,"__,__")#</td>
			   </tr>	
		
			<cfelse>
				 
			   <tr class="labelit line" bgcolor="#cl#">	
				<td colspan="2" height="15" style="padding-left:10px">#vOverall#</td>
				<td align="right" style="padding-right:6px">#numberformat(Overall.amount,"__,__")#</td>
			   </tr>	
			   
			</cfif>    	
		   
		<!---
		</cfif>
		--->
						
		<cfif ceiling.amount neq "" and Requested.amount neq "">
		
			<tr class="labelit" bgcolor="#hd#">
			    <td style="padding-left:6px" colspan="2">#vAvailable#</td>
				<td align="right" style="padding-right:6px"><b>#numberformat(Ceiling.amount-Required,"__,__")#</b></td>
			</tr>				
		
		</cfif>
					   					   
	</table>
	
	</cfoutput>	
	
</cfif>	

</td></tr>

<cfif url.history eq "yes">
	
	<cfinclude template="RequestSnapshot.cfm">
	
</cfif>

</table>
