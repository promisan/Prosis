
<cfoutput>

<script>

	function getContent(itm,doc,per,com,act,mde,usr) {		
	   _cf_loadingtexthtml='';		  
		ptoken.navigate('#session.root#/Vactrack/Application/Candidate/Assessment/AssessmentViewEditContent.cfm?itm='+itm+'&documentno='+doc+'&personno='+per+'&competenceid='+com+'&actioncode='+act+'&mode='+mde+'&useraccount='+usr,'box'+itm)	
	}

	function setcontent(itm,doc,per,com,act,usr) {	
	   updateTextArea();	  
	   ptoken.navigate('#session.root#/Vactrack/Application/Candidate/Assessment/setContent.cfm?itm='+itm+'&documentno='+doc+'&personno='+per+'&competenceid='+com+'&actioncode='+act+'&useraccount='+usr,'result_'+itm,'','','POST','textevaluation')		
	}
		
	function seteval(itm,doc,per,act,com,usr,frm,fld) {		    
		ptoken.navigate('#session.root#/Vactrack/Application/Candidate/Assessment/setAssessment.cfm?itm='+itm+'&documentno='+doc+'&personno='+per+'&actioncode='+act+'&competenceid='+com+'&useraccount='+usr+'&formfield='+frm+'&field='+fld,'result_'+itm,'','','POST','textevaluation')		
	}	
	
	function showquestion(doc,per,act,mde) {
	    ptoken.open('#session.root#/Vactrack/Application/Candidate/Assessment/AssessmentViewContent.cfm?documentno='+doc+'&personno='+per+'&actioncode='+act+'&mode='+mde,'qa'+doc)
	}
	
</script>

</cfoutput>