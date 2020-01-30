<!DOCTYPE html>
<cfsilent>
	<!--- in some cases the header/footer may be invoked when there is no url builder (eg if request.fuseguard is missing) --->
	<cfset request.hasUrlBuilder = StructKeyExists(request, "urlBuilder")>
	<cfif NOT StructKeyExists(request, "title")>
		<cfset request.title = "Web Manager">
	</cfif>
	<cfif NOT StructKeyExists(request, "isAuthenticated") OR NOT IsBoolean(request.isAuthenticated)>
		<cfset request.isAuthenticated = false>
	</cfif>
	<!--- Enable Content-Security-Policy --->
	<cfif NOT StructKeyExists(request, "csp")>
		<cfif request.hasUrlBuilder>
			<cfset request.csp = request.urlBuilder.getDefaultContentSecurityPolicy()>
		<cfelse>
			<cfset request.csp = "default-src 'self';">
		</cfif>
	</cfif>
	<cfheader name="Content-Security-Policy" value="#request.csp#"><!--- Chrome 25+ --->
	<cfheader name="X-Content-Security-Policy" value="#request.csp#"><!--- FF --->
	<cfheader name="X-Webkit-CSP" value="#request.csp#">	
	<!--- prevent loading inside of a frame, clickjacking --->
	<cfheader name="X-Frame-Options" value="DENY">
	<cfset css = StructNew()>
	<cfif request.hasUrlBuilder>
		<cfset css.bootstrap = request.urlBuilder.createStaticURL("views/bootstrap/css/bootstrap.min.css")>
		<cfset css.fuseguard = request.urlBuilder.createStaticURL("views/style/style.css")>
	<cfelse>
		<cfset css.bootstrap = "views/bootstrap/css/bootstrap.min.css">
		<cfset css.fuseguard = "views/style/style.css">
	</cfif>
</cfsilent>
<html>
	<head>
		<cfoutput>
			<title>#XmlFormat(request.title)#</title>	
			<link rel="stylesheet" href="#XmlFormat(css.bootstrap)#" type="text/css" />
			<link rel="stylesheet" href="#XmlFormat(css.fuseguard)#" type="text/css" />
			<meta name="robots" content="NOINDEX,NOFOLLOW" />
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		</cfoutput>		
	</head>
	<body>
	<div id="header" class="navbar navbar">
		<div class="navbar-inner">
			<div class="container">
				<a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
				</a>
				
		<cfif request.isAuthenticated>
			<cfoutput>
			<a class="brand" href="#request.urlBuilder.createDynamicURL("index")#">FuseGuard Manager</a>
				
				<div class="nav-collapse" id="navCollapse">
					<ul class="nav">
						<li class="divider-vertical"></li>
						<li<cfif request.urlBuilder.isCurrentAction("index")> class="active"</cfif>><a href="#request.urlBuilder.createDynamicURL("index")#"><img src="#request.urlBuilder.createStaticURL('views/images/dashboard.png')#" class="icon" border="0" height="20" width="20" alt="dashboard" /> Dashboard</a></li>
						<li class="dropdown <cfif request.urlBuilder.isCurrentAction("log") OR request.urlBuilder.isCurrentAction("log-detail")> active</cfif>" id="mLogs">
							
							<a class="dropdown-toggle" data-toggle="dropdown" href="##mLogs">
								<img src="#request.urlBuilder.createStaticURL('views/images/line-chart.png')#" class="icon" border="0" alt="logs" height="20" width="20" /> Logs
								<b class="caret"></b>
								
							</a>
				    		<ul class="dropdown-menu">
				      				<li><a href="#request.urlBuilder.createDynamicURL('log', 'mode=graph')#">Graphical Log View</a></li>
				      				<li><a href="#request.urlBuilder.createDynamicURL('log', 'mode=table')#">Tabular Log View</a></li>
				      			
					    		</ul>
						</li>
						<li<cfif request.urlBuilder.isCurrentAction("config")> class="active"</cfif>><a href="#request.urlBuilder.createDynamicURL('config')#"><img src="#request.urlBuilder.createStaticURL('views/images/gear.png')#" class="icon" border="0" alt="config" height="20" width="20" /> Configuration</a></li>
						<li<cfif request.urlBuilder.isCurrentAction("user")> class="active dropdown"<cfelse> class="dropdown"</cfif>>
							<a href="#request.urlBuilder.createDynamicURL('user')#" class="dropdown-toggle" data-toggle="dropdown"><img src="#request.urlBuilder.createStaticURL('views/images/user.png')#" class="icon" border="0" alt="user" width="14" height="20" /> Users <b class="caret"></b></a>
							<ul class="dropdown-menu">
									<li><a href="#request.urlBuilder.createDynamicURL('user', 'mode=me')#">My Account</a></li>
				      				<cfif request.firewall.getAuthenticator().isAuthenticatedUserAdmin()>
										<li><a href="#request.urlBuilder.createDynamicURL('user', 'mode=list')#">List Users</a></li>
										<li><a href="#request.urlBuilder.createDynamicURL('user', 'mode=new')#">Create User</a></li>
									</cfif>
				      			
					    		</ul>
						</li>
					</ul>
					<ul class="nav pull-right" role="menu">
						<li class="divider-vertical"></li>
  						<li><a href="#request.urlBuilder.createDynamicURL('logout')#"><i class="icon-plane"></i> Logout</a></li>
  						<li class="divider"></li>
					</ul>
				</div>
			</cfoutput>
		<cfelseif request.hasUrlBuilder AND request.urlBuilder.isCurrentAction("forgot-password")>
			<a href="##" class="brand">Forgot Password</a>
		<cfelse>
			<a href="##" class="brand">Please Login Below</a>
		</cfif>
		</div>
		</div>
	</div>
	<div id="content" class="container">