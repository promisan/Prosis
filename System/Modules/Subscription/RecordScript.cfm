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
<cfparam name="URL.view" default="1">

<cf_listingscript>

<cfoutput>

<script>

function recordedit(id1) {    
    ptoken.open('#SESSION.root#/System/Modules/Reports/RecordEdit.cfm?ID=' + id1, 'Edit');
}
  
function tooltip(name) {
      
    if (name == "") { 
	 self.status = '' 
	  } else {
     self.status = "Action: "+name;   	   
	}
	
   }
       
function report(id) {
    w = #CLIENT.width# - 56;
    h = #CLIENT.height# - 70;
	ptoken.open('#SESSION.root#/tools/cfreport/ReportLinkOpen.cfm?reportid=' + id, '_blank', 'left=10, top=10, width=' + w + ', height= ' + h + ', toolbar=no, status=no, scrollbars=yes, resizable=yes');
}

function reportabout(id) {
    w = #CLIENT.width# - 100;
    h = #CLIENT.height# - 140;
	window.open("#SESSION.root#/System/Modules/Subscription/About.cfm?id=" + id, "_blank", "left=30, top=30, width=" + w + ", height= " + h + ", menubar=no, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function schedule(id) {
    w = screen.availWidth-55
	h = screen.availHeight-92	   
	ptoken.open("#SESSION.root#/tools/cfreport/SubmenuReportView.cfm?height="+h+"&id=" + id + "&context=subscription", "_blank");	
}

function popular(st,id) {
    <cfif url.portal eq "0">
    ptoken.location('#SESSION.root#/System/Modules/Subscription/RecordPopular.cfm?portal=0&view=#URL.view#&st='+st+'&id='+id)
	<cfelse>
	ptoken.navigate('#SESSION.root#/System/Modules/Subscription/RecordPopular.cfm?portal=1&view=#URL.view#&st='+st+'&id='+id,'mylist')	
	</cfif>	
}

function purge() {
	if (confirm("Do you want to remove selected reports from your personal archive ?"))	{
		result.submit()
	}
}

function mail(id,path,sql) {
	if (confirm("Do you want to send this report to your eMail now ?")) {
	ptoken.navigate('#SESSION.root#/tools/cfreport/ReportSQL8.cfm?reportId=' + id + '&Mode=Instant','mail'+id)	
  	}
}

function reloadForm(view) {
   <cfif url.portal eq "0">
    ptoken.location('RecordListing.cfm?systemfunctionid=#url.systemfunctionid#&portal=0&view='+view);
	<cfelse>
	ptoken.navigate('#SESSION.root#/System/Modules/Subscription/RecordListing.cfm?systemfunctionid=#url.systemfunctionid#&portal=1&view='+view,'mylist');
	</cfif>  
}  
  
function more(id,act,row,content) {
	icM  = document.getElementById(row+"Min")
    icE  = document.getElementById(row+"Exp")
	se   = document.getElementById(row);
	if (content == "criteria") {
	url  = "#SESSION.root#/System/Modules/Subscription/Criteria.cfm?id="+id
	} else {
	url  = "#SESSION.root#/System/Modules/Subscription/ListingDistribution.cfm?row="+row+"&id="+id
	}
	
	if (se.className=="hide") {
	   	 icM.className = "regular";
	     icE.className = "hide";
		 se.className  = "regular";
		 ptoken.navigate(url,'i'+row)				 
	} else {
	   	 icM.className = "hide";
	     icE.className = "regular";
	   	 se.className  = "hide"
	 }
	 		
  }

</script>	

</cfoutput>