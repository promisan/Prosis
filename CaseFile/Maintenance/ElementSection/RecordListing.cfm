
<cfajaximport tags="cfform,cfdiv">

<script>

function recordadd() {
   ColdFusion.navigate('RecordListingDetail.cfm?code=new','listing')
}

function save(code) {

   document.mysection.onsubmit() 
	if( _CF_error_messages.length == 0 ) {
       	ColdFusion.navigate('RecordListingSubmit.cfm?code='+code,'listing','','','POST','mysection')
	 }  
	 
 }
 
function sectionedit(code) {
   ColdFusion.navigate('RecordListingDetail.cfm?code='+code,'listing');
}

</script> 

<cfset add          = "1">
<cfset Header       = "Award">
<cfinclude template = "../HeaderCaseFile.cfm"> 
	
<table width="100%" border="0" bordercolor="silver" cellspacing="0" cellpadding="0" align="center" >
  		
	<tr>
	
	    <td width="100%" id="listing">
		<cfinclude template="RecordListingDetail.cfm">
		</td>
		
	</tr>		
	<tr><td height="5"></td></tr>				

</table>	
				

