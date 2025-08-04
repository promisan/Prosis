<!--
    Copyright © 2025 Promisan

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

<cfparam name="url.object" default="">
<cfparam name="url.fund" default="">
<cfparam name="url.program" default="">

<cfquery name="Edition" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_AllotmentEdition R, Ref_AllotmentVersion V
	WHERE  EditionId = '#url.editionid#'	
	AND    R.Version = V.Code				
</cfquery>	

<cfquery name="Parameter" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * FROM Ref_ParameterMission
	WHERE Mission = '#Edition.Mission#'
</cfquery>	

<cfquery name="Amount" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM dbo.#SESSION.acc#BudgetTransfer_#client.sessionNo# 
	WHERE EditionId != '#url.editionid#' 
	OR   Period != '#url.period#'				
</cfquery>	

<cfquery name="Select" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * FROM dbo.#SESSION.acc#BudgetTransfer_#client.sessionNo# 
	ORDER BY SerialNo DESC	
</cfquery>	

<cfswitch expression="#url.field#">

<cfcase value="program">

	<cfparam name="url.programcode" default="">
			
	<cfquery name="Program" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   Program P, ProgramPeriod Pe
		WHERE  P.ProgramCode = Pe.ProgramCode
		AND    Pe.Period = '#url.period#'
		<!--- valid program for period and mission --->
		AND    P.Mission = '#edition.mission#'
		AND    Pe.Status != '9'
		
		<!--- have a positive amount in Cleared budget lines --->
		
		<cfif url.actionclass eq "Amendment">
		
		AND P.ProgramCode = '#url.program#'
				
		<cfelseif url.direction eq "From">
		
		AND Pe.ProgramCode IN (						
			SELECT ProgramCode
			FROM   ProgramAllotmentDetail
			WHERE  EditionId = '#editionid#' 			
			AND    Period = '#period#'
			<!--- June 2nd : relaxed the condition to include 0 as well ---> 
			AND    Status IN ('0','1')
			GROUP BY ProgramCode
			<!---
			HAVING sum(Amount) > 0 
			--->
			) 			
			
		<cfelse>
				  		
			<cfif url.program eq "">
			
				<!--- not sure if this is a correct TO condition --->
				  
			  	AND P.ProgramCode IN (						
						SELECT P.ProgramCode
						FROM   ProgramPeriod Pe, Program P
						WHERE  Pe.Period        = '#period#' 
						AND    P.ProgramCode    = Pe.ProgramCode
						AND    P.ProgramScope   = 'Unit'
						AND    Pe.RecordStatus != '9'
						AND    P.ProgramAllotment = 1)
					
				
			<cfelse>
			
				AND P.ProgramCode = '#url.program#'
			
			</cfif>	
			
		</cfif>	
				
		ORDER BY Reference,
		         ReferenceBudget1,
				 ReferenceBudget2,
				 ReferenceBudget3,
				 ReferenceBudget4,
				 ReferenceBudget5,
				 ReferenceBudget6
	</cfquery>		
	

	<cfoutput>
		
	<select name="programcode#url.direction#" id="programcode#url.direction#"
	  style="width:100%;border:0px;" class="regularxl"
	  onchange="amount('#url.direction#','pending','');amount('#url.direction#','cleared','');unit('#url.direction#','');fundsel('#url.direction#',this.value,'#url.fund#','#url.object#');objectsel('#url.direction#',this.value,'#url.fund#','#url.object#')">
	     <cfif (url.program eq "" or url.direction eq "from") and url.actionclass eq "Transfer">
	     <option value=""></option>
		 </cfif>
		<cfloop query="Program">
			<option value="#ProgramCode#" <cfif url.programcode eq ProgramCode>selected</cfif>><cfif Reference neq "">#Reference# - </cfif><cfif ReferenceBudget1 eq "">#ProgramName#<cfelse>#ReferenceBudget1#<cfif ReferenceBudget2 neq "">-#ReferenceBudget2#</cfif>-<cfif ReferenceBudget3 neq "">#ReferenceBudget3#</cfif><cfif ReferenceBudget4 neq "">-#ReferenceBudget4#</cfif><cfif ReferenceBudget5 neq "">-#ReferenceBudget5#</cfif><cfif ReferenceBudget6 neq "">-#ReferenceBudget6#</cfif></cfif> </option>
		</cfloop>
	</select>	
	
	<cfparam name="url.refresh" default="1">
			
	<cfif (url.program neq "" and url.direction eq "to" and url.refresh eq "1") or (url.actionclass eq "Amendment" and url.refresh eq "1")>
	
		<script>		 
		    			
			amount('#url.direction#','pending','#url.program#');
			amount('#url.direction#','cleared','#url.program#');
			unit('#url.direction#','#url.program#');
			fundsel('#url.direction#','#url.program#','#url.fund#','#url.object#');
			objectsel('#url.direction#','#url.program#','#url.fund#','#url.object#')			
			
		</script>
	
	</cfif>
	
	</cfoutput>

</cfcase>

<cfcase value="fund">

	<cfparam name="url.fund" default="#select.fund#">
			
	<cfquery name="Fund" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT DISTINCT Fund 
		FROM   ProgramAllotmentDetail
		WHERE  EditionId   = '#url.editionid#' 
		AND    ProgramCode = '#url.programcode#'
		AND    Period      = '#url.period#'  
		<!---  
		AND    Amount > 0
		--->
		AND    Status IN ('0','1')		
	</cfquery>		
	
	<cfif fund.recordcount eq "0">
	
		<cfquery name="Fund" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT DISTINCT Fund 
			FROM   Ref_AllotmentEditionFund
			WHERE  EditionId   = '#url.editionid#' 					
		</cfquery>		
	
	</cfif>
	
	<cfoutput>
	<select name="fundcode#url.direction#" class="regularxl" style="width:100%;border:0px;" id="fundcode#url.direction#" 
	    onchange="amount('#url.direction#','pending','');amount('#url.direction#','cleared','')">
	   
		<cfloop query="Fund">
			<option value="#Fund#" <cfif url.fund eq fund>selected</cfif>>#Fund#</option>
		</cfloop>
		
	</select>	
	</cfoutput>

</cfcase>



<cfcase value="object">

	<cfparam name="url.objectcode" default="#select.objectcode#">
		
	<cfquery name="Allotment" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   ProgramAllotment
		WHERE  ProgramCode = '#url.programcode#'
		AND    Period      = '#url.period#'
		AND    EditionId   = '#url.editionid#'					
	</cfquery>	
				
	<cfquery name="Object" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_Object		
		<cfif url.resource eq "">
		WHERE 1=0
		<cfelseif url.resource eq "any">
		WHERE 1=1
		<cfelse>
		WHERE Resource = '#url.resource#'
		</cfif>
		
		<!--- prevent selection of the support cost OE this is generated --->		
		AND   Code != '#allotment.SupportObjectCode#' 
		<!--- ---------------------------------------------------------- --->
		
		<!--- have a positive amount in cleared budget --->
		
		<cfif url.actionClass eq "Amendment">
		
			AND (
			     Code NOT IN (SELECT ObjectCode 
			                  FROM userquery.dbo.#SESSION.acc#BudgetTransfer_#client.sessionNo# 
							  WHERE ProgramCode = '#url.ProgramCode#'
							  <!---
							  AND   Fund        = '#url.fund#' --->
							  )
				 OR
				 Code = '#url.objectcode#'			 
				 )	
		
		<cfelse>
		
			<cfif url.direction eq "From">
			
				AND Code IN (						
					SELECT   ObjectCode 
					FROM     ProgramAllotmentDetail
					WHERE    EditionId = '#editionid#' 
					AND      ProgramCode = '#programcode#'
					AND      Period = '#period#' 
					AND      Status IN ('0','1')
					GROUP BY ObjectCode
					HAVING sum(Amount) > 0
					)
					
				AND (
			     Code NOT IN (SELECT ObjectCode 
			                  FROM userquery.dbo.#SESSION.acc#BudgetTransfer_#client.sessionNo# 
							  WHERE ProgramCode = '#url.ProgramCode#'
							  <!---
							  AND   Fund        = '#url.fund#' --->
							  )
				 OR
				 Code = '#url.objectcode#'			 
				 )	
				
			<cfelse>
			
				AND Code IN (						
					SELECT Code 
					FROM   Ref_Object
					WHERE  Objectusage = '#Edition.ObjectUsage#'
					AND    Code NOT IN (SELECT ObjectCode 
			                            FROM userquery.dbo.#SESSION.acc#BudgetTransfer_#client.sessionNo# 
							            WHERE ProgramCode = '#url.ProgramCode#'
							            AND   Amount < 0
							  <!---
							  AND   Fund        = '#url.fund#' --->
							  )
					
					
					<cfif parameter.budgetObjectMode eq "Parent">
					AND  (ParentCode is NULL or ParentCode ='')  
					</cfif>
					)
				
			</cfif>	
		
		</cfif>		
		ORDER BY HierarchyCode						 
		
	</cfquery>			
	
	<cfoutput>
		
	<select name="objectcode#url.direction#" class="regularxl" id="objectcode#url.direction#"
	  style="width:100%;border:0px;" 
	  onchange="amount('#url.direction#','pending','');amount('#url.direction#','cleared','')">
	    <option value=""></option>
		<cfloop query="Object">
			<option value="#Code#" <cfif url.objectcode eq code>selected</cfif>>#CodeDisplay# #Description#</option>
		</cfloop>
	</select>	
	</cfoutput>

</cfcase>

<cfcase value="unit">
		
	<cfquery name="Program" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * 
			FROM   ProgramPeriod
			WHERE  ProgramCode = '#url.programcode#'
			AND    Period      = '#url.period#'		
	</cfquery>		
	
	<cfquery name="Unit" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * 
			FROM   Organization
			WHERE  OrgUnit = '#Program.orgunit#'
	</cfquery>	
	
	<cfoutput>#Unit.OrgUnitName#
	
	<cfif Unit.ParentOrgUnit neq Unit.OrgUnitCode>
		
		<cfquery name="Parent" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT * 
				FROM   Organization
				WHERE  OrgUnitCode = '#Unit.ParentOrgUnit#'
				AND    Mission = '#unit.mission#'
				AND    MandateNo = '#unit.mandateno#'
		</cfquery>	
		<cfif Parent.OrgUnitName neq "">
		/ #Parent.OrgUnitName#
		</cfif>
		
	</cfif>
	
	</cfoutput>

</cfcase>

</cfswitch>