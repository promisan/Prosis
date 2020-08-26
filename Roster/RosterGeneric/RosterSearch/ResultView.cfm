
<cfoutput>

<cfsavecontent variable="label">
	
	<cfquery name="Search" 
	        datasource="AppsSelection" 
	        username="#SESSION.login#" 
	        password="#SESSION.dbpw#">
	        SELECT *
			FROM RosterSearch
			WHERE SearchId = '#URL.ID#'
	</cfquery>  

	<cfset html="No">
		  
	<cfif Search.SearchCategory eq "Vacancy">
	
		<cfquery name="Vacancy" 
		     datasource="AppsVacancy" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			SELECT   *
			FROM     Document 
			WHERE    DocumentNo = '#Search.SearchCategoryId#'
		</cfquery>		
		
		  Roster search for recruitment request #Search.SearchCategoryId# [#Vacancy.Mission# / #Vacancy.PostGrade# / #Vacancy.FunctionalTitle#]
	
		<cfset html="no">
		
	<cfelseif Search.SearchCategory eq "Function">
	
			<cfquery name="Roster" 
			     datasource="AppsSelection" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				SELECT   FT.FunctionDescription,
				         F.GradeDeployment
				FROM     FunctionOrganization F INNER JOIN
				         FunctionTitle FT ON F.FunctionNo = FT.FunctionNo
				WHERE    F.FunctionId = '#Search.SearchCategoryId#'
			</cfquery>		
			 
			 #Roster.FunctionDescription# [#Roster.GradeDeployment#]	
			 
			 <cfset html="yes">	
					 
	<cfelseif Search.SearchCategory eq "default">
	
		<cfset html="no">
	
	<cfelse>
	
		<cfset html="Yes">
		  	
	  Roster search 
	  
	</cfif>

</cfsavecontent>


<cfquery name="Check" 
       datasource="AppsSelection" 
       username="#SESSION.login#" 
       password="#SESSION.dbpw#">
	   SELECT *
	   FROM   RosterSearch
	   WHERE  SearchId = '#URL.ID#'
</cfquery>

<cfparam name="URL.Height" default="600">
<cfparam name="URL.DocNo" default="">

<cf_screentop label="#label#" 
	   height="100%" 
	   html="#html#"
	   line="no" 
	   bannerheight="55"
	   layout="webapp" 
	   banner="gray"
	   border="1"   
	   jquery="Yes"
	   scroll="no">
   
<cf_LayoutScript>
<cfajaximport tags="cftree,cfform">	
		 
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">
	
	<!--- 
	<cf_layoutarea 
	   	position  = "header"
	   	name      = "reqtop"
	   	minsize	  = "60px"
		maxsize	  = "60px"
		size 	  = "60px">	
					  
		<cfinclude template="SearchMenu.cfm">
			 			  
	</cf_layoutarea>		
	--->
	 
		
	<cf_layoutarea position="center" name="box">
				
			<iframe src="ResultListing.cfm?mode=#url.mode#&docno=#url.docNo#&ID=GEN&ID1=#URL.ID#&ID2=B&ID3=GEN&height=#URL.height#"
		        name="center"
		        id="center"
		        width="100%"
		        height="100%"
				scrolling="no"
		        frameborder="0"></iframe>
					
	</cf_layoutarea>			
	
	<cf_layoutarea 
	    position    = "right" 
		name        = "treebox" 
		maxsize     = "370" 		
		size        = "270" 
		collapsible = "true" 
		splitter    = "true"
		overflow    = "hidden">
				
			<iframe src="SearchTree.cfm?docno=#url.docNo#&ID=1&ID1=#URL.ID#&mode=#url.Mode#&Owner=#Check.Owner#&Status=#Check.RosterStatus#"
		        name="left"
		        id="left"
		        width="100%"
		        height="100%"
				scrolling="no"
		        frameborder="0"></iframe>
	
	</cf_layoutarea>
		
</cf_layout>

</cfoutput>

