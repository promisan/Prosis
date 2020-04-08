
<cfif url.level eq "null">
	<cfset url.level = "">
</cfif>
<cfset url.level = replace(url.level, "'", "", "ALL")>
<cfset url.level = ListQualify(url.level, "'")>

<cfif URL.source eq "Gender">

	<cfquery name="qHeaderValue" 
		datasource="MartStaffing">		 
			SELECT #url.column# as Description, 
			       COUNT(#url.countoption#) as total
			FROM   Gender 
			WHERE  SelectionDate = '#URL.Date#'
			AND    Mission       = '#URL.Mission#'
			AND    Incumbency    = '100'
			
			AND    TransactionType 	  = '#thisPeriodicity#'
			
			AND    #url.column#  = '#qHeader.ColumnName#'
			
			AND    #URL.field#   = '#getData.CategoryDescription#'
			
			<cfif URL.Division neq "">
				AND   MissionParent   = '#URL.Division#'
			</cfif>	
						
			<cfif URL.Uniformed eq "1">	
				AND    PositionSeconded   = '1'
			<cfelseif URL.Uniformed eq "0">
				AND    PositionSeconded   = '0' 
			</cfif>	
			
			<cfif URL.Seconded eq "1">
			
			    AND    AppointmentType NOT IN ('04')
				AND    ContractTerm NOT IN ('100','125','250')
				/*rfuentes AND    PositionSeconded    = '0' */	
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
			
			<cfif url.level neq "">
			
				<cfif URL.Seconded eq "1">		
				AND     left(#getParams.GenderField#,2) IN (#preserveSingleQuotes(url.level)#)
				<cfelse>
				AND     left(#getParams.CurrentField#,2) IN (#preserveSingleQuotes(url.level)#)
				</cfif>
			
			</cfif>
			
			<cfif URL.condition eq "Retirement">
				AND Year(DateRetirement) <= Year(DATEADD(year, 6, GetDate()))
				AND DateRetirement       >= GetDate()
			</cfif>				
						
			AND   SelectionDate = '#URL.Date#'
			
			GROUP BY #url.column#  /*adjusted for seconded url variable */
			
	</cfquery>
	
<cfelseif source eq "Recruitment">

	<cfquery name="qHeaderValue" 
		datasource="martStaffing">	
			 
			SELECT #url.column# as Description, COUNT(#url.countoption#) as total
			FROM   Recruitment
			WHERE  Mission = '#URL.Mission#'
			AND    #url.column# = '#qHeader.ColumnName#'
			AND    #URL.field# = '#getData.CategoryDescription#'
			<cfif URL.Category neq "">
			AND    JobOpeningClass = '#url.Category#'
			
			
			
			</cfif>						
			<cfif URL.Seconded eq "1">									
				AND    left(PostGrade,1) IN ('P','D')
			</cfif>		
					
			
			<cfif url.occgroup neq "">
			AND    JobFamily = '#URL.occgroup#'
			</cfif>	
			<cfif url.level neq "">
			AND    left(PostGrade,2) IN (#preserveSingleQuotes(url.level)#)
			</cfif>															
			AND    YEAR(JobOpeningPosted) = YEAR('#URL.Date#')
			GROUP BY #url.column#
			
			
	</cfquery>		
	
<cfelseif source eq "RecruitmentStage">	

	<cfquery name="qHeaderValue" 
		datasource="martStaffing">	
			 
			SELECT  #url.column# as Description, 
			        COUNT(#url.countoption#) as total
			FROM    Recruitment S INNER JOIN RecruitmentStage R ON S.SelectionDate = R.SelectionDate AND S.Recordid = R.RecordId		
			WHERE   Mission      = '#URL.Mission#'
			AND     #url.column# = '#qHeader.ColumnName#'
			AND     #URL.field#  = '#getData.CategoryDescription#'
			<cfif URL.Category neq "">
			AND     JobOpeningClass = '#url.Category#'
			</cfif>			
			<cfif url.category eq "Temporary Job Opening">
			AND    PresentationLevel IN ('1. Application','4. Selected')
			</cfif>
			
			<cfif URL.Seconded eq "1">									
			AND   left(PostGrade,1) IN ('P','D')
			</cfif>
								
			
			<cfif url.occgroup neq "">
			AND   JobFamily = '#URL.occgroup#'
			</cfif>	
			<cfif url.level neq "">
			AND   left(PostGrade,2) IN (#preserveSingleQuotes(url.level)#)
			</cfif>															
			AND   YEAR(JobOpeningPosted) = YEAR('#URL.Date#')
			GROUP BY #url.column#
			
	</cfquery>	
	
		
	
</cfif>	

<cfif url.debug eq "yes">  <cfdump var="#qHeaderValue#"> </cfif>