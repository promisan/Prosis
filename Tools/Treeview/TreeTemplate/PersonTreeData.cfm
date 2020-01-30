
<cfoutput>

['Gender','ResultListing.cfm?ID=GEN&ID1=#URL.ID1#&ID2=B&ID3=GEN', 

['<u>Male</u>','ResultListing.cfm?ID=GEN&ID1=#URL.ID1#&ID2=M&ID3=NONE'],

['<u>Female</u>','ResultListing.cfm?ID=GEN&ID1=#URL.ID1#&ID2=F&ID3=NONE']],

['Region','ResultListing.cfm?ID=CON&ID1=#URL.ID1#&ID2=all&ID3=CON', 

<cfquery name="Region" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT DISTINCT N.Continent
  FROM PersonSearchResult R, Person A, System.dbo.Ref_Nation N
  WHERE R.PersonNo = A.PersonNo
  AND A.Nationality = N.Code
  AND R.SearchId = #URL.ID1#
</cfquery>

<cfloop query = "Region">
 
  <cfset #Continent# = #Region.Continent#>

  ['#Continent#','ResultListing.cfm?ID=CON&ID1=#URL.ID1#&ID2=#Continent#&ID3=COU',
  
  <cfquery name="Country" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT DISTINCT N.Name, N.Code
  FROM PersonSearchResult R, Person A, System.dbo.Ref_Nation N
  WHERE R.PersonNo = A.PersonNo
  AND A.Nationality = N.Code
  AND N.Continent = '#Continent#'
  AND R.SearchId = #URL.ID1#
   
</cfquery>

  <cfloop query="Country">

  ['#Name#','ResultListing.cfm?ID=COU&ID1=#URL.ID1#&ID2=#Code#&ID3=NONE'],
  
  </cfloop>],
  
  </cfloop>]

  
</cfoutput>


