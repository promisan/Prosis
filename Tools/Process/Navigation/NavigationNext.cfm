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
<cf_param name="URL.Mission"   default="" type="String">
<cf_param name="URL.Prior"     default="" type="String">
<cf_param name="URL.Move"      default="next" type="String">
<cf_param name="URL.Code"      default="" type="String">
<cf_param name="URL.Group"     default="" type="String">
<cf_param name="URL.Id1"       default="" type="String">
<cf_param name="URL.mid"       default="" type="String">  <!--- type="GUID" --->
<cf_param name="URL.Owner" 	   default="" type="String">
<cf_param name="URL.Alias" 	   default="" type="String">
<cf_param name="URL.Objectid"  default="" type="String">
<cf_param name="URL.tablename" default="" type="String">

<cf_systemscript>

<cfoutput>

<cfquery name="Parameter" 
	datasource="#Alias#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
    FROM   Parameter R
</cfquery>

<cftry>
	<!--- Check if the table has an underline owner restriction --->
	
	<cfquery name="qCheckOwnerSection" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     #CLIENT.LanPrefix#Ref_#Object#SectionOwner
		WHERE    Owner = <cfqueryparam value="#URL.Owner#" cfsqltype="CF_SQL_CHAR" maxlength="10"> 
	</cfquery>
	<cfset ValidateOwner = qCheckOwnerSection.recordcount>
	
<cfcatch>

	<cfset ValidateOwner = 0>	
	
</cfcatch>	
</cftry>
 
<cfif URL.move eq "back">

	<cfquery name="Nav" 
	  datasource="#Alias#" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT   TOP 1 R.*  
	    FROM     #Object#Section S INNER JOIN
	             Ref_#Object#Section R ON S.#Object#Section = R.Code
	    WHERE    S.#Object##objectId# = <cfqueryparam value="#URL.ID#" cfsqltype="CF_SQL_CHAR" maxlength="50">
	    					
				<cfif Object eq "Applicant">
					 AND R.TriggerGroup = <cfqueryparam value="#URL.Group#" cfsqltype="CF_SQL_CHAR" maxlength="20">
				</cfif>
				
		AND      R.Operational = 1
		AND      S.Operational = 1
		AND      ListingOrder < <cfqueryparam value="#URL.Prior#" cfsqltype="CF_SQL_CHAR" maxlength="4">
		<cfif ValidateOwner neq 0>
			AND EXISTS
			(
				SELECT 'X'
				FROM   #CLIENT.LanPrefix#Ref_#Object#SectionOwner
				WHERE  Code = R.Code
				AND    Owner = <cfqueryparam value="#URL.Owner#" cfsqltype="CF_SQL_CHAR" maxlength="10">
				AND    Operational = '1' 
			)
		</cfif>						
		ORDER BY R.ListingOrder DESC 
	</cfquery>
	
<cfelseif URL.move eq "current">

	<cfquery name="Nav" 
	  datasource="#Alias#" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT   TOP 1 R.*  
	    FROM     #Object#Section S INNER JOIN
	             Ref_#Object#Section R ON S.#Object#Section = R.Code
	    WHERE    S.#Object##objectId# = <cfqueryparam value="#URL.ID#" cfsqltype="CF_SQL_CHAR" maxlength="50">
	    				
		<cfif Object eq "Applicant">
			 AND R.TriggerGroup = <cfqueryparam value="#URL.Group#" cfsqltype="CF_SQL_CHAR" maxlength="20">
		</cfif>
		AND      R.Operational = 1
		AND      S.Operational = 1
		AND      ListingOrder = <cfqueryparam value="#URL.Prior#" cfsqltype="CF_SQL_CHAR" maxlength="4">
		<cfif ValidateOwner neq 0>
			AND EXISTS
			(
				SELECT 'X'
				FROM   #CLIENT.LanPrefix#Ref_#Object#SectionOwner
				WHERE  Code = R.Code
				AND    Owner = <cfqueryparam value="#URL.Owner#" cfsqltype="CF_SQL_CHAR" maxlength="10">
				AND    Operational = '1' 
			)
		</cfif>									
		ORDER BY R.ListingOrder DESC 
	</cfquery>	
	
<cfelse>

	<!--- next free --->

	<cfquery name="Update" 
		datasource="#Alias#">
		
		UPDATE  #Object#Section 
		SET     ProcessStatus       = '1',
		        ProcessDate         = getDate(),
			    OfficerUserId       = '#SESSION.acc#',   
			    OfficerLastName     = '#SESSION.last#',
			    OfficerFirstName    = '#SESSION.first#'
		WHERE   #Object##ObjectId#  = <cfqueryparam value="#URL.ID#" cfsqltype="CF_SQL_CHAR" maxlength="50">
		AND     ProcessStatus        = '0' 
		AND     Operational          = 1
		AND     #Object#Section IN (SELECT Code 
		                            FROM   Ref_#Object#Section 
									WHERE  ListingOrder = <cfqueryparam value="#URL.Prior#" cfsqltype="CF_SQL_CHAR" maxlength="4">)
	</cfquery> 
	
	<cfquery name="update" 
	  datasource="#Alias#" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT   TOP 1 R.* 
	    FROM     #Object#Section S INNER JOIN
	             Ref_#Object#Section R ON S.#Object#Section = R.Code
	    WHERE    S.#Object##objectId# = <cfqueryparam value="#URL.ID#" cfsqltype="CF_SQL_CHAR" maxlength="50">	    			
		<cfif Object eq "Applicant">
		AND      R.TriggerGroup = <cfqueryparam value="#URL.Group#" cfsqltype="CF_SQL_CHAR" maxlength="20">
		</cfif>		
		AND      S.ProcessStatus = '0'	
		AND      R.Operational = 1
		AND      S.Operational = 1
		<cfif ValidateOwner neq 0>
		AND      EXISTS (
				   SELECT 'X'
				   FROM   #CLIENT.LanPrefix#Ref_#Object#SectionOwner
				   WHERE  Code = R.Code
				   AND    Owner = <cfqueryparam value="#URL.Owner#" cfsqltype="CF_SQL_CHAR" maxlength="10">
				   AND    Operational = '1' )
		</cfif>							
		ORDER BY R.ListingOrder 
	</cfquery>		
		
	<cfquery name="Nav" 
	  datasource="#Alias#" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT   TOP 1 R.* 
	    FROM     #Object#Section S INNER JOIN
	             Ref_#Object#Section R ON S.#Object#Section = R.Code
	    WHERE    S.#Object##objectId# = <cfqueryparam value="#URL.ID#" cfsqltype="CF_SQL_CHAR" maxlength="50">	    			
		<cfif Object eq "Applicant">
		AND      R.TriggerGroup = <cfqueryparam value="#URL.Group#" cfsqltype="CF_SQL_CHAR" maxlength="20">
		</cfif>	    
		<cfif url.move eq "nextlast">
		AND      S.ProcessStatus = 0			
		<cfelse>		
		AND      R.ListingOrder > <cfqueryparam value="#URL.Prior#" cfsqltype="CF_SQL_CHAR" maxlength="4">	      
		</cfif>		
		AND      R.Operational = 1		
		AND      S.Operational = 1
		<cfif ValidateOwner neq 0>
			AND EXISTS
			(
				SELECT 'X'
				FROM   #CLIENT.LanPrefix#Ref_#Object#SectionOwner
				WHERE  Code = R.Code
				AND    Owner = <cfqueryparam value="#URL.Owner#" cfsqltype="CF_SQL_CHAR" maxlength="10">
				AND    Operational = '1' 
			)
		</cfif>			
						
		ORDER BY R.ListingOrder 
		
	</cfquery>
	
	<cfif nav.recordcount eq "0">
					
		<cfquery name="Nav" 
		  datasource="#Alias#" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		    SELECT   TOP 1 R.*
		    FROM     #Object#Section S INNER JOIN
		             Ref_#Object#Section R ON S.#Object#Section = R.Code
		    WHERE    S.#Object##objectId# = <cfqueryparam value="#URL.ID#" cfsqltype="CF_SQL_CHAR" maxlength="50">		    			
			<cfif Object eq "Applicant">
			AND      R.TriggerGroup = <cfqueryparam value="#URL.Group#" cfsqltype="CF_SQL_CHAR" maxlength="20">	
			</cfif>			
			AND      R.ListingOrder > <cfqueryparam value="#URL.Prior#" cfsqltype="CF_SQL_CHAR" maxlength="4"> 
			AND      R.Operational = 1
			AND      S.Operational = 1
			<cfif ValidateOwner neq 0>
			AND      EXISTS (
						SELECT 'X'
						FROM   #CLIENT.LanPrefix#Ref_#Object#SectionOwner
						WHERE  Code = R.Code
						AND    Owner = <cfqueryparam value="#URL.Owner#" cfsqltype="CF_SQL_CHAR" maxlength="10">
						AND    Operational = '1' 
			    	)
			</cfif>								
			ORDER BY R.ListingOrder
		</cfquery>
		
		<cfif nav.recordcount eq "0">
		
			<cfquery name="Nav" 
			  datasource="#Alias#" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			    SELECT   TOP 1 R.*
			    FROM     #Object#Section S INNER JOIN
			             Ref_#Object#Section R ON S.#Object#Section = R.Code
			    WHERE    S.#Object##objectId# = <cfqueryparam value="#URL.ID#" cfsqltype="CF_SQL_CHAR" maxlength="50">			    			
				<cfif Object eq "Applicant">
				AND      R.TriggerGroup = <cfqueryparam value="#URL.Group#" cfsqltype="CF_SQL_CHAR" maxlength="20">
				</cfif>				
				AND      R.Operational = 1		
				AND      S.Operational = 1		
				<cfif ValidateOwner neq 0>
				AND     EXISTS (
						SELECT 'X'
						FROM   #CLIENT.LanPrefix#Ref_#Object#SectionOwner
						WHERE  Code = R.Code
						AND    Owner = <cfqueryparam value="#URL.Owner#" cfsqltype="CF_SQL_CHAR" maxlength="10">
						AND    Operational = '1' 
						)
				</cfif>									
				ORDER BY R.ListingOrder DESC
			</cfquery>
				
		</cfif>
	
	</cfif>
	
</cfif>	

<cfif find("id1=","#nav.TemplateCondition#")>
	<script language="JavaScript">
		ptoken.location("#SESSION.root#/#Parameter.TemplateRoot#/#Nav.TemplateURL#?reload=1&mission=#URL.mission#&owner=#url.owner#&Code=#URL.Code#&Topic=#Nav.TemplateTopicId#&Section=#Nav.code#&Alias=#Alias#&Object=#Object#&#Object##objectid#=#URL.Id#&#nav.TemplateCondition#&group=#url.group#")  
	</script>	
<cfelse>
	<script language="JavaScript">
		ptoken.location("#SESSION.root#/#Parameter.TemplateRoot#/#Nav.TemplateURL#?reload=1&mission=#URL.mission#&owner=#url.owner#&Code=#URL.Code#&Topic=#Nav.TemplateTopicId#&Section=#Nav.code#&Alias=#Alias#&Object=#Object#&#Object##objectid#=#URL.Id#&id1=#URL.ID1##nav.TemplateCondition#&group=#url.group#")  
	</script>	
</cfif>
		
</cfoutput>	
