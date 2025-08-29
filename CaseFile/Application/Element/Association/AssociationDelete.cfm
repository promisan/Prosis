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
<cfquery name="Check" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT    *
	     FROM      ElementRelation
		 WHERE     Elementid      = '#url.elementid1#'
		 AND       ElementidChild = '#url.elementid2#'	
		 UNION ALL
		 SELECT    *
	     FROM      ElementRelation
		 WHERE     ElementIdChild = '#url.elementid1#'
		 AND       Elementid      = '#url.elementid2#'		 
</cfquery>

<cfloop query="Check">
	
	<cfquery name="Logging" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			 INSERT INTO ElementRelationLog
    			 (Elementid,
	    		  ElementidChild,
				  RelationCode,
				  RelationMemo,
				  DateExpiration,
				  OfficerUserid,
				  OfficerLastName,
				  OfficerFirstName)
			 VALUES
				 ('#ElementId#',
				  '#ElementIdChild#',
				  '#RelationCode#',
				  '#RelationMemo#',
				  getdate(),
				  '#SESSION.acc#',
				  '#SESSION.last#',
				  '#SESSION.first#')		 
	</cfquery>
		
	<cfquery name="Clear" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			 DELETE ElementRelation		
			 WHERE     Elementid      = '#ElementId#'
			 AND       ElementidChild = '#ElementIdChild#'		
	</cfquery>	

</cfloop>

<cfinclude template="AssociationListingDetail.cfm">
