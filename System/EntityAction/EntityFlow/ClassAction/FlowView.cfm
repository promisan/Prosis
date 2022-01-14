<cfoutput>

<cfparam name="URL.Connector"    default="INIT"> <!--- JOB0080 / INIT --->
<cfparam name="url.link"         default="'#URL.Connector#'">
<cfparam name="URL.PublishNo"    default="">
<cfparam name="URL.ActionNoShow" default="000">
<cfparam name="URL.Print"        default="0">
<cfparam name="URL.Scope"        default="Config">
<cfparam name="URL.ObjectId"     default="">

<cfquery name="Class" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT   *
	 FROM     Ref_Entity E, Ref_EntityClass R
	 WHERE    R.EntityCode  = '#url.entityCode#'
	 AND      R.EntityClass = '#url.entityClass#'
	 AND      R.EntityCode  = E.EntityCode 
</cfquery>	

<cfif url.scope eq "object">
  
   <cf_screentop height="100%"    
        scroll="no" 
		layout="webapp" 
	    jquery="Yes" 
		SystemModule="System" 
		FunctionClass="window" 
		FunctionName="Workflow Presenter" 
		line="no" 
		banner="gray" 
		bannerenforce="Yes" 
		label="Workflow for #Class.EntityDescription#">
   
   <cf_dialogsystem>
   
	<cf_divscroll>   	
	   <cfinclude template="FlowViewContent.cfm">	
	</cf_divscroll>
	
	<cf_screenbottom layout="webapp">

<cfelse>

	 <cf_screentop height="100%"    
        scroll="yes" 
		layout="webapp" 
	    jquery="Yes" 
		html="No"		
		label="Workflow for #Class.EntityDescription#">
	
	<HTML><HEAD>
		<TITLE>Workflow Preview</TITLE>
	</HEAD>
		
	<body onLoad="window.focus()">
	<link href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>" rel="stylesheet" type="text/css">
	<link rel="stylesheet" type="text/css" href="../../../../print.css" media="print">
	
	<cf_dialogsystem>
	
	<cfinclude template="FlowViewContent.cfm">
		
	</body>

</cfif>

<script>
parent.Prosis.busy('no')
</script>

</cfoutput>

