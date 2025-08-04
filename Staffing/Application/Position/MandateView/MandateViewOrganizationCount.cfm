<!--
    Copyright © 2025 Promisan

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
<!--- <cfif act eq "0"> disabled --->

<cfquery name="Create"
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
 CREATE  INDEX [Position_#SESSION.acc#Post#FileNo#] 
       ON [dbo].[#SESSION.acc#Post#FileNo#]([PositionNo]) ON [PRIMARY]
	   
</cfquery>

<cfquery name="Create"
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
 CREATE  INDEX [Unit_#SESSION.acc#Post#FileNo#] 
       ON [dbo].[#SESSION.acc#Post#FileNo#]([OrgUnit],[Class]) ON [PRIMARY]
	   
</cfquery>

<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#PositionSum#FileNo#">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Post#FileNo#_PreCalc">

<cfquery name="Create"
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
CREATE TABLE dbo.#SESSION.acc#PositionSum#FileNo# (
      [OrgUnit]      [int] NOT NULL , 
	  [Authorised]   [int] NULL , 
	  [Post]         [int] NULL , 
      [PostBorrowed] [int] NULL , 
	  [PostLoaned]   [int] NULL ,
	  [Staff]        [int] NULL )
</cfquery>

<cfif URL.ID neq "BOR">

	<cfquery name="SearchResultPreCalc" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   DISTINCT OrgUnit, HierarchyCode
	INTO 	 #SESSION.acc#Post#FileNo#_PreCalc
	FROM     #SESSION.acc#Post#FileNo# P 
	</cfquery>

<cfelse>

	<cfquery name="SearchResultPreCalc" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   DISTINCT OrgUnit, 
	         P.PostOrder
	INTO 	UserQuery.dbo.#SESSION.acc#Post#FileNo#_PreCalc
	    FROM  userQuery.dbo.#SESSION.acc#Post#FileNo# P 
		WHERE P.HierarchyCode >= '#HStart#' 
	      AND P.HierarchyCode < '#HEnd#' 
	</cfquery>

</cfif>

<cfquery name="SearchResultA" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      UserQuery.dbo.#SESSION.acc#Post#FileNo#_PreCalc
	ORDER BY HierarchyCode 
</cfquery>

<cfif URL.ID eq "ORG">
   <cfset cond = CondA>
</cfif>

<cfset vDetailCondition = PreserveSingleQuotes(cond)>

<cfif URL.ID eq "PGP">
	<cfsavecontent variable="vDetailCondition">
		<cfoutput>
			AND   P.PositionNo IN (SELECT PositionNo 
							       FROM    Employee.dbo.PositionGroup 
							       WHERE   #PreserveSingleQuotes(cond)#) 
		</cfoutput>
	</cfsavecontent>
</cfif>

<cfquery name="SearchResultA_InsertCalcs" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO UserQuery.dbo.#SESSION.acc#PositionSum#FileNo#
	
		       (OrgUnit, 
			    Authorised,
			    Post,
			    PostBorrowed, 
				PostLoaned, 
				Staff)

	SELECT    OrgUnit,
				(
					SELECT COUNT(DISTINCT PositionParentId) as PositionNo 
				     FROM   #SESSION.acc#Post#FileNo# P 
					 WHERE  P.OrgUnit = MainTable.OrgUnit
					 AND    P.PostAuthorised = 1		
					 <!--- position does not exist as loan construction from another unit as such we exclude borrowed --->
					 AND    PositionNo NOT IN (SELECT PositionNo 
					                           FROM  #SESSION.acc#Post#FileNo# 
											   WHERE Class  IN ('Loaned','Floated')
											   AND   OrgUnitOperational != MainTable.OrgUnit
											   )				 				
					        #preserveSingleQuotes(vDetailCondition)#
				),
				
				(
					SELECT  COUNT(DISTINCT PositionParentId) as PositionNo 
				     FROM   #SESSION.acc#Post#FileNo# P 
					 WHERE  P.OrgUnit = MainTable.OrgUnit
					 AND    PositionNo NOT IN (SELECT PositionNo 
					                           FROM  #SESSION.acc#Post#FileNo# 
											   WHERE Class  IN ('Loaned','Floated')
											   AND   OrgUnitOperational != MainTable.OrgUnit
											   )
					         #preserveSingleQuotes(vDetailCondition)#
				),
				(
					SELECT   COUNT(DISTINCT PositionParentId) as PositionNo
				     FROM    #SESSION.acc#Post#FileNo# P 
					 WHERE   P.OrgUnit = MainTable.OrgUnit 
					 AND     P.ParentOrgUnit != P.OrgUnit
					 AND     P.Class IN ('Used')
					         #preserveSingleQuotes(vDetailCondition)#
				),
				(
					SELECT  COUNT(DISTINCT PositionParentId) as PositionNo
				     FROM   #SESSION.acc#Post#FileNo# P
					 WHERE  P.OrgUnit = MainTable.OrgUnit
					 AND    Class IN ('Loaned') 
					        #preserveSingleQuotes(vDetailCondition)#
				),
				(
					SELECT COUNT(DISTINCT PersonNo) as PersonNo
				    FROM   userQuery.dbo.#SESSION.acc#Assignment#FileNo# A 
					WHERE A.PositionNo IN (SELECT PositionNo
					     				   FROM   #SESSION.acc#Post#FileNo# P
										   WHERE  P.OrgUnit = MainTable.OrgUnit
										   AND    Class IN ('Used','Floated')
											      #preserveSingleQuotes(vDetailCondition)#
											)
					AND  A.Incumbency != 0	
				)
	FROM      UserQuery.dbo.#SESSION.acc#Post#FileNo#_PreCalc MainTable
	
</cfquery>

<!--- </cfif> --->

