<cfparam name="url.context" 		default="">
<cfparam name="url.personGrade"		default="">

<cfset thisTemplate ="DashboardNation.cfm">
<cfinclude template = "determineMission.cfm">

<cfif url.context neq "">
	<cf vField	=	"#url.context#">
<cfelse>
	<!---- overwrite ---->
	<cfif url.seconded eq "1">
		<cfset vField = "GradeContract">
	<cfelse>
		<cfset vField = "PositionGrade">
	</cfif>
	
</cfif>

<cfif URL.showdivision eq "No">

	<cfif url.level eq "null">
		<cfset url.level = "">
	</cfif>
	<cfset url.level = replace(url.level, "'", "", "ALL")>
	<cfset url.level = ListQualify(url.level, "'")>

	<cfquery name="getMapData" 
		datasource="martStaffing">		
		 
			SELECT   NationalityCode,Country,			
			         Count(1) as Total,
					 (SELECT  count(1) 
					  FROM    Gender 
			          WHERE   Mission         = '#URL.Mission#'
          			  AND     Incumbency      = '100'
					  
					  <cfif URL.Seconded eq "1">
							AND    AppointmentType NOT IN ('04')
							AND    ContractTerm NOT IN ('100','125','250')
							AND    left(#vField#,1) IN ('P','D')
				
							<cfif url.personGrade neq "">
								AND   #getParams.GenderField# = '#url.personGrade#'
								</cfif>	
						<cfelseif URL.Seconded eq "5">
						AND       PositionSeconded   = '#URL.Seconded#'	
						<cfif url.personGrade neq "">
								AND   #getParams.CurrentField# = '#url.personGrade#'
								</cfif>
						<cfelse>
						
						<cfif url.personGrade neq "">
								AND   #getParams.CurrentField# = '#url.personGrade#'
								</cfif>	
						</cfif>		
					  
					  <cfif URL.Uniformed eq "1">	
						AND    PositionSeconded   = '1'
					  <cfelseif URL.Uniformed eq "0">
						AND    PositionSeconded   = '0' 
					  </cfif>	
					  		
			          AND     MissionParent  != ''
					  AND     Gender          = 'M'
					  AND     NationalityCode = G.NationalityCode
			          AND     SelectionDate   = '#URL.Date#') as TotalMale
					  
			FROM     Gender G
			WHERE    Mission        = '#URL.Mission#'
			AND      Incumbency     = '100'
			
			<cfif URL.Seconded eq "1">
				AND    AppointmentType NOT IN ('04')
				AND    ContractTerm NOT IN ('100','125','250')
				AND    left(#vField#,1) IN ('P','D')
	
				<cfif url.personGrade neq "">
					AND   #getParams.GenderField# = '#url.personGrade#'
					</cfif>	
			<cfelseif URL.Seconded eq "5">
			AND       PositionSeconded   = '#URL.Seconded#'	
			<cfif url.personGrade neq "">
					AND   #getParams.CurrentField# = '#url.personGrade#'
					</cfif>
			<cfelse>
			
			<cfif url.personGrade neq "">
					AND   #getParams.CurrentField# = '#url.personGrade#'
					</cfif>	
			</cfif>		
			
			
			<cfif URL.Uniformed eq "1">	
				AND    PositionSeconded   = '1'
			<cfelseif URL.Uniformed eq "0">
				AND    PositionSeconded   = '0' 
			</cfif>		
			
			<cfif url.level neq "">
			
				AND     left(#vField#,2) IN (#preserveSingleQuotes(url.level)#)
			
			</cfif>
					
			AND      MissionParent != ''
			AND      SelectionDate  = '#URL.Date#'
			GROUP BY NationalityCode, Country
			
	</cfquery>	
	
	<cfset vDataList = "">
	<cfoutput query="getMapData">
	    <cfset ratio = round((totalmale*1000)/total)/10>
		<cfset vDataList = vDataList & "{id:'#NationalityCode#', value:#ratio#}">
		<cfif currentrow neq recordCount>
			<cfset vDataList = vDataList & ", ">
		</cfif>
	</cfoutput>	
	
	<cfquery name="getTotal" dbtype="query">
		SELECT 	SUM(Total) as Total
		FROM 	getMapData
	</cfquery>
	
	<cf_mobileRow>
		<div align="center" class="chartwrapper" style="padding-left:40px">
	  		<div id="mymap" class="chartdiv"></div>
		</div>
	</cf_mobileRow>
		
	<cf_mobileRow>
	
		<cf_mobileCell class="col-lg-6">
			<cfset url.field    = "LocationCountry">
			<cfset url.order    = "LocationCountry">
			<cfset url.title    = "Distribution by Region">
			<cfset url.division = "">
			<cfset url.id       = "LocationCountry">
			<cfset url.column   = "gender">
			<cfset url.content  = "table">
			
			<cfinclude template="doGraphMultiple.cfm">
			
		</cf_mobileCell>
		
		<cf_mobileCell class="col-lg-6">
			<cfset url.field    = "Country">
			<cfset url.order    = "NationalityCode">
			<cfset url.title    = "Distribution by Country">
			<cfset url.division = "">
			<cfset url.id       = "NationalityCode">
			<cfset url.column   = "gender">
			<cfset url.content  = "table">
			
			<cfinclude template="doGraphMultiple.cfm">
			
		</cf_mobileCell>
			
	</cf_mobileRow>	
	
	<cf_tl id="Employees" var="vLblEmployee">
	<cfset ajaxOnLoad("function(){  resetMap_1('Female', 'Male', '<span style=\'font-size:14px;\'><b>[[title]]</b>: [[value]]% Male </span>', [#vDataList#]); }")>
	
</cfif>

