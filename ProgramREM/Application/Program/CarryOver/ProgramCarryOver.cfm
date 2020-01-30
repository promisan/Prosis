
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
			ColdFusion.navigate('ProgramCarryOverSubmit.cfm?Mission=#Org.Mission#&Period='+per+'&PeriodCurrent=#URL.Period#&Edition='+document.getElementById('editionselect').value,'process','','','POST','programform')
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
	
		<table width="97%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
				
		<!--- process submit box --->
		<tr colspan="2" class="hide"><td id="process"></td></tr>	
		
		<tr><td colspan="2" style="padding:10px">

				<table class="formpadding">
				
				<tr>
				
					<td height="30" class="labelmedium"><cf_tl id="Prior"> <cf_tl id="Plan period">:</td>
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
						   class="regularxl"
						   onchange="ColdFusion.navigate('ProgramCarryOverMain.cfm?period=#url.period#&parentunit=#url.parentunit#&prior='+this.value,'content')">
							<cfloop query="PeriodList">
							   <option value="#Period#" <cfif Prior.Period eq Period>selected</cfif>>#Period#</option>
							</cfloop>
						</select>
					
					</td>		
									
				</tr>
				
				<tr>
					<td height="30" class="labelmedium"><cf_tl id="Select edition">:</td>				
					<td><cfdiv bind="url:getEdition.cfm?mission=#Org.mission#&planperiod=#url.period#&period={PeriodFrom}"></td>					
				</tr>
				
				<tr>
					<td></td>				
					<td class="labelmedium"><font color="808080">Attention : select edition of which the requirement/budget lines would need to be inherited for the selected records</td>				
				</tr>
				
				<tr>					
					<td class="labelmedium" style="padding-right:20px">Move to Plan period:</td>
					<td class="labelmedium" style="padding-left:4px">#CurrentPeriod.Description#</td>				
				</tr>
				</table>
			
			</td>
		</tr>	
				
		</cfoutput>
		
		<tr>
			<td colspan="2" valign="top" height="100%" id="content" style="padding:10px">
				<cf_divscroll>
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