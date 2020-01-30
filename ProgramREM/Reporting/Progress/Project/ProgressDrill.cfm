
<cfparam name="URL.Period"      default="FY05">
<cfparam name="URL.ProgramCode" default="PC5329">

<cfquery name="Program" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT *
     FROM   Program
	 WHERE  ProgramCode = '#URL.ProgramCode#'
	</cfquery>
	
<cfset mission = program.mission>	

<cfset gcolor = "ffffff">
		
	<cfquery name="DisplayPeriod" 
	  datasource="AppsProgram" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT * 
		FROM   Ref_Period 
		WHERE  Period='#URL.Period#'
	 </cfquery>
	 
	 <cfset suf = round(Rand()*100)>
	 
	 <cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#ProgramProgress#Suf#">
	 
	 <cfquery name="CreateTable"
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		CREATE TABLE dbo.#SESSION.acc#ProgramProgress#Suf# (
			[ProgramCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
			[ProgressType] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
			[Date] [datetime] NULL ,
			[DateText] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
			[Weight] [float] NOT NULL
		) ON [PRIMARY]
	</cfquery>
				
	<cfset dts = DisplayPeriod.DateEffective>
	<cfset dte = DisplayPeriod.DateExpiration>
	
	<!--- generate a subset with relevant activity for the project --->
	
	<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Activity#Suf#"> 
	     
	<cfquery name="RolledUp"
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
	    SELECT    ProgramCode AS ProjectCode, *
		INTO 	  userQuery.dbo.#SESSION.acc#Activity#suf#
		FROM      ProgramActivity PA
		WHERE     ProgramCode = '#URL.ProgramCode#' 
		AND       RecordStatus != '9'
		AND       PA.ProgramCode NOT IN (SELECT  ProgramCode 
	                                     FROM    ProgramPeriod 
							    		 WHERE   ProgramCode = PA.ProgramCode
									     AND     Period = '#URL.Period#' 
									     AND     RecordStatus = '9')

		UNION ALL
		
		SELECT    Pe.PeriodParentCode AS ProjectCode, PA.*
		FROM      ProgramActivity PA, Program P, ProgramPeriod Pe
		WHERE     PA.ProgramCode      = P.ProgramCode		 
		AND       P.ProgramClass      = 'Project'
		AND       Pe.ProgramCode      = P.ProgramCode
		AND       Pe.Period           = '#URL.Period#'
		AND       Pe.PeriodParentCode = '#URL.ProgramCode#'
		AND       PA.RecordStatus != '9' 
		AND       Pe.RecordStatus != '9'
		
		ORDER BY  ProjectCode 
		
	</cfquery>
	 	
	<cfloop condition="#dts# lt #dte#">
					
		<cfset check = dts + daysinmonth(dts) -1>
		<cfset text  = "#left(MonthAsString(Month(check)),'3')# #dateformat(check,'yy')#">
		<cfset dts   = dts + daysinmonth(dts)>
						
		<!--- planning --->	
				
		<cfquery name="Last" 
	    datasource="AppsProgram" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		
			SELECT   MAX(ProgressStatusDate) as ProgressStatusDate
			FROM     ProgramActivityProgress
			WHERE    ProgramCode = '#URL.ProgramCode#' 
			AND      RecordStatus != '9'
			
			UNION ALL
			
			SELECT   MAX(ProgressStatusDate) as ProgressStatusDate
			FROM     ProgramActivityProgress PG, Program P, ProgramPeriod Pe
			WHERE    PG.ProgramCode         = P.ProgramCode 
			AND      P.ProgramClass         = 'Project'
			AND      Pe.ProgramCode         = P.ProgramCode
			AND      Pe.Period              = '#URL.Period#'
			AND      PG.RecordStatus       != '9'
			AND      Pe.RecordStatus       != '9'
			AND      Pe.PeriodParentCode    = '#URL.ProgramCode#'
			
		</cfquery>
		
		<cfquery name="TotalWeight" 
	    datasource="AppsProgram" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
			SELECT   ProjectCode, SUM(ActivityWeight) AS ActivityWeight
			FROM     userQuery.dbo.#SESSION.acc#Activity#suf#
			GROUP BY ProjectCode	
		</cfquery>
		
		<cfset Total = TotalWeight.ActivityWeight>
		
		<cfif Total eq "0">
		    <cfset Total = "0.01">
		</cfif>  
		
		<cfquery name="Plan" 
	    datasource="AppsProgram" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
			SELECT   DISTINCT ProjectCode 
			FROM     userQuery.dbo.#SESSION.acc#Activity#suf#
			WHERE    ActivityDate <= #check#
		</cfquery>
		
		<cfif Plan.recordcount eq "0">
		
			<cfquery name="Plan" 
		    datasource="AppsProgram" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
				INSERT INTO userQuery.dbo.#SESSION.acc#ProgramProgress#Suf#
				         (ProgramCode, ProgressType, Date, DateText, Weight)
				VALUES   ('#URL.ProgramCode#', 'Planning', '#DateFormat(Check,CLIENT.DateSQL)#', 
				'#DaysInMonth(check)# #text#',0)
			</cfquery>
		
		<cfelse>
		
			<cfquery name="Plan" 
		    datasource="AppsProgram" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			INSERT INTO userQuery.dbo.#SESSION.acc#ProgramProgress#Suf#
			         (ProgramCode, ProgressType, Date, DateText, Weight)
			SELECT   ProjectCode, 
			         'Planning', 
			         '#DateFormat(Check,CLIENT.DateSQL)#', 
					 '#DaysInMonth(check)# #text#',
          			 SUM(ActivityWeight*100/#Total#) AS ActivityWeight
			FROM     userQuery.dbo.#SESSION.acc#Activity#suf#
			WHERE    ActivityDate <= #check#
			GROUP BY ProjectCode	
			</cfquery>
		
		</cfif>
		
		<!--- actual --->
				
		<cfset d = DaysInMonth(now()) - day(now())>
		
		<cfif Check lte (now()+d) or check lte Last.ProgressStatusDate>
			
			<!--- here --->
			
			<cfset FileNo = suf>			
			<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#ActivityPending#FileNo#">
								
			<cfset ProgramFilter = "ProgramCode IN (SELECT DISTINCT ProgramCode FROM userQuery.dbo.#SESSION.acc#Activity#suf#)">		
			<cfset DateFilter    = "O.ProgressStatusDate <= '#DateFormat(check,CLIENT.DateSQL)#'">	
			<cfinclude template  = "../../../Application/Tools/ProgramActivityPendingPrepare.cfm">
						
			<cfquery name="CompleteCheck" 
			 datasource="AppsProgram" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT   ProgramCode 
			 FROM     userQuery.dbo.#SESSION.acc#Activity#suf#
			 WHERE    ActivityId NOT IN (SELECT ActivityId 
			                             FROM userQuery.dbo.#SESSION.acc#ActivityPending#FileNo#)
			</cfquery>						   
			
			<cfif CompleteCheck.recordcount eq "0">
			
				<cfquery name="CompleteActivity" 
				    datasource="AppsProgram" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					INSERT INTO userQuery.dbo.#SESSION.acc#ProgramProgress#suf#
							(ProgramCode, ProgressType, Date, DateText, Weight)
					VALUES  ('#URL.ProgramCode#', 
					         'Actual', 
							 '#DateFormat(Check,CLIENT.DateSQL)#', 
							 '#DaysInMonth(check)# #text#',
							 0)
					</cfquery>
			
			<cfelse>
					
				<cfquery name="CompleteActivity" 
				 datasource="AppsProgram" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 
					INSERT INTO userQuery.dbo.#SESSION.acc#ProgramProgress#suf#
					     (ProgramCode, ProgressType, Date, DateText, Weight)
						 						 
					SELECT    ProgramCode, 
					          'Actual', 
							  '#DateFormat(Check,client.DateSQL)#', 
							  '#DaysInMonth(check)# #text#', 
							  SUM(ActivityWeight*100/#Total#) AS ActivityWeight 
							  
					FROM      userQuery.dbo.#SESSION.acc#Activity#suf#
					WHERE     ActivityId NOT IN (SELECT ActivityId 
					                             FROM userQuery.dbo.#SESSION.acc#ActivityPending#FileNo#)
					GROUP BY  ProgramCode	
					
				</cfquery>
			
			</cfif>
								
			<!--- now I can define the complete activities as the activities not in ActivityPending and add to the table --->
			<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#ActivityPending#FileNo#">
							
		</cfif>
						
	</cfloop>
	
	<!--- adjust the weight to a scale of 0..1 as it was multiplied by 100 --->	
		
	<cfquery name="Update" 
	  datasource="AppsQuery" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    UPDATE #SESSION.acc#ProgramProgress#Suf#  
		SET    Weight = Weight/100
	</cfquery>
	 	 
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding <cfoutput>section_#URL.ProgramCode#</cfoutput>">
				 
	<tr><td align="center" valign="middle">
	
	<table width="100%" border="0" bordercolor="silver">
	
	<tr><td class="labelmedium" colspan="1" style="padding-left:9px">
	    <font face="Calibri" size="3"><cf_tl id="Project Output and Progress Status"></td>
	    <td class="labelmedium" style="padding-right:5px;">
			<cfoutput>
				<span id="printTitle_#URL.ProgramCode#" style="display:none;"><cf_tl id="Project Output and Progress Status"> - #Program.ProgramName# [#Program.ProgramCode#]</span>
				<cf_tl id="Print" var="1">
				<cf_button2 
					mode		= "icon"
					type		= "Print"
					title       = "#lt_text#" 
					id          = "Print"					
					height		= "30px"
					width		= "35px"
					printTitle	= ".section_#URL.ProgramCode# ##printTitle_#URL.ProgramCode#"
					printContent = ".section_#URL.ProgramCode# .clsPrintContent_#URL.ProgramCode#">
			</cfoutput>
		</td>
	</tr>
	
	<tr><td colspan="2" class="linedotted"></td></tr>
	
	<tr><td align="center" class="<cfoutput>clsPrintContent_#URL.ProgramCode#</cfoutput>">

	<cf_tl id="Month" var="1">
	<cfset tMonth = "#Lt_text#">

	<cf_tl id="Progress" var="1">
	<cfset tProgress = "#Lt_text#">

	<cf_tl id="Output due" var="1">
	<cfset tOutuptDue = "#Lt_text#">	
	
	<cf_tl id="Actual" var="1">
	<cfset tActual = "#Lt_text#">	
			
	<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
	
<cfchart style = "#chartStyleFile#" format="png"
       chartheight="250"
       chartwidth="#CLIENT.width-470#"
       showygridlines="yes" showborder="no"
       seriesplacement="default"
       labelformat="percent" showlegend="yes"
       show3d="no" backgroundcolor="#gcolor#"
	   fontsize="9" scalefrom="0" scaleto="1"
	   font="Calibri"
	   <!--- title="#Title.IndicatorDescription#"  
	   tipbgcolor="E9E9D1"
	   --->
	   url="javascript:search('$ITEMLABEL$','#URL.ProgramCode#','#url.Period#')"
       pieslicestyle="solid"
	   showxgridlines="yes"
       sortxaxis="no"
       xAxisTitle="#tMonth#"
	   yAxisTitle="#tProgress#">
	   
	   <cfquery name="Planning" 
		  datasource="AppsQuery" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		    SELECT * 
			FROM   #SESSION.acc#ProgramProgress#Suf# 
			WHERE  ProgressType = 'Planning'
		</cfquery>
	 			   
	   <cfchartseries type="curve"
	        query="Planning"
	        itemcolumn="DateText"
	        valuecolumn="Weight"
	        serieslabel="#tOutuptDue#"
	        seriescolor="gray"
	        paintstyle="raise"
	        markerstyle="circle"/> 
			
	    <cfquery name="Actual" 
		  datasource="AppsQuery" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		    SELECT * 
			FROM   #SESSION.acc#ProgramProgress#Suf# 
			WHERE  ProgressType = 'Actual' 
		</cfquery>	
	
	   <cfchartseries type="curve"
	        query="Actual"
	        itemcolumn="DateText"
	        valuecolumn="Weight"
	        serieslabel="#tActual#"
	        seriescolor="6688aa"
	        paintstyle="raise"
	        markerstyle="circle"/>
			 			 
	</cfchart>
	
	</td></tr>		
	<cfoutput>	
		
	<tr id="searching" class="hide"><td colspan="2" align="center">
	<img src="#SESSION.root#/images/busy9.gif" alt="" border="0">
	</td></tr>
	<tr>
		<td width="99%" colspan="2" align="center" valign="middle" id="#url.Programcode#_result" class="clsPrintContent_#URL.ProgramCode#">
		    <cfset text = "None">
		    <cfinclude template="ProgressDrillDetail.cfm">
		</td>
	</tr>
	</cfoutput>
		
	</table>
	
	</td></tr>
	
	</table>	
	
	<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#ProgramProgress#Suf#">  
	<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Activity#Suf#"> 
	
	
	<script>
	 Prosis.busy('no')
	</script>
