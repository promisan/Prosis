
<cfquery name="SearchResult" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
	SELECT     R.Mission as Tree, R.Mandateno, R.Period, O.OrgUnitCode, O.OrgUnitName, O.OrgUnit, M.MissionName
	FROM       Ref_MissionPeriod R INNER JOIN
                  Organization O ON R.Mission = O.Mission INNER JOIN
                  Ref_Mission M ON O.OrgUnitCode = M.Mission
	WHERE      1=1
	<cfif url.id1 eq "0">
	AND        R.Period = '#Periods.Period#'	 	
	<cfelse>
	AND        R.Period IN (SELECT P.Period
							FROM   Ref_MissionPeriod M, Program.dbo.Ref_Period P
							WHERE  M.Mission = '#url.mission#'
							<!---
							WHERE  M.Mission IN (#preservesingleQuotes(mis)#)
							--->
							AND    M.Period = P.Period 	  
							AND    DateExpiration < GETDATE()  )
	</cfif>
	AND       R.Period IN (SELECT Period 
	                       FROM Program.dbo.Ref_Period 
						   WHERE IncludeListing = 1) 
	AND       O.OrgUnit IN (SELECT OrgUnit FROM Program.dbo.ProgramPeriod)					   
</cfquery>

		
<!--- Query returning search results --->

<cfset border = 1>

<table width="100%" border="<cfoutput>#border#</cfoutput>" frame="hsides" cellspacing="0" cellpadding="1" bordercolor="e4e4e4" rules="rows">
	
<tr><td>
 	
<table class="#cl#" width="100%" border="0" cellspacing="0" cellpadding="0" align="left" bordercolor="#C0C0C0">

<cfif SearchResult.recordcount eq "0">

		<tr bgcolor="ffffef"><td height="17" 
		   colspan="2">
		   &nbsp;&nbsp;<b>
		   <font color="gray">
		   No <cfoutput>#URL.Text#</cfoutput> found</b>
		   </td>
		 </tr>  
			
<cfelse>  			
			
		<tr>
			<td colspan="2">
		    <table width="100%" cellspacing="0" cellpadding="0">									
								
					<tr><td height="3"></td></tr>						
					
					<cfset visible = 0>
					
						<cfoutput query="SearchResult">	
										
						<cfinvoke component="Service.AccessGlobal"
						    Method="global"
						  	Role="AdminProgram"
							ReturnVariable="ManagerAccess">	
							
						   <cfinvoke component="Service.Access"
							Method="organization"
							OrgUnit="#OrgUnit#"
							Period="#Period#"
							Role="ProgramOfficer', 'ProgramManager', 'ProgramAuditor"
							ReturnVariable="ListingAccess">	
							 
							<cfif ManagerAccess eq "NONE" and ListingAccess eq "NONE">
						
							<cfelse> 	
							
							<cfset visible = 1>
						
							<tr>
																											   
							<TD width="3%" height="22" rowspan="1" bgcolor="white" align="center">						
							 
								<img src="#SESSION.root#/Images/bullet.png" alt="" 
									border="0" class="show" 
									align="middle" style="cursor: pointer;" 
									onClick="load('#period#','#orgunit#','#tree#','#mandateno#')">								
																					
							 </td>
												 
								    <TD>
									<a href="javascript:load('#period#','#orgunit#','#tree#','#mandateno#')">#OrgUnitCode#</a>
									</td>
									<TD>
									<a title="Open Action Plan" href="javascript:load('#period#','#orgunit#','#tree#','#mandateno#')">#MissionName#  
									
									<cfif url.show eq "0">
																	
										<cfquery name="Per" 
											datasource="appsProgram" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">		
											SELECT    *
											FROM       Ref_Period 	
											WHERE  Period = '#Period#'   
										</cfquery>
																		
										
										#dateformat(per.dateEffective,CLIENT.DateFormatShow)# - #dateformat(per.dateExpiration,CLIENT.DateFormatShow)#
										
									</cfif>
									
									</a></td>
									<TD></TD>
									<td align="right"></td>
														
							</TR>		
							
							</cfif>															
																																												      
						</cfoutput>
					
					<cfoutput>
					
					
					<cfif visible eq "0">
					
						<script>
						
							se = document.getElementsByName("e#periods.currentrow#")
							count = 0
							while (se(count)) {
							se(count).className = "hide"
							count++
							}
							
						</script>
						
					</cfif>	
					
					
					<tr>
					
					<td colspan="5" align="right">
					
					<img src="#SESSION.root#/Images/finger.gif" alt="" 
								border="0" class="show" 
								align="absmiddle" style="cursor: pointer;" 
								onClick="overview('#SearchResult.period#','Tree','#SearchResult.tree#','#SearchResult.mandateno#')">		
					
						<a href="javascript:overview('#SearchResult.period#','Tree','#SearchResult.tree#','#SearchResult.mandateno#')"><b>Consolidated View</a>
						
					</cfoutput>						
					</td></tr>					
				
			</table>
			</td>
		</tr>	
		
				  
</cfif>	  

</TABLE>			 

</tr>

</table>

