
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

	.float-bottom-right {
		position: fixed;
		bottom:7%;
		right:3%;
	}

	.main { 
		width:50%;
	}

	.container {
		background-color:rgba(255,255,255,0.75); 
		padding:30px; 
		border:1px solid #a8a8a8; 
		border-radius:10px; 
		overflow:hidden; 
		height:auto;
		width:100%;
	}

	.title {
		color:#303030;
		font-size:20px; 
		text-align:center;
	}

	.subtitle {
		color:#303030; 
		font-size:80%;
	}

	.metainfo {
		color:#303030; 
		font-size:110%;
		position: fixed;
		top:3%;
		left:3%;
		padding:30px;
		background-color:rgba(255,255,255,0.75); 
		border:1px solid #a8a8a8; 
		border-radius:3px; 
		overflow:hidden; 
	}
	
	.logoContainer {
		text-align:center; 
		padding-bottom:20px;
	}

	.logo {
		height:60px; 
		width:auto;
	}

	@media only screen and (max-width: 768px) {
		.logo {
			height:75px; 
		}
	}

</style>

<cfoutput>

	<script>

		function checkUserSession() {		
			_cf_loadingtexthtml='';				
			ptoken.navigate('#session.root#/tools/entityaction/session/checkSession.cfm?id=#url.id#&mode=init','sessionbox')
		}
		
	</script>

</cfoutput>

<div class="main float-bottom-right">

	<div class="container">

		<cfquery name="getLogo" 
			datasource="AppsInit">
			SELECT *
			FROM   Parameter		
			WHERE  Hostname = '#CGI.HTTP_HOST#'
		</cfquery>

		<div class="logoContainer">
		
			<table style="width:100%">
			<tr style="border-bottom:1px solid black" class="labelmedium"><td style="padding-bottom:5px">
			<cfoutput>
				<img src="#session.root#/#getLogo.ApplicationThemeLogo#" class="logo">
			</cfoutput>
			</td>
			<td style="font-size:20px;padding-bottom:5px" valign="bottom"  align="right"><cf_tl id="User Session"></td>
			</tr></table>
			
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

	</div>
</div>

<cfif isDefined("SessionAction") AND SessionAction.RecordCount gt 0>

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

	<cfif getBackground.recordCount eq 1 AND getBackground.SessionBackground neq "">
		<cfoutput>
			<style>
				body {
					background-image: url("#session.root#/#getBackground.SessionBackground#");
					background-position: center; 
  					background-repeat: no-repeat; 
  					background-size: cover; 
				}
			</style>
		</cfoutput>
	</cfif>
		
	<cfoutput>
	
		<div class="metainfo">
			<cf_tl id="Your contact">: #SessionAction.OfficerFirstName# #SessionAction.OfficerLastName#.
		</div>
		
		<script>												
			checkUserSession();
			setInterval(checkUserSession, 30000);				
		</script>
		
	</cfoutput>

</cfif>
