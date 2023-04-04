
<cfparam name="url.target" default="0">

<cfset vLandingMission = "">
<cfif isDefined("client.mission")>
	<cfset vLandingMission = client.mission>
</cfif>

<cfparam name="url.mission" default="#vLandingMission#">

<cf_screentop html="no" scroll="no" Jquery="yes" busy="busy10.gif">

<cfif url.target eq "1" and session.acc neq "">
	    
	<cfset url.objectid   = client.objectid>
	<cfset url.actioncode = client.actioncode>
	<cfparam name="url.mid" default="">	
		
	<cfinvoke component = "Service.EntityAction.Workflow"  
	   method           = "wfAuthorization" 
	   ObjectId         = "#url.objectId#" 
	   ActionCode       = "#url.actionCode#"   
	   returnvariable   = "access"> 
	   	  	
	<cfif access.status eq 1>	    	
	    <cflocation  url="#session.root#/Tools/EntityAction/Process/ActionProcess.cfm?ajaxid=&process=&myentity=&id=#access.actionId#&mid=#url.mid#">				
	<cfelse>
	    <div style="padding-top:15%; text-align:center; color:#eb5449;">
	        <h1>[ <cf_tl id="You have no access to this action"> ]</h1>
	    </div>
	</cfif> 
	
<cfelse>
	
	<div style="width:100%; height:100%; margin:0px; padding:0px;">
		<cfinclude template="PortalFunctionOpen.cfm"> 	

</cfif>
