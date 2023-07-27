
<cf_tl id="Process Requisitions" var="1">
<cfset vReq060=lt_text>

<cf_screentop height="100%" line="no" html="yes" layout="webapp"
		systemmodule="Procurement" 
		functionclass="Window" 
		functionName="Job Create" 
		jquery="Yes" 
		label="#vReq060#" 
		scroll="yes"
		banner="red">

<cfajaximport tags="cfform">

<cf_DialogProcurement>
<cf_DialogStaffing>
<cf_DialogMaterial>
<cf_DialogPosition>
<cf_dialogOrganization>
<cf_AnnotationScript>

<cfquery name="Parameter" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT *
      FROM   Ref_ParameterMission
	  WHERE  Mission = '#URL.Mission#'
</cfquery>

<cfparam name="URL.Period" default="#Parameter.DefaultPeriod#">
<cfparam name="URL.Selected" default="">

<cfoutput>
	
	<script language="JavaScript">
		
	function facttablexls1(control,format,box) {  
	    // here I could capture the client variable if this is better for large selections 
		ColdFusion.navigate('../../Requisition/Process/RequisitionViewSelected.cfm','process','','','POST','jobreq')
	  	w = #CLIENT.width# - 80;
	    h = #CLIENT.height# - 110;		
		ptoken.open("#SESSION.root#/component/analysis/CrossTabLaunch.cfm?box="+box+"&data=1&controlid="+control+"&format="+format, "factable", "unadorned:yes; edge:raised; status:yes; dialogHeight:"+h+"px; dialogWidth:"+w+"px; help:no; scroll:no; center:yes; resizable:yes");
	}	
		
    function mail2(mode,id) {
	     ptoken.open("#SESSION.root#/Tools/Mail/MailPrepareOpen.cfm?id="+mode+"&ID1="+id+"&ID0=#Parameter.RequisitionTemplate#","_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
    }	
	
	function processorg(org) {
	    selectedLines = document.getElementById('reqno').value		
			ptoken.navigate('SelectLines.cfm?mode=quick&mission=#url.mission#&period=#url.period#&orgunit='+org,'popending')
	} 
		
	function togglesel() {
	
		se = document.getElementsByName("RequisitionNo")
		btn = document.getElementById("selectall")
		
		if 	(btn.value == "Invert") {
			btn.value = "Select All" 
			$('.chk_requisition').prop( "checked", false );
			
		} else {
			btn.value = "Invert"
			$('.chk_requisition').prop( "checked", true );
		}	   
			
		 document.getElementById("reqno").value = ""
		 sel   = document.getElementById("reqno")	
		 req   = $('.chk_requisition');

		 cnt=0
		 while (req[cnt]) {
		    if (req[cnt].checked) {		  
			   if (sel.value==""){
			 	  sel.value = "'"+req[cnt].value+"'"
			   } else {
				   sel.value = sel.value+",'"+req[cnt].value+"'"
			   }
			}
			cnt++	
		 }		
		 
		 console.log(sel.value);		 		
		 document.getElementById('reqno').value = sel.value
		 ptoken.navigate('setJobOption.cfm','check','','','POST','jobreq')			
					
	}		
	
	function show(box) {
		itm = document.getElementById('add')
		itm.className = "Hide"
		itm = document.getElementById('exist')
		itm.className = "Hide"
		itm = document.getElementById(box)
		itm.className = "regular"
	}
	
	function selected(contractor) {
	    if (contractor == "") {
		   alert("Please select a vendor")
		} else {
		   ptoken.navigate('JobCreatePurchaseSelect.cfm?period=#url.period#&mission=#URL.mission#&contractor='+contractor,'selection')
		}
	}
		
	function selectedtraveler(traveler) {
	    if (traveler == "") {
		   alert("Please select a traveler")
		} else {
		   ptoken.navigate('JobCreatePurchaseSelect.cfm?period=#url.period#&mission=#URL.mission#&traveler='+traveler,'selection')
		}
	}


	function hl(itm,fld,reqno){		 
		 	 	 		 	
		 if (fld != false) {
			 $("##"+reqno+"_1").css("background-color","##eaeaea");
			 $("##"+reqno+"_2").css("background-color","##eaeaea");
			 $("##"+reqno+"_3").css("background-color","##eaeaea");
		 } else {
			 $("##"+reqno+"_1").css("background-color","transparent");
			 $("##"+reqno+"_2").css("background-color","transparent");
			 $("##"+reqno+"_3").css("background-color","transparent");
		 }
		  
		 document.getElementById("reqno").value = ""
		 sel   = document.getElementById("reqno")	
		 req   = $('.chk_requisition');

		 cnt=0
		 while (req[cnt]) {
		    if (req[cnt].checked) {		  
			   if (sel.value==""){
			   sel.value = "'"+req[cnt].value+"'"
			   } else {
			   sel.value = sel.value+",'"+req[cnt].value+"'"
			   }
			}
			cnt++	
		 }		
		 		 
		 document.getElementById('reqno').value = sel.value

		 ptoken.navigate('setJobOption.cfm','check','','','POST','jobreq')			
	}
	
	function search(itm) {
	 if (window.event.keyCode == "13") {		   
    	reqsearch(itm)	
		try {
		document.getElementById(itm).onkeyup=new Function("return false")  } catch(e) {} 		
     } 	
    }
 
	function reqsearch(pag) {		 
	 	 
	  if (pag == "undefined") {
	    pag  = document.getElementById('pagesel').value 
	  }	 
	 
      per   = document.getElementById('period').value   	 	 
	  unit  = document.getElementById('pending_unit').value	  
	  val   = document.getElementById('pending_search').value	 
	  ann   = document.getElementById('annotationsel').value		 	 
	  fun   = document.getElementById('fundsel').value		 
	  fund  = document.getElementById('fundcode').value			 		 
	  ptoken.navigate('SelectPending.cfm?mode=pending&page='+pag+'&annotationid='+ann+'&mission=#url.mission#&period='+per+'&search='+val+'&unit='+unit+'&fun='+fun+'&fund='+fund,'pending')
	}  	
	
	// function AddVacancy(pos,req) {
	// ret = window.showModalDialog("#SESSION.root#/Vactrack/Application/Document/DocumentEntryPosition.cfm?Mission=#URL.Mission#&ID1=" + pos + "&box=" + req + "&ts="+new Date().getTime(), window, "unadorned:yes; edge:raised; status:yes; dialogHeight:640px; dialogWidth:700px; help:no; scroll:yes; center:yes; resizable:yes");
	// ColdFusion.navigate('#session.root#/Procurement/Application/Requisition/Position/PositionFunding.cfm?reqid='+req,'pos'+req)			 		   			 	 	
	// }
  	
	</script>

</cfoutput>

<table width="100%" height="100%" style="padding-left:36px;padding-top:10px;padding-right:36px">

	<tr class="hide"><td id="check"></td></tr>
	
	<cfquery name="PeriodList" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_MissionPeriod
			WHERE  Mission = '#URL.Mission#'
			AND    Period IN (SELECT Period 
			                  FROM   Purchase.dbo.RequisitionLine 
							  WHERE  Mission = '#url.mission#')
	</cfquery>
	
	<cfif url.period eq "">
		  <cfset url.period = periodlist.period>
	</cfif>

	<tr>
		
		<td colspan="2" align="left" style="padding-left:8px;padding-right:8px">
		
		    <cfoutput>		
			   <input type="hidden" name="period" id="period" value="#url.period#">	
			</cfoutput>				
				   
		    <table class="formpadding">
			
				<tr>
				<td height="26">&nbsp;</td>
				
			    <cfoutput query="PeriodList">
					 				 				  
					  <td class="labellarge" style="padding-left:8px;padding-right:8px;cursor: pointer;<cfif url.period eq period>font-weight: bold;</cfif>" id="period_#period#" 
					      onclick="document.getElementById('period').value='#period#';ColdFusion.navigate('SelectBox.cfm?period=#Period#&mission=#url.mission#','main');clearrow();this.style.fontWeight='bold';"><font color="gray">#Period#</i></font>
					  </td>
					  				  
				</cfoutput> 
				
				 <td class="hide">
		
					 <input type   = "button" 
						   id      = "refreshbutton" 
						   class   = "button10g"
						   value   = "refresh"	   
						   name    = "refreshbutton"
						   onclick = "reqsearch(document.getElementById('pagesel').value)">
			   
			      </td>
				 			
				</tr>
			</table>
			
		</td>
		
	</tr>

<script>
	
	function clearrow(RowNum) {
		<cfoutput>
			<cfloop query="PeriodList">
			  se = document.getElementById("period_#period#")
	  		  se.style.fontWeight='normal'
		    </cfloop>
		</cfoutput>
	 
	 }

</script>

	<tr><td colspan="2" class="line"></td></tr>

	<cfajaximport tags="cfdiv">

	<tr>
	<td colspan="2" height="99%" width="99%" align="center" valign="top" id="main" style="padding-left:18px;padding-right:18px">
		<cfinclude template="SelectBox.cfm">
	</td>
	</tr>

</table>

<cf_screenbottom layout="webapp">

