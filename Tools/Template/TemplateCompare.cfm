
<cfparam name="attributes.left"   default="">
<cfparam name="attributes.right"  default="">
<cfparam name="attributes.output" default="">
<cfparam name="attributes.script" default="#SESSION.rootPath#\cfrstage\user\#SESSION.acc#\script.txt">
<cfparam name="attributes.bat"    default="#SESSION.rootPath#\cfrstage\user\#SESSION.acc#\bcbat.bat">
<cfparam name="attributes.delete" default="no">

<cfparam name="left"       default="#attributes.left#">
<cfparam name="right"      default="#attributes.right#">
<cfparam name="output"     default="#attributes.output#">
<cfparam name="batfile"    default="#attributes.bat#">
<cfparam name="scriptfile" default="#attributes.script#">
<cfparam name="delete"     default="#attributes.delete#">

<cfif right eq "" or left eq "" or output eq "">
   aborted
   <cfabort>
</cfif>

<cfoutput>

<cfquery name="Engine" 
datasource="appsInit">
	SELECT *
	FROM   Parameter
	WHERE HostName = '#CGI.HTTP_HOST#'
</cfquery>	

<cfset bc = "#Engine.CompareEngine#">
	
<cfsavecontent variable="script">
	file-report layout:Composite &
	options:ignore-unimportant,display-context &
	output-to:#output# &
	output-options:html-color,wrap-word &
	#right# &
	#left# 
</cfsavecontent>

<cftry>
	
	<cffile action="WRITE" file="#scriptfile#" 
	                       output="#script#" 
						   addnewline="Yes" fixnewline="No">		
						   
	<cfsavecontent variable="bat">"#bc#" @#scriptfile#</cfsavecontent>
	
	<cffile action="WRITE" file="#batfile#"
					       output="#bat#"
					       addnewline="Yes" fixnewline="No">		
	
	<cfsilent>
		<cfexecute name="#batfile#" timeOut="3"></cfexecute>
	</cfsilent>

	<cfcatch></cfcatch>
	
</cftry>

<cfif delete eq "yes">

	<cf_sleep seconds="1"> 
	<cftry>
		<cffile action="DELETE" file="#left#">
		<cffile action="DELETE" file="#right#">
	<cfcatch></cfcatch>
	</cftry>

</cfif>

</cfoutput>
