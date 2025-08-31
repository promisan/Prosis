<!--
    Copyright Â© 2025 Promisan B.V.

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
<cfquery name="get" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   ApplicantReview
	WHERE  ReviewId = '#URL.ReviewId#' 
</cfquery>   

<cfquery name="Delete" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM  ApplicantReview
	WHERE     ReviewId = '#URL.ReviewId#' 
</cfquery>   

<cfinvoke component = "Service.RosterStatus"  
   method           = "RosterSet" 
   personno         = "#get.PersonNo#" 
   owner            = "#get.Owner#"
   returnvariable   = "rosterstatus">	
	
<cflocation url="../General.cfm?Owner=#URL.Owner#&ID=#URL.ID#&section=general&topic=review&ID1=#URL.ID1#" addtoken="No">