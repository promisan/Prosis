
<!--- update group --->
		
	<cfquery name="ResetGroup" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE PositionGroup
	SET    Status = '9' 
	WHERE  PositionNo = '#Form.PositionNo#'
	</cfquery>
	
	<cfparam name="Form.PositionGroup" type="any" default="">
	
	<cfloop index="Item" 
	        list="#Form.PositionGroup#" 
	        delimiters="' ,">
	
		<cfquery name="VerifyGroup" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT PositionGroup
		FROM   PositionGroup
		WHERE  PositionNo = '#Form.PositionNo#' 
		AND    PositionGroup = '#Item#'
		</cfquery>
		
		<CFIF VerifyGroup.recordCount is 1 > 
		
			<cfquery name="UpdateGroup" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE PositionGroup
				 SET   Status = '1',
				       OfficerUserId    = '#SESSION.acc#',
					   OfficerLastName  = '#SESSION.last#',
					   OfficerFirstName = '#SESSION.first#'
				WHERE  PositionNo = '#Form.PositionNo#' 
				AND    PositionGroup = '#Item#'
			</cfquery>
		
		<cfelse>
		
			<cfquery name="Check" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   Position
				WHERE  PositionNo = '#Form.PositionNo#' 
			</cfquery>
			
			<cfif Check.recordcount eq "1">
			
					<cfquery name="InsertGroup" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					 INSERT INTO PositionGroup 
					           (PositionNo,
						        PositionGroup,
							    Status,
							    OfficerUserId,
							    OfficerLastName,
							    OfficerFirstName) 
					  VALUES  ('#Form.PositionNo#',
					      	   '#Item#',
						       '1',
							   '#SESSION.acc#',
							   '#SESSION.last#',
							   '#SESSION.first#')
				   </cfquery>
							  
				</cfif>			  
					  
		</cfif>
		
	</cfloop>		