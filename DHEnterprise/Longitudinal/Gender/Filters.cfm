<cfparam name="url.showDetail"  default="1">
<cfset CLIENT.DateFormatShow  = "dd/mm/yyyy">

<cfparam name="session.authent"   default="0">
<cfparam name="URL.Source"        default="Gender">

<cfif isDefined("session.acc") AND TRIM(Session.acc) neq "">
	<cfset url.showDetail	= "1">
	<cfelse>
	<cfset url.showDetail	= "0">
</cfif>

<cfif URL.source eq "Gender">

	<cfquery name="qPeriod" datasource="MartStaffing">
		SELECT    DISTINCT SelectionDate, (SELECT Status FROM Period WHERE SelectionDate = G.SelectionDate) as Status
		FROM      Gender as G
		WHERE 1=1
		<cfif session.authent eq 0>
			AND  SelectionDate > '12/31/2018'
		</cfif>	
			AND TransactionType = '#thisPeriodicity#'
		ORDER BY  SelectionDate DESC
	</cfquery>
	
<cfelse>

	<cfquery name="qPeriod" datasource="martStaffing">
		SELECT    YEAR(JobOpeningPosted) as SelectionDate,'5' as Status
		FROM      Recruitment
		WHERE     JobOpeningPosted IS NOT NULL
		GROUP BY  YEAR(JobOpeningPosted)
		ORDER BY  YEAR(JobOpeningPosted) DESC
	</cfquery>
			
</cfif>	

<cfinclude template="determineMission.cfm">

<cfquery name="qMission" 
	datasource="martStaffing">		 
		SELECT   DISTINCT Mission
		FROM     Gender 
		WHERE    Incumbency = '100'
		AND      MissionParent != ''		
		ORDER BY Mission		
</cfquery>

<cfparam name="Session.Gender.Mission"        default="#qMission.Mission#">
<cfparam name="Session.Gender.Mode"           default="1">
<cfparam name="Session.Gender.Uniformed"      default="0">
<cfparam name="Session.Gender.SelectionDate"  default="#qPeriod.SelectionDate#">
<cfparam name="Session.Gender.Level"          default="">

<cfparam name="URL.Mission"    default="#Session.Gender['Mission']#">
<cfparam name="URL.Seconded"   default="#Session.Gender['Mode']#">
<cfparam name="URL.Uniformed"  default="#Session.Gender['Uniformed']#">
<cfparam name="URL.Date"       default="#Session.Gender['SelectionDate']#">
<cfparam name="URL.Level"      default="#Session.Gender['Level']#">


<cfoutput>
	<cf_mobileRow>
	
		<cf_mobileCell class="col-lg-2 text-center m-t-md">
		
			<select class="form-control" name="pDate" id="pDate" 
				onchange="applyFilter('#vTemplate#','#URL.showdivision#', 'statsDetail')">

				<cfloop query="qPeriod">
				    <cfif URL.source eq "Gender">
					<option value="#qPeriod.SelectionDate#" <cfif qPeriod.SelectionDate eq Session.Gender["SelectionDate"]>selected='selected'</cfif>>							
							<cfif qPeriod.Status eq "0">
									As of today
								<cfelse>
									#DateFormat(qPeriod.SelectionDate,CLIENT.DateFormatShow)#									
							</cfif>
					</option>
					<cfelse>
					<option value="01/01/#qPeriod.SelectionDate#" <cfif qPeriod.SelectionDate eq Session.Gender["SelectionDate"]>selected='selected'</cfif>>							
						<cfif qPeriod.Status eq "0">
							As of today
							<cfelse>
							#SelectionDate#																
						</cfif>
						   
					</option>
					</cfif>
				</cfloop> 
			</select>
				
		</cf_mobileCell>
				
		<cf_mobileCell class="col-lg-2 text-center m-t-md">
		
			<cfif url.source eq "Gender">
		
				<cfquery name="qMission" 
					datasource="martStaffing">		 
						SELECT   DISTINCT Mission, MissionLabel <cfif url.showDetail neq "1">, LEN(Mission) </cfif>
						FROM     Gender 
						WHERE    Incumbency = '100'
						AND      MissionParent != ''
						AND 	 Mission IN (#preserveSingleQuotes(myValidMissions)#)						
						AND 	 TransactionType = '#thisPeriodicity#'						
						ORDER BY MissionLabel, <cfif url.showDetail neq "1"> LEN(Mission) <cfelse> Mission </cfif>  DESC	
						
						
							
				</cfquery>
								
			
			<select class="form-control" name="pMission" id="pMission" 
				onchange="applyFilter('#vTemplate#','#URL.showdivision#', 'statsDetail')" style="min-width:110px;">
				<cfloop query="qMission">
					<cfset vEntity=Trim(qMission.Mission)>		
					<option value="#vEntity#" <cfif vEntity eq Session.Gender["Mission"]>selected='selected'</cfif>>#vEntity#</option>
				</cfloop>
			</select>
			
			<cfelse>
									
				<cfquery name="qMission" 
					datasource="martStaffing">		 
						SELECT   DISTINCT Mission
						FROM     Recruitment 
						WHERE    Mission IN (
						
							SELECT   DISTINCT Mission
							FROM     Gender 							
							WHERE    MissionParent != ''
						
						)			
						
						<cfif getAdministrator('*') neq '1'>
							AND Mission IN (#preserveSingleQuotes(myValidMissions)#)
						</cfif>
													
						ORDER BY Mission		
						
				</cfquery>
			
				<select class="form-control" name="pMission" id="pMission" 
					onchange="applyFilter('#vTemplate#','#URL.showdivision#', 'statsDetail')">
					<cfloop query="qMission">
						<cfset vEntity=Trim(qMission.Mission)>		
						<option value="#vEntity#" <cfif vEntity eq Session.Gender["Mission"]>selected='selected'</cfif>>#vEntity#</option>
					</cfloop>
				</select>
			
			
			</cfif>
			
		</cf_mobileCell>
					
			<cfif url.source eq "Gender">
				
				<cf_mobileCell class="col-lg-3 text-center m-t-md clsSecondmentContainer">
			
				<select class="form-control" name="pSeconded" id="pSeconded" 
					onchange="applyFilter('#vTemplate#','#URL.showdivision#', 'statsDetail')" style="font-size:10px;">
						<option value="1" <cfif Session.Gender["Mode"] eq "1"> selected="selected"</cfif>>
							GENDER PARITY STRATEGY: personal grade EXCL. temporary assignment.
						</option>
						<option value="2" <cfif Session.Gender["Mode"] eq "2">selected="selected"</cfif>>
							CURRENT COMPOSITION: post level INCL. temporary assignment.
						</option>
				</select>
				
				</cf_mobileCell>
				
				<cf_mobileCell class="col-lg-2 text-center m-t-md clsSecondmentContainer">
			
				<select class="form-control" name="pUniformed" id="pUniformed" 
					onchange="applyFilter('#vTemplate#','#URL.showdivision#', 'statsDetail')">
						<option value="2" <cfif Session.Gender["Uniformed"] eq "2">selected="selected"</cfif>>
							All Personnel
						</option>
						<option value="0" <cfif Session.Gender["Uniformed"] eq "0">selected="selected"</cfif>>
							Civilian
						</option>
						<option value="1" <cfif Session.Gender["Uniformed"] eq "1">selected="selected"</cfif>>
							Seconded
						</option>
				</select>
				
				</cf_mobileCell>				
				
				
				<cf_mobileCell class="col-lg-2 text-center m-t-md">
								
				<select name="pLevel" id="pLevel" multiple="multiple" style="width:150px;"
					onchange="applyFilter('#vTemplate#','#URL.showdivision#', 'statsDetail')">
						<option value="US" <cfif Session.Gender["Level"] eq "US">selected='selected'</cfif>>
							USG-Level
						</option>
						<option value="AS" <cfif Session.Gender["Level"] eq "AS">selected='selected'</cfif>>
							ASG-Level
						</option>
						<option value="D-" <cfif Session.Gender["Level"] eq "D">selected='selected'</cfif>>
							D-Level
						</option>
						<option value="P-" <cfif Session.Gender["Level"] eq "P">selected='selected'</cfif>>
							P-Level
						</option>
						<option value="G-" <cfif Session.Gender["Level"] eq "G">selected='selected'</cfif>>
							G-Level
						</option>

				</select>
				
				</cf_mobileCell>
				
				
			<cfelse>
			
				<cf_mobileCell class="col-lg-2 text-center m-t-md">
			
				<input type="hidden" value="2" name="pSeconded" id="pSeconded" >
				
				<select name="pLevel" id="pLevel" multiple="multiple" style="width:150px;"
					onchange="applyFilter('#vTemplate#','#URL.showdivision#', 'statsDetail')">
						<option value="US" <cfif URL.Level eq 'US'>selected='selected'</cfif>>
							USG-Level
						</option>
						<option value="AS" <cfif URL.Level eq 'AS'>selected='selected'</cfif>>
							ASG-Level
						</option>
						<option value="D-" <cfif URL.Level eq 'D'>selected='selected'</cfif>>
							D-Level
						</option>
						<option value="P-" <cfif URL.Level eq 'P'>selected='selected'</cfif>>
							P-Level
						</option>
						<option value="G-" <cfif URL.Level eq 'G'>selected='selected'</cfif>>
							G-Level
						</option>

				</select>
				
				</cf_mobileCell>
				
			</cfif>
				
		<cf_mobileCell class="col-lg-1 text-center m-t-md hidden-xs">
			<button 
				class="btn btn-default clsNoPrint" 
				onclick="___prosisMobileWebPrint('##mainContainer', true, '#session.root#/DHEnterprise/Longitudinal/Gender/Styles/printStyle.css?ts=#gettickcount()#', '')"
				style="height:33px;">
					<span class="glyphicon glyphicon-print"></span>
			</button>
			<!---- we hide this button for now, rfuentes 27-Jun2019  
			<button class="btn btn-default clsNoPrint" id="btnExportExcel">
				<span class="fa fa-file-excel-o"></span>
			</button>
			--->
		</cf_mobileCell>
					
	</cf_mobileRow>
	
</cfoutput>

<cfset ajaxOnload("function(){ $('##pLevel').multipleSelect().multipleSelect('checkAll'); }")>