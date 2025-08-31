<!--
    Copyright © 2025 Promisan B.V.

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
<cfparam name="url.portal" default="0">

<cfoutput>

<script language="JavaScript">
	
	function check() {
		 
		if (window.event.keyCode == "13")
			{	document.getElementById("searchicon").click() }						
    }
				
	function drillboxopen() {
		ColdFusion.Window.create('adddetail','Workorder #timeformat(now(),'HH:MM:SS')#','',{x:100,y:100,height:700,width:700,resizable:true,modal:true,center:true})
	}
	
	function addrequest(mis) {
	   window.open("#SESSION.root#/Warehouse/Application/StockOrder/Request/Create/RequestEntry.cfm?mission="+mis,"request","left=30, top=30, width=850, height=850, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
	}
		
	function showrequest(mis,whs,status,tpe,mid) {
		ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Request/Listing/RequestListing.cfm?mission='+mis+'&warehouse='+whs+'&status='+status+'&requesttype='+tpe+'&systemfunctionid='+mid,'detail',mycallBack,myerrorhandler)
	}
	
	function findrequest(mis,mid) {
		ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Request/Listing/RequestListing.cfm?mission='+mis+'&systemfunctionid='+mid,'detail',mycallBack,myerrorhandler)
	}
	
	function showrequesttask(mis,whs,status,tpe,mid,mde,src,cat) {	  
		ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Request/Listing/RequestTaskListing.cfm?mission='+mis+'&warehouse='+whs+'&status='+status+'&taskstatus='+tpe+'&systemfunctionid='+mid+'&shiptomode='+mde+'&source='+src+'&category='+cat,'detail',mycallBack,myerrorhandler)
	}
		
	function mycallBack(text) { }
	  	var myerrorhandler = function(errorCode,errorMessage){
		alert("[In Error Handler]" + "\n\n" + "Error Code: " + errorCode + "\n\n" + "Error Message: " + errorMessage);
	}	
	
	function printme(id) {
	    window.open("#SESSION.root#/Tools/Mail/MailPrepareOpen.cfm?id="+id+"&ID1="+id+"&ID0=/warehouse/inquiry/print/TaskView/Task.cfr","_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
	}	
	
</script>	

</cfoutput>
