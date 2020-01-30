
<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateDue#">
<cfset dueDate = dateValue>

<cfquery name="Header" 
   datasource="AppsMaterials" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">	

   		SELECT *
		FROM   RequestHeader
		WHERE  RequestHeaderId = '#Form.headerId#'
  
</cfquery>

<cfif Header.Category neq Form.Category or Header.RequestShipToMode neq Form.ShipToMode 
	or Header.Remarks neq Form.Remarks or Header.DateDue neq dueDate>

	<!--- Logging---->
	
	<cftransaction>
	
		<cfquery name="GetLogging" 
		    datasource="AppsMaterials" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">	
				SELECT MAX(SerialNo) AS SerialNo
				FROM   RequestHeaderLog
				WHERE  Mission = '#Header.Mission#' AND Reference = '#Header.Reference#'
				
		</cfquery>
		
		
		<cfif GetLogging.SerialNo eq ''> <!--- no log has been created for this record--->
		
			<cfquery name="InsertOldValues" 
		    datasource="AppsMaterials" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">	
				INSERT INTO RequestHeaderLog ([Mission]
				      ,[Reference]
				      ,[SerialNo]
				      ,[Category]
				      ,[RequestShipToMode]
				      ,[DateDue]
					  ,[Remarks]
				      ,[RequestHeaderId]
				      ,[OfficerUserId]
				      ,[OfficerLastName]
				      ,[OfficerFirstName] )
				VALUES(
						'#Header.Mission#',
						'#Header.Reference#',
						'1',
						'#Header.Category#',
						'#Header.RequestShipToMode#',
						'#Header.DateDue#',
						'#Header.Remarks#',
						'#Header.RequestHeaderId#',
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
					)
			</cfquery>
			
			<cfset serialNo = 2>
			
		<cfelse>
		
			<cfset serialNo = GetLogging.SerialNo + 1>
			
		</cfif>
		
		<cfquery name="InsertNewValues" 
		    datasource="AppsMaterials" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">	
				INSERT INTO RequestHeaderLog ([Mission]
				      ,[Reference]
				      ,[SerialNo]
				      ,[Category]
				      ,[RequestShipToMode]
				      ,[DateDue]
					  ,[Remarks]
				      ,[RequestHeaderId]
				      ,[OfficerUserId]
				      ,[OfficerLastName]
				      ,[OfficerFirstName] )
				VALUES(
						'#Header.Mission#',
						'#Header.Reference#',
						'#serialNo#',
						'#Form.Category#',
						'#Form.ShipToMode#',
						#dueDate#,
						'#Form.Remarks#',
						'#Header.RequestHeaderId#',
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
					)
			</cfquery>
		
		
			<cfquery name="UpdateHeader" 
		    datasource="AppsMaterials" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">	
				UPDATE RequestHeader
				SET    Category          = '#Form.Category#',
					   RequestShipToMode = '#Form.ShipToMode#',
					   Remarks           = '#Form.Remarks#',
					   DateDue			 = #dueDate#
				WHERE  RequestHeaderId   = '#Form.headerId#'
			</cfquery>
	
	</cftransaction>
	

	
	<cf_tl id="Information has been updated" class="message" var="vMessage">
	
	<cfoutput>
		<script>
			alert('#vMessage#.');
		</script>
	</cfoutput>
	
<cfelse>

	<cf_tl id="No information was changed" class="message" var="vMessage">
	
	<cfoutput>
		<script>
			alert('#vMessage#.');
		</script>
	</cfoutput>
	
</cfif>