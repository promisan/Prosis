<!-- 
	PersonSearchListSubmit.cfm
	
	Called by ../Application/PersonSearchList.cfm
	
	Check if this person (that has been selected from the Person Search page, has already 
	been associated with current personnel request.
	If not, add this person to DocumentRotatingPerson table.
	
	Parameters:
		URL.ID	- DocumentNo (request no.)
		URL.ID1	- PersonNo
	
	Modification History:
	15Oct03 - adapted by MM from CandidateEntryListSubmit.cfm
	27Aug04 - modified check for rotating person to see if person is 'rotating' in any active request
	20Sep04 - modified check for rotating person to see if person is 'rotating' in any active request
	          and where the replacement for this rotating person has not been revoked or stalled.
	17Jan06 - modified check query to fix false positive problem, ie, erroneously reporting that a person
			  exists as a nominated person in another active request.
	15Oct12 - added the line "AND drr.DocumentNo= t1.DocumentNo" to the JOIN statement to ensure only 
	          relevant records are returned by the query
--->	

<!--- Check if this person is already associated with this request --->
<cfquery name="Check" datasource="#CLIENT.Datasource#"  username="#SESSION.login#" password="#SESSION.dbpw#">
<!---
	Logic: See if person being selected exists as a rotating person that is 
			associated with an active nominee in a Pending personnel request record.
	15Oct12 - added the line "AND drr.DocumentNo= t1.DocumentNo" to the JOIN statement to ensure only 
	       relevant records are returned by the query	
--->
	SELECT *
	FROM   DocumentRotatingPerson drr INNER JOIN
			( SELECT 	d.DocumentNo, drr1.PersonNo 
			  FROM   	DocumentRotatingPerson drr1 INNER JOIN 
						DocumentCandidate dc  ON drr1.DocumentNo = dc.DocumentNo AND drr1.ReplacementPersonNo = dc.PersonNo INNER JOIN
                      	Document d ON dc.DocumentNo = d.DocumentNo
			  WHERE 	dc.Status NOT IN ('6', '9') 
				AND 	d.Status = '0'
			) t1 ON drr.PersonNo = t1.PersonNo 
			    AND drr.DocumentNo= t1.DocumentNo
	WHERE	drr.PersonNo = '#URL.ID1#' 
</cfquery>

<!-- If this deployed person has not been associated to this request, proceed... -->
<cfif Check.recordCount GT 0>

	<cfoutput>
	<script language="JavaScript">
		alert("The individual is already in request number #Check.DocumentNo#. An individual may not be identified as rotating in multiple requests.");
		window.close() ;
	</script>
	</cfoutput>
	
	<cfexit method="EXITTEMPLATE">
	
<cfelse>	
 
	<!-- Get info about the nominee from Person table -->
	<cfquery name="Get" datasource="AppsEmployee"  username="#SESSION.login#" password="#SESSION.dbpw#">
	  	SELECT *  FROM   Person
  		WHERE  PersonNo = '#URL.ID1#'
 	</cfquery>
 
	<!--- record reference in DocumentRotatingPerson link table --->
   	<cfquery name="InsertCandidate" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
  	INSERT INTO DocumentRotatingPerson
         (DocumentNo,
		 PersonNo,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
  	VALUES ('#URL.ID#',
          '#URL.ID1#',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#',
		  '#DateFormat(Now(),"mm/dd/yyyy")#')
  	</cfquery>	    
</cfif>
  
<script language="JavaScript">
   window.close()
   opener.location.reload()
</script>