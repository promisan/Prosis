<cfparam name="url.collectionid" default="">
<cfparam name="url.id" default="">

<cfquery name="Line" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT L.*
    FROM Schedule L
	<cfif url.id neq "">
	WHERE ScheduleId = '#URL.ID#'
	<cfelseif collectionid neq "">
	WHERE CollectionId = '#URL.Collectionid#'
	<cfelse>
	WHERE 1 = 0
	</cfif>
</cfquery>

<cfset url.id = line.scheduleid>

<cfinclude template="ScheduleScript.cfm">

<cfif URL.Id eq "">
    <cf_screentop height="100%" blur="yes" layout="webapp" html="yes" jquery="Yes" banner="gray" scroll="yes" label="Register Schedule" option="Define Batch routines to be performed on a regular basis">
<cfelse>
	<cf_screentop height="100%" blur="yes" html="yes" scroll="no" jquery="Yes" banner="blue" layout="webapp"  label="#Line.ScheduleName#" option="Maintain Batch routines to be performed on a regular basis" user="yes">
</cfif>	

<cfquery name="AppServer" 
datasource="AppsControl" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   ParameterSite
	WHERE  ServerLocation = 'Local'
</cfquery>

<cfoutput>

<script>

var isNN = (navigator.appName.indexOf("Netscape")!=-1);

function timetoggle(val) {

  if (val == "") {
    act = "regular"
  } else {
    act = "hide"
  }
  se = document.getElementsByName('timebox')
  cnt=0
  while (se[cnt]) {
    se[cnt].className = act
    cnt++
  }
}

function check() {			
	file = document.getElementById("ScheduleTemplate").value 
	ptoken.navigate('ScheduleTemplateCheck.cfm?ts='+new Date().getTime()+'&file='+file,'ifilecheck')	
}


function autoTab(input,len, e) {
	var keyCode = (isNN) ? e.which : e.keyCode; 
	var filter = (isNN) ? [0,8,9] : [0,8,9,16,17,18,37,38,39,40,46];
	if(input.value.length >= len && !containsElement(filter,keyCode)) {
	input.value = input.value.slice(0, len);
	input.form[(getIndex(input)+1) % input.form.length].focus();
	}
	function containsElement(arr, ele) {
	var found = false, index = 0;
	while(!found && index < arr.length)
	if(arr[index] == ele)
	found = true;
	else
	index++;
	return found;
	}
	function getIndex(input) {
	var index = -1, i = 0, found = false;
	while (i < input.form.length && index == -1)
	if (input.form[i] == input)index = i;
	else i++;
	return index;
	}
	return true;
}

function template(file) {
 	ptoken.open("TemplateDialog.cfm?file="+file, "Template", "left=40, top=40, width=860, height= 732, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function schedulelog(id,id1,act) {
 
    
	icM  = document.getElementById(id+"Min")
    icE  = document.getElementById(id+"Exp")
	se   = document.getElementById("log"+id);	
		
	if (id1 != "") { window.status = "deleting.." }
				 		 
	if (se.className == "hide" || act == "show") {	
	   	 icM.className = "regularH";
	     icE.className = "hide";
		 se.className  = "regularH";		
		 ptoken.navigate('ScheduleLog.cfm?id='+id+'&id1='+id1,'detail'+id)
	} else {
	   	 icM.className = "hide";
	     icE.className = "regularH";
    	 se.className  = "hide";
	 }
		 		
  }

</script>

</cfoutput>

<table width="100%" height="100%" cellspacing="0" cellpadding="0">

<cfif URL.Id eq "">

	<tr><td align="center" valign="top" style="padding-top:8px">

	<cfparam name="Status" default="1">
	
	<cfinclude template="RecordEditForm.cfm">

<cfelse>

   <cf_menuscript>
   
   <tr><td align="center" height="40" style="padding-top:4px">   
   
   <!--- top menu --->
				
		<table width="96%" border="0" align="center" cellspacing="0" cellpadding="0">		  		
						
			<cfset ht = "64">
			<cfset wd = "64">
					
			<tr>					
						
					<cf_menutab item       = "1" 
					            iconsrc    = "Scheduled-Requests.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								class      = "highlight1"
								name       = "Schedule">			
									
					<cf_menutab item       = "2" 
					            iconsrc    = "Script.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								name       = "Script file"
								source     = "TemplateDialog.cfm?id=#URL.ID#&mode=embed">
								
					<cf_menutab item       = "3" 
					            iconsrc    = "Logos/System/Log.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								name       = "Execution History"
								source     = "ScheduleLogView.cfm?id=#URL.ID#&mode=embed">			
				
				</tr>
		</table>

	</td>
	
	</tr>
 
	<tr><td height="1" colspan="1" class="linedotted"></td></tr>

	<tr><td height="100%" width="100%" valign="top">		
	
		<cf_divscroll>	
	
			<table cellspacing="0" width="100%" height="100%" cellpadding="0">
						
			<cf_menucontainer item="1" class="regular">
				<cfparam name="Status" default="1">	
				<cfinclude template="RecordEditForm.cfm">
			</cf_menucontainer>
			<cf_menucontainer item="2" class="hide">						
			<cf_menucontainer item="3" class="hide">
			
		</table>	
			
		</cf_divscroll>
			
		</td></tr>

</cfif>	

<tr class="hide">
<td colspan="2"><iframe name="result" id="result" width="100%" frameborder="0"></iframe></td></tr>

</table>
	
<cf_screenbottom layout="Webapp">
