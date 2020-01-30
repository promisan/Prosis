
<cfparam name="row"           default="0">
<cfparam name="sectionselect" default = "">

<cf_calendarscript>

<cfset rows = getTopicList.RecordCount>

<!--- 1. filter on the sectionselect value for the looing --->

<cfif sectionselect neq "">
	
	<cfquery name="getTopicListFilter" dbtype="query">
		SELECT * FROM getTopicList WHERE ElementSection = '#sectionselect#'
	</cfquery>
	
	<cfoutput query="getTopicListFilter">
	
		<cfset row = row + 1>	
		
		<cfif TopicClass eq 'Person'>		
		    <cfinclude template = "FieldPerson.cfm">
		<cfelse>
			<cfinclude template = "FieldCustom.cfm">
		</cfif>			
					    
	</cfoutput>	
	
	<cfif currentrow eq "1">
		<cfinclude template = "FieldStandard.cfm">
	</cfif>

<cfelse>
	
	<cfoutput query="getTopicList">
	
		<cfset row = row + 1>			
		<cfif TopicClass eq 'Person'>		
		    <cfinclude template = "FieldPerson.cfm">
		<cfelse>
			<cfinclude template = "FieldCustom.cfm">
		</cfif>							
		    
	</cfoutput>	
	
	<cfinclude template = "FieldStandard.cfm">

</cfif>

  