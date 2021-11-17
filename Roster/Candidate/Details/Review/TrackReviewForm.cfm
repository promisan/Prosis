
<CFOUTPUT>	

<script>

function selectall(chk) {

var count=1
while (count < 30) {
	
    se = document.getElementById("selected_"+count)
	if (se) {
	ln = document.getElementById("line"+count)
    
	if (chk == true) {
	     ln.className = "highLight2";
		 se.checked = true;
	} else {      
		 ln.className = "regular";
	     se.checked = false; 
	}		   
	}
    count++;
   }	
}

ie = document.all?1:0
ns4 = document.layers?1:0

function hl(itm,fld){

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 
	 	 		 	
	 if (fld != false){
		
	 itm.className = "highLight2";
	 }else{
		
     itm.className = "regular";		
	 }
  }

</script>
</CFOUTPUT>

<cf_assignid>

<cfquery name="Line" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM ApplicantReview
	WHERE ReviewId = '#rowguid#' 
</cfquery>

<cfquery name="Priority" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Priority	
</cfquery>

<cfquery name="Reference" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_ReviewClass
	WHERE Code = '#URL.reviewcode#' 
</cfquery>

<cfquery name="SearchResult" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT   A.Source AS Source, B.*, C.ExperienceId as CurrentAssigned
   FROM     ApplicantSubmission A INNER JOIN
            ApplicantBackground B ON A.ApplicantNo = B.ApplicantNo LEFT OUTER JOIN
            ApplicantReviewBackground C ON B.ExperienceId = C.ExperienceId 
					                  AND A.PersonNo = '#URL.PersonNo#'
	                                  AND   ReviewId = '#rowguid#'
   WHERE    A.ApplicantNo      = B.ApplicantNo
   AND      A.PersonNo         = '#URL.PersonNo#'
   AND      B.Status           <> '9' 	
   AND      ExperienceCategory = '#Reference.ExperienceCategory#'
   ORDER BY B.ExperienceStart DESC 
</cfquery>

<cf_screentop html="No" layout="webapp" height="100%" label="Request #Reference.Description# Review" scroll="yes">
	
	<cfform action="TrackReviewSubmit.cfm?reviewcode=#url.reviewcode#&personno=#url.personno#&documentno=#url.documentno#&reviewid=#rowguid#" 
	method="POST" target="result">
		
		<table width="99%" align="center" cellspacing="0" cellpadding="0">		
		<tr class="hide"><td><iframe name="result" id="result" width="100%" height="50"></iframe></td></tr>
		<tr><td>		
			<cfinclude template="BackgroundDetail.cfm">		
		</td></tr>		
		<cfif Searchresult.recordcount gte "1">
		<tr><td align="center" height="30" style="padding-bottom:10px">
			<input class="button10g" style="width:120px" value="Request" name="savecustom" type="submit">
		</td></tr>
		</cfif>		
		</table>	
	
	</cfform>

<cf_screenbottom layout="webapp">
