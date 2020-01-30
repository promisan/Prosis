
<!--- check class --->
<cfparam name="Attributes.PeriodEnable" default="0">
<cfparam name="Attributes.Description"  default="">

<cfquery name="Check" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_ExperienceParent
WHERE  Parent = '#Attributes.Parent#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_ExperienceParent
	       (Parent, Description, Area, SearchEnable, SearchOrder, PeriodEnable) 
	VALUES ('#Attributes.Parent#',
	        <cfif Attributes.Description neq "">
			'#Attributes.Description#',
			<cfelse>
			NULL,
			</cfif>
	        '#Attributes.Area#',
			'#Attributes.SearchEnable#',
			'#Attributes.SearchOrder#',
			'#Attributes.PeriodEnable#')
	</cfquery>
	
<cfelse>

	<cfquery name="Update" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_ExperienceParent
	SET Area         = '#Attributes.Area#',
	    <cfif Attributes.Description neq "">
		Description = '#Attributes.Description#',		
		</cfif>
	    <!--- SearchEnable = '#Attributes.SearchEnable#', 
	    SearchOrder  = '#Attributes.SearchOrder#',
		--->
		PeriodEnable = '#Attributes.PeriodEnable#' 
	WHERE Parent = 	'#Attributes.Parent#'
	</cfquery>
			
</cfif>

