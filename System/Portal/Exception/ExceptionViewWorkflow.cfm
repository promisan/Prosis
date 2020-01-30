
<cfquery name="get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT   *
  FROM     UserError 
  WHERE    ErrorId = '#url.ajaxid#'
</cfquery> 

<cfset link = "System/Portal/Exception/ExceptionView.cfm?errorid=#url.ajaxid#">

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
	ajaxid           = "#get.ErrorId#"
	ObjectURL        = "#link#"
	Show             = "Yes"
	Toolbar          = "Yes"
	Framecolor       = "ECF5FF"
	CompleteFirst    = "No">	
	
<cfoutput>

<script>
  	
	<!--- refreshes the listing --->	
	try {	
	opener.applyfilter('','','#get.ErrorId#') } catch(e) {}
		
</script>	

</cfoutput>
		
<!--- refresh the opener status --->