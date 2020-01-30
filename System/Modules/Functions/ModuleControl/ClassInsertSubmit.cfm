
<cfparam name="Attributes.ClassId" default="0">
<cfparam name="Attributes.SystemModule" default="System">
<cfparam name="Attributes.ClassName" default="">
<cfparam name="Attributes.ClassDescription" default="System">
<cfparam name="Attributes.ListingOrder" default="1">

<!--- check role --->
	<cfquery name="Check" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Class  
	WHERE   Classid = '#Attributes.ClassId#' 
	</cfquery>
			
	<cfif Check.recordcount eq "0">
	
	   <cfquery name="System" 
		datasource="AppsControl" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO  Class
		      (ClassId,
			  SystemModule, 
			  ClassDescription,
			  ListingOrder,
			  ClassName)
		VALUES ('#Attributes.ClassId#', 
			  '#Attributes.SystemModule#', 
			  '#Attributes.ClassDescription#',
			  '#Attributes.ListingOrder#',
			  '#Attributes.ClassName#') 
	   </cfquery>
	   
	  <cfelse> 
	  
	  <cfquery name="System" 
		datasource="AppsControl" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Class
		SET   Classname         = '#Attributes.ClassName#',
		      ClassDescription = '#Attributes.ClassDescription#',
			  ListingOrder = '#Attributes.ListingOrder#'
		WHERE   ClassId  = '#Attributes.Classid#' 
	   </cfquery>
		
	</cfif>