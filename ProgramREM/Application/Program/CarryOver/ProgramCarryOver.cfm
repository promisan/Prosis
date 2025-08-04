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

<cfajaximport tags="cfform">

<!--- Create Criteria string for query from data entered thru search form --->

<cfparam name="ProgramClass" default="Component"> 

<cfquery name="CurrentPeriod" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT   *
	 FROM     Ref_Period
	 WHERE    Period = '#URL.Period#'	
</cfquery>

<!--- determine prior period --->

<cfquery name="Org" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT *
   FROM   Organization
   WHERE  OrgUnit = '#URL.ParentUnit#' 
</cfquery>

<cfquery name="Prior" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT   TOP 1 Pe.Period, R.Description
	 FROM     Program P INNER JOIN
              ProgramPeriod Pe ON P.ProgramCode = Pe.ProgramCode INNER JOIN
			  Organization.dbo.Organization O ON O.OrgUnit = Pe.OrgUnit INNER JOIN
              Ref_Period R ON Pe.Period = R.Period
	 WHERE    R.DateEffective < '#currentPeriod.DateEffective#'	
	 AND      O.Mission    = '#Org.Mission#'
	 AND      R.PeriodClass = '#currentperiod.PeriodClass#'
	 ORDER BY R.DateEffective DESC	 	 
</cfquery>

<cfoutput>
	
	<script language="JavaScript">
	
	 function validate(per) {
	 
		document.programform.onsubmit() 
		if( _CF_error_messages.length == 0 ) {		
		    <!--- [it passed Passed the CFFORM JS validation, now run a Ajax script to save] --->
			Prosis.busy('yes') 
			ptoken.navigate('ProgramCarryOverSubmit.cfm?Mission=#Org.Mission#&Period='+per+'&PeriodCurrent=#URL.Period#&Edition='+document.getElementById('editionselect').value,'process','','','POST','programform')
		 }   
	
	 }
	
	</script>

</cfoutput>

<!--- check if mandate is the same --->

<cf_screentop height="100%" scroll="Yes" band="No" jquery="Yes"
    title="Carry over of #ProgramClass#s"
	label="Carry over of #ProgramClass#s" layout="webapp" banner="gray">

<cfquery name="PeriodList" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
		 SELECT DISTINCT Pe.Period, R.Description, R.DateEffective, R.DateExpiration
		 FROM   Program P INNER JOIN
	            ProgramPeriod Pe ON P.ProgramCode = Pe.ProgramCode INNER JOIN
			    Organization.dbo.Organization O ON O.OrgUnit = Pe.OrgUnit INNER JOIN
	            Ref_Period R ON Pe.Period = R.Period
		 WHERE  R.DateEffective < '#currentPeriod.DateEffective#'	
		 AND    O.Mission = '#Org.Mission#'	
		 AND    R.isPlanningPeriod = 1
		 ORDER BY R.DateExpiration DESC	 
</cfquery>

<cfif PeriodList.recordcount eq "0">

	<cfquery name="PeriodList" 
	     datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			 SELECT DISTINCT Pe.Period, R.Description, R.DateEffective, R.DateExpiration
			 FROM   Program P INNER JOIN
		            ProgramPeriod Pe ON P.ProgramCode = Pe.ProgramCode INNER JOIN
			        Organization.dbo.Organization O ON O.OrgUnit = Pe.OrgUnit INNER JOIN
		            Ref_Period R ON Pe.Period = R.Period
			 WHERE  R.DateEffective < '#currentPeriod.DateEffective#'	
			 AND    O.Mission = '#Org.Mission#'				
			 ORDER BY R.DateExpiration DESC	 
	</cfquery>		

</cfif>

<cfif PeriodList.recordcount eq "0">

	<table align="center">
		<tr><td style="height:300" class="labelmedium" align="center"><font color="FF0000">No prior period entries found, function is not available</font></tr>
	</table>

<cfelse>

	<cfoutput>
	
		<table width="97%" height="100%" align="center">
				
		<!--- process submit box --->
		<tr colspan="2" class="hide"><td id="process"></td></tr>	
		
		<tr><td colspan="2" style="padding:10px;background-color:f1f1f1">

				<table>
				
				<tr class="labelmedium2">
				
					<td height="30"><cf_tl id="Prior"> <cf_tl id="Plan period">:</td>
					<td> 
							
						<cfquery name="PeriodList" 
						     datasource="AppsProgram" 
						     username="#SESSION.login#" 
						     password="#SESSION.dbpw#">
								 SELECT DISTINCT Pe.Period, R.Description, R.DateEffective, R.DateExpiration
								 FROM   Program P INNER JOIN
							            ProgramPeriod Pe ON P.ProgramCode = Pe.ProgramCode INNER JOIN
									    Organization.dbo.Organization O ON O.OrgUnit = Pe.OrgUnit INNER JOIN
							            Ref_Period R ON Pe.Period = R.Period
								 WHERE  R.DateEffective < '#currentPeriod.DateEffective#'	
								 AND    O.Mission = '#Org.Mission#'	
								 AND    R.isPlanningPeriod = 1
								 ORDER BY R.DateExpiration DESC	 
						</cfquery>
						
						<cfif PeriodList.recordcount eq "0">
						
							<cfquery name="PeriodList" 
							     datasource="AppsProgram" 
							     username="#SESSION.login#" 
							     password="#SESSION.dbpw#">
									 SELECT DISTINCT Pe.Period, R.Description, R.DateEffective, R.DateExpiration
									 FROM   Program P INNER JOIN
								            ProgramPeriod Pe ON P.ProgramCode = Pe.ProgramCode INNER JOIN
										    Organization.dbo.Organization O ON O.OrgUnit = Pe.OrgUnit INNER JOIN
								            Ref_Period R ON Pe.Period = R.Period
									 WHERE  R.DateEffective < '#currentPeriod.DateEffective#'	
									 AND    O.Mission = '#Org.Mission#'				
									 ORDER BY R.DateExpiration DESC	 
							</cfquery>		
						
						</cfif>
											
						<select name="PeriodFrom" 
						   class="regularxxl"
						   onchange="ptoken.navigate('ProgramCarryOverMain.cfm?period=#url.period#&parentunit=#url.parentunit#&prior='+this.value,'content')">
							<cfloop query="PeriodList">
							   <option value="#Period#" <cfif Prior.Period eq Period>selected</cfif>>#Period#</option>
							</cfloop>
						</select>
					
					</td>	
					
					<td style="padding-left:20px" height="30"><cf_tl id="Select edition">:</td>				
					<td style="padding-left:10px"><cf_securediv bind="url:getEdition.cfm?mission=#Org.mission#&planperiod=#url.period#&period={PeriodFrom}"></td>						
									
				</tr>
							
				
				<tr class="labelmedium2">					
					<td style="padding-top:5px;padding-right:20px">Move to Plan period:</td>
					<td style="font-size:20px;padding-left:4px">#CurrentPeriod.Description#</td>				
				</tr>
				</table>
			
			</td>
		</tr>	
				
		</cfoutput>
		
		<tr>
			<td colspan="2" valign="top" height="100%" style="padding-left:1px;padding-right:1px">
				<cf_divscroll id="content">
					<cfinclude template="ProgramCarryOverMain.cfm">
				</cf_divscroll>
			</td>					
		</tr>
		
		<tr><td colspan="2" class="line"></td></tr>
		
		<cfoutput>
		
		<tr>
			<td align="center" colspan="2" height="40">	
			<input type="button" class="button10g" name="Cancel" value="Cancel" style="font-size:14px;height:25;width:140" onClick="window.close()">
			<input type="button" class="button10g" name="Submit" value="Apply"  style="font-size:13px;height:25;width:140" onclick="validate('#PriorPeriod#')">
			</td>
		</tr>
		
		</cfoutput>
		
		</table>
		
</cfif>		
	
<CF_DropTable dbName="AppsProgram" tblName="tmp#SESSION.acc#Program"> 

<cf_screenbottom layout="webapp">	