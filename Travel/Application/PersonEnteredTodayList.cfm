<!---
	PersonEnteredTodayList.cfm
	
	List persons that have been entered today.
	
	Records appear in the Entered Persons section of the PersonEntry page
	(personentry.cfm).
	
	Called by: PersonEntry.cfm
	
	Modification History:
	20Oct03 - created by MM
--->
<!---
<cfparam name="codate" 
		 type="date" 
		 default="#Dateformat(now(), CLIENT.DateFormatShow)#">
--->
<cfset codate = now()>		 


<cfset select = "spPersonsEnteredToday">

<cfstoredproc procedure="#select#" 
 datasource="#CLIENT.Datasource#" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">

<!---
   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" 	dbvarname="@USERID"  	  	value="#SESSION.acc#" 	null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_DATE" dbvarname="@CUTOFFDATE" value="#URL.CutOff#" null="No">
--->   
   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" 	dbvarname="@USERID"  	  	value="#SESSION.acc#" 	null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_DATE" 		dbvarname="@CUTOFFDATE" 	value="#codate#" 		null="No">   

   <cfprocresult name="SearchResult" resultset="1"> 
   
</cfstoredproc>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#111111" style="border-collapse: collapse">

	<!-- print row title -->
    <tr>
<!--    	  <td class="top2"></td> -->
   	  <td class="top2">&nbsp;Count</td>
      <td class="top2">FirstName</td>
      <td class="top2">LastName</td>
	  <td class="top2">Nat.</td>
      <td class="top2">Gender</td>
   	  <td class="top2">DOB</td>
   	  <td class="top2">Rank</td>
	  <td class="top2">Category</td>
  	  <td class="top2">&nbsp;</td>
  	  <td class="top2">Entered</td>	  
     </tr>	
	 
	<!-- print person records -->	 
	<cfoutput query="SearchResult">	

	<tr bgcolor="#IIf(SearchResult.CurrentRow Mod 2, DE('ffffff'), DE('f5f5f5'))#">
<!--- 		<td class="regular">
		<button class="button3" onClick="javascript:showdocumentcandidate('#qPerson.DocumentNo#','#qPerson.PersonNo#')">
		<img src="../../Images/function.JPG" alt="" width="18" height="15" border="0">
		</button>
		</td>
 --->
 		<td class="regular">&nbsp;&nbsp;#SearchResult.CurrentRow#</td>
	    <td class="regular">#SearchResult.FirstName#</td>
		<td class="regular">#SearchResult.LastName#</td>
		<td class="regular">#SearchResult.Nationality#</td>
		<td class="regular">#SearchResult.Gender#</td>		
		<td class="regular">#Dateformat(SearchResult.BirthDate, CLIENT.DateFormatShow)#</td>
		<td class="regular">#SearchResult.vRank#</td>
		<td class="regular">#Category#</td>
		<td class="regular">&nbsp;</td>		
		<td class="regular">#Dateformat(SearchResult.Created, CLIENT.DateFormatShow)#</td>
		
		<!--- link for cancelling, ie, deleting a record 
		<td>	
		<button class="button3" onClick="javascript:cancel('#qPerson.DocumentNo#','#qPerson.PersonNo#')">
	   	&nbsp;<u>cancel</u>
    	</button>
		</td>	
		--->
	</tr>
	</cfoutput>	
</table>