
<cfparam name="URL.ID" default="">

<cfif url.id eq "">

	<cf_message text="Problem, please contact your administrator">
	<cfabort>
	
</cfif>

<cfquery name="Action" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
   SELECT *
   FROM   OrganizationObjectAction OA, 
          #CLIENT.LanPrefix#Ref_EntityActionPublish P,
		  Ref_EntityAction A		
   WHERE  ActionId = '#URL.ID#' 
   AND    OA.ActionPublishNo = P.ActionPublishNo
   AND    OA.ActionCode = P.ActionCode 
   AND    OA.ActionCode = A.ActionCode 
</cfquery>

<cfif Action.recordcount eq "0">
	<cf_message text="Problem, please contact your administrator">
	<cfabort>
</cfif>

<cfquery name="Object" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
   SELECT *
   FROM OrganizationObject O, Ref_Entity R		
   WHERE ObjectId = '#Action.ObjectId#' 
   AND O.EntityCode = R.EntityCode
   AND O.Operational  = 1
</cfquery>

<cfswitch expression="#Object.EntityCode#">
<cfcase value="ProcJob">
	<cf_dialogProcurement>
</cfcase>
</cfswitch>

<cfparam name="URL.ajaxId" default="">

<cfif Action.ProcessMode eq "0">

    <!--- SINGLE screen mode :
	The single screen mode shows all the information in one screen which has to be PROCESSED in one action at the top.
	Attention: This mode does not provide support for 
	- generation of embedded documents to be genertated nor
	- for system defined dialogs !
	Note : Custom field entry and custom attachment entry IS NOW SUPPORTED
	--->	
	<cfinclude template="ProcessAction7.cfm">
        
	
<cfelse>

	 <!--- TABBED screen mode :
	The tabbed screen mode shows 
	custom dialog and reports in a different tab, which maybe be saved independently from the processed action.
	Custom fields are saved upon submission
	Attention : custom dialog is validated to ensure completeness in case of a forward.	
	--->
    <cfinclude template="ProcessAction8.cfm">
        
	
</cfif>	 
	
