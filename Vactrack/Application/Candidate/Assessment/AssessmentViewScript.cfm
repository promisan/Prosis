<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<cfoutput>

<script>

	function getContent(itm,doc,per,com,act,mde,usr,cls) {		
	   _cf_loadingtexthtml='';		  
		ptoken.navigate('#session.root#/Vactrack/Application/Candidate/Interaction/AssessmentTestContent.cfm?itm='+itm+'&documentno='+doc+'&personno='+per+'&competenceid='+com+'&actioncode='+act+'&mode='+mde+'&useraccount='+usr+'&modality='+cls,'box'+itm)	
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