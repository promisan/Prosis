
<cfparam name="myindexno" default="#url.indexno#">

<!---
<cfset myindexno = "00574068">  <!--- masunga --->
<cfset myindexno = "00368129">  <!--- pankina --->
<cfset myindexno = "00984962">  <!--- hanoch --->

<!--- important to find matches, example Pankina --->

--->

<cfparam name="dts"    default="#dateformat(now(),client.dateSQL)#">
<cfparam name="dte"    default="#dateformat(now()-30,client.dateSQL)#">

<!--- replace with last, in that case are getting also recently expired TA assignments  likely --->

<cfquery name="position" 
	  datasource="hubEnterprise" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		SELECT    IndexNo, PositionId, AssignmentType, DateEffective, DateExpiration
		FROM      PersonAssignment
		WHERE     IndexNo        = '#myindexNo#'  
		AND       TransactionStatus = '1' 
		AND       DateEffective   < '#dts#' 
		AND       DateExpiration >= '#dte#'
</cfquery>

<cfif position.recordcount eq "0">
	
	<cfquery name="person" 
		  datasource="appsEmployee" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			SELECT    *
			FROM      Person
			WHERE     PersonNo = '#myindexNo#'  		
	</cfquery>
	
	<cfset myindexNo = person.Indexno>
			
	<cfquery name="position" 
		  datasource="hubEnterprise" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			SELECT    IndexNo, PositionId, AssignmentType, DateEffective, DateExpiration
			FROM      PersonAssignment
			WHERE     IndexNo        = '#myindexNo#'  
			AND       TransactionStatus = '1' 
			AND       DateEffective   < '#dts#' 
			AND       DateExpiration >= '#dte#'
	</cfquery>
	
</cfif>

<cfset chain = "">

<!--- this will render a LI to his/her old position and a used psotioon to which another person can have LI to --->

<cfif position.recordcount eq "0">

<cfelse>



	<cfoutput query="position">
	
		<cfif not find(positionid,chain)> 
			<cfif chain neq "">
			<cfset chain = "#chain#,#positionid#">
			<cfelse>
			<cfset chain = "#positionid#">
			</cfif>
		</cfif>
	
		<!--- 
		 R : #positionid#:#indexno#:#assignmenttype#<br>	
		 --->
	
		<cfquery name="getdetail" 
		  datasource="hubEnterprise" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			SELECT    IndexNo, PositionId, AssignmentType, DateEffective, DateExpiration 
			FROM      PersonAssignment
			WHERE     PositionId = '#positionid#' and PositionId != '99999999'
	        AND       TransactionStatus = '1' 
	        AND       DateEffective   < '#dts#' 
			AND       DateExpiration >= '#dte#'
			<cfif AssignmentType eq "LI">
			AND       AssignmentType != 'LI'
			<cfelse>
			AND       AssignmentType = 'LI'
			</cfif>
		</cfquery>		
	
		
			<cfif not find(positionid,chain)> 
				<cfset chain = "#chain#,#positionid#">
			</cfif>
							
			<cfloop query="getDetail">
			
				<!---
				0 : #positionid#:#indexno#:#assignmenttype#<br>
				--->
			
				<cfquery name="position_1" 
					  datasource="hubEnterprise" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
						SELECT    IndexNo, PositionId, AssignmentType, DateEffective, DateExpiration
						FROM      PersonAssignment
						WHERE     IndexNo = '#indexNo#' <cfif indexNo eq "00860606"></cfif>
						AND       TransactionStatus = '1' 
						AND       DateEffective   < '#dts#' 
						AND       DateExpiration >= '#dte#'
				</cfquery>
							
				<cfloop query="position_1">
				
					<cfquery name="getdetail_1" 
					  datasource="hubEnterprise" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
						SELECT    IndexNo, PositionId, AssignmentType, DateEffective, DateExpiration 
						FROM      PersonAssignment
						WHERE     PositionId = '#positionid#' and PositionId != '99999999'
				        AND       TransactionStatus = '1' 
				        AND       DateEffective   < '#dts#' 
						AND       DateExpiration >= '#dte#'
						<cfif AssignmentType eq "LI">
						AND       AssignmentType != 'LI'
						<cfelse>
						AND       AssignmentType = 'LI'
						</cfif>
					</cfquery>	
					
					<cfif not find(positionid,chain)> 
						<cfset chain = "#chain#,#positionid#">					
					</cfif>	
		
		
		            
									
					<cfloop query="getDetail_1">
					
						<!--- 
						1 : #positionid#:#indexno#:#assignmenttype#<br>
						--->
								
						
						<cfquery name="position_2" 
							  datasource="hubEnterprise" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">
								SELECT    IndexNo, PositionId, AssignmentType, DateEffective, DateExpiration
								FROM      PersonAssignment
								WHERE     IndexNo = '#indexNo#' 
								AND       TransactionStatus = '1' 
								AND       DateEffective   < '#dts#' 
								AND       DateExpiration >= '#dte#'
						</cfquery>
							
																	
						<cfloop query="position_2">
						
							<cfquery name="getdetail_2" 
							  datasource="hubEnterprise" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">
								SELECT    IndexNo, PositionId, AssignmentType, DateEffective, DateExpiration 
								FROM      PersonAssignment
								WHERE     PositionId = '#positionid#' and PositionId != '99999999'
						        AND       TransactionStatus = '1' 
						        AND       DateEffective   < '#dts#' 
								AND       DateExpiration >= '#dte#'
								<cfif AssignmentType eq "LI">
								AND       AssignmentType != 'LI'
								<cfelse>
								AND       AssignmentType = 'LI'
								</cfif>
							</cfquery>	
							
							

							<cfif not find(positionid,chain)> 
								<cfset chain = "#chain#,#positionid#">
							</cfif>	
													
							<cfloop query="getDetail_2">
								
								<!---					
								2 : #positionid#:#indexno#:#assignmenttype#<br>
								--->
							
								<cfquery name="position_3" 
									  datasource="hubEnterprise" 
									  username="#SESSION.login#" 
									  password="#SESSION.dbpw#">
										SELECT    IndexNo, PositionId, AssignmentType, DateEffective, DateExpiration
										FROM      PersonAssignment
										WHERE     IndexNo = '#indexNo#' 
										AND       TransactionStatus = '1' 
										AND       DateEffective   < '#dts#' 
										AND       DateExpiration >= '#dte#'
								</cfquery>
								
																													
								<cfloop query="position_3">
								
									<cfquery name="getdetail_3" 
									  datasource="hubEnterprise" 
									  username="#SESSION.login#" 
									  password="#SESSION.dbpw#">
										SELECT    IndexNo, PositionId, AssignmentType, DateEffective, DateExpiration 
										FROM      PersonAssignment
										WHERE     PositionId = '#positionid#' and PositionId != '99999999'
								        AND       TransactionStatus = '1' 
								        AND       DateEffective   < '#dts#' 
										AND       DateExpiration >= '#dte#'
										<cfif AssignmentType eq "LI">
										AND       AssignmentType != 'LI'
										<cfelse>
										AND       AssignmentType = 'LI'
										</cfif>
									</cfquery>	
									
									<cfif not find(positionid,chain)> 
										<cfset chain = "#chain#,#positionid#">
									</cfif>	
									
									<cfloop query="getDetail_3">
									
										<cfquery name="position_4" 
											  datasource="hubEnterprise" 
											  username="#SESSION.login#" 
											  password="#SESSION.dbpw#">
												SELECT    IndexNo, PositionId, AssignmentType, DateEffective, DateExpiration
												FROM      PersonAssignment
												WHERE     IndexNo = '#indexNo#' 
												AND       TransactionStatus = '1' 
												AND       DateEffective   < '#dts#' 
												AND       DateExpiration >= '#dte#'
										</cfquery>
															
										<cfloop query="position_4">
										
											<cfquery name="getdetail_4" 
											  datasource="hubEnterprise" 
											  username="#SESSION.login#" 
											  password="#SESSION.dbpw#">
												SELECT    IndexNo, PositionId, AssignmentType, DateEffective, DateExpiration 
												FROM      PersonAssignment
												WHERE     PositionId = '#positionid#' and PositionId != '99999999'
										        AND       TransactionStatus = '1' 
										        AND       DateEffective   < '#dts#' 
												AND       DateExpiration >= '#dte#'
												<cfif AssignmentType eq "LI">
												AND       AssignmentType != 'LI'
												<cfelse>
												AND       AssignmentType = 'LI'
												</cfif>
											</cfquery>	
											
											<cfif not find(positionid,chain)> 
												<cfset chain = "#chain#,#positionid#">
											</cfif>	
									
									     </cfloop>
									
										<!---						
										3 : #positionid#:#indexno#:#assignmenttype#<br>								
										--->
									
									</cfloop>
													
								</cfloop>		
									
							
						    </cfloop>
																	
						</cfloop>
										
					</cfloop>
										
				</cfloop>
			
		     </cfloop>
			
	</cfoutput>

	<cfset positions = chain>
	
	<cfinclude template="ChainView.cfm">

</cfif>
