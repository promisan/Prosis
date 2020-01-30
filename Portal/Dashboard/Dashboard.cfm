
<cfoutput>

<cfinclude template="DashboardGadgetScript.cfm">
  
<cfajaximport tags="cfwindow,cfform,cfchart">

<cf_screentop height="100%" html="No" jQuery="Yes" Band="No" scroll="Yes" title="#session.welcome# Presenter">

<cf_layoutscript>

<script>
		
	// function mycallBack(text) { }
		
	// var myerrorhandler = function(errorCode,errorMessage){
	//		alert("[In Error Handler]" + "\n\n" + "Error Code: " + errorCode + "\n\n" + "Error Message: " + errorMessage);
	// }	
	
	// function submitForm(frm,url) {
	//	ColdFusion.Ajax.submitForm(frm, url, mycallBack,myerrorhandler);
	//	history.go()
	// }
			
	function setting() {	
	    ColdFusion.Window.create('setting', 'Settings', '',{x:100,y:100,height:500,width:600,resizable:false,modal:true,center:true})		
		ColdFusion.Window.show('setting')		
		ColdFusion.navigate('DashBoardSetting.cfm','setting',mycallBack,myerrorhandler)		
	}
	
	function toggle(opt) {
	
		if (window.innerHeight){ 
			h = window.innerHeight 
		}else{ 
		    h = document.body.clientHeight
		} 
		   
		if (opt == "dashboard") {
		    window.location = "Dashboard.cfm?h="+h	 		  
		} else {
		    window.location = "DashboardFavorite.cfm?h="+h	  
		}

	}
	
</script>

</cfoutput>
	
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<tr class="hidden"><td id="framescontent"></td></tr>
<tr>
	<td align="center" 
	    width="100%" 
		height="100%" 
		id="content" 
		align="center" 
		style="border:0px;padding:0px">	
	   	<cfinclude template="DashboardFrames.cfm">				
	</td>
</tr>
</table>

	

