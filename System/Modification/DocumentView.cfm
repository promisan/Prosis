
<cfparam name="url.drillid" default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.id" default="">

<cfif url.id eq "">
	<cfset url.id = url.drillid>
<cfelse>
  	<cfset url.drillid = url.id>
</cfif>

<cfquery name="Object" 
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT * 
	 FROM   OrganizationObject
	 WHERE  ObjectKeyValue4   = '#URL.id#' or ObjectId = '#URL.id#' 
</cfquery>	

<cfif Object.recordcount eq "0">
	
	<cfif Object.recordcount eq "0">
	  <cf_message message="Problem, this ticket will need to be initiated again">
	  
	</cfif>
		
	<cfquery name="Observation" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    DELETE FROM Observation
		WHERE   ObservationId = '#URL.id#' 
	</cfquery>
	
	<cfabort>
	
</cfif>

<cfquery name="Observation" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *
		FROM    Observation
		WHERE   ObservationId = '#URL.id#' <cfif Object.recordcount eq "1">or ObservationId = '#Object.ObjectKeyValue4#'</cfif>
</cfquery>

<cfquery name="User" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *
		FROM    UserNames
		WHERE   Account = '#Observation.Requester#'	
</cfquery>

<cfif Observation.recordcount eq "0">
  <cf_message message="Problem, could not find this observation request">
  <cfabort>
</cfif>

<cfoutput>
	<script>
	function save() {
	   ptoken.navigate('DocumentEditSubmit.cfm?id=#url.drillid#','result','','','POST','formedit')
	}
	
	function convert(id) {
	   ColdFusion.Window.create('amendment', 'Conversion', '',{x:15,y:90,height:260,width:480,closable:true,draggable:false,resizable:false,modal:true,center:true})
	   ptoken.navigate('DocumentConvert.cfm?id='+id+'&observationclass=amendment','amendment') 	 	  
	}
	
	function saveamend(id,cls) {	   
	   ptoken.navigate('DocumentConvertSubmit.cfm?id='+id+'&observationclass='+cls,'amendresult','','','POST','formamend')
	}
	</script>
</cfoutput>

<cf_dialogstaffing>	
<cf_textareascript>
<cfajaximport tags="cfmenu,cfdiv,cfform,cfwindow">
<cf_ActionListingScript>
<cf_FileLibraryScript>
<cf_LayoutScript>
<cf_PresentationScript>

<cf_screentop height="100%" MenuAccess="context" band="no" html="No" layout="webapp" user="yes" jquery="Yes"
    banner="blue" label="#Observation.ObservationClass#: #Observation.Reference#">

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">
	
	<cf_layoutarea 
	   	position  = "header"
	   	name      = "reqtop"
	   	minsize	  = "50px"
		maxsize	  = "50px"
		size 	  = "50px">	
		
			<cf_ViewTopMenu label="#Observation.ObservationClass#: #Observation.Reference#" background="blue">
						 			  
	</cf_layoutarea>		
	
	<cf_layoutarea position="center" name="box" overflow="scroll">

		<cf_divscroll style="height:99%">		
			<cfinclude template="DocumentEdit.cfm">
		</cf_divscroll>			
					
	</cf_layoutarea>		
	 	 
	<cf_layoutarea 
	    position    = "right" 
		name        = "commentbox" 
		maxsize     = "500" 		
		size        = "25%" 		
		minsize     = "380"
		collapsible = "true" 
		splitter    = "true"
		overflow    = "scroll"
		style 		= "border-left:1px solid ##gray;">
						
		<cf_divscroll style="height:99%">
			<cf_commentlisting objectid="#url.id#" ajax="No">		
		</cf_divscroll>
									
	</cf_layoutarea>	
			
</cf_layout>
