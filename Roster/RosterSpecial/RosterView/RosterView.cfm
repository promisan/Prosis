<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfparam name="URL.Edition" default="all">

<cfquery name="Edition" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_SubmissionEdition
	WHERE   SubmissionEdition = '#URL.Edition#'
	</cfquery>
		
	
<cfif Edition.recordcount eq "1">	

	<TITLE><cfoutput>#Edition.EditionDescription#</cfoutput></TITLE>

<cfelse>

    
<cfquery name="Owner" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_AuthorizationRoleOwner
	WHERE   Code = '#URL.Owner#'
	</cfquery>

	<TITLE><cfoutput>#Owner.Description#</cfoutput></TITLE>

</cfif>

<cfif URL.Edition eq "all">

	<cfoutput>
	
	<cf_tl id="Combined Roster Summary" var="1">
		<frameset rows="33,*" frameborder="0">
		  <cfif URL.Mode eq "Generic">
		    <frame src="#SESSION.root#/Tools/Control/Banner.cfm?Header=#lt_text# #URL.Owner#&action=closew" name="banner" id="banner" frameborder="0" scrolling="No" noresize TARGET="contents">
		  <cfelse>
		  	<frame src="#SESSION.root#/Tools/Control/Banner.cfm?Header=#lt_text# #URL.Owner#&action=closew" name="banner" id="banner" frameborder="0" scrolling="No" noresize TARGET="contents">
		  </cfif>	
		  <frame src="RosterViewLoop.cfm?Owner=#URL.Owner#&Edition=#URL.Edition#" name="top" scrolling="no" TARGET="contents">
	      <noframes>
		     <body>
		     <p>This page uses frames, but your browser doesn't support them.</p>
		     </body>
		  </noframes>
		</frameset>
	</cfoutput>

<cfelse>

	<cfoutput>
    	<cfinclude template="RosterViewLoop.cfm">		
	</cfoutput>

</cfif>
