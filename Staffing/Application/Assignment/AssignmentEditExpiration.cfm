
<!--- check if the person has a prior assignment already --->
	
<cfquery name="Check" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
	    FROM    PersonAssignment
		WHERE   AssignmentNo = '#url.AssignmentNo#'
</cfquery>	

<cfquery name="getPosition" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
	    FROM    Position
		WHERE   PositionNo = '#check.PositionNo#'
</cfquery>	

<cfquery name="Extend" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   PersonExtension E
	WHERE  E.PersonNo  = '#check.PersonNo#'
	AND    E.Mission   = '#getPosition.Mission#'
	AND    E.MandateNo = '#getPosition.MandateNo#'  
</cfquery>

<cfquery name="getMission" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
	    FROM    Ref_Mission
		WHERE   Mission   = '#getPosition.Mission#'		
</cfquery>	

<cfquery name="getMandate" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
	    FROM    Ref_Mandate
		WHERE   Mission   = '#getPosition.Mission#'
		AND     MandateNo = '#getPosition.MandateNo#'
</cfquery>	

<!--- check if the person has a later assignment already --->
	
<cfquery name="LaterAssignment" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
	    FROM  PersonAssignment
		WHERE PersonNo = '#check.PersonNo#'
		AND   DateEffective > '#check.DateEffective#'
		AND   AssignmentStatus IN ('0','1')
		AND   AssignmentNo != '#check.AssignmentNo#'
		AND   PositionNo IN (SELECT PositionNo FROM Position WHERE Mission = '#getPosition.Mission#')
</cfquery>

<script>
	try {document.getElementById('extdate').className = "hide"} catch(e) {}	
</script>

<input type="hidden" name="EditExpiration" id="EditExpiration" value="1">

<cfif LaterAssignment.recordcount eq "0">

	<!--- show and hide the input date --->	
			
	<cfif url.dateexpiration eq dateformat(getMandate.dateexpiration,CLIENT.DateFormatShow)>
	
		<cfif Extend.recordcount eq "1">
	
		    <script>
				try {document.getElementById('extdate').className = "regular"} catch(e) {}
			</script>
		
		</cfif>			
	
		<cfoutput>
						
			<table cellspacing="0" cellpadding="0">
			
			<tr>
			
				<td height="20" class="labelmedium" style="padding-left:5px"><cf_tl id="Extension Proposal">:</td>	
				
				<td style="padding-left:4px">
					<table border="0" cellspacing="0" cellpadding="0"><tr>
					<td>
					
					  	<input type="checkbox" 
						       name="Extension" 
							   id="Extension"
							   class="radiol"
					           onclick="extend(this.checked)" 
							   value="1" <cfif Extend.recordcount eq "1">checked</cfif>>
					</td>
					
					</tr>
					</table>
											
			</tr>
			
			</table>
			
			<cfif Extend.recordcount eq "1">
			
				<cfset cl = "hide">
			
			<cfelse>
			
				<cfset cl = "labelit">
			
			</cfif>
		
		</cfoutput>
		
	</cfif>	
	
	<cfif url.validcontract eq "0">
	
	<cfparam name="cl" default="labelit">
	
	<table cellspacing="0" style="border-left:0px solid silver" cellpadding="0" id="reasonbox" class="<cfoutput>#cl#</cfoutput> formpadding">	
					
		<!--- ------------------------ --->		
		<!--- reason for expiration--- --->
		<!--- ------------------------ --->
			
			<cfquery name="Topic" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				  SELECT  *
				  FROM    Ref_PersonGroup
				  WHERE   Code IN (SELECT GroupCode 
				                   FROM   Ref_PersonGroupList)
				  AND     Code = 'AssignEnd'
				 
			</cfquery>
										
			<cfif Topic.recordcount gt "0">
			
					<cfoutput query="topic">
					
						<tr>
					
						<td class="labelmedium" style="padding-left:3px">#Description#: <font color="FF0000">*</font>&nbsp;</td>
						<td class="labelmedium">
						
						<cfquery name="List" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						  SELECT  *
						     FROM  Ref_PersonGroupList
							 WHERE GroupCode = '#Code#'
							 ORDER BY Description
						</cfquery>
																			
						<select name="ExpirationListCode" id="ExpirationListCode" class="regularxl">
						    <option value=""></option>
							<cfloop query="List">
								<option value="#GroupListCode#" <cfif check.ExpirationListCode eq GroupListCode>selected</cfif>><cfif GroupListCode neq "0">#Description#</cfif></option>
							</cfloop>
						</select>
						<input type="hidden" name="ExpirationCode" value="AssignEnd">
						</td>
						
						</tr>
								
					</cfoutput>			
								
			</cfif>	
			
		<cfif dateformat(check.dateexpiration,CLIENT.DateFormatShow) neq url.dateexpiration>
			
		<!--- ----------------- --->		
		<!--- recruitment track --->
		<!--- ----------------- --->
			
			<cfquery name="getPosition" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  *
			    FROM    Position
				WHERE   PositionNo = '#check.PositionNo#'
		    </cfquery>			
					
			<cfquery name="Mission" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  SELECT DISTINCT M.Mission, M.MissionOwner
			  FROM    Ref_Mission M, Ref_MissionModule R
			  WHERE   M.Mission = R.Mission
			  AND     R.SystemModule = 'Vacancy'
			  AND     M.Mission IN (SELECT Mission 
			                        FROM   Ref_Mandate 
								    WHERE  DateExpiration > getDate()) 
							
			  <cfif getAdministrator(getPosition.mission) eq "1">
	
					<!--- no filtering --->
	
			  <cfelse>				
			  
				  AND (
				      M.Mission IN (SELECT DISTINCT A.Mission
									FROM     OrganizationAuthorization A INNER JOIN
									         Ref_EntityAction R ON A.ClassParameter = R.ActionCode
									WHERE   A.UserAccount = '#SESSION.acc#' 
									AND     R.EntityCode = 'VacDocument'
									AND     R.ActionType = 'Create')  
					  OR M.Mission IN (SELECT DISTINCT Mission 
					                   FROM    OrganizationAuthorization
									   WHERE   UserAccount = '#SESSION.acc#' 
									   AND     Role = 'VacOfficer')
					   )
				               				
			  </cfif>	
			 		
			</cfquery>
									
			<cfquery name="Admin" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM Organization.dbo.Organization Org
				WHERE OrgUnit = '#getPosition.OrgUnitAdministrative#' 
			</cfquery>
			
			<cfif Admin.recordcount eq "1">
			
				<cfquery name="Own" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT     R.Mission, 
				           R.MissionOwner as Owner
				FROM       Organization O INNER JOIN
				           Ref_Mission R ON O.Mission = R.Mission
				WHERE      O.OrgUnit = '#getPosition.OrgUnitAdministrative#'
				</cfquery>
				
				<cfif Own.Owner neq "">
				     <cfset owner = Own.Owner>
					 <cfset miss  = Own.Mission>
				<cfelse>
				     <cfset owner = Mission.MissionOwner>
					 <cfset miss  = Mission.Mission>
				</cfif>
				
			<cfelse>
			
				<cfquery name="Mis" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM   Ref_Mission
				WHERE  Mission = '#getPosition.Mission#'
				</cfquery>
			
				<cfset owner = Mis.MissionOwner>	
				<cfset miss  = Mis.Mission>
			
			</cfif>
			
			<cfquery name="getMissionClass"
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT EntityClass 
			    FROM   Ref_EntityClassMission 
			    WHERE  EntityCode = 'VacDocument' 
			    AND    Mission = '#getPosition.Mission#'
			</cfquery>	
			
			<cfquery name="Class"
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT DISTINCT R.*
				FROM     Ref_EntityClass R, 
				         Ref_EntityClassPublish P
				WHERE    R.Operational = '1'
				AND      R.EntityCode   = P.EntityCode 
				AND      R.EntityClass  = P.EntityClass
				AND      R.EntityCode = 'VacDocument'	
				AND     
				         (
						 
				         R.EntityClass IN (SELECT EntityClass 
				                           FROM   Ref_EntityClassOwner 
										   WHERE  EntityCode = 'VacDocument'
										   AND    EntityClass = R.EntityClass
										   AND    EntityClassOwner = '#owner#')
										   
						 OR
						
						  R.EntityClass NOT IN (SELECT EntityClass 
				                           FROM   Ref_EntityClassOwner 
										   WHERE  EntityCode = 'VacDocument'
										   AND    EntityClass = R.EntityClass)
										   
						 )				   							   				   
				
				AND     (R.EntityParameter is NULL or
				         R.EntityParameter = '' or
					     R.EntityParameter = '#getPosition.PostType#')		
						 
				<cfif getMissionClass.recordcount gte "1">
	
				AND    R.EntityClass IN (SELECT EntityClass 
	                   					FROM   Ref_EntityClassMission 
					  	 				WHERE  EntityCode = 'VacDocument' 
					   					AND    Mission = '#getPosition.Mission#')
				</cfif>		
					
				ORDER BY R.ListingOrder	 
			</cfquery>
			
			<cfoutput>
			
				<cfif getMission.staffingMode eq "1" and class.recordcount gte "1">
						
					<tr>
					
						<td class="labelmedium" style="padding-left:3px;padding-right:10px"><cf_tl id="Initiate recruitment track"> [#owner#]:</td>
						<td>
						
						<select name="EntityClass" name="EntityClass" class="regularxl">
						    <option value="" selected>N/A</option>
							<cfloop query="Class">
								<option value="#EntityClass#">#EntityClassName#</option>
							</cfloop>
						</select>								
						<input type="hidden" name="EntityOwner" id="EntityOwner" value="#owner#">
						
						</td>
							
					</tr>
					
				<cfelse>
							
					<input type="hidden" name="EntityClass" id="EntityClass" value="">
					<input type="hidden" name="EntityOwner" id="EntityOwner" value="#owner#">				
				
				</cfif>
			
			</cfoutput>		
			
	</cfif>	
	
	</table>	
			
	</cfif>	
	
</cfif>

<cf_compression>
		