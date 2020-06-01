
<cfinvoke component="Service.Access"  
 method="roster" 
 returnvariable="AccessRoster"
 role="'AdminRoster','CandidateProfile'">

<cfparam name="URL.ID2" default="">
<cfparam name="URL.source" default="">

<cfajaximport tags="cfform">
 
<cfoutput>

 <script language="JavaScript">
 
 function reload(src) {
     Prosis.busy('yes')
     ptoken.navigate('Assessment/Assessment.cfm?source='+src+'&Owner=#url.owner#&ID=#url.id#','assessment')
  }
 
 function load() {
 	 ptoken.navigate('Assessment/Assessment.cfm?id2=edit&source=#url.source#&Owner=#url.owner#&ID=#url.id#','assessment')
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
	
	 if (fld != false) {
		 itm.className = "highLight4";
	 } else { 
	     itm.className = "header"; 
	 }
	
  }
  
</script>	

</cfoutput>

<table width="100%" cellspacing="0" cellpadding="0">
	
	<cf_FileLibraryScript>
	
	<cfoutput>
	
		<script>
			function importpdf(file) {
				<cf_tl id="Do you want to upload the PDF submitted information" var="1">
			  if (confirm("#lt_text#?")) {
			  src = document.getElementById("sourcesel").value
			  ptoken.navigate('Assessment/AssessmentDetail.cfm?source='+src+'&id2=edit&Owner=#URL.Owner#&ID=#URL.ID#&pdfform='+file,'assessment') 
			  }
			}
		</script>
		
	</cfoutput>
		
	<cfif AccessRoster eq "EDIT" or AccessRoster eq "ALL"> 
	
		<tr>
			<td>
			<cf_securediv bind="url:Assessment/AssessmentDetail.cfm?source=#url.source#&id2=edit&Owner=#URL.Owner#&ID=#URL.ID#" id="assessment"/>	
			</td>
		</tr>
	
	</cfif>	

</table>