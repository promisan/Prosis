<!--- steps 

1.	Input

Period
Fund
From version 
To version

2. Select all EditionId with combination

Fund
From version

SELECT *
FROM Ref_AllotmentEdition
WHERE Fund = 'fund'
AND Version = 'version'
and EditionClass = 'budget'

3. loop through selection and check if combination

Fund
To version
Period
Class = budget
(Description) exists

4a. if not, add a record to ref_allotmentEdit
4b. if yes, clean current entries in programAllotment for editions and period

5. generate a from - to list

SELECT    Old.EditionId AS EditionIdOld, New.EditionId AS EditionIdNew
FROM      Ref_AllotmentEdition Old INNER JOIN
          Ref_AllotmentEdition New ON Old.Fund = New.Fund AND Old.Period = New.Period AND Old.EditionClass = New.EditionClass
WHERE     (Old.Version = 'Initial') AND (New.Version = 'Second')

6. Run copy statement for the editions and preparation period

--->

<cfparam name="URL.VersionFrom" default="Initial">
<cfparam name="URL.VersionTo" default="Second">
<cfparam name="URL.Fund" default="GOV">

<cfset VersionFrom = URL.VersionFrom>
<cfset VersionTo   = URL.VersionTo>
<cfset Fd = URL.Fund>

<cfquery name="Edition" 
 datasource="AppsProgram" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT  *
 FROM    Ref_AllotmentEdition
 WHERE   Fund         = '#fd#' 
 AND     Version      = '#versionFrom#' 
 AND     EditionClass = 'Budget'
</cfquery>

<cfloop query="Edition">

	<cfquery name="Check" 
	 datasource="AppsProgram" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT  *
	 FROM    Ref_AllotmentEdition
	 WHERE   Fund         = '#fd#' 
	 AND     Version      = '#versionTo#' 
	 AND     EditionClass = 'Budget'
	 AND     Period       = '#Period#'
	</cfquery>
	
	<cfif check.recordcount eq "0">
	
	  <cfquery name="Insert" 
	   datasource="AppsProgram" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		INSERT INTO Ref_AllotmentEdition
               (Fund, 
			    Period, 
				Version, 
			    EditionClass, 
				Description,
				OfficerUserId, 
				OfficerLastName, 
				OfficerFirstName)
		VALUES ('#fd#',
	            '#period#',
				'#versionTo#',
				'Budget',
				'#Description#',
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#')
	  </cfquery>
	  
	<cfelse>
	
	<!--- clean entries --->
	
	 <cfquery name="Delete" 
	   datasource="AppsProgram" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   DELETE FROM ProgramAllotment
 	   WHERE     EditionId = '#Check.EditionId#'  
	 </cfquery>  
		
	</cfif>

</cfloop> 

<!--- add ProgramAllotment --->
<cfquery name="AddAllotment" 
	   datasource="AppsProgram" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	INSERT INTO ProgramAllotment
		       (ProgramCode,
			    Period,
				EditionId,
				Description,
				Status,				
				OfficerUserId,
				OfficerLastName,
				OfficerFirstName)
	SELECT     PA.ProgramCode, 
	           PA.Period, 
			   New.EditionId, 
			   PA.Description, 
			   '0', 			  
			   '#SESSION.acc#',
			   '#SESSION.last#',
			   '#SESSION.first#'
	FROM      Ref_AllotmentEdition Old INNER JOIN
	          Ref_AllotmentEdition New ON Old.Fund = New.Fund AND Old.Period = New.Period AND Old.EditionClass = New.EditionClass INNER JOIN
	          ProgramAllotment PA ON Old.EditionId = PA.EditionId
	WHERE     Old.Version = '#VersionFrom#' 
	AND       New.Version = '#VersionTo#'
</cfquery>

<!--- issue provision to adjust the exchange rate if needed --->

<!--- add ProgramAllotment --->
<cfquery name="AddAllotment" 
  datasource="AppsProgram" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  INSERT INTO ProgramAllotmentDetail
		      (ProgramCode,
			   Period,
			   EditionId,
			   TransactionDate,
			   Currency,
			   Amount,
			   ExchangeRate,
			   AmountBase,
			   ObjectCode,
			   Fund,
			   Status,
			   OfficerUserId,
			   OfficerLastName,
			   OfficerFirstName)
  SELECT     PAD.ProgramCode, 
	         PAD.Period, 
			 New.EditionId, 
			 getDate(), 
			 PAD.Currency, 
			 PAD.Amount, 
			 PAD.ExchangeRate, 
			 PAD.AmountBase, 
             PAD.ObjectCode, 
			 PAD.Fund, 
			 '0',
			 '#SESSION.acc#',
			 '#SESSION.last#',
			 '#SESSION.first#'
	FROM     Ref_AllotmentEdition Old INNER JOIN
	         Ref_AllotmentEdition New ON Old.Fund = New.Fund AND Old.Period = New.Period AND Old.EditionClass = New.EditionClass INNER JOIN
	         ProgramAllotmentDetail PAD ON Old.EditionId = PAD.EditionId
	WHERE    Old.Version = '#VersionFrom#' 
	AND      New.Version = '#VersionTo#'
</cfquery>

completed
<!--- completed --->

