
<cfif url.id neq "">

	<cfquery name="validate" 
	     datasource="AppsSystem" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 	SELECT	*
			FROM	UserModule
			WHERE	SystemFunctionId = '#url.id#'
			AND		Account = '#url.account#'
	</cfquery>
	
	<cfif validate.recordcount eq 0>
	
		<cftry>
		
			<cfquery name="insert" 
			     datasource="AppsSystem" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 	INSERT INTO UserModule
						(
							Account,
							SystemFunctionId,
							OrderListing,
							Status
						)
					VALUES
						(
							'#url.account#',
							'#url.id#',
							0,
							'#url.value#'
						)
			</cfquery>
			
			<font color="0080FF">
				<b>Saved</b>
			</font>
			
			<cfcatch>
				<font color="FF0000">
					<b>Error</b>
				</font>
			</cfcatch>
		
		</cftry>
	
	<cfelse>
	
		<cftry>
			
			<cfquery name="update" 
			     datasource="AppsSystem" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 	UPDATE 	UserModule
					SET		Status = '#url.value#'
					WHERE	SystemFunctionId = '#url.id#'
					AND		Account = '#url.account#'
			</cfquery>
			
			<font color="0080FF">
				<b>Saved</b>
			</font>
			
			<cfcatch>
				<font color="FF0000">
					<b>Error</b>
				</font>
			</cfcatch>
		
		</cftry>
	
	</cfif>
	
<cfelse>

	<cf_compression>	
	
</cfif>