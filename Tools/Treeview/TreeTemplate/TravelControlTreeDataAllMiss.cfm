<!---

    UN PMStars
	
	..Tools/TreeTemplate/TravelControlTreeData.cfm
	
	Build code that dynamically controls which folders will display in the left panel
	of the Monitor Personnel Requests control page.  
	
	This is the version called when current user HAS access to all missions.
	
--->

<cfoutput>

['<b>Mission</b>',null, 

<cfquery name="Mission" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT DISTINCT D.Mission FROM Document D
	WHERE EXISTS (SELECT AA.*
				  FROM  ActionAuthorization AA, FlowAction FA, Ref_TravellerType RT, Ref_Category RC,
				  	    Organization.DBO.Ref_MissionModule MM 
				  WHERE AA.ActionId = FA.ActionID
				  AND   FA.ActionClass = RT.TravellerTypeCode
				  AND   RT.TravellerType = RC.TravellerType
			  	  AND   AA.AccessLevel <> '9'
				  AND   AA.UserAccount = '#SESSION.acc#'
				  AND   MM.SystemModule = 'PM Travel'
				  AND   MM.Mission  = D.Mission
				  AND   RC.Category = D.PersonCategory)
	ORDER BY D.Mission
</cfquery>	

<cfloop query = "Mission">
 
  <cfset #Mis# = #Mission.Mission#>

  ['#Mission#',null,
  
   <cfquery name="Status" 
	datasource="AppsTravel" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DISTINCT RS.Status, RS.Description
	FROM  ActionAuthorization AA, FlowAction FA, Ref_TravellerType RT, Ref_Category RC,  Document D, Ref_Status RS
	WHERE AA.AccessLevel <> '9'
	AND   AA.UserAccount = '#SESSION.acc#'
	AND   AA.ActionId    = FA.ActionID
	AND   FA.ActionClass = RT.TravellerTypeCode
	AND   RT.TravellerType = RC.TravellerType
	AND   RC.Category    = D.PersonCategory
	AND   D.Status       = RS.Status
	AND   RS.Class       = 'Document'
	AND   D.Mission      = '#Mis#'
   </cfquery>

  <cfloop query="Status">
  
  <cfset #Sta# = #Status.Status#>
  
  <cfif #Sta# neq "0">

  ['#Description#','ControlListing.cfm?ID=MIS&ID1=#Mis#&ID2=#Sta#&IDArea=',
  
  <cfelse>
  
  ['#Description#','ControlListing.cfm?ID=MIS&ID1=#Mis#&ID2=#Sta#&IDArea=',
   
   <cfquery name="Area" 
	datasource="AppsTravel" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DISTINCT RC.TravellerType AS ActionArea
	FROM Document D, ActionAuthorization AA, FlowAction FA, Ref_TravellerType RT, Ref_Category RC
	WHERE AA.ActionId = FA.ActionID
	AND   FA.ActionClass = RT.TravellerTypeCode
	AND   RT.TravellerType = RC.TravellerType
	AND   AA.AccessLevel <> '9'
	AND   AA.UserAccount = '#SESSION.acc#'
	AND   D.Mission      = '#Mis#'
   </cfquery>

  <cfloop query="Area">
  
  <cfset #Are# = #Area.ActionArea#>

  ['#Are#','ControlListing.cfm?ID=MIS&ID1=#Mis#&ID2=#Sta#&IDArea=#Are#'],
  
  </cfloop>
  
  </cfif>
  
  ],
  
   </cfloop>],
   
  </cfloop>]

  
</cfoutput>