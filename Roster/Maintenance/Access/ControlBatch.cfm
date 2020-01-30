
<cfif ParameterExists(Form.Purge)> 

<cfparam name="Form.FunctionId" default="''">
   
<!--- roster access ---> 

<cfparam name="Form.RecordId" default="'00000000-0000-0000-0000-000000000000'">

<cfquery name="Verify" 
	 datasource="AppsSelection" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT * FROM RosterAccessAuthorization
		 WHERE RecordId  IN (#PreserveSingleQuotes(FORM.RecordId)#) 
	 </cfquery>

<cfif Verify.recordcount gt "0">

	<cfquery name="Delete2" 
	 datasource="AppsSelection" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 DELETE RosterAccessAuthorization
		 WHERE RecordId  IN (#PreserveSingleQuotes(FORM.RecordId)#) 
	 </cfquery>
	 
	 <cfquery name="Delete9" 
	 datasource="AppsSelection" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 DELETE RosterAccessAuthorization
		 WHERE UserAccount = '#Verify.UserAccount#'
		 AND  FunctionId   = '#Verify.FunctionId#'
		 AND  AccessLevel  = '9' 
		 AND  Source      = 'Manual'
	 </cfquery>
	  
</cfif>
 
<cfoutput>

<script language="JavaScript">

  window.location = "ControlListingDetail.cfm?RosterAction=#URL.RosterAction#&ID=#URL.ID#&Status=#URL.ID1#&FunctionId=#URL.FunctionID#&row=#URL.Row#&mode=#URL.Mode#";
	
</script>

</cfoutput>
 
</cfif>      



