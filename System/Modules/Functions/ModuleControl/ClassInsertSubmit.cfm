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