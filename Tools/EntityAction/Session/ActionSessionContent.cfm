
<cf_screentop label="User Session" html="No" jquery="Yes" scroll="Yes">

<cfquery name="SessionAction" 
	datasource="AppsOrganization">
		SELECT *
		FROM   OrganizationObjectActionSession 		
		WHERE  ActionSessionId = <cfqueryparam	value="#url.actionsessionid#" cfsqltype="CF_SQL_IDSTAMP"> 	
</cfquery>

<cfquery name="getBackground" 
		datasource="AppsOrganization">
		SELECT	ECM.SessionBackGround
		FROM	OrganizationObjectActionSession S INNER JOIN 
		        OrganizationObjectAction A ON S.ActionId = A.ActionId INNER JOIN 
				OrganizationObject O ON A.ObjectId = O.ObjectId	INNER JOIN 
				Ref_EntityClassMission ECM ON ECM.EntityCode = O.EntityCode
											AND ECM.EntityClass = O.EntityClass
											AND ECM.Mission = O.Mission
		WHERE	S.ActionSessionId = '#SessionAction.ActionSessionId#'
</cfquery>

<cfoutput>

	<style>
	
		body {
			background-image: url("#session.root#/#getBackground.SessionBackground#");
			background-position: center; 
			background-repeat: no-repeat; 
			background-size: cover; 
			}
			
		.metainfo {
			background-color:f1f1f1; 						
			position: fixed;
			top:3%;
			left:3%;
			padding:8px;			
			border:1px solid black; 
			border-radius:3px; 
			
	}	
			
	</style>
	
	<cf_textareascript>
	
	<script>

		function checkUserSession() {		
			_cf_loadingtexthtml='';				
			ptoken.navigate('#session.root#/tools/entityaction/session/checkSession.cfm?id=#url.actionsessionid#&mode=session','sessionbox')
		}
		
	</script>

</cfoutput>

<cfquery name="Document" 
	datasource="AppsOrganization">
		SELECT *
		FROM   Ref_EntityDocument
		WHERE  DocumentId = '#SessionAction.SessionDocumentId#'	 
</cfquery>	
		
<cfset doc = Document.DocumentTemplate>	

<cf_divscroll>
	
	<cfoutput>
	
	<div class="main float-bottom-right" style="padding:13px">    
		<div class="metainfo" id="sessionbox">	
		<cf_tl id="Your contact">: #SessionAction.OfficerFirstName# #SessionAction.OfficerLastName#.
		</div>		
		<div class="container" style="background-color:white;padding-bottom:20px;border:1px solid black">	
		<cfinclude template="../../../#doc#">	
		</div>	
	</div>	
	
	</cfoutput>

</cf_divscroll>

<script>												
	checkUserSession();
	setInterval(checkUserSession, 10000);				
</script>

	
