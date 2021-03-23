
<cfparam name="url.default" default="">

<cfswitch expression="#url.field#">

	<cfcase value="apptstatus">
	
		<cfquery name="Scope" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				    SELECT *
				    FROM   Ref_AppointmentStatusMission
					WHERE  Mission = '#URL.mission#'
		</cfquery>			
		
		<cfif scope.recordcount eq "0">
		
				<cfquery name="AppStatus" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM   Ref_AppointmentStatus		
					WHERE  Operational = 1						
				</cfquery>				
										
		<cfelse>
			
				<cfquery name="AppStatus" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM   Ref_AppointmentStatus
					WHERE  Operational = 1	
					AND    Code	IN ( 
							    SELECT AppointmentStatus
							    FROM   Ref_AppointmentStatusMission
								WHERE  Mission = '#url.mission#'									 
							 )
				</cfquery>							
										
		</cfif>	
				
		<cfset val = quotedvalueList(AppStatus.Code)>
			
		<cfquery name="list" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Ref_AppointmentStatus
				WHERE  Code IN (SELECT AppointmentStatus 
				             	FROM   Ref_AppointmentStatusContract
								WHERE  ContractType = '#url.contracttype#'
								<cfif val neq "">								
								AND    AppointmentStatus IN (#preservesingleQuotes(val)#)
								</cfif>
								)
		</cfquery>	
		
		<cfif list.recordcount eq "0">
			
			<cfquery name="list" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM   Ref_AppointmentStatus
						<cfif val neq "">	
						WHERE  Code IN (#preservesingleQuotes(val)#)
						</cfif>
				</cfquery>	
		
		</cfif>
		
		
		<table>
		<tr><td>
		<cfoutput>
	  	<select name="AppointmentStatus" size="1"  class="regularxxl">
		<cfloop query="list">
			<option value="#Code#" <cfif Code eq url.default>selected</cfif>>
	    		#Description#
			</option>
		</cfloop>
	    </select>
		
		</td>
		
		<td style="padding-left:4px"><input type="text" name="AppointmentStatusMemo" maxlength="100" class="regularxxl" style="min-width:240px"></td>
		
		</td></tr></table>
		</cfoutput>
			
	</cfcase>		
	
	<cfcase value="contracttype">
	
		<cfquery name="Scope" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM   Ref_ContractTypeMission
				WHERE  Mission = '#url.mission#' 
		</cfquery>
									
		<cfquery name="ContractType" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM   Ref_ContractType
				WHERE  Operational = 1
				<cfif scope.recordcount gte "1">
				AND    ContractType IN (SELECT ContractType
				                        FROM   Ref_ContractTypeMission
			                            WHERE  Mission = '#url.mission#')
				</cfif>						
		</cfquery>
				
		<cfoutput>
	  	<select name="ContractType" id="ContractType"
		     size="1" 
			 class="regularxxl" 
			 onchange="_cf_loadingtexthtml='';ptoken.navigate('getFinancialEntitlement.cfm?id=#url.id#&contracttype='+this.value+'&salaryschedule='+document.getElementById('salaryschedule').value,'boxentitlement');ptoken.navigate('#SESSION.root#/staffing/Application/Employee/Contract/ContractField.cfm?field=apptstatus&mission=#url.mission#&default=&contracttype='+this.value,'fldappstatus')">
				<cfloop query="ContractType">
					<option value="#ContractType#" <cfif ContractType eq url.default>selected</cfif>>
			    		 #Description#
					</option>
				</cfloop>
	    </select>
		</cfoutput>	
		
	</cfcase>	
	
	<cfcase value="contractlevel">
	
		<cfquery name="Scope" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM   Ref_PostgradeParentMission
				WHERE  Mission = '#url.mission#'
				AND Mode = 'Edit'
		</cfquery>
		
		<cfif scope.recordcount eq "0">
					
			<cfquery name="PostGrade" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM   Ref_PostGrade
				WHERE  PostGradeContract = 1
				ORDER BY PostOrder
			</cfquery>
		
		<cfelse>
		
			<cfquery name="PostGrade" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT   *
			    FROM     Ref_PostGrade
				WHERE    PostGradeContract = 1
				AND      PostGradeParent IN (SELECT PostGradeParent
					                        FROM    Ref_PostgradeParentMission
				                            WHERE   Mission = '#url.mission#'
											AND     Mode = 'Edit'
											)				
				ORDER BY PostOrder
			</cfquery>
		
		</cfif>
		
		<select name="contractlevel" size="1" class="regularxxl" 
		    onchange="ptoken.navigate('<cfoutput>#SESSION.root#</cfoutput>/staffing/Application/Employee/Contract/ContractField.cfm?field=contractstep&grade='+this.value,'fldcontractstep')">
			<cfoutput query="PostGrade">
			<option value="#PostGrade#" <cfif PostGrade eq url.default>selected</cfif>>
	    		#PostGrade#  
			</option>
			</cfoutput>
	    </select>	
		
		<!---
		<cfoutput>
		<script>
		   ptoken.navigate('#SESSION.root#/staffing/Application/Employee/Contract/ContractField.cfm?field=contractstep&grade=#url.default#&default','fldcontractstep')
		</script>	
		</cfoutput>
		--->
		
	</cfcase>				
	
	<cfcase value="contractstep">
	
		<cfparam name="url.default" default="1">
							
		<cfquery name="PostGrade" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT   *
		    FROM     Ref_PostGrade
			WHERE    PostGrade = '#URL.Grade#'			
		</cfquery>
		
		<cfoutput>
		
		<cfif PostGrade.PostGradeSteps lte "1">
		
			<input type="hidden" name="contractstep" value="01">
			<cf_tl id="N/A">
			
			<script>
			try {
				document.getElementById('nextincrement').className = "hide" } catch(e) {}
			</script>
		
		<cfelse>
		
			<select name="contractstep" class="regularxxl">
					
				<cfloop index="st" from="1" to="#PostGrade.PostGradeSteps#">
						<option value="#st#" <cfif url.default eq st>selected</cfif>>#st#</option>
				</cfloop>	
						
			</select>	
			
			<script>
			try {
				document.getElementById('nextincrement').className = "regular" } catch(e) {}
			</script>		
		
		</cfif>	
		
		</cfoutput>
	
	</cfcase>				
		
</cfswitch>		