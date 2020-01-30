
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  label="Maintain Service Item" 
			  option="Maintain settings and service rates" 
			  scroll="Yes" 
			  layout="webapp" 
			  banner="gradient" 
			  jquery="Yes"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#"> 
			  
<cf_calendarscript>			  
			  
<cfajaximport tags="cfform">

<cfquery name="Get" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   ServiceItem
	WHERE  Code = '#URL.ID1#'
</cfquery>
 
<cfoutput>

<script language="JavaScript">

function validate() {
	document.editform.onsubmit() 
	if( _CF_error_messages.length == 0 ) {        
		ColdFusion.navigate('RecordSubmit.cfm?action=save','contentbox1','','','POST','editform')
	 }   
}	 

function editItemTopic(code,si) {
   ColdFusion.navigate("ServiceItemTopic.cfm?code="+code+"&ID1="+si+"&ts="+new Date().getTime(),'contentbox2');	
}

function deleteItemTopic(code,si) {
   ColdFusion.navigate("ServiceItemTopic.cfm?code="+code+"&ID1="+si+"&mode=delete&ts="+new Date().getTime(),'contentbox2');	
}

function saveItemTopic(code,si) {

   document.edittopicform.onsubmit() 
   if( _CF_error_messages.length == 0 ) {        
	   ColdFusion.navigate("ServiceItemTopicSubmit.cfm?code="+code+"&ID1="+si+"&ts="+new Date().getTime(),'contentbox2','','','POST','edittopicform');
  }
	
}

function showunit(serviceitem,unit) {
   ptoken.open("#SESSION.root#/workorder/maintenance/unitRate/ItemUnitEdit.cfm?ID1="+serviceitem+"&ID2="+unit,'_blank');
}

function showunitrefresh(serviceitem) {
   _cf_loadingtexthtml='';	
   ColdFusion.navigate('#SESSION.root#/workorder/maintenance/unitRate/ItemUnitListing.cfm?ID1='+serviceitem,'contentbox2')	
}

function showitemtab(mission, serviceitem, name) {
	
	try { ColdFusion.Window.destroy('mydialog',true) } catch(e) {}
	ColdFusion.Window.create('mydialog', 'Tab', '',{x:100,y:100,height:document.body.clientHeight-80,width:document.body.clientWidth-80,modal:true,resizable:false,center:true})    					
	ColdFusion.navigate('#SESSION.root#/workorder/maintenance/ServiceItemTab/ServiceItemTab.cfm?ID1='+mission+'&ID2='+serviceitem+'&ID3='+name,'mydialog') 	
     
   
}

function showitemtabrefresh(serviceitem) {
    ColdFusion.navigate('#SESSION.root#/workorder/maintenance/ServiceItemTab/ServiceItemTabListing.cfm?ID1='+serviceitem,'contentbox2')
}

function validatereq() {
	document.reqform.onsubmit() 
	if( _CF_error_messages.length == 0 ) {        	
		ColdFusion.navigate('ServiceItemRequestSubmit.cfm?id1=#url.id1#','contentbox2','','','POST','reqform')
	 }   
}	 

function ask() {
	if (confirm("Do you want to remove this service item ?")) {	
	ColdFusion.navigate('RecordSubmit.cfm?action=delete','contentbox1','','','POST','editform')
	}	
	return false	
}	

function addMissionPosting(serviceitem, mission) {

		var width = 700
		var height = 500      	
	    window.open("ServiceItemMissionPostingListing.cfm?ID1="+serviceitem+"&ID2="+mission+"&ts="+new Date().getTime(), window, "dialogWidth:" + width + "px; dialogHeight:" + height + "px; resizable:yes")  	
   		ColdFusion.navigate('Financials_MissionPosting.cfm?ID1='+serviceitem+'&ID2='+mission,'detailMissionPosting_' + mission)	 
		
}

</script>

</cfoutput>



<!--- edit form --->

<table height="100%" width="94%" class="formpadding" cellspacing="0" cellpadding="0" align="center">
	
	<cfoutput>
	
	<TR style="height:20px">
	 <TD class="labelmedium" width="100">Code:</TD>  
	 <TD class="labelmedium" width="70"><b>#get.Code#</TD>	
     <TD class="labelmedium">Description:</TD>
     <TD class="labelmedium"><b>#get.Description#</TD>
	 <td width="30%"></td>
	</TR>
	
	<tr><td height="1"></td></tr>
	<tr><td colspan="5" class="line"></td></tr>
	<tr><td colspan="5" height="100%">
	    <cf_divscroll>
    	<cfinclude template="RecordEditTab.cfm"> 
		</cf_divscroll>
	</td></tr>
	
    </cfoutput>
    	
</TABLE>



