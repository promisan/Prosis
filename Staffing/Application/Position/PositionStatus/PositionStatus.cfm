
<cfquery name="Org" 
 datasource="AppsOrganization" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT    *
	 FROM      Organization 
	 WHERE     OrgUnit = '#URL.OrgUnit#'  
</cfquery>

<cfquery name="Mandate" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	   FROM Ref_Mandate
	   WHERE Mission = '#Org.Mission#'
	   AND MandateNo = '#Org.MandateNo#' 
</cfquery>

<cfquery name="PostGroup" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DISTINCT PostClassGroup
	FROM Ref_PostClass
	WHERE PostClass IN (SELECT PostClass FROM Position WHERE Mission = '#org.mission#' and mandateNo = '#org.mandateNo#')
</cfquery>

<cfset PostGroups = "#ValueList(PostGroup.PostClassGroup)#,Borrowed">
            
<cfquery name="Funds" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT Code
		FROM Ref_Fund
	   Where ControlView = 1
	   Order by ListingOrder
</cfquery>

<cfset Funds = "'"& '#ValueList(Funds.Code,"','")#'&"'">

<cfif Mandate.DateExpiration lt now() >
       <CF_DateConvert Value="#DateFormat(Mandate.DateExpiration,CLIENT.DateFormatShow)#">
<cfelseif Mandate.DateEffective gt now()>   
       <CF_DateConvert Value="#DateFormat(Mandate.DateEffective,CLIENT.DateFormatShow)#">
<cfelse> 
 	   <CF_DateConvert Value="#DateFormat(now(),CLIENT.DateFormatShow)#">
</cfif>
	
<cfset sel       = dateValue>

<cf_OrganizationSelect
       Enforce     = "1"
	   OrgUnit     = "#URL.Orgunit#">  	 
	   
	   
<cfset FileNo = round(Rand()*100)>

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#AuthPost#FileNo#">		

<cftransaction isolation="READ_UNCOMMITTED">   	      

<cfquery name="AuthPosts" 
 datasource="AppsEmployee" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT    P.PositionNo,
	 		   P.PostAuthorised, 
	 		   R.PostClassGroup as PostClass,		
	 		   Case WHEN PP.Fund not in (#PreserveSingleQuotes(Funds)#) THEN 'Other'
			   	    ELSE PP.Fund
			   END as Fund,
			   P.OrgUnitOperational as OrgUnit,
			   PP.OrgUnitOperational as ParentOrgUnit,
			   CASE WHEN P.OrgUnitOperational != PP.OrgUnitOperational THEN 'LOANED'
			   	    ELSE 'OWNED'
			   END as Class		
	 INTO      userQuery.dbo.#SESSION.acc#AuthPost#FileNo#	   			   
	 FROM      Position P INNER JOIN
	           PositionParent PP ON P.PositionParentId = PP.PositionParentId
			   LEFT JOIN Ref_PostClass R
			   	ON P.PostClass = R.PostClass
	 WHERE     PP.Mission   = '#Org.Mission#'
	 AND       PP.MandateNo = '#Org.MandateNo#' 
	 AND       PP.OrgUnitOperational IN
	                          (SELECT    OrgUnit
	                            FROM     Organization.dbo.Organization
	                            WHERE    Mission       =  '#Org.Mission#' 
								AND      MandateNo     =  '#Org.MandateNo#'
								<cfif url.mde eq "">
								AND      HierarchyCode = '#HStart#' 
								<cfelse>
								AND      HierarchyCode >= '#HStart#'  
							    AND      HierarchyCode < '#HEnd#'
								</cfif>)
	AND        P.DateExpiration >= #sel#  
	AND        P.DateEffective <= #sel# 	
UNION ALL
	 SELECT    P.PositionNo, 
	 	       P.PostAuthorised, 
	 		   'Borrowed' as PostClass,		
	 		   Case WHEN PP.Fund not in (#PreserveSingleQuotes(Funds)#) THEN 'Other'
			   	    ELSE PP.Fund
			   END as Fund,
			   P.OrgUnitOperational as OrgUnit,
			   PP.OrgUnitOperational as ParentOrgUnit,
			   'BORROWED' as Class
	 FROM      Position P INNER JOIN PositionParent PP 
	 				ON P.PositionParentId = PP.PositionParentId AND
						P.OrgUnitOperational != PP.OrgUnitOperational			   
	 WHERE     P.OrgUnitOperational IN
	                          (SELECT    OrgUnit
	                            FROM     Organization.dbo.Organization
	                            WHERE    Mission       =  '#Org.Mission#' 
								AND      MandateNo     =  '#Org.MandateNo#'
								<cfif url.mde eq "">
								AND      HierarchyCode = '#HStart#' 
								<cfelse>
								AND      HierarchyCode >= '#HStart#'  
							    AND      HierarchyCode < '#HEnd#'
								</cfif>)
	AND        P.DateExpiration >= #sel#  
	AND        P.DateEffective <= #sel# 				
</cfquery>

</cftransaction>  

<cfquery name="AllPosts" 
 datasource="AppsEmployee" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT *  FROM userQuery.dbo.#SESSION.acc#AuthPost#FileNo#
 </cfquery>

<cfquery name="Post" dbtype="query">
SELECT PostAuthorised, PostClass, Fund, Count(*) as Total
FROM AllPosts
GROUP BY PostAuthorised, PostClass, Fund
ORDER BY PostAuthorised, PostClass, Fund      
</cfquery>

<cfquery name="Loaned" dbtype="query">
	SELECT PostAuthorised, Fund, Count(*) as Total
	FROM AllPosts
	WHERE Class = 'LOANED'
	GROUP BY PostAuthorised, Fund
	ORDER BY PostAuthorised, Fund      
</cfquery>

<cfquery name="AllIncum" 
 datasource="AppsEmployee" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT     * 
	FROM userQuery.dbo.#SESSION.acc#AuthPost#FileNo# 
	WHERE Class != 'LOANED'
	AND   PositionNo IN
	                  (SELECT   PositionNo
	                   FROM     PersonAssignment
					   WHERE    AssignmentStatus IN ('0','1')
	                   AND      DateEffective <= #sel# AND DateExpiration >= #sel#
					   AND 		Incumbency = 100)
</cfquery>

<cfquery name="Incum" dbtype="query">
SELECT PostAuthorised, PostClass, Fund, Count(*) as Total
FROM AllIncum
GROUP BY PostAuthorised, PostClass, Fund
ORDER BY PostAuthorised, PostClass, Fund      
</cfquery>

<cfquery name="AllVacant" 
 datasource="AppsEmployee" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT     * 
	FROM userQuery.dbo.#SESSION.acc#AuthPost#FileNo# 
	WHERE Class != 'LOANED'
	AND   PositionNo NOT IN
	                  (SELECT   PositionNo
	                   FROM     PersonAssignment
					   WHERE    AssignmentStatus IN ('0','1')
	                   AND      DateEffective <= #sel# AND DateExpiration >= #sel#
					   AND 		Incumbency = 100)
</cfquery>

<cfquery name="Vacant" dbtype="query">
Select PostAuthorised, PostClass, Fund, Count(*) as Total
FROM AllVacant
GROUP BY PostAuthorised, PostClass, Fund
ORDER BY PostAuthorised, PostClass, Fund      
</cfquery>
	 
<cfquery name="FUND" dbtype="query">
	Select Fund
	FROM AllPosts
		Union Select Fund
	FROM AllIncum
</cfquery>

<cfoutput>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">

 <tr><td height="4"></td></tr>
 
<cfset groupLen = ListLen(PostGroups)+1>	<!--- 1 is the total --->
<cfset span = GroupLen*3+1>				<!--- 3 subgroups (posts, incum, vacant), 1 Loaned posts --->

<tr>
<td rowspan="2" class="labelit" style="border:1px solid silver;padding:2px;padding-left:5px"><cf_tl id="fund"></td>
<cfloop index="PostClass" list="#PostGroups#">
	<td colspan="3" class="labelit" align="center" style="border:1px solid silver;padding:2px">#PostClass#</td>
</cfloop>
    <td class="labelit" align="center" style="border:1px solid silver;padding:2px"><cf_tl id="Loanded"></td>
    <td class="labelit" align="center" colspan="3" style="border:1px solid silver;padding:2px"><cf_tl id="Total"></td>
</tr>

<tr>
<cfloop index="ix" list="#PostGroups#">
	<td width="100" bgcolor="ffffaf" align="right" style="border:1px solid silver;padding:2px">P</td>
	<td width="100" bgcolor="fafafa" align="right" style="border:1px solid silver;padding:2px">I</td>
	<td width="100" bgcolor="fafafa" align="right" style="border:1px solid silver;padding:2px">V</td>
</cfloop>
<!--- loaned --->
	<td width="100" bgcolor="e1e1e1" align="right" style="border:1px solid silver;padding:2px">P</td>
<!--- Total --->
	<td width="100" bgcolor="ffffaf" align="right" style="border:1px solid silver;padding:2px">P</td>
	<td width="100" bgcolor="fafafa" align="right" style="border:1px solid silver;padding:2px">I</td>
	<td width="100" bgcolor="fafafa" align="right" style="border:1px solid silver;padding:2px">V</td>
</tr>

<cfloop index="aut" list="1">

	<tr><td bgcolor="<cfif aut eq "0">fffaaa<cfelse>D8EEFC</cfif>" colspan="#span+1#" align="center" class="labelit">
		<cfif aut eq "1">
			<cf_tl id="Authorised">
		<cfelse>
		    <cf_tl id="Not Authorised">
		</cfif>
		</td>
	</tr>

	<cfloop query="fund">
	
	<cfif Fund neq "">

	<tr><td width="100" class="labelit" align="right" style="padding:2px;padding-left:5px">#Fund#</td>
	
		<cfset fd = Fund>
	
		<cfloop index="PostClass" list="#PostGroups#">
		
			<td width="100" class="labelit" align="right" style="border:1px solid silver;padding:2px" <!---bgcolor="#PresentationColor#"> ---> >	
				<cfquery name="Pst" dbtype="query">
				SELECT sum(Total) as Total
				FROM  Post
				WHERE PostAuthorised = '#aut#'
				AND   PostClass = '#PostClass#'
				AND   Fund      = '#fd#'
				</cfquery>	
				#Pst.Total#		
			</td>
			
			<td width="100" class="labelit" align="right" style="border:1px solid silver;padding:2px" <!---bgcolor="#PresentationColor#"> ---> >		    
				<cfquery name="Inc" dbtype="query">
				SELECT sum(Total) as Total
				FROM   Incum
				WHERE  PostAuthorised = '#aut#'
				AND    PostClass = '#PostClass#'
				AND    Fund      = '#fd#'
				</cfquery>	
				#Inc.Total#						
			</td>

			<td width="100" class="labelit" align="right" style="border:1px solid silver;padding:2px" <!---bgcolor="#PresentationColor#"> ---> >		    
		
				<cfquery name="Vac" dbtype="query">
				SELECT sum(Total) as Total
				FROM   Vacant
				WHERE  PostAuthorised = '#aut#'
				AND    PostClass = '#PostClass#'
				AND    Fund      = '#fd#'
				</cfquery>	
				#Vac.Total#			
		
			</td>

		</cfloop>
		
		<!--- loaned --->
		<td width="100" class="labelit" align="right" style="border:1px solid silver;padding:2px">		    
			<cfquery name="Pst" dbtype="query">
			SELECT sum(Total) as Total
			FROM  Loaned
			WHERE PostAuthorised = '#aut#'
			AND   Fund      = '#fd#'
			</cfquery>	
			#Pst.Total#
		</td>

		<td width="100" class="labelit" bgcolor="f4f4f4" align="right" style="border:1px solid silver;padding:2px">		   
			<cfquery name="Pst" dbtype="query">
			SELECT sum(Total) as Total
			FROM  Post
			WHERE PostAuthorised = '#aut#'
			AND   Fund      = '#fd#'
			</cfquery>	
			#Pst.Total#			
		</td>
			
		<td width="100" class="labelit" bgcolor="f4f4f4" align="right" style="border:1px solid silver;padding:2px">			
			<cfquery name="Inc" dbtype="query">
			SELECT sum(Total) as Total
			FROM   Incum
			WHERE  PostAuthorised = '#aut#'
			AND    Fund      = '#fd#'
			</cfquery>	
			#Inc.Total#						
		</td>	
		
		<td width="100" class="labelit" bgcolor="f4f4f4" align="right" style="border:1px solid silver;padding:2px">			

			<cfquery name="Vac" dbtype="query">
			SELECT sum(Total) as Total
			FROM   Vacant
			WHERE  PostAuthorised = '#aut#'
			AND    Fund      = '#fd#'
			</cfquery>	
			#Vac.Total#						
		
		</td>	

	</tr>
	
	</cfif>
	
	</cfloop>
	
</cfloop>

	<tr class="labelit" bgcolor="eaeaea"><td width="100" class="labelit">&nbsp;&nbsp;&nbsp;&nbsp;Total</td>
	
	<cfloop index="PostClass" list="#PostGroups#">
	
			<td width="100" class="labelit" align="right" style="border:1px solid silver;padding:2px">		    
				<cfquery name="Pst" dbtype="query">
				SELECT sum(Total) as Total
				FROM  Post
				WHERE PostClass = '#PostClass#'			
				</cfquery>	
				#Pst.Total#			
			</td>
			
			<td width="100" class="labelit" align="right" style="border:1px solid silver;padding:2px">			
				<cfquery name="Inc" dbtype="query">
				SELECT sum(Total) as Total
				FROM   Incum
				WHERE  PostClass = '#PostClass#'			
				</cfquery>	
				#Inc.Total#						
			</td>

			<td width="100" class="labelit" align="right" style="border:1px solid silver;padding:2px">
				<cfquery name="Vac" dbtype="query">
				SELECT sum(Total) as Total
				FROM   Vacant
				WHERE  PostClass = '#PostClass#'			
				</cfquery>	
				#Vac.Total#			
			</td>

		</cfloop>	

		<!--- loaned	--->	    		
		<td width="100" class="labelit" align="right" style="border:1px solid silver;padding:2px">
				<cfquery name="Pst" dbtype="query">
				SELECT sum(Total) as Total
				FROM  Loaned
				</cfquery>	
				#Pst.Total#
		</td>

		<td width="100" class="labelit" align="right" style="border:1px solid silver;padding:2px">		    
			<cfquery name="Pst" dbtype="query">
			SELECT sum(Total) as Total
			FROM  Post			
			</cfquery>	
			#Pst.Total#			
		</td>
			
		<td width="100" class="labelit" align="right" style="border:1px solid silver;padding:2px">			
			<cfquery name="Inc" dbtype="query">
			SELECT sum(Total) as Total
			FROM   Incum
			</cfquery>	
			#Inc.Total#						
		</td>	
			
		<td width="100" class="labelit" align="right" style="border:1px solid silver;padding:2px">
			<cfquery name="Vac" dbtype="query">
			SELECT sum(Total) as Total
			FROM   Vacant
			</cfquery>	
			#Vac.Total#			
		</td>	

	 </tr>	
	 
	 <tr><td height="4"></td></tr>
</table>
</cfoutput>