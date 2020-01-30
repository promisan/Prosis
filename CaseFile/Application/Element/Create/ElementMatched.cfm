
<!--- elements match to the entry screen --->

<cfquery name="TopicList" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  R.*
	     FROM    Ref_Topic R INNER JOIN Ref_TopicElementClass S ON R.Code = S.Code
		 WHERE   ElementClass = '#url.elementclass#'	
		 AND     Operational = 1
		 AND     TopicClass != 'Person'
		 AND     (Mission = '#url.Mission#' or Mission is NULL)		
		 AND     ValueClass != 'Memo'       	 
</cfquery>

<cfset FileNo = round(Rand()*100)>

<CF_DropTable dbName="AppsQuery"  tblName="tmp#SESSION.acc#ElementMatched_#fileno#"> 

<cfif url.elementclass eq "Person">	
	<cfset dateValue = "">
	<cfif form.dob neq ""> 
	    <CF_DateConvert Value="#Form.DOB#">
	    <cfset DOB = dateValue>
	</cfif>	
</cfif>

<cfoutput>

<cfsavecontent variable="myquery">
	SELECT  E.ElementId,
	        E.Reference,    
			
			(SELECT TOP 1 CaseElementId 
			 FROM   ClaimElement 
			 WHERE  ElementId = E.ElementId) as CaseElementId,
			
			<cfif url.elementclass eq "Person">
			
			    A.PersonNo,
				A.LastName,
				A.LastName2,
				A.FirstName,
				A.MiddleName,
				A.DOB,
				A.Gender,	
				
			<cfelse>				
							
			<cfloop query="TopicList">			
				<cfset fld = replace(description," ","","ALL")>
				<cfset fld = replace(fld,".","","ALL")>
				<cfset fld = replace(fld,",","","ALL")>
					(SELECT TopicValue 
					 FROM   ElementTopic 
					 WHERE  ElementId = E.ElementId 
					 AND    Topic = '#code#') as #fld#,						
			</cfloop>	
			
			</cfif>	
			
		    E.Created		
	INTO    userquery.dbo.tmp#SESSION.acc#ElementMatched_#fileno#			
	FROM    Element E 	       
			<cfif url.elementclass eq "Person">
			INNER JOIN Applicant.dbo.Applicant A ON E.PersonNo = A.PersonNo
			</cfif>	
			
	WHERE  ElementClass = '#url.elementclass#'		
		
	AND    E.Reference LIKE '#form.ElementReference#%' #CLIENT.Collation#
	
	<cfif url.elementclass eq "Person">	
	AND    A.LastName  LIKE '%#FORM.LastName#%' #CLIENT.Collation#
	AND    A.FirstName LIKE '%#Form.FirstName#%' #CLIENT.Collation#
	<cfif form.dob neq "">
	AND    A.DOB = #dob#
	</cfif>
		
	</cfif>
	
	<cfloop query = "TopicList">	
	
	      <cfparam name="FORM.Topic_#Code#" default="">
		  <cfset value  = Evaluate("FORM.Topic_#Code#")>								
		  <cfif value neq "">				
	
			AND    ElementId IN (
			
			                     SELECT ElementId 
				                 FROM   ElementTopic
								 WHERE  (
										   Topic = '#Code#' AND ( 
						                          CONVERT(VARCHAR,TopicValue) LIKE '%#value#%' #CLIENT.Collation# OR ListCode = '#value#') 
										)
							
						  ) 
						  
		  </cfif>
	
		   </cfloop>			  						  
		 	
</cfsavecontent>
</cfoutput>


<cftry>

<cfquery name="Matched" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">	
   #preservesinglequotes(myquery)#		 	
</cfquery>


<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
<tr><td colspan="3" height="200">
    <cfset url.fileno = fileno>
    <cfinclude template="ElementMatchedContent.cfm">
    </td>
</tr>

<tr>

<cfquery name="Listing" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT TOP 1 * 
	FROM userquery.dbo.tmp#SESSION.acc#ElementMatched_#url.fileno#
</cfquery>

<cfcatch>
	 <cfabort>
</cfcatch>

</cftry>

<cfif listing.recordcount gte "1">
			
	<tr><td colspan="3" class="line"></td></tr>
		
	<tr><td colspan="3" align="center" height="34">
				
		<cf_tl id="Add Selected Elements" var="1">
		
		<cfoutput>
	    <input type="button" 
			   name="Save" 
			   value="<cfoutput>#lt_text#</cfoutput>" 
			   class="button10g" 					   
			   onclick="addmatched('#url.caseelementid#')" 					  
			   style="width:240px">	
		</cfoutput>	   
		
	</td></tr>		

</cfif>	

