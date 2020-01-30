
<cfif URL.id eq "">

	<cfquery name="Settings" 
		 datasource="AppsSystem" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 DELETE FROM UserDashboard
		 WHERE  Account      = '#SESSION.acc#'
		 AND    DashboardFrame = '#url.frm#'
		</cfquery>

<cfelse>

	<cfquery name="Check" 
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT   * 
	 FROM     UserDashboard
	 WHERE    Account      = '#SESSION.acc#'
	 AND      DashboardFrame = '#url.frm#'
	</cfquery>
	
	<cfif check.recordcount eq "0">
	
		<cfquery name="Settings" 
		 datasource="AppsSystem" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 INSERT INTO UserDashboard
		 (Account,DashboardFrame,ReportId,ReportType)
		 VALUES('#SESSION.acc#','#url.frm#','#URL.ID#','#URL.Type#')
		</cfquery>
	
	<cfelse>
		
		<cfquery name="Settings" 
		 datasource="AppsSystem" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 UPDATE UserDashboard
		   SET ReportId     = '#URL.ID#', 
		       ReportType   = '#URL.Type#'
		 WHERE Account      = '#SESSION.acc#'
		 AND   DashboardFrame = '#url.frm#'
		</cfquery>
	
	</cfif>

</cfif>

<cfinclude template="DashboardGadgetItem.cfm">
	
