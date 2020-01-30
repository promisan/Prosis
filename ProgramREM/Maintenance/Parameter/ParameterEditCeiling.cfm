<cfajaximport tags="cfform">

<cfquery name="Get" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_ParameterMission
		WHERE  Mission = '#URL.Mission#' 
</cfquery>

<!--- obtain the class --->




<cfoutput query="get">	
<cfform action="ParameterSubmitBudgetCeiling.cfm?idmenu=#URL.Idmenu#&mission=#URL.mission#" method="POST" name="parameterbudgetceiling">

<table width="100%" cellspacing="0" cellpadding="0" align="center">
	
	<tr><td height="12"></td></tr>		
						
			<cfquery name="Resource" 
			  datasource="AppsProgram" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">	
		   	  SELECT     R.*, P.Mission AS Used, P.Ceiling AS Ceiling
			  FROM       Ref_Resource R LEFT OUTER JOIN
                         Ref_ParameterMissionResource P ON R.Code = P.Resource AND P.Mission = '#Url.mission#'
			  WHERE      Resource IN (SELECT DISTINCT O.Resource
									  FROM      Ref_Object O INNER JOIN
							                    Ref_AllotmentVersion V ON O.ObjectUsage = V.ObjectUsage INNER JOIN
							                    Ref_AllotmentEdition E ON V.Code = E.Version
									  WHERE     E.Mission = '#Url.Mission#') 
			  
									  <!---
			  
			  					      SELECT   DISTINCT R.Resource
									  FROM     ProgramAllotmentDetail AS PA INNER JOIN
						                       Program AS P ON PA.ProgramCode = P.ProgramCode INNER JOIN
						                       Ref_Object AS R ON PA.ObjectCode = R.Code
									  WHERE    P.Mission = '#url.mission#')			 
									  
									  --->
			</cfquery>	
			
			<cfif Resource.recordcount eq "0">
						
				<cfquery name="Resource" 
				  datasource="AppsProgram" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">	
			   	  SELECT     R.*, 
				             P.Mission AS Used, 
							 P.Ceiling AS Ceiling
				  FROM       Ref_Resource R LEFT OUTER JOIN
	                         Ref_ParameterMissionResource P ON R.Code = P.Resource AND P.Mission = '#URL.mission#'			 
				</cfquery>	
						
			</cfif>		
			
			<tr class="labelmedium">
			<td valign="top" style="padding-top:3px">Ceiling<br>Per Resource:</td>
			<td>
			<table cellspacing="0" cellpadding="0">
				<tr class="labelmedium line">
				<td>Code</td>
				<td>Description</td>
				<td>Apply<br>Ceiling</td>
				</tr>
				
				<cfloop query="Resource">
				
				<tr class="labelmedium line">
				<td style="padding-right:5px">#Code#</td>
				<td style="padding-right:15px">#Description#</td>
				<td style="padding-right:5px">
				  <input type="checkbox" value="1" name="#code#_ceiling" <cfif ceiling eq "1">checked</cfif>>
				</td>
				</tr>				
				
				</cfloop>	
			
			</table>	
			
			</td>
			
			</tr>
			
			<TR class="labelmedium">
	   		<td width="250" style="height:30px;cursor: pointer;">
			<cf_UIToolTip  tooltip="Allowance clearance even if ceiling is exceeded.">
				Allow clearance once ceiling exceeded:
			</cf_UIToolTip>
			</b></td>
		    <TD colspan="3">
				  <table><tr>
				   <td>	<input type="radio" name="BudgetCeilingClear" value="1" <cfif BudgetCeilingClear eq "1">checked</cfif>></td>
				   <td style="padding-left:5px">Yes</td>
				   <td style="padding-left:5px"><input type="radio" name="BudgetCeilingClear" value="0" <cfif BudgetCeilingClear eq "0">checked</cfif>></td>
				   <td style="padding-left:5px">No <font color="808080"><i>(recommended)</i></font></td>
				   </tr>
			      </table>
				   
		    </TD>
			</TR>	
			
			<TR class="labelmedium">
	   		<td width="150" style="cursor: pointer;">
			<cf_UIToolTip  tooltip="Level on which ceiling amounts are defined">
			Ceiling enforcement level:
			</cf_UIToolTip>
			</b></td>
		    <TD colspan="3">
			    <table cellspacing="0" cellpadding="0">
					<tr class="labelmedium"><td>
					   <input type="radio" name="BudgetCeiling" value="Resource" <cfif BudgetCeiling eq "Resource">checked</cfif>></td>
					   <td style="padding-left:5px">per Program/Resource <font color="808080"><i>(default)</i></font></td>
					   <td style="padding-left:5px"><input type="radio" name="BudgetCeiling" value="Program"  <cfif BudgetCeiling eq "Program">checked</cfif>></td>
					   <td style="padding-left:5px">Enforce on Program level <font color="808080"><i>(Sum of ceiling of all enabled resource)</font></td>
					</tr>
				</table>
		    </TD>
			</TR>	
					
	<tr><td height="10"></td></tr>	
	
	<tr class="line"><td height="1" colspan="4"></td></tr>	
						
	<tr><td height="40" colspan="4" align="center">	
		<input type="Submit" name="Save" value="Update" class="button10g">
	</td></tr>
	
	
	</table>

</cfform>	

</cfoutput>			