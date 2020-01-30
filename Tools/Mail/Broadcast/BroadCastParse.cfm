<!--- loop through the valid fields and replace if exists --->
<!--- output in mail --->
					
<cfif recipientcode neq "">
		
		<cfquery name="Data" 
	    datasource="#Listing.QueryDataSource#">
			SELECT * FROM dbo.vwListing#SESSION.acc# 
			WHERE #Key.DrillFieldKey# = '#recipientcode#'  	
		</cfquery> 	
		
<cfelse>
		
		<cfquery name="Data" 
	    datasource="#Listing.QueryDataSource#">
		SELECT * FROM dbo.vwListing#SESSION.acc# 
		WHERE #Mail.FieldName# = '#eMailAddress#'  	
		</cfquery> 	
		
</cfif>

<cfloop query="Fields">
																		 
		 <cfquery name="FieldName" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#"> 	
			SELECT * 
			FROM   Ref_ModuleControlDetailField
			WHERE  SystemFunctionId = '#Broadcast.systemfunctionid#'		
			AND    FunctionSerialNo = '#Broadcast.functionserialNo#'
			AND    FieldName = '#name#'
		</cfquery>		
		
		<cfif FieldName.FieldHeaderLabel neq "">
		
			<cfset fld = FieldName.FieldHeaderLabel>
			
		<cfelse>
		
			<cfset fld = name>
			
		</cfif>
				
		<cfif usertype eq "12">
		    <!--- date field --->
		    <cfset val = dateformat(evaluate("Data.#name#"),CLIENT.DateFormatShow)>							
		<cfelseif usertype eq "8">
		     <!--- number field --->
		    <cfset val = numberformat(evaluate("Data.#name#"),"__,__.__")>	
		<cfelse>
			<cfset val = evaluate("Data.#name#")>						
		</cfif>		
																				
		<cfset body = ReplaceNoCase("#body#", "@#fld#", "#val#", "ALL")>		
	
	</cfloop>			