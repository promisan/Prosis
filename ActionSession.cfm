
<cfparam name="url.id" default="00000000-0000-0000-0000-000000000000">

<cf_tl id="Problem" var="1">
<cf_screentop html="No" title="#lt_text#" jquery="yes" bootstrap="yes">

<cf_publicinit>

<style>

	.center-screen {
		display: flex;
		flex-direction: column;
		justify-content: center;
		align-items: center;
		text-align: center;
		min-height: 100vh;
	}

	.main {
		height:100%; 
		width:100%; 
		padding:30px;
	}

	.container {
		background-color:#f5f5f5; 
		padding:30px; 
		border:1px solid #a8a8a8; 
		border-radius:10px; 
		overflow:hidden; 
		height:auto;
	}

	.title {
		color:#eb4034;
		font-size:23px; 
		text-align:center;
	}

	.subtitle {
		color:#0A72AF; 
		font-size:80%;
	}

	.metainfo {
		padding-top:10px; 
		color:#0A72AF; 
		font-size:110%;
	}

	.submetainfo {
		font-size:100%;
	}

	.logoContainer {
		text-align:center; 
		padding-bottom:20px;
	}

	.logo {
		height:100px; 
		width:auto;
	}

</style>

<cfoutput>

<script>

	function checkUserSession() {		
		_cf_loadingtexthtml='';				
		ptoken.navigate('#session.root#/tools/entityaction/session/checkSession.cfm?id=#url.id#&mode=start','sessionbox')
	}
	
</script>

</cfoutput>

<div class="main center-screen">
	<div class="container">

		<cfquery name="getLogo" 
			datasource="AppsInit">
			SELECT *
			FROM   Parameter		
			WHERE  Hostname = '#CGI.HTTP_HOST#'
		</cfquery>

		<div class="logoContainer">
			<cfoutput>
				<img src="#session.root#/#getLogo.ApplicationThemeLogo#" class="logo">
			</cfoutput>
		</div>

		<cftry>
			
			<cfquery name="SessionAction" 
			datasource="AppsOrganization">
				SELECT *
				FROM   OrganizationObjectActionSession 		
				WHERE  ActionSessionId = <cfqueryparam	value="#URL.ID#" cfsqltype="CF_SQL_IDSTAMP"> 	
			</cfquery>
						
			<cfif SessionAction.recordcount eq "1">
			
				<cfquery name="Entity" 
				datasource="AppsOrganization">
					SELECT *
					FROM   Ref_Entity
					WHERE  EntityCode = '#SessionAction.EntityCode#'	 
				</cfquery>	
									
				<cfset go = "1">	
						
				<cfif SessionAction.ActionId neq "">
								
					<cfquery name="Action" 
					datasource="AppsOrganization">
						SELECT *
						FROM   OrganizationObjectAction		
						WHERE  ActionId = '#SessionAction.ActionId#'	
					</cfquery>
					
					<cfquery name="Object" 
					datasource="AppsOrganization">
						SELECT *
						FROM   OrganizationObject	
						WHERE  ObjectId = '#Action.ObjectId#'	
					</cfquery>
					
					<!--- set the IP --->
					
					<cfif SessionAction.SessionIP eq "">
					
						<cfquery name="SessionAction" 
						datasource="AppsOrganization">
							UPDATE  OrganizationObjectActionSession 		
							SET     SessionIP = '#CGI.Remote_Addr#', SessionActualStart = getDate()				 
							WHERE   ActionSessionId = <cfqueryparam	value="#URL.ID#" cfsqltype="CF_SQL_IDSTAMP"> 	
						</cfquery>		
					
					</cfif>
													
					<div class="title" id="sessionbox"></div>
				
				</cfif>
							
			<cfelse>

				<div class="title">
					<cfoutput>
					<b>Attention:</b> Requested document has been processed already or does not longer exist.
					</cfoutput>  
				</div>	
				
			</cfif>			
			
			<cfcatch>

				<div class="title">
					<cfoutput>
					Form could not be retrieved.
					<div class="subtitle">Please contact your focal point if the problem persists.</div>
					</cfoutput>  
				</div>
			
			</cfcatch>

		</cftry>

		<cfif isDefined("SessionAction") AND SessionAction.RecordCount gt 0>
		
			<cfoutput>
			
				<div class="metainfo">
					Requested by #SessionAction.OfficerFirstName# #SessionAction.OfficerLastName#.
					<div class="submetainfo">Local time <span id="timeContainer"></span></div>
				</div>
				
				<script>												
					setInterval(checkUserSession, 60000) 	
					_cf_loadingtexthtml='';		
					ptoken.navigate('#session.root#/tools/entityaction/session/checkSession.cfm?id=#url.id#&mode=start','sessionbox')													
				</script>
				
			</cfoutput>
		</cfif>

	</div>
</div>

