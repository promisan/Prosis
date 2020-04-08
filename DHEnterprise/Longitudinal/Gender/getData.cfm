<cfparam name="url.cntTotalTimes" 	default= "1">
<cfparam name="url.cntThisTime"	 	default= "1">
<cfparam name="url.contentResults"	default= "0">

<cfparam name="url.debug"	 default= "no">

<cfif url.level eq "null">
	<cfset url.level = "">
</cfif>
<cfset url.level = replace(url.level, "'", "", "ALL")>
<cfset url.level = ListQualify(url.level, "'")>

<cfset vMode = Session.Gender["Mode"]> 

<cfif url.source eq "Gender">

	<cfoutput>
	
	<cfsavecontent variable="vCondition">
	
			WHERE  Mission            = '#URL.Mission#'
			AND    Incumbency         = '100'
			AND    TransactionType 	  = '#thisPeriodicity#'
			<cfif URL.Division neq "">
			AND    MissionParent      = '#URL.Division#'
			</cfif>	 
			AND    SelectionDate      = '#URL.Date#'
			
			<cfif URL.Seconded eq "1">		<!-----gender parity ------>
				
				AND    AppointmentType NOT IN ('04')
				AND    ContractTerm NOT IN ('100','125','250')
				AND    left(#getParams.GenderField#,1) IN ('P','D')
				
				<cfif url.personGrade neq "">
				AND   #getParams.GenderField# = '#url.personGrade#'
				</cfif>	 
				
			<cfelseif URL.Seconded eq "5">
			
				AND    PositionSeconded    = '#URL.Seconded#'				
				<cfif url.personGrade neq "">
				AND   #getParams.CurrentField# = '#url.personGrade#'
				</cfif>	
				
			<cfelse>
								
				<cfif url.personGrade neq "">
				AND   #getParams.CurrentField# = '#url.personGrade#'
				</cfif>	
				
			</cfif>				
			
			<cfif URL.condition eq "Retirement">
			AND    Year(DateRetirement) <= Year(DATEADD(year, 6, GetDate()))
			AND    Year(DateRetirement) >= Year(GetDate())
			</cfif>
						
			<cfif url.level neq "">
				<!----check if this relates to GenderParity or Current Comp  is brought by url.field ------->
				<cfif url.seconded eq "1">
					AND     left(#getParams.GenderField#,2) IN (#preserveSingleQuotes(url.level)#)  /*rf1 vmode1 #url.seconded# this is the VAR sent in the AJAX*/
				<cfelse>
					AND     left(#getParams.CurrentField#,2) IN (#preserveSingleQuotes(url.level)#)  /*rf1 vmode2 #url.seconded# */
				</cfif>
				
			</cfif>
			
			<cfif URL.condition eq "Retirement">
				AND Year(DateRetirement) <= Year(DATEADD(year, 6, GetDate()))
				AND DateRetirement       >= GetDate()
			</cfif>
			
			<cfif URL.Uniformed eq "1">	
				AND    PositionSeconded   = '1' 
			<cfelseif URL.Uniformed eq "0">
				AND    PositionSeconded   = '0' 
			</cfif>		
			
	</cfsavecontent>
	
	</cfoutput>
	
	<cfquery name="checkPeriod" datasource="MartStaffing">
		SELECT    top 1 *
		FROM      Gender
		WHERE     Selectiondate = '#url.date#'		
	</cfquery>
	
	<cfif checkPeriod.recordcount eq "0">
	
		<cfset url.date = qPeriod.selectiondate>
	
	</cfif>
		
	<!--- keep the selection --->
	
	<cfset Session.Gender.Mission       = url.mission>
	<cfset Session.Gender.Mode          = url.seconded>
	<cfset Session.Gender.Uniformed          = url.uniformed>
	<cfset Session.Gender.Level         = url.level>
	<cfset Session.Gender.SelectionDate = url.date>
		
	<cfquery name="getData" 
		datasource="martStaffing">		 
			SELECT #url.field# as CategoryDescription, 
			       <cfif url.field neq url.order>#url.order# <cfelse>1</cfif> as CategoryOrder, 
				   COUNT(#url.countoption#) as Total
			FROM   Gender
			#PreserveSingleQuotes(vCondition)#
			GROUP BY #url.field#<cfif url.field neq url.order>, #url.order#</cfif>
			ORDER BY #url.order#    
	</cfquery>	
	
	
				
<cfelseif source eq "Recruitment">

	<cfset Session.Gender.Mission       = url.mission>
	<cfset Session.Gender.Mode          = url.seconded>
	<cfset Session.Gender.Uniformed     = url.uniformed>
	<cfset Session.Gender.Level         = url.level>
	<cfset Session.Gender.SelectionDate = url.date>

	<!---  
	<cfsavecontent variable="vDispositionException" >
		AND RecruitmentStage NOT LIKE '025 %'
		AND RecruitmentStage != 'UNSPECIFIED'
	</cfsavecontent>	
	--->

	<cfoutput>
	
		<cfsavecontent variable="vCondition" >
			WHERE Mission = '#URL.Mission#'
			
			<cfif Url.Category neq ""> 
				AND JobOpeningClass = '#url.Category#'
			<cfelse>
				AND JobOpeningClass IN ('Job Opening','Temporary Job Opening')	
			</cfif>	  
			
			<cfif URL.Seconded eq "1">									
				AND    left(PostGrade,1) IN ('P','D')
			</cfif>
						
			<cfif url.occgroup neq "">
				AND JobFamily = '#URL.occgroup#'
			</cfif>	
			<cfif url.level neq "">
				AND Left(PostGrade,2) IN (#preserveSingleQuotes(url.level)#)
			</cfif>	
			AND YEAR(JobOpeningPosted) = YEAR('#URL.Date#')
		</cfsavecontent>
		
	</cfoutput>

	<cfquery name="getData" 
		datasource="martStaffing">		 
		SELECT   #url.field# as CategoryDescription 
		         <cfif url.field neq url.order>, #url.order# <cfelse>,1</cfif> as CategoryOrder,
			     COUNT(#url.countoption#) as total
		FROM     Recruitment
				 #PreserveSingleQuotes(vCondition)#
		GROUP BY #url.field#<cfif url.field neq url.order>, #url.order#</cfif>
		ORDER BY #url.order#   
	</cfquery>
	
<cfelseif source eq "RecruitmentStage">	

	<cfset Session.Gender.Mission       = url.mission>
	<cfset Session.Gender.Mode          = url.seconded>
	<cfset Session.Gender.Level         = url.level>
	<cfset Session.Gender.SelectionDate = url.date>
	
	<cfoutput>
	
		<cfsavecontent variable="vCondition" >
			WHERE Mission = '#URL.Mission#'
			<cfif Url.Category neq ""> 
				AND JobOpeningClass = '#url.Category#'
			<cfelse>
				AND JobOpeningClass IN ('Job Opening','Temporary Job Opening')	
			</cfif>	  
			
			<cfif url.category eq "Temporary Job Opening">
			AND    PresentationLevel IN ('1. Application','4. Selected')
			</cfif>
			
			<cfif url.occgroup neq "">
				AND JobFamily = '#URL.occgroup#'
			</cfif>	
			<cfif URL.Seconded eq "1">									
				AND    left(PostGrade,1) IN ('P','D')
			</cfif>
			<cfif url.level neq "">
				AND Left(PostGrade,2) IN (#preserveSingleQuotes(url.level)#)
			</cfif>	
			AND YEAR(JobOpeningPosted) = YEAR('#URL.Date#')
		</cfsavecontent>
		
	</cfoutput>

	<cfquery name="getData" 
		datasource="martStaffing">		 
		SELECT   #url.field# as CategoryDescription 
		         <cfif url.field neq url.order>, #url.order# <cfelse>,1</cfif> as CategoryOrder,
			     COUNT(#url.countoption#) as total
		FROM     Recruitment S INNER JOIN RecruitmentStage R ON S.SelectionDate = R.SelectionDate AND S.Recordid = R.RecordId
		#PreserveSingleQuotes(vCondition)#
		GROUP BY #url.field#<cfif url.field neq url.order>, #url.order#</cfif>
		ORDER BY #url.order# 
	</cfquery>

</cfif>

<cfif getData.recordcount lte 0 and url.cntThisTime gte url.cntTotalTimes AND url.contentResults lte 0> <!---print only the last time when NO results AT ALL were found ---->
<cfoutput>
	<div class="hpanel" style="margin-top:-25px; text-align:center">
		<tr><td> <h4>this filter criteria does not produce any relevant data</h4> </td> </tr>
	</div>
</cfoutput>	

<cfelse>
	<cfset url.contentResults = url.contentResults + getData.recordcount>
</cfif>

<cfif url.debug eq "yes">  <cfdump var="#getData#"> </cfif>
