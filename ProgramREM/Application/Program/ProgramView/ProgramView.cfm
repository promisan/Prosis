
<cfparam name="URL.Programid"   default="">	
<cfparam name="URL.ProgramCode" default="">	
<cfparam name="URL.Period"      default=""> 
<cfparam name="URL.ProgramName" default="">	
<cfparam name="URL.AuditId"     default="">	
<cfparam name="URL.scope"       default="Backend">	

<cfset CLIENT.Sort = "OrgUnit">

<cfoutput>

 <cf_LanguageInput
	TableCode       = "Ref_ModuleControl" 
	Mode            = "get"
	Name            = "FunctionName"
	Key1Value       = "#url.SystemFunctionId#"
	Key2Value       = "#url.mission#"					
	Label           = "Yes">
					
<cf_screenTop height="100%" 
    title="#lt_content# #URL.Mission#" 	
	border="0" 
	html="No" 
	jQuery="Yes"
	validateSession="Yes"
	TreeTemplate="Yes"
	MenuAccess="Yes"
	scroll="no">		
		
<cf_layoutscript>	

<cf_ObjectControls>

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>	

<cf_layout attributeCollection="#attrib#">			
	
	<cfif url.scope neq "Portal">
		<cf_layoutarea 
		    position="top"
		    name="controltop"	      
		    splitter="true"
			overflow = "hidden">		
				
			 <cfinclude template="ProgramMenu.cfm">
					 
		</cf_layoutarea>	
	</cfif>
		
	<cfoutput>
		
		<script language="JavaScript">
		
		function searchgo() {		
			window.open('#client.virtualdir#/ProgramREM/Inquiry/LocateProgram/InquiryForm.cfm?mission=#url.mission#&period='+document.getElementById('PeriodSelect').value,'right')		
		}
			
		function view(val) {
	
			count = 1		
			while (count != 10) {		
		      try {	
			  se = document.getElementById('viewmode'+count)	
			  se.style.fontWeight='normal' 
			  } catch(e) {}
			  count++		  
			}
			document.getElementById('viewmode'+val).style.fontWeight='bold'		
			    
		}
		
		function refreshListing() {
		
			if (treeselect.value != "") {
										
				parent.right.ptoken.location("#session.root#/ProgramREM/Application/Program/ProgramView/ProgramViewGeneral.cfm?Period=" + document.getElementById("PeriodSelect").value + 
	                     "&Mode=" + document.getElementById("Mode").value +
	                     "&ProgramGroup="   + document.getElementById("ProgramGroup").value +
						 "&ReviewCycleId="  + document.getElementById("CycleId").value +
						 "&ProgramClass="   + document.getElementById("ProgramClass").value +
						 "&" + treeselect.value)
						}						
			}		
				
		
		function updatePeriod(per,mandate,enforce) {		
			
			document.getElementById('reviewcontent').className = "regular"						
			document.getElementById("PeriodSelect").value = per		
			_cf_loadingtexthtml='';	
			ptoken.navigate('#session.root#/ProgramREM/Application/Program/ProgramView/ProgramViewTreeCycle.cfm?mission=#URL.Mission#&period='+per,'reviewcontent')								   	   
			_cf_loadingtexthtml="<div><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy11.gif'/>";	
			if ((mandate != document.getElementById("MandateNo").value) || enforce == 1) {				
			   // refresh the tree to be shown, effectively we also have to tune the filtering !!!
			   ptoken.navigate('#session.root#/ProgramREM/Application/Program/ProgramView/ProgramViewTreeContent.cfm?systemfunctionid=#url.systemfunctionid#&mission=#URL.Mission#&mandate='+mandate+'&period='+per,'treecontent')						  		      		
			} else {   		   	
				if (treeselect.value != "") {	
			      right.document.location ="#session.root#/ProgramREM/Application/Program/ProgramView/ProgramViewGeneral.cfm?Period=" + document.getElementById("PeriodSelect").value + 
	                     "&Mode=" + document.getElementById("Mode").value +
	                     "&ProgramGroup=" + document.getElementById("ProgramGroup").value +
						 "&ProgramClass=" + document.getElementById("ProgramClass").value +
						 "&ReviewCycleId=" +
						 "&" + treeselect.value
				}		 
			
			}			
			document.getElementById("MandateNo").value = mandate
			
		   }
		
		function updateDonor() {		
		       document.getElementById('reviewcontent').className = "hide"
			   // refresh the tree to be shown, effectively we also have to tune the filtering !!!
			   ptoken.navigate('#session.root#/ProgramREM/Application/Program/Donor/DonorTreeContent.cfm?systemfunctionid=#url.systemfunctionid#&mission=#URL.Mission#','treecontent')				
		}
		
		</script>
	
	</cfoutput>
		
	<cf_layoutarea  position="left" name="treebox" maxsize="350" size="350" collapsible="true" splitter="true">	
		<cf_divScroll>					
		    <cfinclude template="ProgramViewTree.cfm">		
		</cf_divScroll>
	</cf_layoutarea>
	
	<cf_layoutarea  position="center" name="box" overflow="hidden">		

		<cfset vInitSrc = "#SESSION.root#/Tools/Treeview/TreeViewInit.cfm">
		<cfif url.scope neq "Backend">
			<cfset vInitSrc = "">
		</cfif>
	
		<iframe name="right" id="right" width="100%" height="100%" scrolling="no" src="#vInitSrc#"
		    frameborder="0"></iframe>			
				
	</cf_layoutarea>				
			
</cf_layout>

</cfoutput>
