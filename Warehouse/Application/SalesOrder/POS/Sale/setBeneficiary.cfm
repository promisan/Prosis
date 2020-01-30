<cfswitch expression="#URL.action#" >
	<cfcase value="Change">
			
		<cfquery name="AllBeneficiaries"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT CustomerId,BeneficiaryId, FirstName,LastName
			FROM dbo.Sale#URL.Warehouse#Beneficiary WB
			WHERE CustomerId 	= '#URL.CustomerId#'
			AND   BeneficiaryId != '#URL.BeneficiaryId#'
			AND   Operational = '1'
			AND   Len(FirstName)>2
			AND NOT EXISTS
			(
				SELECT 'X'
				FROM dbo.Sale#URL.Warehouse#Beneficiary WB2
				WHERE WB2.TransactionId = '#URL.Id#'
				AND   WB2.CustomerId    = WB.CustomerId
				AND   WB2.BeneficiaryId = WB.BeneficiaryId
				AND   WB2.Operational = '1'				
			)			
			UNION
			SELECT CustomerId,BeneficiaryId, FirstName,LastName
			FROM Materials.dbo.CustomerBeneficiary CB
			WHERE  CustomerId 	= '#URL.CustomerId#'
			AND NOT EXISTS
			(
				SELECT 'X'
				FROM dbo.Sale#URL.Warehouse#Beneficiary WB
				WHERE WB.TransactionId = '#URL.Id#'
				AND   WB.CustomerId    = CB.CustomerId
				AND   WB.BeneficiaryId   = CB.BeneficiaryId
				AND   WB.Operational = '1'				
			)
			AND   Len(FirstName)>2
		</cfquery>	
		
		<cfquery name="qBeneficiaries" dbtype="query" >
			SELECT DISTINCT CustomerId,BeneficiaryId, FirstName,LastName
			FROM AllBeneficiaries
		</cfquery>

		<cfoutput>
		<cfif qBeneficiaries.recordcount neq 0>	
			<table width = "100%">
			<tr>
				<td width="2%"></td>
				<td>		
					<select name="Beneficiary_Gender_#Left(URL.Id,5)#_#Left(URL.BeneficiaryId,5)#" 
						id	="Beneficiary_Gender_#Left(URL.Id,5)#_#Left(URL.BeneficiaryId,5)#" 
						style="font-size:16px" class="regularxl enterastab"
						onchange="applyBeneficiaryData('#URL.warehouse#','#URL.BeneficiaryId#','#qBeneficiaries.CustomerId#','#URL.Id#','doChange',this.value,'#URL.crow#')">
						<option value="">--<cf_tl id="Select">--</option>
						<cfloop query="qBeneficiaries">		
							<option value="#qBeneficiaries.BeneficiaryId#">#qBeneficiaries.FirstName# #qBeneficiaries.LastName#</option>
						</cfloop>
					</select>
				</td>	
				<td>
					
				</td>	
				
			</tr>
			</table>
		</cfif>					
		</cfoutput>		
		
			
	</cfcase>
	
	<cfcase value="add">

		
		<cfquery name="qBeneficiary"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM dbo.Sale#URL.Warehouse#Beneficiary
				WHERE  	TransactionId = '#URL.id#'
				AND 	CustomerId    = '#URL.CustomerId#'
				AND     Operational='1'
		</cfquery>


		<cfset URL.clines = qBeneficiary.recordcount+1> 
		<cfoutput>
			<script>
				ColdFusion.navigate('#session.root#/Warehouse/Application/SalesOrder/POS/Sale/getBeneficiary.cfm?crow=#url.crow#&warehouse=#url.warehouse#&id=#URL.id#&clines=#url.clines#','Beneficiary_#url.crow#')
			</script>
		</cfoutput>	

	</cfcase>		
		

	<cfcase value="doChange">


		<cftransaction>
		<cfquery name="setBeneficiary"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE dbo.Sale#URL.Warehouse#Beneficiary
				SET Operational = '0'
				WHERE  	TransactionId = '#URL.id#'
				AND 	CustomerId    = '#URL.CustomerId#'
				AND 	BeneficiaryId = '#URL.BeneficiaryId#'
					
		</cfquery>
		
		<cfquery name="qGetCandidate"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * FROM Materials.dbo.CustomerBeneficiary
			WHERE 
				CustomerId    = '#URL.CustomerId#'
			AND BeneficiaryId = '#URL.Value#'	

		</cfquery>

		<cfquery name="qInsert"
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO dbo.Sale#URL.Warehouse#Beneficiary(TransactionId,
													   CustomerId,
													   BeneficiaryId,
													   LastName,
													   FirstName,
													   Relationship,
													   BirthDate,
													   Gender,
													   Operational,						
													   OfficerUserId,
													   OfficerLastName,
													   OfficerFirstName)
			VALUES ('#URL.Id#',
			    '#qGetCandidate.CustomerId#',
				'#qGetCandidate.BeneficiaryId#',
				'#qGetCandidate.LastName#',
				'#qGetCandidate.FirstName#',
				'#qGetCandidate.Relationship#',
				'#qGetCandidate.BirthDate#',
				'#qGetCandidate.Gender#',
				'1',
				'#session.acc#',
				'#session.last#',
				'#session.first#' )		  
		</cfquery>	
		
		</cftransaction>

		<cfquery name="qBeneficiary"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM dbo.Sale#URL.Warehouse#Beneficiary
				WHERE  	TransactionId = '#URL.id#'
				AND 	CustomerId    = '#URL.CustomerId#'
				AND     Operational='1'
		</cfquery>


		<cfset URL.clines = qBeneficiary.recordcount> 
		<cfoutput>
			<script>
				ColdFusion.navigate('#session.root#/Warehouse/Application/SalesOrder/POS/Sale/getBeneficiary.cfm?crow=#url.crow#&warehouse=#url.warehouse#&id=#URL.id#&clines=#url.clines#','Beneficiary_#url.crow#')
			</script>
		</cfoutput>	

	</cfcase>	
	
	<cfcase value="Delete">
		<cfquery name="setBeneficiary"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE FROM dbo.Sale#URL.Warehouse#Beneficiary
				WHERE  	TransactionId = '#URL.id#'
				AND 	CustomerId    = '#URL.CustomerId#'
				AND 	BeneficiaryId = '#URL.BeneficiaryId#'	
		</cfquery>

		<cfquery name="qBeneficiary"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM dbo.Sale#URL.Warehouse#Beneficiary
				WHERE  	TransactionId = '#URL.id#'
				AND 	CustomerId    = '#URL.CustomerId#'
				AND  	Operational = '1'
		</cfquery>


		<cfset URL.clines = qBeneficiary.recordcount> 
		
		<cfinclude template = "getBeneficiary.cfm">
	</cfcase>
	
	<cfcase value="FirstName">
		<cfquery name="setBeneficiary"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE dbo.Sale#URL.Warehouse#Beneficiary
				SET    	Firstname     = '#URL.value#'
				WHERE  	TransactionId = '#URL.id#'
				AND 	CustomerId    = '#URL.CustomerId#'
				AND 	BeneficiaryId = '#URL.BeneficiaryId#'	
		</cfquery>
	</cfcase>
	<cfcase value="LastName">
		<cfquery name="setBeneficiary"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE dbo.Sale#URL.Warehouse#Beneficiary
				SET    	LastName     = '#URL.value#'
				WHERE  	TransactionId = '#URL.id#'
				AND 	CustomerId    = '#URL.CustomerId#'
				AND 	BeneficiaryId = '#URL.BeneficiaryId#'	
		</cfquery>
	</cfcase>
	<cfcase value="Gender">
		<cfquery name="setBeneficiary"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE dbo.Sale#URL.Warehouse#Beneficiary
				SET    	Gender       = '#URL.value#'
				WHERE  	TransactionId = '#URL.id#'
				AND 	CustomerId    = '#URL.CustomerId#'
				AND 	BeneficiaryId = '#URL.BeneficiaryId#'	
		</cfquery>
	</cfcase>			

	<cfcase value="Relationship">
		<cfquery name="setBeneficiary"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE dbo.Sale#URL.Warehouse#Beneficiary
				SET    	Relationship  = '#URL.value#'
				WHERE  	TransactionId = '#URL.id#'
				AND 	CustomerId    = '#URL.CustomerId#'
				AND 	BeneficiaryId = '#URL.BeneficiaryId#'	
		</cfquery>
	</cfcase>			

	<cfcase value="Birthdate">
		
		<cfset dateValue = "">
		<CF_DateConvert Value="#URL.value#">
		<cfset DTE = dateValue>		
	
	    <cfif val eq "">
		    <cfset result = "1">
		<cfelseif not isValid("date",dte)>		
			<cfset result = "0">				
		<cfelse>		
			<cfset result = "1">		
		</cfif> 
		
		<cfset val = dateformat(dte,client.dateSQL)>
		
		<cfif result eq 1>
			<cfquery name="setBeneficiary"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE dbo.Sale#URL.Warehouse#Beneficiary
				SET    	Birthdate  = '#val#'
				WHERE  	TransactionId = '#URL.id#'
				AND 	CustomerId    = '#URL.CustomerId#'
				AND 	BeneficiaryId = '#URL.BeneficiaryId#'	
			</cfquery>
		</cfif>
	</cfcase>			


</cfswitch>
