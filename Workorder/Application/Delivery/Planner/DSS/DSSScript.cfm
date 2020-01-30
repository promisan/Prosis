<script>

 var markers = new Array();
 var path = new Array();
 var lines = new Array();
 var previous_color = '';
 
 var g_cluster = 0;
 var g_date    = 0; 
 
 function resetcluster(date,cluster) {
 	var r = confirm("Are you sure you want to restart the whole planning? All added/confirmed deliveries will be reseted");
	if (r == true) {
	   g_cluster = cluster
	   g_date    = date;

	   Prosis.busy('yes');
	   showProgressBar();	   
	   ColdFusion.navigate("Planner/DSS/WorkClusterReset.cfm?mission=<cfoutput>#url.mission#</cfoutput>&date="+date+"&step="+cluster,"dDContent",callBack_DSS);
	}
}

function setPlanDriver(psno,id,dte,step)
{
		ColdFusion.navigate("Planner/DSS/setDriver.cfm?date="+dte+"&psno="+psno+"&id="+id+"&step="+step+"&ts="+new Date().getTime(),"dResult");
}
 
function seeAll(date) {	
 	 ColdFusion.navigate("Planner/DSS/WorkClusterContent.cfm?mission=<cfoutput>#url.mission#</cfoutput>&step=final&date="+date+'&loadmode=refresh','dDContent');   
 }

function reloadMap() {
	reloadcontent('DSS');
}
  
 var callBack_DSS = function(){

 	Prosis.busy('no');
	
	hideProgressBar();
	 	
 	if (g_cluster==0) {
		all_refresh = 1;
		g_cluster=1;
	} else {
		all_refresh = 0;
	}
       
    if (all_refresh==1)
    	ColdFusion.navigate("Planner/DSS/WorkCluster.cfm?mission=<cfoutput>#url.mission#</cfoutput>&step="+g_cluster+'&date='+g_date+'&loadmode=','mapcontent');
    else
        ColdFusion.navigate("Planner/DSS/WorkClusterContent.cfm?mission=<cfoutput>#url.mission#</cfoutput>&step="+g_cluster+'&date='+g_date+'&loadmode=refresh','dDContent');       
 
 } 
 
 var callBack_Done = function(){
 	
 	Prosis.busy('no');
 	if (g_cluster==0)
 		g_cluster=1;   
	planning()
}  

function confirmcluster(date) {
	var r = confirm("Are you sure you want to confirm this planning? This operation will overwite any other planning for this date");
	if (r == true) {
	   g_date    = date;
	   Prosis.busy('yes')	   
	   ColdFusion.navigate("Planner/DSS/WorkClusterConfirm.cfm?date="+date,"dResult")	}	
} 
  
function deleteNodes(date,id,step) {
    g_cluster = step;
    g_date    = date; 	
	
	if ($('input:checkbox.nassigned:checked').length!=0)
	{
		var r = confirm("You are about to remove all checked deliveries/branches?");
			
		if (r == true) {
			$('input:checkbox.nassigned:checked').each(function () {
			       var node = (this.checked ? $(this).val() : "");
				   if (node!="") {
				   	   if (step!="")
					   		ColdFusion.navigate("Planner/DSS/WorkClusterRemove.cfm?date="+date+"&node="+node+"&id="+id+"&step="+step+"&ts="+new Date().getTime()+"&type=0","dResult");
					   else
					   		ColdFusion.navigate("Planner/DSS/WorkClusterRemove.cfm?date="+date+"&node="+node+"&id="+id+"&step="+step+"&ts="+new Date().getTime()+"&type=0","mapmetadata");
					   		
				   }						   
			  });			  
			  if (step!="")
			  	ColdFusion.navigate("Planner/DSS/WorkClusterContent.cfm?mission=<cfoutput>#url.mission#</cfoutput>&step="+step+'&date='+date+'&loadmode=refresh','dDContent');
			  else
			  {
			  	ColdFusion.navigate("Map/MapInsert.cfm?mission=<cfoutput>#url.mission#</cfoutput>&step="+step+'&date='+date+'&loadmode=refresh','mapmetadata');
			  }
		}
	} else {		
		alert('Please select a branch/delivery to be removed')
	}		 	
 }
 
 function reinstateNode(date,node,id,step) {
    g_cluster = step;
    g_date    = date; 	
	ColdFusion.navigate("Planner/DSS/WorkClusterReinstate.cfm?mission=<cfoutput>#url.mission#</cfoutput>&date="+date+"&node="+node+"&id="+id+"&step="+step,"dResult",callBack_DSS) 	
 } 

 function refresh_dss(date,step,mde) {
	ColdFusion.navigate("Planner/DSS/WorkCluster.cfm?mission=<cfoutput>#url.mission#</cfoutput>&step="+step+'&date='+date+'&loadmode='+mde,"mapcontent");		
 }  
 
 function goUp() {
		first_node = 0;
		$('input:checkbox.nassigned:checked').each(function () {
			if (first_node==0)
				first_node = $(this).val();			
		});
		first_row = $('#row_'+first_node).prev();
		if (first_row.attr("id") != 'rlisting')	{
			$('input:checkbox.nassigned:checked').each(function () {
		       var node = $(this).val();
			   if (node!="") {				
				   row = $('#row_'+node);
				   row.insertBefore(first_row);

			   }
		  	});		  	
		  doSorting();  			  		
		} 
 }
  
 function goDown() {
		last_node = 0;

		$('input:checkbox.nassigned:checked').each(function () {
			last_node = $(this).val();
		});
		last_row = $('#row_'+last_node).next();
		
		
		if (last_row.attr("id") != 'rtotal') {
			$('input:checkbox.nassigned:checked').each(function () {
			       var node = $(this).val();
				   if (node!="") {
				   		
					   row = $('#row_'+node);
					   row.insertAfter(last_row);
					   last_row = row;
					
				   }
			  });			  
			doSorting();  
	  }	 
 }

function doSorting() {
	
	var lorder = 0;
	$('.sorting_input').each(function () {
		   lorder = lorder + 1;
	       $(this).val(lorder);
	 });
	
	var json_value = $('#input_order').val();
	var json_obj  = Ext.JSON.decode(json_value);
	
	var aSorting = new Array();
	
    Ext.each(json_obj, function(vobj,value) {
	  if (vobj.listingorder) {
		aSorting[parseInt(vobj.listingorder)] = vobj.planorder;										
	  } 
	});			             

	var k = 0;
	var current_order = 1 ;
	
	$('.sorting_select').each(function () {
	       
	    if (!($(this).css('visibility') == 'hidden'))   
	    {  
	       var node = $(this).attr('id').replace("select_", "");
		   if ($("#branch_"+node).val()==0) {
			   k = k + 1;
		   }	 		   
		   newVal = aSorting[current_order];
	       $(this).val(newVal);	       
	       
	       if (k==2) {
	       	  k=0;
	       	  current_order=current_order + 1;
	       }
	    }	    
	 });	
} 

function processcluster(id,date,cluster) {	
     g_cluster = cluster
     g_date    = date
     Prosis.busy('yes');
	 if (id!='')
	 {     
		showProgressBar();
     	ColdFusion.navigate("Planner/DSS/WorkClusterSet.cfm?mission=<cfoutput>#url.mission#</cfoutput>&id="+id+"&date="+date+"&step="+cluster,"dResult",callBack_DSS,'','POST','mapform');
     }
     else
     {
     	ColdFusion.navigate("Planner/DSS/WorkClusterSet.cfm?mission=<cfoutput>#url.mission#</cfoutput>&id="+id+"&date="+date+"&step="+cluster,"dResult");
     }
             
 }

 var hideProgressBar = function()  { 
 	$('#rdProgressBar').show();
    ColdFusion.ProgressBar.hide('DSSProgressBar'); 
 }  

 var showProgressBar = function() { 
 	$('#rdProgressBar').hide();
    ColdFusion.ProgressBar.show("DSSProgressBar"); 
    ColdFusion.ProgressBar.start("DSSProgressBar");
 }  

function processcluster_add(date,id,step) { 	
    g_cluster = step;
    g_date    = date;
    $('#trAdding').hide();     	
	ColdFusion.navigate("Planner/DSS/WorkClusterAdd.cfm?mission=<cfoutput>#url.mission#</cfoutput>&date="+date+"&id="+id+"&step="+step,"dResult",callBack_DSS,'','POST','mapform') 	
}
 
function marknode(id,node,branch) {

       if ($('#assigned_'+node).is(':checked')) {      
            previous_color = $('#row_'+node).css('background-color'); 
       		$('#row_'+node).css('background-color','#FBEFF5');

            if (branch==1) {
              
           		var children = $('#input_assigned_'+node).val();
              	var obj = jQuery.parseJSON(children);

              	$.each(obj, function(key,value) {
                     if (value.node!='')  {
                           $('#assigned_'+value.node).prop('checked', true);
                           $('#row_'+value.node).css('background-color','#FBEFF5');
                     }
              	});           
              }
       } else {
       $('#row_'+node).css('background-color',previous_color);
              if (branch==1) {
              var children = $('#input_assigned_'+node).val();
              var obj = jQuery.parseJSON(children);

              $.each(obj, function(key,value) {

                     if (value.node!='') {
                     $('#row_'+value.node).css('background-color',previous_color);
                           $('#assigned_'+value.node).prop('checked', false);
                     }
              });    
              }
       }      
 }
 
function block_selection() {
	pList = $('#input_unit_scope').val();
	
	aList = pList.split(',');
	
	$(".selector").each(function() {
		var vOrg = $(this).attr('id').replace("select_", "");
		if ($.inArray(vOrg, aList)!=-1)	{
			$(this).prop("disabled", true);
			$(this).prop('checked', true);
			$('#rowselection_'+vOrg).animate({ opacity: 1});
		} else {//block
			$(this).prop('checked', false);
			$(this).prop("disabled", true);
			$('#rowselection_'+vOrg).animate({ opacity: 0.3});			
		}	  	
	});			
}



function hidePending() {
	$('#trAdding').hide();
}

function showPending(dte,id,step) {
	$('#trAdding').show();
	ColdFusion.navigate('<cfoutput>#session.root#</cfoutput>/workorder/application/Delivery/Planner/DSS/WorkClusterPending.cfm?mission=<cfoutput>#url.mission#</cfoutput>&date='+dte+'&id='+id+'&step='+step,'tdAdding');	
}

function unblock_selection() {
	$(".selector").each(function() {
		var vOrg = $(this).attr('id').replace("select_", "");
		$(this).attr("disabled", false);
		$('#rowselection_'+vOrg).animate({ opacity: 1});	  	
	});			
} 
 
</script>
