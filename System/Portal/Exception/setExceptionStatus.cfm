
<cfquery name="get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	  SELECT   *
	  FROM     UserError 
	  WHERE    ErrorId      = '#url.errorid#'
</cfquery> 

<cfquery name="setError" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  UPDATE   UserError
  SET      ActionStatus        = '#url.actionstatus#',
  			<cfif url.actionstatus eq "2">
	           FirstReviewerUserid = '#Form.FirstReviewerUserid#',
		   </cfif>
		   ActionMemo          = '#Form.Memo#'
  WHERE    ErrorNo             = '#get.ErrorNo#' 
</cfquery> 

<cfoutput>

<cfif url.actionstatus eq "0">

	<cfset actionClass = "Pending">

<cfelseif url.actionstatus eq "3">

    <cfset actionClass = "Dismiss">
	
	<script>
	 document.getElementById('process_#url.errorid#').className = "hide"
	</script>
	
<cfelseif url.actionstatus eq "2">

   <cfset actionClass = "WorkFlow">	
   
   <script>
	 document.getElementById('process_#url.errorid#').className = "hide"
	</script>
	
	<!--- trigger the workflow --->	
	
   <cfset link = "System/Portal/Exception/ExceptionView.cfm?errorid=#get.ErrorId#">
         	
   <cf_ActionListing 
		EntityCode       = "SysError"
		EntityGroup      = "#get.HostServer#"
		EntityClass      = "#get.HostServer#"
		EntityStatus     = ""
		OrgUnit          = ""
		PersonNo         = "" 
		ObjectReference  = "Exception Error #get.ErrorTemplate#"
		ObjectReference2 = "#SESSION.first# #SESSION.last#"
		ObjectKey4       = "#get.ErrorId#"
		ObjectURL        = "#link#"
		Show             = "No"
		Toolbar          = "No"
		FlyActor         = "#Form.FirstReviewerUserid#"
		Framecolor       = "ECF5FF"
		CompleteFirst    = "No">	
	
</cfif>

</cfoutput>

<!--- logging --->

<cfquery name="setErrorAction" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	  INSERT INTO UserErrorAction
	       (ErrorNo,
		    ActionClass,
			ActionMemo,
			OfficerUserId,
			OfficerLastName,
			OfficerFirstName)
	  VALUES
		  ('#get.ErrorNo#',
		   '#actionclass#',
		   '#form.memo#',
		   '#SESSION.acc#',
		   '#SESSION.last#',
		   '#SESSION.first#')
</cfquery> 

<cfset url.mode = "hide">

<cfinclude template="ExceptionMemo.cfm">
  