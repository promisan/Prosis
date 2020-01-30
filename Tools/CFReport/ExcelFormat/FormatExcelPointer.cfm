
<!--- define last order --->

<cfif url.id neq "">
	
	<cfquery name="Clear" 
	 datasource="appsSystem">
	 DELETE  FROM UserReportOutput 
	 WHERE    UserAccount = '#SESSION.acc#'
	 AND      OutputId    = '#url.id#' 
	 AND      OutputClass = '#url.class#'
	</cfquery>
	
	<cfif URL.Value eq "1">
	
		<cfquery name="Insert" 
		 datasource="appsSystem">
		 INSERT INTO UserReportOutput 
		 (UserAccount, OutputId, OutputClass, FieldName, FieldNameOrder, GroupFormula)
		 VALUES
		 ('#SESSION.acc#','#URL.ID#','#URL.Class#','1','0','None')
		</cfquery>
	
	</cfif>
	
</cfif>