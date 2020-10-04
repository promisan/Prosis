
<cfoutput>

<script>

	function getContent(itm,doc,per,com,act,mde,usr,cls) {		
	   _cf_loadingtexthtml='';		  
		ptoken.navigate('#session.root#/Vactrack/Application/Candidate/Assessment/AssessmentViewEditContent.cfm?itm='+itm+'&documentno='+doc+'&personno='+per+'&competenceid='+com+'&actioncode='+act+'&mode='+mde+'&useraccount='+usr+'&modality='+cls,'box'+itm)	
	}

	function setcontent(itm,doc,per,com,act,usr) {	
	   updateTextArea();	  
	   ptoken.navigate('#session.root#/Vactrack/Application/Candidate/Assessment/setContent.cfm?itm='+itm+'&documentno='+doc+'&personno='+per+'&competenceid='+com+'&actioncode='+act+'&useraccount='+usr,'result_'+itm,'','','POST','textevaluation')		
	}
		
	function seteval(itm,doc,per,act,com,usr,frm,fld,mdl) {		    
		ptoken.navigate('#session.root#/Vactrack/Application/Candidate/Assessment/setAssessment.cfm?itm='+itm+'&documentno='+doc+'&personno='+per+'&actioncode='+act+'&competenceid='+com+'&useraccount='+usr+'&formfield='+frm+'&field='+fld+'&modality='+mdl,'result_'+itm,'','','POST','textevaluation')		
	}	
	
	function showquestion(doc,per,act,mde,cls) {
	    ptoken.open('#session.root#/Vactrack/Application/Candidate/Assessment/AssessmentViewContent.cfm?documentno='+doc+'&personno='+per+'&actioncode='+act+'&mode='+mde+'&modality='+cls,'qa'+doc)
	}
	
</script>

</cfoutput>