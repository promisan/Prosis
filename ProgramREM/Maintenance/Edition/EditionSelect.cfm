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

<!--- ALLOW TO TRANSFER BUDGET FROM 
           VERSION A TO VERSION B, but only within the same EDITION period or NULL 
		   
The idea is that you create a new version of a budgetin a new edition and that you can
carry over already recorded amounts of that budget as recorded in a different
version
		   
--->

<!--- select version --->

<cfquery name="ObjectUsage"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_AllotmentVersion
	WHERE  Code = '#URL.Version#'	
</cfquery>

<cfquery name="Period"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     Ref_Period
	WHERE    Period = '#URL.Period#' 	
</cfquery>

<!--- find for this mission the correct plan period --->

<cfquery name="LastPeriod"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   TOP 1 R.Period
	FROM     Organization.dbo.Ref_MissionPeriod Pe INNER JOIN
	         Ref_Period R ON Pe.PlanningPeriod = R.Period
	WHERE    Pe.Mission = '#url.Mission#'			
	ORDER BY R.DateEffective DESC
</cfquery>

<cfquery name="Edition"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT A.EditionId, 
	       A.Version, 
		   (SELECT TOP 1 R.Period 
		    FROM ProgramAllotment PA , Ref_Period  R
			WHERE PA.Period = R.Period
			AND   PA.EditionId = A.EditionId
			ORDER BY DateEffective DESC) as PlanningPeriod,
		   A.Period,
		   B.Description,		 
	             (SELECT SUM(PAD.AmountBase) 
				  FROM  ProgramAllotmentDetail PAD
				  WHERE PAD.EditionId = A.EditionId
				  AND   PAD.Status != '9' 
				  AND   PAD.ActionId is NULL) AS AmountBase
	FROM   Ref_AllotmentEdition A, 
	       Ref_AllotmentVersion B
	WHERE  A.Mission = '#URL.Mission#'
	<cfif url.period neq "">
	AND    A.Period IN (SELECT Period 
	                    FROM   Ref_Period 
						WHERE  DateEffective <= '#Period.DateEffective#')
	<cfelse>
	AND    A.Period is null
	</cfif>	
	AND    A.Version    = B.Code
	AND    EditionClass = 'Budget' 
	<!--- same object version to carry over --->
	AND    A.Version IN (SELECT Code
			   		     FROM   Ref_AllotmentVersion
					     WHERE  ObjectUsage = '#ObjectUsage.ObjectUsage#')	
	ORDER BY A.Created					 
</cfquery>

<cfquery name="Version"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     Ref_AllotmentVersion
	WHERE    Mission = '#URL.Mission#' 
	ORDER BY ListingOrder
</cfquery>

<cfif Edition.recordcount eq "0">&nbsp;<font color="808080"><i>No editions to be inherited were found.
	  
	<input type="hidden" name="CarryOver" value="">

<cfelse>

   <table width="94%" cellspacing="0" cellpadding="0">
   
   <tr>
	   <td colspan="2" class="labelit">Edition</td>
	   <td class="labelit">Plan Period</td>
	   <td class="labelit">Exec.Period</td>
	   <td class="labelit">Name</td>
	   <td class="labelit">Fund</td>
	   <td class="labelit">Amount</td>
   </tr>
   
   <tr><td colspan="7" class="linedotted"></td></tr>   
   
   <tr>
   <td><input type="radio" name="CarryOver" value="" checked onclick="inherit('')"></td>
   <td colspan="6" class="labelit">Do not carry over</td>   
   <td></td>
   </tr>
   
   <cfoutput query="Edition">
   
   		<cfif amountbase neq "">
   
   		<tr><td colspan="7" class="linedotted"></td></tr>  
   
	   <tr>
	   <td width="40"><input type="radio" name="CarryOver" value="#EditionId#" onclick="inherit('#editionid#')"></td>
	   <td width="50"  class="labelit">#EditionId#</td>
	   <td width="80"  class="labelit">#PlanningPeriod#</td>
	   <td width="80"  class="labelit">#Period#</td>
	   <td width="120" class="labelit">#Description#</td>		   
	   <td width="160" class="labelit">
	   
			<cfquery name="Funds" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   Ref_AllotmentEditionFund
					WHERE  EditionId = '#editionid#'				
			</cfquery>
			
			<cfif Funds.recordcount eq "0">
				<font color="FF0000">No fund</font>
			<cfelse>
				<cfloop query="Funds">#Fund#<cfif currentrow neq recordcount>, </cfif></cfloop>
			</cfif>	
	   
	   </td>
	   
	   <td align="right" class="labelit">#numberFormat(AmountBase,",__.__")#</td>
	   
	   </tr>    
	   
	   </cfif>
   
   </cfoutput>
     	
   <tr><td colspan="7" class="linedotted"></td></tr>   
   
   </table>
   
</cfif>
