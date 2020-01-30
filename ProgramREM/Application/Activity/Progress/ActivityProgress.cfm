
<cfparam name = "url.periodmode"   default="fit">
<cfparam name = "url.mode"         default="0">
<cfparam name = "url.output"       default="0">
<cfparam name = "url.periodfilter" default="#url.period#">



<cfif url.mode eq "Print">

	<cfset url.attach = "0">
	<cf_screentop html="No">
	<cfinclude template="../../Program/Header/ViewHeader.cfm">		

</cfif>

<cfajaximport tags="cfdiv">

<cfquery name="Check" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      ProgramActivityCluster
	WHERE     ProgramCode = '#URL.ProgramCode#' 
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Sub" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      ProgramPeriod
		WHERE     PeriodParentCode = '#URL.ProgramCode#' 
		AND       Period = '#url.period#'
	</cfquery>
	
	<cfset val = "'#URL.ProgramCode#'">
	
	<cfloop query="sub">
		  	   
	     <cfset val = "#val#,'#ProgramCode#'">	
			 
	</cfloop>

	<cfset ProgramFilter = "ProgramCode IN (#val#)">		

<cfelse>
	
	<cfset ProgramFilter = "ProgramCode = '#URL.ProgramCode#'">		

</cfif>				

<!--- prepare data --->
<cfinclude template="ActivityProgressInit.cfm">

<cfquery name="Project" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	SELECT    Pr.*, 
	          C.ClusterDescription AS SubProject, 
			  C.ListingOrder AS ListingOrder,
			  Pen.Status,
			  Org.OrgUnitNameShort
			  
	FROM      ProgramActivity Pr 
	          INNER JOIN Organization.dbo.Organization Org ON Pr.OrgUnit = Org.OrgUnit 
			  LEFT OUTER JOIN ProgramActivityCluster C ON Pr.ActivityClusterId = C.ActivityClusterId
			  LEFT OUTER JOIN userQuery.dbo.#SESSION.acc#ActivityPending#FileNo# Pen ON Pr.ActivityId = Pen.ActivityId		  
	
	WHERE     Pr.ProgramCode    = '#URL.ProgramCode#' 
	AND       Pr.RecordStatus <> '9'
	
	<cfif url.periodfilter neq "">	
	AND       Pr.ActivityPeriod = '#url.periodfilter#' 
	</cfif>
	
	AND       Pr.ProgramCode NOT IN (SELECT ProgramCode 
	                                 FROM   ProgramPeriod 
									 WHERE  Period = '#URL.Period#' 
									 AND    RecordStatus = '9')	
	ORDER BY  C.ListingOrder, Pr.ActivityClusterId, Pr.ActivityDateStart
	</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Activity" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
			
	 SELECT   P.ProgramName as SubProject,
	          Pr.ActivityId,Pr.ActivityPeriod,Pr.ActivityDateStart,Pr.ActivityDateEnd,Pr.ActivityDate,Pr.ActivityDescription, Pr.ActivityDescriptionShort,
	          '0' AS ListingOrder,
			  Pen.Status,
			  Org.OrgUnitNameShort,
			  (SELECT count(*) FROM ProgramActivityParent P WHERE Pr.ActivityId = P.ActivityId) as Dependent
			  
	FROM      Program P INNER JOIN
              ProgramActivity Pr ON P.ProgramCode = Pr.ProgramCode INNER JOIN				   
			  ProgramPeriod Pe ON P.ProgramCode = Pe.ProgramCode AND Pe.Period = '#url.Period#' INNER JOIN
              Organization.dbo.Organization Org ON Pr.OrgUnit = Org.OrgUnit LEFT OUTER JOIN
              userQuery.dbo.#SESSION.acc#ActivityPending#FileNo# Pen ON Pr.ActivityId = Pen.ActivityId
						
	WHERE     Pr.ProgramCode = '#URL.ProgramCode#' 	
	AND       Pr.RecordStatus != '9'
	AND       Pe.RecordStatus != '9'
	
	<cfif url.periodfilter neq "">	
	AND       Pr.ActivityPeriod = '#url.periodfilter#'
	</cfif>
		
	UNION 
	 
	SELECT    P.ProgramName as SubProject,
	          Pr.ActivityId,
			  Pr.ActivityPeriod,
			  Pr.ActivityDateStart,
			  Pr.ActivityDateEnd,
			  Pr.ActivityDate,
			  Pr.ActivityDescription, 
			  Pr.ActivityDescriptionShort,
	          P.ListingOrder AS ListingOrder,
			  Pen.Status,
			  Org.OrgUnitNameShort,
			   (SELECT count(*) 
			    FROM   ProgramActivityParent P 
				WHERE  Pr.ActivityId = P.ActivityId) as Dependent
	
	FROM      Program P INNER JOIN
              ProgramActivity Pr ON P.ProgramCode = Pr.ProgramCode INNER JOIN
			  ProgramPeriod Pe ON P.ProgramCode = Pe.ProgramCode AND Pe.Period = '#url.Period#' INNER JOIN
              Organization.dbo.Organization Org ON Pr.OrgUnit = Org.OrgUnit LEFT OUTER JOIN
              userQuery.dbo.#SESSION.acc#ActivityPending#FileNo# Pen ON Pr.ActivityId = Pen.ActivityId
				  
	WHERE     Pe.PeriodParentCode = '#URL.ProgramCode#' 
	AND       Pr.RecordStatus != '9'
	AND       Pe.RecordStatus != '9'
	<cfif url.periodfilter neq "">
	AND       Pr.ActivityPeriod = '#url.periodfilter#' 
	</cfif>
		
	ORDER BY  ListingOrder, Pr.ActivityDateStart   
	
	</cfquery>
				
<cfelse>


	<!--- clustering --->
	
	<cfquery name="Activity" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT    Pr.*, 
		          C.ClusterDescription AS SubProject, 
				  C.ListingOrder AS ListingOrder,
				  Pen.Status,
				  Org.OrgUnitNameShort,
				   (SELECT count(*) FROM ProgramActivityParent P WHERE Pr.ActivityId = P.ActivityId) as Dependent
				   
		FROM      ProgramActivity Pr 
	              INNER JOIN Organization.dbo.Organization Org ON Pr.OrgUnit = Org.OrgUnit 
			      LEFT OUTER JOIN ProgramActivityCluster C ON Pr.ActivityClusterId = C.ActivityClusterId
			      LEFT OUTER JOIN userQuery.dbo.#SESSION.acc#ActivityPending#FileNo# Pen ON Pr.ActivityId = Pen.ActivityId	
			  		   		
		WHERE     Pr.ProgramCode = '#URL.ProgramCode#' 
		AND       Pr.RecordStatus != '9'
		AND       Pr.ProgramCode NOT IN (SELECT ProgramCode 
		                                 FROM   ProgramPeriod 
										 WHERE  Period = '#URL.Period#' AND RecordStatus = '9')
										 
		<cfif url.periodfilter neq "">
		AND       Pr.ActivityPeriod = '#url.periodfilter#' 
		</cfif>								 
		
		ORDER BY  C.ListingOrder, 
		          Pr.ActivityDateStart, 
				  Pr.ActivityDateEnd
		
	</cfquery>
	
</cfif>

<cfif url.periodmode eq "fit">

		<cfquery name="Period" 
	     datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			SELECT  MIN(ActivityDateStart) AS DateEffective, 
			        MAX(ActivityDate)      AS DateExpiration
			FROM    ProgramActivity
			WHERE   ProgramCode = '#URL.ProgramCode#'
			AND     RecordStatus != '9'
			<!--- added 29/1 as we now filter by period in the screen more consistently --->
			AND     ActivityPeriod = '#url.period#'
		</cfquery>
				
		<cfset perS = Period.DateEffective>
		<cfset perE = Period.DateExpiration>
				
		<cfif pers eq "">
		    <cfset diff = "99999">
		<cfelse>		
			<cfset diff = DateDiff("m", pers, pere)> 
		</cfif>	
		
		<cfif pers eq "" or pere eq "" or diff gte "48">
		
			<cfquery name="Period" 
			     datasource="AppsProgram" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     SELECT *
			     FROM   Ref_Period
				 WHERE  Period = '#URL.Period#'
			</cfquery>
			
			<cfset perS = Period.DateEffective>
			<cfset perE = Period.DateExpiration>
				
		</cfif>
				
<cfelse>		
		
	<cfquery name="Period" 
		     datasource="AppsProgram" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT *
		     FROM   Ref_Period
			 WHERE  Period = '#URL.Period#'
	</cfquery>
	
	<cfset perS = Period.DateEffective>
	<cfset perE = Period.DateExpiration>
	
</cfif>	

<cfquery name="PeriodListing" 
	     datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT *
	     FROM Ref_Period
		 WHERE IncludeListing = '1'
		 AND Period >= (SELECT MIN(Period) FROM ProgramPeriod WHERE ProgramCode = '#URL.ProgramCode#')
		 
</cfquery>

<cfset perE = DateAdd("m","1",perE)>
<cfset mth = DateDiff("m", perS, perE)>

<cfset S=arrayNew(1)>
<cfset SM = Month(perS)>
<cfset SY = Year(perS)>
<cfset S[1] = 12 - SM + 1> <!--- months in first year --->
<cfset EM = Month(PerE)>
<cfset EY = Year(PerE)>
<cfset S[2] = EM> <!--- months in second year --->
<cfset DF = EY - SY + 1>

<cfif url.output eq "0">	
	<cfset cols = mth+6>
<cfelse>
    <cfset cols = mth+5>
</cfif>		

<cf_divscroll overflowx="auto">
		
<table width="99%" align="center" cellspacing="0" cellpadding="0" border="0" >

<tr><td align="right">

	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td class="noprint" height="26">
	
	<cfinvoke component="Service.Access"
			Method="Program"
			ProgramCode="#URL.ProgramCode#"
			Period="#URL.Period#"	
			Role="'ProgramOfficer'"	
	    	ReturnVariable="EditAccess">
		
	<cfif url.mode neq "Print">
	
		<table border="0"><tr>
		
			<cfoutput>	 				
			
				 <cfif EditAccess eq "Edit" or EditAccess eq "ALL">
				 					 
					 <td style="padding-top:3px;padding-left:4px">
				
				 	 <img src="#SESSION.root#/Images/activity.png" name="act1" height="20"
							  onMouseOver="document.act1.src='#SESSION.root#/Images/activity_faded.png'" 
							  onMouseOut="document.act1.src='#SESSION.root#/Images/activity.png'"
							  style="cursor: pointer;" alt="Add an activity and output" border="0" align="absmiddle" 
							  onClick="edit('')"> 
							  
					  </td>
				  
				  </cfif>
				  
				   <td style="padding-left:3px;width:20px">	
						  
					<span style="display:none;" id="printTitle"><cf_tl id="Activity Progress"></span>
					
					<cf_tl id="Print" var="1">
					<cf_button2
						title = "#lt_text#"
						type = "Print"
						mode = "icon"
						height = "21px"
						printContent = ".clsPrintContent"
						printTitle = "##printTitle">
						  
				 </td>			
					
			</cfoutput> 	
				
		</table>
				  
	</cfif>
		
	</td>
	
	<cfparam name="url.outputshow" default="0">
	
	<cfoutput>
	
	<cfif url.mode neq "Print">
	
	<td style="height:40px"><table cellspacing="0" cellpadding="0" class="formpadding">
	    <tr>
		<td class="labelmedium">	
			<input type="radio" class="radiol" name="Out" id="Out" value="show" <cfif url.outputshow eq "1">checked</cfif> onclick="menuoption('gantt','#url.output#','1');">&nbsp;<cf_tl id="Show Deliverables">	
		</td>		
		<td class="labelmedium" style="padding-left:10px">	
			<input type="radio" class="radiol" name="Out" id="Out" value="hide" <cfif url.outputshow eq "0">checked</cfif> onclick="menuoption('gantt','#url.output#','0');">&nbsp;<cf_tl id="Hide Deliverables">	
		</td>		
		</tr>
		</table>
	</td>
	
	</cfif>
	
	</cfoutput>
	
	<td align="right" class="clsPrintContent">
		
		<style>
			.Connector {
				background-color: blue;
				border-bottom: 1px solid Black;
				border-left: 1px solid Black;
				cursor: pointer;
				border-top: 1px solid Black; }
			
			.NotStarted {
				background-color: silver;
				border-bottom: 1px solid Black;
				border-top: 1px solid Black; }
				
			.OnSchedule {
				background-color: yellow; 
				border-bottom: 1px solid Black;
				border-top: 1px solid Black;}	
				
			.Completed {
				background-color: green;
				border-bottom: 1px solid Black;
				border-top: 1px solid Black; }		
				
			.Overdue {
				background-color: red;
				border-bottom: 1px solid Black;
				border-top: 1px solid Black; }		
		</style>
		
		<table><tr><td>

		<table cellspacing="0" cellpadding="0">
		<tr> 
		  		  
		  <td width="15" bgcolor="C0C0C0" style="padding-left:1px;border: 1px solid Gray;"></td>
		  <td class="labelit" style="height:11px;padding-left:4px;padding-right:7px"><cf_tl id="Not started"></td>
		  
		  <td width="15" bgcolor="yellow" style="padding-left:1px;border: 1px solid gray;"></td>
		  <td class="labelit" style="height:11px;padding-left:4px;padding-right:7px"><cf_tl id="On schedule"></td>
		  
		  <td width="15"  bgcolor="green" style="padding-left:1px;border: 1px solid gray;"></td>
		  <td class="labelit" style="height:11px;padding-left:4px;padding-right:7px"><cf_tl id="Completed"></td>
		  
		  <td width="15" bgcolor="red" style="padding-left:1px;border: 1px solid gray;"></td>
		  <td class="labelit" style="height:11px;padding-left:4px;padding-right:7px"><cf_tl id="Overdue"></td>
		</tr>
		</table>
		
		</td></tr></table>
		
	</tr></table>	

</td></tr>

<tr><td class="clsPrintContent">

	<table width="99%" align="center" cellspacing="0" cellpadding="0">
	<tr><td>
		
		<table width="100%" height="30" border="0" cellspacing="0" cellpadding="0" class="navigation_table">
		
			<!--- current DATE --->

			<cfset cr = dateformat(now(),client.dateSQL)>
			
			<cfif cr lt PerS>
				  <cfset CR = PerS>
			<cfelseif cr gt PerE>  
			      <cfset CR = PerE>
			</cfif>
			
			<!--- define box element that coincides with date --->
			<!--- define year --->
									
			<cfif Year(CR) eq SY>			
			   <cfset MthC = "0">
			   <cfset ElmC = (MthC + month(CR)-SM)*4>
			<cfelse>			
			   <cfset MthC = S[1]>
			   <cfset ElmC = (MthC + month(CR)-1)*4>			  
			</cfif>
						
			<!--- define month and element --->
			<cfif Day(CR) gte 23>
			   <cfset ElmC = ElmC+4>
			<cfelseif Day(CR) gte 16>   
			   <cfset ElmC = ElmC+3>
			<cfelseif Day(CR) gte 9> 
			   <cfset ElmC = ElmC+2>   
			<cfelseif Day(CR) gte 2> 
			   <cfset ElmC = ElmC+1>       
			</cfif>  	
																					
			<cfinclude template="ActivityProgressHeader.cfm">
														
			<cfset act = 0>	
			<cfset clrow = 0>
			<cfset dep = 0>
				
			<cfoutput query = "Activity" group="SubProject">
			
				<cfif Check.recordcount eq "0">
				
					<cfquery name="Project" 
				     datasource="AppsProgram" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
						SELECT    MIN(ActivityDateStart) AS ProjectStart, 
						          MAX(ActivityDate) AS ProjectEnd, 
								  CAST(MAX(ActivityDate) - MIN(ActivityDateStart) + 1 AS INTEGER) AS ProjectDays
						FROM      ProgramActivity
						WHERE     ProgramCode = '#ProgramCode#'  				
						AND       RecordStatus != '9'
						<cfif url.periodfilter neq "">
						AND       ActivityPeriod = '#url.periodfilter#'
						</cfif>
					</cfquery>	
					
				
				<cfelse>
				
					<cfquery name="Project" 
				     datasource="AppsProgram" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
						SELECT   MIN(ActivityDateStart) AS ProjectStart, 
						         MAX(ActivityDate) AS ProjectEnd, 
								 CAST(MAX(ActivityDate) - MIN(ActivityDateStart) + 1 AS INTEGER) AS ProjectDays
						FROM     ProgramActivity
						WHERE    ProgramCode = '#URL.ProgramCode#'  
						AND      RecordStatus != '9'
						<cfif ActivityClusterId eq "">
						AND      ActivityClusterId IS NULL
						<cfelse>
						AND      ActivityClusterId = '#ActivityClusterid#'
						</cfif>
					</cfquery>
					
									
				</cfif>
			
			   <cfinclude template="ActivityProgressCluster.cfm">				
							
			<cfoutput>					
						
				<cfinclude template="ActivityProgressTask.cfm">
							
			</cfoutput>
			
			</cfoutput>
			
		</table>
	</td></tr>
	
	</table>

</td></tr>

<cfif url.mode eq "Print">

	<tr><td class="noprint" align="center" height="47">
		<input type="button" name="Close" id="Close" value="Close Window" style="width:200px;height:25px;font-size:13px" onclick="window.close()" class="button10g">
	</td></tr>
	
	<script>
		window.print()
	</script>

</cfif>

</table>

</cf_divscroll>

<cfset ajaxonload("doHighlight")>
<script>
Prosis.busy('no')
</script>

